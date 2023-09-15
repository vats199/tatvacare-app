//
//  UITextView+Class.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

class DataDetectionTextView: UITextView, UITextViewDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isEditable = false
        self.isSelectable = true
        
        self.dataDetectorTypes = .link
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled = false
        self.delegate = self
        self.contentInsetAdjustmentBehavior = .never
        self.textContainerInset = UIEdgeInsets(top: 0.0, left: 14, bottom: 0.0, right: 14)
    }
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) {
            gestureRecognizer.isEnabled = false
        }
        super.addGestureRecognizer(gestureRecognizer)
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print(URL)
        return true
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
}
