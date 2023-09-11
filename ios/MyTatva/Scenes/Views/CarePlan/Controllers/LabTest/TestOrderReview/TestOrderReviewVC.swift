//
//  CartVC.swift
//

//

import UIKit
import Razorpay
import SwiftyJSON


class TestOrderReviewCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    var object = AppointmentListModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblDesc
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
            //self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            //self.vwBg.borderColor(color: UIColor.themeBlack.withAlphaComponent(0.09), borderWidth: 0.5)
            
        }
    }
}

class TestOrderReviewVC: ClearNavigationFontBlackBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var lblBookingFor            : UILabel!
    @IBOutlet weak var lblName                  : UILabel!
    @IBOutlet weak var lblEmail                 : UILabel!
    @IBOutlet weak var lblAge                   : UILabel!
    @IBOutlet weak var lblGender                : UILabel!
    
    @IBOutlet weak var lblAppointmentDate       : UILabel!
    @IBOutlet weak var lblDateVal               : UILabel!
    @IBOutlet weak var lblTimeVal               : UILabel!
    
    @IBOutlet weak var lblLabDetail             : UILabel!
    @IBOutlet weak var lblLabName               : UILabel!
    @IBOutlet weak var lblLabAddress            : UILabel!
    
    @IBOutlet weak var lblPickupAddress         : UILabel!
    @IBOutlet weak var lblPickupAddressName     : UILabel!
    @IBOutlet weak var lblPickupAddressVal      : UILabel!
    
    @IBOutlet weak var lblItemTitle             : UILabel!
    @IBOutlet weak var lblItemVal               : UILabel!
    //    @IBOutlet weak var lblItemName              : UILabel!
    //    @IBOutlet weak var lblItemPrice             : UILabel!
    @IBOutlet weak var tblTest                  : UITableView!
    @IBOutlet weak var tblTestHeight            : NSLayoutConstraint!
    
    @IBOutlet weak var lblItemTotal             : UILabel!
    @IBOutlet weak var lblItemOldPrice          : UILabel!
    @IBOutlet weak var lblItemTotalPrice        : UILabel!
    
    @IBOutlet weak var lblCollectionCharge      : UILabel!
    @IBOutlet weak var lblCollectionChargeDesc  : UILabel!
    @IBOutlet weak var lblCollectionChargePrice : UILabel!
    @IBOutlet weak var lblCollectionChargeFree  : UILabel!
    
    @IBOutlet weak var lblServiceCharge         : UILabel!
    @IBOutlet weak var lblServiceChargeVal      : UILabel!
    
    @IBOutlet weak var lblOrderTotal            : UILabel!
    @IBOutlet weak var lblOrderTotalVal         : UILabel!
    
    @IBOutlet weak var vwDash1                  : UIView!
    @IBOutlet weak var vwDash2                  : UIView!
    
    @IBOutlet weak var lblAmount                : UILabel!
    @IBOutlet weak var lblAmountVal             : UILabel!
    
    @IBOutlet weak var btnSelectTerms           : UIButton!
    @IBOutlet weak var lblTerms                 : UILabel!
    @IBOutlet weak var btnOpenTerms             : UIButton!
    @IBOutlet weak var lblAnd                   : UILabel!
    @IBOutlet weak var btnCancellation          : UIButton!
    
    @IBOutlet weak var btnSubmit                : UIButton!
    
    
    //MARK: ------------------------- Class Variable -------------------------
    private let viewModel           = TestOrderReviewVM()
    var cartListModel               = CartListModel()
    var labPatientListModel         = LabPatientListModel()
    var labAddressListModel         = LabAddressListModel()
    var selectedTimeSlot            = ""
    var selectedDate                = Date()
    
    var razorpayObj : RazorpayCheckout? = nil
    
    
    //MARK: ------------------------- Memory Management Method -------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    func setUpView() {
        
        self.configureUI()
        self.manageActionMethods()
        self.setData()
        self.setup(tblView: self.tblTest)
        self.addObserverOnHeightTbl()
        self.setupViewModelObserver()
    }
    
    func configureUI(){
        
        
        self.lblBookingFor
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblName
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblEmail
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblAge
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblGender
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblAppointmentDate
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblDateVal
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblTimeVal
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblLabDetail
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblLabName
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblLabAddress
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblPickupAddress
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblPickupAddressName
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblPickupAddressVal
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblItemTitle
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblItemVal
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblItemTotal
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblItemOldPrice
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblItemTotalPrice
            .font(name: .regular, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblCollectionCharge
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblCollectionChargeDesc
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.lblCollectionChargePrice
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblCollectionChargeFree
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblServiceCharge
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblServiceChargeVal
            .font(name: .regular, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblOrderTotal
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblOrderTotalVal
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblAmount
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblAmountVal
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.btnSubmit
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.white.withAlphaComponent(1))
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 12),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        self.lblItemOldPrice.attributedText = self.lblItemOldPrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
        self.lblCollectionChargePrice.attributedText = self.lblCollectionChargePrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
        
        self.lblTerms.font(name: .regular, size: 15).textColor(color: .themeBlack)
        self.lblAnd.font(name: .regular, size: 15).textColor(color: .themeBlack)
        self.btnOpenTerms.font(name: .regular, size: 15).textColor(color: .themePurple)
        self.btnCancellation.font(name: .regular, size: 15).textColor(color: .themePurple)
        
        DispatchQueue.main.async {
            self.btnSubmit.layoutIfNeeded()
            self.vwDash1.layoutIfNeeded()
            self.vwDash2.layoutIfNeeded()
            
            self.vwDash1.addDashedLine(color: UIColor.themeLightGray)
            self.vwDash2.addDashedLine(color: UIColor.themeLightGray)
            
            self.btnSubmit.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple)
        }
    }
    
    func setup(tblView: UITableView) {
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
    }
    
    //MARK: ------------------------- Action Method -------------------------
    func manageActionMethods(){
        
        self.btnOpenTerms.addTapGestureRecognizer {
            GFunction.shared.openLink(strLink: kThyrocareTermsUse, inApp: true)
        }
        
        self.btnCancellation.addTapGestureRecognizer {
            GFunction.shared.openLink(strLink: kThyrocareTermsUse, inApp: true)
        }
        
        self.btnSelectTerms.isSelected = false
        //self.updateSubmit()
        self.btnSelectTerms.addTapGestureRecognizer {
            self.btnSelectTerms.isSelected = !self.btnSelectTerms.isSelected
            //self.updateSubmit()
        }
        
        self.btnSubmit.addTapGestureRecognizer {
            if !self.btnSelectTerms.isSelected {
                Alert.shared.showSnackBar(AppError.validation(type: .agreeThyroTermsAndCondition).errorDescription ?? "")
            }
            else {
                self.viewModel.check_book_testAPI(final_payable_amount: "\(self.cartListModel.orderDetail.finalPayableAmount!)") { [weak self] isDone, order_id in
                    guard let self = self else {return}
                    if isDone {
                        self.openRazorpayCheckout(order_id: order_id)
                    }
                }
            }
//            let vc = TestOrderSuccessVC.instantiate(fromAppStoryboard: .carePlan)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        
        WebengageManager.shared.navigateScreenEvent(screen: .BookLabtestAppointmentReview)
        
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = DateTimeFormaterEnum.yyyymmdd.rawValue
        let appointment_date            = formatter.string(from: self.selectedDate)
        
        var params1 = [String: Any]()
        params1[AnalyticsParameters.appointment_date.rawValue]  = appointment_date
        params1[AnalyticsParameters.slot_time.rawValue]         = self.selectedTimeSlot
        params1[AnalyticsParameters.member_id.rawValue]         = self.labPatientListModel.patientMemberRelId
        params1[AnalyticsParameters.address_id.rawValue]        = self.labAddressListModel.patientAddressRelId
        FIRAnalytics.FIRLogEvent(eventName: .USER_OPEN_LABTEST_ORDER_REVIEW,
                                 screen: .BookLabtestAppointmentReview,
                                 parameter: params1)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
}

//MARK: -------------------------- TableView Methods --------------------------
extension TestOrderReviewVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartListModel.testsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TestOrderReviewCell = tableView.dequeueReusableCell(withClass: TestOrderReviewCell.self, for: indexPath)
        let object = self.cartListModel.testsList[indexPath.row]
        
        cell.lblTitle.text      = object.name
        cell.lblDesc.text       = CurrencySymbol.INR.rawValue + "\(object.discountPrice!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
        //                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension TestOrderReviewVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = ""//self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension TestOrderReviewVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblTest, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            DispatchQueue.main.async {
                self.tblTestHeight.constant = newvalue.height
                UIView.animate(withDuration: kAnimationSpeed) {
                    self.view.layoutIfNeeded()
                }
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


//MARK: -------------------------- Set data --------------------------
extension TestOrderReviewVC {
    
    func setData(){
        if self.labPatientListModel.name != nil {
            self.lblName.text       = self.labPatientListModel.name
            self.lblEmail.text      = self.labPatientListModel.email
            self.lblGender.text     = AppMessages.Gender + " : " + labPatientListModel.gender
            self.lblAge.text        = AppMessages.Age + " : " + "\(labPatientListModel.age!)"
        }
        
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = DateTimeFormaterEnum.ddmm_yyyy.rawValue
        self.lblDateVal.text            = formatter.string(from: self.selectedDate)
        self.lblTimeVal.text            = self.selectedTimeSlot
        
        if self.cartListModel.lab != nil {
            //self.imgLab.setCustomImage(with: self.cartListModel.lab.image)
            self.lblLabName.text        = self.cartListModel.lab.name
            self.lblLabAddress.text     = self.cartListModel.lab.address
        }
        
        self.lblCollectionChargePrice.text  = CurrencySymbol.INR.rawValue + "\(self.cartListModel.homeCollectionCharge.ammount!)"
        if self.cartListModel.homeCollectionCharge.payableAmmount > 0 {
            self.lblCollectionChargeFree.text       = CurrencySymbol.INR.rawValue + "\(self.cartListModel.homeCollectionCharge.payableAmmount!)"
            self.lblCollectionChargeDesc.isHidden   = true
        }
        else {
            self.lblCollectionChargeFree.text       = AppMessages.Free
            self.lblCollectionChargeDesc.isHidden   = false
        }
        
        self.lblItemOldPrice.text       = CurrencySymbol.INR.rawValue + self.cartListModel.orderDetail.orderTotal
        self.lblItemTotalPrice.text     = CurrencySymbol.INR.rawValue + self.cartListModel.orderDetail.payableAmount
        self.lblServiceChargeVal.text   = CurrencySymbol.INR.rawValue + self.cartListModel.orderDetail.serviceCharge
        self.lblOrderTotalVal.text      = CurrencySymbol.INR.rawValue + "\(self.cartListModel.orderDetail.finalPayableAmount!)"
        self.lblAmountVal.text          = CurrencySymbol.INR.rawValue + "\(self.cartListModel.orderDetail.finalPayableAmount!)"
        //self.lblFinalVal.text           = CurrencySymbol.INR.rawValue + "\(self.cartListModel.orderDetail.finalPayableAmount!)"
        
        self.lblItemTitle.text = "\(self.cartListModel.testsList.count)" + " " + AppMessages.items
        self.lblItemVal.isHidden = true
        self.tblTest.reloadData()
        
        
        if self.labAddressListModel.name != nil {
            self.lblPickupAddressName.text  = self.labAddressListModel.addressType
            self.lblPickupAddressVal.text   = """
\(self.labAddressListModel.name ?? "")
\(self.labAddressListModel.address ?? "")
\(self.labAddressListModel.street ?? "")
\(self.labAddressListModel.pincode!)
\(self.labAddressListModel.contactNo!)
"""
        }
    }
}

//MARK: -------------------------- Payment methods --------------------------
extension TestOrderReviewVC: RazorpayResultProtocol {
    
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
        
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = DateTimeFormaterEnum.yyyymmdd.rawValue
        let appointment_date            = formatter.string(from: self.selectedDate)
        
        self.viewModel.apiCall(vc: self,
                               appointment_date: appointment_date,
                               slot_time: self.selectedTimeSlot,
                               address_id: self.labAddressListModel.patientAddressRelId,
                               member_id: self.labPatientListModel.patientMemberRelId,
                               transaction_id: transaction_id,
                               order_total: self.cartListModel.orderDetail.orderTotal,
                               payable_amount: self.cartListModel.orderDetail.payableAmount,
                               final_payable_amount: "\(self.cartListModel.orderDetail.finalPayableAmount!)",
                               home_collection_charge: "\(self.cartListModel.homeCollectionCharge.payableAmmount!)",
                               service_charge: self.cartListModel.orderDetail.serviceCharge)
        
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension TestOrderReviewVC {
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
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
    }
}
