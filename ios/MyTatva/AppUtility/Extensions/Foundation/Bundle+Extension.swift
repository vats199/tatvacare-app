//
//  GExtension+UIDevice.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var displayName: String {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ??
            Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "MyTatva"
    }
    
    public var shortVersion: String {
        if let result = infoDictionary?["CFBundleShortVersionString"] as? String {
            return result
        } else {
            assert(false)
            return ""
        }
    }
    
    public var buildVersion: String {
        if let result = infoDictionary?["CFBundleVersion"] as? String {
            return result
        } else {
            assert(false)
            return ""
        }
    }
    
    public var displayFullVersion: String {
        return "v\(shortVersion) (\(buildVersion))"
    }
    
    //TODO: Use
    //    Bundle.main.releaseVersionNumber
    //    Bundle.main.buildVersionNumber
    
    //MARK:- Bundle Localization
    
    func getBundleName() -> Bundle {
        if let languageArray = UserDefaults.standard.value(forKey: UserDefaults.Keys.appleLanguages) as? Array<String>,
            let languageObj = languageArray.first, let language = AppLanguages(rawValue: String(languageObj.prefix(2))) {
            
            let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
            let bundle = Bundle(path: path!)
            return bundle!
            
        } else {
            let path = Bundle.main.path(forResource: "Base", ofType: "lproj")
            let bundle = Bundle(path: path!)
            return bundle!
        }
    }
    
    func updateWindow() {
        if let languageArray = UserDefaults.standard.value(forKey: UserDefaults.Keys.appleLanguages) as? Array<String>, let languageObj = languageArray.first, let language = AppLanguages(rawValue: String(languageObj.prefix(2))) {
            
            switch language {
            case .arabic:
                //                UITextField.appearance().semanticContentAttribute = .forceRightToLeft
                UISearchBar.appearance().semanticContentAttribute = .forceRightToLeft
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                UIView.userInterfaceLayoutDirection(for: .forceRightToLeft)
                UIView().semanticContentAttribute = .forceRightToLeft
            default:
                //                UITextField.appearance().semanticContentAttribute = .forceLeftToRight
                UISearchBar.appearance().semanticContentAttribute = .forceLeftToRight
                UIView().semanticContentAttribute = .forceLeftToRight
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UIView.userInterfaceLayoutDirection(for: .forceLeftToRight)
            }
        }
        
        DispatchQueue.main.async {
            UIButton.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitle("Cancel".localized, for: .normal)
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized
            UIApplication.shared.manageLogin()
        }
    }
    
    var currentAppLanguage: AppLanguages {
        if let languageArray = UserDefaults.standard.value(forKey: UserDefaults.Keys.appleLanguages) as? Array<String>, let languageObj = languageArray.first, let language = AppLanguages(rawValue: String(languageObj.prefix(2))) {
            return language
        } else {
            return AppLanguages.english
        }
    }
    
    var isArabicLanguage: Bool {
        return currentAppLanguage.rawValue == AppLanguages.arabic.rawValue
    }
    
    
    func setAppleLAnguageTo(lang: String) {
        guard let languageArray = UserDefaults.standard.value(forKey: UserDefaults.Keys.appleLanguages) as? Array<String>, let languageObj = languageArray.first else { return }
        
        UserDefaults.standard.set([lang, languageObj], forKey: UserDefaults.Keys.appleLanguages)
        UserDefaults.standard.synchronize()
    }
    
    // Name of the app - title under the icon.
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
    
    func getAppVersion() -> String {
        JSON(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as Any).stringValue
    }
    
}
