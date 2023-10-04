//
//  CustomMethods.swift
//  MyTatva
//
//  Created by Macbook Pro on 13/09/23.
//

import Foundation

@objc(RNShare)
class RNShare : NSObject {
    @objc
    func constantsToExport() -> [AnyHashable : Any]! {
        return ["token": UserModel.accessToken]
    }
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
