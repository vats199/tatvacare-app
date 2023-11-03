//
//  PheromonePopupVC.swift
//

//

import UIKit

class UpdateCommonReadingPopupVC: ClearNavigationFontBlackBaseVC {
    
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
    
    @IBOutlet weak var lblReading       : UILabel!
    @IBOutlet weak var txtReading       : UITextField!
    
    @IBOutlet weak var vwUnit           : UIView!
    @IBOutlet weak var txtUnit          : UITextField!
    @IBOutlet weak var txtUnitWidth     : NSLayoutConstraint!
    
    @IBOutlet weak var lblStandardVal   : UILabel!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancel        : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    
    @IBOutlet weak var vwHKConnect      : UIView!
    @IBOutlet weak var lblHKConnect     : UILabel!
    
    
    //MARK:- Class Variable
    let viewModel                       = UpdateReadingPopupVM()
    var readingType: ReadingType        = .HeartRate
    var readingListModel                = ReadingListModel()
    var isNext                          = false
    
    var datePicker                      = UIDatePicker()
    var timePicker                      = UIDatePicker()
    var dateFormatter                   = DateFormatter()
    let pickerWeight                    = UIPickerView()
    let pickerFattyLiver                = UIPickerView()
    var selectedFattyLiverGrade         = JSON()
//    var dateFormat                      = DateTimeFormaterEnum.ddmm_yyyy.rawValue
//    var timeFormat                      = DateTimeFormaterEnum.hhmma.rawValue
    
    fileprivate var arrWeightUnit : [UnitData] = []
    fileprivate var arrFattyLiverGrade : [JSON] = []
    
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
        self.lblReading.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblStandardVal.font(name: .medium, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
        
        self.txtUnit.font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .backGroundColor(color: .clear)
    
        self.btnCancel.font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
            .borderColor(color: UIColor.themePurple, borderWidth: 1)
            .cornerRadius(cornerRadius: 7)
            .backGroundColor(color: UIColor.white)
        
        self.btnSubmit.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
        
        self.txtUnit.textAlignment = .center
        
        GFunction.shared.setUpHealthKitConnectionLabel(vw: self.vwHKConnect, lbl: self.lblHKConnect){ [weak self] (isDone) in
            guard let _ = self else {return}
            if isDone {
            }
        }
        
        
        self.vwBg.animateBounce()
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
        self.initDatePicker()
        self.arrFattyLiverGrade = GFunction.shared.setArrFattyLiver()
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
            
            self.vwUnit.layoutIfNeeded()
            self.vwUnit
                .borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
                .cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themeLightGray)
            
        }
    }
    
    private func initWeightPicker(){
        self.pickerWeight.delegate              = self
        self.pickerWeight.dataSource            = self
        self.txtUnit.delegate                   = self
        self.txtUnit.inputView                  = self.pickerWeight
        self.txtUnit.isUserInteractionEnabled   = true
    }
    
    private func initFattyLiverPicker(){
        self.pickerFattyLiver.delegate              = self
        self.pickerFattyLiver.dataSource            = self
        self.txtReading.delegate                    = self
        self.txtReading.inputView                   = self.pickerFattyLiver
        self.txtReading.isUserInteractionEnabled    = true
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
            var readingValue = self.txtReading.text!
            if self.readingType == .fatty_liver_ugs_grade {
                readingValue = self.selectedFattyLiverGrade["value"].stringValue
            }
            
            let result = GFunction.shared.getFinalHeightWeight(heightUnit: "",
                                                               weightUnit: GFunction.shared.getUnit(from: self.arrWeightUnit),
                                                               heightCm: "",
                                                               heightFt: "",
                                                               heightIn: "",
                                                               weight: readingValue,
                                                               goalWeight: "")
            
            self.viewModel.apiCall(vc: self,
                                   date: self.txtDate,
                                   time: self.txtTime,
                                   reading: readingValue,
                                   weightKg: result.weight,
                                   weightLbs: self.txtReading.text!,
                                   unit: self.txtUnit,
                                   weightUnit: GFunction.shared.getUnit(from: self.arrWeightUnit),
                                   readingType: self.readingType,
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
        self.setData()
        self.txtReading.delegate                    = self
        self.txtReading.isUserInteractionEnabled    = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: -------------------- Date picker methods --------------------
extension UpdateCommonReadingPopupVC {
    
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
extension UpdateCommonReadingPopupVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
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
            
        case self.txtReading:
            if self.txtReading.text?.trim() == "" {
                
                if self.readingType == .fatty_liver_ugs_grade {
                    let obj = self.arrFattyLiverGrade[0]
                    self.selectedFattyLiverGrade = obj
                    self.txtReading.text = obj["name"].stringValue
                }
            }
            break
        default:
            break
        }
        return true
    }
}

