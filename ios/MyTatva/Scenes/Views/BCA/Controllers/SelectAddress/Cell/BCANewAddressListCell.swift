//
//  BCANewAddressListCell.swift
//  MyTatva
//
//  Created by Uttam patel on 15/09/23.
//

import UIKit

class BCANewAddressListCell: UITableViewCell {

    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblAddress       : UILabel!
    @IBOutlet weak var imgIcon          : UIImageView!
    @IBOutlet weak var btnMore          : UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgLine: UIImageView!
    @IBOutlet weak var vwBtn: UIView!
    
    @IBOutlet weak var vwEdit: UIView!
    @IBOutlet weak var vwDelete: UIView!
    
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var lblEdit: UILabel!
    
    @IBOutlet weak var imgDelete: UIImageView!
    @IBOutlet weak var lblDelete: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        self.applyStyle()
    }
    
    func applyStyle() {
        self.vwBg.cornerRadius(cornerRadius: 16).themeShadowBCP()
        self.vwBtn.cornerRadius(cornerRadius: 16).themeShadowBCP()
        
        self.vwEdit.cornerRadius(cornerRadius: 16)
        self.vwDelete.cornerRadius(cornerRadius: 16)
        
        self.btnEdit.cornerRadius(cornerRadius: 16)
        self.btnDelete.cornerRadius(cornerRadius: 16)
        
        self.lblTitle.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblAddress
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        
        self.lblEdit.font(name: .regular, size: 12)
            .textColor(color: UIColor.ThemeGray61).text = "Edit"
        self.lblDelete.font(name: .regular, size: 12)
            .textColor(color: UIColor.ThemeGray61).text = "Delete"
        
        self.imgEdit.image = UIImage(named: "ic_Edit_gray")
        self.imgDelete.image = UIImage(named: "ic_Delete_gray")
        
        self.vwBtn.isHidden = true
        self.imgLine.backGroundColor(color: .themeBorder2)
    }
    
    
    func setData(object: BCAVitalsModel){
        
        let range = BCAVitalRange(rawValue: object.readingRange) ?? .Normal
        
        if object.readingValue.isEmpty {
            self.lblTitle.text              = "-"
        }else {
            GFunction.shared.setReadingData(obj: object, lblReading: self.lblTitle)
        }
        
       
        self.imgIcon.setCustomImage(with: object.imageUrl)
        self.imgIcon.contentMode = .scaleAspectFit
        self.imgIcon.superview!.backGroundColor(color: UIColor.hexStringToUIColor(hex: object.colorCode).withAlphaComponent(0.15)).cornerRadius(cornerRadius: 4.0)
        
        let rangeColor = range.bgColor
        
    }
    //----------------------------------------------------------------------
    
}
