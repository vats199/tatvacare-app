//
//  TestListCell.swift
//  MyTatva
//
//  Created by Hlink on 28/06/23.
//

import Foundation
class TestListCell: UITableViewCell {

    //MARK: Outlets -
    @IBOutlet weak var constTopMain: NSLayoutConstraint!
    @IBOutlet weak var constBottomMain: NSLayoutConstraint!
    
    @IBOutlet weak var vwShadow: UIView!
    @IBOutlet weak var vwMain: UIView!
    
    @IBOutlet weak var vwLine: UIView!
    
    @IBOutlet weak var vwTest: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblBCPTest: UILabel!
    
    @IBOutlet weak var vwTestName: UIView!
    @IBOutlet weak var imgTest: UIImageView!
    @IBOutlet weak var lblTestName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var vwMainTop: NSLayoutConstraint!
    @IBOutlet weak var vwLineBottomConst: NSLayoutConstraint!
    
    
    //MARK: Class Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTestName.font(name: .regular, size: 12).textColor(color: .themeBlack2)
        self.lblBCPTest.font(name: .bold, size: 14.0).textColor(color: .themeBlack2)
        self.btnDelete.setImage(UIImage(named: "delete_ic"), for: .normal)
        self.imgTest.image = UIImage(named: "test_like")
//        self.imgCheck.isHidden = true
        
        
    }
}
