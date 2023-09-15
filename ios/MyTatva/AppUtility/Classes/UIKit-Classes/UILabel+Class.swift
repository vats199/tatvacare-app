//
//  UILabel+Class.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

//Bold Title Lable
class BoldBlackTitle: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme(themeStyle: .boldBlackTitle)
    }
}

class MediumBlack: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme(themeStyle: .mediumBlack)
    }
}

class SemiBoldBlackTitle: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme(themeStyle: .semiBoldBlackTitle)
    }
}

//Regular Theme Lable
class RegularTheme: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme(themeStyle: .regularThemeText).lineSpacing(lineSpacing: 5, alignment: NSTextAlignment.natural)
    }
}

//Regular Theme Large Lable
class RegularLargeTheme: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme(themeStyle: .regularLargeThemeText).lineSpacing(lineSpacing: 5, alignment: NSTextAlignment.natural)
    }
}

//Bold title medium size Lable
class BoldBlackMediumTitle: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme(themeStyle: .boldBlackMediumTitle)
    }
}

//Flip lable
class FlipLable: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        if Bundle.main.isArabicLanguage {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
}

class ChangeContentMode: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        if Bundle.main.isArabicLanguage {
            if self.textAlignment == .left {
                self.textAlignment = .right
            } else {
                self.textAlignment = .left
            }
        }
    }
}

