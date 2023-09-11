
import UIKit

class UpdateStepsPopupVC: ClearNavigationFontBlackBaseVC {
    
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg                : UIImageView!
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var lblProgress          : UILabel!
    @IBOutlet weak var linearProgressBar    : LinearProgressBar!
    
    @IBOutlet weak var txtDate              : UITextField!
    
    @IBOutlet weak var txtTime              : UITextField!
    
    @IBOutlet weak var lblSteps             : UILabel!
    @IBOutlet weak var lblStepsValue        : UILabel!
    @IBOutlet weak var btnPlus              : UIButton!
    @IBOutlet weak var btnMinus             : UIButton!
    
    @IBOutlet weak var btnAdd               : UIButton!
    @IBOutlet weak var btnAddAndNext        : UIButton!
    @IBOutlet weak var btnCancelTop         : UIButton!
    @IBOutlet weak var btnEditGoal          : UIButton!
    
    @IBOutlet weak var vwHKConnect          : UIView!
    @IBOutlet weak var lblHKConnect         : UILabel!
    
    
    //MARK:- Class Variable
    let viewModel                       = UpdateStepsPopupVM()
    var readingType: ReadingType        = .HeartRate
    var goalListModel                   = GoalListModel()
    var myIndex : Int                   = 0
    var arrList                         = [GoalListModel]()
    var isNext                          = false
    var valueLog                        = kJumpValueSteps
    
    var datePicker                      = UIDatePicker()
    var timePicker                      = UIDatePicker()
    var dateFormatter                   = DateFormatter()
//    var dateFormat                      = DateTimeFormaterEnum.ddmm_yyyy.rawValue
//    var timeFormat                      = DateTimeFormaterEnum.hhmma.rawValue
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {
        
        self.lblTitle.font(name: .bold, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblProgress.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack)
        
        self.txtDate.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack)
        self.txtTime.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack)
        
        self.lblSteps.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblStepsValue.font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.btnEditGoal.font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
        
        self.btnAdd.font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
            .borderColor(color: UIColor.themePurple, borderWidth: 1)
            .cornerRadius(cornerRadius: 7)
            .backGroundColor(color: UIColor.white)
        
        self.btnAddAndNext.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
        
        GFunction.shared.setUpHealthKitConnectionLabel(vw: self.vwHKConnect, lbl: self.lblHKConnect){ [weak self] (isDone) in
            guard let _ = self else {return}
            if isDone {
            }
        }
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.btnAdd.layoutIfNeeded()
            self.btnAddAndNext.layoutIfNeeded()
            
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.btnAddAndNext
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnAdd
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.white)
            
            self.btnEditGoal.layoutIfNeeded()
            self.btnEditGoal
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.white)
            
        }
        
        self.vwBg.animateBounce()
        self.openPopUp()
        self.setData()
        self.configureUI()
        self.manageActionMethods()
        self.initDatePicker()
    }
    
    fileprivate func configureUI(){
        
    }
    
    func setProgress(progressBar: LinearProgressBar, color: UIColor){
        progressBar.trackColor          = UIColor.themeLightGray
        progressBar.trackPadding        = 0
        progressBar.capType             = 1
        
        switch progressBar {
        
        case self.linearProgressBar:
            progressBar.barThickness        = 10
            progressBar.barColor            = color
            
            progressBar.barColorForValue = { value in
                switch value {
                case 0..<20:
                    return color
                case 20..<60:
                    return color
                case 60..<80:
                    return color
                default:
                    return color
                }
            }
            
            break
       
        default: break
        }
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : JSON? = nil) {
        
        func sendData() {
            if let obj = objAtIndex {
                if let vc = self.parent?.parent as? UpdateGoalParentVC {
                    if let completionHandler = vc.completionHandler {
                        completionHandler(obj)
                    }
                }
            }
        }
        
        self.dismiss(animated: animated) {
            sendData()
        }
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
       
        self.imgBg.addTapGestureRecognizer {
            var obj         = JSON()
            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: obj)
        }
        
        self.btnCancelTop.addTapGestureRecognizer {
            //let obj         = JSON()
            var obj         = JSON()
            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: obj)
        }
        
        self.btnAdd.addTapGestureRecognizer {
            self.isNext = false
            self.viewModel.apiCall(vc: self,
                                   date: self.txtDate,
                                   time: self.txtTime,
                                   steps: self.lblStepsValue.text!,
                                   goalListModel: self.goalListModel)
        }
        
        self.btnAddAndNext.addTapGestureRecognizer {
            self.isNext = true
            self.viewModel.apiCall(vc: self,
                                   date: self.txtDate,
                                   time: self.txtTime,
                                   steps: self.lblStepsValue.text!,
                                   goalListModel: self.goalListModel)
        }
        
        //self.calculateLogValue()
        self.btnPlus.addTapGestureRecognizer {
            self.handleLog(sender: self.btnPlus)
        }
        self.btnMinus.addTapGestureRecognizer {
            self.handleLog(sender: self.btnMinus)
        }
        
        self.lblHKConnect.addTapGestureRecognizer {
            HealthKitManager.shared.checkHealthKitPermission { (isSync) in
                if isSync {
                    Alert.shared.showAlert(message: AppMessages.healthKitDisconnect, completion: nil)
                }
                else {
                    self.dismiss(animated: true) {
                        GFunction.shared.navigateToHealthConnect { obj in
                        }
                    }
                }
            }
        }
        
        self.btnEditGoal.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
            GFunction.shared.navigateToSetGoal()
        }
    }
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: -------------------- Date picker methods --------------------
extension UpdateStepsPopupVC {
    
