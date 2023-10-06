//
//  OrderReviewVC.swift
//  MyTatva
//
//  Created by 2022M43 on 13/06/23.
//

import Foundation
import UIKit
import Razorpay

class OrderReviewVC: LightPurpleNavigationBase {
    
    //MARK: - Outlets -
    @IBOutlet weak var lblNavTitle: SemiBoldBlackTitle!
    
    //----------------- Patient Details -------------------
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblPatientName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var imgAddress: UIImageView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var imgMobile: UIImageView!
    
    //----------------- Collection Details -------------------
    @IBOutlet weak var lblCollectionDetails: UILabel!
    @IBOutlet weak var lblAppoitmentDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var imgClock: UIImageView!
    
    //----------------- Test Details -------------------
    @IBOutlet weak var lblTestDetails: UILabel!
    @IBOutlet weak var tblTest: UITableView!
    @IBOutlet weak var tblTestHeightConst: NSLayoutConstraint!
    
    //----------------- Billing -------------------
    @IBOutlet weak var vwBilling: UIView!
    @IBOutlet weak var lblBilling: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalOldAmount: UILabel!
    @IBOutlet weak var lblTotalAmountRate: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblSubTotalRate: UILabel!
    @IBOutlet weak var lblSubTotalOldAmount: UILabel!
    @IBOutlet weak var lblCollectionCharge: UILabel!
    @IBOutlet weak var lblCollectionChargeRate: UILabel!
    @IBOutlet weak var lblCollectionOldAmount: UILabel!
    @IBOutlet weak var lblServiceCharge: UILabel!
    @IBOutlet weak var lblServiceChargeRate: UILabel!
    @IBOutlet weak var lblAmountPaid: UILabel!
    @IBOutlet weak var lblAmountPaidRate: UILabel!
    
    @IBOutlet weak var lblDiscountItemsCharge: UILabel!
    @IBOutlet weak var lblDiscountItemsChargeRate: UILabel!
    @IBOutlet weak var lblApplyCouponCharge: UILabel!
    @IBOutlet weak var lblApplyCouponChargeRate: UILabel!
    
    //----------------- Agree -------------------
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var lblAgreeConditions: UILabel!
   
    //----------------- Process -------------------
    @IBOutlet weak var vwProcess: UIView!
    @IBOutlet weak var lblTotalPayable: UILabel!
    @IBOutlet weak var lblTotalPayablePrice: UILabel!
    @IBOutlet weak var btnProcess: ThemePurple16Corner!
    
    //---------------- View Container --------------
    @IBOutlet weak var vwAccountDetails: UIView!
    @IBOutlet weak var vwSampleDetails: UIView!
    @IBOutlet weak var vwTestDetails: UIView!
    @IBOutlet weak var vwBillingDetails: UIView!
    @IBOutlet weak var vwMainApplyCoupon: UIView!
    @IBOutlet weak var vwApplyCouponCharge: UIView!
    @IBOutlet weak var vwDiscountCharge: UIView!
    
    //----------------- Apply Coupon -------------------
    
    @IBOutlet weak var lblHeaderOffers: UILabel!
    @IBOutlet weak var vwApplyCoupon: UIView!
    @IBOutlet weak var lblApplyCoupon: UILabel!
    
    //------------------------------------------------------
    //MARK: - Class Variables -
    
    private let viewModel           = TestOrderReviewVM()
    var cartListModel: CartListModel!
    var labPatientListModel         = LabPatientListModel()
    var labAddressListModel         = LabAddressListModel()
    var selectedTimeSlot            = ""
    var selectedTimeTitle           = ""
    var selectedDate                = Date()
    
    var totalOldAmount = 0
    var totalAmount = 0
    
    var homeOldCollectionCharge = 0
    var homeCollectionCharge = 0
    
    var serviceCharge = 0
    
    var finalPayableAmount = 0
    
    var razorpayObj : RazorpayCheckout? = nil
    
    var promoCodeAmount = 0
    
