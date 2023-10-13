//
//  CartVC.swift
//

//

import UIKit

class OrderSummaryStatusVC: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!

    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDate              : UILabel!
    
    @IBOutlet weak var vwNo                 : UIView!
    @IBOutlet weak var lblNo                : UILabel!
    
    @IBOutlet weak var vwLineTop            : UIView?
    @IBOutlet weak var vwLineBottom         : UIView!
    
    var object = AppointmentListModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblDate
            .font(name: .light, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblNo
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.white.withAlphaComponent(1))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
            //self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            //self.vwBg.borderColor(color: UIColor.themeBlack.withAlphaComponent(0.09), borderWidth: 0.5)
            
            self.vwNo.layoutIfNeeded()
            self.vwNo.cornerRadius(cornerRadius: self.vwNo.frame.size.height / 2)
            self.vwNo.backGroundColor(color: UIColor.themeLightGray)
        }
    }
    
    func setCellData(){
       
//        self.imgTitle.setCustomImage(with: self.object.profilePicture)
//        self.lblTitle.text          = self.object.doctorName
//
//        let date = GFunction.shared.convertDateFormate(dt: self.object.appointmentDate,
//                                                           inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
//                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
//                                                           status: .NOCONVERSION)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            if let tbl = self.superview as? UITableView {
               
                UIView.performWithoutAnimation {
                    if #available(iOS 15.0, *) {
                        tbl.performBatchUpdates {
                        } completion: { isDone in
                        }
                        tbl.layoutIfNeeded()
                    }
                    else {
                    }
                }
                
            }
        }
    }
}

class OrderSummaryVC: ClearNavigationFontBlackBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var scrollMain               : UIScrollView!
    
    @IBOutlet weak var lblPatient               : UILabel!
    @IBOutlet weak var lblPatientVal            : UILabel!
    
    @IBOutlet weak var lblOrder                 : UILabel!
    @IBOutlet weak var lblOrderVal              : UILabel!
    
    @IBOutlet weak var vwAppointment            : UIView!
    @IBOutlet weak var lblAppointmentDate       : UILabel!
    @IBOutlet weak var lblAppointmentDateVal    : UILabel!
    
    @IBOutlet weak var lblAppointmentTime       : UILabel!
    @IBOutlet weak var lblAppointmentTimeVal    : UILabel!
    
    @IBOutlet weak var lblServiceDateTime       : UILabel!
    @IBOutlet weak var lblServiceDateTimeVal    : UILabel!
    
    @IBOutlet weak var lblStatus                : UILabel!
    @IBOutlet weak var lblStatusValue           : UILabel!
    @IBOutlet weak var btnStatusExpand          : UIButton!
    @IBOutlet weak var tblStatus                : UITableView!
    @IBOutlet weak var tblStatusHeight          : NSLayoutConstraint!
    
    @IBOutlet weak var lblPickupAddress         : UILabel!
    @IBOutlet weak var lblPickupAddressName     : UILabel!
    @IBOutlet weak var lblPickupAddressVal      : UILabel!
    
    @IBOutlet weak var lblLabDetail             : UILabel!
    @IBOutlet weak var lblLabName               : UILabel!
    @IBOutlet weak var lblLabAddress            : UILabel!
    
    @IBOutlet weak var lblBillDetails           : UILabel!
    @IBOutlet weak var lblOrderedItems          : UILabel!
    @IBOutlet weak var lblOrderedItemsVal       : UILabel!
    @IBOutlet weak var btnMoveToTest            : UIButton!
    
    @IBOutlet weak var lblSubTotal              : UILabel!
    @IBOutlet weak var lblSubTotalVal           : UILabel!
   
    @IBOutlet weak var lblCollectionCharge      : UILabel!
    @IBOutlet weak var lblCollectionChargeDesc  : UILabel!
    @IBOutlet weak var lblCollectionChargePrice : UILabel!
    @IBOutlet weak var lblCollectionChargeFree  : UILabel!
    
    @IBOutlet weak var lblServiceCharge         : UILabel!
    @IBOutlet weak var lblServiceChargeVal      : UILabel!
    
    @IBOutlet weak var lblOrderTotal            : UILabel!
    @IBOutlet weak var lblOrderTotalVal         : UILabel!
    
    @IBOutlet weak var lblAmount                : UILabel!
    @IBOutlet weak var lblAmountVal             : UILabel!
   
    @IBOutlet weak var btnCancel                : UIButton!
    
    @IBOutlet weak var lblApplyCoupon           : UILabel!
    @IBOutlet weak var lblApplyCouponVal        : UILabel!
    
    @IBOutlet weak var stApplyCouopn: UIStackView!
    
    //MARK: ------------------------- Class Variable -------------------------
    var object              = LabTestOrderSummaryModel()
    
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
        self.setup(tblView: self.tblStatus)
        self.addObserverOnHeightTbl()
        
        self.btnStatusExpand.isSelected = true
        self.updateStatusData()
    }
    
    func configureUI(){
        
        self.lblPatient
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblPatientVal
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblAppointmentDate
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblAppointmentTime
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblServiceDateTime
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblAppointmentDateVal
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.lblAppointmentTimeVal
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.lblServiceDateTimeVal
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblStatus
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblStatusValue
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.btnStatusExpand.isSelected = true
        
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
       
        self.lblBillDetails
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblOrderedItems
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblOrderedItemsVal
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblOrder
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblOrderVal
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
            
        self.lblSubTotal
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblSubTotalVal
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblApplyCoupon
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblApplyCouponVal
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeGreen)
        
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
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 12),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        self.lblCollectionChargePrice.attributedText = self.lblCollectionChargePrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
        
        self.lblOrderTotal
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblOrderTotalVal
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblServiceCharge
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblServiceChargeVal
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblAmount
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblAmountVal
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.btnCancel
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        DispatchQueue.main.async {
            self.btnCancel.layoutIfNeeded()
            self.btnCancel.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.vwAppointment.layoutIfNeeded()
            self.vwAppointment.cornerRadius(cornerRadius: 10)
                .backGroundColor(color: UIColor.themeLightPurple.withAlphaComponent(0.4))
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
        
        self.btnStatusExpand.addTapGestureRecognizer {
            self.btnStatusExpand.isSelected = !self.btnStatusExpand.isSelected
            self.updateStatusData()
        }
        
        self.btnCancel.addTapGestureRecognizer {
            let vc = ContactLabSupportVC.instantiate(fromAppStoryboard: .carePlan)
            vc.order_master_id = self.object.orderMasterId
            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandler = { obj in
                
                //self.navigationController?.popViewController(animated: true)
            }
            self.present(vc, animated: true, completion: nil)
        }
        
        self.btnMoveToTest.addTapGestureRecognizer {
            if let vc = self.parent?.parent as? TestOrderDetailParentVC {
                vc.manageSelection(type: .Tests)
            }
        }
        
        self.lblOrderedItemsVal.addTapGestureRecognizer {
            if let vc = self.parent?.parent as? TestOrderDetailParentVC {
                vc.manageSelection(type: .Tests)
            }
        }
    }
    
    func updateStatusData(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) {
            if self.btnStatusExpand.isSelected {
                self.tblStatus.isHidden = false
            }
            else {
                self.tblStatus.isHidden = true
            }
            self.tblStatus.reloadData()
        }
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUpView()
        
        //WebengageManager.shared.navigateScreenEvent(screen: .DoctorProfile)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.scrollMain.isHidden = true
        self.setData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
}

