//
//  SceneDelegate.swift
//  MVVMBasicStructure
//
//  Created by on 27/02/23.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        //self.window = ((UIApplication.shared.connectedScenes.first) as? UIWindowScene)?.windows.first
        
        
        if UserModel.isUserLoggedIn && UserModel.isVerifiedUser {
            if BiometricsManager.shared.getBiometricType() != .none {
                if UserModel.isBiometricOn {
                    BiometricsManager.shared.authenticationWithTouchID { [weak self]  (isDone) in
                        guard let self = self else {return}
                        if isDone {
                            DispatchQueue.main.async {
                                UIApplication.shared.manageLogin()
                                if let userActivity = connectionOptions.userActivities.first {
                                    self.navigateUserWithDeeplink(userActivity: userActivity)
                                }
                            }
                        }
                    }
                }
                else {
                    UIApplication.shared.manageLogin()
                    if let userActivity = connectionOptions.userActivities.first {
                        self.navigateUserWithDeeplink(userActivity: userActivity)
                    }
                }
            }
            else {
                UIApplication.shared.manageLogin()
                if let userActivity = connectionOptions.userActivities.first {
                    self.navigateUserWithDeeplink(userActivity: userActivity)
                }
            }
        }
        else {
            UIApplication.shared.manageLogin()
            if let userActivity = connectionOptions.userActivities.first {
                self.navigateUserWithDeeplink(userActivity: userActivity)
            }
        }
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        isAppBackgroundForGAOnce = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            AppDelegate.shared.requestTrackingPermission()
        }
        
        kAppSessionTimeStart    = Date()
        kUserSessionActive      = UserModel.isUserLoggedIn && UserModel.isVerifiedUser
        FIRAnalytics.FIRLogEvent(eventName: .USER_SESSION_START, parameter: nil)
        
        if UserModel.isUserLoggedIn && UserModel.isVerifiedUser {
            
            HealthKitManager.shared.checkHealthKitPermission { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    //                    DispatchQueue.main.async {
                    //
                    //                    }
                    GlobalAPI.shared.update_goal_and_reading_from_healthkitAPI { [weak self] isDone in
                        guard let _ = self else {return}
                        if isDone{
                        }
                    }
                }
            }
            
            //            GlobalAPI.shared.appConfigAPI { (isDone) in
            //            }
            //
            //            GlobalAPI.shared.updateLocationAPI { (isDone) in
            //            }
            
            GlobalAPI.shared.updateDeviceAPI { [weak self] (isDone) in
                guard let _ = self else {return}
                GlobalAPI.shared.getPatientDetailsAPI { [weak self] isOk in
                    guard let _ = self else {return}
                }
            }
        }
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        isAppBackgroundForGAOnce = true
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        if UserModel.isUserLoggedIn && UserModel.isVerifiedUser {
            if kUserSessionActive {
                kUserSessionActive      = false
                FIRAnalytics.FIRLogEvent(eventName: .USER_SESSION_END, parameter: nil)
            }
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        let url = URLContexts.first?.url
        let urlStr = url?.absoluteString
        if (urlStr!.contains("add-test-device")) {
            ApxorSDK.handleDeeplink(url!)
        }
        
        for context in URLContexts {
            print("url: \(context.url.absoluteURL)")
            print("scheme: \(context.url.scheme ?? "")")
            print("host: \(context.url.host ?? "")")
            print("path: \(context.url.path)")
            print("query: \(context.url.query ?? "")")
            print("components: \(context.url.pathComponents)")
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        self.navigateUserWithDeeplink(userActivity: userActivity)
    }
    
}


//MARK: -------------------- Navigate user from deeplink --------------------
extension SceneDelegate {
    
