//
//  ExerciseMoreVC.swift

import UIKit

class PaymentHistoryTitleCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnViewAll   : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        self.btnViewAll
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
        
        
//        DispatchQueue.main.async {
//            self.vwBg.layoutIfNeeded()
//            self.vwBg.roundCorners([.topLeft, .topRight], radius: 0)
//        }
    }
}

class PaymentHistoryListCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDate              : UILabel!
    @IBOutlet weak var lblDateVal           : UILabel!
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblPrice             : UILabel!
    
    @IBOutlet weak var btnInvoice           : UIButton!
    @IBOutlet weak var btnSelect            : UIButton!
    
    @IBOutlet weak var stackServicePeriod   : UIStackView!
    @IBOutlet weak var stackPaymentMethod   : UIStackView!
    @IBOutlet weak var stackDetails         : UIStackView!
    
    @IBOutlet weak var lblServicePeriod     : UILabel!
    @IBOutlet weak var lblServicePeriodVal  : UILabel!
    
    @IBOutlet weak var lblPaymentMethod     : UILabel!
    @IBOutlet weak var lblPaymentMethodVal  : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.9))
        self.lblDate
            .font(name: .medium, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblDateVal
            .font(name: .medium, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblPrice
            .font(name: .semibold, size: 18)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblServicePeriod
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.lblServicePeriodVal
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblPaymentMethod
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.lblPaymentMethodVal
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.btnInvoice
            .font(name: .medium, size: 11)
            .textColor(color: UIColor.white.withAlphaComponent(1))
            .backGroundColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            
            self.btnInvoice.layoutIfNeeded()
            self.btnInvoice.cornerRadius(cornerRadius: 5)
            
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.borderColor(color: UIColor.themeLightGray, borderWidth: 1)
            self.imgTitle.cornerRadius(cornerRadius: 7)
        }
    }
}

//MARK: -------------------------  UIViewController -------------------------
class PaymentHistoryListVC : ClearNavigationFontBlackBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var btnMoveTop           : UIButton!

    //MARK:- Class Variable
    var arrList                             = [ParentPaymentHistoryListModel]()
    let viewModel                           = PaymentHistoryListVM()
    let refreshControl                      = UIRefreshControl()
    var strErrorMessage : String            = ""
    var lastSyncDate                        = Date()
    var timerSearch                         = Timer()
    
    var isGloabalSearch                     = false
    var strSearch                           = ""
    //MARK: ------------------------- Memory Management Method -------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    func setUpView() {
        self.setup(tblView: tblView)
        self.configureUI()
        self.setupViewModelObserver()
    }
    
    func configureUI(){
        //self.tblView.themeShadow()
    }

    func setup(tblView: UITableView){
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        tblView.addSubview(self.refreshControl)
    }
    
    //MARK: ------------------------- Action Method -------------------------
    @IBAction func btnMoveTopTapped(sender: UIButton){
        self.tblView.scrollToTop()
    }
    
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .HistoryPayment)
        
        self.updateAPIData()
        
//        if Calendar.current.dateComponents([.minute], from: lastSyncDate, to: Date()).minute > kAPI_RELOAD_DELAY_BY {
//            self.lastSyncDate = Date()
//            self.updateAPIData(withLoader: true)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .ExercisePlan, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //FIRAnalytics.manageTimeSpent(on: .ExercisePlan, when: .Disappear)
    }
    
}

