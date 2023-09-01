//
//  UILabel + Exensions.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

// MARK: - Set Dynamic Font -

extension UILabel {
    
    // MARK: Life Cycle Methods
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 10.0, *) {
            self.adjustsFontForContentSizeCategory = true
        }
        
        if let textValue = self.text {
            //print("NSLocalizedString UILabel :::::::::::::::: \(textValue)")
            self.text = textValue//.localized
        }
    }
    
    func setAttributedString(_ arrStr : [String] , attributes : [[NSAttributedString.Key : Any]]) {
        let str = self.text!
        
        let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font: self.font as Any])
        
        for index in 0...arrStr.count - 1 {
            
            let attr = attributes[index]
            attributedString.addAttributes(attr, range: (str as NSString).range(of: arrStr[index]))
        }
        
        self.attributedText = attributedString
    }
    
    func addImage(image: UIImage, with text: String) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        let attachmentStr = NSAttributedString(attachment: attachment)
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentStr)
        
        let textString = NSAttributedString(string: " " + text, attributes: [.font: self.font ?? UIFont.systemFont(ofSize: 10)])
        mutableAttributedString.append(textString)
        
        self.attributedText = mutableAttributedString
    }
}



extension UILabel {
    /**
     Add Line Spacing
     - Parameter spacing: Add space between lines. Default 3
     */
    func addLineSpacing(_ spacing: CGFloat = 3) {
        
        if let text = self.text {
            let attributedString = NSMutableAttributedString(string: text)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = spacing
            //            paragraphStyle.alignment = alignment
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            
            attributedText = attributedString
        }
    }
    
    /**
     Add character Spacing
     - Parameter kernValue: Add space between characters. Default 1.15
     */
    func addCharacterSpacing(_ kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

@IBDesignable public class VerticalAlignLabel: UILabel {
    enum VerticalAlignment {
        case top
        case middle
        case bottom
    }

    var verticalAlignment : VerticalAlignment = .top {
        didSet {
            setNeedsDisplay()
        }
    }

    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)

        if UIView.userInterfaceLayoutDirection(for: .unspecified) == .rightToLeft {
            switch verticalAlignment {
            case .top:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            }
        } else {
            switch verticalAlignment {
            case .top:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            }
        }
    }

    override public func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
}

extension UILabel {
    
    func setAttributesForOrders(defFont: UIFont = UIFont.customFont(ofType: .regular, withSize: 12), defColor: UIColor = UIColor.themeBlack.withAlphaComponent(0.8), attrFont: UIFont = UIFont.customFont(ofType: .bold, withSize: 12), attrColor: UIColor = UIColor.themeBlack.withAlphaComponent(1), str: String = "") {
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : defFont,
            NSAttributedString.Key.foregroundColor : defColor as Any,
        ]
        
        let attributDicQue :  [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : attrFont,
            NSAttributedString.Key.foregroundColor : attrColor as Any,
        ]
        self.attributedText = self.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: attributDicQue, attributedStrings: [str])
    }
    
    func calculateMaxLines() -> Int {
            let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
            let charSize = font.lineHeight
            let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font], context: nil)
            let linesRoundedUp = Int(ceil(textSize.height/charSize))
            return linesRoundedUp
        }
    
    func setAttributesForOptional(defFont: UIFont = UIFont.customFont(ofType: .regular, withSize: 14), defColor: UIColor = UIColor.themeBlack.withAlphaComponent(0.8), attrFont: UIFont = UIFont.customFont(ofType: .bold, withSize: 14), attrColor: UIColor = UIColor.themeBlack.withAlphaComponent(1), str: String = "") {
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : defFont,
            NSAttributedString.Key.foregroundColor : defColor as Any,
        ]
        
        let attributDicQue :  [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : attrFont,
            NSAttributedString.Key.foregroundColor : attrColor as Any,
        ]
        self.attributedText = self.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: attributDicQue, attributedStrings: [str])
    }
    
}