    fileprivate func initDatePicker(){
       
        self.txtDate.inputView             = self.datePicker
        self.txtDate.delegate              = self
        self.datePicker.datePickerMode     = .date
        self.datePicker.maximumDate        =  Date()
        //self.datePicker.minimumDate        =  Calendar.current.date(byAdding: .month, value: -1, to: Date())
        self.datePicker.timeZone           = .current
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
        
        self.dateFormatter.dateFormat       = appDateFormat
        self.dateFormatter.timeZone         = .current
        self.txtDate.text                   = self.dateFormatter.string(from: self.datePicker.date)
        
        self.txtTime.inputView              = self.timePicker
        self.txtTime.delegate               = self
        
        self.timePicker.datePickerMode      = .time
        self.timePicker.maximumDate         = self.datePicker.maximumDate
        //self.timePicker.minimumDate          =  Calendar.current.date(byAdding: .minute, value: 0, to: self.datePicker.date)
        self.timePicker.timeZone             = .current
        self.timePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
        
        self.dateFormatter.dateFormat       = appTimeFormat
        self.dateFormatter.timeZone         = .current
        self.dateFormatter.locale           = NSLocale(localeIdentifier: "en_US") as Locale
        self.txtTime.text                   = self.dateFormatter.string(from: self.timePicker.date)
        
        if #available(iOS 14, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
            self.timePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.datePicker:
            self.dateFormatter.dateFormat   = appDateFormat
            self.dateFormatter.timeZone     = .current
            self.txtDate.text               = self.dateFormatter.string(from: sender.date)
            
            self.timePicker.date            = self.datePicker.date
            //self.timePicker.minimumDate     = Calendar.current.date(byAdding: .minute, value: 0, to: self.datePicker.date)
            self.txtTime.text               = ""
            break
            
        case self.timePicker:
            self.dateFormatter.dateFormat   = appTimeFormat
            self.dateFormatter.timeZone     = .current
            self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
            self.txtTime.text               = self.dateFormatter.string(from: sender.date)
            break
     
        default:break
        }
    }
    
}

//MARK: -------------------- Calculation methods --------------------
extension UpdateStepsPopupVC {
    
