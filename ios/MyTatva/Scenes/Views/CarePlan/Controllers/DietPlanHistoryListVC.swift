//
//  DietPlanHistoryListVC.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import UIKit

class CarePlanDietPlanCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var btnDownload      : UIButton!
    
    var object = DietPlanListModel() {
        didSet {
            self.setCellData()
        }
    }
    var screeName: ScreenName = .CarePlan
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        
        self.btnDownload.font(name: .medium, size: 12)
            .textColor(color: UIColor.white)
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.btnDownload.layoutIfNeeded()
            
            //self.vwBg.applyViewShadow(shadowOffset: CGSize.zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.2, shdowRadious: 5)
            
            self.vwBg.cornerRadius(cornerRadius: 5)
            self.btnDownload.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple)
        }
        
    }
    
    func setCellData(){
        self.manageActionMethods()
        self.lblTitle.text = self.object.documentTitle
        
        let time = GFunction.shared.convertDateFormate(dt: object.validTill,
                                                       inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .LOCAL)
        self.lblDesc.text = "Valid until \(time.0)"
    }
    
    private func manageActionMethods(){
        self.btnDownload.addTapGestureRecognizer {
            var param = [String : Any]()
            param[AnalyticsParameters.feature_status.rawValue]      = FeatureStatus.active.rawValue
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_DIET_PLAN_CARD,
                                     screen: self.screeName,
                                     parameter: param)
            
            var param2 = [String : Any]()
            param2[AnalyticsParameters.diet_start_date.rawValue]     = self.object.startDate
            param2[AnalyticsParameters.diet_end_date.rawValue]       = self.object.validTill
            FIRAnalytics.FIRLogEvent(eventName: .DIET_PLAN_DOWNLOAD,
                                     screen: self.screeName,
                                     parameter: param2)
            
            if let doc = self.object.documentUrl {
                if let url = URL(string: doc) {
                    GFunction.shared.openPdf(url: url,
                                             withName: self.object.fileName)
                }
            }
            
//            if self.object.documentUrl.contains("pdf") {
//                if let doc = self.object.documentUrl {
//                    if let url = URL(string: doc) {
//                        GFunction.shared.openPdf(url: url)
//                    }
//                }
//            }
//            else {
//                let img = UIImageView()
//                img.setCustomImage(with: self.object.documentUrl) { img, err, cache, url in
//                    if img != nil {
//                        if self.object.documentUrl.trim() != "" {
//                            self.btnDownload.imageView?.tapToZoom(with: img)
//                            self.btnDownload.imageView?.setupImageViewer(images: [img ?? UIImage()])
//                        }
//                    }
//                }
//            }
        }
    }
}

class DietPlanHistoryListVC: ClearNavigationFontBlackBaseVC {
    
    //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var tblView          : UITableView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                       = DietPlanHistoryListVM()
    let refreshControl                  = UIRefreshControl()
    var timerSearch                     = Timer()
    var strErrorMessage : String        = ""
    
    var isGloabalSearch                 = false
    var strSearch                       = ""
    
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchDidUpdate(_:)), name: kPostSearchData, object: nil)
        
        DispatchQueue.main.async {
            
        }
        
        self.configureUI()
        self.manageActionMethods()
      
    }
    
    @objc func updateAPIData(){
        DispatchQueue.main.asyncAfter(deadline: .now()){
            let withLoader = false
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.viewModel.apiCallFromStart(tblView: self.tblView,
                                                      refreshControl: self.refreshControl,
                                                      withLoader: withLoader,
                                                      search: self.strSearch)
            }
        }
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
    
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
           
        DispatchQueue.main.async {
           
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .HistoryRecord)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.updateAPIData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = self.parent?.parent as? TabbarVC {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension DietPlanHistoryListVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : CarePlanDietPlanCell = tableView.dequeueReusableCell(withClass: CarePlanDietPlanCell.self, for: indexPath)
        cell.screeName = .DietPlan
        cell.object = self.viewModel.getObject(index: indexPath.row)
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var params              = [String : Any]()
//        params[AnalyticsParameters.patient_records_id.rawValue]  = self.viewModel.getObject(index: indexPath.row).patientRecordsId
//        FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_RECORD,
//                                 screen: .HistoryRecord,
//                                 parameter: params)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.managePagenation(tblView: self.tblView,
                                        refreshControl: self.refreshControl,
                                        index: indexPath.row,
                                        search: self.strSearch)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension DietPlanHistoryListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension DietPlanHistoryListVC {
    
    fileprivate func setData(){
        
    }
}

//MARK: -------------------- GlobalSearch Methods --------------------
extension DietPlanHistoryListVC {
    
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
extension DietPlanHistoryListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.tblView.reloadData()
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
