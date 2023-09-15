//
//  NotificationService.swift
//  MyTatvaNotificationService
//
//  Created by Darshan Joshi on 29/10/21.
//

import UserNotifications


class NotificationService: UNNotificationServiceExtension {
    
    //WEXPushNotificationService {

    let service = WEXPushNotificationService()
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        guard let bestAttemptContent = self.bestAttemptContent else { return }

//        bestAttemptContent?.title = bestAttemptContent?.body ?? ""
//        bestAttemptContent?.body = bestAttemptContent?.title ?? ""
//
//        if bestAttemptContent?.title.count ?? 0 > 60{
//            bestAttemptContent?.title = bestAttemptContent?.body ?? ""
//            bestAttemptContent?.body = bestAttemptContent?.title ?? ""
//        }
        if let apsPayload = request.content.userInfo["aps"] as? [String:Any] {
            if let alert = apsPayload["alert"] as? [String:Any] {
                bestAttemptContent.title = "\(alert["title"] as! String)"
                bestAttemptContent.body = "\(alert["body"] as! String)"
            }
            
            if let  category = apsPayload["category"] as? String{
                if let userInfo = request.content.userInfo as? [String:Any]{
                    
                    if let expandableDetails = userInfo["expandableDetails"] as? [String:Any]{
                        
                        guard let attachmentURL = expandableDetails["image"] as? String else {
                            contentHandler(bestAttemptContent)
                            return
                        }
                        
                        do {
                            let imageData = try Data(contentsOf: URL(string: attachmentURL)!)
                            guard let attachment = UNNotificationAttachment.download(imageFileIdentifier: "image.jpg", data: imageData, options: nil) else {
                                contentHandler(bestAttemptContent)
                                return
                            }
                            bestAttemptContent.attachments = [attachment]
                            contentHandler(bestAttemptContent.copy() as! UNNotificationContent)
                        } catch {
                            contentHandler(bestAttemptContent)
                            print("Unable to load data: \(error)")
                        }
                    }
                    self.registerCTA(category: category,
                                     userInfo: userInfo,
                                     dismissActiontitle: "Dismiss")
                }
            }
        }
        
        let requestCopy = UNNotificationRequest(identifier: request.identifier,
                                                content: bestAttemptContent,
                                                trigger: request.trigger)
        service.didReceive(requestCopy, withContentHandler: contentHandler)
        //service.didReceive(request, withContentHandler: contentHandler)
        //contentHandler(bestAttemptContent)

        /*
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
         */
        
        /*
         if let bestAttemptContent = bestAttemptContent {
             // Modify the notification content here...
             bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
             
             // Save notification data to UserDefaults
             let data = bestAttemptContent.userInfo as NSDictionary
             let pref = UserDefaults.init(suiteName: "group.id.gits.notifserviceextension")
             pref?.set(data, forKey: "NOTIF_DATA")
             pref?.synchronize()
             
             guard let dict = bestAttemptContent.userInfo["expandableDetails"] as? [String:Any] else {
                 contentHandler(bestAttemptContent)
                 return
             }
             
             if let attachmentURL = dict["image"] as? String {
                 do {
                     let imageData = try Data(contentsOf: URL(string: attachmentURL)!)
                     guard let attachment = UNNotificationAttachment.download(imageFileIdentifier: "image.jpg", data: imageData, options: nil) else {
                         contentHandler(bestAttemptContent)
                         return
                     }
                     bestAttemptContent.attachments = [attachment]
                     contentHandler(bestAttemptContent.copy() as! UNNotificationContent)
                 } catch {
                     contentHandler(bestAttemptContent)
                     print("Unable to load data: \(error)")
                 }
             }
         }
         */
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    func registerCTA(category:String,
                         userInfo:[String:Any],
                         dismissActiontitle:String?){
        var actions:[UNNotificationAction] = []
        if let expandableDetails = userInfo["expandableDetails"] as? [String:Any]{
            for i in 1...3{
                if let ctaDetails = expandableDetails["cta\(i)"] as? [String:Any]{
                    if let templateId = ctaDetails["templateId"] as? String,
                       let actionText = ctaDetails["actionText"] as? String{
                        let actionObject = UNNotificationAction(identifier: templateId,
                                                                title: actionText,
                                                                options: UNNotificationActionOptions(rawValue: 0))
                        actions.append(actionObject)
                    }
                }
            }
        }
        
        // add dimiss button if required
        if let dismissTitle = dismissActiontitle{
            let actionObject = UNNotificationAction(identifier: "dismiss" // This identifier can be anything
                                                    , title: dismissTitle,
                                                    options: UNNotificationActionOptions(rawValue: 0))
            actions.append(actionObject)
        }
        
        // Define the notification type
        let customCategory =
            UNNotificationCategory(identifier:category,
                                   actions: actions,
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([customCategory])
        
    }
}

extension UNNotificationAttachment {
    
    static func download(imageFileIdentifier: String, data: Data, options: [NSObject : AnyObject]?)
        -> UNNotificationAttachment? {
            let fileManager = FileManager.default
            if let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.mytatva") {
                do {
                    let newDirectory = directory.appendingPathComponent("Images")
                    if !fileManager.fileExists(atPath: newDirectory.path) {
                        try? fileManager.createDirectory(at: newDirectory, withIntermediateDirectories: true, attributes: nil)
                    }
                    let fileURL = newDirectory.appendingPathComponent(imageFileIdentifier)
                    do {
                        try data.write(to: fileURL, options: [])
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                    let pref = UserDefaults(suiteName: "group.com.mytatva")
                    pref?.set(data, forKey: "NOTIF_IMAGE")
                    pref?.synchronize()
                    let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
                    return imageAttachment
                } catch let error {
                    print("Error: \(error)")
                }
            }
            return nil
    }
}
