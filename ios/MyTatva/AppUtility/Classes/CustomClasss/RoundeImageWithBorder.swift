//
//  RoundeImageWithBorder.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

class RoundeImageWithBorder: UIImageView {
    
    //MARK: Class Variables
    
    ///Sets the border color
    @IBInspectable var borderClr: UIColor? = UIColor.white {
        didSet {
            setUp()
        }
    }
    
    ///Sets the border width
    @IBInspectable var borderwidth: CGFloat = 0.0 {
        didSet {
            setUp()
        }
    }
    
    ///Sets the outline color
    @IBInspectable var outlineBorderColor: UIColor? = UIColor.white {
        didSet {
            setUp()
        }
    }
    
    ///Sets the outline width
    @IBInspectable var outlineBorderwidth: CGFloat = 0.0 {
        didSet {
            setUp()
        }
    }
    
    ///Sets the start angle of the outline
    @IBInspectable var startAngle: CGFloat = 150
    
    ///Sets the end angle of the outline
    @IBInspectable var endAngle: CGFloat = 390
    
    ///Sets the space between outline and image
    @IBInspectable var outlineSpace: CGFloat = 10
    
    ///Sets the enable - disable outline
    @IBInspectable var isOutlineBorder: Bool = false {
        didSet {
            if isOutlineBorder {
                self.perform(#selector(self.addOutline), with: self, afterDelay: 0.0)
            }
        }
    }
    
    ///Sets the half corner
    @IBInspectable var isHalfCorner: Bool = false {
        didSet {
            setUp()
        }
    }
    
    ///Sets the corner size
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
    
    //MARK: Class Funcation
    
    /**
     Intial setup
     */
    private func setUp() {
        self.layer.borderWidth = borderwidth
        self.layer.borderColor = self.borderClr?.cgColor
        if isHalfCorner {
            self.layer.cornerRadius = self.frame.size.height / 2
        } else {
            self.layer.cornerRadius = cornerSize
        }
    }
    
    /**
     Create outline view
     */
    @objc private func addOutline() {
        let path = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2),
                                radius: (self.frame.size.height/2) + self.outlineSpace,
                                startAngle: CGFloat(startAngle).toRadians(),
                                endAngle: CGFloat(endAngle).toRadians(),
                                clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.frame
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = self.outlineBorderColor?.cgColor
        shapeLayer.lineWidth = outlineBorderwidth
        self.superview?.layer.insertSublayer(shapeLayer, at: 0)
    }
}