//MARK: -------------------------- TableView Methods --------------------------
//MARK: -------------------------- TableView Methods --------------------------
extension OrderSummaryVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.object.orderStatusData != nil {
            return self.object.orderStatusData.count
        }
        return 0
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : OrderSummaryStatusVC = tableView.dequeueReusableCell(withClass: OrderSummaryStatusVC.self, for: indexPath)
        let obj = self.object.orderStatusData[indexPath.row]
        cell.lblNo.text     = "\(obj.index!)"
        cell.lblTitle.text  = obj.status
        cell.lblDate.isHidden = true
        
        cell.vwLineTop?.backGroundColor(color: UIColor.themeLightGray)
        cell.vwLineBottom.backGroundColor(color: UIColor.themeLightGray)
        
        DispatchQueue.main.async {
            if obj.done == "Yes" {
                cell.vwNo.backGroundColor(color: UIColor.themeLightPurple.withAlphaComponent(1))
                cell.vwLineBottom.backGroundColor(color: UIColor.themeLightPurple.withAlphaComponent(1))
                
                cell.lblTitle
                    .font(name: .medium, size: 13)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
                cell.lblDate
                    .font(name: .light, size: 11)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
            }
            else {
                cell.vwNo.backGroundColor(color: UIColor.themeLightGray)
                cell.lblTitle
                    .font(name: .medium, size: 13)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
                cell.lblDate
                    .font(name: .light, size: 11)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
            }
            
            if indexPath.row == self.object.orderStatusData.count - 1 {
                cell.vwLineBottom.alpha = 0
            }
            else {
                cell.vwLineBottom.alpha = 1
            }
        }
    
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
extension OrderSummaryVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension OrderSummaryVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblStatus, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            DispatchQueue.main.async {
                self.tblStatusHeight.constant = newvalue.height
                UIView.animate(withDuration: kAnimationSpeed) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblStatus.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblStatus else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------------- Set data --------------------------
extension OrderSummaryVC {
    
