//
//  WebViewLinks.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 28/02/21.
//

import Foundation

//MARK: WebViewLinks
enum WebViewLinks {
    case privacyPolicy
    case facebook
    case linkedIn
    case youtube
    case twitter
    
    var url: URL? {
        switch self {
        case .privacyPolicy:
            return URL(string: "https://www.google.com/")
            
        case .facebook:
            return URL(string: "https://www.google.com/")
            
        case .linkedIn:
            return URL(string: "https://www.google.com/")
            
        case .youtube:
            return URL(string: "https://www.google.com/")
            
        case .twitter:
            return URL(string: "https://www.google.com/")
        }
    }
    
    var title: String {
        switch self {
        case .privacyPolicy:
            return "Disclaimer & Privacy Policy"
            
        default: return ""
        }
    }
}
