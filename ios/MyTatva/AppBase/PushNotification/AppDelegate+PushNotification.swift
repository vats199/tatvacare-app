//
//  AppDelegate+PushNotification.swift
//  MVVMBasicStructure
//
//  Created by on 28/02/23.
//

import UIKit
import UserNotificationsUI
import UserNotifications

enum PushType {
    case willPresent
    case didreceive
    case didreceiveFetch
}

//MARK: - Device Token
extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //Set token for push
        DeviceManager.shared.deviceTokenData = deviceToken
        FreshDeskManager.shared.initFreshchatSDK()
        
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        DeviceManager.shared.deviceToken = deviceTokenString
        debugPrint(deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Device Token Not Found \(error)")
    }
}

//MARK: - Push Notification
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func registerForNotification() {
        //For device token and push notifications.
        UIApplication.shared.registerForRemoteNotifications()
        
        let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
            if ((error != nil)) { UIApplication.shared.registerForRemoteNotifications() }
            else {
                
            }
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if Freshchat.sharedInstance().isFreshchatNotification(notification.request.content.userInfo) {   Freshchat.sharedInstance().handleRemoteNotification(notification.request.content.userInfo, andAppstate: UIApplication.shared.applicationState)
            //Handled for freshchat notifications
            completionHandler([.sound, .banner])
        }
        else {
            self.handlePushNotification(userInfo: JSON(notification.request.content.userInfo),
                                        type: .willPresent)

            completionHandler([.sound, .banner])

        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if Freshchat.sharedInstance().isFreshchatNotification(response.notification.request.content.userInfo) {
            
            Alert.shared.showAlert(message: "didReceive") { Bool in
            }
            
            Freshchat.sharedInstance().handleRemoteNotification(response.notification.request.content.userInfo, andAppstate: UIApplication.shared.applicationState)
        //Handled for freshchat notifications
            //FreshDeskManager.shared.showConversations()
            completionHandler()
        }
        else {
            if  response.notification.request.content.categoryIdentifier  ==  "text_input" {
                    if let textResponse =  response as? UNTextInputNotificationResponse {
                        let sendText =  textResponse.userText
                        print("Received text message: \(sendText)")
                    }
                }
            
            self.handlePushNotification(userInfo: JSON(response.notification.request.content.userInfo),
                                        type: .didreceive)
            completionHandler()
        }
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        self.handlePushNotification(userInfo: JSON(userInfo),
                                    type: .didreceiveFetch)
    }
    
    //------------------------------------------------------
    //TODO : This is custom notification method
    
    func handlePushNotification(userInfo : JSON,
                                        type: PushType) {
        print(userInfo)
        
        func updateAppOnPush(){
            //            if Freshchat.sharedInstance().isFreshchatNotification(userInfo) {            Freshchat.sharedInstance().handleRemoteNotification(userInfo, andAppstate: application.applicationState)}
//            UserDefaultsConfig.badgeCount += 1
//            UIApplication.shared.applicationIconBadgeNumber = 0
            if JSON(userInfo["source"].stringValue) == "webengage" {
//                UserDefaultsConfig.badgeCount = 0
//                UIApplication.shared.applicationIconBadgeNumber = UserDefaultsConfig.badgeCount
                                           
                let expandableDetails   = JSON(userInfo["expandableDetails"])
                let image               = expandableDetails["image"].stringValue
                let notification_id     = JSON(userInfo["notification_id"]).stringValue
                let cta_list            = JSON(userInfo["cta_list"].arrayValue)
                var deeplink            = ""
                if cta_list.count > 0 {
                    deeplink = cta_list[0]["mainCta"]["deeplink"].stringValue
                }
                
                if deeplink.trim() == "" {
                    deeplink = expandableDetails["cta1"]["actionLink"].stringValue
                }
                
                let title               = JSON(userInfo["aps"]["alert"]["title"]).stringValue
                let msg                 = JSON(userInfo["aps"]["alert"]["body"]).stringValue
                
                //API CALL ON PUSH RECEIVED
                GlobalAPI.shared.update_notificationAPI(image_url: image,
                                                        we_notification_id: notification_id,
                                                        deep_link: deeplink,
                                                        title: title,
                                                        mesage: msg,
                                                        data: userInfo.dictionaryObject ?? [:]) { [weak self] isDone in
                    guard let _ = self else {return}
                    if isDone {
                        
                    }
                }
                            
                            /*
                             
                             Webengage push response:
                             ============================================================
                             {
                               "experiment_id" : "67j385||j70b4ei23db9bf_07f24668-9307-468a-a32f-b51f8b14d6bf#1:1635509317860",
                               "customData" : [
                                 {
                                   "key" : "provider",
                                   "value" : "APNS"
                                 }
                               ],
                               "notification_id" : "2jahbfk",
                               "cta_list" : [
                                 {
                                   "mainCta" : {
                                     "deeplink" : "",
                                     "ctaId" : "main"
                                   }
                                 }
                               ],
                               "aps" : {
                                 "content-available" : 1,
                                 "sound" : "default",
                                 "alert" : {
                                   "title" : "This is title",
                                   "body" : "This is demo app description to check how it looks..sofjsdljlds"
                                 },
                                 "category" : "19db52de",
                                 "mutable-content" : 1
                               },
                               "license_code" : "~2024baca",
                               "source" : "webengage",
                               "expandableDetails" : {
                                 "image" : "https:\/\/afiles.webengage.com\/~2024baca\/fde1b665-24f3-405e-af7b-0c763475bbd2.jpg",
                                 "message" : "This is demo app description to check how it looks..sofjsdljlds",
                                 "style" : "BIG_PICTURE",
                                 "category" : "19db52de",
                                 "ratingScale" : 5
                               }
                             }
                             ============================================================
                             
                             {
                               "aps" : {
                                 "category" : "18dfbbcc",
                                 "mutable-content" : 1,
                                 "alert" : {
                                   "body" : "This is message",
                                   "title" : "This is title"
                                 },
                                 "sound" : "default",
                                 "content-available" : 1
                               },
                               "experiment_id" : "~10l170j||~4j7i6g3d1b829ec_ed218fea-e190-4a00-ab52-01ab21803b15#11:1637919896445",
                               "source" : "webengage",
                               "expandableDetails" : {
                                 "category" : "18dfbbcc",
                                 "style" : "BIG_TEXT",
                                 "cta1" : {
                                   "actionLink" : "deepLink",
                                   "actionText" : "Yes",
                                   "templateId" : "56ghe26",
                                   "id" : "bb4b8697"
                                 },
                                 "message" : "This is message",
                                 "ratingScale" : 5
                               },
                               "notification_id" : "4he01dd",
                               "customData" : [
                                 {
                                   "key" : "test_key",
                                   "value" : "Test Value"
                                 },
                                 {
                                   "key" : "provider",
                                   "value" : "APNS"
                                 }
                               ],
                               "license_code" : "311c4c4b",
                               "cta_list" : [
                                 {
                                   "1820b988" : {
                                     "deeplink" : "deepLink",
                                     "ctaId" : "1820b988"
                                   }
                                 },
                                 {
                                   "56ghe26" : {
                                     "deeplink" : "deepLink",
                                     "ctaId" : "bb4b8697"
                                   }
                                 }
                               ]
                             }
                             */
                        }
                        else {
//                            UserDefaultsConfig.badgeCount -= 1
//                            UIApplication.shared.applicationIconBadgeNumber = UserDefaultsConfig.badgeCount
                            
                            //Regular push payload
                            let flag = JSON(userInfo["flag"].stringValue)
                            let goal_master_id = JSON(userInfo["message"]["other_details"]["goal_master_id"].stringValue)
                            let key = JSON(userInfo["message"]["other_details"]["key"]).stringValue
                            
                            UIApplication.shared.setHome()
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                                if let vc = UIApplication.topViewController() as? HomeVC{
                                    
                                    switch flag {
                                    case "LogGoal":
                                        vc.isOpenGoal = true
                                        vc.isOpenGoalReadingKey = key
                                        break
                                        
                                    case "LogReading":
                                        vc.isOpenReading = true
                                        vc.isOpenGoalReadingKey = key
                                        break
                                        
                                    case "DoctorAppointment":
                                        let navVC = AppointmentsHistoryVC.instantiate(fromAppStoryboard: .setting)
                                        navVC.isForList = true
                                        navVC.hidesBottomBarWhenPushed = true
                                        vc.navigationController?.pushViewController(navVC, animated: true)
                                        break
                                        
                                    case "UpdateGoalValue":
                                        let navVC = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
                                        navVC.isEdit = true
                                        navVC.hidesBottomBarWhenPushed = true
                                        vc.navigationController?.pushViewController(navVC, animated: true)
                                        break
                                    
                                    case "HealthcoachTask":
                                        break
                                        
                                    case "HealthcoachContent", "HealthcoachAppointment":
                                        
                                        let message         = JSON(userInfo["message"])
                                        let other_details   = JSON(message["other_details"])
                                        let deepLink        = other_details["deep_link"].stringValue
                                        
                                        if let url = URL(string: deepLink) {
                                            let _ = DynamicLinks.dynamicLinks()
                                                .handleUniversalLink(url) { dynamiclink, error in
                                                    // ...
                                                    print("dynamiclink: \(dynamiclink)")
                                                    print("dynamiclink url: \(dynamiclink?.url)")
                                                    sceneDelegate.fetchDeepLinkData(link: dynamiclink?.url)
                                                }
                                        }
                                        
                                        break
                                    default:
                                        break
                                    }
                                }
                            }
//
                            /*
                             {
                               "aps" : {
                                 "alert" : {
                                   "body" : "Update your exercise logs",
                                   "title" : "MyTatva"
                                 }
                               },
                               "flag" : "LogGoal",
                               "title" : "MyTatva",
                               "body" : "Update your exercise logs",
                               "message" : {
                                 "other_details" : {
                                   "goal_master_id" : "25b7f7cc-1a16-11ec-9b7c-02004825dc14",
                                   "key" : "exercise"
                                 },
                                 "title" : "MyTatva",
                                 "message" : "Update your exercise logs",
                                 "flag" : "LogGoal"
                               }
                             }
                             */
                        }
        }
        
        if UserModel.isUserLoggedIn && UserModel.isVerifiedUser {
            UserModel.shared.retrieveUserData()
            switch type {
                
            case .willPresent:
                break
            case .didreceive:
                updateAppOnPush()
                break
            case .didreceiveFetch:
                updateAppOnPush()
                break
            }
        }
        
    }
    
    func showPushButtons(){
        let replyAction = UNTextInputNotificationAction(
            identifier: "text_input",
            title: "Reply on message",
            textInputButtonTitle: "Log",
            textInputPlaceholder: "Input text here")

        let pushNotificationButtons = UNNotificationCategory(
            identifier: "text_input",
            actions: [replyAction],
            intentIdentifiers: [],
            options: [])

        UNUserNotificationCenter.current().setNotificationCategories([pushNotificationButtons])
    }
}
