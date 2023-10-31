//
//  MoyaHelper.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

import UIKit
import QorumLogs
import Moya
import Alamofire

/// API Environment. Sets base URL of API as per environment
enum APIEnvironment {
    case live
    case uat
    case local
    case localhost
    
    /// Get base url as per given environment state
    /// - Parameter state: Environment state. e.g. live, local, localhost
    /// - Returns: Return IP address and API base url
    /// //http://20.204.236.180:8080/api/v1
    static func getUrl(state : APIEnvironment) -> (ip : String, baseurl : String) {
        switch state {
        case .live:
            return (ip : "https://api.mytatva.in",
                    baseurl : "https://api.mytatva.in/api/v7/")
        case .uat:
            return (ip : "https://api-uat.mytatva.in",
                    baseurl : "https://api-uat.mytatva.in/api/v7/")
        case .local:
            return (ip : "https://api.mytatvadev.in",
                    baseurl : "https://api.mytatvadev.in/api/v6/")
        case .localhost:
            return (ip : "http://3.7.8.99",
                    baseurl : "http://3.7.8.99:9011/api/v1/")
        }
    }
}

/// NetworkManagerr
struct NetworkManager  {
    let provider = MoyaProvider<ApiManager>(plugins: [NetworkLoggerPlugin()])
    static let environment : APIEnvironment = .uat
}

/// Moya String Helper Extenstions
extension String: Moya.ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
    /// To convert string to encrypted string
    /// - Returns: Return encrypted string
    func encryptData() -> String {
        return CryptLib().encryptPlainText(with: self, key: ApiKeys.encrypt(.secretKey).value, iv: ApiKeys.encrypt(.iv).value)
    }
    
    /// To convert encrypted string to decrypted string
    /// - Returns: Return decrypted string
    func decryptData() -> String {
        return JSON(CryptLib().decryptCipherText(with: self, key: ApiKeys.encrypt(.secretKey).value, iv: ApiKeys.encrypt(.iv).value) as Any).stringValue
    }
    
    /// To create string to sixteen bit IV
    /// - Returns: Return sixteen bit IV string
    func createSixteenBitIV() -> String {
        guard let strIV = ApiKeys.encrypt(.iv).value.data(using: String.Encoding.utf8) else {
            return ""
        }
        //    let strIVBytes:[UInt8] = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(strIV!.bytes), count: 16))
        let strIVBytes: [UInt8] = strIV.withUnsafeBytes {
            $0.load(as: [UInt8].self)
//            [UInt8](UnsafeBufferPointer(start: $0, count: 16))
        }
        
        return String(bytes: strIVBytes, encoding: String.Encoding.utf8)!
    }
    
    /// To convert string to key - value dictionary
    /// - Returns: Return Key - Value dictionary
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    ///Return URL string with adding percent encoding.
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    ///Return utf8 data from string.
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

/// Response
extension Response {
    public func filterApiStatusCodes<R: RangeExpression>(statusCodes: R) throws -> Response where R.Bound == Int {
        guard statusCodes.contains(statusCode) else {
            throw MoyaError.statusCode(self)
        }
        return self
    }
}

/// WebService
/// Create and return almofire session manager
class WebService {
    // session manager
    static func manager() -> Alamofire.Session {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 120//60 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 120//60 // as seconds, you can set your resource timeout
        configuration.urlCache = nil
        let manager = Alamofire.Session(configuration: configuration)
        return manager
    }
    
    // request adpater to add default http header parameter
    private class CustomRequestAdapter: RequestAdapter {
        func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void) {
        }
    }
}

/// Response model type
enum ResponseModelType {
    case dictonary, array
}

//MARK: Helping Methods
extension ApiManager {
    
    /// Print debug API request.
    /// - Parameter parameters: Dictionary request parameter
    func manageDebugRequest(parameters: [String:Any]?) {
        let encyptedData = JSON(debugCryptoLib.encryptPlainText(with: JSON.init(rawValue: parameters as Any)?.rawString(), key: ApiKeys.encrypt(.secretKey).value, iv: ApiKeys.encrypt(.iv).value) as Any).stringValue
        QLPlusLine()
        QL1("\n==============================Parameters==============================\n")
        QL1(JSON(parameters as Any).dictionaryValue)
        QL1("\n==================================URL=================================\n")
        QL1(baseURL.appendingPathComponent(self.path).absoluteString)
        QL1("\n==============================Encrypted Parameters==============================\n")
        QL1(encyptedData)
        QLPlusLine()
    }
    
    /// Print debug API response with encrypted and decrypted formate.
    /// - Parameters:
    ///   - encryptedString: Encrypted respons string
    ///   - responseDic: Response JSON dictionary
    func manageDebugResponse(encryptedString: String, responseDic: JSON) {
        QLPlusLine()
        QL1("\n==============================Encrypted Response==============================\n")
        QL1(encryptedString)
        QL1("\n==============================Decrypted Response==============================\n")
        QL1(responseDic)
        QLPlusLine()
    }
    
    /// Print and show API error message
    /// - Parameters:
    ///   - apiName: API name
    ///   - error: API Error
    ///   - isShowAlert: Flag for show API error alert. Default false.
    func manageErrors(apiName: String, error: Error, isShowAlert: Bool = false) {
        QL4("Error \(error.localizedDescription) in method \(apiName)")
        if isShowAlert {
            //FIXME: Show Error Alert here
        }
    }
    
    /// Add loader when request make.
    func addLoader() {
        AppLoader.shared.addLoader()
    }
    
    /// Remove loader after request end with responce.
    func removeLoader() {
        AppLoader.shared.removeLoader()
    }
    
    /// Logout user from app if user session expired
    func logout() {
        UIApplication.shared.forceLogOut()
    }
    
    /// Cancel all request for given end point
    /// - Parameter endpoint: API end point for cancel request
    func cancelRequest(endpoint : ApiEndPoints)  {
        if let task = (self.requests.filter{ $0.endPoint.methodName == endpoint.methodName }).first{
            task.cancellable.cancel()
        }
    }
}
                                                                                                 
