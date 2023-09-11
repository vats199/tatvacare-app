//
//  CartVC.swift
//

//

import UIKit

class LabTestCartCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!

    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var btnRemove            : UIButton!
    
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var vwOffer              : UIView!
    @IBOutlet weak var lblOffer             : UILabel!
    
    @IBOutlet weak var lblOldPrice          : UILabel!
    @IBOutlet weak var lblNewPrice          : UILabel!
    
    var object = AppointmentListModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblDesc
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblOffer
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.white.withAlphaComponent(1))
     
        self.lblOldPrice
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblNewPrice
            .font(name: .regular, size: 20)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        self.lblOldPrice.attributedText = self.lblOldPrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
     
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
            //self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            //self.vwBg.borderColor(color: UIColor.themeBlack.withAlphaComponent(0.09), borderWidth: 0.5)
            
            self.vwOffer.layoutIfNeeded()
            self.vwOffer.backGroundColor(color: UIColor.themePurple)
            
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.cornerRadius(cornerRadius: 5)
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


class LabTestCartVC: ClearNavigationFontBlackBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var scrollMain               : UIScrollView!
    @IBOutlet weak var lblSelectedLab           : UILabel!
    
    @IBOutlet weak var imgLab                   : UIImageView!
    @IBOutlet weak var lblLabName               : UILabel!
    @IBOutlet weak var lblLabAddress            : UILabel!
    
    @IBOutlet weak var tblTest                  : UITableView!
    @IBOutlet weak var tblTestHeight            : NSLayoutConstraint!
    
    @IBOutlet weak var vwAddTest                : UIView!
    @IBOutlet weak var lblAddTest               : UILabel!
    
    @IBOutlet weak var vwApplyCoupon            : UIView!
    @IBOutlet weak var lblApplyCoupon           : UILabel!
    
    @IBOutlet weak var lblItemTotal             : UILabel!
    @IBOutlet weak var lblItemOldPrice          : UILabel!
    @IBOutlet weak var lblItemTotalPrice        : UILabel!
    
    @IBOutlet weak var lblServiceCharge         : UILabel!
    @IBOutlet weak var lblServiceChargeVal      : UILabel!
    
    @IBOutlet weak var lblCollectionCharge      : UILabel!
    @IBOutlet weak var lblCollectionChargeDesc  : UILabel!
    @IBOutlet weak var lblCollectionChargePrice : UILabel!
    @IBOutlet weak var lblCollectionChargeFree  : UILabel!
    
    @IBOutlet weak var lblOrderTotal            : UILabel!
    @IBOutlet weak var lblOrderTotalVal         : UILabel!
    
    @IBOutlet weak var vwDash1                  : UIView!
    @IBOutlet weak var vwDash2                  : UIView!
    
    @IBOutlet weak var lblAmount                : UILabel!
    @IBOutlet weak var lblAmountVal             : UILabel!
    
    @IBOutlet weak var vwCart                   : UIView!
    @IBOutlet weak var lblFinal                 : UILabel!
    @IBOutlet weak var lblFinalVal              : UILabel!
    @IBOutlet weak var btnSelectPatient         : UIButton!
    
    
    //MARK:- Class Variable
    var viewModel           = LabTestCartVM()
    var object              = CartListModel()
    let labTestListVM       = LabTestListVM()
    
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
        
        self.vwApplyCoupon.isHidden = true
        self.addObserverOnHeightTbl()
        self.configureUI()
        self.manageActionMethods()
        self.setup(tblView: self.tblTest)
        
    }
    
    func configureUI(){
        
        
        self.lblSelectedLab
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblLabName
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblLabAddress
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblAddTest
            .font(name: .bold, size: 14)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblApplyCoupon
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblItemTotal
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblItemOldPrice
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblItemTotalPrice
            .font(name: .regular, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblServiceCharge
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblServiceChargeVal
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
        
        self.lblFinal
            .font(name: .medium, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblFinalVal
            .font(name: .regular, size: 17)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.btnSelectPatient
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.white.withAlphaComponent(1))
    
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 12),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        self.lblItemOldPrice.attributedText = self.lblItemOldPrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
        self.lblCollectionChargePrice.attributedText = self.lblCollectionChargePrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
        
        DispatchQueue.main.async {
            self.vwApplyCoupon.layoutIfNeeded()
            self.btnSelectPatient.layoutIfNeeded()
            self.vwCart.layoutIfNeeded()
            self.vwAddTest.layoutIfNeeded()
            self.vwDash1.layoutIfNeeded()
            self.vwDash2.layoutIfNeeded()
            
            self.vwDash1.addDashedLine(color: UIColor.themeLightGray)
            self.vwDash2.addDashedLine(color: UIColor.themeLightGray)
            
            self.vwAddTest.backGroundColor(color: UIColor.themeLightGray)
            self.imgLab.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themeLightPurple, borderWidth: 1)
            
            self.btnSelectPatient.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple)
            self.vwApplyCoupon.borderColor(color: UIColor.themePurple, borderWidth: 1)
                .cornerRadius(cornerRadius: 5)
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
        
        self.btnSelectPatient.addTapGestureRecognizer {
            let vc = SelectPatientDetailsVC.instantiate(fromAppStoryboard: .carePlan)
            vc.cartListModel = self.object
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.vwApplyCoupon.addTapGestureRecognizer {
            let vc = ApplyTestCouponVC.instantiate(fromAppStoryboard: .carePlan)
            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            vc.completionHandler = { obj in
//                if obj?.count > 0 {
//                    let vc = SetLocationVC.instantiate(fromAppStoryboard: .auth)
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            }
            self.present(vc, animated: true, completion: nil)
        }
        
        self.vwAddTest.addTapGestureRecognizer {
            let vc = AllLabTestListVC.instantiate(fromAppStoryboard: .carePlan)
            vc.labTestType = .all
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        
        WebengageManager.shared.navigateScreenEvent(screen: .LabtestCart)
        
        //var params1 = [String: Any]()
        //params1[AnalyticsParameters.lab_test_id.rawValue]  = object.labTestId
        FIRAnalytics.FIRLogEvent(eventName: .USER_VIEWED_CART,
                                 screen: .LabtestCart,
                                 parameter: nil)
        
        self.scrollMain.isHidden = true
        self.viewModel.cartTestListAPI(withLoader: true) { [weak self] isDone, object in
            guard let self = self else {return}
            
            if isDone {
                self.scrollMain.isHidden = false
                self.object = object
                CartListModel.shared = object
                self.setData()
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

//MARK: -------------------------- TableView Methods --------------------------
extension LabTestCartVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.object.testsList != nil {
            return self.object.testsList.count
        }
        return 0
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : LabTestCartCell = tableView.dequeueReusableCell(withClass: LabTestCartCell.self, for: indexPath)
        let object = self.object.testsList[indexPath.row]
        
        cell.imgTitle.setCustomImage(with: object.imageLocation)
        cell.lblTitle.text          = object.name
        cell.lblOffer.text          = "\(object.discountPercent!)% OFF"
        //        cell.lblDesc.text = ""
        cell.lblNewPrice.text       = CurrencySymbol.INR.rawValue + "\(object.discountPrice!)"
        
        if JSON(object.discountPercent as Any).intValue > 0 {
            cell.lblOldPrice.text   = CurrencySymbol.INR.rawValue + "\(object.price!)"
            cell.vwOffer.isHidden   = false
        }
        else {
            cell.lblOldPrice.text   = ""
            cell.vwOffer.isHidden   = true
        }
        
        cell.btnRemove.addTapGestureRecognizer {
            Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    self.labTestListVM.updateCartAPI(isAdd: false,
                                                     code: object.code,
                                                     labTestId: object.labTestId,
                                                     screen: .LabtestCart) { [weak self] isDone in
                        guard let self = self else {return}
                        if isDone {
                            //self.object.testsList.remove(at: indexPath.row)
                            CartListModel.shared.testsList.remove(at: indexPath.row)
                            if self.object.testsList.count > 0 {
                                self.viewModel.cartTestListAPI(withLoader: true) { isDone, object in
                                    if isDone {
                                        self.object = object
                                        self.setData()
                                    }
                                    else {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                            else {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
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
extension LabTestCartVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension LabTestCartVC {
    
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
extension LabTestCartVC {
    
    func setData(){
        if let lab = self.object.lab {
            self.imgLab.setCustomImage(with: lab.image)
            self.lblLabName.text        = lab.name
            self.lblLabAddress.text     = lab.address
        }
        
        self.lblCollectionChargePrice.text  = CurrencySymbol.INR.rawValue + "\(self.object.homeCollectionCharge.ammount!)"
        
        if self.object.homeCollectionCharge.payableAmmount > 0 {
            self.lblCollectionChargeFree.text       = CurrencySymbol.INR.rawValue + "\(self.object.homeCollectionCharge.payableAmmount!)"
            self.lblCollectionChargeDesc.isHidden   = true
        }
        else {
            self.lblCollectionChargeFree.text       = AppMessages.Free
            self.lblCollectionChargeDesc.isHidden   = false
        }
        
        self.lblItemOldPrice.text       = CurrencySymbol.INR.rawValue + self.object.orderDetail.orderTotal
        self.lblItemTotalPrice.text     = CurrencySymbol.INR.rawValue + self.object.orderDetail.payableAmount
        self.lblServiceChargeVal.text   = CurrencySymbol.INR.rawValue + self.object.orderDetail.serviceCharge
        self.lblOrderTotalVal.text      = CurrencySymbol.INR.rawValue + "\(self.object.orderDetail.finalPayableAmount!)"
        self.lblAmountVal.text          = CurrencySymbol.INR.rawValue + "\(self.object.orderDetail.finalPayableAmount!)"
        self.lblFinalVal.text           = CurrencySymbol.INR.rawValue + "\(self.object.orderDetail.finalPayableAmount!)"
        
        self.tblTest.reloadData()
    }
}
