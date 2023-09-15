//
//  PheromonePopupVC.swift
//

//

import UIKit

class UpdateExercisePopupVC: ClearNavigationFontBlackBaseVC {
    
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg                : UIImageView!
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var lblProgress          : UILabel!
    @IBOutlet weak var linearProgressBar    : LinearProgressBar!
    
    @IBOutlet weak var txtDate              : UITextField!
    
    @IBOutlet weak var txtTime              : UITextField!
    
    @IBOutlet weak var vwSelectExercise     : UIStackView!
    @IBOutlet weak var lblSelectExercise    : UILabel!
    @IBOutlet weak var txtSelectExercise    : UITextField!
    
    @IBOutlet weak var vwExerciseDuration   : UIStackView!
    @IBOutlet weak var lblExerciseDuration  : UILabel!
    @IBOutlet weak var lblExerciseDurationValue  : UILabel!
    @IBOutlet weak var btnPlus              : UIButton!
    @IBOutlet weak var btnMinus             : UIButton!
    
    @IBOutlet weak var btnAdd               : UIButton!
    @IBOutlet weak var btnAddAndNext        : UIButton!
    @IBOutlet weak var btnCancelTop         : UIButton!
    @IBOutlet weak var btnEditGoal          : UIButton!
    
    @IBOutlet weak var vwHKConnect          : UIView!
    @IBOutlet weak var lblHKConnect         : UILabel!
        
    @IBOutlet weak var vwRoutineList        : UIView!
    @IBOutlet weak var tblRoutineList       : UITableView!
    
    @IBOutlet weak var constRoutinetblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnAddotherExercise  : UIButton!
    
    
    //MARK:- Class Variable
    let viewModel                       = UpdateExercisePopupVM()
    var readingType: ReadingType        = .HeartRate
    var goalListModel                   = GoalListModel()
    var myIndex : Int                   = 0
    var arrList                         = [GoalListModel]()
    
    var datePicker                      = UIDatePicker()
    var timePicker                      = UIDatePicker()
    var dateFormatter                   = DateFormatter()
    var selectedExerciseListModel       = ExerciseListModel()
    var isNext                          = false
    var valueLog                        = kJumpValueExercise
//    var dateFormat                      = DateTimeFormaterEnum.ddmm_yyyy.rawValue
//    var timeFormat                      = DateTimeFormaterEnum.hhmma.rawValue
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    var exerciseVM = ExerciseRoutineVM()
    
