//
//  Nsobject+FormatStyle.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

//MARK:- TextColor
extension FormatStyle where Self: NSObject {
    
    @discardableResult func textColor(color: UIColor, state: UIControl.State? = nil) -> Self {
        
        switch self {
   
        case is UILabel:
            let lbl = self as! UILabel
            lbl.textColor = color
            lbl.highlightedTextColor = color
            break
        case is UIButton:
            let btn = self as! UIButton
            var defaultState = UIControl.State()
            if let nwState = state {
                defaultState = nwState
            }
            btn.setTitleColor(color, for: defaultState)
            break
            
        case is UIBarButtonItem:
            let barButton = self as! UIBarButtonItem
            
            var defaultState = UIControl.State()
            if let nwState = state {
                defaultState = nwState
            }
            var defaultAttributes : [NSAttributedString.Key : Any] = [:]
            if let attributes = barButton.titleTextAttributes(for: defaultState) {
                defaultAttributes = attributes
            }
            
            defaultAttributes[NSAttributedString.Key.foregroundColor] = color
            barButton.setTitleTextAttributes(defaultAttributes, for: defaultState)
            break
            
        case is UITextField:
            let txtField = self as! UITextField
            txtField.textColor = color
            break
            
        case is UITextView:
            let txtv = self as! UITextView
            txtv.textColor = color
            break
            
        default:
            break
        }
        
        return self
    }
    
}

//MARK:- Font & size
extension FormatStyle where Self: NSObject {
    
    @discardableResult func font(name: UIFont.FontType, size: CGFloat? = nil) -> Self {
        
        let defaultFontSize : CGFloat = 10
        
        switch self {
        
        case is UILabel:
            let lbl = self as! UILabel
            lbl.font = UIFont.customFont(ofType: name, withSize: size ?? lbl.font.pointSize)
//            customFont(ofType: name, withSize: size ?? lbl.font.pointSize) //UIFont(name: name, size: size ?? lbl.font.pointSize)
            break
            
        case is UIButton:
            let btn = self as! UIButton
            let nwSize = size ?? btn.titleLabel?.font.pointSize ?? defaultFontSize
            btn.titleLabel?.font = UIFont.customFont(ofType: name, withSize: nwSize)
            break
            
        case is UIBarButtonItem:
            let barButton = self as! UIBarButtonItem
            let defaultState = UIControl.State()
            
            var defaultAttributes : [NSAttributedString.Key : Any] = [:]
            
            if let attributes = barButton.titleTextAttributes(for: defaultState) {
                defaultAttributes = attributes
            }
            defaultAttributes[NSAttributedString.Key.font] = UIFont.customFont(ofType: name, withSize: size ?? defaultFontSize)
//            customFont(ofType: name, withSize: size ?? defaultFontSize)
           // defaultAttributes[NSAttributedString.Key.font] = UIFont(name: name, size: size ?? defaultFontSize)
            
            barButton.setTitleTextAttributes(defaultAttributes, for: defaultState)
            break
            
        case is UITextField:
            let txtField = self as! UITextField
            txtField.font = UIFont.customFont(ofType: name, withSize: size ?? txtField.font?.pointSize ?? defaultFontSize)
//            customFont(ofType: name, withSize: size ?? txtField.font?.pointSize ?? defaultFontSize)
         //   txtField.font = UIFont(name: name, size: size ?? txtField.font?.pointSize ?? defaultFontSize)
            break
            
        case is UITextView:
            let txtv = self as! UITextView
            txtv.font = UIFont.customFont(ofType: name, withSize: size ?? txtv.font?.pointSize ?? defaultFontSize)
//            customFont(ofType: name, withSize: size ?? txtv.font?.pointSize ?? defaultFontSize)
           // txtv.font = UIFont(name: name, size: size ?? txtv.font?.pointSize ?? defaultFontSize)
            break
            
        default:
            break
        }
        
        return self
    }
    
}

//MARK:- FontsizeOnly
extension FormatStyle where Self: NSObject {
    
    @discardableResult func fontSize(size: CGFloat) -> Self {
        
        switch self {
            
        case is UILabel:
            
            let lbl = self as! UILabel
            
            if let font = UIFont.FontType(rawValue: lbl.font.familyName) {
                lbl.font = UIFont.customFont(ofType: font, withSize: size)
                return self
            }
            
            lbl.font = lbl.font.withSize(size)
            
            break
            
        case is UIButton:
            
            let btn = self as! UIButton
            
            if let font = UIFont.FontType(rawValue: btn.titleLabel?.font.familyName ?? "") {
                btn.titleLabel?.font = UIFont.customFont(ofType: font, withSize: size)
                return self
            }
            btn.titleLabel?.font = btn.titleLabel?.font.withSize(size)
            
            break
            
        case is UITextField:
            
            let txtField = self as! UITextField
            
            if let font = UIFont.FontType(rawValue: txtField.font?.familyName ?? "") {
                txtField.font = UIFont.customFont(ofType: font, withSize: size)
                return self
            }
            txtField.font = txtField.font?.withSize(size)
            
            break
            
        case is UITextView:
            
            let txtv = self as! UITextView
            
            if let font = UIFont.FontType(rawValue: txtv.font?.familyName ?? "") {
                txtv.font = UIFont.customFont(ofType: font, withSize: size)
                return self
            }
            txtv.font = txtv.font?.withSize(size)
            
            break
            
        default:
            break
        }
        
        return self
    }
    
}

//MARK:- Apply Theme
extension FormatStyle where Self: UIView {
    
    @discardableResult func applyTheme(themeStyle: Theme) -> Self {
        
        let theme = themeStyle.theme
        
        if let color = theme.textColor {
            self.textColor(color: color)
        }

        if let backGroundColor = theme.backGroundColor {
            (self as UIView).backGroundColor(color: backGroundColor)
        }
        
        if let fontName = theme.fontName {
            self.font(name: fontName, size: theme.fontSize)
        }
        
        return self
    }
}