//MARK: -------------------------- UITableView Methods --------------------------
extension PaymentHistoryListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell : PaymentHistoryTitleCell = tableView.dequeueReusableCell(withClass: PaymentHistoryTitleCell.self)
    
        let obj             = self.arrList[section]
        cell.lblTitle.text  = obj.title
        
        cell.btnViewAll.addTapGestureRecognizer {
            let vc = ViewAllPaymentHistoryVC.instantiate(fromAppStoryboard: .setting)
            vc.strTitle     = obj.title
            vc.listType     = obj.type
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrList[section].arr.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : PaymentHistoryListCell = tableView.dequeueReusableCell(withClass: PaymentHistoryListCell.self, for: indexPath)
        let objParent   = self.arrList[indexPath.section]
        let obj         = objParent.arr[indexPath.row]
        cell.imgTitle.setCustomImage(with: obj.imageUrl)
        cell.imgTitle.contentMode = .scaleAspectFit
        
        let purchaseDate = GFunction.shared.convertDateFormate(dt: obj.planPurchaseDatetime,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        cell.lblDateVal.text   = purchaseDate.0
        cell.lblTitle.text  = obj.planName
        /*if obj.offerPrice > 0 {
            cell.lblPrice.text = appCurrencySymbol.rawValue + " \(obj.offerPrice!)"
        }
        else {*/
        
        if obj.transactionType == "In-App" {
            cell.lblPrice.text = obj.iosPrice == 0 ? KFree : appCurrencySymbol.rawValue + " \(obj.iosPrice!)"
        }else {
            cell.lblPrice.text = JSON(obj.androidPrice as Any).intValue == 0 ? KFree : appCurrencySymbol.rawValue + " " + "\(JSON(obj.androidPrice as Any).intValue)"
        }
//        }
        
        let startDate = GFunction.shared.convertDateFormate(dt: obj.planStartDate,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.dd_mmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        
        let endDate = GFunction.shared.convertDateFormate(dt: obj.planEndDate,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.dd_mmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        cell.lblServicePeriodVal.text   = startDate.0 + " " + AppMessages.to + " " + endDate.0
        cell.btnSelect.isSelected       = obj.isSelected
        
        if objParent.type == .plan {
            cell.stackServicePeriod.isHidden = false
        }
        else {
            cell.stackServicePeriod.isHidden = true
        }
        
        
        cell.stackDetails.isHidden = true
        if obj.isSelected {
            cell.stackDetails.isHidden = false
        }
        
        if obj.deviceType.lowercased() == "A".lowercased() {
            //"Online"
            cell.lblPaymentMethodVal.text = obj.transactionType.capitalized
        }
        else if obj.deviceType.lowercased() == "I".lowercased() {
            //"In-App"
            cell.lblPaymentMethodVal.text = "In-App"
        }
        else {
            //"-"
            cell.lblPaymentMethodVal.text = "-"
        }
        
        cell.lblPaymentMethodVal.text = (obj.transactionType ?? "-").capitalized
        
        cell.btnInvoice.isHidden = (obj.invoiceURL ?? "").isEmpty
        
        if let invoiceURL = obj.invoiceURL {
            cell.btnInvoice.addTapGestureRecognizer {
                if let url = URL(string: invoiceURL) {
                    let formatter = DateFormatter()
                    formatter.dateFormat = DateTimeFormaterEnum.dd_mm_yyyy_HHmm.rawValue
                    let withName = "Invoice - \(formatter.string(from: Date())).pdf"
                    GFunction.shared.openPdf(url: url,withName: withName)
                }
            }
        }
        
        //cell.lblPaymentMethodVal.text =
        
        //        cell.lblTitle.text = object.title
        //        cell.configInnerTableCell(object: object)
        //        cell.tblView.isUserInteractionEnabled = false
        
        //cell.vwTable.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrList[indexPath.section].arr[indexPath.row]
        if obj.isSelected {
            obj.isSelected = false
        }
        else {
            obj.isSelected = true
        }
        DispatchQueue.main.async {
            self.tblView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.viewModel.managePagenation(refreshControl: self.refreshControl,
//                                        tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension PaymentHistoryListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Set data Methods --------------------------
extension PaymentHistoryListVC {
    
    @objc func updateAPIData(){
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.viewModel.apiCallFromStart_payment_history(refreshControl: self.refreshControl,
                                                         tblView: self.tblView,
                                                         withLoader: false)
                
            }
        }
    }
    
    func setData(){
        self.arrList.removeAll()
        for item in PaymentHistoryType.allCases {
            let obj     = ParentPaymentHistoryListModel()
            obj.type    = item
            switch item {
            case .plan:
                obj.title       = "MyTatva Plans"
                obj.arr         = self.viewModel.arrPlan_payment
            case .test:
                obj.title       = "Diagnostic Test"
                obj.arr         = self.viewModel.arrTest_payment
            }
            if obj.arr.count > 0 {
                self.arrList.append(obj)
            }
        }
        self.tblView.reloadData()
    }

}

//MARK: -------------------- GlobalSearch Methods --------------------
extension PaymentHistoryListVC {
    
    @objc func searchDidUpdate(_ notification: NSNotification) {
        if let _ = self.parent {
            if let searchKeyword = notification.userInfo?["search"] as? String {
                self.strSearch = searchKeyword
                self.updateAPIData()
             }
        }
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension PaymentHistoryListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResultContentList.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.setData()
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

