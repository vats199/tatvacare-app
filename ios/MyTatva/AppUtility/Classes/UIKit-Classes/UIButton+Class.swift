//
//  UIButton+Class.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit


final class ThemePurpleButton: UIButton {
    
    @IBInspectable var isShadow: Bool = false {
        didSet {
            setUp()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
    }
    
    private func setUp() {
        if isShadow {
            self.applyViewShadow(shadowOffset: CGSize(width: 0, height: 3),
                                 shadowColor: UIColor.themeBlack,
                                 shadowOpacity: 0.16,
                                 shdowRadious: 3)
        }
        
        self.font(name: .bold, size: 15).textColor(color: .white)
            .backGroundColor(color: .themePurple)
        self.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), imageTitlePadding: 0)
        
    }
}

final class ThemePurple16Corner: UIButton {
    
    @IBInspectable var isShadow: Bool = false {
        didSet {
            setUp()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 16
    }
    
    private func setUp() {
        if isShadow {
            self.applyViewShadow(shadowOffset: CGSize(width: 0, height: 3),
                                 shadowColor: UIColor.themeBlack,
                                 shadowOpacity: 0.16,
                                 shdowRadious: 3)
        }
        
        self.font(name: .bold, size: 16).textColor(color: .white)
            .backGroundColor(color: .themePurple)
        self.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), imageTitlePadding: 0)
        
    }
}

final class ThemePurpleBorderButton: UIButton {
    
    @IBInspectable var isShadow: Bool = false {
        didSet {
            setUp()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }
    
    private func setUp() {
        if isShadow {
            self.applyViewShadow(shadowOffset: CGSize(width: 0, height: 3), shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 3)
        }
        
        self.font(name: .medium, size: 20).textColor(color: .themePurple).backGroundColor(color: .white)
        self.borderColor(color: UIColor.themePurple, borderWidth: 1)
        self.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), imageTitlePadding: 0)
    }
}

final class ThemeFacebookButton: UIButton {
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }
    
    private func setUp() {
        self.applyViewShadow(shadowOffset: CGSize(width: 0, height: 3), shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 3)
        self.font(name: .medium, size: 20).textColor(color: .themeFb).backGroundColor(color: .white)
        self.borderColor(color: UIColor.themeFb, borderWidth: 1)
        //self.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), imageTitlePadding: 0)
    }
}

final class ThemeGoogleButton: UIButton {
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }
    
    private func setUp() {
        self.applyViewShadow(shadowOffset: CGSize(width: 0, height: 3), shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 3)
        self.font(name: .medium, size: 20).textColor(color: .themeGoogle).backGroundColor(color: .white)
        self.borderColor(color: UIColor.themeGoogle, borderWidth: 1)
        //self.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), imageTitlePadding: 0)
    }
}

final class ThemeAppleButton: UIButton {
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }
    
    private func setUp() {
        self.applyViewShadow(shadowOffset: CGSize(width: 0, height: 3), shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 3)
        self.font(name: .medium, size: 20).textColor(color: .themeBlack).backGroundColor(color: .white)
        self.borderColor(color: UIColor.themeBlack, borderWidth: 1)
        //self.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), imageTitlePadding: 0)
    }
}


final class ThemePurpleBCPButton: UIButton {
    
    @IBInspectable var isShadow: Bool = false {
        didSet {
            setUp()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }
    
    private func setUp() {
        if isShadow {
            self.applyViewShadow(shadowOffset: CGSize(width: 0, height: 3),
                                 shadowColor: UIColor.themeBlack,
                                 shadowOpacity: 0.16,
                                 shdowRadious: 3)
        }
        
        self.font(name: .bold, size: 11).textColor(color: .white)
            .backGroundColor(color: .themePurple)
        self.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), imageTitlePadding: 0)
        
    }
}

final class ThemePurpleBorderBCPButton: UIButton {
    
    @IBInspectable var isShadow: Bool = false {
        didSet {
            setUp()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }
    
    private func setUp() {
        if isShadow {
            self.applyViewShadow(shadowOffset: CGSize(width: 0, height: 3), shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 3)
        }
        
        self.font(name: .bold, size: 11).textColor(color: .themePurple).backGroundColor(color: .white)
        self.borderColor(color: UIColor.themePurple, borderWidth: 1)
        self.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), imageTitlePadding: 0)
    }
}
