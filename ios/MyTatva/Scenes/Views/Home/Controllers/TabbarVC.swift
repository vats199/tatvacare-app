
//
//  BasicVC.swift


import UIKit
import React

class TabbarVC: BFPaperTabBarController {
    
    //MARK: -------------------------- Outlet --------------------------
    @IBOutlet weak var myTabbar                     : UITabBar!
    
    //MARK: -------------------------- Class Variable --------------------------
    private var showEngageVC = true
    private var isFromRN = true
    private var currentIndex = 0
    var prevTabBarIndex = 0
    private var tempVariable = false
    
    //MARK: -------------------------- Memory Management Method --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: -------------------------- Custom Method --------------------------
    
    fileprivate func setUpView() {
        self.delegate = self
        
        self.showEngageVC = true
        Settings().isHidden(setting: .hide_engage_page) { isHidden in
            if isHidden {
                self.showEngageVC = false
            }
            Settings().isHidden(setting: .home_from_react_native) { isFromRN in
                self.isFromRN = isFromRN
                self.setTabbarViewControllers()
                self.setTabbar()
                self.setTabTheme()
                self.selectedIndex = self.currentIndex
            }
        }
    }
    
    fileprivate  func setTabbar(){
        self.myTabbar.backgroundColor       = UIColor.clear
        self.myTabbar.backgroundImage       = UIImage()
        self.myTabbar.shadowImage           = UIImage()  // removes the border
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 12),
                                                                  NSAttributedString.Key.foregroundColor: UIColor.themeGray],
                                                                 for: .normal)
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 12),
                                                                  NSAttributedString.Key.foregroundColor: UIColor.themePurple],
                                                                 for: .selected)
        
        
        let vwBg                            = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: self.tabBar.frame.height + 50))
        vwBg.backgroundColor                = UIColor.white
        //        vwBg.roundCorners(corners: [.topLeft, .topRight], radius: 25)
        self.myTabbar.insertSubview(vwBg, belowSubview: self.myTabbar.subviews.first!)
        self.myTabbar.applyViewShadow(shadowOffset: .zero,
                                      shadowColor: UIColor.themeBlack,
                                      shadowOpacity: 0.3,
                                      shdowRadious: 5)
        
        let paddingTop: CGFloat     = 5
        let paddingBottom: CGFloat  = 2
        var index = 0
        
        let tab1            = self.tabBar.items![index]
        index += 1
        tab1.image          = UIImage(named: "home_unselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tab1.selectedImage  = UIImage(named: "home_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tab1.title          = "Home"
        tab1.imageInsets    = UIEdgeInsets(top: paddingTop, left: 0, bottom: paddingBottom, right: 0)
        
        let tab2            = self.tabBar.items![index]
        index += 1
        tab2.image          = UIImage(named: "care_unselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tab2.selectedImage  = UIImage(named: "care_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tab2.title          = "Care Plan"
        tab2.imageInsets    = UIEdgeInsets(top: paddingTop, left: 0, bottom: paddingBottom, right: 0)
        
        if self.showEngageVC {
            let tab3            = self.tabBar.items![index]
            index += 1
            tab3.image          = UIImage(named: "engage_unselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            tab3.selectedImage  = UIImage(named: "engage_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            tab3.title          = "Discover"
            tab3.imageInsets    = UIEdgeInsets(top: paddingTop, left: 0, bottom: paddingBottom, right: 0)
        }
        
        let tab4            = self.tabBar.items![index]
        index += 1
        tab4.image          = UIImage(named: "exercise_unselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tab4.selectedImage  = UIImage(named: "exercise_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tab4.title          = "Exercise"
        tab4.imageInsets    = UIEdgeInsets(top: paddingTop, left: 0, bottom: paddingBottom, right: 0)
        
        if !self.isFromRN {
            let tab5            = self.tabBar.items![index]
            tab5.image          = UIImage(named: "more_unselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            tab5.selectedImage  = UIImage(named: "more_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            tab5.title          = "More"
            tab5.imageInsets    = UIEdgeInsets(top: paddingTop, left: 0, bottom: paddingBottom, right: 0)
        } else {
            let tab6           = self.tabBar.items![index]
            tab6.image          = UIImage(named: "chat_unselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            tab6.selectedImage  = UIImage(named: "chat_unselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            tab6.title          = "Ask"
            tab6.imageInsets    = UIEdgeInsets(top: paddingTop, left: 0, bottom: paddingBottom, right: 0)
        }
    }
    
    fileprivate func setTabbarViewControllers(){
        
#if DEBUG
        let rootView = RCTRootView(
            bundleURL: URL(string: "http://192.168.1.29:8081/index.bundle?platform=ios")!,
//            bundleURL: URL(string: "http://localhost:8081/index.bundle?platform=ios")!,
            //           bundleURL: URL(string: "http://192.168.1.5:8081/index.bundle?platform=ios")!,
            //            bundleURL: URL(string: "http://192.168.1.36:8081/index.bundle?platform=ios")!,
            
            //           bundleURL: URL(string: "http://169.254.76.56:8081/index.bundle?platform=ios")!,
            
            moduleName: "TatvacareApp",
            initialProperties: nil,
            launchOptions: nil
        )
        
        let chatView = RCTRootView(
            bundleURL: URL(string: "http://192.168.1.29:8081/index.bundle?platform=ios")!,
//            bundleURL: URL(string: "http://localhost:8081/index.bundle?platform=ios")!,
            //           bundleURL: URL(string: "http://192.168.1.5:8081/index.bundle?platform=ios")!,
            //            bundleURL: URL(string: "http://192.168.1.36:8081/index.bundle?platform=ios")!,
            
            //           bundleURL: URL(string: "http://169.254.76.56:8081/index.bundle?platform=ios")!,
            
            moduleName: "TatvacareApp",
            initialProperties: nil,
            launchOptions: nil
        )
#else
        let rootView = RCTRootView(
            bundleURL: Bundle.main.url(forResource: "main", withExtension: "jsbundle")!,
            //           bundleURL: URL(string: "http://192.168.1.5:8081/index.bundle?platform=ios")!,
            //            bundleURL: URL(string: "http://192.168.1.32:8081/index.bundle?platform=ios")!,
            
            //           bundleURL: URL(string: "http://169.254.76.56:8081/index.bundle?platform=ios")!,
            
            moduleName: "TatvacareApp",
            initialProperties: nil,
            launchOptions: nil
        )
        
        let chatView = RCTRootView(
            bundleURL: Bundle.main.url(forResource: "main", withExtension: "jsbundle")!,
            //           bundleURL: URL(string: "http://192.168.1.5:8081/index.bundle?platform=ios")!,
            //            bundleURL: URL(string: "http://192.168.1.32:8081/index.bundle?platform=ios")!,
            
            //           bundleURL: URL(string: "http://169.254.76.56:8081/index.bundle?platform=ios")!,
            
            moduleName: "TatvacareApp",
            initialProperties: nil,
            launchOptions: nil
        )
#endif
        
        let vc = UIViewController()
        vc.view = rootView
        var homeVC: UIViewController!
        
        if self.isFromRN {
            homeVC = vc
        } else {
            homeVC = HomeVC.instantiate(fromAppStoryboard: .home)
        }
        
        let cvc = UIViewController()
        cvc.view = chatView
        var chatVC: UIViewController!
        
        if self.isFromRN {
            chatVC = cvc
        }
        
        let carePlanVC          = CarePlanVC.instantiate(fromAppStoryboard: .carePlan)
        let engageVC            = EngageParentVC.instantiate(fromAppStoryboard: .engage)
        let exerciseVC          = ExerciseParentVC.instantiate(fromAppStoryboard: .exercise)
        let moreVC              = MenuVC.instantiate(fromAppStoryboard: .home)
        
        var arrVC       = [homeVC!, carePlanVC, exerciseVC]
        if self.showEngageVC {
            arrVC       = [homeVC!, carePlanVC, engageVC, exerciseVC]
        }
        
        if !self.isFromRN {
            arrVC.append(moreVC)
        } else {
            //            Chat Module
            arrVC.append(chatVC!)
        }
        
        self.viewControllers    = arrVC
        self.viewControllers    = arrVC.map({ (vc) in
            UINavigationController(rootViewController: vc)
        })
        
        if self.isFromRN {
            self.viewControllers?[0] = homeVC
            self.viewControllers?[arrVC.count - 1] = chatVC
        }
        
        
    }
    
    fileprivate func setTabTheme(){
        
        self.tabBar.tintColor = UIColor.themePurple // set the tab bar tint color to something cool.
        
        self.rippleFromTapLocation = true  // YES = spawn tap-circles from tap locaiton. NO = spawn tap-circles from the center of the tab.
        
        self.usesSmartColor = true // YES = colors are chosen from the tabBar.tintColor. NO = colors will be shades of gray.
        
        self.tapCircleColor = UIColor.themePurple    // Set this to customize the tap-circle color.
        
        self.backgroundFadeColor = UIColor.clear  // Set this to customize the background fade color.
        
        self.tapCircleDiameter = bfPaperTabBarController_tapCircleDiameterSmall;    // Set this to customize the tap-circle diameter.
        
        self.underlineColor = UIColor.clear // Set this to customize the color of the underline which highlights the currently selected tab.
        
        self.animateUnderlineBar = true  // YES = bar slides below tabs to the selected one. NO = bar appears below selected tab instantaneously.
        
        self.showUnderline = true  // YES = show the underline bar, NO = hide the underline bar.
        
        self.underlineThickness = 0    // Set this to adjust the thickness (height) of the underline bar. Not that any value greater than 1 could cover up parts of the TabBarItem's title.
        
        self.showTapCircleAndBackgroundFade = true // YES = show the tap-circles and add a color fade the background. NO = do not show the tap-circles and background fade.
        
    }
    //MARK: -------------------------- Action Method --------------------------
    
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFromRN {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appStatusActivity), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appStatusActivity), name: UIApplication.willResignActiveNotification, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            GlobalAPI.shared.get_incident_surveyAPI(withLoader: false,
                                                    showAlert: false) { isDone, obj, msg in
                if isDone {
                    Settings().isHidden(setting: .hide_incident_survey) { isHide in
                        hide_incident_surveyMain = isHide
                    }
                }
                else {
                    hide_incident_surveyMain = true
                }
            }
            if self.isFromRN {
                GlobalAPI.shared.getPatientDetailsAPI { [weak self] (isDone) in
                    guard let self = self else {return}
                    if isDone {
                        //self.updateAppData()
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension TabbarVC: TransitionableTab {
    
    func transitionDuration() -> CFTimeInterval {
        return 0.2
    }
    
    func transitionTimingFunction() -> CAMediaTimingFunction {
        return .easeInOut
    }
    
    func fromTransitionAnimation(layer: CALayer?, direction: Direction) -> CAAnimation {
        //        switch type {
        //        case .move: return DefineAnimation.move(.from, direction: direction)
        //        case .scale: return DefineAnimation.scale(.from)
        //        case .fade: return DefineAnimation.fade(.from)
        //        case .custom:
        //            let animation = CABasicAnimation(keyPath: "transform.translation.y")
        //            animation.fromValue = 0
        //            animation.toValue = -(layer?.frame.height ?? 0)
        //            return animation
        //        }
        
        return DefineAnimation.scale(.from)
        
    }
    
    func toTransitionAnimation(layer: CALayer?, direction: Direction) -> CAAnimation {
        //        switch type {
        //        case .move: return DefineAnimation.move(.to, direction: direction)
        //        case .scale: return DefineAnimation.scale(.to)
        //        case .fade: return DefineAnimation.fade(.to)
        //        case .custom:
        //            let animation = CABasicAnimation(keyPath: "transform.translation.y")
        //            animation.fromValue = (layer?.frame.height ?? 0)
        //            animation.toValue = 0
        //            return animation
        //        }
        
        //        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        //        animation.fromValue = 20//(layer?.frame.width ?? 0)
        //        animation.toValue = 0
        //        return animation
        
        return DefineAnimation.move(.to, direction: direction)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return animateTransition(tabBarController, shouldSelect: viewController)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if self.isFromRN {
            RNEventEmitter.emitter.sendEvent(withName: "bottomTabNavigationInitiated", body: [:])
            if(tabBarController.selectedIndex == 4){
                IQKeyboardManager.shared.enable = false
                IQKeyboardManager.shared.enableAutoToolbar = false
                var params: [String: Any] = [:]
                params[AnalyticsParameters.module.rawValue] = "Chatbot"
                FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_BOTTOM_NAV,
                                         screen: .Home,
                                         parameter: params)
                tabBar.isHidden = true
                RNEventEmitter.emitter.sendEvent(withName: "chatScreenOpened", body: [:])
            }
            if(tabBarController.selectedIndex == 1){
                var params: [String: Any] = [:]
                params[AnalyticsParameters.module.rawValue] = "Home"
                FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_BOTTOM_NAV,
                                         screen: .Home,
                                         parameter: params)
            }
        }
        
        let vcs = viewController.children[0]
        
        if let _ = vcs as? MenuVC {
            var params: [String: Any] = [:]
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_MENU,
                                     screen: .Home,
                                     parameter: params)
            
            params[AnalyticsParameters.module.rawValue] = "More"
            FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_BOTTOM_NAV,
                                     screen: .Home,
                                     parameter: params)
        }
        
        if let _ = vcs as? ExerciseParentVC {
            var params: [String: Any] = [:]
            params[AnalyticsParameters.module.rawValue] = "Exercise"
            FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_BOTTOM_NAV,
                                     screen: .Home,
                                     parameter: params)
        }
        
        if let _ = vcs as? HomeVC {
            var params: [String: Any] = [:]
            params[AnalyticsParameters.module.rawValue] = "Home"
            FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_BOTTOM_NAV,
                                     screen: .Home,
                                     parameter: params)
        }
        
        if let _ = vcs as? CarePlanVC {
            var params: [String: Any] = [:]
            params[AnalyticsParameters.module.rawValue] = "Care Plan"
            FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_BOTTOM_NAV,
                                     screen: .Home,
                                     parameter: params)
        }
        
        if let _ = vcs as? EngageParentVC {
            var params: [String: Any] = [:]
            params[AnalyticsParameters.module.rawValue] = "Discover"
            FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_BOTTOM_NAV,
                                     screen: .Home,
                                     parameter: params)
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        //(viewController as! UINavigationController).viewControllers[0].view.subviews
        
        //        if let nav = viewController as? UINavigationController {
        //            let vc = nav.viewControllers[0]
        //            let subviews = vc.view.subviews
        //            for vw in subviews {
        //                if let scroll = vw as? UIScrollView {
        //                    scroll.scrollToTop()
        //                }
        //                else if let scroll = vw as? UITableView {
        //                    scroll.scrollToTop()
        //                }
        //                else if let scroll = vw as? UICollectionView {
        //                    scroll.scrollToTop()
        //                }
        //            }
        //        }
        
        ///For tab select animation
        DispatchQueue.main.async {
            if let items = self.myTabbar.items {
                for i in 0...items.count - 1 {
                    if items[i] == self.myTabbar.selectedItem {
                        if(self.currentIndex != 4){
                            self.prevTabBarIndex = self.currentIndex
                        }
                        self.currentIndex = i
                        if self.myTabbar.subviews.count > 0 {
                            if i + 3 < self.myTabbar.subviews.count {
                                if let vw = self.myTabbar.subviews[i + 3].subviews[1] as? UIImageView{
                                    self.amimateTab(vw: vw)
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func amimateTab(vw: UIView){
        
        UIView.animate(withDuration: 0.2, animations: {
            //            vw.transform = CGAffineTransform(scaleX: 2, y: 2)
            //            vw.transform = CGAffineTransform(scaleX: -1, y: 1)
            
            let translation     = CGAffineTransform(translationX: -1, y: 1)
            let scaling         = CGAffineTransform(scaleX: 1.1, y: 1.1)
            let fullTransform   = scaling.concatenating(translation)
            
            //            let translation     = CGAffineTransform(translationX: -10, y: 1)
            //            let scaling         = CGAffineTransform(rotationAngle: 180)
            //            let fullTransform   = scaling.concatenating(translation)
            
            vw.transform        = fullTransform
        }) { isDone in
            
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3.0, options: .curveEaseInOut, animations: {
                vw.transform = .identity
            }, completion: nil)
        }
    }
    
    @objc func appStatusActivity(_ notification: Notification)  {
        if notification.name == UIApplication.didBecomeActiveNotification{
            // become active notifictaion
        }else{
            // willResignActiveNotification
        }
    }
}