    fileprivate func handleLog(sender: UIButton){
        switch sender {
        case self.btnPlus:
            if self.valueLog < kMaximumStepsLog {
                self.valueLog += kJumpValueSteps
            }
            
            break
        case self.btnMinus:
            if self.valueLog > kJumpValueSteps {
                self.valueLog -= kJumpValueSteps
            }
            break
        default:break
        }
        
        self.calculateLogValue()
    }
    
    fileprivate func calculateLogValue(){
        self.lblStepsValue.text = String(format: "%.f", Float(self.valueLog))
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension UpdateStepsPopupVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtDate:
            
            if self.txtDate.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appDateFormat
                self.dateFormatter.timeZone     = .current
                self.txtDate.text               = self.dateFormatter.string(from: self.datePicker.date)
                
                self.timePicker.date            = self.datePicker.date
                //self.timePicker.minimumDate     = Calendar.current.date(byAdding: .minute, value: 0, to: self.datePicker.date)
                self.txtTime.text               = ""
            }
            break
            
        case self.txtTime:
            
            if self.txtTime.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appTimeFormat
                self.dateFormatter.timeZone     = .current
                self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
                self.txtTime.text               = self.dateFormatter.string(from: self.timePicker.date)
            }
            break
        
        default:
            break
        }
        
        return true
    }
}

//MARK: ------------------ setData Method ------------------
extension UpdateStepsPopupVC {
    
    fileprivate func setData(){
        WebengageManager.shared.navigateScreenEvent(screen: .LogGoal, postFix: self.goalListModel.keys)
        
        if self.myIndex == self.arrList.count - 1 {
            self.btnAddAndNext.isHidden = true
        }
        else {
            self.btnAddAndNext.isHidden = false
        }
        
        GFunction.shared.setGoalProgressData(goalListModel: self.goalListModel,
                                             lblProgress: self.lblProgress,
                                             linearProgressBar: self.linearProgressBar,
                                             lblDuration: self.lblStepsValue, valueLog: Float(self.valueLog))
        
        let value       = Float(goalListModel.achievedValue)
        if value > 0 {
            self.valueLog = Int(value)
        }
        
        self.imgTitle.image     = nil
        self.imgTitle.setCustomImage(with: self.goalListModel.imageUrl)
        self.lblTitle.text      = AppMessages.log + " " + self.goalListModel.goalName
        self.setProgress(progressBar: self.linearProgressBar, color: UIColor.hexStringToUIColor(hex: self.goalListModel.colorCode))
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension UpdateStepsPopupVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                var params              = [String : Any]()
                params[AnalyticsParameters.goal_name.rawValue]      = self.goalListModel.goalName
                params[AnalyticsParameters.goal_id.rawValue]        = self.goalListModel.goalMasterId
                params[AnalyticsParameters.goal_value.rawValue]    = self.goalListModel.goalValue
                FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATED_ACTIVITY,
                                         screen: .LogGoal,
                                         parameter: params)
                
                let datetime = GFunction.shared.convertDateFormate(dt: self.txtDate.text! + self.txtTime.text!,
                                                                   inputFormat: appDateFormat + appTimeFormat,
                                                                   outputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                                   status: .NOCONVERSION)
                
                HealthKitManager.shared.addLogToHealthKit(identifier: .stepCount,
                                                          reading: Double(self.lblStepsValue.text!) ?? 0,
                                                          unit: HKUnit.count(),
                                                          dateTime: self.viewModel.achieved_datetime)
                
                if self.isNext {
                    if let vc = self.parent?.parent as? UpdateGoalParentVC {
                        vc.goNext()
                        
                        var obj         = JSON()
                        obj["isDone"]   = true
                        if let completionHandler = vc.completionHandler {
                            completionHandler(obj)
                        }
                    }
                }
                else {
                    var obj         = JSON()
                    obj["isDone"]   = true
                    self.dismissPopUp(true, objAtIndex: obj)
                }
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

