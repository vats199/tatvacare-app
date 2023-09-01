//
//  AppDelegate.swift
//  MVVMBasicStructure
//
//  Created by on 27/02/23.
//

import UIKit
import AWSS3
@_exported import Firebase
@_exported import FirebaseRemoteConfig
@_exported import DropDown
@_exported import DZNEmptyDataSet
@_exported import GoogleMaps
@_exported import GooglePlaces
@_exported import AdvancedPageControl
@_exported import FirebaseDynamicLinks
@_exported import KDCircularProgress
@_exported import MaterialShowcase
@_exported import MobileCoreServices

@_exported import TwilioVideo
@_exported import AudioToolbox
@_exported import AVFoundation
@_exported import HGCircularSlider
@_exported import Hero
@_exported import libLifetronsSdk

import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static let shared : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    private var appCoordinator: AppCoordinator!
    let viewModel = HomeViewModel()
    let appId: String = "7519120009406205295"
    let configKey: String = GFunction.getConfigKeyForBCP()
    //"aebeb6bce4dc7ecec7e3083f2a292e494ff8ec2f690c338b576a9827db8e0b0f7474324e1c90ea74b9d552395a14acdba1cad03035b0ae4f01850f60db962d37ebd29f4aa91242dc08febf7d0344077a8175fcaff43e7157f3c02be65df0da5b9497c669cc71d4cbbae9a2db7e701ba9c5adaaff8eb7bd74ed51d7adc36a13bad37edf59eacfd18559702832d8b37e4995d1b41f487d6b9510f928be68b3093986fac78ffd483f792a606e85618b3fbb"
    
    override init() {
        super.init()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //        FB login
        
        FirebaseApp.configure()
        appCoordinator = AppCoordinator()
        appCoordinator.basicAppSetup()
        FIRAnalytics.FIRLogEvent(eventName: .NEW_APP_LAUNCHED, parameter: nil)
        
#if DEBUG
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
#endif
        //FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "mytatva.page.link"
        self.showPushButtons()
        
        DispatchQueue.main.async {
            InAppManager.shared.completeTransaction()
        }
        
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        var nsDictionary: NSDictionary?
//        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
//            nsDictionary = NSDictionary(contentsOfFile: path)
//            print(JSON(nsDictionary))
//        }
        
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]

        // 1
        if let notification = notificationOption as? [String: AnyObject],
          let userInfo = notification["aps"] as? [String: AnyObject] {

          // 2
            self.handlePushNotification(userInfo: JSON(userInfo),
                                        type: .didreceiveFetch)
        }
        
        WebEngage.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions, notificationDelegate: self, autoRegister: true)
        
        LSBleApi.shared().initSdk(appId: self.appId, dataFileContent: self.configKey, completion: { (code, msg) in
            print("code:--- \(code)")
            print("msg:--- \(msg)")
        })
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if UserModel.isUserLoggedIn && UserModel.isVerifiedUser {
            if kUserSessionActive {
                kUserSessionActive      = false
                FIRAnalytics.FIRLogEvent(eventName: .USER_SESSION_END, parameter: nil)
            }
        }
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        let handled = DynamicLinks.dynamicLinks()
            .handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
              // ...
            }

          return handled
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
      return application(app, open: url,
                         sourceApplication: options[UIApplication.OpenURLOptionsKey
                           .sourceApplication] as? String,
                         annotation: "")
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
          sceneDelegate.fetchDeepLinkData(link: dynamicLink.url)
        // Handle the deep link. For example, show the deep-linked content or
        // apply a promotional offer to the user's account.
        // ...
        return true
      }
      return false
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return true
    }
}

//MARK: -------------- WEGAppDelegate Methods --------------
extension AppDelegate: WEGAppDelegate {
    
    func wegHandleDeeplink(_ deeplink: String!, userData data: [AnyHashable : Any]!) {
        if let url = URL(string: deeplink) {
            let _ = DynamicLinks.dynamicLinks()
                .handleUniversalLink(url) { dynamiclink, error in
                    // ...
                    print("dynamiclink: \(dynamiclink)")
                    print("dynamiclink url: \(dynamiclink?.url)")
                    sceneDelegate.fetchDeepLinkData(link: dynamiclink?.url)
                }
        }
    }
}

extension AppDelegate: WEGInAppNotificationProtocol {
//    func notificationPrepared(_ inAppNotificationData: [String : Any]!, shouldStop stopRendering: UnsafeMutablePointer<ObjCBool>!) -> [AnyHashable : Any]!
    
    func notificationShown(_ inAppNotificationData: [String : Any]!) {
    }
    
    func notificationDismissed(_ inAppNotificationData: [String : Any]!) {
    }
        
    func notification(_ inAppNotificationData: [String : Any]!, clickedWithAction actionId: String!) {
//        print(actionId)
//        print(inAppNotificationData)
        
        let object = JSON(inAppNotificationData)
        let arr = object["actions"].arrayValue
        
        if arr.count > 0 {
            if let url = URL(string: arr[0]["actionLink"].stringValue) {
                let _ = DynamicLinks.dynamicLinks()
                    .handleUniversalLink(url) { dynamiclink, error in
                        // ...
                        print("dynamiclink: \(dynamiclink)")
                        print("dynamiclink url: \(dynamiclink?.url)")
                        sceneDelegate.fetchDeepLinkData(link: dynamiclink?.url)
                    }
            }
        }
    }
}

extension AppDelegate {
    
    //NEWLY ADDED PERMISSIONS FOR iOS 14
    func requestTrackingPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    
                    // Now that we are authorized we can get the IDFA
                    //print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
    
}

//$(WEGLicenseCode)
