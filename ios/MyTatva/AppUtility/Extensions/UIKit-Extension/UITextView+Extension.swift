//
//  UITextView+Extension.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import Foundation

extension UITextView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.textAlignment = Bundle.main.isArabicLanguage ? .right : .left
    }
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
}
