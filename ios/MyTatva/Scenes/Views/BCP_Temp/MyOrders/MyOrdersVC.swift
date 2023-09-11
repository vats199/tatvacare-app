//
//  MyOrdersVC.swift
//  MyTatva
//
//  Created by 2022M43 on 31/05/23.
//

import Foundation
import UIKit
class MyOrdersVCCell: UITableViewCell {
    
    //MARK: - Outlets -
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblPurchesOn: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var imgOrderStatus: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgAddress: UIImageView!
    @IBOutlet weak var imgMobile: UIImageView!
    
    @IBOutlet weak var lblAmountPaid: UILabel!
    @IBOutlet weak var lblAmountPaidRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblPlanName.font(name: .regular, size: 11).textColor(color: .themeBlack).text = "Care Plans for Fatty Liver (NAFLD/NASH)"
        self.lblName.font(name: .bold, size: 11).textColor(color: .themeBlack).text = "Name"
       // self.lblAddress.font(name: .regular, size: 11).textColor(color: .ThemeGray61).text = "Address"
        self.lblMobileNo.font(name: .regular, size: 11).textColor(color: .ThemeGray61).text = "+91-9990000000"
        self.lblOrderStatus.font(name: .bold, size: 13).textColor(color: .themeBlack).text = "Order Confirmed"
        self.lblPurchesOn.font(name: .regular, size: 11).textColor(color: .ThemeGray61).text = "Purchased on :"
        self.lblDate.font(name: .medium, size: 11).textColor(color: .themeBlack).text = "18 March 2023"
        
        self.lblAmountPaid.font(name: .bold, size: 13).textColor(color: .themeBlack).text = "Amount Paid"
        self.lblAmountPaidRate.font(name: .bold, size: 13).textColor(color: .themeBlack).text = "₹ 1,999"
        
        DispatchQueue.main.async {
            let myString:NSString = "Order ID : 37035002" as NSString
            var myMutableString = NSMutableAttributedString()
            
            let range1 = (myString as NSString).range(of: "Order ID :")
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 13),NSAttributedString.Key.foregroundColor : UIColor.ThemeGray61])
            myMutableString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.themeBlack,
                                           NSAttributedString.Key.font : UIFont.customFont(ofType: .bold, withSize: 13)],
                                                                             range: range1)
            
            self.lblOrderID.attributedText = myMutableString
        }
    }
    
    
}

class MyOrdersVC: UIViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var lblNavTitle: SemiBoldBlackTitle!
    @IBOutlet weak var tblOrderData: UITableView!
    //------------------------------------------------------
    //MARK: - Class Variables -
    
    //------------------------------------------------------
    //MARK: - UIView Life Cycle Methods -
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    //------------------------------------------------------
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    //MARK: - Custome Methods -
    func setUpView() {
        self.applyStyle()
        
        self.tblOrderData.delegate = self
        self.tblOrderData.dataSource = self
    }
    
    func applyStyle() {
        self.lblNavTitle.text = "My Orders"
        
    }
    
    //MARK: - Button Action Methods -
}

//MARK: UITableViewDelegate and UITableViewDataSource
extension MyOrdersVC : UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MyOrdersVCCell.self)
        return cell
    }
    
}
