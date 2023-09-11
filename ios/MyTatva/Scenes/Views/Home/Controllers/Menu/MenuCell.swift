//
//  MenuCell.swift
//  MyTatva
//
//

import Foundation

class MenuCell : UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var imgTitle     : UIImageView!
    @IBOutlet weak var imgArrow     : UIImageView!
    
    @IBOutlet weak var sepTop       : UIView!
    @IBOutlet weak var sepBottom    : UIView!
    
    var object = MenuListModel() {
        didSet {
            self.setCellData()
        }
    }

    
    override func awakeFromNib() {
    }
    
    func setCellData(){
        
        self.lblTitle.text          = self.object.name
        self.imgTitle.image         = UIImage(named: object.imageName)
        
        self.sepTop.isHidden        = true
        self.sepBottom.isHidden     = true
        self.imgArrow.image         = UIImage(named: "right_purple")
        self.imgArrow.isHidden      = true
        
        let type: MenuList = MenuList.init(rawValue: object.name) ?? .OrderTest
        switch type {
        case .FoodDiary:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .OrderTest:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .MyTatvaPlans:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .YourBadges:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .History:
            self.sepTop.isHidden        = true
            self.sepBottom.isHidden     = false
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .Bookmarks:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
            
        case .BookAppointment:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
            
        case .BookTest:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .AppTour:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .ReportIncident:
            
            self.lblTitle.font(name: .regular, size: 15).textColor(color: .themeRed)
            break
        case .FAQs:
//            self.lblTitle.font(name: .regular, size: 15).textColor(color: UIColor.themeBlack.withAlphaComponent(1))
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .Terms:
//            self.lblTitle.font(name: .regular, size: 15).textColor(color: UIColor.themeBlack.withAlphaComponent(1))
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .Logout:
            
//            self.lblTitle.font(name: .regular, size: 15).textColor(color: UIColor.themeBlack.withAlphaComponent(1))
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        
        case .ShareApp:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .RateApp:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .TransactionHistory:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .DefineYourGoals:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .GoalsHealthTrends:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .DiagnosticReport:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .ContactUs:
            self.sepTop.isHidden        = false
            self.sepBottom.isHidden     = true
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        case .PrivacyPolicy:
            self.lblTitle.font(name: .semibold, size: 17).textColor(color: .themePurple)
            break
        }
    
        self.selectionStyle = .none
        self.layoutIfNeeded()
    }
}
