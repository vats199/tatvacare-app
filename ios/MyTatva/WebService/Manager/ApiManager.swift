////
////  NewApiManager.swift
////
////
////  Created by  on 18/12/20.
////
//
import Foundation
import UIKit
import Moya
import Alamofire

//------------------------------------------------------
//MARK:- APIEnvironment

class ApiManager : TargetType {

    var path: String = ""

    static var shared = ApiManager()

    let provider = MoyaProvider<ApiManager>()//(manager : WebService.manager())

    var sampleData: Data {
        return "Half measures are as bad as nothing at all.".utf8Encoded
    }

    var requests : [(endPoint : ApiEndPoints , cancellable : Moya.Cancellable)] = []

    var headers: [String : String]?

    var environmentBaseURL : String {
        return APIEnvironment.getUrl(state: NetworkManager.environment).baseurl
    }

    // MARK: - baseURL
    var baseURL: URL {

        guard let url  = URL(string: environmentBaseURL) else{
            fatalError("base url could not be configured")
        }
        return url
    }

    //  var path : String = ""

    var method: Moya.Method = .post

    // MARK: - parameterEncoding
    var parameterEncoding: ParameterEncoding {
       return URLEncoding.default
    }

    // MARK: - task
    var task: Task {
        let jsonData = try? JSONSerialization.data(withJSONObject: self.parameters!, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let encryptedData  : String = (self.stringParam ?? "").isEmpty ? jsonString.encryptData() : self.stringParam!.encryptData()
        return .requestParameters(parameters: [:], encoding: self.method == . post ? encryptedData as ParameterEncoding : URLEncoding.default)
    }

    var parameters: [String: Any]?

    var stringParam: String?
    
    let debugCryptoLib = CryptLib()

    /// Set Headers
    func setHeaders()  {

        var headersToSend : [String : String] = [:]
        headersToSend[ApiKeys.header(.apiKey).value] = ApiKeys.header(.apiKeyValue).value.encryptData()
        
        headersToSend[ApiKeys.header(.contentTypeKey).value] = ApiKeys.header(.contentTypeApplicationTextPlain).value

        let dateFormatter                   = DateFormatter()
        dateFormatter.dateFormat            = DateTimeFormaterEnum.yyyymmdd.rawValue
        dateFormatter.timeZone              = .current
        let strDate                         = dateFormatter.string(from: Date())
        headersToSend["current_datetime"]   = strDate
        
        if self.method == .put {
            headersToSend[ApiKeys.header(.contentTypeKey).value] = ApiKeys.header(.contentTypeApplicationForm).value
        }

        headersToSend[ApiKeys.header(.acceptLanguageKey).value] = "en"
        
        let arryPath = [ApiEndPoints.patient(.update_signup_for).methodName,
                        ApiEndPoints.patient(.update_access_code).methodName,
                        ApiEndPoints.patient(.medical_condition_group_list).methodName,
                        ApiEndPoints.patient(.register).methodName,
                        ApiEndPoints.patient(.register_temp_patient_profile).methodName,
                        ApiEndPoints.patient(.verify_doctor_access_code).methodName
        ]
                
        if arryPath.contains(self.path) {
            headersToSend[ApiKeys.header(.signUptoken).value] = UserDefaultsConfig.accessToken
        } else {
            if let token = UserModel.accessToken {
                headersToSend[ApiKeys.header(.tokenKey).value] = token//.encryptData()
            }
        }
        
       // headersToSend[ApiKeys.header(.acceptLanguageKey).value] = ApiKeys.header(.acceptLanguageValue).value
//        if let appLanguage = GFunction.shared.getLanguage() {
//            switch appLanguage {
//
//            case AppLanguage.English.rawValue:
//                headersToSend["accept-language"]           = appLanguage
//                break
//
//            case AppLanguage.Arabic.rawValue:
//                headersToSend["accept-language"]           = appLanguage
//                break
//
//            case  AppLanguage.Urdu.rawValue:
//                headersToSend["accept-language"]           = appLanguage
//                break
//
//            case  AppLanguage.Hindi.rawValue:
//                headersToSend["accept-language"]           = appLanguage
//                break
//
//            case  AppLanguage.Bengali.rawValue:
//                headersToSend["accept-language"]           = appLanguage
//                break
//
//            default:
//                headersToSend["accept-language"]           = "en"
//                break
//            }
//        }

        self.headers = headersToSend

        print("🔲🔲🔲🔲🔲🔲🔲🔲 HEADER: \(JSON(self.headers!)) 🔲🔲🔲🔲🔲🔲🔲🔲")
    }

    //MARK: ----------------------- Api calling Methods -----------------------
    func makeRequest(method: ApiEndPoints,
                 methodType: HTTPMethod = .post,
                 parameter : Dictionary<String,Any>?,
                 stringParam: String? = nil,
                 withErrorAlert isErrorAlert : Bool = true,
                 withLoader isLoader : Bool = true,
                 withdebugLog isDebug : Bool = true,
                 withBlock completion :((Swift.Result<DataResult,Error>) -> Void)?) {


        //Assign Value to Moya Parameters
        self.path = method.methodName
        self.parameters = parameter
        self.stringParam = stringParam
        self.method = methodType

        self.setHeaders()

        if isLoader {
            self.addLoader()
        }

//        DispatchQueue.main.async {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }

        if isDebug {
            debugPrint("🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲 Call URL 🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲")
            debugPrint(self.baseURL.appendingPathComponent(self.path))
            print("🔲🔲🔲🔲🔲🔲🔲🔲 PARAMETER: \(JSON(self.parameters!)) 🔲🔲🔲🔲🔲🔲🔲🔲")
            //self.manageDebugRequest(parameters: self.parameters)
        }

        let request = provider.request(self) { (result) in

            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            if isLoader {
                self.removeLoader()
            }

            switch result {

            case .success(let response):

                DispatchQueue.main.async {
                    if response.statusCode == 401 {
                        UIApplication.shared.forceLogOut()
                        completion?(.failure(ApiCustomError.sessionExpire))
                    }

                    do {
                        guard let res = try response.mapJSON() as? String else {
                            return
                        }


                        var code = ApiKeys.ApiStatusCode.invalidOrFail

                        let resDic  = JSON(res.decryptData().convertToDictionary() as Any)

                        if isDebug {
                            debugPrint("🟧🟧🟧🟧🟧🟧🟧 Response Data of URL \(response.request!.url!.absoluteString) 🟧🟧🟧🟧🟧🟧🟧")
                            debugPrint(resDic)
                            //self.manageDebugResponse(encryptedString: res, responseDic: resDic)
                        }

                        if let codeint = ApiKeys.ApiStatusCode.init(rawValue: JSON(resDic["code"].intValue).stringValue) {
                            code = codeint
                        }

                        let responseData = DataResult(data: resDic[ApiKeys.respsone(.data).value],
                                                      httpCode: response.statusCode,
                                                      apiCode: code,
                                                      message: resDic[ApiKeys.respsone(.message).value].stringValue,
                                                      response: resDic)

                        

                        completion?(.success(responseData))

                    } catch {
                        //completion?(.failure(ApiCustomError.invalidData))
                        
                        let err = NSError(domain:"",
                                            code: response.statusCode,
                                            userInfo:[ NSLocalizedDescriptionKey: "\(response.statusCode) : Server Issue"]) as Error
                        
                        completion?(.failure(err))
                        self.manageErrors(apiName: method.methodName, error: error, isShowAlert: false)
                    }
                }
                
                break

            case .failure(let error):

                let err = NSError(domain:"",
                                  code: error.errorCode,
                                    userInfo:[ NSLocalizedDescriptionKey: "Connection failed: \(error.localizedDescription)"]) as Error
                
                if (error as NSError).code == NSURLErrorCancelled {
                    // Manage cancellation here
                    self.manageErrors(apiName: method.methodName, error: error, isShowAlert: false)
                    
                    completion?(.failure(err))
                    return
                }
                else if (error as NSError).code == 6 {
                    
                    var errorUpdate = err
                    if error.localizedDescription.lowercased()
                        .contains("offline".lowercased()) ||
                        error.localizedDescription.lowercased()
                            .contains("A data connection is not currently allowed".lowercased()){
                        
                        // No Internet connection
                        errorUpdate = NSError(domain:"",
                                          code: error.errorCode,
                                            userInfo:[ NSLocalizedDescriptionKey: AppMessages.internetConnectionMsg]) as Error
                    }
                    
                    self.manageErrors(apiName: method.methodName, error: errorUpdate, isShowAlert: false)
                    
                    completion?(.failure(errorUpdate))
                    return
                }
                
                self.manageErrors(apiName: method.methodName, error: error, isShowAlert: isErrorAlert)
                completion?(.failure(err))
                break
            }
        }

        requests.append((method,request))
    }

    //MARK: ----------------------- Api calling Methods with model -----------------------
    func makeRequestWithModel<T: Mappable>(method: ApiEndPoints,
                                           modelType : T.Type,
                                           methodType: HTTPMethod = .post,
                                           responseModelType: ResponseModelType = .dictonary,
                                           parameter: Dictionary<String,Any>?,
                                           withErrorAlert isErrorAlert: Bool = true,
                                           withLoader isLoader: Bool = true,
                                           withdebugLog isDebug: Bool = true,
                                           withBlock completion: ((Swift.Result<DataResultModel<T>,Error>) -> Void)?)  {

        //Assign Value to Moya Parameters
        self.path           = method.methodName
        self.parameters     = parameter
        self.method         = methodType
        
        setHeaders()

        if isLoader {
            self.addLoader()
        }

        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }

        if isDebug {
            self.manageDebugRequest(parameters: self.parameters)
        }

        let request = provider.request(self) { (result) in

            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            if isLoader {
                //FIXME: Remove Loader
                self.removeLoader()
            }

            switch result {

            case .success(let response):

                if response.statusCode == 401 {
                    self.logout()
                    return
                }

                do {
                    guard let res = try response.mapJSON() as? String else {
                        return
                    }

                    var code = ApiKeys.ApiStatusCode.invalidOrFail

                    let resDic  = JSON(res.decryptData().convertToDictionary() as Any)

                    if isDebug {
                        self.manageDebugResponse(encryptedString: res, responseDic: resDic)
                    }



                    if let codeint = ApiKeys.ApiStatusCode.init(rawValue: resDic[ApiKeys.respsone(.code).value].stringValue) {
                        code = codeint
                    }
                    
                    var responseData = DataResultModel<T>.init()

                    switch responseModelType {

                    case .dictonary:
                        responseData.data = modelType.init(fromJson: resDic[ApiKeys.respsone(.data).value])
                        break
                    case .array:
                        responseData.data = modelType.init(fromJson: resDic[ApiKeys.respsone(.data).value]["result"]) // If response["data"] is not array type then
//                        responseData.data = modelType.init(fromJson: resDic[ApiKeys.respsone(.kData).value]) // if data has direct array value use this
                        break
                    }

                    responseData.message = resDic[ApiKeys.respsone(.message).value].stringValue
                    responseData.apiCode = code
                    responseData.httpCode = response.statusCode
                    responseData.response = resDic
                    completion?(.success(responseData))

                } catch let error {
                    self.manageErrors(apiName: method.methodName, error: error, isShowAlert: false)
                }
                break

            case .failure(let error):

               let err = NSError(domain:"",
                                  code: error.errorCode,
                                    userInfo:[ NSLocalizedDescriptionKey: "Connection failed: \(error.localizedDescription)"]) as Error
                
                if (error as NSError).code == NSURLErrorCancelled {
                    // Manage cancellation here
                    self.manageErrors(apiName: method.methodName, error: error, isShowAlert: false)
                    
                    completion?(.failure(err))
                    return
                }
                else if (error as NSError).code == 6 {
                    
                    var errorUpdate = err
                    if error.localizedDescription.lowercased()
                        .contains("offline".lowercased()) ||
                        error.localizedDescription.lowercased()
                            .contains("A data connection is not currently allowed".lowercased()){
                        
                        // No Internet connection
                        errorUpdate = NSError(domain:"",
                                          code: error.errorCode,
                                            userInfo:[ NSLocalizedDescriptionKey: AppMessages.internetConnectionMsg]) as Error
                    }
                    
                    self.manageErrors(apiName: method.methodName, error: errorUpdate, isShowAlert: false)
                    
                    completion?(.failure(errorUpdate))
                    return
                }

                self.manageErrors(apiName: method.methodName, error: error, isShowAlert: isErrorAlert)
                completion?(.failure(error))
                break

            }

        }

        requests.append((method,request))
    }
}

//extension ApiManager {
//
//    func mapJSONData(failsOnEmptyData: Bool = true) throws -> Any {
//        do {
//            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//        } catch {
//            if data.count < 1 && !failsOnEmptyData {
//                return NSNull()
//            }
//            throw MoyaError.jsonMapping(self)
//        }
//    }
//}
//
//
//
//
//
//
//
