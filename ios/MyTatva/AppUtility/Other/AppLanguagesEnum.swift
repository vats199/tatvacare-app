//
//  AppLanguagesEnum.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 28/12/20.
//

import Foundation

//MARK:- App language
enum AppLanguages: String, Codable, CaseIterable{
    case english    = "en"
    case arabic     = "ar"
    
    var headerValue: String {
        switch self {
        case .english:
            return "en"
        case .arabic:
            return "ar"
        }
    }
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .arabic:
            return "Arabic"
        }
    }
}
