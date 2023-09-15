//
//  ApiKeys.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

import UIKit

///API Keys
enum ApiKeys {
    case header(ApiHeaderKeysValue)
    case encrypt(EncryptionKeys)
    case respsone(ApiResponseKey)
    case statusCode(ApiStatusCode)
    
    var value: String {
        switch self {
        case .header(let key):
            return key.rawValue
        case .encrypt(let key):
            return key.rawValue
        case .respsone(let key):
            return key.rawValue
        case .statusCode(let key):
            return key.rawValue
        }
    }
}

/// Sets API key values
extension ApiKeys {
    internal enum EncryptionKeys: String {
        case secretKey = "9Ddyaf6rfywpiTvTiax2iq6ykKpaxgJ6"
        case iv = "9Ddyaf6rfywpiTvT"
    }
    
    //MARK:- HeaderKeys
    internal enum ApiHeaderKeysValue: String {
        case apiKey = "api-key"
        case apiKeyValue = "6939CB32CA9C1"
        
        case tokenKey = "token"
        case signUptoken = "signup_token"
        
        case acceptLanguageKey = "accept-language"
        case acceptLanguageValue = "en"
        
//        case acceptLanguageKey = "Accept"
//        case acceptLanguageValue = "application/json"
        
        case contentTypeKey = "content-type"
        case contentTypeApplicationForm = "application/x-www-form-urlencoded"
        case contentTypeApplicationTextPlain = "text/plain"
    }
    
    //MARK:- API Key Constant
    internal enum ApiResponseKey: String {
        case data                               = "data"
        case message                            = "message"
        case code                               = "code"
        case userToken                          = "token"
    }
    
    //MARK:- APIStatusCodeEnum
    internal enum ApiStatusCode: String {
        ///Invalid or fail response
        case invalidOrFail              = "0"
        
        ///Sucess response
        case success                    = "1"
        
        ///Empty data record
        case emptyData                  = "2"
        
        ///Inactive account
        case inactiveAccount            = "3"
        
        ///OTP not verify
        case otpVerify                  = "4"
        
        ///Email not verify
        case emailVerify                = "5"
        
        ///Force app update alert
        case forceUpdateApp             = "6"
        
        ///Simple app update alert
        case underMaintenance           = "7"
        
        ///Simple app under Maintenance
        case optionalUpdateApp          = "8"
        
        ///User not registerd with social logins
        case socialIdNotRegister        = "11"
        
        case userAlreadyRegistered      = "12"
        
        ///User session expire
        case userSessionExpire          = "-1"
        
        ///Unknown
        case unknown                    = "1000"
    }
}
