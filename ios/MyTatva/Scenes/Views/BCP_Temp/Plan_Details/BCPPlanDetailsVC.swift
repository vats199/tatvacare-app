//
//  PlanDetailsVC.swift
//  MyTatva
//
//  Created by 2022M43 on 31/05/23.
//

import Foundation
import UIKit
import Razorpay

enum ToView {
    case AddAddress
    case SelectAddress
}

class BCPPlanDetailsVC: LightPurpleNavigationBase {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var lblNavTittle: SemiBoldBlackTitle!
    @IBOutlet weak var btnHelp: UIBarButtonItem!
    
    // ---------- planDetails ----------
    @IBOutlet weak var lblPlanDetails: UILabel!
    @IBOutlet weak var lblCarePlanName: UILabel!
    @IBOutlet weak var lblPlanDesc: UILabel!
    @IBOutlet weak var vwPlanDetails: UIView!
    
    // ---------- AddressDetails ----------
    @IBOutlet weak var vwAddressMain: UIView!
    @IBOutlet weak var vwAddress: UIView!
    @IBOutlet weak var lblAddressDetails: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgAddress: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var imgMobile: UIImageView!
    
    // ---------- BillingDetails ----------
    @IBOutlet weak var vwBilling: UIView!
    @IBOutlet weak var lblBilling: UILabel!
    @IBOutlet weak var vwActualPrice: UIView!
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblActualPriceRate: UILabel!
    
    @IBOutlet weak var vwDiscount: UIView!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblDiscountRate: UILabel!
    
    @IBOutlet weak var vwPurchase: UIView!
    @IBOutlet weak var lblPurchse: UILabel!
    @IBOutlet weak var lblPurchseRate: UILabel!
    
    @IBOutlet weak var vwGST: UIView!
    @IBOutlet weak var lblGST: UILabel!
    @IBOutlet weak var lblGSTRate: UILabel!
    
    @IBOutlet weak var lblAmountPaid: UILabel!
    @IBOutlet weak var lblAmountPaidRate: UILabel!
    
    // ---------- processToPayment ----------
    
    @IBOutlet weak var vwPaymentDetails: UIView!
    @IBOutlet weak var lblTotalPay: UILabel!
    @IBOutlet weak var lblTotalPayrate: UILabel!
    @IBOutlet weak var lblMonths: UILabel!
    
    @IBOutlet weak var btnProcessPayment: ThemePurple16Corner!
    
    //------------------------------------------------------
    
    //----------------- Apply Coupon -------------------
    @IBOutlet weak var imgApplyCoupon: UIImageView!
    @IBOutlet weak var imgCouponLogo: UIImageView!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var lblHeaderOffers: UILabel!
    @IBOutlet weak var vwApplyCoupon: UIView!
    @IBOutlet weak var lblApplyCoupon: UILabel!
    
    //---------------- View Container --------------
    @IBOutlet weak var vwApplyCouponCharge: UIView!
    @IBOutlet weak var lblApplyCouponCharge: UILabel!
    @IBOutlet weak var lblApplyCouponChargeRate: UILabel!
    
    //------------------------------------------------------
    //MARK: - Class Variables -
    
    var selectAddData: LabAddressListModel?
    var addAddData = String()
    var toView: ToView = .SelectAddress
    var cpDetails: CarePlanDetailsModel!
    var isPayThroughInApp = false
    var razorpayObj : RazorpayCheckout? = nil
    var selectedPlan: DurationDetailModel!
    var finalAmount = 0
    var finalDicountPrice = 0
    var promoCodeAmount = 0
    var isCouponRemove = false
    var isDiscountHide = true
    
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
        WebengageManager.shared.navigateScreenEvent(screen: .BcpOrderReview)
        Settings().isHidden(setting: .is_bcp_with_in_app) { [weak self] isWithInApp in
            guard let self = self else { return }
            self.isPayThroughInApp = isWithInApp
            self.lblHeaderOffers.superview?.isHidden = self.isPayThroughInApp
            self.setData()
        }
        
        Settings().isHidden(setting: .hide_discount_on_plan) { [weak self] isHide in
            guard let self = self else { return }
            self.isDiscountHide = isHide
            self.lblHeaderOffers.superview?.isHidden = isHide
        }
        
