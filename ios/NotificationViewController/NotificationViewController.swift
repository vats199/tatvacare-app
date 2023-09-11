//
//  NotificationViewController.swift
//  NotificationViewController
//
//  Created by Darshan Joshi on 29/10/21.
//

import UIKit
import UserNotifications
import UserNotificationsUI


class NotificationViewController: WEXRichPushNotificationViewController {

    @IBOutlet var lblTitle  : UILabel?
    @IBOutlet var lblDesc   : UILabel?
    @IBOutlet var imgTitle  : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    override func didReceive(_ notification: UNNotification) {
        self.lblTitle?.text = notification.request.content.body + "ok"
        self.lblDesc?.text = notification.request.content.body + "dummy"
    }

}