    func setData(){
        if self.object.member != nil {
            self.lblPatientVal.text     = self.object.member.name
        }
        
        if self.object.orderId != nil {
            self.lblOrderVal.text = "\(self.object.refOrderId!)"
            
            let date = GFunction.shared.convertDateFormate(dt: self.object.appointmentDate,
                                                               inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                               outputFormat: DateTimeFormaterEnum.EEEddMMMM.rawValue,
                                                               status: .NOCONVERSION)
            self.lblAppointmentDateVal.text         = date.0
            self.lblAppointmentTimeVal.text         = self.object.slotTime
            
            self.lblStatusValue.text    = self.object.orderStatus
            self.tblStatus.reloadData()
        }
        
        self.lblServiceDateTime.isHidden = true
        self.lblServiceDateTimeVal.isHidden = true
        if self.object.serviceDateTime != nil {
            self.lblServiceDateTime.isHidden        = false
            self.lblServiceDateTimeVal.isHidden     = false
            //"16-06-2022 06:26",
            let date = GFunction.shared.convertDateFormate(dt: self.object.serviceDateTime,
                                                               inputFormat: DateTimeFormaterEnum.dd_mm_yyyy_HHmm.rawValue,
                                                               outputFormat: DateTimeFormaterEnum.ddMMMYYYYhhmma.rawValue,
                                                               status: .NOCONVERSION)
            self.lblServiceDateTimeVal.text         = date.0
        }
        
        if self.object.lab != nil {
            //self.imgLab.setCustomImage(with: self.cartListModel.lab.image)
            self.lblLabName.text        = self.object.lab.name
            self.lblLabAddress.text     = self.object.lab.address
        }
        
        if self.object.address != nil {
            self.lblPickupAddressName.text  = self.object.address.addressType
            self.lblPickupAddressVal.text   = """
\(self.object.address.name ?? "")
\(self.object.address.address ?? "")
\(self.object.address.pincode!)
\(self.object.address.contactNo!)
\(self.object.member.email!)
"""
            //\(self.object.address.street ?? "")
        }
        
        if self.object.payableAmount != nil {
            self.tblStatus.isHidden             = false
            self.scrollMain.isHidden            = false
            
            self.lblOrderedItemsVal.text        = "\(self.object.items.count)" + " " + AppMessages.items
            self.lblServiceChargeVal.text       = JSON(self.object.serviceCharge as Any).intValue == 0 ? KFree : CurrencySymbol.INR.rawValue + "\(self.object.serviceCharge!)"
            self.lblSubTotalVal.text            = CurrencySymbol.INR.rawValue + "\(self.object.payableAmount!)"
            self.lblCollectionChargePrice.text  = ""
            self.lblCollectionChargeFree.text   = JSON(self.object.homeCollectionCharge as Any).intValue == 0 ? KFree : CurrencySymbol.INR.rawValue + "\(self.object.homeCollectionCharge!)"
            self.lblOrderTotalVal.text          = CurrencySymbol.INR.rawValue + "\(self.object.orderTotal!)"
            self.lblAmountVal.text              = CurrencySymbol.INR.rawValue + "\(self.object.finalPayableAmount!)"
            
//            self.lblApplyCoupon.isHidden = self.object.couponCode == "" && self.object.couponDiscount == ""
//            self.lblApplyCouponVal.isHidden = self.object.couponCode == "" && self.object.couponDiscount == ""
            
            self.stApplyCouopn.isHidden = self.object.couponCode == "" && self.object.couponDiscount == ""
            
            self.lblApplyCoupon.text            = "Applied Coupon (\(self.object.couponCode!))"
            let value = Float(self.object.couponDiscount)
            let finalValue = Int(value ?? 0.0)
            self.lblApplyCouponVal.text = "- \(appCurrencySymbol.rawValue)\(finalValue)"
        }
        
        if let bcpTestValue = self.object.bcpTestPriceData {
            self.lblOrderTotalVal.text = bcpTestValue.bcpTotalAmountOld == 0 ? KFree : CurrencySymbol.INR.rawValue + JSON(bcpTestValue.bcpTotalAmountOld as Any).stringValue
            self.lblSubTotalVal.text = bcpTestValue.bcpTotalAmount == 0 ? KFree : CurrencySymbol.INR.rawValue + JSON(bcpTestValue.bcpTotalAmount as Any).stringValue
            self.lblCollectionChargePrice.text = bcpTestValue.bcpHomeCollectionCharge == 0 ? KFree : CurrencySymbol.INR.rawValue + JSON(bcpTestValue.bcpHomeCollectionCharge as Any).stringValue
            self.lblCollectionChargePrice.isHidden = true// bcpTestValue.bcpHomeCollectionCharge == 0
            self.lblCollectionChargeFree.isHidden = false
            self.lblCollectionChargeFree.text = bcpTestValue.bcpHomeCollectionCharge == 0 ? KFree : CurrencySymbol.INR.rawValue + JSON(bcpTestValue.bcpHomeCollectionCharge as Any).stringValue
            
            self.lblServiceChargeVal.text = bcpTestValue.bcpServiceCharge == 0 ? KFree : JSON(bcpTestValue.bcpServiceCharge as Any).stringValue
            self.lblAmountVal.text = bcpTestValue.bcpFinalAmountToPay == 0 ? KFree : CurrencySymbol.INR.rawValue + JSON(bcpTestValue.bcpFinalAmountToPay as Any).stringValue
        }
        
    }
}
