//
//  GExtension+UIApplication.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension UIApplication {
    /**
     Sets home screen
     */
    func setHome() {
        if let homeNavigation = UIStoryboard.home.instantiateViewController(withIdentifier: "NavHome") as? UINavigationController {
            self.setRootController(for: homeNavigation)
        }
    }
    
    /**
     Sets home screen
     */
    func setSetting() {
        if let settingNavigation = UIStoryboard.setting.instantiateViewController(withIdentifier: "NavSetting") as? UINavigationController {
            self.setRootController(for: settingNavigation)
        }
    }
    
    /**
     Sets login screen
     */
    func setLogin() {
        if let loginNavigation = UIStoryboard.auth.instantiateViewController(withIdentifier: "NavLogin") as? UINavigationController {
            self.setRootController(for: loginNavigation)
        }
    }
    
    func setSignup(_ vc: UIViewController = SplashVC.instantiate(fromAppStoryboard: .auth)) {
        /*let nav = UINavigationController(rootViewController: vc)
        self.setRootController(for: nav)*/
        if let loginNavigation = UIStoryboard.auth.instantiateViewController(withIdentifier: "NavLoginSignup") as? UINavigationController {
            self.setRootController(for: loginNavigation)
        }
    }
    
    func setAccountFor() {
        if let loginNavigation = UIStoryboard.auth.instantiateViewController(withIdentifier: "NavAccountFor") as? UINavigationController {
            self.setRootController(for: loginNavigation)
        }
    }
    
    func setAccessCode() {
        /*let vc = DoctorAccessCodeVC.instantiate(fromAppStoryboard: .auth)
        self.setSignup(vc)*/
        if let loginNavigation = UIStoryboard.auth.instantiateViewController(withIdentifier: "NavAccessCode") as? UINavigationController {
            self.setRootController(for: loginNavigation)
        }
    }
    
    func setPatientDetail() {
//        self.setSignup(AddpatientDetailsVC.instantiate(fromAppStoryboard: .auth))
        if let loginNavigation = UIStoryboard.auth.instantiateViewController(withIdentifier: "NavPatientDetail") as? UINavigationController {
            self.setRootController(for: loginNavigation)
        }
    }
    
    func setLaunch() {
        if let loginNavigation = UIStoryboard.auth.instantiateViewController(withIdentifier: "NavLaunch") as? UINavigationController {
            self.setRootController(for: loginNavigation)
        }
    }
    
    /**
     Sets UJ - 3 screen
     */
    
    func setLetsBeginProfileFor() {
        if let loginNavigation = UIStoryboard.auth.instantiateViewController(withIdentifier: "NavLetsBeginProfileFor") as? UINavigationController {
            self.setRootController(for: loginNavigation)
        }
    }
    
    
    func setSetupProfileFor() {
        if let loginNavigation = UIStoryboard.auth.instantiateViewController(withIdentifier: "NavSetupProfileFor") as? UINavigationController {
            self.setRootController(for: loginNavigation)
        }
    }
    
    func setChronicConditionsFor() {
        if let loginNavigation = UIStoryboard.AuthTemp.instantiateViewController(withIdentifier: "NavChronicConditionsFor") as? UINavigationController {
            self.setRootController(for: loginNavigation)
        }
    }
    
    
    /**
     Sets tutorial screen
     */
    private func setLanguage() {
        if let vc = UIStoryboard.auth.instantiateViewController(withIdentifier: "SelectLanguageVC") as? SelectLanguageVC {
            let nVc = UINavigationController(rootViewController: vc)
            nVc.clearNavigation()
            self.setRootController(for: nVc)
        }
    }
    
    /// Logout user from app and clear all user data from user default
    func forceLogOut() {
        print("user forcefully logout===>>>")
        UserModel.removeCurrentUser()
        // Clear all the user default data from the app, expect remember me data
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        
        let rememberMe          = UserDefaultsConfig.rememberMe
        let mobile              = UserDefaultsConfig.mobile
        let password            = UserDefaultsConfig.password
        let languageId          = UserDefaultsConfig.languageId
        
        dictionary.keys.forEach { key in
            if key != UserDefaults.Keys.isShowTutorial &&
                key != UserDefaults.Keys.isShowHealthPermission &&
                key != UserDefaults.Keys.deviceToken &&
                key != UserDefaults.Keys.isShowCoachmark {
                
                defaults.removeObject(forKey: key)
            }
        }
        
        UserDefaultsConfig.rememberMe       = rememberMe
        UserDefaultsConfig.mobile           = mobile
        UserDefaultsConfig.password         = password
        UserDefaultsConfig.languageId       = languageId
        
        UserModel.shared = UserModel()
        UserDefaults.standard.synchronize()
        //UIApplication.shared.setLogin()
//        UIApplication.shared.manageLogin()
        
        GlobalAPI.shared.apiWalkthroughList { [weak self] dataResponse in
            guard let self = self else { return }
            let vc = WalkthroughVC.instantiate(fromAppStoryboard: .auth)
            vc.viewModel.arrWalkthroughList = dataResponse
            self.setRootController(for: vc)
        }
        
        WebengageManager.shared.weUser.logout()
        Freshchat.sharedInstance().resetUser {
        }

        kDoctorAccessCode                   = ""
        kAccessCode                         = ""
        kContactNo                          = ""
        kAccessFrom                         = .Doctor
        
        if PIPKit.isActive {
            if let vc = PIPKit.visibleViewController as? VideoAppointmentVC {
                vc.disconnectRoom()
                PIPKit.dismiss(animated: true) {
                    print("dismiss")
                }
            }
        }
        
        
        UserDefaultsConfig.badgeCount = 0
        UIApplication.shared.applicationIconBadgeNumber = UserDefaultsConfig.badgeCount
    }
    
    private func setRootController(for rootController: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            // Set the new rootViewController of the window.
            
            window.rootViewController = rootController
            window.makeKeyAndVisible()
            
            // A mask of options indicating how you want to perform the animations.
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            
            // The duration of the transition animation, measured in seconds.
            let duration: TimeInterval = 0.3
            
            // Creates a transition animation.
            // Though `animations` is optional, the documentation tells us that it must not be nil. ¯\_(ツ)_/¯
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: { completed in
                // Do something on completion here
            })
        }
    }
    
    /**
     Manage user redirection after login, logout and signup
     */
       func manageLogin() {
     
        func continueAppFlow(){
            self.setupSideMenu()
            
            // Show language screen if app is installed for the first time
            if UserDefaultsConfig.isShowTutorial {
                
                UserDefaults.standard.setValue(false, forKey: UserDefaults.Keys.isShowTutorial)
                
    //            self.setLanguage()
//                Settings().isHidden(setting: .language_page) { isHidden in
//                    if isHidden {
//    //                    self.setLogin()
//                        self.setSignup()
//                    }
//                    else {
//                        self.setLanguage()
//                        self.setSignup()
//                    }
//                }
                
                self.setSignup()
                
            }
            else {
                //Redirect user to home screen if user is loggin and verifyed by OTP
                //else set login screen
                if UserModel.isUserLoggedIn && UserModel.isVerifiedUser {
                    UserModel.shared.retrieveUserData()
    //                GlobalAPI.shared.appConfigAPI { (isDone) in
    //                }
                    
                    //Initiate webengage to login once user enters the app
                    WebengageManager.shared.initiate()
                    self.setHome()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        AppCoordinator().setUpIQKeyBoardManager()
                    }
                    
                } else {
                    //self.setLanguage()
                    //self.setLogin()
                    /*Settings().isHidden(setting: .language_page) { isHidden in
                        if isHidden {
                            //                    self.setLogin()
                            
                            let kUSerStep = UserDefaultsConfig.kUserStep
                            
                            if kUSerStep == 3 {
                                self.setPatientDetail()
                            } else if kUSerStep == 2 {
                                self.setAccessCode()
                            } else if kUSerStep == 1 {
                                self.setAccountFor()
                            } else {
                                self.setSignup()
                            }
                        }
                        else {
                            self.setLanguage()
                        }
                    }*/
                    
                    let kUSerStep = UserDefaultsConfig.kUserStep
                    
                    /*if kUSerStep == 3 {
                        self.setPatientDetail()
                    } else if kUSerStep == 2 {
                        self.setAccessCode()
                    } else if kUSerStep == 1 {
                        self.setAccountFor()
                    } else {
                        self.setSignup()
                    }*/
                    
                    
                    if kUSerStep == 3 {
                        self.setChronicConditionsFor()
                    } else if kUSerStep == 2 {
                        self.setSetupProfileFor()
                    } else if kUSerStep == 1 {
                        self.setLetsBeginProfileFor()
                    } else {
                        self.setSignup()
                    }
                    
                }
            }
        }
        
        if isRemoteConfigFetchDone {
            continueAppFlow()
        }
        else {
            continueAppFlow()
//            self.setLaunch()
        }
    }
    
    /// To get top of the view controller
    /// - Parameter controller: Any controller which is need to find top view controller
    /// - Returns: Optional top view controller
    class func topViewController(controller: UIViewController? = sceneDelegate.window?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller ?? sceneDelegate.window?.rootViewController
    }
    
    class func popTo(viewController: Any) {
        if let topVC = UIApplication.topViewController() {
            for element in  (topVC.navigationController?.viewControllers ?? []) as Array {
                if "\(type(of: element)).Type" == "\(type(of: viewController))" {
                    topVC.navigationController?.popToViewController(element, animated: true)
                    break
                }
            }
        }
        
    }
    
    /**
     Get safe area insets
     */
    class var safeArea : UIEdgeInsets {
        if UIApplication.shared.windows.count > 0{
            if #available(iOS 11.0, *) {
                return UIApplication.shared.windows[0].safeAreaInsets
            } else {
                return UIEdgeInsets.zero
                // Fallback on earlier versions
            }
        }
        return UIEdgeInsets.zero
    }
    
    /**
     Return true if device has notch
     */
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
    //------------------------------------------------------
    //MARK:- SideMenuSetUp
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = UISideMenuNavigationController.instantiate(fromAppStoryboard: .home)
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        
        let navigationController : UINavigationController = UIStoryboard.home.instantiateViewController(withIdentifier: "NavHome") as! UINavigationController
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        navigationController.clearNavigation()
        
        //        SideMenuManager.default.menuAddPanGestureToPresent(toView: navigationController.navigationBar)
        //        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: navigationController.view)
        
        SideMenuManager.default.menuAnimationBackgroundColor        = UIColor.clear
        SideMenuManager.default.menuFadeStatusBar                   = true
        SideMenuManager.default.menuPresentMode                     = .menuSlideIn
        SideMenuManager.default.menuShadowOpacity                   = 1
        SideMenuManager.default.menuShadowColor                     = UIColor.themeBlack
        SideMenuManager.default.menuShadowRadius                    = 0
        SideMenuManager.default.menuWidth                           = ScreenSize.width * 0.8
        SideMenuManager.default.menuAnimationFadeStrength           = 0.4
        SideMenuManager.default.menuAnimationTransformScaleFactor   = 1
        SideMenuManager.default.menuPushStyle                       = .popWhenPossible
        
        //        SideMenuManager.default.menuAnimationPresentDuration = 1
    }
}

extension UIApplication {
    /**
     Get status bar view
     */
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 3848245
            if let statusBar = self.windows.first?.viewWithTag(tag) {
                self.windows.first?.bringSubviewToFront(statusBar)
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? .zero)
                statusBarView.tag = tag
                
                self.windows.first?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}
