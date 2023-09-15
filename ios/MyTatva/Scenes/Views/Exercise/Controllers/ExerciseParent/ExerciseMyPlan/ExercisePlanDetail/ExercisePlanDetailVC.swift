//
//  ExerciseMoreVC.swift

import UIKit

class ExercisePlanDetailRestCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var vwTitle              : UIView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var lblRest              : UILabel!
    
    var object = PlanDaysListModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
        self.lblTitle
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.white)
        self.lblRest
            .font(name: .semibold, size: 20)
            .textColor(color: UIColor.themeBlack)
    
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.vwTitle.layoutIfNeeded()
            
            let color = GFunction.shared.applyGradientColor(startColor: UIColor.themePurple.withAlphaComponent(1),
                                                            endColor: UIColor.themePurple.withAlphaComponent(0.3),
                                                            locations: [0, 1],
                                                            startPoint: CGPoint(x: 0, y: self.vwTitle.frame.maxY),
                                                            endPoint: CGPoint(x: self.vwTitle.frame.maxX, y: self.vwTitle.frame.maxY),
                                                            gradiantWidth: self.vwTitle.frame.width,
                                                            gradiantHeight: self.vwTitle.frame.height)
            
            self.vwTitle.backgroundColor = color
        }
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    func configCell(object : PlanDaysListModel){
        //self.lblTitle.text = object.day + ", " + JSON(object.date!).stringValue + " " + object.month
        
        let time = GFunction.shared.convertDateFormate(dt: object.dayDate,
                                                       inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.EEEEddMMMM.rawValue,
                                                       status: .NOCONVERSION)
                                                       
                                                       
        self.lblTitle.text      = time.0
        
        if self.lblTitle.text?.trim() == "" {
            self.lblTitle.text      = object.day + ", " + "\(object.date!)" + " " + object.month//time.0
        }
    }
}
//MARK: -------------------------  UIViewController -------------------------
class ExercisePlanDetailVC : UIViewController {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var lblTitleTop      : UILabel!
    @IBOutlet weak var tblView          : UITableView!
    @IBOutlet weak var btnMoveTop       : UIButton!

    //MARK:- Class Variable
    let viewModel                       = ExercisePlanDetailVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    var content_master_id               : String!
    var titleTop                        : String!
    var plan_type                       = ""
    var exerciseAddedBy                 = ""
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
        self.tblView.scrollToTop(animated: false)
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .ExercisePlanDetail)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.updateAPIData()
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .ExercisePlanDetail, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAnalytics.manageTimeSpent(on: .ExercisePlanDetail, when: .Disappear)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

//MARK: -------------------------- UITableView Methods --------------------------
extension ExercisePlanDetailVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object = self.viewModel.getObject(index: indexPath.row)
        
        if object.isRestDay == 0 {
            if self.plan_type == "custom" {
                let cell : ExercisePlanDetailCell = tableView.dequeueReusableCell(withClass: ExercisePlanDetailCell.self, for: indexPath)
                
                //cell.lblTitle.text = object.day + ", " + JSON(object.date!).stringValue + " " + object.month
                cell.object             = object
                cell.plan_type          = self.plan_type
                cell.exerciseAddedBy    = self.exerciseAddedBy
                
                return cell
            }
            else {
                let cell : ExerciseMyPlanCell = tableView.dequeueReusableCell(withClass: ExerciseMyPlanCell.self, for: indexPath)
                let object = self.viewModel.getObject(index: indexPath.row)
                cell.configureDetailsCell(object: object)
                
                cell.vwBg.addTapGestureRecognizer {
                    let obj                     = object
                    let vc                      = ExerciseDetailsParentVC.instantiate(fromAppStoryboard: .exercise)
                    vc.exercise_plan_day_id     = obj.exercisePlanDayId
                    vc.plan_type                = self.plan_type
                    vc.exerciseAddedBy          = self.exerciseAddedBy
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
                
                return cell
            }
        }
        else {
            let cell : ExercisePlanDetailRestCell = tableView.dequeueReusableCell(withClass: ExercisePlanDetailRestCell.self, for: indexPath)
            
            //cell.lblTitle.text = object.day + ", " + JSON(object.date!).stringValue + " " + object.month
            cell.object = object
            cell.configCell(object: object)
            
            return cell
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        self.viewModel.managePagenationPlanDaysList(tblView: self.tblView,
//                                                    withLoader: false,
//                                                    content_master_id: self.content_master_id,
//                                                    index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension ExercisePlanDetailVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension ExercisePlanDetailVC {
    
    @objc func updateAPIData(){
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            self.viewModel.apiCallFromStart_PlanDaysList(refreshControl: self.refreshControl,
                                                         tblView: self.tblView,
                                                         withLoader: false,
                                                         content_master_id: self.content_master_id,
                                                         plan_type: self.plan_type,
                                                         type: self.exerciseAddedBy)
        }
    }
    
    func setData(){
        self.lblTitleTop.text = self.titleTop
    }

}

//MARK: -------------------- UIScrollView Delegate Methods --------------------
extension ExercisePlanDetailVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tblView {
            
//            if scrollView.contentSize.height > self.view.frame.size.height && scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
//                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height - scrollView.frame.size.height), animated: false)
//            }
//            else if scrollView.contentSize.height < self.tblView.frame.size.height && scrollView.contentOffset.y >= 0 {
//                scrollView.setContentOffset(CGPoint.zero, animated: false)
//            }
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension ExercisePlanDetailVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessagePlanDays
                
                if self.viewModel.arrPlanDaysList.count > 0 {
                    self.btnMoveTop.isHidden = true
                }
                else {
                    self.btnMoveTop.isHidden = true
                }
                break
                
            case .failure(let error):
                print(error.errorDescription ?? "")
                
            case .none: break
            }
        })
    }
    
}
