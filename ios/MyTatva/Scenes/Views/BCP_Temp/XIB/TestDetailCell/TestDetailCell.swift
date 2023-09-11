//
//  TestDetailCell.swift
//  MyTatva
//
//  Created by 2022M43 on 13/06/23.
//

import UIKit

class TestDetailCell: UITableViewCell {

    //MARK: Outlets -
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgTest: UIImageView!
    @IBOutlet weak var lblTestName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var vwLine: UIView!
    @IBOutlet weak var consLineBottom: NSLayoutConstraint!
    @IBOutlet weak var consImgTop: NSLayoutConstraint!
    
    //MARK: Class Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTestName.font(name: .regular, size: 11).textColor(color: .themeBlack2).text = "Test Name"
        self.btnDelete.setImage(UIImage(named: "delete_ic"), for: .normal)
        self.imgTest.image = UIImage(named: "test_like")
    }
}
