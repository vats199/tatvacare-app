//
//  DiscountVC.swift
//  MyTatva
//
//  Created by 2022M43 on 22/08/23.
//

import Foundation
import UIKit
class DiscountVC: LightPurpleNavigationBase {
    
    //MARK: - Outlets -
    @IBOutlet weak var lblNavTitle: SemiBoldBlackTitle!
    
    @IBOutlet weak var vwCouponCode: UIView!
    @IBOutlet weak var txtCouponCode: UITextField!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var tblCoupons: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    
    //------------------------------------------------------
    //MARK: - Class Variables -
    let viewModel = DiscountVM()
    var completionHandler: ((String, String, Int, String) -> Void)?
    
    var IS_FROM_LAB_TEST = false
    
    var payableAmount = ""
    var pendingRequest:DispatchWorkItem?
  
    //------------------------------------------------------
    //MARK: - UIView Life Cycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.ApiDiscountList(withLoader: false, discount_type: self.IS_FROM_LAB_TEST ? "L" : "P", price: self.payableAmount ) { isSuccess, msg in
            if isSuccess {
                if self.viewModel.arrList.isEmpty {
                    self.tblCoupons.setEmptyMessage(msg)
                } else {
                    self.tblCoupons.restoreEmptyMessage()
                }
                self.tblCoupons.reloadData()
                
            }
        }
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
        self.manageActionMethods()
       
        self.txtCouponCode.delegate = self
        
        self.tblCoupons.delegate = self
        self.tblCoupons.dataSource = self
        self.tblCoupons.register(UINib(nibName: "DiscountCell", bundle: nil), forCellReuseIdentifier: "DiscountCell")
        self.tblCoupons.separatorStyle = .none
        if #available(iOS 15.0, *) {
            self.tblCoupons.sectionHeaderTopPadding = 0.0
        }
        
        self.txtCouponCode.font(name: .semibold, size: 14).textColor(color: .ThemeBlack21)
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.themeGray4,
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 12)
        ]

        self.txtCouponCode.attributedPlaceholder = NSAttributedString(string: "Enter Coupon Code", attributes:attributes)
        self.txtCouponCode.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.txtCouponCode.setRightPadding(60)
        self.viewModel.isFromLabTest = self.IS_FROM_LAB_TEST
    }
    
    func applyStyle() {
        
        self.lblHeader.font(name: .bold, size: 16).textColor(color: .ThemeBlack21).text = "Coupons For You"
        self.vwCouponCode.cornerRadius(cornerRadius: 12.0).borderColor(color: .themeBorder2).themeTextFieldShadow()
        self.btnApply.font(name: .semibold, size: 14).textColor(color: .ThemeGray9E).isUserInteractionEnabled = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.btnApply.textColor(color: textField.text!.isEmpty ? .ThemeGray9E : .themePurple)
        self.btnApply.isUserInteractionEnabled = textField.text!.isEmpty ? false : true
    }
    
    //MARK: - Button Action Methods -
    func manageActionMethods() {
        self.btnApply.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.viewModel.ApiCheckDiscountList(withLoader: false, discounts_master_id: "", price: self.payableAmount, discount_Code: self.txtCouponCode.text!) { isSuccess, finalPrice, discountAmount, subHeading  in
                if isSuccess {
                    if self.IS_FROM_LAB_TEST {
                        kCouponCodeAmount = discountAmount
                        kApplyCouponName = self.txtCouponCode.text!
                        kDiscountMasterId = self.viewModel.discountData?.discountsMasterId ?? ""
                        kDiscountType = self.viewModel.discountData?.discountType ?? ""
                    } else {
                        kBCPCouponCodeAmount = discountAmount
                        kBCPApplyCouponName = self.txtCouponCode.text!
                        kBCPDiscountMasterId = self.viewModel.discountData?.discountsMasterId ?? ""
                        kBCPDiscountType = self.viewModel.discountData?.discountType ?? ""
                    }
                    
                    var params = [String:Any]()
                    params[AnalyticsParameters.discount_code.rawValue] = self.txtCouponCode.text!
                    params[AnalyticsParameters.design_element_type.rawValue] = "discount_textfield"
                    FIRAnalytics.FIRLogEvent(eventName: .APPLY_CLICK,
                                             screen: .CouponCodeList,
                                             parameter: params)
                   
                    self.navigationController?.popViewController(animated: true)
                    self.completionHandler?(self.txtCouponCode.text!, self.viewModel.discountData?.label ?? "", discountAmount, subHeading)
                }
            }
        }
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension DiscountVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case self.txtCouponCode :
            self.vwCouponCode.borderColor(color: .themePurpleBlack)
            break
        default:
            break
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case self.txtCouponCode :
            self.vwCouponCode.borderColor(color: self.txtCouponCode.text!.isEmpty ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
            self.btnApply.textColor(color: self.txtCouponCode.isEmpty ? .ThemeGray9E : .themePurple)
            self.btnApply.isUserInteractionEnabled = self.txtCouponCode.isEmpty ? false : true
            break
        default:
            break
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtCouponCode {
            
            self.pendingRequest?.cancel()
            self.pendingRequest = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                if textField.text!.count >= 10 {
                    var params = [String:Any]()
                    
                    params[AnalyticsParameters.discount_code.rawValue] = textField.text
                    FIRAnalytics.FIRLogEvent(eventName: .USER_ENTERS_CODE,
                                             screen: .CouponCodeList,
                                             parameter: params)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: self.pendingRequest!)
            
           
            if range.location >= 10 {
                return false
            }
        }
        return true
        
    }
}


