//
//  BcaListCell.swift
//  MyTatva
//
//  Created by 2022M02 on 09/05/23.
//

import Foundation

enum BCAVitalRange: String {
    case Low = "Low"
    case Normal = "Normal"
    case High = "High"
    case TooHigh = "Too High"
    case Good = "Good"
    
    var bgColor:UIColor {
        switch self {
        case .Normal: return UIColor.hexStringToUIColor(hex: "#25DD25")
        case .Low: return UIColor.hexStringToUIColor(hex: "#F48A26")
        case .High: return UIColor.hexStringToUIColor(hex: "#F94E4E")
        case .TooHigh: return UIColor.hexStringToUIColor(hex: "#FF0000")
        case .Good: return UIColor.hexStringToUIColor(hex: "#0E8001")
        }
    }
    
}

class BcaListCell : UICollectionViewCell {

    //MARK: - IBoutlet Variables -
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var vwOffer          : UIView!
    @IBOutlet weak var lblOffer         : UILabel!
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    
    @IBOutlet weak var imgIcon          : UIImageView!
    
    //----------------------------------------------------------------------
    
    //MARK: - Custom Variables -
    
    //----------------------------------------------------------------------
    
    //MARK: - custom Methods -
    func setup() {
        self.applyStyle()
    }
    
    func applyStyle() {
        self.lblTitle
            .font(name: .bold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblDesc
            .font(name: .light, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblOffer
            .font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.vwOffer.backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.4))
    }
    
    func setData(object: BCAVitalsModel){
        
        let range = BCAVitalRange(rawValue: object.readingRange) ?? .Normal
        
        if object.readingValue.isEmpty {
            self.lblTitle.text              = "-"
        }else {
            GFunction.shared.setReadingData(obj: object, lblReading: self.lblTitle)
        }
        
        self.lblDesc.text               = object.readingName + "(" + object.measurements + ")"
        self.lblOffer.text              = range.rawValue
        self.imgIcon.setCustomImage(with: object.imageUrl)
        self.imgIcon.contentMode = .scaleAspectFit
        self.imgIcon.superview!.backGroundColor(color: UIColor.hexStringToUIColor(hex: object.colorCode).withAlphaComponent(0.15)).cornerRadius(cornerRadius: 4.0)
        
        let rangeColor = range.bgColor
        self.vwOffer.backGroundColor(color: rangeColor.withAlphaComponent(0.15))
        self.lblOffer.textColor(color: rangeColor)
        
    }
    //----------------------------------------------------------------------
    
    override func awakeFromNib() {
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10).applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 2)
//            self.vwBg.themeShadow()
            self.vwOffer.roundCorners([.bottomLeft, .topRight], radius: 10)
        }
    }
}
