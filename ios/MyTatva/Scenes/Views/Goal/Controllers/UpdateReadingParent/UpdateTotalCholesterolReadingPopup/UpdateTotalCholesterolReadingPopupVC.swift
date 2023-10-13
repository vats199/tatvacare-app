//
//  PheromonePopupVC.swift
//

//

import UIKit

class UpdateTotalCholesterolReadingPopupVC: ClearNavigationFontBlackBaseVC {
    
    
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
    
    @IBOutlet weak var lblLDL           : UILabel!
    @IBOutlet weak var txtLDL           : UITextField!
    
    @IBOutlet weak var lblHDL           : UILabel!
    @IBOutlet weak var txtHDL           : UITextField!
    
    @IBOutlet weak var lblTriglyceride      : UILabel!
    @IBOutlet weak var txtTriglyceride      : UITextField!
    
    @IBOutlet weak var lblTotalCholesterol  : UILabel!
    @IBOutlet weak var txtTotalCholesterol  : UITextField!

    @IBOutlet weak var lblStandardVal   : UILabel!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancel        : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    
    @IBOutlet weak var vwHKConnect      : UIView!
    @IBOutlet weak var lblHKConnect     : UILabel!
    
    //MARK:- Class Variable
    let viewModel                       = UpdateTotalCholesterolReadingPopupVM()
    var readingType: ReadingType        = .HeartRate
    var readingListModel                = ReadingListModel()
    var isNext                          = false
    
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
        
        self.lblTitle.font(name: .bold, size: 18)
            .textColor(color: UIColor.themeBlack)
        
        self.lblDate.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblTime.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblLDL.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblHDL.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblTriglyceride.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblTotalCholesterol.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblStandardVal.font(name: .medium, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
        
        self.btnCancel.font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
            .borderColor(color: UIColor.themePurple, borderWidth: 1)
            .cornerRadius(cornerRadius: 7)
            .backGroundColor(color: UIColor.white)
        
        self.btnSubmit.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
      
        self.txtLDL.maxLength               = kMaximumLDL.size
        self.txtHDL.maxLength               = kMaximumHDL.size
        self.txtTriglyceride.maxLength      = kMaximumTriglyceride.size
        self.txtTotalCholesterol.maxLength  = kMaximumTriglyceride.size
        
        self.txtLDL.keyboardType            = .numberPad
        self.txtLDL.regex                   = Validations.RegexType.OnlyNumber.rawValue
        
        self.txtHDL.keyboardType            = .numberPad
        self.txtHDL.regex                   = Validations.RegexType.OnlyNumber.rawValue
        
        self.txtTriglyceride.keyboardType   = .numberPad
        self.txtTriglyceride.regex          = Validations.RegexType.OnlyNumber.rawValue
        
        self.txtTotalCholesterol.keyboardType   = .numberPad
        self.txtTotalCholesterol.regex          = Validations.RegexType.OnlyNumber.rawValue
        
        self.txtLDL.delegate = self
        self.txtLDL.isUserInteractionEnabled = true
        
        self.txtHDL.delegate = self
        self.txtHDL.isUserInteractionEnabled = true
        
        self.txtTriglyceride.delegate = self
        self.txtTriglyceride.isUserInteractionEnabled = true
        
        self.txtTotalCholesterol.delegate = self
        self.txtTotalCholesterol.isUserInteractionEnabled = true
        
        
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
    }
    
    fileprivate func configureUI(){
        DispatchQueue.main.async {
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
            self.viewModel.apiCall(vc: self,
                                   date: self.txtDate,
                                   time: self.txtTime,
                                   txtLDL: self.txtLDL,
                                   txtHDL: self.txtHDL,
                                   txtTriglyceride: self.txtTriglyceride,
                                   txtTotalCholesterol: self.txtTotalCholesterol,
                                   readingListModel: self.readingListModel)
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
extension UpdateTotalCholesterolReadingPopupVC {
    
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
        self.dateFormatter.locale           = NSLocale(localeIdentifier: "en_US") as Locale
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
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc fileprivate func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.datePicker:
            self.dateFormatter.dateFormat   = appDateFormat
            self.dateFormatter.timeZone     = .current
            self.txtDate.text               = self.dateFormatter.string(from: sender.date)
            
            self.timePicker.date            = self.datePicker.date
            //self.timePicker.minimumDate     = Calendar.current.date(byAdding: .minute, value: 0, to: Date())
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

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension UpdateTotalCholesterolReadingPopupVC : UITextFieldDelegate {
    
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
        
        default:
            break
        }
        
        return true
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension UpdateTotalCholesterolReadingPopupVC {
    
    fileprivate func setData(){
        WebengageManager.shared.navigateScreenEvent(screen: .LogReading, postFix: self.readingListModel.keys)
        
        self.vwImgTitle
            .backGroundColor(color: UIColor.hexStringToUIColor(hex: self.readingListModel.backgroundColor).withAlphaComponent(0.1))
        self.imgTitle.setCustomImage(with: self.readingListModel.imageUrl, renderingMode: .alwaysTemplate)
        self.imgTitle.tintColor         = UIColor.hexStringToUIColor(hex: self.readingListModel.colorCode)
        self.lblTitle.text              = self.readingListModel.readingName
        
        self.txtLDL.text                = self.readingListModel.readingValueData.ldl_cholesterol ?? "0"
        self.txtHDL.text                = self.readingListModel.readingValueData.hdl_cholesterol ?? "0"
        self.txtTriglyceride.text       = self.readingListModel.readingValueData.triglycerides ?? "0"
        self.txtTotalCholesterol.text   = String(format:"%0.f",self.readingListModel.readingValue)
        
        self.lblLDL.text                = AppMessages.kLDL +
        "(\(self.readingListModel.measurements!))"
        self.lblHDL.text                = AppMessages.kHDL +
        "(\(self.readingListModel.measurements!))"
        self.lblTriglyceride.text       = AppMessages.kTriglyceride +
        "(\(self.readingListModel.measurements!))"
        self.lblTotalCholesterol.text   = AppMessages.kTotalCholesterol +
        "(\(self.readingListModel.measurements!))"
        self.lblStandardVal.text        = self.readingListModel.defaultReading!
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension UpdateTotalCholesterolReadingPopupVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                
                var params = [String: Any]()
                params[AnalyticsParameters.reading_name.rawValue]   = self.readingListModel.readingName
                params[AnalyticsParameters.reading_id.rawValue]     = self.readingListModel.readingsMasterId
                
                FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATED_READING,
                                         screen: .LogReading,
                                         parameter: params)
                
//                let datetime = GFunction.shared.convertDateFormate(dt: self.txtDate.text! + self.txtTime.text!,
//                                                                   inputFormat: appDateFormat + appTimeFormat,
//                                                                   outputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
//                                                                   status: .NOCONVERSION)
//
//                HealthKitManager.shared.addLogToHealthKit(identifier: .bloodPressureSystolic,
//                                                          reading: Double(self.txtHDL.text!) ?? 0,
//                                                          unit: HKUnit.millimeterOfMercury(),
//                                                          dateTime: self.viewModel.achieved_datetime)
//
//                HealthKitManager.shared.addLogToHealthKit(identifier: .bloodPressureDiastolic,
//                                                          reading: Double(self.txtLDL.text!) ?? 0,
//                                                          unit: HKUnit.millimeterOfMercury(),
//                                                          dateTime: self.viewModel.achieved_datetime)
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