//MARK: UITableViewDelegate and UITableViewDataSource
extension DiscountVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscountCell") as! DiscountCell
        let obj = self.viewModel.listOfRow(indexPath.row)
        
        cell.lblCode.text = obj.discountCode
        cell.lblGetOff.text = obj.label
        cell.lblUpto.text = obj.onlydescription
        cell.vwDesc.isHidden = !obj.isSelected
        cell.imgViewHideIcon.image = obj.isSelected ? UIImage(named: "upArrow_ic") : UIImage(named: "downArrow_ic")
        cell.lblViewHideDetails.text = obj.isSelected ? "Hide Details" : "View Details"
        cell.vwViewHideMain.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            
            var params = [String:Any]()
            params[AnalyticsParameters.discount_code.rawValue] = obj.discountCode
            params[AnalyticsParameters.action.rawValue] = obj.isSelected ? "hide" : "view"
            FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_DETAILS,
                                     screen: .CouponCodeList,
                                     parameter: params)
            
            self.viewModel.didSelectect(indexPath.row)
            self.tblCoupons.reloadData()
        }
        
        let value = Float(obj.minCartPrice)
        let finalValue = Int(value!)
        
        if obj.isActive == "N" || finalValue > Int(self.payableAmount) {
            cell.lblCode.textColor(color: .themeGray4)
            cell.lblGetOff.textColor(color: .ThemeGray61)
            cell.lblUpto.textColor(color: .themeGray4)
            cell.lblViewHideDetails.textColor(color: .themeGray4)
            cell.lblApply.textColor(color: .themeGray4)
            cell.imgDiscount.image = UIImage(named: "discount_icGray")
            cell.imgViewHideIcon.image = UIImage(named: "downArrow_icGray")
            cell.btnApply.isUserInteractionEnabled = false
            cell.vwViewHideMain.isUserInteractionEnabled = false
        } else {
            cell.lblCode.textColor(color: .themeBlack2)
            cell.lblGetOff.textColor(color: .ThemeGray61)
            cell.lblUpto.textColor(color: .themeGray4)
            cell.lblViewHideDetails.textColor(color: .themePurple)
            cell.lblApply.textColor(color: .themePurple)
            cell.imgDiscount.image = UIImage(named: "discount_ic")
            cell.imgViewHideIcon.image = obj.isSelected ? UIImage(named: "upArrow_ic") : UIImage(named: "downArrow_ic")
            cell.btnApply.isUserInteractionEnabled = true
            cell.vwViewHideMain.isUserInteractionEnabled = true
        }
        
        cell.webDesc.loadHTMLString(obj.descriptionField.replacingOccurrences(of: """
                                        \"
                                        """, with: """
                                        "
                                        """), baseURL: Bundle.main.bundleURL)

        cell.btnApply.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.viewModel.ApiCheckDiscountList(withLoader: false, discounts_master_id: obj.discountsMasterId, price: self.payableAmount, discount_Code: "") { isSuccess, finalPrice, discountAmount, subHeading  in
                if isSuccess {
                    if self.IS_FROM_LAB_TEST {
                        kCouponCodeAmount = discountAmount
                        kApplyCouponName = obj.discountCode
                        kDiscountMasterId = obj.discountsMasterId
                        kDiscountType = obj.discountType
                    } else {
                        kBCPCouponCodeAmount = discountAmount
                        kBCPApplyCouponName = obj.discountCode
                        kBCPDiscountMasterId = obj.discountsMasterId
                        kBCPDiscountType = obj.discountType
                    }
                    
                    var params = [String:Any]()
                    params[AnalyticsParameters.discount_code.rawValue] = obj.discountCode
                    params[AnalyticsParameters.design_element_type.rawValue] = "discount_card"
                    FIRAnalytics.FIRLogEvent(eventName: .APPLY_CLICK,
                                             screen: .CouponCodeList,
                                             parameter: params)
                    
                    self.navigationController?.popViewController(animated: true)
                    self.completionHandler?(obj.discountCode, obj.label ,discountAmount, subHeading)
                }
            }
        }
        
        return cell
    }
  
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width, height: 25))
        lbl.font(name: .bold, size: 16)
        lbl.text = "Coupons For You"
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }*/
}
