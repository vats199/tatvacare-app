//
//  WalkthroughColCell.swift
//  MyTatva
//
//  Created by Uttam patel on 05/06/23.
//

import UIKit

class WalkthroughColCell: UICollectionViewCell {

    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var vwGif: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var imgGif: UIImageView!
    @IBOutlet weak var vwBgWidthConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    //MARK: - Custom Methods -
    
    func applyStyle () {
       
        self.vwBgWidthConst.constant = UIScreen.main.bounds.size.width
        self.lblTitle.font(name: .heavy, size: 24).textColor(color: .themeBlack2)
        self.lblDescription.font(name: .medium, size: 16).textColor(color: .themeGray5)
    }
    
    //---------------------------------------------------------------------------

}
