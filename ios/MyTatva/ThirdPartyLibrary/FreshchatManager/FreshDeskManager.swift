//
//  File.swift
//  MyTatva
//
//  Created by Darshan Joshi on 14/12/21.
//

import Foundation
import UIKit

class FreshDeskManager: NSObject {

    static let shared : FreshDeskManager = FreshDeskManager()
    var btnChat = UIButton()
    var fchatConfig: FreshchatConfig!
    
    var kFCPropertyConversationID   = ""
    var kFCPropertyChannelID        = ""
    var kFCPropertyChannelName      = ""
    var health_coach_id             = ""
    
    deinit{
        self.removeFreshDeskObserver()
    }
    
    func initFreshchatSDK() {
        self.fchatConfig = FreshchatConfig.init(appID: "ba3cb466-dd9f-4c03-b9e9-2bd0646989dc",
                                                andAppKey: "2406dd59-8906-4de6-974e-71339d54ae44") //Enter your AppID and AppKey here
        
        self.fchatConfig.themeName                  = "CustomThemeFile"
        self.fchatConfig.domain                     = "msdk.in.freshchat.com"//msdk.freshchat.com
        self.fchatConfig.gallerySelectionEnabled    = true; // set FALSE to disable picture selection for messaging via gallery
        self.fchatConfig.cameraCaptureEnabled       = true; // set FALSE to disable picture selection for messaging via camera
        self.fchatConfig.teamMemberInfoVisible      = true; // set to FALSE to turn off showing a team member avatar. To customize the avatar shown, use the theme file
        self.fchatConfig.showNotificationBanner     = true; // set to FALSE if you don't want to show the in-app notification banner upon receiving a new message while the app is open
        self.fchatConfig.fileAttachmentEnabled      = true; //set to FALSE if you want to hide the response expectations for the Topics
        
        Freshchat.sharedInstance().initWith(self.fchatConfig)
        self.updateUser()
        
//        let message = "Your message here"let freshchatMessage = FreshchatMessage.init(message: message, andTag: "single_match_tag")
//        Freshchat.sharedInstance().send(freshchatMessage)

        DispatchQueue.main.async {
            if let data = DeviceManager.shared.deviceTokenData {
                Freshchat.sharedInstance().setPushRegistrationToken(data)
            }
        }

//        if Freshchat.sharedInstance().isFreshchatNotification(userInfo) {            Freshchat.sharedInstance().handleRemoteNotification(userInfo, andAppstate: application.applicationState)
//        }

    }
    
    func updateUser(){
        if UserModel.shared.patientId != nil {
            // Create a user object
            let user = FreshchatUser.sharedInstance();
            
            // To set an identifiable first name for the user
            user.firstName = UserModel.shared.name
            
            //To set user's email id
            user.email = UserModel.shared.email
            //To set user's phone number
            user.phoneCountryCode = UserModel.shared.countryCode
            user.phoneNumber = UserModel.shared.contactNo
            Freshchat.sharedInstance().setUser(user)
            //Freshchat.sharedInstance().setUserWithIdToken(UserModel.shared.patientId)
            
            //You can set custom user properties for a particular user
            Freshchat.sharedInstance().setUserPropertyforKey("patientId", withValue: UserModel.shared.patientId)
            Freshchat.sharedInstance().setUserPropertyforKey("name", withValue: UserModel.shared.name)
            //You can set user demographic information
            Freshchat.sharedInstance().setUserPropertyforKey("email", withValue: UserModel.shared.email)
            Freshchat.sharedInstance().setUserPropertyforKey("gender", withValue: UserModel.shared.gender)
            
//            if UserModel.shared.hcList != nil {
//                for item in UserModel.shared.hcList {
//                    let hc_name = item.firstName + " " + item.lastName
//                    if item.role.lowercased() == "Physiotherapist".lowercased() {
//                        Freshchat.sharedInstance().setUserPropertyforKey("physiotherapist", withValue: hc_name)
//                    }
//                    else if item.role.lowercased() == "Nutritionist".lowercased() {
//                        Freshchat.sharedInstance().setUserPropertyforKey("nutritionist", withValue: hc_name)
//                    }
//                }
//            }
            
            ///To lookup and restore user by external id and restore id:
            Freshchat.sharedInstance().identifyUser(withExternalID: UserModel.shared.patientId,
        restoreID: UserModel.shared.restoreId ?? "")
            //Freshchat.sharedInstance().identifyUser(withExternalID: "externalId", restoreID: "restoreId")
            ///To retrieve the restore id:
            
            ///To listen to restore id generated event:
            /// Register for local
            
//            notificationNotificationCenter.default.addObserver(self,selector: #selector(userRestoreIdReceived),name: NSNotification.Name(rawValue: FRESHCHAT_USER_RESTORE_ID_GENERATED),object: nil)
//
//            func userRestoreIdReceived() {
//                print("Your restore id is - " FreshchatUser.sharedInstance().restoreID)
//                print("Your query external id is - " FreshchatUser.sharedInstance().externalID)
//            }
            ///Unregister local
            //notificationNotificationCenter.default.removeObserver(FRESHCHAT_USER_RESTORE_ID_GENERATED)

        }
    }
    
