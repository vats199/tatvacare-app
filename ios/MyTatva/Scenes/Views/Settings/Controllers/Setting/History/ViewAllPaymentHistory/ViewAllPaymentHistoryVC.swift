//
//  .swift

import UIKit


//MARK: -------------------------  UIViewController -------------------------
class ViewAllPaymentHistoryVC : ClearNavigationFontBlackBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var btnMoveTop           : UIButton!
    @IBOutlet weak var lblTitle             : UILabel!

    //MARK:- Class Variable
    let viewModel                           = ViewAllPaymentHistoryVM()
    let refreshControl                      = UIRefreshControl()
    var strErrorMessage : String            = ""
    var lastSyncDate                        = Date()
    var timerSearch                         = Timer()
    
    var strTitle                            = ""
    var listType: PaymentHistoryType        = .plan
    
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
        self.lblTitle.text = self.strTitle
        
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
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = .default
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
extension ViewAllPaymentHistoryVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : PaymentHistoryListCell = tableView.dequeueReusableCell(withClass: PaymentHistoryListCell.self, for: indexPath)
        let obj = self.viewModel.getObject(index: indexPath.row)
        cell.imgTitle.setCustomImage(with: obj.imageUrl)
        
        let purchaseDate = GFunction.shared.convertDateFormate(dt: obj.planPurchaseDatetime,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        cell.lblDateVal.text    = purchaseDate.0
        cell.lblTitle.text      = obj.planName
        /*if obj.offerPrice > 0 {
            cell.lblPrice.text = appCurrencySymbol.rawValue + " \(obj.offerPrice!)"
        }
        else {*/
        //        }
        if obj.transactionType == "In-App" {
            cell.lblPrice.text = obj.iosPrice == 0 ? KFree : appCurrencySymbol.rawValue + " \(obj.iosPrice!)"
        }else {
            cell.lblPrice.text = JSON(obj.androidPrice as Any).intValue == 0 ? KFree : appCurrencySymbol.rawValue + " " + obj.androidPrice
        }

        
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
        
        if self.listType == .plan {
            cell.stackServicePeriod.isHidden = false
            
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
        }
        else {
            cell.stackServicePeriod.isHidden = true
            cell.lblPaymentMethodVal.text = obj.transactionType.capitalized
        }
        
        
        cell.stackDetails.isHidden = true
        if obj.isSelected {
            cell.stackDetails.isHidden = false
        }
        
        cell.btnInvoice.isHidden = (obj.invoiceURL ?? "").isEmpty
        
        if let invoiceURL = obj.invoiceURL {
            cell.btnInvoice.addTapGestureRecognizer {
                if let url = URL(string: invoiceURL) {
                    GFunction.shared.openPdf(url: url)
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
        let obj = self.viewModel.getObject(index: indexPath.row)
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
        self.viewModel.managePagenation(tblView: self.tblView,
                                        refreshControl: self.refreshControl,
                                        index: indexPath.row,
                                        type: self.listType.rawValue)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension ViewAllPaymentHistoryVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0), NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Set data Methods --------------------------
extension ViewAllPaymentHistoryVC {
    
    @objc func updateAPIData(){
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                
                self.viewModel.apiCallFromStartRecord(tblView: self.tblView,
                                                      refreshControl: self.refreshControl,
                                                      withLoader: false,
                                                      type: self.listType.rawValue)
            }
        }
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension ViewAllPaymentHistoryVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

