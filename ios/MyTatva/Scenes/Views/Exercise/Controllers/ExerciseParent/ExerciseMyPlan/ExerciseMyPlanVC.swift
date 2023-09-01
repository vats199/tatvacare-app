//
//  ExerciseMoreVC.swift

import UIKit

//MARK: -------------------------  UIViewController -------------------------
class ExerciseMyPlanVC : ClearNavigationFontBlackBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var btnMoveTop           : UIButton!

    //MARK:- Class Variable
    let viewModel                           = ExerciseMyPlanVM()
    let refreshControl                      = UIRefreshControl()
    var strErrorMessage : String            = ""
    var lastSyncDate                        = Date()
    var isContinueCoachmark                 = false
    
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
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchDidUpdate(_:)), name: kPostSearchData, object: nil)
        
        self.setup(tblView: tblView)
        self.setData()
        self.configureUI()
        self.setupViewModelObserver()
    }
    
    func configureUI(){
        self.tblView.themeShadow()
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .ExercisePlan)
        self.updateAPIData()
        
//        if Calendar.current.dateComponents([.minute], from: lastSyncDate, to: Date()).minute > kAPI_RELOAD_DELAY_BY {
//            self.lastSyncDate = Date()
//            self.updateAPIData(withLoader: true)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .ExercisePlan, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAnalytics.manageTimeSpent(on: .ExercisePlan, when: .Disappear)
    }
    
}

//MARK: -------------------------- UITableView Methods --------------------------
extension ExerciseMyPlanVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell : ExerciseMyPlanTblCell = tableView.dequeueReusableCell(withClass: ExerciseMyPlanTblCell.self, for: indexPath)
//        let object = self.viewModel.getObject(index: indexPath.row)
//        cell.lblTitle.text = object.title
//        cell.configInnerTableCell(object: object)
//        cell.tblView.isUserInteractionEnabled = false
        
        let cell : ExerciseMyPlanCell = tableView.dequeueReusableCell(withClass: ExerciseMyPlanCell.self, for: indexPath)
        let object = self.viewModel.getObject(index: indexPath.row)
        cell.setCellData(object: object)
        
        PlanManager.shared.isAllowedByPlan(type: .exercise_my_routine_breathing,
                                           sub_features_id: "",
                                           completion: { isAllow in
            if !isAllow{
                PlanManager.shared.isAllowedByPlan(type: .exercise_my_routine_exercise,
                                                   sub_features_id: "",
                                                   completion: { isAllow in
                    if !isAllow{
                        PlanManager.shared.addLock(toView: cell.vwBg,
                                                   eventName: .USER_CLICKED_ON_PLAN_EXERCISE,
                                                   screen: .ExercisePlan)
                    }
                    else {
                        PlanManager.shared.removeLock(toView: cell.vwBg)
                    }
                })
            }
            else {
                PlanManager.shared.removeLock(toView: cell.vwBg)
            }
        })
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.viewModel.getObject(index: indexPath.row)
        
        var param = [String : Any]()
        param[AnalyticsParameters.content_master_id.rawValue]   = object.contentMasterId
        param[AnalyticsParameters.content_type.rawValue]        = object.contentType
        param[AnalyticsParameters.feature_status.rawValue]      = FeatureStatus.active.rawValue
        FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_PLAN_EXERCISE,
                                 screen: .ExercisePlan,
                                 parameter: param)
        
        let vc = ExercisePlanDetailVC.instantiate(fromAppStoryboard: .exercise)
        
        vc.content_master_id            = object.contentMasterId
        vc.titleTop                     = object.title
        vc.plan_type                    = object.planType
        vc.exerciseAddedBy              = object.exerciseAddedBy
        vc.hidesBottomBarWhenPushed     = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.managePagenation(tblView: self.tblView,
                                        refreshControl: self.refreshControl,
                                        withLoader: false,
                                        search: self.strSearch,
                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension ExerciseMyPlanVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension ExerciseMyPlanVC {
    
    @objc func updateAPIData(){
        DispatchQueue.main.async {
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.viewModel.apiCallFromStart_PlanList(refreshControl: self.refreshControl,
                                                         tblView: self.tblView,
                                                         withLoader: false,
                                                         search: self.strSearch)
            }
        }
    }
    
    func setData(){
        
    }
}

//MARK: -------------------- GlobalSearch Methods --------------------
extension ExerciseMyPlanVC {
    
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
extension ExerciseMyPlanVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessagePlanList
                
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    self.startAppTour()
                }
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
    
    func startAppTour(){
        DispatchQueue.main.async {
            if self.isContinueCoachmark {
                self.isContinueCoachmark = false
                self.tblView.scrollToTop(animated: false)
                let vc = CoachmarkExercisePlanVC.instantiate(fromAppStoryboard: .home)
                vc.targetView = self.tblView
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.completionHandler = { obj in
                    if obj?.count > 0 {
                        if let vc = self.parent?.parent as? ExerciseParentVC {
                            vc.manageSelection(type: .Explore)
                            vc.isContinueCoachmark = true
                        }
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