    //------------------------------------------------------
    //MARK: - UIView Life Cycle Methods -
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        WebengageManager.shared.navigateScreenEvent(screen: .BookLabtestAppointmentReview)
    }
        
    //------------------------------------------------------
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    //MARK: - Custome Methods -
    func setUpView() {
        self.setupViewModelObserver()
        self.applyStyle()
        self.addObserverOnHeightTbl()
        self.manageActionMethods()
        
        self.tblTest.delegate = self
        self.tblTest.dataSource = self
        
    }
    
    func applyStyle() {
        
        self.lblNavTitle.text = "Lab Test Summary"
        
        // ---------- Patient Details ----------
        self.lblSummary.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Summary"
        self.lblPatientName.font(name: .bold, size: 14).textColor(color: .themeBlack2).text = UserModel.shared.name
        self.lblAddress.font(name: .regular, size: 13).textColor(color: .ThemeDarkGray).text = "\(self.labAddressListModel.address ?? "")\n\(self.labAddressListModel.street ?? "")\n\(self.labAddressListModel.pincode ?? 0)"
        self.lblAddress.numberOfLines = 0
        self.lblEmail.font(name: .regular, size: 13).textColor(color: .ThemeDarkGray).text = UserModel.shared.email
        self.lblMobile.font(name: .regular, size: 13).textColor(color: .ThemeDarkGray).text = UserModel.shared.countryCode + " " + UserModel.shared.contactNo
    
        self.imgAddress.image = UIImage(named: "grayAddress_ic")
        self.imgEmail.image = UIImage(named: "grayMail_ic")
        
  //    self.imgMobile.image = UIImage(named: "callGray_ic")
        
        //----------------- Collection Details -------------------
        self.lblCollectionDetails.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Sample Collection Details"
        
        self.imgCalender.image = UIImage(named: "icon_Calender")
        self.imgClock.image = UIImage(named: "icon_Clock")
        
        self.lblAppoitmentDate
            .font(name: .regular, size: 12).textColor(color: .ThemeBlack21)
            .text = "Appointment On: May 23, 2023"
        
        self.lblTime
            .font(name: .regular, size: 12).textColor(color: .ThemeBlack21)
            .text = "Time: 8:00 - 9:00 PM"
        
        // ---------- Test Details ----------
        self.lblTestDetails.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Test Details"
        
        // ---------- Billing Details ----------
        self.lblBilling.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Billing"
        self.lblTotalAmount.font(name: .regular, size: 13).textColor(color: .ThemeGray61).text = "Total Amount"
        self.lblSubTotal.font(name: .regular, size: 13).textColor(color: .ThemeGray61).text = "Sub Total"
        self.lblCollectionCharge.font(name: .regular, size: 13).textColor(color: .ThemeGray61).text = "Home Collection Charges"
        self.lblServiceCharge.font(name: .regular, size: 13).textColor(color: .ThemeGray61).text = "Service Charge"
        
        self.lblTotalAmountRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "Free"
        self.lblSubTotalRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "Free"
        self.lblCollectionChargeRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "Free"
        self.lblServiceChargeRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "Free"
        
        self.lblAmountPaid.font(name: .bold, size: 14).textColor(color: .themeBlack).text = "Amount to be Paid"
        self.lblAmountPaidRate.font(name: .bold, size: 14).textColor(color: .themeBlack).text = "Free"
        
        self.lblDiscountItemsCharge.font(name: .regular, size: 13).textColor(color: .ThemeGray61).text = "Discount on Item(s)"
        self.lblDiscountItemsChargeRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "Free"
        self.lblApplyCouponCharge.font(name: .regular, size: 13).textColor(color: .ThemeGray61).text = "Applied Coupon (\(kApplyCouponName))"
        self.lblApplyCouponChargeRate.font(name: .medium, size: 14).textColor(color: .themeGreen).text = "Free"
       
        self.lblAgreeConditions.text = "I agree to the Terms & Conditions"

        self.lblAgreeConditions.font(name: .regular, size: 12.0).numberOfLines = 0
        self.lblAgreeConditions.isUserInteractionEnabled = true
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(tapLabelTerms(gesture:)))
        self.lblAgreeConditions.addGestureRecognizer(gesture2)

        self.lblAgreeConditions.setAttributedString(["I agree to the","Terms & Conditions"], attributes: [[
            NSAttributedString.Key.foregroundColor : UIColor.themeGray5
        ],[
            NSAttributedString.Key.foregroundColor : UIColor.themeGray5,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]])
        
        // ---------- Process ----------
        self.lblTotalPayable.font(name: .regular, size: 10).textColor(color: .ThemeGray61).text = "Total Payable"
        self.lblTotalPayablePrice.font(name: .bold, size: 16).textColor(color: .themeBlack).text = "Free"
        self.btnProcess.font(name: .bold, size: 12)
        
        self.setAttributedLabels()
       
        
        self.vwAccountDetails.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.tblTest.cornerRadius(cornerRadius: 12.0)
        self.vwTestDetails.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.vwBillingDetails.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.vwSampleDetails.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.vwProcess.themeShadowBCP()
        
        if !kApplyCouponName.isEmpty {
            self.vwMainApplyCoupon.isHidden = false
            self.vwDiscountCharge.isHidden = false
            self.vwApplyCouponCharge.isHidden = false
            self.lblApplyCouponChargeRate.text = "- \(appCurrencySymbol.rawValue)\(kCouponCodeAmount)"
            self.promoCodeAmount = kCouponCodeAmount
        } else {
            self.vwMainApplyCoupon.isHidden = true
            self.vwDiscountCharge.isHidden = false
            self.vwApplyCouponCharge.isHidden = true
        }
        
        self.vwApplyCoupon.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.lblHeaderOffers.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Offers & Promotions"
        self.lblApplyCoupon.font(name: .semibold, size: 14).textColor(color: .themeBlack).text = "'\(kApplyCouponName)' applied"
        
        self.lblTotalOldAmount.isHidden = true
        self.lblCollectionOldAmount.isHidden = true
        
        self.setTestData()
    }
    
    func setAttributedLabels() {
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = DateTimeFormaterEnum.EEEEddMMMyyyy.rawValue
        self.lblAppoitmentDate.text = formatter.string(from: self.selectedDate)
        self.lblTime.text = selectedTimeTitle + "," + " " + self.selectedTimeSlot
    }
    
    func setTestData() {
        
        guard let _ = self.cartListModel else { return }
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 11),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        
        func setAmountData() {
//            [
//                self.lblTotalOldAmount,self.lblCollectionOldAmount
//            ].forEach({$0?.isHidden = false})
            
//            self.lblTotalAmountRate.text = appCurrencySymbol.rawValue + JSON(totalAmount as Any).stringValue
//            self.lblTotalOldAmount.text = appCurrencySymbol.rawValue + JSON(totalOldAmount as Any).stringValue
            
            self.lblTotalAmountRate.text = appCurrencySymbol.rawValue + JSON(totalOldAmount as Any).stringValue
            
            self.lblAmountPaidRate.text = appCurrencySymbol.rawValue + JSON(finalPayableAmount as Any).stringValue
            self.lblTotalPayablePrice.text = appCurrencySymbol.rawValue + JSON(finalPayableAmount as Any).stringValue
           
            self.lblTotalOldAmount.attributedText = self.lblTotalOldAmount.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
            
            self.lblCollectionOldAmount.text = appCurrencySymbol.rawValue + JSON(homeOldCollectionCharge as Any).stringValue
            self.lblCollectionOldAmount.attributedText = self.lblCollectionOldAmount.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
            self.lblCollectionChargeRate.text = appCurrencySymbol.rawValue + JSON(homeCollectionCharge as Any).stringValue
            self.lblServiceChargeRate.text = serviceCharge == 0 ? KFree : appCurrencySymbol.rawValue + "\(serviceCharge)"
            self.btnProcess.setTitle("Proceed to Payment", for: .normal)
            
            let dicountChargeRate = Int(JSON(totalOldAmount as Any).stringValue)! - Int(JSON(totalAmount as Any).stringValue)!
            
            self.lblDiscountItemsChargeRate.text = "- \(appCurrencySymbol.rawValue)\(dicountChargeRate)"
        }
        
        let isBCPAdded = self.cartListModel.bcpTestsList.contains(where: { $0.isBcpTestsAdded })
        let isOtherTestAdded = self.cartListModel.testsList.filter({$0.type != kBCP}).isEmpty
        
        self.vwBilling.isHidden = !( isBCPAdded || !isOtherTestAdded)
        
        self.lblSubTotal.superview?.isHidden = true
        
        guard let orderDetail = self.cartListModel.orderDetail, let homeCharge = self.cartListModel.homeCollectionCharge else { return }
        
        totalOldAmount = JSON(orderDetail.orderTotal as Any).intValue
        totalAmount = JSON(orderDetail.payableAmount as Any).intValue
        homeOldCollectionCharge = homeCharge.ammount
        homeCollectionCharge = homeCharge.payableAmmount
        serviceCharge = JSON(orderDetail.serviceCharge as Any).intValue
        finalPayableAmount = orderDetail.finalPayableAmount - self.promoCodeAmount
        
        if isBCPAdded && !isOtherTestAdded {
            var tempOldTotal = 0
            var tempAmount = 0
            if let bcpCartData = self.cartListModel.bcpTestsList.first(where: {$0.isBcpTestsAdded}) {
                bcpCartData.bcpTestsList.forEach({
                    tempOldTotal += $0.price
                    tempAmount += $0.discountPrice
                })
            }
            
            totalOldAmount -= tempOldTotal
            totalAmount -= tempAmount
            finalPayableAmount = (totalAmount+homeCollectionCharge+serviceCharge) - self.promoCodeAmount
            
            setAmountData()
            
        }
        else if isBCPAdded && isOtherTestAdded {
//            [
//                self.lblTotalOldAmount,self.lblCollectionOldAmount
//            ].forEach({$0?.isHidden = true})
//
            [
                self.lblTotalAmountRate,self.lblCollectionChargeRate,self.lblServiceChargeRate,self.lblAmountPaidRate
            ].forEach({$0?.text = KFree})
            self.btnProcess.setTitle("Confirm", for: .normal)
            
            self.finalPayableAmount = 0
            self.vwApplyCouponCharge.isHidden = true
            self.vwDiscountCharge.isHidden = true
            
        }
        else if !isBCPAdded && !isOtherTestAdded {
            setAmountData()
        }
        
    }
    
    func getAppointmentDate() -> String {
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = DateTimeFormaterEnum.yyyymmdd.rawValue
        return formatter.string(from: self.selectedDate)
    }
    
    func getPatientPlanRelID() -> String {
        var patient_plan_rel_id = ""
        
        if let temp = self.cartListModel.bcpTestsList.first(where: {$0.isBcpTestsAdded}) {
            patient_plan_rel_id = temp.patientPlanRelId
        }
        return patient_plan_rel_id
    }
        
    @objc func tapLabelTerms(gesture: UITapGestureRecognizer) {
        
        guard let text = lblAgreeConditions.attributedText?.string else {
            return
        }
        let vc = WebviewVC.instantiate(fromAppStoryboard: .setting)
        if let range = text.range(of: "Terms & Conditions".localized),gesture.didTapAttributedTextInLabel(label: self.lblAgreeConditions, inRange: NSRange(range, in: text)) {
            print("Tapped")
            vc.webType = .ThyrocareTerms
        }else {
            print("Tapped none")
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: - Button Action Methods -
    func manageActionMethods() {
        
        
        self.btnProcess.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            guard self.btnAgree.isSelected else {
                Alert.shared.showSnackBar(AppError.validation(type: .agreeTermsAndCondition).localizedDescription, isError: true, isBCP: true)
                return
            }
            
            var params              = [String : Any]()
            
            params[AnalyticsParameters.service_type.rawValue]       = "test"

            params[AnalyticsParameters.discount_code.rawValue]      = !kApplyCouponName.isEmpty ? kApplyCouponName : ""
            
            let dis = self.finalPayableAmount + self.promoCodeAmount
            params[AnalyticsParameters.amount_after_discount.rawValue]       = !kApplyCouponName.isEmpty ? "\(self.finalPayableAmount)" : ""
            params[AnalyticsParameters.amount_before_discount.rawValue]      = !kApplyCouponName.isEmpty ? "\(dis)" : "\(self.finalPayableAmount)"

            FIRAnalytics.FIRLogEvent(eventName: .TAP_PROCEED_TO_PAYMENT,
                                     screen: .BookLabtestAppointmentReview,
                                     parameter: params)
            
            var params1 = [String: Any]()
            
            FIRAnalytics.FIRLogEvent(eventName: .TAP_BOOK_LAB_TEST,
                                     screen: .BookLabtestAppointmentReview,
                                     parameter: params1)
            
            self.viewModel.check_book_testAPI(final_payable_amount: "\(self.finalPayableAmount)") { [weak self] isDone, order_id in
                guard let self = self else {return}
                if isDone {
                    guard self.finalPayableAmount == 0 else {
                        self.openRazorpayCheckout(order_id: order_id)
                        return
                    }
                    
                    var bcp_test_price_data = [String:Any]()
                    bcp_test_price_data["bcp_final_amount_to_pay"] = 0
                    bcp_test_price_data["bcp_home_collection_charge"] = 0
                    bcp_test_price_data["bcp_home_collection_charge_old"] = 0
                    bcp_test_price_data["bcp_service_charge"] = 0
                    bcp_test_price_data["bcp_total_amount"] = 0
                    bcp_test_price_data["bcp_total_amount_old"] = 0
                    
                    self.viewModel.apiCall(vc: self,
                                           appointment_date: self.getAppointmentDate(),
                                           slot_time: self.selectedTimeSlot,
                                           address_id: self.labAddressListModel.patientAddressRelId,
                                           transaction_id: "",
                                           order_total: self.cartListModel.orderDetail.orderTotal,
                                           payable_amount: self.cartListModel.orderDetail.payableAmount,
                                           final_payable_amount: "\(self.cartListModel.orderDetail.finalPayableAmount!)",
                                           home_collection_charge: "\(self.cartListModel.homeCollectionCharge.payableAmmount!)",
                                           service_charge: self.cartListModel.orderDetail.serviceCharge,
                                           bcp_flag: "Y",
                                           bcp_test_price_data: bcp_test_price_data,
                                           patient_plan_rel_id: self.getPatientPlanRelID())
                    
                }
            }
            
        }
        
        self.btnAgree.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.btnAgree.isSelected.toggle()
        }
    }
}

