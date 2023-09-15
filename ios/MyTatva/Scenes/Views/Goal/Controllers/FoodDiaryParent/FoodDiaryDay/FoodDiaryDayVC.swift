//
//  ExerciseMoreVC.swift

import UIKit

class FoodDiaryDayHeaderCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var imgFood              : UIImageView!
    @IBOutlet weak var lblCal               : UILabel!
    @IBOutlet weak var btnSelect            : UIButton!
    @IBOutlet weak var btnDropdown          : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.lblTitle
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.themeBlack)
        
        self.lblCal
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
    
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
            
            self.imgFood.layoutIfNeeded()
            self.imgFood.cornerRadius(cornerRadius: 4)
        }
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
}

class FoodDiaryDayChildCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var lblCal               : UILabel!
    @IBOutlet weak var btnEdit              : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.lblTitle
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblTitle
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        
        self.lblCal
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
    
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
        }
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
}
//MARK: -------------------------  UIViewController -------------------------
class FoodDiaryDayVC : UIViewController {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var txtTitleDate         : UITextField!
    @IBOutlet weak var btnViewInsights      : UIButton!
    
    @IBOutlet weak var vwCalories           : UIView!
    @IBOutlet weak var progressCalories     : LinearProgressBar!
    @IBOutlet weak var imgCalories          : UIImageView!
    @IBOutlet weak var lblCalories          : UILabel!
    @IBOutlet weak var lblCaloriesValue     : UILabel!
    
    @IBOutlet weak var lblTotalIntake       : UILabel!
    @IBOutlet weak var lblTotalIntakeValue  : UILabel!
    
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var tblViewHeight        : NSLayoutConstraint!
    
    //MARK:- Class Variable
    let viewModel                       = FoodDiaryDayVM()
    var object                          = FoodDiaryDayModel()
    var strDate                         = ""
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    var selectedFilterobject            = ContenFilterListModel()
    var lastSyncDate                    = Date()
    
    var datePicker                      = UIDatePicker()
    var dateFormatter                   = DateFormatter()
    var dateFormat                      = DateTimeFormaterEnum.MMMMDD.rawValue
    
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
        self.addObserverOnHeightTbl()
        self.configureUI()
        self.setupViewModelObserver()
        self.setup(tblView: tblView)
        self.manageActionMethods()
        self.initDatePicker()
    }
    
    func configureUI(){
        //self.tblView.themeShadow()
        
        self.txtTitleDate
            .font(name: .bold, size: 22)
            .textColor(color: UIColor.themeBlack)
        self.txtTitleDate.delegate = self
        self.txtTitleDate.tintColor = .clear
        
        self.btnViewInsights
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
        
        self.lblCalories
            .font(name: .bold, size: 18)
            .textColor(color: UIColor.themeBlack)
        self.lblCaloriesValue
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        
        GFunction.shared.setProgress(progressBar: self.progressCalories, color: UIColor.themePurple)
        
        self.lblTotalIntake
            .font(name: .medium, size: 17)
            .textColor(color: UIColor.themeBlack)
        self.lblTotalIntakeValue
            .font(name: .medium, size: 22)
            .textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.vwCalories.layoutIfNeeded()
            self.vwCalories.cornerRadius(cornerRadius: 5)
                .borderColor(color: .themePurple, borderWidth: 1)
                .backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.15))
            
            self.btnViewInsights.layoutIfNeeded()
            self.btnViewInsights.cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)
        }
    }
    
    func setup(tblView: UITableView){
        tblView.tableFooterView             = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource          = self
        tblView.emptyDataSetDelegate        = self
        tblView.delegate                    = self
        tblView.dataSource                  = self
        tblView.rowHeight                   = UITableView.automaticDimension
        tblView.sectionHeaderHeight         = UITableView.automaticDimension
        tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        tblView.addSubview(self.refreshControl)
    }
    
    //MARK: ------------------------- Action Method -------------------------
    private func manageActionMethods(){
        self.btnViewInsights.addTapGestureRecognizer {
            
            let vc = FoodDiaryDetailVC.instantiate(fromAppStoryboard: .goal)
            let dateFormatter           = DateFormatter()
            dateFormatter.dateFormat    = DateTimeFormaterEnum.yyyymmdd.rawValue
            dateFormatter.timeZone      = .current
            vc.insight_date             = dateFormatter.string(from: self.datePicker.date)
            
            ///------------------------------------------------
            var params                  = [String: String]()
            params["date_of_insight"]   = dateFormatter.string(from: self.datePicker.date)
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_INSIGHT,
                                     screen: .FoodDiaryDay,
                                     parameter: nil)
            ///------------------------------------------------
            
            dateFormatter.dateFormat    = DateTimeFormaterEnum.MMMDD.rawValue
            dateFormatter.timeZone      = .current
            vc.dateMonth                = dateFormatter.string(from: self.datePicker.date)
            self.navigationController?.pushViewController(vc, animated: true)
            
            
//            PlanManager.shared.isAllowedByPlan(type: .food_logs,
//                                               sub_features_id: "",
//                                               completion: { isAllow in
//                if isAllow {
//                }
//                else {
//                    PlanManager.shared.alertNoSubscription()
//                }
//            })
        }
    }
    
    @IBAction func btnMoveTopTapped(sender: UIButton){
        self.tblView.scrollToTop()
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.datePicker.date = Date()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .FoodDiaryDay)
        
        self.updateAPIData(withLoader: true)
        
        self.tblView.reloadData()
        if Calendar.current.dateComponents([.minute], from: lastSyncDate, to: Date()).minute > kAPI_RELOAD_DELAY_BY {
            self.lastSyncDate = Date()
            //self.updateAPIData(withLoader: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .FoodDiaryDay, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAnalytics.manageTimeSpent(on: .FoodDiaryDay, when: .Disappear)
    }

}

