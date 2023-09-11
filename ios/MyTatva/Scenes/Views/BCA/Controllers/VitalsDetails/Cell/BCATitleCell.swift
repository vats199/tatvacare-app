//
//  BCATitleCell.swift
//  MyTatva
//
//  Created by 2022M02 on 10/05/23.
//

import Foundation

class BCATitleCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var vwLine           : UIView!
    
    //MARK:- Class Variable
    
    override func awakeFromNib() {
        self.lblTitle
            .font(name: .medium, size: 13)
            .textColor(color: .themeGray)
    }
    
    func setData(object: BCAVitalsModel){
        self.lblTitle.text              = String(object.formattedReadingName)
        self.lblTitle
                .font(name: object.isSelected ? .bold : .medium, size: 13)
                .textColor(color: object.isSelected ? .themePurple : .themeGray)
        
        self.vwLine.backGroundColor(color: object.isSelected ? .themePurple : .clear)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwBg.layoutIfNeeded()
            self.vwLine.layoutIfNeeded()            
            self.vwLine.cornerRadius(cornerRadius: self.vwLine.frame.height / 2)
        }
    }
}
