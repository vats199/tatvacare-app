//
//  UIImageView+Class.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

class ImageFilp: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        if Bundle.main.isArabicLanguage {
            self.image = self.image?.imageFlippedForRightToLeftLayoutDirection()
        }
    }
}

class ScreenBackground: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1).withAlphaComponent(0.31)
    }
}

class LineSeperator: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeGray
        self.alpha = 0.5
    }
}

class LineSeperatorTop: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeGray
        self.alpha = 0.21
    }
}

class LightBlueLineSeperator: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.colorFromHex(hex: 0x014BFE)
        self.alpha = 0.05
    }
}

class HorizontalDashLine: HorizontalDotLine {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = UIColor.colorFromHex(hex: 0x1D1C1C).withAlphaComponent(0.3)
    }
}

class VerticleDashLine: VerticleDotLine {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = UIColor.colorFromHex(hex: 0x1D1C1C).withAlphaComponent(0.3)
    }
}

class ThemeImageView: UIImageView {
    
    @IBInspectable var isAllSideCorner: Bool = false {
        didSet {
            setUp()
        }
    }
    
    @IBInspectable var isShdaow: Bool = false {
        didSet {
            setUp()
        }
    }
    
    @IBInspectable var cornerSize: CGFloat = 19 {
        didSet {
            setUp()
        }
    }
    
    @IBInspectable var shadowoHeight: Int = 0 {
        didSet {
            setUp()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    private func setUp(){
        self.layer.cornerRadius = cornerSize
        if !isAllSideCorner {
            self.layer.masksToBounds = false
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if isShdaow {
            self.applyViewShadow(shadowOffset: CGSize(width: 0, height: shadowoHeight), shadowColor: UIColor.black.withAlphaComponent(0.05), shadowOpacity: 1.0, shdowRadious: 8)
        }
    }
}

class HorizontalDotLine: UIImageView {
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0.0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        
        //Create a CAShape Layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.frame = self.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = self.tintColor.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.lineDashPattern = [1,2]
        pathLayer.lineJoin = CAShapeLayerLineJoin.miter
        
        if self.layer.sublayers != nil {
            
            if (self.layer.sublayers?.count)! > 0 {
                
                for layer in self.layer.sublayers! {
                    
                    if layer.isKind(of: CAShapeLayer.self) {
                        
                        self.layer.replaceSublayer(layer, with: pathLayer)
                        
                    }
                    
                }
                
            }
            
        }
        
        self.layoutIfNeeded()
        //Add the layer to your view's layer
        self.layer.addSublayer(pathLayer)
        self.layoutIfNeeded()
    }
    
    //--------------------------------------------------------------------------------------
    
    override func layoutSubviews() {
        self.awakeFromNib()
        self.layoutIfNeeded()
    }
}


class VerticleDotLine: UIImageView {
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0.0))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        
        //Create a CAShape Layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.frame = self.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = self.tintColor.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.lineDashPattern = [1,2]
        pathLayer.lineJoin = CAShapeLayerLineJoin.miter
        
        if self.layer.sublayers != nil {
            
            if (self.layer.sublayers?.count)! > 0 {
                
                for layer in self.layer.sublayers! {
                    
                    if layer.isKind(of: CAShapeLayer.self) {
                        
                        self.layer.replaceSublayer(layer, with: pathLayer)
                        
                    }
                }
            }
        }
        
        self.layoutIfNeeded()
        //Add the layer to your view's layer
        self.layer.addSublayer(pathLayer)
        self.layoutIfNeeded()
    }
    
    //--------------------------------------------------------------------------------------
    
    override func layoutSubviews() {
        self.awakeFromNib()
        self.layoutIfNeeded()
    }
}


class ImageWithoutRender: UIImage {
    override func withRenderingMode(_ renderingMode: UIImage.RenderingMode) -> UIImage {
        return self
    }
}