        if !kBCPApplyCouponName.isEmpty {
            self.lblApplyCoupon.text = "'\(kBCPApplyCouponName)' applied"
            self.btnRemove.isHidden = false
            self.imgApplyCoupon.isHidden = true
            self.imgCouponLogo.image = UIImage(named: "ic_CircleGreenCheck")
            self.vwApplyCouponCharge.isHidden = false
            self.lblApplyCouponCharge.text = "Applied Coupon (\(kBCPApplyCouponName))"
            self.lblApplyCouponChargeRate.text = "- \(appCurrencySymbol.rawValue)\(kBCPCouponCodeAmount)"
            self.promoCodeAmount = kBCPCouponCodeAmount
            self.isCouponRemove = false
        } else {
            self.btnRemove.isHidden = true
            self.imgApplyCoupon.isHidden = false
            self.imgCouponLogo.image = UIImage(named: "ic_Discount")
            self.vwApplyCouponCharge.isHidden = true
        }
        
        self.setData()
        
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
        //        self.setData()
    }
    
    func applyStyle() {
        
        self.lblNavTittle.text = "Order Review"
        //        self.btnHelp.image = UIImage(named: "helpBlack_ic")
        self.navigationItem.rightBarButtonItems = nil
        let btnTempHelp = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        btnTempHelp.setBackgroundImage(UIImage(named: "helpBlack_ic"), for: UIControl.State())
        btnTempHelp.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            var params              = [String : Any]()
            params[AnalyticsParameters.plan_id.rawValue] = self.cpDetails.planDetails.planMasterId
            FIRAnalytics.FIRLogEvent(eventName: .TAP_CONTACT_US,
                                     screen: .BcpOrderReview,
                                     parameter: params)
            GFunction.shared.openContactUs()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnTempHelp)
        
        // ---------- planDetails ----------
        self.lblPlanDetails.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Summary"
        self.lblCarePlanName.font(name: .bold, size: 14.0).textColor(color: .themeBlack2).text = "Care Plan Name"
        self.lblPlanDesc.font(name: .regular, size: 12).textColor(color: .ThemeGray61).text = "MyTatva now offers Care Plans for Lung and Liver Chronic conditions. Get personalized support and comprehensive care tailored to your needs. Take charge of your health with MyTatva Care Plans."
        
        
        // ---------- AddressDetails ----------
        self.lblAddressDetails.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Address"
        self.lblName.font(name: .bold, size: 14).textColor(color: .themeBlack2).text = UserModel.shared.name ?? ""
        self.lblCarePlanName.font(name: .bold, size: 14).textColor(color: .themeBlack2).text = self.cpDetails.planDetails.planName
        
        if let address = self.selectAddData {
            self.vwAddressMain.isHidden = false
            let objSelectAddress = "\(address.address ?? "")\n\(address.street ?? "")\n\(address.pincode ?? 0)"
            
            self.lblAddress.font(name: .regular, size: 14).textColor(color: .ThemeGray61).text = self.toView == .SelectAddress ? objSelectAddress : self.addAddData
        }else {
            self.vwAddressMain.isHidden = true
        }
        
        self.lblAddress.numberOfLines = 0
        self.lblEmail.font(name: .regular, size: 14).textColor(color: .ThemeGray61).text = UserModel.shared.email ?? ""
        self.lblMobileNo.font(name: .regular, size: 14).textColor(color: .ThemeGray61).text = "\(UserModel.shared.countryCode ?? "")  \(UserModel.shared.contactNo ?? "")"
        
        self.imgAddress.image = UIImage(named: "grayAddress_ic")
        self.imgEmail.image = UIImage(named: "grayMail_ic")
        self.imgMobile.image = UIImage(named: "CallGray_ic")
        
        // ---------- BillingDetails ----------
        self.lblBilling.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Billing"
        self.lblActualPrice.font(name: .regular, size: 14).textColor(color: .ThemeGray61).text = "Item Total"//"Actual Price (MRP)"
        self.lblDiscount.font(name: .regular, size: 14).textColor(color: .ThemeGray61).text = "Discount on Item(s)"
        self.lblPurchse.font(name: .regular, size: 14).textColor(color: .ThemeGray61).text = "Purchase Price"
        self.lblGST.font(name: .regular, size: 14).textColor(color: .ThemeGray61).text = "GST"
        self.lblApplyCouponCharge.font(name: .regular, size: 14).textColor(color: .ThemeGray61).text = "Applied Coupon (FIRST25)"
        
        self.lblActualPriceRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "₹ 1,200"
        self.lblDiscountRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "₹ 1,200"
        self.lblPurchseRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "₹ 500"
        self.lblGSTRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "₹ 300"
        
        self.lblApplyCouponChargeRate.font(name: .medium, size: 14).textColor(color: .themeGreen).text = "₹ 300"
        
        self.lblAmountPaid.font(name: .bold, size: 14).textColor(color: .themeBlack).text = "Amount to be Paid"
        self.lblAmountPaidRate.font(name: .bold, size: 14).textColor(color: .themeBlack).text = "₹ 1,999"
        
        // ---------- processToPayment ----------
        self.lblTotalPay.font(name: .regular, size: 10).textColor(color: .ThemeGray61).text = "Total Payable"
        self.lblTotalPayrate.font(name: .bold, size: 16).textColor(color: .ThemeBlack21).text = "₹ 1999"
        self.lblMonths.font(name: .regular, size: 10).textColor(color: .ThemeBlack21).text = "For 3 months"
        self.btnProcessPayment.font(name: .bold, size: 12)
        
        self.vwPlanDetails.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.vwAddress.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.vwBilling.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.vwPaymentDetails.themeShadowBCP()
        
        self.vwApplyCoupon.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.lblApplyCoupon.font(name: .semibold, size: 14).textColor(color: .themeBlack).text = "Apply Coupon"
        self.lblHeaderOffers.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Offers & Promotions"
        self.btnRemove.font(name: .semibold, size: 12).textColor(color: .themePurple).setTitle("REMOVE", for: .normal)
        self.btnRemove.isHidden = true
        self.imgApplyCoupon.isHidden = false
        
        self.vwPurchase.isHidden = true
        
        //        self.lblTotalOldAmount.isHidden = true
        //        self.lblCollectionOldAmount.isHidden = true
    }
    
    func setRemoveCouponData() {
        DispatchQueue.main.async {
            AppLoader.shared.removeLoader()
        }
        kBCPApplyCouponName = ""
        kBCPDiscountType = ""
        kBCPDiscountMasterId = ""
        kBCPCouponCodeAmount = 0
        self.isCouponRemove = true
        self.btnRemove.isHidden = true
        self.imgApplyCoupon.isHidden = false
        self.lblApplyCoupon.text = "Apply Coupon"
        self.imgCouponLogo.image = UIImage(named: "ic_Discount")
        self.vwApplyCouponCharge.isHidden = true
        self.promoCodeAmount = 0
        self.setData()
    }
    
    private func setData() {
        
        guard let selectedPlan = self.cpDetails.durationDetails.first(where: { $0.isSelected }) else { return }
        
        self.selectedPlan = selectedPlan
        
        self.lblActualPriceRate.text = appCurrencySymbol.rawValue + (selectedPlan.offerPrice == 0 ? self.isPayThroughInApp ? JSON(selectedPlan.iosPrice as Any).stringValue : JSON(selectedPlan.androidPrice as Any).stringValue : JSON(selectedPlan.offerPrice as Any).stringValue)
        
        let discount = (JSON(selectedPlan.offerPrice as Any).doubleValue * JSON(selectedPlan.discountPercentage as Any).doubleValue) / 100
        
        self.lblDiscountRate.text = "-\(appCurrencySymbol.rawValue)\(selectedPlan.offerPrice-selectedPlan.androidPrice)" //"\(JSON(selectedPlan.discountPercentage as Any).intValue)" + "%" //appCurrencySymbol.rawValue + "\(discount)"
        
        [
            self.vwDiscount, self.vwGST
        ].forEach({ $0?.isHidden = selectedPlan.offerPrice == 0 })
        
        var gst = 0
        
        //        self.vwDiscount.isHidden = JSON(selectedPlan.offerPrice as Any).doubleValue >= 0
        
        let gstPer = String(format: "%.f", selectedPlan.androidGstAmount.floorToPlaces(places: 2))
        if JSON(gstPer as Any).intValue > 0 && !self.isPayThroughInApp {
            //            gst = (selectedPlan.iosPrice * gstPer)/100
            self.lblGSTRate.text = appCurrencySymbol.rawValue + gstPer //"\(gst)"
            self.vwGST.isHidden = false
        }else {
            self.vwGST.isHidden = true
        }
        
        self.lblPurchseRate.text = appCurrencySymbol.rawValue + (self.isPayThroughInApp ? JSON(selectedPlan.iosPrice as Any).stringValue : JSON(selectedPlan.androidPrice as Any).stringValue)
        
        self.finalAmount = (self.isPayThroughInApp ? selectedPlan.iosPrice+gst : JSON(String(format: "%.f", selectedPlan.androidFinalAmount.floorToPlaces(places: 2)) as Any).intValue)
        //        self.lblTotalPayrate.text = appCurrencySymbol.rawValue + "\(self.finalAmount)"
        //        self.lblAmountPaidRate.text = appCurrencySymbol.rawValue + "\(self.finalAmount)"
        
        self.finalDicountPrice = self.finalAmount - self.promoCodeAmount
        self.lblAmountPaidRate.text = self.isCouponRemove ? appCurrencySymbol.rawValue + "\(self.finalAmount)" : appCurrencySymbol.rawValue + "\(self.finalDicountPrice)"
        self.lblTotalPayrate.text = self.isCouponRemove ? appCurrencySymbol.rawValue + "\(self.finalAmount)" : appCurrencySymbol.rawValue + "\(self.finalDicountPrice)"
        
        self.lblMonths.text = selectedPlan.durationName
        
        self.lblPlanDesc.text = selectedPlan.durationTitle + " - " + selectedPlan.durationName
        
    }
    
    //MARK: - Button Action Methods -
    
    @IBAction func btnBackTapped(_ sender: UIBarButtonItem) {
        
        self.setRemoveCouponData()
        guard let arrViewController = self.navigationController?.viewControllers else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        _ = arrViewController.map({
            if $0.isKind(of: BCPCarePlanDetailVC.self) {
                self.navigationController?.popToViewController($0, animated: true)
            }
        })
        
    }
    
    @IBAction func btnHelpClicked(_ sender: UIButton) {
        GFunction.shared.openContactUs()
    }
    
    func manageActionMethods() {
        
        self.vwApplyCoupon.addTapGestureRecognizer {
            if kBCPApplyCouponName.isEmpty {
                let vc = DiscountVC.instantiate(fromAppStoryboard: .BCP_temp)
                vc.IS_FROM_LAB_TEST = false
                vc.payableAmount = "\(self.finalDicountPrice)"
                
                var params = [String:Any]()
                params[AnalyticsParameters.service_type.rawValue] = "plan"
                params[AnalyticsParameters.amount_before_discount.rawValue] = self.lblAmountPaidRate.text
                FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_APPLY_COUPON_CARD,
                                         screen: .BcpOrderReview,
                                         parameter: params)
                
                vc.completionHandler = { obj, desc, amount, subHeading in
                    let vc = ApplyCouponPopupVC.instantiate(fromAppStoryboard: .BCP_temp)
                    vc.promoCode = obj
                    vc.descriptionTitle = subHeading
                    self.lblApplyCouponChargeRate.text = "- \(appCurrencySymbol.rawValue)\(amount)"
                    self.promoCodeAmount = amount
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true, completion: nil)
                    self.setData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
        self.btnRemove.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            var params = [String:Any]()
            params[AnalyticsParameters.discount_code.rawValue] = kBCPApplyCouponName
            params[AnalyticsParameters.service_type.rawValue] = "plan"
            FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_REMOVE,
                                     screen: .BcpOrderReview,
                                     parameter: params)
            
            self.setRemoveCouponData()
        }
        
        self.btnProcessPayment.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            
            var selectedDuration = self.cpDetails.durationDetails.first(where: { $0.isSelected })
            
            var params              = [String : Any]()
            //            params[AnalyticsParameters.plan_id.rawValue]            = self.cpDetails.planDetails.planMasterId
            //            params[AnalyticsParameters.plan_type.rawValue]          = self.cpDetails.planDetails.planType
            //            params[AnalyticsParameters.rentOrBuy.rawValue]          = selectedDuration?.rentBuyType ?? ""
            params[AnalyticsParameters.plan_duration.rawValue]      = selectedDuration?.durationTitle ?? ""
            
            params[AnalyticsParameters.amount_before_discount.rawValue]         = self.finalAmount
            params[AnalyticsParameters.service_type.rawValue]       = "plan"
            
            params[AnalyticsParameters.discount_code.rawValue]      = !kBCPApplyCouponName.isEmpty ? kBCPApplyCouponName : ""
            params[AnalyticsParameters.amount_after_discount.rawValue]       = !kBCPApplyCouponName.isEmpty ? "\(self.finalDicountPrice)" : ""
            //            params[AnalyticsParameters.amount_before_discount.rawValue]      = !kBCPApplyCouponName.isEmpty ? "\(self.finalAmount)" : ""
            
            FIRAnalytics.FIRLogEvent(eventName: .TAP_PROCEED_TO_PAYMENT,
                                     screen: .BcpOrderReview,
                                     parameter: params)
            
            guard self.isPayThroughInApp else {
                self.getOrderId()
                return
            }
            
            if self.selectedPlan.iosPrice > 0 {
                InAppManager.shared.purchaseProduct(productID: self.selectedPlan.iosProductId) { (jsonObj, stringObj) in
                    
                    if jsonObj != nil {
                        InAppManager.shared.completeTransaction()
                        
                        var transaction_id = InAppManager.shared.getOriginalTransectionId(jsonResponse: jsonObj!)
                        
                        if self.cpDetails.planDetails.planType == kSubscription {
                            transaction_id = InAppManager.shared.getOriginalSubscriptionTransectionId(jsonResponse: jsonObj!)
                        }
                        
                        self.addPlanAPI(plan_master_id: self.cpDetails.planDetails.planMasterId,
                                        transaction_id: transaction_id,
                                        receipt_data: stringObj ?? "",
                                        plan_type: self.cpDetails.planDetails.planType,
                                        plan_package_duration_rel_id: self.selectedPlan.planPackageDurationRelId,
                                        purchase_amount: JSON(self.selectedPlan.iosPrice as Any).intValue,
                                        withLoader: true)
                    }
                }
            }
            else {
                //Free plan
                self.addPlanAPI(plan_master_id: self.cpDetails.planDetails.planMasterId,
                                transaction_id: "Free",
                                receipt_data: "",
                                plan_type: self.cpDetails.planDetails.planType,
                                plan_package_duration_rel_id: self.selectedPlan.planPackageDurationRelId,
                                purchase_amount: JSON(self.selectedPlan.iosPrice as Any).intValue,
                                withLoader: true)
            }
            
        }
    }
}