//MARK: -------------------------- UITableView Methods --------------------------
extension FoodDiaryDayVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.object.foodData != nil {
            return self.object.foodData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell : FoodDiaryDayHeaderCell = tableView.dequeueReusableCell(withClass: FoodDiaryDayHeaderCell.self)

        let object = self.object.foodData[section]
        cell.lblTitle.text = object.mealType

        let calorie = Float(object.totalCal) ?? 0
        cell.lblCal.text = String(format: "%0.0f", calorie) + " " + AppMessages.cal

        
        cell.btnDropdown.isSelected = object.isSelected
        
        cell.btnSelect.isSelected = false
        if object.mealData.count > 0 {
            cell.btnSelect.isSelected = true
        }
        
        if object.imageUrl.count > 0 {
            cell.imgFood.isHidden = false
            cell.imgFood.setCustomImage(with: object.imageUrl.first!)
        }
        else {
            cell.imgFood.isHidden = true
        }
        
        cell.btnDropdown.isUserInteractionEnabled = false
        cell.vwBg.addTapGestureRecognizer {
            if calorie > 0 {
                cell.btnDropdown.isSelected = !cell.btnDropdown.isSelected
                object.isSelected = cell.btnDropdown.isSelected
                self.tblView.reloadSections([section], with: .automatic)
                //self.tblView.reloadData()
            }
            else {
                PlanManager.shared.isAllowedByPlan(type: .activity_logs,
                                                   sub_features_id: GoalType.Diet.rawValue,
                                                   completion: { isAllow in
                    if isAllow {
                        let vc = FoodLogVC.instantiate(fromAppStoryboard: .goal)
                        vc.mealTypesId      = object.mealTypesId
                        vc.selectedDate     = self.datePicker.date
                        vc.hidesBottomBarWhenPushed = true
                        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        PlanManager.shared.alertNoSubscription()
                    }
                })
            }
        }

        return cell.contentView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.object.foodData != nil {
            let object = self.object.foodData[section]
            if object.isSelected {
                return self.object.foodData[section].mealData.count
            }
            else {
                return 0
            }
        }
        return 0
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FoodDiaryDayChildCell = tableView.dequeueReusableCell(withClass: FoodDiaryDayChildCell.self, for: indexPath)
        let parentObject    = self.object.foodData[indexPath.section]
        let object          = parentObject.mealData[indexPath.row]
        
        cell.lblTitle.text = object.foodName
        cell.lblDesc.text = "\(object.quantity!)" + " " + object.unitName

