//
//  Alert.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 28/02/21.
//

import UIKit

class Alert {
    
    /// Shared instance
    static let shared = Alert()
    
    private let snackbar: TTGSnackbar = TTGSnackbar()
    
    ///Init
    private init() {
        
    }
}

// MARK: Snackbar
extension Alert {
    
    /// Show snack bar alert message
       ///
       /// - Parameters:
       ///   - message: Message for alert
       ///   - backGroundColor: Backgroud color for alert box
       ///   - duration: Alert display duration
       ///   - animation: Snack bar animation type
       func showSnackBar(_ message : String, isError: Bool = false, isBCP: Bool = false, duration : TTGSnackbarDuration = .long, animation : TTGSnackbarAnimationType = .slideFromTopBackToTop) {
           snackbar.message = message//.localized
           snackbar.duration = duration
           snackbar.messageTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           snackbar.messageTextFont = .customFont(ofType: .medium, withSize: 15)
           snackbar.layer.insertSublayer(snackbar.gradientLayer, at: 0)

        
           if isError && isBCP {
               snackbar.backgroundColor = UIColor.themeRedAlert
           } else if isBCP {
               snackbar.backgroundColor = UIColor.themeGreenAlert
           } else if isError {
               snackbar.backgroundColor = .themePurple
           } else {
               snackbar.backgroundColor = UIColor.themePurple
           }
           
           snackbar.layer.cornerRadius = 10
           
           snackbar.onTapBlock = { snackbar in
               snackbar.dismiss()
           }
           
           snackbar.onSwipeBlock = { (snackbar, direction) in
               if direction == .right {
                   snackbar.animationType = .slideFromLeftToRight
               } else if direction == .left {
                   snackbar.animationType = .slideFromRightToLeft
               } else if direction == .up {
                   snackbar.animationType = .slideFromTopBackToTop
               } else if direction == .down {
                   snackbar.animationType = .slideFromTopBackToTop
               }
               
               snackbar.dismiss()
           }
           snackbar.viewcornerRadius = 5.0
           
           // Change animation duration
           snackbar.animationDuration = 0.5
           
           // Animation type
           snackbar.animationType = animation
           snackbar.show()
       }
       
    
    
    func showSnackBarGreen(_ message : String, isError: Bool = false, duration : TTGSnackbarDuration = .middle, animation : TTGSnackbarAnimationType = .slideFromBottomToTop) {
        let snackbar = TTGSnackbar()
        snackbar.message = message//.localized
        snackbar.duration = duration
        snackbar.messageTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        snackbar.messageTextFont = .customFont(ofType: .medium, withSize: 15)
        snackbar.layer.insertSublayer(snackbar.gradientLayer, at: 0)

        if isError {
            snackbar.backgroundColor = UIColor.themeRedAlert
        } else {
            snackbar.backgroundColor = UIColor.themeGreenAlert
        }
        
        snackbar.layer.cornerRadius = 0
        
        
        snackbar.onTapBlock = { snackbar in
            snackbar.dismiss()
        }
        
        snackbar.onSwipeBlock = { (snackbar, direction) in
            if direction == .right {
                snackbar.animationType = .slideFromLeftToRight
            } else if direction == .left {
                snackbar.animationType = .slideFromRightToLeft
            } else if direction == .up {
                snackbar.animationType = .slideFromBottomToTop
            } else if direction == .down {
                snackbar.animationType = .slideFromTopToBottom
            }
            
            snackbar.dismiss()
        }
        snackbar.viewcornerRadius = 0.0
        
        // Change animation duration
        snackbar.animationDuration = 0.5
        snackbar.leftMargin = 0
        snackbar.rightMargin = 0
        // Animation type
        snackbar.animationType = animation
        snackbar.show()
    }
}

// MARK: UIAlertController
extension Alert {
    
    /// Show normal ok - cancel alert with action
    ///
    /// - Parameters:
    ///   - title: Alert title
    ///   - actionOkTitle: Ok action button title
    ///   - actionCancelTitle: Cancel action button title
    ///   - message: Alert message
    ///   - completion: Action completion return true if action is ok else false for cancel
    func showAlert(_ title : String = ""/* Bundle.appName() */, actionOkTitle : String = AppMessages.ok , actionCancelTitle : String = "" , message : String, completion: ((Bool) -> ())? ) {
        
        let alert : UIAlertController = UIAlertController(title: "".localized, message: message.localized , preferredStyle: .alert)
        
        let actionOk : UIAlertAction = UIAlertAction(title: actionOkTitle.localized, style: .default) { (action) in
            if completion != nil {
                completion!(true)
            }
        }
        alert.addAction(actionOk)
        
        if actionCancelTitle != "" {
            let actionCancel : UIAlertAction = UIAlertAction(title: actionCancelTitle.localized, style: .cancel) { (action) in
                if completion != nil {
                    completion!(false)
                }
            }
            alert.addAction(actionCancel)
        }
        
        alert.view.tintColor = UIColor.black
        if let a = UIApplication.topViewController() as? UIAlertController {
            a.dismiss(animated: true){
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
        }
        else {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Show alert for multiple button action
    ///
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - actionTitles: Array of button action title
    ///   - actions: Array of UIAlertAction actions
    func showAlert(title: String = Bundle.appName(), message: String, actionTitles:[String], actions:[((UIAlertAction) -> Void)]) {
        let alert = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title.localized, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        alert.view.tintColor = UIColor.black
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }

    func showAlertForSettings(title: String,message: String = "",settingsCompletion: ((UIAlertAction) -> Void)? = nil, cancelCompletion: ((UIAlertAction) -> Void)?) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title:"Cancel".localized, style: .default, handler: cancelCompletion))
            
            
            let settingsAction = UIAlertAction(title: "Settings".localized, style: .default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
                if let url = settingsUrl {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                    }
                }
            }
            
            if let settingActionCompletion = settingsCompletion {
                alertController.addAction(UIAlertAction(title:"Settings".localized, style: .default, handler: settingActionCompletion))
            } else {
                alertController.addAction(settingsAction)
            }
            
            
            DispatchQueue.main.async {
                UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
            }
        }
        
        func openAppOrSystemSettingsAlert(title: String, message: String) {
            let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) -> Void in
                
            }
            alertController.addAction(cancelAction)
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
}
