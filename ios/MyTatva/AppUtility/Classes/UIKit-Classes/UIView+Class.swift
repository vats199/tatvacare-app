//
//  UIView+Class.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

class RoundeViewWithBorder: UIView {
    //MARK: Class Variables
    
    ///Sets boarder color
    @IBInspectable var borderClr: UIColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1) {
        didSet {
            setUp()
        }
    }
    
    ///Sets boarder width
    @IBInspectable var borderwidth: CGFloat = 0.0 {
        didSet {
            setUp()
        }
    }
    
    ///Sets is half corner
    @IBInspectable var isHalfCorner: Bool = false {
        didSet {
            setUp()
        }
    }
    
    ///Sets corner size.
    @IBInspectable var cornerSize: CGFloat = ScreenSize.cornerRadious {
        didSet {
            setUp()
        }
    }
    
    //MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    //MARK: Class Funcations
    /**
     Intitial view setup
     */
    private func setUp(){
        self.layer.borderWidth = borderwidth
        self.layer.borderColor = self.borderClr.cgColor
        if isHalfCorner {
            self.layer.cornerRadius = self.frame.size.height / 2
        } else {
            self.layer.cornerRadius = cornerSize
        }
    }
}

class CellStyleView: UIView {
    //MARK: Class Variables
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyShadow()
    }
    
    //MARK: Class Funcation
    
    /**
     Add shdows
     */
    private func applyShadow() {
        self.layer.cornerRadius = 6
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
    }
}

class BCPCarePlanViews : UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.borderColor(color: .colorFromHex(hex: 0xF0F0F0)).cornerRadius(cornerRadius: 12.0)
            self.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.ThemeDeviceShadow, shadowOpacity: 1)
            self.clipsToBounds = true
        }
    }
}

class ThemeView: UIView {
    
    //MARK: Class Variables
    
    private var blurEffectView = UIVisualEffectView()
    
    ///Sets the cornr for all side.
    ///Defaults to YES.
    @IBInspectable var isAllSideCorner: Bool = true {
        didSet {
            setUp()
        }
    }
    
    ///Enable shadow.
    ///Defaults to YES.
    @IBInspectable var isShadow: Bool = true {
        didSet {
            setUp()
        }
    }
    
    ///Sets corner size.
    ///Defaults to 20.
    @IBInspectable var cornerSize: CGFloat = 20 {
        didSet {
            setUp()
        }
    }
    
    ///Sets shadow height.
    ///Defaults to 00.
    @IBInspectable var shadowHeight: Int = 0 {
        didSet {
            setUp()
        }
    }
    
    ///Sets shadow opacity.
    ///Defaults to 0.2
    @IBInspectable var _shadowOpacity: Float = 0.2 {
        didSet {
            setUp()
        }
    }
    
    ///Enable blur background.
    ///Defaults to NO.
    @IBInspectable var isBlurBG: Bool = false {
        didSet {
            self.addBlurBG()
        }
    }
    
    //MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    //MARK: Class Funcations
    
    /**
     Intitial view setup
     */
    private func setUp(){
        blurEffectView.layer.cornerRadius = self.cornerSize
        self.layer.cornerRadius = cornerSize
        if !isAllSideCorner {
            self.layer.masksToBounds = false
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if self.isShadow {
            self.applyViewShadow(shadowOffset: CGSize(width: 0, height: self.shadowHeight), shadowColor: UIColor.black.withAlphaComponent(0.9), shadowOpacity: _shadowOpacity, shdowRadious: 3)
            
        } else {
            self.removeShadow()
        }
    }
    
    /**
     Add blur layer for blur background
     */
    private func addBlurBG() {
        let blurEffect = UIBlurEffect(style: .dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.frame = self.bounds
        blurEffectView.clipsToBounds = true
        self.layer.masksToBounds = true
        self.insertSubview(blurEffectView, at: 0)
    }
}

class ThemeGrayBorderView: UIView {
    
    ///Sets corner size.
    ///Defaults to 20.
    @IBInspectable var cornerSize: CGFloat = 10 {
        didSet {
            setUp()
        }
    }
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    //MARK: Class Funcations
    
    /**
     Intitial view setup
     */
    private func setUp(){
        
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            self.cornerRadius(cornerRadius: self.cornerSize)
            self.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            self.backgroundColor        = UIColor.clear
        }
    }
}

class ThemeTextfieldBorderView: UIView {
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyThemeTextfieldBorderView(withError: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.applyThemeTextfieldBorderView(withError: false)
    }
  
}
    
class ThemeBgView: UIView {
    
    @IBInspectable
    var isCorderRadius: Bool = true {
        didSet{
            self.setUp()
        }
    }
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    //MARK: Class Funcations
    
    /**
     Intitial view setup
     */
    private func setUp(){
        
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            self.isCorderRadius ? self.roundCorners([.topLeft, .topRight], radius: 30) : nil
            self.backgroundColor        = UIColor.themeLightGray.withAlphaComponent(0.24)
        }
    }
}

class ThemeSegmentedControl: UISegmentedControl {
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    //MARK: Class Funcations
    
    /**
     Intitial view setup
     */
    private func setUp(){
        
        self.setTitle(font: UIFont.customFont(ofType: .medium, withSize: 16), fontColor: UIColor.white, state: .selected)
        self.setTitle(font: UIFont.customFont(ofType: .medium, withSize: 16), fontColor: UIColor.themeGray, state: .normal)
        
        self.selectedSegmentTintColor = UIColor.themePurple
        self.tintColor = UIColor.white
        
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            self.cornerRadius(cornerRadius: 5)
            self.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            self.backgroundColor = UIColor.white
            
            self.setBackgroundImage(UIImage(color: UIColor.white, size: self.frame.size), for: .normal, barMetrics: .default)
            self.setBackgroundImage(UIImage(color: UIColor.themePurple, size: self.frame.size), for: .selected, barMetrics: .default)
        }
    }
}
