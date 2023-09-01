//
//  BCPCartHeaderCell.swift
//  MyTatva
//
//  Created by Hlink on 23/06/23.
//

import Foundation
class BCPCartHeaderCell: UIView {
    
    //MARK: - Outlets
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwTopConst: NSLayoutConstraint!
    @IBOutlet weak var vwBottomConst: NSLayoutConstraint!
    
    //MARK: - Class Variables
    
    //MARK: - deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(self) ‼️‼️‼️")
    }
    
    //MARK: - LifeCycleMethods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    //MARK: - Custom Methods
    private func applyStyle() {
        self.backGroundColor(color: .clear)
//        self.lblTitle.font(name: .bold, size: 13).textColor(color: .themeBlack)
    }
    
    func configure() {
        
    }
    
    
}
