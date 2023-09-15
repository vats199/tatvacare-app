//
//  UIBarButtonItem+Class.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

class BarButtonItemFilp: UIBarButtonItem {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let textValue = self.title {
            self.title = textValue.localized
        }
        if Bundle.main.isArabicLanguage {
            self.image = self.image?.imageFlippedForRightToLeftLayoutDirection()
        }
    }
}
