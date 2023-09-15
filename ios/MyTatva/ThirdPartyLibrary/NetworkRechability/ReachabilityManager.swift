//
//  ReachabilityManager.swift
//
//
//  Created by on 12/10/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - Reachability Manager -

class ReachabilityManager: NSObject {
    
    // MARK: - Shared
    
    static let shared: ReachabilityManager = ReachabilityManager()
    
    // -----------------------------------------------------------------------------------------------------------------------------
    
    // MARK: - Class Variables
    
    private var reachability: Reachability!
    private let snackBarNetworkReachability: TTGSnackbar = TTGSnackbar()
    
    let reachabilityChangedNotification = "ReachabilityChangedNotification"
    
    static var isReachable: Bool {
        return ReachabilityManager.shared.reachability.connection != .none
    }
    
    static var isReachableViaWWAN: Bool {
        return ReachabilityManager.shared.reachability.connection == .cellular
    }
    
    static var isReachableViaWiFi: Bool {
        return ReachabilityManager.shared.reachability.connection == .wifi
    }
    
    // -----------------------------------------------------------------------------------------------------------------------------
    
    // MARK: - Custom Methods
    
    func startObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        do {
            try self.reachability.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    
    func stopObserving() {
        reachability.stopNotifier()
    }
    
    @objc func reachabilityChanged(notification: NSNotification) {
        if let reachability = notification.object as? Reachability {
            switch reachability.connection {
            case .cellular:
                print("Network available via Cellular Data.")
                removeNetworkSnackBar()
                break
            case .wifi:
                print("Network available via WiFi.")
                removeNetworkSnackBar()
                break
            case .none:
                print("Network is not available.")
                showNetworkSnackBar()
                break
            }
        }
    }
    
    //Snackbar Methods
    
    private func showNetworkSnackBar(withMessage message: String = AppMessages.internetConnectionMsg) {
        //extra decoration
        // Change message text font and color
        snackBarNetworkReachability.dismiss()
        snackBarNetworkReachability.messageTextColor = UIColor.white
        snackBarNetworkReachability.messageTextFont = .customFont(ofType: .bold, withSize: 15)
        
        snackBarNetworkReachability.messageTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        snackBarNetworkReachability.backgroundColor = UIColor.themeRed
        
        snackBarNetworkReachability.animationType = .slideFromTopBackToTop
        snackBarNetworkReachability.message = message.localized
        snackBarNetworkReachability.duration = .forever
        snackBarNetworkReachability.messageTextAlign = .center
        snackBarNetworkReachability.shouldDismissOnSwipe = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.snackBarNetworkReachability.show()
        }
    }
    
    func removeNetworkSnackBar() {
        snackBarNetworkReachability.dismiss()
    }
    
    func showNoNetworkMessage() {
        if !ReachabilityManager.isReachable {
            self.showNetworkSnackBar()
        }
    }
    
    // MARK: - Life Cycle Methods
    
    override init() {
        super.init()
        self.reachability = Reachability()
    }
    
}
