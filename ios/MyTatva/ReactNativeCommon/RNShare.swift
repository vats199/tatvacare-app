//
//  CustomMethods.swift
//  MyTatva
//
//  Created by Macbook Pro on 13/09/23.
//

import Foundation

@objc(RNShare)
class RNShare : NSObject {
    
    
//    @objc
//    func getToken(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> String {
//        return  "Test ReactNative"
//    }
    
//    @objc
//    func getToone() -> String {
//        
//        return UserModel.accessToken ?? "Test React"
//    }
    
    @objc
    func constantsToExport() -> [AnyHashable : Any]! {
        return ["token": UserModel.accessToken]
    }
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
//    // Reference to use main thread
//    @objc func getToken() -> String? {
//        DispatchQueue.main.async {
//        self._getToken()
//        }
//    }
//
//    func _getToken() -> String? {
//        let token = UserModel.accessToken ?? "Test ReactNative"
//        debugPrint(token)
//        return token
//    }
}
