//
//  RecordsVC.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import UIKit

//enum AppointmentStatus: String {
//    case Scheduled
//    case Cancelled
//    case Complete
//}


class OrderTestVC: ClearNavigationFontBlackBaseVC {
    
    //----------------------------------
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var scrollMain               : UIScrollView!
    @IBOutlet weak var lblTitle                 : UILabel!
    
    @IBOutlet weak var tblView                  : UITableView!
    @IBOutlet weak var tblViewHeight            : NSLayoutConstraint!
    
    @IBOutlet weak var lblBillDetails           : UILabel!
    
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
    
    //MARK: ------------------------- Class Variable -------------------------
    var object                      = LabTestOrderSummaryModel()
    let viewModel                   = OrderTestVM()
    let refreshControl              = UIRefreshControl()
    var isShowDoc                   = false
    
    var strErrorMessage : String    = ""
    
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        
        self.configureUI()
        self.manageActionMethods()
        self.addObserverOnHeightTbl()
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
    
        self.lblTitle
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblBillDetails
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
            
        self.lblSubTotal
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblSubTotalVal
            .font(name: .semibold, size: 15)
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
            .font(name: .medium, size: 15)
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
        
        DispatchQueue.main.async {
//            self.vwSelectClinic.layoutIfNeeded()
//            self.vwSelectClinic.cornerRadius(cornerRadius: 5)
//            self.vwSelectClinic.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
           
        }
        
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
//        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
//        self.tblView.addSubview(self.refreshControl)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
//        self.btnBookAppointment.addTapGestureRecognizer {
//            let vc = BookAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //WebengageManager.shared.navigateScreenEvent(screen: .HistoryRecord)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.scrollMain.isHidden = true
        self.setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = self.parent?.parent as? TabbarVC {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        //FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension OrderTestVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.object.items != nil {
            return self.object.items.count
        }
        return 0
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : OrderTestCell = tableView.dequeueReusableCell(withClass: OrderTestCell.self, for: indexPath)
        
        if self.object.items != nil {
            let objec = self.object.items[indexPath.row]
            cell.object = objec
//            cell.setCellData()
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var params              = [String : Any]()
//        params[AnalyticsParameters.patient_records_id.rawValue]  = self.viewModel.getRecordObject(index: indexPath.row).patientRecordsId
        //FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_RECORD, parameter: params)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.manageAppointmentPagenation(forToday: false,
                                                   tblView: tableView,
                                                   index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension OrderTestVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension OrderTestVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            DispatchQueue.main.async {
                self.tblViewHeight.constant = newvalue.height
                UIView.animate(withDuration: kAnimationSpeed) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblView else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension OrderTestVC {
    
    func setData(){
        if self.object.payableAmount != nil {
            self.tblView.isHidden = false
            self.scrollMain.isHidden            = false
            
            self.lblOrderTotalVal.text          = "\(self.object.items.count)" + " " + AppMessages.items
            self.lblServiceChargeVal.text       = JSON(self.object.serviceCharge as Any).intValue == 0 ? KFree : CurrencySymbol.INR.rawValue + "\(self.object.serviceCharge!)"
            self.lblSubTotalVal.text            =  CurrencySymbol.INR.rawValue + "\(self.object.payableAmount!)"
            self.lblCollectionChargePrice.text  = ""
            self.lblCollectionChargeFree.text   = JSON(self.object.homeCollectionCharge as Any).intValue == 0 ? KFree : CurrencySymbol.INR.rawValue + "\(self.object.homeCollectionCharge!)"
            self.lblOrderTotalVal.text          = CurrencySymbol.INR.rawValue + "\(self.object.orderTotal!)"
            self.lblAmountVal.text              = CurrencySymbol.INR.rawValue + "\(self.object.finalPayableAmount!)"
            
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
        
        self.tblView.reloadData()
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension OrderTestVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.tblView.reloadData()
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