    func addChatButton(vw: UIView){
        DispatchQueue.main.async {
            self.btnChat = UIButton()
            self.btnChat.setImage(UIImage(named: "chat_ic"), for: .normal)
            let width               = 80
            let height              = 80
            var bottomPadding       = 0
            if let tabVC = vw.parentViewController?.parent?.parent as? TabbarVC {
                bottomPadding = Int(tabVC.tabBar.frame.size.height)
            }
            
            self.btnChat.frame = CGRect(x: Int(ScreenSize.width) - width,
                                        y: Int(ScreenSize.height) - height - bottomPadding,
                                        width: width, height: height)
            if let view = vw.subviews[vw.subviews.count - 1] as? UIButton {
                if view.frame == self.btnChat.frame {
                    view.removeFromSuperview()
                }
            }
            vw.addSubview(self.btnChat)
            
            self.btnChat.addTapGestureRecognizer {
//                let content = UNMutableNotificationContent()
//                content.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
//                content.body = NSString.localizedUserNotificationString(forKey: "Test message", arguments: nil)
//                content.sound = UNNotificationSound.default
//                content.categoryIdentifier = "notify-test"
//
//                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
//                let request = UNNotificationRequest.init(identifier: "notify-test", content: content, trigger: trigger)
//
//                let center = UNUserNotificationCenter.current()
//                center.add(request)
                
                //FreshDeskManager.shared.showConversations()
                //                if let vc = UIApplication.topViewController() {
                //                    let vc1 = WebviewChatBotVC.instantiate(fromAppStoryboard: .setting)
                //                    vc1.hidesBottomBarWhenPushed = true
                //                    vc.navigationController?.pushViewController(vc1, animated: true)
                //
                //                }
                
                let vc = ChatHistoryListVC.instantiate(fromAppStoryboard: .setting)
                self.btnChat.hero.id        = "btnChat"
                vc.modalPresentationStyle   = .overFullScreen
                vc.modalTransitionStyle     = .crossDissolve
                UIApplication.topViewController()?.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func showConversations(tags: [String], screen: ScreenName){
        self.removeFreshDeskObserver()
        self.addFreshDeskObserver()
        
        Freshchat.sharedInstance().identifyUser(withExternalID: UserModel.shared.patientId,
                                                restoreID: UserModel.shared.restoreId ?? "")
        
        GlobalAPI.shared.link_healthcoach_chatAPI(health_coach_id: self.health_coach_id,
                                                  restore_id: UserModel.shared.restoreId ?? "") { [weak self] isDone in
            guard let _ = self else {return}
            
            if isDone {
            }
        }
        
        let option = ConversationOptions()
//        option.filter(byTags: tags, withTitle: "Welcome to the chat between you and your healthcoach")
        option.filter(byTags: tags, withTitle: "MyTatva Health Coach")
        
        if let vc = UIApplication.topViewController() {
            Freshchat.sharedInstance().initWith(self.fchatConfig)
            Freshchat.sharedInstance().showConversations(vc, with: option)
            
            var params = [String: Any]()
            params[AnalyticsParameters.health_coach_id.rawValue]   = self.health_coach_id
            FIRAnalytics.FIRLogEvent(eventName: .USER_CHAT_WITH_HC,
                                     screen: screen,
                                     parameter: nil)
        }
    }
    
    func sendMessage(msg: String, tag: String){
        let message = msg
        let freshchatMessage = FreshchatMessage.init(message: message, andTag: tag)
        Freshchat.sharedInstance().send(freshchatMessage)
    }
}

extension FreshDeskManager {
    
    @objc func userActionEvent(_ notification: Notification)    {
        var fcEvent : FreshchatEvent? = nil
        fcEvent = (notification.userInfo?["event"] as? FreshchatEvent)
        print ("🔵🔵🔵🔵🔵🔵🔵🔵🔵 Event: \(JSON(fcEvent?.getName() ?? "").stringValue) and properties - \(JSON(fcEvent?.properties ?? "")) 🔵🔵🔵🔵🔵🔵🔵🔵🔵")
        //Check with available event enum
        
        /*
         if fcEvent?.name == FCEventConversationOpen {
             //Log existing event meta / properties
             print ("FCEventConversationOpen Event properties - \(JSON(fcEvent?.properties ?? ""))")
             
             if let val = fcEvent?.properties?["FCPropertyConversationID"] {
                 self.kFCPropertyConversationID = JSON(val).stringValue
             }
             if let val = fcEvent?.properties?["FCPropertyChannelID"] {
                 self.kFCPropertyChannelID = JSON(val).stringValue
             }
             if let val = fcEvent?.properties?["FCPropertyChannelName"] {
                 self.kFCPropertyChannelName = JSON(val).stringValue
             }
         }
         */
        
        if fcEvent?.name == FCEventMessageSent {
            //Log existing event meta / properties
            if let val = fcEvent?.properties?["FCPropertyConversationID"] {
                self.kFCPropertyConversationID = JSON(val).stringValue
            }
            if let val = fcEvent?.properties?["FCPropertyChannelID"] {
                self.kFCPropertyChannelID = JSON(val).stringValue
            }
            if let val = fcEvent?.properties?["FCPropertyChannelName"] {
                self.kFCPropertyChannelName = JSON(val).stringValue
            }
        }
    }
    
    @objc func userRestoreIdReceived() {
        if UserModel.isUserLoggedIn && UserModel.isVerifiedUser {
            let externalID  = FreshchatUser.sharedInstance().externalID!
            let restoreID   = FreshchatUser.sharedInstance().restoreID!
            
            print("Your restore id is - \(restoreID)")
            print("Your query external id is - \(externalID)")
            
            Freshchat.sharedInstance().identifyUser(withExternalID: externalID, restoreID: restoreID)
            
            GlobalAPI.shared.link_healthcoach_chatAPI(health_coach_id: self.health_coach_id,
                                                      restore_id: restoreID) { [weak self] isDone in
                guard let _ = self else {return}
                if isDone {
                    GlobalAPI.shared.getPatientDetailsAPI { [weak self] isDone in
                        guard let _ = self else {return}
                    }
                }
            }
        }
    }
    
    func addFreshDeskObserver(){
        NotificationCenter.default.addObserver(self,selector: #selector(userActionEvent(_:)),name: NSNotification.Name(rawValue: FRESHCHAT_EVENTS),object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(userRestoreIdReceived),name: NSNotification.Name(rawValue: FRESHCHAT_USER_RESTORE_ID_GENERATED),object: nil)

    }
    
    func removeFreshDeskObserver(){
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: FRESHCHAT_EVENTS), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: FRESHCHAT_USER_RESTORE_ID_GENERATED), object: nil)
    }
}
