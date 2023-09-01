//
//  UserDefaults+Extension.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//


import Foundation

//MARK: User defaults keys
extension UserDefaults {
    public enum Keys {
        static var authorization            = "authorization" //isLogin
        static let accessToken              = "accessToken"
        static let currentUser              = "currentUser"
        static let appleLanguages           = "AppleLanguages"
        static let deviceToken              = "deviceToken"
        static let deviceTokenData          = "deviceTokenData"
        static let isShowTutorial           = "showTutorial"
        static let isShowCoachmark          = "showCoachmark"
        static let isShowHealthPermission   = "isShowHealthPermission"
        static let reviewWorthyActionCount  = "reviewWorthyActionCount"
        static var rememberMe               = "rememberMe"
        static var mobile                   = "mobile"
        static var password                 = "password"
        static var languageId               = "languageId"
        static var isBiometricOn            = "isBiometricOn"
        static var badgeCount               = "badgeCount"
        static let language_page            = "language_page"
        static let accountFor               = "accountFor"
        static let accessCode               = "accessCode"
        static let patientDetails           = "patientDetails"
        static let kUserStep                = "kUserStep"
        static let kLetBigGIF               = "kLetBigGIF"
        static let kDoctorAccessCode        = "kDoctorAccessCode"
        static let kAccessCode              = "kAccessCode"
    }
}

extension UserDefaults {
    func decode<T : Codable>(for type : T.Type, using key : String) -> T? {
        let defaults = UserDefaults.standard
        guard let data = defaults.object(forKey: key) as? Data else {return nil}
        let decodedObject = try? PropertyListDecoder().decode(type, from: data)
        return decodedObject
    }
    
    func encode<T : Codable>(for type : T, using key : String) {
        let defaults = UserDefaults.standard
        let encodedData = try? PropertyListEncoder().encode(type)
        defaults.set(encodedData, forKey: key)
        defaults.synchronize()
    }
}
