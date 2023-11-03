//
//  UpdateSedentaryTimePopupVC.swift
//  MyTatva
//
//  Created by Hlink on 18/09/23.
//
class UpdateSedentaryTimePopupVC: ClearNavigationFontBlackBaseVC {


    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!

    @IBOutlet weak var vwImgTitle       : UIView!
    @IBOutlet weak var imgTitle         : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!

    @IBOutlet weak var lblDate          : UILabel!
    @IBOutlet weak var txtDate          : UITextField!

    @IBOutlet weak var lblTime          : UILabel!
    @IBOutlet weak var txtTime          : UITextField!

    @IBOutlet weak var lblSleepStartTime        :UILabel!
    @IBOutlet weak var txtSleepStartTime        :UITextField!

    @IBOutlet weak var lblSleepEndTime          :UILabel!
    @IBOutlet weak var txtSleepEndTime          :UITextField!

    @IBOutlet weak var lblPhysicalActivity      :UILabel!
    @IBOutlet weak var txtPhysicalActivity      :UITextField!

    @IBOutlet weak var lblActivityStartTime     :UILabel!
    @IBOutlet weak var txtActivityStartTime     :UITextField!

    @IBOutlet weak var lblPhysicalActivityDuration       :UILabel!
    @IBOutlet weak var lblDuration                       :UILabel!
    @IBOutlet weak var btnMinus                          :UIButton!
    @IBOutlet weak var btnPlus                           :UIButton!

    @IBOutlet weak var lblActivityEndTime       :UILabel!
    @IBOutlet weak var txtActivityEndTime       :UITextField!

    @IBOutlet weak var lblStandardVal   : UILabel!

    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancel        : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!

    @IBOutlet weak var vwHKConnect          : UIView!
    @IBOutlet weak var lblHKConnect         : UILabel!


    //MARK:- Class Variable
    let viewModel                       = UpdateSedentaryTimePopupVM()
    var readingType: ReadingType        = .HeartRate
    var readingListModel                = ReadingListModel()
    var exerciseModel                   = SelectExerciseVM()
    var isNext                          = false

    var datePicker                      = UIDatePicker()
    var timePicker                      = UIDatePicker()
    var pickerView                      = UIPickerView()

    var sleepStartTimePicker            = UIDatePicker()
    var sleepEndTimePicker              = UIDatePicker()
    var actitvityStartTimePicker        = UIDatePicker()
    var activityEndTimePicker           = UIDatePicker()

    var dateFormatter                   = DateFormatter()
    var valueLog                        = 5
    var maxDuration                     = kMaximumExerciseLog
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

        self.lblTitle.font(name: .bold, size: 18)
            .textColor(color: UIColor.themeBlack)