    func navigateUserWithDeeplink(userActivity: NSUserActivity){
        
        let _ = DynamicLinks.dynamicLinks()
            .handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
                // ...
                print("dynamiclink: \(dynamiclink)")
                print("dynamiclink url: \(dynamiclink?.url)")
                self.fetchDeepLinkData(link: dynamiclink?.url)
            }
    }
    
    @discardableResult
    func fetchDeepLinkData(link: URL?) -> DeepLinkType? {
        
        if let url = link {
            let data = JSON(url.queryDictionary ?? [:])
            print("dynamiclink data: \(data)")
            
            guard let type = DeepLinkType.init(rawValue: data["operation"].stringValue) else {
                return nil
            }
            
            switch type {
                
            case .content:
                if UserModel.isUserLoggedIn && UserModel.isVerifiedUser {
                    UIApplication.shared.setHome()
                    let engageContentDetailVC = EngageContentDetailVC.instantiate(fromAppStoryboard: .engage)
                    engageContentDetailVC.contentMasterId = data["content_master_id"].stringValue
                    engageContentDetailVC.hidesBottomBarWhenPushed = true
                    if let vc = UIApplication.topViewController() {
                        vc.navigationController?.pushViewController(engageContentDetailVC, animated: true)
                    }
                }
                
                break
            case .signup_link_doctor:
                
                //doctor_access_code
                //access_code
                kDoctorAccessCode   = ""
                kAccessCode         = ""
                kContactNo          = data["contact_no"].stringValue
                kDoctorAccessCode   = data["doctor_access_code"].stringValue
                if kDoctorAccessCode.trim() != "" {
                    kAccessFrom         = .LinkPatient
                    kDoctorAccessCode   = data["doctor_access_code"].stringValue
                    kAccessCode         = data["access_code"].stringValue
                }
                else {
                    //this is doctor link
                    kAccessFrom         = .Doctor
                    kAccessCode         = data["access_code"].stringValue
                }
                
                break
            case .screen_nav:
                let type = ScreenName.init(rawValue: data["screen_name"].stringValue) ?? .Home
                if type == .ForgotPasswordPhone {
                    let vc = ForgotPasswordVC.instantiate(fromAppStoryboard: .auth)
                    vc.hidesBottomBarWhenPushed = true
                    if let vc2 = UIApplication.topViewController() {
                        vc2.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if UserModel.isUserLoggedIn && UserModel.isVerifiedUser {
                    
                    if(type != .GenAI){
                        UIApplication.shared.setHome()
                    }
                    
                    switch type {
                    case .GenAI:
                        if let tabbar = UIApplication.topViewController()?.parent as? TabbarVC {
                            if  tabbar.isFromRN && !tabbar.hideChatbot{
                                tabbar.selectedIndex = 4
                                tabbar.tabBar.isHidden = true
                                
                                RNEventEmitter.emitter.sendEvent(withName: "chatScreenOpened", body: [:])
                                
                            }
                            
                        }
                        break
                    case .Home:
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            if let vc = UIApplication.topViewController() as? HomeVC {
                                if let screenSection = ScreenSection.init(rawValue: data["screen_section"].stringValue) {
                                    
                                    vc.screenSection = screenSection
                                }
                            }
                        }
                        
                        break
                    case .CarePlan:
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            if let tab = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first as? UITabBarController {
                                tab.selectedIndex = 1
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                    if let vc = UIApplication.topViewController() as? CarePlanVC {
                                        if let screenSection = ScreenSection.init(rawValue: data["screen_section"].stringValue) {
                                            
                                            vc.screenSection = screenSection
                                        }
                                    }
                                }
                            }
                        }
                        break
                    case .DiscoverEngage:
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            if let tab = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first as? UITabBarController {
                                tab.selectedIndex = 2
                                
                                if let type = data["content_type"].string {
                                    if let engageVC = (tab.viewControllers?[2] as? UINavigationController)?.viewControllers.first as? EngageParentVC{
                                        
                                        let filterContenTypeListModel = FilterContenTypeListModel()
                                        filterContenTypeListModel.keys = type
                                        let arr = ContenFilterListModel()
                                        arr.contentType = [filterContenTypeListModel]
                                        engageVC.selectedFilterobject_engage = arr
                                        
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                                            
                                            if let vc = engageVC.pages.first as? DiscoverEngageListVC {
                                                vc.selectedFilterobject = engageVC.selectedFilterobject_engage
                                                
                                                if let arrTemp = arr.topic {
                                                    for item in vc.viewModel.arrListTopicList {
                                                        item.isSelected = false
                                                        for child in arrTemp {
                                                            if item.topicMasterId == child.topicMasterId {
                                                                item.isSelected = true
                                                            }
                                                        }
                                                    }
                                                    vc.colTopic.reloadData()
                                                }
                                                vc.updateAPIData()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        break
                    case .ExercisePlan:
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            if let tab = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first as? UITabBarController {
                                tab.selectedIndex = 3
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                    if let vc = (tab.viewControllers?[3] as? UINavigationController)?.viewControllers.first as? ExerciseParentVC {
                                        vc.manageSelection(type: .MyRoutine)
                                    }
                                }
                            }
                        }
                        break
                    case .ExerciseMore:
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            if let tab = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first as? UITabBarController {
                                tab.selectedIndex = 3
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                    if let vc = (tab.viewControllers?[3] as? UINavigationController)?.viewControllers.first as? ExerciseParentVC {
                                        vc.manageSelection(type: .Explore)
                                    }
                                }
                            }
                        }
                        break
                    case .ContentDetailPhotoGallery:
                        
                        let engageContentDetailVC = EngageContentDetailVC.instantiate(fromAppStoryboard: .engage)
                        engageContentDetailVC.contentMasterId = data["content_master_id"].stringValue
                        engageContentDetailVC.hidesBottomBarWhenPushed = true
                        if let vc = UIApplication.topViewController() {
                            vc.navigationController?.pushViewController(engageContentDetailVC, animated: true)
                        }
                        break
                    case .ContentDetailNormalVideo:
                        
                        let engageContentDetailVC = EngageContentDetailVC.instantiate(fromAppStoryboard: .engage)
                        engageContentDetailVC.contentMasterId = data["content_master_id"].stringValue
                        engageContentDetailVC.hidesBottomBarWhenPushed = true
                        if let vc = UIApplication.topViewController() {
                            vc.navigationController?.pushViewController(engageContentDetailVC, animated: true)
                        }
                        break
                    case .ContentDetailKolVideo:
                        
                        let engageContentDetailVC = EngageContentDetailVC.instantiate(fromAppStoryboard: .engage)
                        engageContentDetailVC.contentMasterId = data["content_master_id"].stringValue
                        engageContentDetailVC.hidesBottomBarWhenPushed = true
                        if let vc = UIApplication.topViewController() {
                            vc.navigationController?.pushViewController(engageContentDetailVC, animated: true)
                        }
                        break
                    case .ContentDetailBlog:
                        
                        let engageContentDetailVC = EngageContentDetailVC.instantiate(fromAppStoryboard: .engage)
                        engageContentDetailVC.contentMasterId = data["content_master_id"].stringValue
                        engageContentDetailVC.hidesBottomBarWhenPushed = true
                        if let vc = UIApplication.topViewController() {
                            vc.navigationController?.pushViewController(engageContentDetailVC, animated: true)
                        }
                        
                        break
                    case .ContentDetailWebinar:
                        
                        let engageContentDetailVC = EngageContentDetailVC.instantiate(fromAppStoryboard: .engage)
                        engageContentDetailVC.contentMasterId = data["content_master_id"].stringValue
                        engageContentDetailVC.hidesBottomBarWhenPushed = true
                        if let vc = UIApplication.topViewController() {
                            vc.navigationController?.pushViewController(engageContentDetailVC, animated: true)
                        }
                        break
                    case .ExercisePlanDetail:
                        let detailVC = ExercisePlanDetailVC.instantiate(fromAppStoryboard: .exercise)
                        detailVC.content_master_id  = data["content_master_id"].stringValue
                        detailVC.titleTop           = data["plan_name"].stringValue
                        detailVC.plan_type          = data["plan_type"].stringValue
                        detailVC.exerciseAddedBy    = "A"//data["exercise_added_by"].stringValue
                        detailVC.hidesBottomBarWhenPushed = true
                        if let vc = UIApplication.topViewController() {
                            vc.navigationController?.pushViewController(detailVC, animated: true)
                        }
                        break
                        
                    case .ExercisePlanDayDetail:
                        
                        let detailVC = ExerciseDetailsParentVC.instantiate(fromAppStoryboard: .exercise)
                        detailVC.exercise_plan_day_id   = data["exercise_plan_day_id"].stringValue
                        detailVC.plan_type              = data["plan_type"].stringValue
                        detailVC.exerciseAddedBy        = "A"//data["exercise_added_by"].stringValue
                        detailVC.hidesBottomBarWhenPushed = true
                        if let vc = UIApplication.topViewController() {
                            vc.navigationController?.pushViewController(detailVC, animated: true)
                        }
                        break
                        
                    case .RequestCallBack:
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            if let tab = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first as? UITabBarController {
                                tab.selectedIndex = 1
                                
                                PlanManager.shared.isAllowedByPlan(type: .prescription_book_test,
                                                                   sub_features_id: "",
                                                                   completion: { isAllow in
                                    if isAllow {
                                        let vc = RequestCallBackPopupVC.instantiate(fromAppStoryboard: .carePlan)
                                        vc.modalPresentationStyle = .overFullScreen
                                        vc.modalTransitionStyle = .crossDissolve
                                        //vc.patient_dose_rel_id = data["patient_dose_rel_id"].stringValue
                                        vc.completionHandler = { objc in
                                            
                                            if objc != nil {
                                                if objc?.count > 0 {
                                                    vc.dismiss(animated: true) {
                                                        let profileVC = ProfileVC.instantiate(fromAppStoryboard: .setting)
                                                        UIApplication.topViewController()?.navigationController?.pushViewController(profileVC, animated: true)
                                                    }
                                                }
                                                else {
                                                    let backvc = BackToCarePlanPopupVC.instantiate(fromAppStoryboard: .carePlan)
                                                    backvc.modalPresentationStyle = .overFullScreen
                                                    backvc.modalTransitionStyle = .crossDissolve
                                                    UIApplication.topViewController()?.navigationController?.present(backvc, animated: false, completion: nil)
                                                }
                                            }
                                        }
                                        UIApplication.topViewController()?.navigationController?.present(vc, animated: true, completion: nil)
                                    }
                                    else {
                                        PlanManager.shared.alertNoSubscription()
                                    }
                                })
                            }
                        }
                        
                        break
                        
                    case .FoodDiaryDay:
                        
                        PlanManager.shared.isAllowedByPlan(type: .activity_logs,
                                                           sub_features_id: GoalType.Diet.rawValue,
                                                           completion: { isAllow in
                            if isAllow {
                                let vc = FoodDiaryParentVC.instantiate(fromAppStoryboard: .goal)
                                vc.hidesBottomBarWhenPushed = true
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                    vc.manageSelection(index: 0)
                                }
                                if let vc2 = UIApplication.topViewController() {
                                    vc2.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            else {
                                PlanManager.shared.alertNoSubscription()
                            }
                        })
                        
                        break
                    case .FoodDiaryMonth:
                        
                        PlanManager.shared.isAllowedByPlan(type: .activity_logs,
                                                           sub_features_id: GoalType.Diet.rawValue,
                                                           completion: { isAllow in
                            if isAllow {
                                let vc = FoodDiaryParentVC.instantiate(fromAppStoryboard: .goal)
                                vc.hidesBottomBarWhenPushed = true
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                    vc.manageSelection(index: 1)
                                }
                                if let vc2 = UIApplication.topViewController() {
                                    vc2.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            else {
                                PlanManager.shared.alertNoSubscription()
                            }
                        })
                        
                        break
                    case .FoodDiaryDayInsight:
                        
                        PlanManager.shared.isAllowedByPlan(type: .activity_logs,
                                                           sub_features_id: GoalType.Diet.rawValue,
                                                           completion: { isAllow in
                            if isAllow {
                                let vc = FoodDiaryDetailVC.instantiate(fromAppStoryboard: .goal)
                                let dateFormatter           = DateFormatter()
                                dateFormatter.dateFormat    = DateTimeFormaterEnum.yyyymmdd.rawValue
                                dateFormatter.timeZone      = .current
                                vc.insight_date             = dateFormatter.string(from: Date())
                                dateFormatter.dateFormat    = DateTimeFormaterEnum.MMMDD.rawValue
                                dateFormatter.timeZone      = .current
                                vc.dateMonth                = dateFormatter.string(from: Date())
                                vc.hidesBottomBarWhenPushed = true
                                if let vc2 = UIApplication.topViewController() {
                                    vc2.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            else {
                                PlanManager.shared.alertNoSubscription()
                            }
                        })
                        
                        break
                    case .LogFood:
                        
                        PlanManager.shared.isAllowedByPlan(type: .activity_logs,
                                                           sub_features_id: GoalType.Diet.rawValue,
                                                           completion: { isAllow in
                            if isAllow {
                                let vc = FoodLogVC.instantiate(fromAppStoryboard: .goal)
                                vc.hidesBottomBarWhenPushed = true
                                
                                if let vc2 = UIApplication.topViewController() {
                                    vc2.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            else {
                                PlanManager.shared.alertNoSubscription()
                            }
                        })
                        
                        break
                    case .LogFoodSuccess:
                        ///No Deeplink
                        break
                    case .HelpSupportFaq:
                        
                        let vc = HelpAndSupportVC.instantiate(fromAppStoryboard: .setting)
                        vc.hidesBottomBarWhenPushed = true
                        if let vc2 = UIApplication.topViewController() {
                            vc2.navigationController?.pushViewController(vc, animated: true)
                        }
                        break
                    case .FaqQuery:
                        let vc = AddSupportQuestionPopupVC.instantiate(fromAppStoryboard: .setting)
                        vc.modalPresentationStyle   = .overFullScreen
                        vc.modalTransitionStyle     = .crossDissolve
                        
                        vc.hidesBottomBarWhenPushed = true
                        if let vc2 = UIApplication.topViewController() {
                            vc2.navigationController?.present(vc, animated: true, completion: nil)
                        }
                        break
                    case .NotificationList:
                        
                        let vc = NotificationVC.instantiate(fromAppStoryboard: .setting)
                        vc.isEdit = true
                        vc.hidesBottomBarWhenPushed = true
                        if let vc2 = UIApplication.topViewController() {
                            vc2.navigationController?.pushViewController(vc, animated: true)
                        }
                        break
                    case .IncidentDetails:
                        ///No Deeplink
                        break
                    case .UploadRecord:
                        PlanManager.shared.isAllowedByPlan(type: .add_records_history_records,
                                                           sub_features_id: "",
                                                           completion: { isAllow in
                            if isAllow{
                                let vc = UploadRecordVC.instantiate(fromAppStoryboard: .setting)
                                vc.hidesBottomBarWhenPushed = true
                                if let vc2 = UIApplication.topViewController() {
                                    vc2.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            else {
                                PlanManager.shared.alertNoSubscription()
                            }
                        })
                        break
                    case .BreathingVideo:
                        ///No Deeplink
                        break
                    case .CommentList:
                        ///No Deeplink
                        break
                    case .AddIncident:
                        break
                    case .MyAccount:
                        ///No Deeplink
                        break
                    case .MyProfile:
                        
                        let vc = ProfileVC.instantiate(fromAppStoryboard: .setting)
                        vc.hidesBottomBarWhenPushed = true
                        if let vc2 = UIApplication.topViewController() {
                            vc2.navigationController?.pushViewController(vc, animated: true)
                        }
                        break
                    case .EditProfile:
                        
                        let vc = EditProfileVC.instantiate(fromAppStoryboard: .setting)
                        vc.hidesBottomBarWhenPushed = true
                        if let vc2 = UIApplication.topViewController() {
                            vc2.navigationController?.pushViewController(vc, animated: true)
                        }
                        break
                    case .MyDevices:
                        
                        let vc = MyDevicesVC.instantiate(fromAppStoryboard: .setting)
                        vc.hidesBottomBarWhenPushed = true
                        if let vc2 = UIApplication.topViewController() {
                            vc2.navigationController?.pushViewController(vc, animated: true)
                        }
                        break
                    case .MyDeviceDetail:
                        ///No Deeplink
                        break
                    case .LogGoal:
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                            if let vc = UIApplication.topViewController() as? HomeVC{
                                vc.isOpenGoal = true
                                vc.isOpenGoalReadingKey = data["goal_key"].stringValue
                            }
                        }
                        
                        break
                    case .LogReading:
                        ///No Deeplink
                        break
                    case .GoalChart:
                        ///No Deeplink
                        break
                    case .ReadingChart:
                        ///No Deeplink
                        break
                    case .LoginWithPhone:
                        ///No Deeplink
                        break
                    case .LoginWithPassword:
                        ///No Deeplink
                        break
                    case .LoginOtp:
                        ///No Deeplink
                        break
                    case .SelectLanguage:
                        ///No Deeplink
                        break
                    case .LanguageList:
                        ///No Deeplink
                        break
                    case .SignUpWithPhone:
                        ///No Deeplink
                        break
                    case .SignUpOtp:
                        ///No Deeplink
                        break
                    case .AddAccountDetails:
                        ///No Deeplink
                        break
                    case .BookmarkList:
                        
                        PlanManager.shared.isAllowedByPlan(type: .bookmarks,
                                                           sub_features_id: "",
                                                           completion: { isAllow in
                            if isAllow {
                                let vc = BookmarkVC.instantiate(fromAppStoryboard: .engage)
                                vc.isEdit = true
                                vc.hidesBottomBarWhenPushed = true
                                if let vc2 = UIApplication.topViewController() {
                                    vc2.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            else {
                                PlanManager.shared.alertNoSubscription()
                            }
                        })
                        
                        break
                    case .ReportComment:
                        ///No Deeplink
                        break
                    case .AllBookmark:
                        ///No Deeplink
                        break
                    case .UseBiometric:
                        ///No Deeplink
                        break
                    case .SetUpDrugs:
                        
                        PlanManager.shared.isAllowedByPlan(type: .add_medication,
                                                           sub_features_id: "",
                                                           completion: { isAllow in
                            if isAllow {
                                let vc = AddPrescriptionVC.instantiate(fromAppStoryboard: .auth)
                                vc.hidesBottomBarWhenPushed = true
                                vc.isEdit = true
                                if let vc2 = UIApplication.topViewController() {
                                    vc2.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            else {
                                PlanManager.shared.alertNoSubscription()
                            }
                        })
                        
                        break
                    case .SearchDrugs:
                        ///No Deeplink
                        break
                    case .SetUpGoalsReadings:
                        let vc = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
                        vc.isEdit = true
                        vc.hidesBottomBarWhenPushed = true
                        vc.isEdit = true
                        if let vc2 = UIApplication.topViewController() {
                            vc2.navigationController?.pushViewController(vc, animated: true)
                        }
                        break
                    case .SelectGoals:
                        ///No Deeplink
                        break
                    case .SelectReadings:
                        ///No Deeplink
                        break
                    case .SelectLocation:
                        
                        let vc = SetLocationVC.instantiate(fromAppStoryboard: .auth)
                        vc.isEdit = true
                        vc.hidesBottomBarWhenPushed = true
                        if let vc2 = UIApplication.topViewController() {
                            vc2.navigationController?.pushViewController(vc, animated: true)
                        }
                        break
                    case .DoctorProfile:
                        ///No Deeplink
                        break
                    case .ForgotPasswordPhone:
                        ///No Deeplink
                        break
                    case .ForgotPasswordOtp:
                        ///No Deeplink
                        break
                    case .CreatePassword:
                        ///No Deeplink
                        break
                    case .CreateProfileFlow:
                        
                        let vc = SetLocationVC.instantiate(fromAppStoryboard: .auth)
                        vc.isEdit = false
                        vc.hidesBottomBarWhenPushed = true
                        if let vc2 = UIApplication.topViewController() {
                            vc2.navigationController?.pushViewController(vc, animated: true)
                        }
                        break
                        
                    case .CatSurvey:
                        
                        GlobalAPI.shared.get_cat_surveyAPI { [weak self] (isDone, object, id) in
                            guard let self = self else {return}
                            if isDone {
                                PlanManager.shared.isAllowedByPlan(type: .reading_logs,
                                                                   sub_features_id: ReadingType.cat.rawValue,
                                                                   completion: { [weak self] isAllow in
                                    guard let self = self else {return}
                                    
                                    if isAllow {
                                        SurveySparrowManager.shared.startSurveySparrow(token: object.surveyId)
                                        SurveySparrowManager.shared.completionHandler = { [weak self] Response in
                                            guard let self = self else {return}
                                            print(Response as Any)
                                            
                                            
                                            GlobalAPI.shared.add_cat_surveyAPI(cat_survey_master_id: object.catSurveyMasterId,
                                                                               survey_id: object.surveyId,
                                                                               Score: String(Response!["score"] as? Int ?? 0), response: Response!["response"] as! [[String: Any]]) { [weak self]  (isDone, msg) in
                                                guard let _ = self else {return}
                                                
                                                
                                                if isDone {
                                                    var params = [String: Any]()
                                                    params[AnalyticsParameters.reading_name.rawValue]   = object.readingName
                                                    params[AnalyticsParameters.reading_id.rawValue]     = object.readingsMasterId
                                                    
                                                    FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATED_READING,
                                                                             screen: .LogReading,
                                                                             parameter: params)
                                                }
                                            }
                                        }
                                    }
                                    else {
                                        PlanManager.shared.alertNoSubscription()
                                    }
                                })
                                
                            }
                        }
                        break
                        
                    case .ExercisePlanDayDetailBreathing:
                        break
                    case .ExercisePlanDayDetailExercise:
                        break
                    case .SetHeightWeight:
                        break
                    case .AskAnExpert:
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            if let tab = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first as? UITabBarController {
                                tab.selectedIndex = 2
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                    if let vc = (tab.viewControllers?[2] as? UINavigationController)?.viewControllers.first as? EngageParentVC {
                                        vc.manageSelection(type: .AskExpert)
                                    }
                                }
                            }
                        }
                        break
                    case .QuestionDetails:
                        let askExpertQuestionDetailsVC = AskExpertQuestionDetailsVC.instantiate(fromAppStoryboard: .engage)
                        askExpertQuestionDetailsVC.contentMasterId = data["content_master_id"].stringValue
                        askExpertQuestionDetailsVC.hidesBottomBarWhenPushed = true
                        if let vc = UIApplication.topViewController() {
                            vc.navigationController?.pushViewController(askExpertQuestionDetailsVC, animated: true)
                        }
                        break
                    case .ExerciseVideo:
                        break
                    case .BookAppointment:
                        
                        //                    https://mytatva.page.link/?link=https://mytatva.com/&operation=screen_nav&screen_name=BookAppointment&selection=HC&apn=com.mytatva.patient&ibi=com.mytatva.patient
                        
                        PlanManager.shared.isAllowedByPlan(type: .book_appointments,
                                                           sub_features_id: "",
                                                           completion: { isAllow in
                            if isAllow {
                                let vc = BookAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
                                vc.selectedFor = .D
                                if data["selection"].stringValue == "HC" {
                                    vc.selectedFor = .H
                                }
                                vc.hidesBottomBarWhenPushed = true
                                if let vc2 = UIApplication.topViewController() {
                                    vc2.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            else {
                                PlanManager.shared.alertNoSubscription()
                            }
                        })
                        break
                    case .AppointmentList:
                        
                        //                    https://mytatva.page.link/?link=https://mytatva.com/&operation=screen_nav&screen_name=AppointmentList&selection=HC&apn=com.mytatva.patient&ibi=com.mytatva.patient
                        
                        let vc = AppointmentsHistoryVC.instantiate(fromAppStoryboard: .setting)
                        vc.isFromDeelink = true
                        vc.selectedFor = .D
                        if data["selection"].stringValue == "HC" {
                            vc.selectedFor = .H
                        }
                        vc.isForList = true
                        vc.hidesBottomBarWhenPushed = true
                        if let vc2 = UIApplication.topViewController() {
                            vc2.navigationController?.pushViewController(vc, animated: true)
                        }
                        break
                    case .AppointmentHistory:
                        break
                    case .ChatBot:
                        break
                    case .ChatList:
                        break
                    case .AddAddress:
                        break
                    case .AddPatientDetails:
                        break
                    case .BookLabtestAppointmentReview:
                        break
                    case .HealthPackageList:
                        break
                    case .BookLabtestAppointmentSuccess:
                        break
                    case .LabtestCart:
                        break
                    case .LabtestDetails:
                        let vc = LabTestDetailsVC.instantiate(fromAppStoryboard: .carePlan)
                        vc.lab_test_id = data["lab_test_id"].stringValue
                        vc.hidesBottomBarWhenPushed = true
                        
                        if let vc2 = UIApplication.topViewController() {
                            vc2.navigationController?.pushViewController(vc, animated: true)
                        }
                        break
                    case .LabtestList:
                        break
                    case .AllTestPackageList:
                        break
                    case .LabtestOrderDetails:
                        break
                    case .SelectPatient:
                        break
                    case .SelectAddress:
                        break
                    case .SelectLabtestAppointmentDateTime:
                        break
                    case .MyTatvaPlans:
                        //                        let vc = PlanParentVC.instantiate(fromAppStoryboard: .setting)
                        //vc.selectedType = .Records
                        let vc = BCPCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
                        vc.hidesBottomBarWhenPushed = true
                        if let vc2 = UIApplication.topViewController() {
                            vc2.navigationController?.pushViewController(vc, animated: true)
                        }
                        break
                        
                    case .MyTatvaPlanDetail:
                        break
                    case .MyTatvaIndividualPlan:
                        break
                    case .MyTatvaIndividualPlanDetail:
                        break
                        
                    case .Menu:
                        break
                    case .AccountDelete:
                        break
                    case .VideoPlayer:
                        break
                    case .ExerciseViewAll:
                        break
                    case .NotificationSettings:
                        break
                    case .ProfileCompleteSuccess:
                        break
                    case .SearchFood:
                        break
                    case .AnswerDetails:
                        break
                    case .PostQuestion:
                        break
                    case .SubmitAnswer:
                        break
                        
                    case .HistoryIncident:
                        PlanManager.shared.isAllowedByPlan(type: .incident_records_history,
                                                           sub_features_id: "",
                                                           completion: { isAllow in
                            if isAllow{
                                let vc = HistoryParentVC.instantiate(fromAppStoryboard: .setting)
                                vc.selectedType = .Incident
                                vc.hidesBottomBarWhenPushed = true
                                if let vc2 = UIApplication.topViewController() {
                                    vc2.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        })
                        break
                        
                    case .HistoryRecord:
                        PlanManager.shared.isAllowedByPlan(type: .add_records_history_records,
                                                           sub_features_id: "",
                                                           completion: { isAllow in
                            if isAllow{
                                let vc = HistoryParentVC.instantiate(fromAppStoryboard: .setting)
                                vc.selectedType = .Records
                                vc.hidesBottomBarWhenPushed = true
                                if let vc2 = UIApplication.topViewController() {
                                    vc2.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        })
                        break
                    case .HistoryPayment:
                        PlanManager.shared.isAllowedByPlan(type: .history_payments,
                                                           sub_features_id: "",
                                                           completion: { isAllow in
                            if isAllow{
                                let vc = HistoryParentVC.instantiate(fromAppStoryboard: .setting)
                                vc.selectedType = .Payments
                                vc.hidesBottomBarWhenPushed = true
                                if let vc2 = UIApplication.topViewController() {
                                    vc2.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        })
                        break
                        
                    case .HistoryTest:
                        Settings().isHidden(setting: .hide_diagnostic_test) { isHidden in
                            if !isHidden {
                                let vc = HistoryParentVC.instantiate(fromAppStoryboard: .setting)
                                vc.selectedType = .Tests
                                vc.hidesBottomBarWhenPushed = true
                                if let vc2 = UIApplication.topViewController() {
                                    vc2.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                        break
                    case .RegisterSuccess:
                        break
                    case .AppointmentConfirmed:
                        break
                        
                    case .DietPlan:
                        break
                        
                    case .none:
                        break
                    case .LoginSignup:
                        break
                    case .SelectRole:
                        break
                    case .LinkDoctor:
                        break
                    case .LearnToConnectSmartScale:
                        break
                    case .SearchSelectSmartScale:
                        break
                    case .MeasureSmartScaleReadings:
                        break
                    case .SmartScaleReadingAnalysis:
                        break
                    case .DoYouHaveDevice:
                        break
                    case .ConnectDevice:
                        break
                    case .Walkthrough:
                        break
                        
                    case .BcpList:
                        break
                    case .BcpDetails:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            ApiManager.shared.makeRequest(method: .patient_plans(.check_is_plan_purchased), parameter: ["plan_master_id":data["plan_master_id"].stringValue]) { [weak self] result in
                                guard let self = self else { return }
                                switch result{
                                case.success(let apiResponse):
                                    
                                    switch apiResponse.apiCode {
                                    case .success:
                                        print(apiResponse.data)
                                        
                                        let planDetails = PlanDetail(fromJson: apiResponse.data)
                                        
                                        if !planDetails.patientPlanRelId.isEmpty && planDetails.planType == kIndividual {
                                            let vc = PurchsedCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
                                            vc.viewModel.planDetails = planDetails
                                            vc.isBack = true
                                            if let vc2 = UIApplication.topViewController() {
                                                vc2.navigationController?.pushViewController(vc, animated: true)
                                            }
                                        }else {
                                            GlobalAPI.shared.planDetailsAPI(plan_id: planDetails.planMasterId,
                                                                            durationType: planDetails.enableRentBuy ? planDetails.planType == kIndividual ? kRent : nil : nil,
                                                                            patientPlanRelId: planDetails.patientPlanRelId,
                                                                            withLoader: true) { [weak self] isDone, object1, msg in
                                                guard let self = self else {return}
                                                if isDone {
                                                    let vc = BCPCarePlanDetailVC.instantiate(fromAppStoryboard: .BCP_temp)
                                                    vc.plan_id              = planDetails.planMasterId
                                                    vc.viewModel.cpDetail   = object1
                                                    vc.patientPlanRelId     = planDetails.patientPlanRelId
                                                    if let vc2 = UIApplication.topViewController() {
                                                        vc2.navigationController?.pushViewController(vc, animated: true)
                                                    }
                                                }
                                            }
                                        }
                                        
                                    default:
                                        Alert.shared.showSnackBar(apiResponse.message)
                                    }
                                    
                                    print(apiResponse.data)
                                case .failure(let error):
                                    debugPrint("Error: ",error.localizedDescription)
                                }
                            }
                        }
                        break
                    case .BcpPurchasedDetails:
                        break
                    case .BcpDeviceDetails:
                        break
                    case .BcpHcServices:
                        break
                    case .BcpHcServiceSelectTimeSlot:
                        break
                    case .BcpPurchaseSuccess:
                        break
                    case .BcpOrderReview:
                        break
                    case .SelectAddressBottomSheet:
                        break
                    case .ConnectDeviceInfo:
                        break
                    case .CouponCodeList:
                        break
                    case .AppliedCouponCodeSuccess:
                        break
                        
                    case .ExerciseFeedback:
                        break
                    case .LocationPermission:
                        break
                    case .EnterLocationPinCode:
                        break
                    case .ConfirmLocationMap:
                        break
                    case .ExerciseMyRoutine:
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            if let tab = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first as? UITabBarController {
                                tab.selectedIndex = 3
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                    if let vc = UIApplication.topViewController() as? ExerciseParentVC {
                                        //                                        vc.manageSelection(type: .MyRoutine)
                                        /*if let screenSection = ScreenSection.init(rawValue: data["screen_section"].stringValue) {
                                         
                                         vc.screenSection = screenSection
                                         }*/
                                    }
                                }
                            }
                        }
                        break
                    case .EnterAddress:
                        break
                    }
                }
            }
            return type
        }
        return nil
    }
    
}


