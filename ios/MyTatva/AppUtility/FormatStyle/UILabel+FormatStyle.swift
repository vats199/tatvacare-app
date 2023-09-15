//
//  UILabel+FormatStyle.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit


extension FormatStyle where Self: UILabel {
    
     @discardableResult func lineSpacing(lineSpacing : CGFloat? = 5, alignment : NSTextAlignment? = nil) -> UILabel {
        if let text = self.text {
            
            var attributedString = NSMutableAttributedString(string: text)
            
            var alignMentForText = self.textAlignment
            
            if let txtAlignMent = alignment {
                alignMentForText = txtAlignMent
            }
            
            if let attributedText = self.attributedText {
                attributedString = NSMutableAttributedString(attributedString: attributedText)
            }
            
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = lineSpacing! // Whatever line spacing you want in points
            paragraphStyle.alignment = alignMentForText
            
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            // *** Set Attributed String to your label ***
            self.attributedText = attributedString
            
        }
        
        return self
    }
}
