//
//  CarePlansCell.swift
//  MyTatva
//
//  Created by 2022M43 on 29/05/23.
//

import UIKit

class CarePlansCell: UITableViewCell {
    
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblSpeciality: UILabel!
    @IBOutlet weak var lblIncluded: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblMore: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var vwMore: UIView!
    @IBOutlet weak var vwBg: UIView!
    
    @IBOutlet weak var imgPlan: UIImageView!
    
    static let identifier = String(describing: CarePlansCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblPlanName.font(name: .bold, size: 15).textColor = .themePurple
        self.lblSpeciality.font(name: .medium, size: 14).textColor = .themeBlack
        self.lblIncluded.font(name: .medium, size: 12).textColor = .ThemeDarkGray
        self.lblDescription.font(name: .medium, size: 12).textColor = .ThemeDarkGray
        self.lblPrice.font(name: .bold, size: 20).textColor = .themeBlack
        self.lblMore.font(name: .medium, size: 10).textColor = .themePurple
    }
    
    func configCell() {
        
    }
}
