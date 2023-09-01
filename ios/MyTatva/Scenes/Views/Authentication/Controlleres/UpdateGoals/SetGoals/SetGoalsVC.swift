//

import UIKit
import Alamofire


class SetGoalsCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var imgView      : UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!
    
    @IBOutlet weak var lblDesc      : UILabel!
    @IBOutlet weak var txtDesc      : UITextField!
    @IBOutlet weak var btnEdit      : UIButton!
    @IBOutlet weak var btnUpdate    : UIButton!
    
    var objGoal = GoalListModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .bold, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.lblDesc.font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.txtDesc.font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            .cornerRadius(cornerRadius: 5)
        self.txtDesc.textAlignment = .center
        
        self.btnEdit.font(name: .medium, size: 12)
            .textColor(color: UIColor.themePurple)
        self.btnUpdate.font(name: .medium, size: 12)
            .textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
            self.imgView.layoutIfNeeded()
            self.imgView.cornerRadius(cornerRadius: 5)
        }
    }
    
    func setData(){
        let type = GoalType.init(rawValue: self.objGoal.keys) ?? .Exercise
        self.txtDesc.regex = Validations.RegexType.OnlyNumber.rawValue
        self.btnEdit.isHidden = false
        switch type {
        case .Medication:
            
            self.btnEdit.isHidden = true
            break
        case .Calories:
            
            self.txtDesc.maxLength = 2
            break
        case .Steps:
            
            self.txtDesc.maxLength = 6
            break
        case .Exercise:
            
            self.txtDesc.maxLength = 3
            break
        case .Pranayam:
            
            self.txtDesc.maxLength = 3
            break
        case .Sleep:
            
            self.txtDesc.maxLength = 2
            break
        case .Water:
            
            self.txtDesc.maxLength = 3
            break
            
        case .Diet:
            self.txtDesc.maxLength = 4
            break
        }
    }
    
}

//MARK: -------------------- UITextField Delegate --------------------
extension SetGoalsCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtDesc {
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            let valueTest   = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.OnlyNumber.rawValue)
            let isAllow  = valueTest.evaluate(with: newText)
            
            if isAllow {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                    /*
                     if newText.trim() != "" {
                         let enteredValue    = JSON(newText).intValue
                         if let vc = self.parentViewController as? SetGoalsVC {
                             
                             if vc.isValidGoal(object: self.objGoal,
                                                 enteredValue: enteredValue) {
                                 self.objGoal.goalValue      = newText
                             }
                             else {
                                 self.txtDesc.text!          = self.objGoal.goalValue
                             }
                         }
                     }
                     else {
                         //self.txtDesc.text!          = self.objGoal.goalValue
                     }
                     */
                }
            }
            return isAllow
        }
        
        return true
    }
}

class SetReadingsCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var vwImgBg          : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var btnUpdateReading : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.btnUpdateReading.font(name: .regular, size: 12)
            .textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
            self.vwImgBg.layoutIfNeeded()
            self.vwImgBg.cornerRadius(cornerRadius: 5)
        }
    }
}

class SetGoalsVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var scrollMain           : UIScrollView!
    @IBOutlet weak var imgLogo              : UIImageView!
    @IBOutlet weak var imgLogo2             : UIImageView!
    
    @IBOutlet weak var lblSetGoal           : UILabel!
    @IBOutlet weak var lblSetGoalDesc       : UILabel!
    
    @IBOutlet weak var tblGoals             : UITableView!
    @IBOutlet weak var tblGoalsHeight       : NSLayoutConstraint!
    
    @IBOutlet weak var btnAddGoal           : UIButton!
    @IBOutlet weak var btnAddReadings       : UIButton!
    
    @IBOutlet weak var lblReadings          : UILabel!
    @IBOutlet weak var lblReadingsDesc      : UILabel!
    
    @IBOutlet weak var tblReadings          : UITableView!
    @IBOutlet weak var tblReadingsHeight    : NSLayoutConstraint!
    
    @IBOutlet weak var btnDailySummaryInfo  : UIButton!
    @IBOutlet weak var btnSubmit            : UIButton!
    @IBOutlet weak var btnBack              : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                           = SetGoalsVM()
    var isEdit                              = false
    var doNothingWhenReadingUpdates         = false
    let refreshControl                      = UIRefreshControl()
    var strErrorGoalMessage : String        = ""
    var strErrorReadingMessage : String     = ""
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    //var arrGoal = [GoalListModel]()
//    var arrGoal : [JSON] = [
//        [
//            "img" : "goals_calories",
//            "name" : "Calories",
//            "desc" : "2500  calories per day",
//            "type": GoalType.Calories.rawValue,
//            "isSelected": 0,
//        ],
//        [
//            "img" : "goals_steps",
//            "name" : "Steps",
//            "desc" : "2500 steps per day",
//            "type": GoalType.Steps.rawValue,
//            "isSelected": 0,
//        ],
//        [
//            "img" : "goals_exercise",
//            "name" : "Exercise",
//            "desc" : "30 minutes per day",
//            "type": GoalType.Exercise.rawValue,
//            "isSelected": 0,
//        ]
//    ]
    
    //var arrReading : [ReadingListModel] = []