//MARK: UITableViewDelegate and UITableViewDataSource
extension OrderReviewVC : UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartListModel.testsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestDetailCell") as! TestDetailCell
        cell.btnDelete.isHidden = true
        cell.lblTestName.text = self.cartListModel.testsList[indexPath.row].name
        let isLast = indexPath.row == (self.cartListModel.testsList.count - 1)
        cell.vwLine.isHidden = isLast
        cell.consLineBottom.constant = isLast ? 6 : 12
        return cell
    }
    
}

//MARK: -------------------------- Observers Methods --------------------------
extension OrderReviewVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblTest, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            DispatchQueue.main.async {
                self.tblTestHeightConst.constant = newvalue.height
                self.tblTest.isScrollEnabled = false
            }
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblTest.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblTest else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------------- Payment methods --------------------------
extension OrderReviewVC: RazorpayResultProtocol {
    
    private func openRazorpayCheckout(order_id: String) {
        // 1. Initialize razorpay object with provided key. Also depending on your requirement you can assign delegate to self. It can be one of the protocol from RazorpayPaymentCompletionProtocolWithData, RazorpayPaymentCompletionProtocol.
        razorpayObj = RazorpayCheckout.initWithKey(RazorPayKey, andDelegate: self)
        let options: [AnyHashable:Any] = [
            "prefill": [
                "contact": UserModel.shared.countryCode + UserModel.shared.contactNo,
                "email": UserModel.shared.email
                //                "method":"wallet",
                //                "wallet":"amazonpay"
            ],
            "name": self.labPatientListModel.name ?? "",
            "description": "Lab test order",
            "currency": "INR",
            "amount" : self.cartListModel.orderDetail.finalPayableAmount * 100,
            "order_id": order_id
            //"image": "http://www.freepngimg.com/download/light/2-2-light-free-download-png.png",
            
            //            "timeout":10,
            //            "theme": [
            //                "color": "#F37254"
            //            ]//            "order_id": "order_B2i2MSq6STNKZV"
            // and all other options
        ]
        if let rzp = self.razorpayObj {
            rzp.open(options)
        } else {
            print("Unable to initialize")
        }
    }
    