//------------------------------------------------------
//MARK: - Razorpay Payment Delegates
extension BCPPlanDetailsVC: RazorpayResultProtocol {
    
    private func openRazorPayCheckout(orderID:String) {
        
        // 1. Initialize razorpay object with provided key. Also depending on your requirement you can assign delegate to self. It can be one of the protocol from RazorpayPaymentCompletionProtocolWithData, RazorpayPaymentCompletionProtocol.
        self.razorpayObj = RazorpayCheckout.initWithKey(RazorPayKey, andDelegate: self)
        let options: [AnyHashable:Any] = [
            "prefill":[
                "contact": UserModel.shared.countryCode + UserModel.shared.contactNo,
                "email": UserModel.shared.email ?? ""
            ],
            "name": UserModel.shared.name ?? "",
            "description": self.cpDetails.planDetails.planName ?? "",
            "currency": "INR",
            "amount": self.finalDicountPrice * 100,
            "order_id": orderID
        ]
        if let rzp = self.razorpayObj {
            
            DispatchQueue.main.async {
                rzp.open(options)
            }
            
        }else {
            print("Unable to initialize")
        }
    }
    
    func onComplete(response: [AnyHashable : Any]) {
        print(response)
        
        let jsonRes = JSON(response)
        
        guard jsonRes["error"].isEmpty else {
            Alert.shared.showAlert(message: jsonRes["error"]["description"].stringValue, completion: nil)
            return
        }
        
        if let rzp = self.razorpayObj {
            rzp.close()
        }
        
        let transactionID = JSON(response["razorpay_payment_id"] as Any).stringValue
        
        self.addPlanAPI(plan_master_id: self.selectedPlan.planMasterId, transaction_id: transactionID, plan_type: self.cpDetails.planDetails.planType, plan_package_duration_rel_id: self.selectedPlan.planPackageDurationRelId, purchase_amount: JSON(String(format: "%.f", self.selectedPlan.androidFinalAmount.floorToPlaces(places: 2))).intValue, withLoader: true)
        
    }
    
}

