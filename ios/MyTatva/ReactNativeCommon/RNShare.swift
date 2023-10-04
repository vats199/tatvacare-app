//
//  CustomMethods.swift
//  MyTatva
//
//  Created by Macbook Pro on 13/09/23.
//

import Foundation

@objc(RNShare)
class RNShare : NSObject {
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
