//
//  UIButton+Extension.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIButton {
    func setInsets(
        forContentPadding contentPadding: UIEdgeInsets? = nil,
        imageTitlePadding: CGFloat
    ) {
        
        guard let contentPadding = contentPadding == nil ? self.contentEdgeInsets : contentPadding else {
            return
        }
        
        if Bundle.main.isArabicLanguage {
            self.contentEdgeInsets = UIEdgeInsets(
                top: contentPadding.top,
                left: contentPadding.left + imageTitlePadding,
                bottom: contentPadding.bottom,
                right: contentPadding.right
            )
            
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -imageTitlePadding,
                bottom: 0,
                right: imageTitlePadding
            )
        } else {
            self.contentEdgeInsets = UIEdgeInsets(
                top: contentPadding.top,
                left: contentPadding.left,
                bottom: contentPadding.bottom,
                right: contentPadding.right + imageTitlePadding
            )
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: imageTitlePadding,
                bottom: 0,
                right: -imageTitlePadding
            )
        }
    }
}

extension UIButton {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        //Vibration.light.vibrate()
    }
    override open var intrinsicContentSize: CGSize {
        
        let intrinsicContentSize = super.intrinsicContentSize
        
        let adjustedWidth = intrinsicContentSize.width + titleEdgeInsets.left + titleEdgeInsets.right
        let adjustedHeight = intrinsicContentSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom
        
        return CGSize(width: adjustedWidth, height: adjustedHeight)
        
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // self.semanticContentAttribute = Bundle.main.isArabicLanguage ? .forceRightToLeft : .forceLeftToRight
        self.frame.size = self.intrinsicContentSize
        if #available(iOS 10.0, *) {
            self.titleLabel?.adjustsFontForContentSizeCategory = true
        }
        self.titleLabel?.lineBreakMode = .byTruncatingTail
        if let text = self.title(for: self.state) {
            self.setTitle(text.localized, for: self.state)
        }
    }
    
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let factor: CGFloat =  1
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount*factor, bottom: 0, right: insetAmount*factor)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount*factor, bottom: 0, right: -insetAmount*factor)
        self.contentEdgeInsets = UIEdgeInsets(top: self.contentEdgeInsets.top, left: insetAmount, bottom: self.contentEdgeInsets.bottom, right: insetAmount)
    }
    
    func imageUnderText(padding: CGFloat = 8.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: padding, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font as Any])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + padding), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    
    
}

