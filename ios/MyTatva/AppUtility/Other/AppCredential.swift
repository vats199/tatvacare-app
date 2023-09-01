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
    case googleClientID         = "784229987778-l7u6ibdtrnf85tcthc0us0ut2ldjsltb.apps.googleusercontent.com"
    case googleBrowserKey       = "AIzaSyBCWMnbFGmhustPqXXF5DuOWDDcu0Yu4uE"
    case googleKey              = "AIzaSyD-HztfmwAmkBMEaaFUyQAlUQUrIMH5qF0"////Note:- Keys are from account of deep sir.
    case bundelID               = "com.hyperlink.mytatva"
    case appStoreID             = "1590299281"
    case shareapp               = "https://apps.apple.com/in/app/mytatva/id1590299281"
    static var appStoreLink: String {
        return "itms-apps://itunes.apple.com/app/" + AppCredential.appStoreID.rawValue
    }
}

