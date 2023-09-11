//
//  GExtension+UIViewController.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit
import SafariServices
import AVKit

extension UIViewController {
    ///Life Cycle.
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.modalPresentationStyle = .overFullScreen
        
    }
    
    ///Return status bar height.
    public var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            // Fallback on earlier versions
            return UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }
    
    ///Return top bar height : Navigation bar height + status bar height
    var topbarHeight: CGFloat {
        var top = self.navigationController?.navigationBar.frame.height ?? 0.0
        if #available(iOS 13.0, *) {
            top += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            top += UIApplication.shared.statusBarFrame.height
        }
        return top
    }
    
    ///Return storyboard identifier
    class var storyboardID : String {
        return "\(self)"
    }
    
    /**
     To get storyboard view controller instantiate
     
     - Parameter appStoryboard: Pass storyboard
     - Returns: View controller
     
     */
    static func instantiate(fromAppStoryboard appStoryboard: UIStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    /**
     To pop / back view controller
     
     - Parameter sender: AnyObject
     */
    
    @IBAction func popViewController(sender : AnyObject) {
        //        Vibration.medium.vibrate()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openMenu(sender : AnyObject) {
        if let nav = SideMenuManager.default.menuLeftNavigationController{
            UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
        }
    }
    /**
     To dismiss view controller
     
     - Parameter sender: AnyObject
     */
    
    @IBAction func dismissViewController(sender : AnyObject) {
        //        Vibration.medium.vibrate()
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     To back root  view controller
     
     - Parameter sender: AnyObject
     */
    @IBAction func popToRootViewController(sender : AnyObject) {
        //        Vibration.medium.vibrate()
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension UIViewController: SFSafariViewControllerDelegate {
    /**
     To open url in safari controller
     
     - Parameter url: Any web url
     */
    func openURL(_ url : String) {
        
        var url = url.url()
        if !(["http", "https"].contains(url.scheme?.lowercased())) {
            let appendedLink = "http://\(url)"
            
            url = appendedLink.url()
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        UIApplication.topViewController()?.present(safariVC, animated: true, completion: nil)
        
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    /**
     To play youtube video in player view controller.
     
     - Parameter urlString: Video url string
     */
    func playYoutubeVideo(with urlString: String) {
        //First get video id from link and make playbel youtube link
        guard let url = URL(string: urlString) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension UIViewController{
    
    /**
     redirect to notification screen
     */
    @IBAction func openNotificationVC(_ sender : UIBarButtonItem) {
        
        let vc = NotificationVC.instantiate(fromAppStoryboard: .setting)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func openGlobalSearchVC(_ sender : UIBarButtonItem) {
        
        let vc = GlobalSearchParentVC.instantiate(fromAppStoryboard: .home)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
