//
//  ThemeStyle.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

// Add paramters based on your requirement
struct ThemeStyle {
    var textColor : UIColor?
    var backGroundColor: UIColor?
    var fontName : UIFont.FontType?
    var fontSize : CGFloat?
}

// Make your own theme
// Create theme only if your application has global theme
enum Theme {
    case boldBlackTitle
    case boldBlackMediumTitle
    case regularThemeText
    case regularLargeThemeText
    case semiBoldBlackTitle
    case mediumBlack
    
    var theme : ThemeStyle {
        switch self {
        case .boldBlackTitle:
            return ThemeStyle(textColor: #colorLiteral(red: 0.02352941176, green: 0.1176470588, blue: 0.1921568627, alpha: 1), backGroundColor: UIColor.clear, fontName: .bold, fontSize: 24)
        
        case .boldBlackMediumTitle:
            return ThemeStyle(textColor: #colorLiteral(red: 0.02352941176, green: 0.1176470588, blue: 0.1921568627, alpha: 1), backGroundColor: UIColor.clear, fontName: .bold, fontSize: 16)
            
        case .regularThemeText:
            return ThemeStyle(textColor: #colorLiteral(red: 0.3019607843, green: 0.337254902, blue: 0.4901960784, alpha: 1), backGroundColor: UIColor.clear, fontName: .regular, fontSize: 14)
            
        case .regularLargeThemeText:
            return ThemeStyle(textColor: #colorLiteral(red: 0.3019607843, green: 0.337254902, blue: 0.4901960784, alpha: 1), backGroundColor: UIColor.clear, fontName: .regular, fontSize: 18)
            
        case .semiBoldBlackTitle:
            return ThemeStyle(textColor: .themeBlack, backGroundColor: UIColor.clear, fontName: .semibold, fontSize: 18)
            
        case .mediumBlack:
            return ThemeStyle(textColor: .themeBlack, backGroundColor: UIColor.clear, fontName: .medium, fontSize: 15)
        }
    }
}