//        [
//            [
//                "img" : "reading_lung",
//                "name" : "Lung Function",
//                "desc" : "2500  calories per day",
//                "type": ReadingType.Lung.rawValue,
//                "isSelected": 0,
//            ],
//            [
//                "img" : "reading_pulseOxy",
//                "name" : "Pulse Oxygen",
//                "desc" : "2500 steps per day",
//                "type": ReadingType.PulseOxygen.rawValue,
//                "isSelected": 0,
//            ],
//            [
//                "img" : "reading_bp",
//                "name" : "Blood Pressure",
//                "desc" : "30 minutes per day",
//                "type": ReadingType.BloodPressure.rawValue,
//                "isSelected": 0,
//            ]
//        ]
    
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
        self.scrollMain.delegate = self
        self.addObserverOnHeightTbl()
        self.configureUI()
        self.manageActionMethods()
        self.applyStyle()
    }
    
    private func applyStyle() {
        
        self.lblSetGoal
            .font(name: .bold, size: 20).textColor(color: .themeBlack)
        self.lblSetGoalDesc
            .font(name: .regular, size: 16).textColor(color: .themeBlack)
        
        self.lblReadings
            .font(name: .bold, size: 20).textColor(color: .themeBlack)
        self.lblReadingsDesc
            .font(name: .regular, size: 16).textColor(color: .themeBlack)
        
        self.btnAddGoal
            .font(name: .regular, size: 12).textColor(color: .themePurple)
            .cornerRadius(cornerRadius: 5)
            .borderColor(color: UIColor.themePurple, borderWidth: 1)
        
        self.btnAddReadings
            .font(name: .regular, size: 12).textColor(color: .themePurple)
            .cornerRadius(cornerRadius: 5)
            .borderColor(color: UIColor.themePurple, borderWidth: 1)
    }
    
    @objc func updateAPIData(){
        self.strErrorGoalMessage        = ""
        self.strErrorReadingMessage     = ""
        self.viewModel.apiCallFromStart_goal(refreshControl: self.refreshControl,
                                        tblView: self.tblGoals,
                                        withLoader: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.viewModel.apiCallFromStart_reading(refreshControl: self.refreshControl,
                                            tblView: self.tblGoals,
                                            withLoader: false)
        }
        
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
    
        self.setup(tblView: self.tblGoals)
        self.setup(tblView: self.tblReadings)
        
        if self.isEdit {
            self.btnSubmit.setTitle(AppMessages.submit, for: .normal)
        }
        else {
            self.btnSubmit.setTitle(AppMessages.completeSetup, for: .normal)
        }
        
//        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
//        self.tblGoals.addSubview(self.refreshControl)

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
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    
    func manageActionMethods(){
        
        self.btnDailySummaryInfo.addTapGestureRecognizer { [weak self] in
            guard let _ = self else {return}
            
            Alert.shared.showAlert(message: AppMessages.dailySummaryInfo) { [weak self]  isDone in
                guard let _ = self else {return}
                
            }
        }
        
        self.btnAddGoal.addTapGestureRecognizer { [weak self] in
            guard let self = self else {return}
            
            let vc = AddGoalsVC.instantiate(fromAppStoryboard: .auth)
            vc.arrDataOffline = self.viewModel.arrGoalList
            vc.completionHandler = { obj in
                if obj != nil {
                    //Do your task here
                    let arrTemp = self.viewModel.arrGoalList
                    self.viewModel.arrGoalList.removeAll()
                    self.viewModel.arrGoalList.append(obj ?? [])
                    
                    for parent in self.viewModel.arrGoalList {
                        for child in arrTemp {
                            if parent.goalMasterId == child.goalMasterId {
                                parent.goalValue = child.goalValue
                            }
                        }
                    }
                    self.tblGoals.reloadData()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnAddReadings.addTapGestureRecognizer {
            let vc = AddReadingsVC.instantiate(fromAppStoryboard: .auth)
            vc.arrDataOffline = self.viewModel.arrReadingList
            vc.completionHandler = { obj in
                if obj != nil {
                    //Do your task here
                    self.viewModel.arrReadingList.removeAll()
                    self.viewModel.arrReadingList.append(obj ?? [])
                    if self.viewModel.arrReadingList.count > 0 &&
                    self.viewModel.arrGoalList.count > 0 {
                        self.doNothingWhenReadingUpdates = true
                        self.viewModel.apiAddReadingGoalCall(vc: self,
                                                             arrReading: self.viewModel.arrReadingList,
                                                             arrGoal: self.viewModel.arrGoalList)
                    }
//                    self.tblReadings.reloadData()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnBack.addTapGestureRecognizer {
            if self.viewModel.arrReadingList.count > 0 &&
            self.viewModel.arrGoalList.count > 0 {
                
                self.viewModel.apiAddReadingGoalCall(vc: self,
                                                     arrReading: self.viewModel.arrReadingList,
                                                     arrGoal: self.viewModel.arrGoalList)
                
                if self.isEdit {
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        self.btnSubmit.addTapGestureRecognizer {
            /*
             PARAMETER:
             
             {"readings":[{"reading_id":"de3dcfe5-1a17-11ec-a706-a87eea410734","reading_datetime":"2021-09-22 15:15:15","reading_value":"100"}],
             "goals":[{"goal_id":"a99daf7a-1a16-11ec-a706-a87eea410734","goal_value":"100","start_date":"2021-09-22","end_date":"2021-09-22"}]}
             
             */
            
            self.viewModel.apiAddReadingGoalCall(vc: self,
                                                 arrReading: self.viewModel.arrReadingList,
                                                 arrGoal: self.viewModel.arrGoalList)
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
        self.updateAPIData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        WebengageManager.shared.navigateScreenEvent(screen: .SetUpGoalsReadings)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .SetUpGoalsReadings, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAnalytics.manageTimeSpent(on: .SetUpGoalsReadings, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension SetGoalsVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblGoals:
            return self.viewModel.arrGoalList.count
            
        case self.tblReadings:
            return self.viewModel.arrReadingList.count
            
        default: return 0
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.tblGoals:
            
            let cell : SetGoalsCell     = tableView.dequeueReusableCell(withClass: SetGoalsCell.self, for: indexPath)
            
            let object                  = self.viewModel.arrGoalList[indexPath.row]
//            let type = GoalType.init(rawValue: object["type"].stringValue) ?? .Calories
//            cell.imgView.image      = type.image//UIImage(named: object["img"].stringValue)
            
            cell.objGoal                = object
            cell.setData()
            cell.txtDesc.delegate       = cell
            cell.imgView.image          = nil
            cell.imgView.setCustomImage(with: object.imageUrl)
            cell.lblTitle.text          = object.goalName
            
            let goalValue = String(format: "%.f", Float(object.goalValue) ?? 0)
            cell.lblDesc.text           = goalValue + " " + object.goalMeasurement.lowercased() + " " + AppMessages.perDay
            
            let type = GoalType.init(rawValue: object.keys) ?? .Medication
            
            cell.lblDesc.isHidden = false
            if type == .Medication {
                cell.lblDesc.isHidden = true
            }
            
            cell.btnUpdate.isHidden = true
            cell.txtDesc.isHidden = true
            cell.btnEdit.addTapGestureRecognizer {
                PlanManager.shared.isAllowedByPlan(type: .activity_logs,
                                                   sub_features_id: object.keys,
                                                   completion: { isAllow in
                    if isAllow {
                        cell.btnEdit.isHidden       = true
                        cell.txtDesc.isHidden       = false
                        cell.btnUpdate.isHidden     = false
                        cell.lblDesc.text           = object.goalMeasurement.lowercased() + " " + AppMessages.perDay
                    }
                    else {
                        PlanManager.shared.alertNoSubscription()
                    }
                })
                
                
//                let vc = UpdateGoalParentVC.instantiate(fromAppStoryboard: .goal)
//                vc.selectedIndex = indexPath.row
//                vc.arrList = self.viewModel.arrGoalList
//                vc.modalPresentationStyle = .overFullScreen
//                vc.completionHandler = { obj in
//                    if obj?.count > 0 {
//                        print(obj ?? "")
//                        //object
//                        self.tblGoals.reloadData()
//                    }
//                }
//                self.present(vc, animated: true, completion: nil)
            }
            
            cell.btnUpdate.addTapGestureRecognizer {
                DispatchQueue.main.async {
                    let enteredValue    = JSON(cell.txtDesc.text!).intValue
                    if self.isValidGoal(object: object,
                                        enteredValue: enteredValue) {
                        cell.objGoal.goalValue      = cell.txtDesc.text!
                    }
                    else {
                        cell.objGoal.goalValue      = cell.objGoal.goalValue
                    }
                    
                    cell.txtDesc.text!          = ""
                    cell.txtDesc.isHidden       = true
                    cell.btnUpdate.isHidden     = true
                    cell.btnEdit.isHidden       = false
                    self.tblGoals.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            
            return cell
            
        case self.tblReadings:
            let cell : SetReadingsCell = tableView.dequeueReusableCell(withClass: SetReadingsCell.self, for: indexPath)
            
            let object              = self.viewModel.arrReadingList[indexPath.row]
//            let type = ReadingType.init(rawValue: object["type"].stringValue) ?? .BloodPressure
//            cell.imgView.image      = type.image//UIImage(named: object["img"].stringValue)
            
            cell.vwImgBg
                .backGroundColor(color: UIColor.hexStringToUIColor(hex: object.backgroundColor).withAlphaComponent(0.1))
            cell.imgView.image      = nil
            cell.imgView.setCustomImage(with: object.imageUrl, renderingMode: .alwaysTemplate)
            cell.imgView.tintColor  = UIColor.hexStringToUIColor(hex: object.colorCode)
            cell.lblTitle.text      = object.readingName
            
            cell.btnUpdateReading.addTapGestureRecognizer {
                if object.notConfigured.trim() != "" {
                    Alert.shared.showSnackBar(object.notConfigured)
                }
                else {
                    PlanManager.shared.isAllowedByPlan(type: .reading_logs,
                                                       sub_features_id: object.keys,
                                                       completion: { isAllow in
                        if isAllow {
                            if let type = ReadingType.init(rawValue: object.keys) {
                                if type == .cat {
                                    GlobalAPI.shared.get_cat_surveyAPI { [weak self]  (isDone, object, id) in
                                        guard let self = self else {return}
                                        if isDone {
                                            SurveySparrowManager.shared.startSurveySparrow(token: object.surveyId)
                                            SurveySparrowManager.shared.completionHandler = { Response in
                                                print(Response as Any)
                                                
                                                
                                                GlobalAPI.shared.add_cat_surveyAPI(cat_survey_master_id: object.catSurveyMasterId,
                                                                                   survey_id: object.surveyId,
                                                                                   Score: String(Response!["score"] as? Int ?? 0), response: Response!["response"] as! [[String: Any]]) { [weak self]  (isDone, msg) in
                                                    guard let self = self else {return}
                                                    
                                                    if isDone {
                                                        var params = [String: Any]()
                                                        params[AnalyticsParameters.reading_name.rawValue]   = object.readingName
                                                        params[AnalyticsParameters.reading_id.rawValue]     = object.readingsMasterId
                                                        
                                                        FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATED_READING,
                                                                                 screen: .LogReading,
                                                                                 parameter: params)
                                                        
                                                        self.viewModel.apiCallFromStart_reading(refreshControl: self.refreshControl,
                                                                                        tblView: self.tblGoals,
                                                                                        withLoader: true)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                else {
                                    let vc = UpdateReadingParentVC.instantiate(fromAppStoryboard: .goal)
                                    vc.selectedIndex = indexPath.row
                                    vc.arrList = self.viewModel.arrReadingList
                                    vc.modalPresentationStyle = .overFullScreen
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.completionHandler = { obj in
                                        if obj?.count > 0 {
                                            print(obj ?? "")
                                            //object
        //                                    self.tblReadings.reloadData()
                                            self.viewModel.apiCallFromStart_reading(refreshControl: self.refreshControl,
                                                                            tblView: self.tblGoals,
                                                                            withLoader: true)
                                        }
                                    }
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                        }
                        else {
                            PlanManager.shared.alertNoSubscription()
                        }
                    })
                }
            }
            
            return cell
            
        default: return UITableViewCell()
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tblGoals:
            break
            
        case self.tblReadings:
            break
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension SetGoalsVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        if scrollView == self.tblGoals {
            let text = self.strErrorGoalMessage
            let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
            return NSAttributedString(string: text, attributes: attributes)
        }
        else if scrollView == self.tblReadings {
            let text = self.strErrorReadingMessage
            let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
            return NSAttributedString(string: text, attributes: attributes)
        }
        let text = self.strErrorReadingMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension SetGoalsVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblGoals, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblGoalsHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.tblReadings, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblReadingsHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblGoals.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblReadings.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblGoals else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView1 = self.tblReadings else {return}
        if let _ = tblView1.observationInfo {
            tblView1.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    func updateGoal(cell: SetGoalsCell,
                    object : GoalListModel,
                    enteredValue: Int) {
        if enteredValue != 0 {
            let type = GoalType.init(rawValue: object.keys) ?? .Exercise
            
            switch type {
            case .Medication:
                
                break
            case .Calories:
                
                break
            case .Steps:
                
                if enteredValue > kMaxStepsGoal {
                    return Alert.shared.showSnackBar(AppError.validation(type: .invalidStepsGoal).errorDescription ?? "")
                }
                
                break
            case .Exercise:
               
                if enteredValue > kMaxExerciseGoal {
                    return Alert.shared.showSnackBar(AppError.validation(type: .invalidExerciseGoal).errorDescription ?? "")
                }
                break
            case .Pranayam:
               
                if enteredValue > kMaxPranayamaGoal {
                    return Alert.shared.showSnackBar(AppError.validation(type: .invalidPranayamaGoal).errorDescription ?? "")
                }
                break
            case .Sleep:
               
                if enteredValue > kMaxSleepGoal {
                    return Alert.shared.showSnackBar(AppError.validation(type: .invalidSleepGoal).errorDescription ?? "")
                }
                break
            case .Water:
                
                if enteredValue > kMaxWaterGoal {
                    return Alert.shared.showSnackBar(AppError.validation(type: .invalidWaterGoal).errorDescription ?? "")
                }
                break
                
            case .Diet:
                
                if enteredValue > kMaxDietGoal {
                    return Alert.shared.showSnackBar(AppError.validation(type: .invalidDietGoal).errorDescription ?? "")
                }
                break
                
            }
            cell.objGoal.goalValue      = cell.txtDesc.text!
        }
        else {
            cell.objGoal.goalValue = cell.objGoal.goalValue
        }
    }
    
    func isValidGoal(object: GoalListModel,
                     enteredValue: Int) -> Bool{
        
        var returnVal = true
        if enteredValue != 0 {
            let type = GoalType.init(rawValue: object.keys) ?? .Exercise
            switch type {
            case .Medication:
                
                break
            case .Calories:
                
                break
            case .Steps:
                
                if enteredValue > kMaxStepsGoal {
                    Alert.shared.showSnackBar(AppError.validation(type: .invalidStepsGoal).errorDescription ?? "")
                    returnVal = false
                }
                
                break
            case .Exercise:
               
                if enteredValue > kMaxExerciseGoal {
                    Alert.shared.showSnackBar(AppError.validation(type: .invalidExerciseGoal).errorDescription ?? "")
                    returnVal = false
                }
                break
            case .Pranayam:
               
                if enteredValue > kMaxPranayamaGoal {
                    Alert.shared.showSnackBar(AppError.validation(type: .invalidPranayamaGoal).errorDescription ?? "")
                    returnVal = false
                }
                break
            case .Sleep:
               
                if enteredValue > kMaxSleepGoal {
                    Alert.shared.showSnackBar(AppError.validation(type: .invalidSleepGoal).errorDescription ?? "")
                    returnVal = false
                }
                break
            case .Water:
                
                if enteredValue > kMaxWaterGoal {
                    Alert.shared.showSnackBar(AppError.validation(type: .invalidWaterGoal).errorDescription ?? "")
                    returnVal = false
                }
                break
                
            case .Diet:
                
                if enteredValue > kMaxDietGoal {
                    Alert.shared.showSnackBar(AppError.validation(type: .invalidDietGoal).errorDescription ?? "")
                    returnVal = false
                }
                break
            }
        }
        else {
            returnVal = false
        }
        return returnVal
    }
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension SetGoalsVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollMain {
            let contentOffset = scrollView.contentOffset
            if contentOffset.y <= 0 {

                let scale           = (-contentOffset.y * 0.002) + 1
                let translation     = CGAffineTransform(translationX: scale, y: 0)
                let scaling         = CGAffineTransform(scaleX: scale, y: scale)
                let fullTransform   = scaling.concatenating(translation)
                
                self.imgLogo.transform      = fullTransform
                self.imgLogo2.transform     = scaling
                
//                if let vw = self.tabBarController?.tabBar.subviews[1] as? UIView {
//                    vw.transform     = fullTransform
//                }
                
            }
            
            if scrollView.isAtBottom {
//                FIRAnalytics.FIRLogEvent(eventName: .USER_SCROLL_DEPTH_HOME, parameter: nil)
            }
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension SetGoalsVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmArrayResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                DispatchQueue.main.async {
                    self.strErrorGoalMessage        = self.viewModel.strErrorGoalMessage
                    self.strErrorReadingMessage     = self.viewModel.strErrorReadingMessage

                    self.tblGoals.reloadData()
                    self.tblReadings.reloadData()
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
        self.viewModel.vmSubmitResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                
                if self.doNothingWhenReadingUpdates {
                    self.doNothingWhenReadingUpdates = false
                    self.viewModel.apiCallFromStart_reading(refreshControl: self.refreshControl,
                                                    tblView: self.tblGoals,
                                                    withLoader: true)
                }
                else if self.isEdit {
                    FIRAnalytics.FIRLogEvent(eventName: .USER_CHANGED_GOALS_READINGS,
                                             screen: .SetUpGoalsReadings,
                                             parameter: nil)
                    //FIRAnalytics.FIRLogEvent(eventName: .USER_CHANGED_MARKER, parameter: nil)
                    
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    FIRAnalytics.FIRLogEvent(eventName: .NEW_USER_GOALS_READINGS,
                                             screen: .SetUpGoalsReadings,
                                             parameter: nil)
                    //FIRAnalytics.FIRLogEvent(eventName: .NEW_USER_READING, parameter: nil)
                    
                    let vc = ProfileSetupSuccessVC.instantiate(fromAppStoryboard: .auth)
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

