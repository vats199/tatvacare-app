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
        defer {
            Navigation.is_home_data_update_required = false
            print("is_home_data_update_required set : ", Navigation.is_home_data_update_required)
        }
        print("is_home_data_update_required return : ", Navigation.is_home_data_update_required)
        return ["token": UserModel.accessToken, "is_home_data_update_required":Navigation.is_home_data_update_required]
    }
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