        cell.lblCal.text = String(format: "%0.0f", Float(object.calories) ?? 0) + " " + AppMessages.cal

        
        cell.btnEdit.addTapGestureRecognizer {
            
            var param = [String  :Any]()
            param[AnalyticsParameters.meal_types_id.rawValue] = self.object.foodData[indexPath.section].mealTypesId
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_EDIT_MEAL,
                                     screen: .FoodDiaryDay,
                                     parameter: param)
            
            PlanManager.shared.isAllowedByPlan(type: .activity_logs,
                                               sub_features_id: GoalType.Diet.rawValue,
                                               completion: { isAllow in
                if isAllow {
                    let vc = FoodLogVC.instantiate(fromAppStoryboard: .goal)
                    vc.mealTypesId          = parentObject.mealTypesId
                    vc.isEdit               = true
                    vc.selectedDate         = self.datePicker.date
                    vc.patient_meal_rel_id  = object.patientMealRelId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }

        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //self.viewModel.managePagenationContentList(index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension FoodDiaryDayVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension FoodDiaryDayVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            self.tblViewHeight.constant = newvalue.height
            
            UIView.animate(withDuration: kAnimationSpeed) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let colView = self.tblView else {return}
        if let _ = colView.observationInfo {
            colView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------------- Date picker Methods --------------------------
extension FoodDiaryDayVC {
    
    func initDatePicker(){
       
        self.txtTitleDate.inputView         = self.datePicker
        self.txtTitleDate.delegate          = self
        self.datePicker.datePickerMode      = .date
        self.datePicker.maximumDate         =  Calendar.current.date(byAdding: .day, value: 0, to: Date())
        self.datePicker.timeZone            = .current
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
    
        if #available(iOS 14, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.datePicker:
            self.dateFormatter.dateFormat   = self.dateFormat
            self.dateFormatter.timeZone     = .current
            self.txtTitleDate.text          = self.dateFormatter.string(from: sender.date)
            break
     
        default:break
        }
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension FoodDiaryDayVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.txtTitleDate:
            
            if self.txtTitleDate.text?.trim() == "" {
                self.dateFormatter.dateFormat   = self.dateFormat
                self.dateFormatter.timeZone     = .current
                self.txtTitleDate.text          = self.dateFormatter.string(from: self.datePicker.date)
                self.updateAPIData(withLoader: true)
            }
            return true
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.txtTitleDate:
            self.updateAPIData(withLoader: true)
        default:
            break
        }
    }
}

//MARK: -------------------------- Set data Methods --------------------------
extension FoodDiaryDayVC {
    
    @objc func updateAPIData(withLoader: Bool = false){
        
        //self.vwBg.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            //if self.viewModel.arrListContentList.count == 0 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat    = DateTimeFormaterEnum.yyyymmdd.rawValue
            dateFormatter.timeZone      = .current
            self.strDate                = dateFormatter.string(from: self.datePicker.date)

            self.viewModel.foodLogsListAPI(tblView: self.tblView,
                                           withLoader: withLoader,
                                           insight_date: self.strDate)
        }
    }
    
    func setData(){
        
        let time = GFunction.shared.convertDateFormate(dt: self.strDate,
                                                           inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           outputFormat: dateFormat,
                                                           status: .NOCONVERSION)
        self.txtTitleDate.text = time.0
        
        let value       = Float(self.object.totalCaloriesConsumed)
        let maxValue    = Float(self.object.goalValue) ?? 0
        
        if value < maxValue {
            let available = maxValue - value

            self.lblCaloriesValue.text = String(format: "%0.0f", available) + " " + AppMessages.available

        }
        else {
            self.lblCaloriesValue.text = AppMessages.completed
        }
        self.progressCalories.progressValue = GFunction.shared.getProgress(value: value,
                                                                           maxValue: maxValue)
        
        self.lblTotalIntakeValue.text = String(format: "%0.0f", value)
        self.tblView.reloadData()
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension FoodDiaryDayVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessageContentList
                self.object = self.viewModel.object
                self.setData()
                //self.vwBg.isHidden = false
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
