//
//  BCAOrderDetails + TableViewCell.swift
//  MyTatva
//
//  Created by 2022M02 on 31/05/23.
//

import Foundation

class BCAOrderTestDetailsCell : UITableViewCell {

    //MARK: - IBoutlet Variables -
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblFree          : UILabel!
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
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1)).text = "Test Name"
        self.lblFree
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8)).text = "Free"
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

class BCAOrderTrackDeviceCell : UITableViewCell {

    //MARK: - IBoutlet Variables -
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDate          : UILabel!
    @IBOutlet weak var vwCenterPoint    : UIView!
    @IBOutlet weak var vwTopPoint       : UIView!
    @IBOutlet weak var vwBottomPoint    : UIView!
    //----------------------------------------------------------------------
    
    //MARK: - Custom Variables -
    
    //----------------------------------------------------------------------
    
    //MARK: - custom Methods -
    func setup() {
        self.applyStyle()
        self.configUI()
    }
    
    func applyStyle() {
        self.lblTitle
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1)).text = "Test Name"
        self.lblDate
            .font(name: .medium, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7)).text = "Free"
        self.vwTopPoint.backGroundColor(color: .themeNormal)
        self.vwBottomPoint.backGroundColor(color: .themeNormal)
    }
    
    func configUI() {
        DispatchQueue.main.async {
            self.vwCenterPoint
                .backGroundColor(color: .themeNormal).setRound()
        }
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
