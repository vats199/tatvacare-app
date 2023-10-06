//
//  UserDefaultPropertyWrapper.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import Foundation


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}

struct UserDefaultsConfig {
    @UserDefault(UserDefaults.Keys.isShowCoachmark, defaultValue: true)
    static var isShowCoachmark: Bool
    
    @UserDefault(UserDefaults.Keys.isShowTutorial, defaultValue: true)
    static var isShowTutorial: Bool
    
    @UserDefault(UserDefaults.Keys.isShowHealthPermission, defaultValue: false)
    static var isShowHealthPermission: Bool
    
    @UserDefault(UserDefaults.Keys.authorization, defaultValue: false)
    static var isAuthorization: Bool
    
    @UserDefault(UserDefaults.Keys.accessToken, defaultValue: "")
    static var accessToken: String
    
    @UserDefault(UserDefaults.Keys.authorization, defaultValue: false)
    static var authorization: Bool
    
    @UserDefault(UserDefaults.Keys.rememberMe, defaultValue: false)
    static var rememberMe: Bool
    
    @UserDefault(UserDefaults.Keys.mobile, defaultValue: "")
    static var mobile: String
    
    @UserDefault(UserDefaults.Keys.password, defaultValue: "")
    static var password: String
    
    @UserDefault(UserDefaults.Keys.languageId, defaultValue: "")
    static var languageId: String
    
    @UserDefault(UserDefaults.Keys.badgeCount, defaultValue: 0)
    static var badgeCount: Int
    
    @UserDefault(UserDefaults.Keys.language_page, defaultValue: "Y")
    static var language_page: String
    
    @UserDefault(UserDefaults.Keys.accountFor, defaultValue: 0)
    static var kUserStep: Int
    
    @UserDefault(UserDefaults.Keys.kLetBigGIF, defaultValue: "")
    static var kLetBigGIF: String
    
    @UserDefault(UserDefaults.Keys.kDoctorAccessCode, defaultValue: "")
    static var kDoctorAccessCode: String
    
    @UserDefault(UserDefaults.Keys.kAccessCode, defaultValue: "")
    static var kAccessCode: String
    
    @UserDefault(UserDefaults.Keys.kAccessCode, defaultValue: "")
    static var kAppVersion: String
        
    /*@UserDefault(UserDefaults.Keys.accountFor, defaultValue: false)
    static var accountFor: Bool
    
    @UserDefault(UserDefaults.Keys.accessCode, defaultValue: false)
    static var accessCode: Bool
    
    @UserDefault(UserDefaults.Keys.patientDetails, defaultValue: false)
    static var patientDetails: Bool*/
}
