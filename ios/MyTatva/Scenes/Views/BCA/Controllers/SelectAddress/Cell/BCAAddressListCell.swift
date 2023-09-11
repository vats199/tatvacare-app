//
//  BCAAddressListCell.swift
//  MyTatva
//
//  Created by 2022M02 on 30/05/23.
//

import Foundation

class BCAAddressListCell : UITableViewCell {

    //MARK: - IBoutlet Variables -
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var btnRadio         : UIButton!
    @IBOutlet weak var imgIcon          : UIImageView!
    @IBOutlet weak var vwSaperator      : UIView!
    //----------------------------------------------------------------------
    
    //MARK: - Custom Variables -
    
    //----------------------------------------------------------------------
    
    //MARK: - custom Methods -
    func setup() {
        self.applyStyle()
    }
    
    func applyStyle() {
        self.lblTitle
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
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
    
    override func awakeFromNib() {
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.vwBg.layoutIfNeeded()
//            self.vwBg.cornerRadius(cornerRadius: 10).applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 2)
////            self.vwBg.themeShadow()
//
//        }
    }
}
