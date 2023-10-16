//
//  AppCoordinator.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 02/03/21.
//

import UIKit
// This is for handel keyboard
@_exported import IQKeyboardManagerSwift
// This is for handel optional data
@_exported import SwiftyJSON

// This is for logs
import QorumLogs

// This is for app update
import Siren

class AppCoordinator: NSObject {
    
    var audioDevice = DefaultAudioDevice()
    
    func basicAppSetup() {
        
        setupMap()
        
        //        GMSServices.provideAPIKey(AppCredential.googleKey.rawValue)
        //        GMSPlacesClient.provideAPIKey(AppCredential.googleKey.rawValue)
        
        //        GMSServices.provideAPIKey(AppCredential.googleKey.rawValue)
        //        GMSPlacesClient.provideAPIKey(AppCredential.googleKey.rawValue)
        //GIDSignIn.sharedInstance().clientID = AppCredential.googleClientID.rawValue
        
        DispatchQueue.main.async {
            LocationManager.shared.getLocation()
        }
        
        
        //Application setup
        UIApplication.shared.windows.first?.isExclusiveTouch = true
        UITextField.appearance().tintColor = UIColor.themePurple
        UITextView.appearance().tintColor = UIColor.themePurple
        if #available(iOS 9.0, *) {
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.themeBlack]
        } else {
            // Fallback on earlier versions
        }
        
        let alertView = UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
        alertView.tintColor = UIColor.themePurple
        
        UINavigationBar.appearance().barStyle = .blackOpaque
        
        RemoteConfigManager.shared.initiateRemoteConfig()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            ///Set audio device support for Twilio
            self.audioDevice = DefaultAudioDevice()
            TwilioVideoSDK.audioDevice = self.audioDevice
            
            if self.audioDevice == DefaultAudioDevice() {
                self.audioDevice.block = {
                    do {
                        DefaultAudioDevice.DefaultAVAudioSessionConfigurationBlock()
                        
                        let audioSession = AVAudioSession.sharedInstance()
                        //try audioSession.setMode(.voiceChat)
                        try audioSession.setCategory(
                            .playAndRecord, mode: .videoChat,
                            options: [.mixWithOthers,
                                      .allowAirPlay,
                                      .allowBluetoothA2DP,
                                      .allowBluetooth])
                    } catch let error as NSError {
                        print("Fail: \(error.localizedDescription)")
                    }
                }
                
                self.audioDevice.block();
            }
            else {
                self.audioDevice = DefaultAudioDevice()
            }
        }
        
        if UserDefaultsConfig.kAppVersion != Bundle.main.getAppVersion() && !(UserModel.isUserLoggedIn && UserModel.isVerifiedUser) {
            UIApplication.shared.forceLogOut()
            UserDefaultsConfig.kAppVersion = Bundle.main.getAppVersion()
        }else {
            //manage login
            if #available(iOS 13.0, *) {
                //For latest versions
            } else {
                UIApplication.shared.manageLogin()
            }
        }
        
        //Google sign in init
        //        GIDSignIn.sharedInstance().clientID = AppCredential.googleClientID.rawValue
        
        // AWS Image upload configration
        AWSUploadManager.shared.configure()
        
        //IQKeyboard Setup
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.setUpIQKeyBoardManager()
        }
        
        //Push setup
        AppDelegate.shared.registerForNotification()
        
        //Network Observer
        ReachabilityManager.shared.startObserving()
        GFunction.shared.cartItem = 0
        
        QorumLogs.enabled = true
    }
    
    func setUpIQKeyBoardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 5
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func setupMap() {
        
        let GMSServicesKeyValid = GMSServices.provideAPIKey(AppCredential.googleKey.rawValue)
        
        let GMSServicesSDKVer = GMSServices.sdkVersion()
        print("GMS Services Key Valid: ", GMSServicesKeyValid)
        print("GMS Services SDK version: ", GMSServicesSDKVer)
        
        let GMSPlacesKeyValid = GMSPlacesClient.provideAPIKey(AppCredential.googleBrowserKey.rawValue)
        
        let GMSPlacesSDKVer = GMSPlacesClient.sdkVersion()
        print("GMS Places Key Valid: ", GMSPlacesKeyValid)
        print("GMS Places SDK version: ", GMSPlacesSDKVer)
    }
}