//MARK: --------------------- UIPickerVIew Method ---------------------
extension UpdateCommonReadingPopupVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerWeight:
            return self.arrWeightUnit.count
            
        case self.pickerFattyLiver:
            return self.arrFattyLiverGrade.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerWeight:
            return self.arrWeightUnit[row].unitTitle
        case self.pickerFattyLiver:
            return self.arrFattyLiverGrade[row]["name"].stringValue
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pickerWeight:
            let obj = self.arrWeightUnit[row]
            self.arrWeightUnit = self.arrWeightUnit.map({ data in
                data.isSelected = false
                if data.unitKey == obj.unitKey {
                    data.isSelected = true
                }
                return data
            })
            
            if self.txtUnit.text != obj.unitTitle {
                self.txtUnit.text = obj.unitTitle
                self.calculateWeightValue(isAllowChange: true)
            }
//            for i in 0...self.arrWeightUnit.count - 1 {
//                var item = self.arrWeightUnit[i]
//                item["is_select"] = 0
//                if self.arrWeightUnit[i]["key"].stringValue == obj["key"].stringValue {
//                    item["is_select"] = 1
//                }
//                self.arrWeightUnit[i] = item
//            }
//            if self.txtUnit.text != obj["name"].stringValue {
//                self.txtUnit.text = obj["name"].stringValue
//                self.calculateWeightValue()
//            }
            break
        case self.pickerFattyLiver:
            let obj = self.arrFattyLiverGrade[row]
            self.selectedFattyLiverGrade    = obj
            self.txtReading.text            = obj["name"].stringValue
            break
        default: break
        }
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension UpdateCommonReadingPopupVC {
    
    fileprivate func setData(){
        WebengageManager.shared.navigateScreenEvent(screen: .LogReading, postFix: self.readingListModel.keys)
        
        self.imgTitle.image         = nil
        self.vwImgTitle
            .backGroundColor(color: UIColor.hexStringToUIColor(hex: self.readingListModel.backgroundColor).withAlphaComponent(0.1))
        self.imgTitle.setCustomImage(with: self.readingListModel.imageUrl, renderingMode: .alwaysTemplate)
        self.imgTitle.tintColor     = UIColor.hexStringToUIColor(hex: self.readingListModel.colorCode)
        self.lblTitle.text          = self.readingListModel.readingName
        self.txtUnit.text           = self.readingListModel.measurements
        self.txtUnit.isUserInteractionEnabled = false
        
        //if self.readingListModel.readingValue > 0 {
        self.txtReading.keyboardType    = .numberPad
        self.txtReading.regex           = Validations.RegexType.OnlyNumber.rawValue
        let floorReadingValue: String = "\(floor(self.readingListModel.readingValue ?? 0))"
        self.txtReading.text            = String(format: "%0.f", JSON(floorReadingValue).doubleValue)
        self.lblStandardVal.text        = self.readingListModel.defaultReading!
        //}
        
        switch self.readingType {
        
        case .SPO2:
            //Max value allowed is 100
            self.txtReading.maxLength   = kMaxSPO2.size
            break
            
        case .BloodPressure:
            //not needed here
            break
            
        case .BodyWeight:
            //Max value allowed is 300
            self.txtReading.text            = String(format: "%0.1f", self.readingListModel.readingValue)
            self.txtReading.keyboardType    = .decimalPad
//            self.txtReading.maxLength       = kMaxBodyWeightKg.size + 2
            self.txtReading.regex           = "".decimalRegex(maxLength: Int(kMaxBodyWeightKg.size + 2), decimalLength: 1)
            self.initWeightPicker()
            
            self.arrWeightUnit.removeAll()
            
            if UserModel.shared.unitData != nil  {
                for data in UserModel.shared.unitData {
                    if let _ = WeightUnit.init(rawValue: data.unitKey) {
                        self.arrWeightUnit.append(data)
                    }
                }
            }
            
            self.arrWeightUnit = self.arrWeightUnit.map({ data in
                var appWeightUnit = ""
                if UserModel.shared.weightUnit.trim() != "" {
                    appWeightUnit = UserModel.shared.weightUnit
                }
                else {
                    appWeightUnit = WeightUnit.kg.rawValue
                }
                
                data.isSelected = false
                if data.unitKey == appWeightUnit {
                    data.isSelected = true
                    self.txtUnit.text = data.unitTitle
                }
                return data
            })
            
            ///Set default picker values
//            for i in 0...self.arrHeightUnit.count - 1 {
//                if self.arrHeightUnit[i].isSelected {
//                    self.pickerHeight.selectRow(i, inComponent: 0, animated: true)
//                }
//            }
            for i in 0...self.arrWeightUnit.count - 1 {
                if self.arrWeightUnit[i].isSelected {
                    self.pickerWeight.selectRow(i, inComponent: 0, animated: true)
                }
            }
            
            self.calculateWeightValue(isAllowChange: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.vwUnit
                    .backGroundColor(color: UIColor.white)
                self.txtUnit.setRightImage(img: UIImage(named: "IconDownArrow"))
            }
            break
            
        case .HeartRate:
            //Max value allowed is 200
            self.txtReading.maxLength   = kMaxHeartRate.size
            
            break
      
        case .FEV1Lung:
            //Max value allowed is 10
            self.txtReading.text            = String(format: "%0.2f", self.readingListModel.readingValue)
            self.txtReading.keyboardType    = .decimalPad
            self.txtReading.regex           = "".decimalRegex(maxLength: Int(kMaxFEV1Lung.size + 3), decimalLength: 2)
//            self.txtReading.maxLength       = kMaxFEV1Lung.size
            break
        case .PEF:
            //Max value allowed is 800
            self.txtReading.maxLength       = kMaxPEF.size
            
            break
        case .BMI:
            //not needed here
            break
        case .BloodGlucose:
            //not needed here
            break
        case .HbA1c:
            
            self.txtReading.text            = String(format: "%0.1f", self.readingListModel.readingValue)
            self.txtReading.keyboardType    = .decimalPad
            self.txtReading.regex           = Validations.RegexType.HbA1c.rawValue
            self.txtReading.maxLength       = kMaxHbA1c.size + 2
            //self.txtReading.maxLength   = 3//maxLength is from regex
            break
        case .ACR:
            //Max value allowed is 100
            self.txtReading.maxLength   = kMaxACR.size
            break
        case .eGFR:
            //Max value allowed is 150
            self.txtReading.maxLength   = kMaxeGFR.size
            //self.txtUnit.text           = "1.73m²"
            break
            
        case .cat:
            //cat pending
            break
            
        case .six_min_walk:
            //cat pending
            break
        case .fibro_scan:
            break
        case .fib4:
            break
        case .sgot:
            self.txtReading.maxLength   = kMaximumSGOT.size
            break
        case .sgpt:
            self.txtReading.maxLength   = kMaximumSGPT.size
            break
        case .triglycerides:
            self.txtReading.maxLength   = kMaximumTriglyceride.size
            break
        case .total_cholesterol:
            break
        case .ldl_cholesterol:
            self.txtReading.maxLength   = kMaximumLDL.size
            break
        case .hdl_cholesterol:
            self.txtReading.maxLength   = kMaximumHDL.size
            break
        case .waist_circumference:
            self.txtReading.maxLength   = kMaxWaistCircumference.size
            break
        case .platelet:
            self.txtReading.maxLength   = kMaxPlatelet.size

            self.txtUnitWidth.constant = self.vwBg.frame.width * 0.2
            break
        case .serum_creatinine:
            self.txtReading.text            = String(format: "%0.1f", self.readingListModel.readingValue)
            self.txtReading.keyboardType    = .decimalPad
//            self.txtReading.maxLength       = kMaxBodyWeightKg.size + 2
            self.txtReading.regex           = "".decimalRegex(maxLength: Int(kMaxFattyLiver.size + 2), decimalLength: 1)
            break
        case .fatty_liver_ugs_grade:
            self.selectedFattyLiverGrade = GFunction.shared.getFattyLiver(value: JSON(self.readingListModel.readingValue!).intValue,
                                                                          arrFattyLiverGrade: self.arrFattyLiverGrade)
            self.txtReading.text = self.selectedFattyLiverGrade["name"].stringValue
            
            self.txtReading.tintColor       = UIColor.clear
            self.txtReading.regex           = Validations.RegexType.AlphaNumeric.rawValue
            self.txtReading.setRightImage(img: UIImage(named: "IconDownArrow"))
            self.vwUnit.isHidden            = true
            self.initFattyLiverPicker()
            break
            
        case .random_blood_glucose:
            self.txtReading.maxLength   = kMaxRandomBG.size
            break
        case .BodyFat:
            self.txtReading.maxLength   = kMaxBodyFat.size
            break
        case .Hydration:
            self.txtReading.maxLength   = kMaxHydration.size
            break
        case .MuscleMass:
            self.txtReading.keyboardType    = .decimalPad
            self.txtReading.regex           = "".decimalRegex(maxLength: Int(kMaxMuscleMass.size + 2), decimalLength: 1)
            self.txtReading.text            = String(format: "%0.1f", JSON(self.readingListModel.readingValue as Any).doubleValue)
//            JSON(self.readingListModel.readingValue as Any).stringValue
            break
        case .Protein:
            self.txtReading.maxLength   = kMaxProtein.size
            break
        case .BoneMass:
            self.txtReading.keyboardType    = .decimalPad
            self.txtReading.regex           = "".decimalRegex(maxLength: Int(kMaxBoneMass.size + 2), decimalLength: 1)
            self.txtReading.text            = String(format: "%0.1f", JSON(self.readingListModel.readingValue as Any).doubleValue)
            break
        case .VisceralFat:
            self.txtReading.keyboardType    = .decimalPad
            self.txtReading.regex           = "".decimalRegex(maxLength: String(kMaxVisceralFat).count + 2, decimalLength: 1)
            self.txtReading.text            = String(format: "%0.1f", JSON(self.readingListModel.readingValue as Any).doubleValue)
            break
        case .BaselMetabolicRate:
            self.txtReading.maxLength   = kMaxBasalMetabolicRate.size
            break
        case .MetabolicAge:
            self.txtReading.maxLength   = kMaxMetabolicAge.size
            break
        case .SubcutaneousFat:
            self.txtReading.keyboardType    = .decimalPad
            self.txtReading.regex           = "".decimalRegex(maxLength: Int(kMaxSubcutaneousFat.size + 2), decimalLength: 1)
            self.txtReading.text            = String(format: "%0.1f", JSON(self.readingListModel.readingValue as Any).doubleValue)
            break
        case .SkeletalMuscle:
            self.txtReading.maxLength   = kMaxSkeletalMuscle.size
            break
        case .fev1_fvc_ratio,.fvc,.aqi,.humidity,.temperature,.sedentary_time:
            break
        case .calories_burned:
            self.txtReading.maxLength   = kMaxCaloriesBurned.size
        }
    }
    
    fileprivate func calculateWeightValue(isAllowChange: Bool){
        let unit = GFunction.shared.getUnit(from: self.arrWeightUnit)
        let weightUnit = WeightUnit.init(rawValue: unit) ?? .kg
        
        switch weightUnit {
        case .kg:
            if isAllowChange {
                let weight = GFunction.shared.convertWeight(toLbs: false,
                                                            value: JSON(self.txtReading.text!).doubleValue)
//                self.txtReading.text = String(format:"%0.1f",weight)
                self.txtReading.text = "\(weight.floorToPlaces(places: 1))"
            }
            
            break
        case .lbs:
            let weight = GFunction.shared.convertWeight(toLbs: true,
                                                        value: JSON(self.txtReading.text!).doubleValue)
//            self.txtReading.text = String(format:"%0.1f",weight)
            self.txtReading.text = "\(weight.floorToPlaces(places: 1))"
            break
        }
    }

}