        self.lblDate.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblTime.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)

        self.lblSleepStartTime.font(name: .regular, size: 14).textColor(color: UIColor.themeBlack).text = "Sleep start date & time"
        self.lblSleepEndTime.font(name: .regular, size: 14).textColor(color: UIColor.themeBlack).text = "Sleep end date & time"
        self.lblActivityStartTime.font(name: .regular, size: 14).textColor(color: UIColor.themeBlack).text = "Physical activity start date & time"
        self.lblActivityEndTime.font(name: .regular, size: 14).textColor(color: UIColor.themeBlack).text = "Physical activity end date & time"
        self.lblPhysicalActivity.font(name: .regular, size: 14).textColor(color: UIColor.themeBlack).text = "Physical activity"
        self.lblPhysicalActivityDuration.font(name: .regular, size: 14).textColor(color: UIColor.themeBlack).text = "Physical activity duration (min)"

        [
            self.lblSleepStartTime,
            self.lblSleepEndTime,
            self.lblActivityStartTime,
            self.lblActivityEndTime,
            self.lblPhysicalActivity,
            self.lblPhysicalActivityDuration,
        ].forEach({$0?.text = $0?.text?.capitalized})

        [
            self.txtSleepStartTime,
            self.txtSleepEndTime,
            self.txtActivityStartTime,
            self.txtActivityEndTime,
            self.txtPhysicalActivity,
        ].forEach({$0.font(name: .medium, size: 14).textColor(color: UIColor.themeBlack)})

        self.txtPhysicalActivity.placeholder = "Select"
        self.txtPhysicalActivity.inputView = self.pickerView

        self.txtPhysicalActivity.delegate = self

        self.pickerView.delegate = self
        self.pickerView.dataSource = self

        self.lblStandardVal.font(name: .medium, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))

        self.btnCancel.font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
            .borderColor(color: UIColor.themePurple, borderWidth: 1)
            .cornerRadius(cornerRadius: 7)
            .backGroundColor(color: UIColor.white)

        self.lblDuration.font(name: .medium, size: 14).textColor(color: UIColor.themeBlack)
        self.calculateLogValue()

        self.btnSubmit.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)

        GFunction.shared.setUpHealthKitConnectionLabel(vw: self.vwHKConnect, lbl: self.lblHKConnect){ [weak self] (isDone) in
            guard let _ = self else {return}
            if isDone {
            }
        }

        self.vwBg.animateBounce()
        self.openPopUp()
        self.setData()
        self.configureUI()
        self.manageActionMethods()
        self.initDatePicker()
        self.setPickerView()
    }

    fileprivate func handleLog(sender: UIButton){
        if self.txtSleepStartTime.text?.trim() == "" || self.txtSleepEndTime.text?.trim() == "" {
            Alert.shared.showSnackBar(AppError.validation(type: .selectSleepStartEndDateTimeFirst).errorDescription ?? "")
        } else  {
            guard !((self.txtActivityStartTime.text ?? "").isEmpty) else {
                Alert.shared.showSnackBar(AppError.validation(type: .selectActivityStartDateTimeFirst).errorDescription ?? "")
                return }
            switch sender {
            case self.btnPlus:
                if self.valueLog < maxDuration {
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
    }

    fileprivate func calculateLogValue(){
        self.lblDuration.text = String(format: "%.f", Float(self.valueLog))
    }

    fileprivate func configureUI(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwBg.layoutIfNeeded()
            self.btnSubmit.layoutIfNeeded()
            self.btnCancel.layoutIfNeeded()

            self.vwBg.cornerRadius(cornerRadius: 10)
            self.btnSubmit
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)

            self.btnCancel
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.white)

            self.vwImgTitle.layoutIfNeeded()
            self.vwImgTitle.cornerRadius(cornerRadius: 5)
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
                if let vc = self.parent?.parent as? UpdateReadingParentVC {
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

    private func setPickerView() {

        //For start date time
        self.txtSleepStartTime.inputView         = self.sleepStartTimePicker
        self.sleepStartTimePicker.maximumDate    =  Date()
        self.txtSleepStartTime.delegate          = self
        self.sleepStartTimePicker.datePickerMode = .dateAndTime
        //self.startTimePicker.minimumDate    =  Calendar.current.date(byAdding: .minute, value: 0, to: Date())
        self.sleepStartTimePicker.timeZone       = .current
        self.sleepStartTimePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)

        //For end date time
        self.txtSleepEndTime.inputView         = self.sleepEndTimePicker
        self.txtSleepEndTime.delegate          = self
        self.sleepEndTimePicker.datePickerMode = .dateAndTime
        self.sleepEndTimePicker.minimumDate    =  Calendar.current.date(byAdding: .minute, value: 0, to: self.sleepStartTimePicker.date)
        self.sleepEndTimePicker.maximumDate    = Date()//Calendar.current.date(byAdding: .hour, value: 24, to: self.startTimePicker.date)
        self.sleepEndTimePicker.timeZone       = .current
        self.sleepEndTimePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)

        self.txtActivityStartTime.inputView      = self.actitvityStartTimePicker
        self.actitvityStartTimePicker.maximumDate =  Date()
        self.txtActivityStartTime.delegate          = self
        self.actitvityStartTimePicker.datePickerMode = .dateAndTime
        //self.startTimePicker.minimumDate    =  Calendar.current.date(byAdding: .minute, value: 0, to: Date())
        self.actitvityStartTimePicker.timeZone       = .current
        self.actitvityStartTimePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)

        //For end date time
        self.txtActivityEndTime.inputView         = self.activityEndTimePicker
        self.txtActivityEndTime.delegate          = self
        self.activityEndTimePicker.datePickerMode = .dateAndTime
        self.activityEndTimePicker.minimumDate    =  Calendar.current.date(byAdding: .minute, value: 0, to: self.sleepStartTimePicker.date)
        self.activityEndTimePicker.maximumDate    = Date()
        self.activityEndTimePicker.timeZone       = .current
        self.activityEndTimePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)

    }

    //MARK:- Action Method
    fileprivate func manageActionMethods(){

        self.imgBg.addTapGestureRecognizer {
            var obj         = JSON()
            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: obj)
        }

        self.btnCancel.addTapGestureRecognizer {
            //let obj         = JSON()
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

        self.btnSubmit.addTapGestureRecognizer {
            self.viewModel.apiCall(vc: self,/* date: self.txtDate.text!, time: self.txtTime.text!,*/ sleepStartTime: self.txtSleepStartTime.text!, sleepEndTime: self.txtSleepEndTime.text!,physicalActivity: self.txtPhysicalActivity.text!, activityStartTime: self.txtActivityStartTime.text!, duration: self.valueLog, readingListModel: self.readingListModel)
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

        self.btnPlus.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.handleLog(sender: self.btnPlus)
        }

        self.btnMinus.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.handleLog(sender: self.btnMinus)
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
        self.exerciseModel.stateListAPI(withLoader: false) { isDone in
            self.pickerView.reloadAllComponents()
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

//MARK: -------------------- Date picker methods --------------------
extension UpdateSedentaryTimePopupVC {

    fileprivate func initDatePicker(){

        //For date
        self.txtDate.inputView             = self.datePicker
        self.txtDate.delegate              = self
        self.datePicker.datePickerMode     = .date
        self.datePicker.maximumDate        =  Date()
        //self.datePicker.minimumDate        =  Calendar.current.date(byAdding: .minute, value: 0, to: Date())
        self.datePicker.timeZone           = .current
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)

        self.dateFormatter.dateFormat       = appDateFormat
        self.dateFormatter.timeZone         = .current
        self.txtDate.text                   = self.dateFormatter.string(from: self.datePicker.date)

        //For time
        self.txtTime.inputView              = self.timePicker
        self.txtTime.delegate               = self
        self.timePicker.datePickerMode      = .time
        self.timePicker.maximumDate         = self.datePicker.maximumDate
        //self.timePicker.minimumDate          =  Calendar.current.date(byAdding: .minute, value: 0, to: Date())
        self.timePicker.timeZone            = .current
        self.timePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)

        self.dateFormatter.dateFormat       = appTimeFormat
        self.dateFormatter.timeZone         = .current
        self.dateFormatter.locale           = NSLocale(localeIdentifier: "en_US") as Locale
        self.txtTime.text                   = self.dateFormatter.string(from: self.timePicker.date)

        if #available(iOS 14, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
            self.timePicker.preferredDatePickerStyle = .wheels
            self.sleepStartTimePicker.preferredDatePickerStyle = .wheels
            self.sleepEndTimePicker.preferredDatePickerStyle = .wheels
            self.actitvityStartTimePicker.preferredDatePickerStyle = .wheels
            self.activityEndTimePicker.preferredDatePickerStyle = .wheels

        } else {
            // Fallback on earlier versions
        }
    }

    private func setDateFormatter(_ dateFormatter:String = appDateTimeFormat,_ textField: UITextField,_ datePicker: UIDatePicker) {
        self.dateFormatter.dateFormat   = dateFormatter
        self.dateFormatter.timeZone     = .current
        self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
        textField.text                  = self.dateFormatter.string(from: datePicker.date)
    }

    @objc fileprivate func handleDatePicker(sender: UIDatePicker){

        let calendar = Calendar.current

        switch sender {
        case self.datePicker:
            self.setDateFormatter(appDateFormat, self.txtDate, sender)

            self.timePicker.date            = self.datePicker.date
            //self.timePicker.minimumDate     = Calendar.current.date(byAdding: .minute, value: 0, to: Date())
            self.txtTime.text               = ""
            break

        case self.timePicker:
            self.setDateFormatter(appTimeFormat, self.txtTime, sender)
            break

        case self.sleepStartTimePicker:
            self.setDateFormatter(appDateTimeFormat, self.txtSleepStartTime, sender)

            self.sleepEndTimePicker.minimumDate  = Calendar.current.date(byAdding: .minute, value: 1, to: self.sleepStartTimePicker.date) //calendar.date(byAdding: .minute, value: 0, to: self.sleepStartTimePicker.date)
            
            let nextDate = calendar.date(byAdding: .hour, value: 24, to: self.sleepStartTimePicker.date)
            if nextDate?.compare(Date()) == .orderedAscending {
                self.sleepEndTimePicker.maximumDate = nextDate
            }
            else {
                self.sleepEndTimePicker.maximumDate  = Date()
            }

            self.txtSleepEndTime.text            = ""
            self.txtActivityStartTime.text       = ""
            self.txtActivityEndTime.text         = ""
            break
        case self.sleepEndTimePicker:
            self.setDateFormatter(appDateTimeFormat, self.txtSleepEndTime, sender)

            let formatter = DateFormatter()
            formatter.dateFormat = DateTimeFormaterEnum.ddMMyyyy.rawValue
            let tempDate = formatter.string(from: self.sleepEndTimePicker.date) + " 12:00:AM"

            self.actitvityStartTimePicker.minimumDate = formatter.date(from: formatter.string(from: self.sleepEndTimePicker.date)) ?? Date() //calendar.date(byAdding: .minute, value: 0, to: self.sleepEndTimePicker.date)
            
            let nextDate = calendar.date(byAdding: .hour, value: 23 - ((Calendar.current.component(.hour, from: self.sleepEndTimePicker.date))), to: self.sleepEndTimePicker.date)
//            self.actitvityStartTimePicker.maximumDate = nextDate?.compare(Date()) == .orderedAscending ? calendar.date(byAdding: .minute, value: -(1/*+calendar.component(.minute, from: nextDate ?? Date())*/), to: nextDate ?? Date()) : Date()
            self.actitvityStartTimePicker.maximumDate = calendar.date(byAdding: .minute, value: -(calendar.component(.minute, from: nextDate ?? Date()) - 50), to: nextDate ?? Date())// nextDate?.compare(Date()) == .orderedAscending ? calendar.date(byAdding: .minute, value: -(calendar.component(.minute, from: nextDate ?? Date()) - 50), to: nextDate ?? Date()) : calendar.date(byAdding: .day, value: 1, to: formatter.date(from: formatter.string(from: self.sleepEndTimePicker.date)) ?? Date()) //Date()
            self.activityEndTimePicker.maximumDate = self.actitvityStartTimePicker.maximumDate

            self.txtActivityStartTime.text       = ""
            self.txtActivityEndTime.text         = ""

            break
        case self.actitvityStartTimePicker:
            self.setDateFormatter(appDateTimeFormat, self.txtActivityStartTime, sender)

            self.activityEndTimePicker.minimumDate = calendar.date(byAdding: .minute, value: 0, to: self.actitvityStartTimePicker.date)

            self.maxDuration = calendar.isDateInToday(sender.date) ? ((calendar.dateComponents([.minute], from: self.actitvityStartTimePicker.date, to: calendar.date(bySettingHour: 0, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 1, to: self.actitvityStartTimePicker.date) ?? Date()) ?? Date()).minute ?? 5) - 5) : 1435
//            self.maxDuration = self.maxDuration >= kMaximumExerciseLog ? kMaximumExerciseLog : self.maxDuration
            self.valueLog = 5
            self.txtActivityEndTime.text         = ""
            self.calculateLogValue()

            break
        case self.activityEndTimePicker:
            self.setDateFormatter(appDateTimeFormat, self.txtActivityEndTime, sender)
            break

        default:break
        }
    }

}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension UpdateSedentaryTimePopupVC : UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtDate:

            if self.txtDate.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appDateFormat
                self.dateFormatter.timeZone     = .current
                self.txtDate.text               = self.dateFormatter.string(from: self.datePicker.date)

                self.timePicker.date            = self.datePicker.date
                //self.timePicker.minimumDate     = Calendar.current.date(byAdding: .day, value: 0, to: Date())
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

        case self.txtSleepStartTime:

            self.sleepStartTimePicker.reloadInputViews()

            if self.txtSleepStartTime.text?.trim() == "" {
                self.handleDatePicker(sender: self.sleepStartTimePicker)
                /*self.dateFormatter.dateFormat   = appDateTimeFormat
                self.dateFormatter.timeZone     = .current
                self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
                self.txtSleepStartTime.text          = self.dateFormatter.string(from: self.timePicker.date)
                
                self.sleepEndTimePicker.minimumDate  =  Calendar.current.date(byAdding: .minute, value: 0, to: self.sleepStartTimePicker.date)
                self.txtSleepEndTime.text            = ""
                self.txtActivityStartTime.text       = ""
                self.txtActivityEndTime.text         = ""*/

            }
            break

        case self.txtSleepEndTime:

            self.sleepEndTimePicker.reloadInputViews()
            if self.txtSleepStartTime.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .selectSleepStartDateTimeFirst).errorDescription ?? "")
                return false
            }
            else {
                if self.txtSleepEndTime.text?.trim() == "" {
                    self.dateFormatter.dateFormat   = appDateTimeFormat
                    self.dateFormatter.timeZone     = .current
                    self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
                    self.txtSleepEndTime.text            = self.dateFormatter.string(from: self.sleepEndTimePicker.minimumDate ?? Date())
                }
            }

        case self.txtActivityStartTime:
            self.actitvityStartTimePicker.reloadInputViews()
            if self.txtSleepStartTime.text?.trim() == "" || self.txtSleepEndTime.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .selectSleepStartEndDateTimeFirst).errorDescription ?? "")
                return false
            } else if self.txtPhysicalActivity.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .selectPhysicalActivity).errorDescription ?? "")
                return false
            }
            else if textField.text?.trim() == "" {
                self.handleDatePicker(sender: self.actitvityStartTimePicker)
            }

            break

        case self.txtActivityEndTime:
            self.activityEndTimePicker.reloadInputViews()
            if self.txtSleepStartTime.text?.trim() == "" || self.txtSleepEndTime.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .selectSleepStartEndDateTimeFirst).errorDescription ?? "")
                return false
            }else if txtActivityStartTime.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .selectActivityStartDateTimeFirst).errorDescription ?? "")
                return false
            }else if textField.text?.trim() == "" {
                self.handleDatePicker(sender: self.activityEndTimePicker)
            }
            break

        case self.txtPhysicalActivity:
            if self.txtSleepStartTime.text?.trim() == "" || self.txtSleepEndTime.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .selectSleepStartEndDateTimeFirst).errorDescription ?? "")
                return false
            }else if self.txtPhysicalActivity.text?.trim() == "" {
                self.txtPhysicalActivity.text = self.exerciseModel.arrList.first?.exerciseName ?? ""
            }
            break
        default:
            break
        }

        return true
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension UpdateSedentaryTimePopupVC {

    fileprivate func setData(){
        WebengageManager.shared.navigateScreenEvent(screen: .LogReading, postFix: self.readingListModel.keys)

        self.vwImgTitle
            .backGroundColor(color: UIColor.hexStringToUIColor(hex: self.readingListModel.backgroundColor).withAlphaComponent(0.1))
        self.imgTitle.image         = nil
        self.imgTitle.setCustomImage(with: self.readingListModel.imageUrl, renderingMode: .alwaysTemplate)
        self.imgTitle.tintColor     = UIColor.hexStringToUIColor(hex: self.readingListModel.colorCode)
        self.lblTitle.text          = self.readingListModel.readingName


        self.lblStandardVal.text    = self.readingListModel.defaultReading!
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension UpdateSedentaryTimePopupVC {

    fileprivate func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                
                HealthKitManager.shared.addSleepToHealthKit(.asleep, startDate: self.viewModel.startTime, endDate: self.viewModel.endTime)

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
//MARK: - UIPickerViewDelegate&Datasource
extension UpdateSedentaryTimePopupVC: UIPickerViewDelegate,UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.exerciseModel.arrList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.exerciseModel.arrList[row].exerciseName
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtPhysicalActivity.text = self.exerciseModel.arrList[row].exerciseName
    }

}