    var isRestDay = true
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
        self.removeObserverOnHeightTbl()
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {
        
        [self.vwSelectExercise,self.vwRoutineList,self.vwExerciseDuration].forEach({$0?.isHidden = true })
        
        self.tblRoutineList.delegate = self
        self.tblRoutineList.dataSource = self
        
        self.tblRoutineList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.btnAddotherExercise.font(name: .medium, size: 11.0).textColor(color: .themePurple).setTitle("Performed a different exercise ? Log here", for: UIControl.State())
        
        self.lblTitle.font(name: .bold, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblProgress.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack)
        
        self.txtDate.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack)
        self.txtTime.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack)
        
        self.lblSelectExercise.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblExerciseDuration.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblExerciseDurationValue.font(name: .medium, size: 14)
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
        
        self.txtSelectExercise.setRightImage(img: UIImage(named: "IconDownArrow"))
        self.txtSelectExercise.delegate = self
        
        GFunction.shared.setUpHealthKitConnectionLabel(vw: self.vwHKConnect, lbl: self.lblHKConnect){ [weak self] (isDone) in
            guard let _ = self else {return}
            if isDone {
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
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
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
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
        
        self.dismiss(animated: animated) { [weak self] in
            guard let _ = self else { return }
            sendData()
        }
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblRoutineList else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    private func showRoutineDifficultPopUp(_ indexPath: IndexPath) {
        let obj = self.exerciseVM.listOfRowsInExercise(indexPath)
        let difficulty = obj.difficultyLevel ?? ""
        let vc = RoutineMarkDoneVC.instantiate(fromAppStoryboard: .exercise)
        vc.headerTitle = obj.title
        vc.tempSelectedIndex = difficulty.isEmpty || difficulty == AppMessages.difficult ? 0 : 1
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.completion = { [weak self] difficulty in
            guard let self = self else { return }
            self.exerciseVM.addDifficulty(indexPath: indexPath, difficulty: difficulty)
        }
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblRoutineList && keyPath == "contentSize", let size = change?[.newKey] as? CGSize {
                let halfHeight = (ScreenSize.height/2) - 100
                self.constRoutinetblHeight.constant = size.height > halfHeight ? halfHeight : size.height
                self.tblRoutineList.isScrollEnabled = size.height > halfHeight
            }
        }
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        
        self.imgBg.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            var obj         = JSON()
            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: obj)
        }
        
        self.btnCancelTop.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            //let obj         = JSON()
            var obj         = JSON()
            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: obj)
        }
        
        self.btnAdd.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.isNext = false
            guard self.vwRoutineList.isHidden else {
                self.viewModel.vmResult.value = .success(nil)
                return
            }
            self.viewModel.apiCall(vc: self, date: self.txtDate,
                                   time: self.txtTime,
                                   exercise: self.txtSelectExercise,
                                   exercise_duration: self.lblExerciseDurationValue.text!,
                                   exerciseListModel: self.selectedExerciseListModel,
                                   goalListModel: self.goalListModel)
        }
        
        self.btnAddAndNext.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.isNext = true
            guard self.vwRoutineList.isHidden else {
                self.viewModel.vmResult.value = .success(nil)
                return
            }
            self.viewModel.apiCall(vc: self, date: self.txtDate,
                                   time: self.txtTime,
                                   exercise: self.txtSelectExercise,
                                   exercise_duration: self.lblExerciseDurationValue.text!,
                                   exerciseListModel: self.selectedExerciseListModel,
                                   goalListModel: self.goalListModel)
        }
        
        //self.calculateLogValue()
        self.btnPlus.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.handleLog(sender: self.btnPlus)
        }
        self.btnMinus.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.handleLog(sender: self.btnMinus)
        }
        
        self.lblHKConnect.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            HealthKitManager.shared.checkHealthKitPermission { [weak self] (isSync) in
                guard let self = self else { return }
                if isSync {
                    Alert.shared.showAlert(message: AppMessages.healthKitDisconnect, completion: nil)
                }
                else {
                    self.dismiss(animated: true) { [weak self] in
                        guard let self = self else { return }
                        GFunction.shared.navigateToHealthConnect { [weak self] obj in
                            guard let _ = self else { return }
                        }
                    }
                }
            }
        }
        
        self.btnEditGoal.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.dismissPopUp(true, objAtIndex: nil)
            GFunction.shared.navigateToSetGoal()
        }
        
        self.btnAddotherExercise.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.vwRoutineList.isHidden = true
            self.btnAddotherExercise.isHidden = true
            self.vwExerciseDuration.isHidden = false
            self.vwSelectExercise.isHidden = false
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
        self.exerciseVM.getRoutines(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: -------------------- Date picker methods --------------------
extension UpdateExercisePopupVC {
    
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
        self.timePicker.timeZone            = .current
        self.timePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
        self.txtDate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.dateChange(_:)))
        
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
    
    @objc
    func dateChange(_ sender: UIDatePicker) {
        self.dateFormatter.dateFormat   = appDateFormat
        self.dateFormatter.timeZone     = .current
        self.txtDate.text               = self.dateFormatter.string(from: self.datePicker.date)
                
        self.exerciseVM.getRoutines(true, planDate: self.datePicker.date)
        
        /*GlobalAPI.shared.getRoutines(planDate:self.datePicker.date) { [weak self] (message,data,statusCode) in
            guard let self = self else { return }
            switch statusCode {
            case .success:
                guard let data = data else { return }
                let isRestDay = data["is_rest_day"].boolValue
                
                guard isRestDay else {
                    let vc = RoutineExercisePopupVC.instantiate(fromAppStoryboard: .goal)
                    vc.viewModel.arrExersice = data["exercise_details"].arrayValue.map({ ExerciseDataModel(fromJson: $0) })
                    vc.goalListModel = self.goalListModel
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.performOtherExersice = { [weak self] isDone in
                        guard let self = self,isDone else { return }
                        self.view.alpha = 1
                    }
                    UIApplication.topViewController()?.present(vc, animated: true)
                    return
                }
                self.view.alpha = 0
                break
            case .emptyData: break
            default: break
            }
        }*/
        
        self.timePicker.date            = self.datePicker.date
        //self.timePicker.minimumDate     = Calendar.current.date(byAdding: .minute, value: 0, to: self.datePicker.date)
        self.txtTime.text               = ""
    }
    
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension UpdateExercisePopupVC : UITextFieldDelegate {
    
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
            
        case self.txtSelectExercise:
            self.view.endEditing(true)
            let vc = SelectExerciseVC.instantiate(fromAppStoryboard: .goal)
            vc.completionHandler = { [weak self] obj in
                guard let self = self else { return }
                //Do your task here
                if obj != nil {
                    self.selectedExerciseListModel     = obj!
                    self.txtSelectExercise.text              = self.selectedExerciseListModel.exerciseName
                }
            }
            
            let nav: UINavigationController = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            //nav.modalTransitionStyle = .crossDissolve
            UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
            
            return false
        
        default:
            break
        }
        
        return true
    }
}