//MARK: -------------------- setupViewModel Observer --------------------
extension UpdateCommonReadingPopupVC {
    
    fileprivate func setupViewModelObserver() {
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
                switch self.readingType {
                case .calories_burned:
                    HealthKitManager.shared.addCaloriesData(reading: (Double(self.txtReading.text!) ?? 0),dateTime: self.viewModel.achieved_datetime)
                    break
                case .SPO2:
                    HealthKitManager.shared.addLogToHealthKit(identifier: .oxygenSaturation,
                                                              reading: (Double(self.txtReading.text!) ?? 0) / 100,
                                                              unit: HKUnit.percent(),
                                                              dateTime: self.viewModel.achieved_datetime)
                    break
                    
                case .BloodPressure:
                    //not needed here
                    break
                    
                case .BodyWeight:
                    let result = GFunction.shared.getFinalHeightWeight(heightUnit: "",
                                                                       weightUnit: GFunction.shared.getUnit(from: self.arrWeightUnit),
                                                                       heightCm: "",
                                                                       heightFt: "",
                                                                       heightIn: "",
                                                                       weight: self.txtReading.text!,
                                                                       goalWeight: "")
                    HealthKitManager.shared.addLogToHealthKit(identifier: .bodyMass,
                                                              reading: (Double(result.weight) ?? 0) * 1000,
                                                              unit: HKUnit.gram(),
                                                              dateTime: self.viewModel.achieved_datetime)
                    break
                    
                case .HeartRate:
                    
                    HealthKitManager.shared.addLogToHealthKit(identifier: .restingHeartRate,
                                                              reading: (Double(self.txtReading.text!) ?? 0),
                                                              unit: HKUnit.count().unitDivided(by: .minute()),
                                                              dateTime: self.viewModel.achieved_datetime)
                    break
              
                case .FEV1Lung:
                    HealthKitManager.shared.addLogToHealthKit(identifier: .forcedExpiratoryVolume1,
                                                              reading: (Double(self.txtReading.text!) ?? 0),
                                                              unit: HKUnit.liter(),
                                                              dateTime: self.viewModel.achieved_datetime)
                    break
                case .PEF:
                    HealthKitManager.shared.addLogToHealthKit(identifier: .peakExpiratoryFlowRate,
                                                              reading: (Double(self.txtReading.text!) ?? 0),
                                                              unit: HKUnit.liter().unitDivided(by: .minute()),
                                                              dateTime: self.viewModel.achieved_datetime)
                    break
                case .BMI:
                    //not needed here
                    break
                case .BloodGlucose:
                    //not needed here
                    break
                case .HbA1c:
                    
                    break
                case .ACR:
                    
                    break
                case .eGFR:
                    
                    break
                    
                case .cat:
                    //cat pending
                    break
                    
                case .six_min_walk:
                    //cat pending
                    break
                case .fibro_scan:
                    break
                case .fib4:
                    break
                case .sgot:
                    break
                case .sgpt:
                    break
                case .triglycerides:
                    break
                case .total_cholesterol:
                    break
                case .ldl_cholesterol:
                    break
                case .hdl_cholesterol:
                    break
                case .waist_circumference:
                    break
                case .platelet:
                    break
                case .serum_creatinine:
                    break
                case .fatty_liver_ugs_grade:
                    break
                case .random_blood_glucose:
                    break
                case .BodyFat:
                    break
                case .Hydration:
                    break
                case .MuscleMass:
                    break
                case .Protein:
                    break
                case .BoneMass:
                    break
                case .VisceralFat:
                    break
                case .BaselMetabolicRate:
                    break
                case .MetabolicAge:
                    break
                case .SubcutaneousFat:
                    break
                case .SkeletalMuscle:
                    break
                case .fev1_fvc_ratio,.fvc,.aqi,.humidity,.temperature,.sedentary_time:
                    break
                }
                
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
                    
                    if self.readingType == .BMI && self.readingType == .BodyWeight {
                        GlobalAPI.shared.getPatientDetailsAPI(withLoader: true){ [weak self] isDone in
                            guard let self = self else {return}
                            if isDone {
                                Alert.shared.showSnackBar(kBMISuccessMessage)
                                var obj         = JSON()
                                obj["isDone"]   = true
                                self.dismissPopUp(true, objAtIndex: obj)
                            }
                        }
                    }else {
                        Alert.shared.showSnackBar(kBMISuccessMessage)
                        var obj         = JSON()
                        obj["isDone"]   = true
                        self.dismissPopUp(true, objAtIndex: obj)
                    }
                    
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