//------------------------------------------------------
//MARK: - WSMethods
extension BCPPlanDetailsVC {
    
    private func getOrderId() {
        
        var params = [String:Any]()
        params["amount"] = self.finalDicountPrice
        
        if NetworkManager.environment == .local || NetworkManager.environment == .uat {
            params["dev"] = true
        }
        
        ApiManager.shared.makeRequest(method: .patient_plans(.razorpay_order_id), parameter: params) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.success(let apiResponse):
                
                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    
                    self.openRazorPayCheckout(orderID: apiResponse.data.stringValue)
                    
                default:
                    Alert.shared.showSnackBar(apiResponse.message, isError: true, isBCP: true)
                }
                
                print(apiResponse.data)
            case .failure(_):
                debugPrint("Error")
            }
        }
        
        
    }
    
    func addPlanAPI(plan_master_id: String,
                    transaction_id: String,
                    receipt_data: String? = nil,
                    plan_type: String,
                    plan_package_duration_rel_id: String,
                    purchase_amount: Int,
                    withLoader: Bool){
        
        var params                              = [String : Any]()
        params["plan_master_id"]                = plan_master_id
        params["transaction_id"]                = transaction_id
        params["plan_type"]                     = plan_type
        params["plan_package_duration_rel_id"]  = plan_package_duration_rel_id
        params["device_type"]                   = "A"
        params["purchase_amount"]               = purchase_amount
        params["discount_amount"]               = "\(kBCPCouponCodeAmount)"
        params["discounts_master_id"]           = kBCPDiscountMasterId
        params["discount_type"]                 = kBCPDiscountType
        
        if let address = self.selectAddData {
            params["patient_address_rel_id"] = address.patientAddressRelId
        }
        
        if let receipt_data = receipt_data {
            params["receipt_data"]              = receipt_data
            params["device_type"]                   = "I"
        }
        
        if NetworkManager.environment == .local || NetworkManager.environment == .uat {
            params["dev"]                   = true
        }
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient_plans(.add_patient_plan), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                        GlobalAPI.shared.getPatientDetailsAPI(withLoader: true) { [weak self] (isDone) in
                            guard let self = self else {return}
                            kBCPCouponCodeAmount = 0
                            kBCPDiscountMasterId = ""
                            kBCPDiscountType     = ""
                            kBCPApplyCouponName  = ""
                            let vc = PaymentSuccessVC.instantiate(fromAppStoryboard: .BCP_temp)
                            //                            vc.planDetails = PlanDetail(fromJson: response.response)
                            vc.patientPlanRefID = response.data["patient_plan_rel_id"].stringValue
                            self.navigationController?.pushViewController(vc, animated: true)
                            //                            Alert.shared.showSnackBar(response.message)
                        }
                    }
                    
                    break
                case .emptyData:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .otpVerify:
                    break
                case .emailVerify:
                    break
                case .forceUpdateApp:
                    break
                case .underMaintenance:
                    break
                    
                case .socialIdNotRegister:
                    break
                case .userSessionExpire:
                    break
                case .unknown:
                    break
                default: break
                }
                
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription,  isError: true, isBCP: true)
                break
                
            }
        }
        
    }
    
}
