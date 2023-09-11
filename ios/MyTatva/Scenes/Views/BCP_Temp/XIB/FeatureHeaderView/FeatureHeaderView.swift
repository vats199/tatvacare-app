//
//  FeatureHeaderView.swift
//  MyTatva
//
//  Created by Hlink on 05/06/23.
//

import Foundation
class FeatureHeaderView: UIView {
    
    //------------------------------------------------------
    //MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var constBottom: NSLayoutConstraint!
    
    //------------------------------------------------------
    //MARK: - ClassMethods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
    
    //------------------------------------------------------
    //MARK: - CustomMethods
    private func applyStyle() {
        self.lblTitle.font(name: .medium, size: 12.0).textColor(color: .themeBlack).numberOfLines = 0
    }
    
}
