//
//  AppCredential.swift
//  MVVMBasicStructure
//
//  Created by on 28/02/21.
//

import Foundation

//MARK: App Creadential
enum AppCredential: String {
    case facebookAppID          = "253851173225318"
    case googleClientID         = "784229987778-8c8jpeeen3d26dk9gs5b2att6p343i1c.apps.googleusercontent.com"
    case googleBrowserKey       = "AIzaSyDY5VJ4HSQugDGvirtP75Uv-Wx1Z15J6Wc"
    case googleKey              = "AIzaSyDpw4KKiqefWEUKbOFOQA8DBjtmW5EQ9Ks"////Note:- Keys are from account of deep sir.
    case bundelID               = "com.hyperlink.mytatva"
    case appStoreID             = "1590299281"
    case shareapp               = "https://apps.apple.com/in/app/mytatva/id1590299281"
    static var appStoreLink: String {
        return "itms-apps://itunes.apple.com/app/" + AppCredential.appStoreID.rawValue
    }
}

