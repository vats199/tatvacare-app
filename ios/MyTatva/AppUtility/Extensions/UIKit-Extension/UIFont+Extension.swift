//
//  GExtension+UIFont.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum FontType: String {
//        case regular                 = "Poppins-Regular"
//        case medium                  = "Poppins-Medium"
//        case semibold                = "Poppins-SemiBold"
//        case bold                    = "Poppins-Bold"
//        case light                   = "Poppins-Light"
        
        case regular                    = "SFProDisplay-Regular"
        case medium                     = "SFProDisplay-Medium"
        case semibold                   = "SFProDisplay-Semibold"
        case bold                       = "SFProDisplay-Bold"
        case light                      = "SFProDisplay-Light"
        case ultraLight                 = "SFProDisplay-Ultralight"
        case italic                     = "SFProDisplay-Italic"
        case heavy                      = "SFProDisplay-Heavy"
        case thin                       = "SFProDisplay-Thin"
        case playfairBlack              = "PlayfairDisplay-Black"
        case playfairSCBlack            = "PlayfairDisplaySC-Black"
        case playfairSCBold             = "PlayfairDisplaySC-Bold"
        
        case gloRegular                 = "Gilroy-Regular"
        case gloBold                    = "Gilroy-Bold"
        case gloSemiBold                = "Gilroy-SemiBold"
        case gloMedium                  = "Gilroy-Medium"
    }
    
    //"PlayfairDisplay-Black"
//    - 0 : "PlayfairDisplaySC-Bold"
//    - 1 : "PlayfairDisplaySC-Black"
    
    /// Set custom font
    /// - Parameters:
    ///   - type: Font type.
    ///   - size: Size of font.
    ///   - isRatio: Whether set font size ratio or not. Default true.
    /// - Returns: Return font.
    class func customFont(ofType type: FontType, withSize size: CGFloat, enableAspectRatio isRatio: Bool = true) -> UIFont {
        return UIFont(name: type.rawValue, size: isRatio ? size * ScreenSize.fontAspectRatio : size) ?? UIFont.systemFont(ofSize: size)
    }
}