//MARK: -------------------- Calculation methods --------------------
extension UpdateExercisePopupVC {
    
    fileprivate func handleLog(sender: UIButton){
        switch sender {
        case self.btnPlus:
            if self.valueLog < kMaximumExerciseLog {
                self.valueLog += kJumpValueExercise
            }
            
            break
        case self.btnMinus:
            if self.valueLog > kJumpValueExercise {
                self.valueLog -= kJumpValueExercise
            }
            break
        default:break
        }
        
        self.calculateLogValue()
    }
    
    fileprivate func calculateLogValue(){
        self.lblExerciseDurationValue.text = String(format: "%.f", Float(self.valueLog))
    }
}

//MARK: ------------------ setData Method ------------------
extension UpdateExercisePopupVC {
    
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
                                             lblDuration: self.lblExerciseDurationValue, valueLog: Float(self.valueLog))
        
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
extension UpdateExercisePopupVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.exerciseVM.isRoutineChanged.bind { [weak self] isDone in
            guard let self = self else { return }
            guard (isDone ?? false) else {
                self.vwSelectExercise.isHidden = false
                self.vwExerciseDuration.isHidden = false
                self.vwRoutineList.isHidden = true
                self.btnAddotherExercise.isHidden = true
                return
            }
            self.tblRoutineList.reloadData()
            self.btnAddotherExercise.isHidden = false
            self.vwSelectExercise.isHidden = true
            self.vwExerciseDuration.isHidden = true
            self.vwRoutineList.isHidden = false
            
        }
        
        self.viewModel.vmResult.bind(observer: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                // Redirect to next screen
                if self.vwRoutineList.isHidden {
                    var params              = [String : Any]()
                    params[AnalyticsParameters.goal_name.rawValue]  = self.goalListModel.goalName
                    params[AnalyticsParameters.goal_id.rawValue]    = self.goalListModel.goalMasterId
                    params[AnalyticsParameters.goal_value.rawValue]    = self.goalListModel.goalValue
                    FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATED_ACTIVITY,
                                             screen: .LogGoal,
                                             parameter: params)
                }
                
//                HealthKitManager.shared.addLogToHealthKit(identifier: .stepCount,
//                                                          reading: Double(self.lblStepsValue.text!) ?? 0,
//                                                          unit: HKUnit.count())
                
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

//------------------------------------------------------
//MARK: - UITableViewDelegate,Datasource
extension UpdateExercisePopupVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.exerciseVM.numberOfSectionInExercise()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exerciseVM.numberOfRowsInExercise(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RoutineExerciseCell.self)
        let obj = self.exerciseVM.listOfRowsInExercise(indexPath)
        cell.lblExerciseName.text = obj.title
        cell.lblMins.text = JSON(obj.timeDuration as Any).stringValue + " " + obj.durationUnit
        cell.btnStatus.isSelected = obj.isDone
        cell.btnStatus.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            guard !self.txtTime.text!.isEmpty else {
                Alert.shared.showSnackBar(AppError.validation(type: .selectTime).localizedDescription)
                return
            }
            self.exerciseVM.markDoneRoutine(indexPath,time: self.timePicker.date) { [weak self] (isDone,data) in
                guard let self = self, isDone else { return }
                if self.exerciseVM.listOfRowsInExercise(indexPath).isDone {
                    self.showRoutineDifficultPopUp(indexPath)
                }
                let tempFormatter = DateFormatter()
                tempFormatter.dateFormat = DateTimeFormaterEnum.yyyymmdd.rawValue
                if (GFunction.shared.convertDateFormat(dt: data["achieved_datetime"].stringValue, inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue, outputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue, status: .NOCONVERSION).str == tempFormatter.string(from: Date())) {
                    print("Today")
                    let goalListModel = GoalListModel(fromJson: data)
                    self.goalListModel.todaysAchievedValue = goalListModel.todaysAchievedValue
                    self.goalListModel.goalValue = goalListModel.goalValue
                    GFunction.shared.setGoalProgressData(goalListModel: self.goalListModel,
                                                         lblProgress: self.lblProgress,
                                                         linearProgressBar: self.linearProgressBar,
                                                         lblDuration: self.lblExerciseDurationValue, valueLog: Float(self.valueLog))
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 15, height: 40))
        lbl.font(name: .medium, size: 13.0)
        lbl.text = self.exerciseVM.listOfSectionInExercise(section).title
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