    func onComplete(response: [AnyHashable : Any]) {
        print(response)
        
        if let rzp = self.razorpayObj {
            rzp.close()
        }
        
        let transaction_id = JSON(response["razorpay_payment_id"] as Any).stringValue
        
        var params1 = [String: Any]()
        params1[AnalyticsParameters.transaction_id.rawValue]  = transaction_id
        FIRAnalytics.FIRLogEvent(eventName: .LABTEST_ORDER_PAYMENT_SUCCESS,
                                 screen: .BookLabtestAppointmentReview,
                                 parameter: params1)
        
        let isBCPAdded = self.cartListModel.bcpTestsList.contains(where: {$0.isBcpTestsAdded})
        
        let bcp_test_price_data = [
            "bcp_final_amount_to_pay": self.finalPayableAmount,
            "bcp_home_collection_charge": self.homeCollectionCharge,
            "bcp_home_collection_charge_old": self.homeOldCollectionCharge,
            "bcp_service_charge": self.serviceCharge,
            "bcp_total_amount": self.totalAmount,
            "bcp_total_amount_old": self.totalOldAmount
        ]
        
        self.viewModel.apiCall(vc: self,
                               appointment_date: self.getAppointmentDate(),
                               slot_time: self.selectedTimeSlot,
                               address_id: self.labAddressListModel.patientAddressRelId,
                               member_id: isBCPAdded ? nil : self.labPatientListModel.patientMemberRelId,
                               transaction_id: transaction_id,
                               order_total: self.cartListModel.orderDetail.orderTotal,
                               payable_amount: self.cartListModel.orderDetail.payableAmount,
                               final_payable_amount: "\(self.cartListModel.orderDetail.finalPayableAmount!)",
                               home_collection_charge: "\(self.cartListModel.homeCollectionCharge.payableAmmount!)",
                               service_charge: self.cartListModel.orderDetail.serviceCharge,
                               bcp_flag: isBCPAdded ? "Y" : nil,
                               bcp_test_price_data: isBCPAdded ? bcp_test_price_data : nil,
                               patient_plan_rel_id: isBCPAdded ? self.getPatientPlanRelID() : nil
        )
        
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension OrderReviewVC {
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                
                DispatchQueue.main.async {
                    var params1 = [String: Any]()
                    params1[AnalyticsParameters.order_master_id.rawValue]  = self.viewModel.order_master_id
                    FIRAnalytics.FIRLogEvent(eventName: .LABTEST_ORDER_BOOK_SUCCESS,
                                             screen: .BookLabtestAppointmentReview,
                                             parameter: params1)
                    
                    let vc = TestOrderSuccessVC.instantiate(fromAppStoryboard: .carePlan)
                    vc.cartListModel            = self.cartListModel
                    vc.labPatientListModel      = self.labPatientListModel
                    vc.labAddressListModel      = self.labAddressListModel
                    vc.selectedTimeSlot         = self.selectedTimeSlot
                    vc.selectedDate             = self.selectedDate
                    vc.order_master_id          = self.viewModel.order_master_id
                    vc.finalPayableAmount       = self.finalPayableAmount
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
                
            case .failure(let error):
//                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true, isBCP: true)
            case .none: break
            }
        })
        
    }
}

