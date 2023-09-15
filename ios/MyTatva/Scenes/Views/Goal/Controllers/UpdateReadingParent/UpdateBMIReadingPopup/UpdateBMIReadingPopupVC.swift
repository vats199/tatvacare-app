//
//  PheromonePopupVC.swift
//

//

import UIKit

class UpdateBMIReadingPopupVC: ClearNavigationFontBlackBaseVC {
    
    
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
    
    @IBOutlet weak var lblHeight        : UILabel!
    @IBOutlet weak var lblWeight        : UILabel!
    
    @IBOutlet weak var txtHeightCm      : UITextField!
    @IBOutlet weak var txtHeightFt      : UITextField!
    @IBOutlet weak var txtHeightIn      : UITextField!
    
    @IBOutlet weak var vwHeightUnit     : UIView!
    @IBOutlet weak var txtHeightUnit    : UITextField!
    @IBOutlet weak var stackHeightFtInch: UIStackView!
    
    @IBOutlet weak var vwWeightUnit     : UIView!
    @IBOutlet weak var txtWeight        : UITextField!
    @IBOutlet weak var txtWeightUnit    : UITextField!
    
    @IBOutlet weak var lblReading       : UILabel!
    @IBOutlet weak var txtReading       : UITextField!
    @IBOutlet weak var txtReadingUnit   : UITextField!
    
    @IBOutlet weak var lblStandardVal   : UILabel!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancel        : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    
    @IBOutlet weak var vwHKConnect      : UIView!
    @IBOutlet weak var lblHKConnect     : UILabel!
    
    
    //MARK:- Class Variable
    let viewModel                       = UpdateBMIReadingPopupVM()
    var readingType: ReadingType        = .HeartRate
    var readingListModel                = ReadingListModel()
    var isNext                          = false
    
    var datePicker                      = UIDatePicker()
    var timePicker                      = UIDatePicker()
    var dateFormatter                   = DateFormatter()
//   var dateFormat                      = DateTimeFormaterEnum.ddmm_yyyy.rawValue
//    var timeFormat                      = DateTimeFormaterEnum.hhmma.rawValue
    
    let pickerHeight                    = UIPickerView()
    let pickerWeight                    = UIPickerView()
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    fileprivate var arrHeightUnit : [UnitData] = []
    fileprivate var arrWeightUnit : [UnitData] = []
    
//    fileprivate var arrHeightUnit : [JSON] = [
//        [
//            "name"          : "cm",
//            "key"           : HeightUnit.cm.rawValue,
//            "is_select"     : 1,
//        ],
//        [
//            "name"          : "ft/in",
//            "key"           : HeightUnit.Feetinches.rawValue,
//            "is_select"     : 0,
//        ]
//    ]
//
//    fileprivate var arrWeightUnit : [JSON] = [
//        [
//            "name"          : "kg",
//            "key"           : WeightUnit.kg.rawValue,
//            "is_select"     : 1,
//        ],
//        [
//            "name"          : "lbs",
//            "key"           : WeightUnit.lbs.rawValue,
//            "is_select"     : 0,
//        ]
//    ]
    
    
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
        self.lblHeight.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblWeight.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblStandardVal.font(name: .medium, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
        
        self.btnCancel.font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
            .borderColor(color: UIColor.themePurple, borderWidth: 1)
            .cornerRadius(cornerRadius: 7)
            .backGroundColor(color: UIColor.white)
        
        self.txtDate
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .backGroundColor(color: UIColor.white)
        
        self.txtTime
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .backGroundColor(color: UIColor.white)
        
        self.txtHeightCm
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .backGroundColor(color: UIColor.white)
            .borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            .cornerRadius(cornerRadius: 5)
        self.txtHeightFt
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .backGroundColor(color: UIColor.white)
            .borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            .cornerRadius(cornerRadius: 5)
        self.txtHeightIn
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .backGroundColor(color: UIColor.white)
            .borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            .cornerRadius(cornerRadius: 5)
        self.txtHeightUnit
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .cornerRadius(cornerRadius: 5)
            .setRightImage(img: UIImage(named: "IconDownArrow"))
        
        self.txtWeight
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            .cornerRadius(cornerRadius: 5)
        self.txtWeightUnit
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .cornerRadius(cornerRadius: 5)
            .setRightImage(img: UIImage(named: "IconDownArrow"))
        
        self.txtReading
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            .cornerRadius(cornerRadius: 5)
            .backGroundColor(color: UIColor.themeLightGray)
            .isUserInteractionEnabled = false
        
        self.txtReadingUnit
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            .cornerRadius(cornerRadius: 5)
            .backGroundColor(color: UIColor.themeLightGray)
        self.txtReadingUnit.textAlignment = .center
        self.txtReadingUnit.isUserInteractionEnabled = false
        
        self.btnSubmit.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
        
        
        self.txtHeightCm.maxLength      = kMaxHeightCm.size
        self.txtHeightFt.maxLength      = kMaxHeightFt.size
        self.txtHeightIn.maxLength      = kMaxHeightIn.size
        self.txtWeight.maxLength        = kMaxBodyWeightKg.size + 2
        
        self.txtHeightCm.keyboardType   = .numberPad
        self.txtHeightFt.keyboardType   = .numberPad
        self.txtHeightIn.keyboardType   = .numberPad
        self.txtWeight.keyboardType     = .decimalPad

        self.txtHeightCm.delegate       = self
        self.txtHeightFt.delegate       = self
        self.txtHeightIn.delegate       = self
        self.txtWeight.delegate         = self
        
        self.txtWeightUnit.tintColor    = UIColor.clear
        self.txtHeightUnit.tintColor    = UIColor.clear
        self.txtReadingUnit.tintColor   = UIColor.clear
        
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
        self.initPicker()
        self.updateHeightUI()
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
    
    private func initPicker(){
        self.pickerHeight.delegate          = self
        self.pickerHeight.dataSource        = self
        self.txtHeightUnit.delegate         = self
        self.txtHeightUnit.inputView        = self.pickerHeight
        
        self.pickerWeight.delegate          = self
        self.pickerWeight.dataSource        = self
        self.txtWeightUnit.delegate         = self
        self.txtWeightUnit.inputView        = self.pickerWeight
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
            let result = GFunction.shared.getFinalHeightWeight(heightUnit: GFunction.shared.getUnit(from: self.arrHeightUnit),
                                                               weightUnit: GFunction.shared.getUnit(from: self.arrWeightUnit),
                                                               heightCm: self.txtHeightCm.text!,
                                                               heightFt: self.txtHeightFt.text!,
                                                               heightIn: self.txtHeightIn.text!,
                                                               weight: self.txtWeight.text!,
                                                               goalWeight: "")
            
            self.viewModel.apiCall(vc: self,
                                   date: self.txtDate,
                                   time: self.txtTime,
                                   heightUnit: GFunction.shared.getUnit(from: self.arrHeightUnit),
                                   weightUnit: GFunction.shared.getUnit(from: self.arrWeightUnit),
                                   heightCm: result.height,
                                   heightFt: self.txtHeightFt.text!,
                                   heightIn: self.txtHeightIn.text!,
                                   weightKg: result.weight,
                                   weightLbs: self.txtWeight.text!,
                                   reading: self.txtReading,
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: -------------------- Date picker methods --------------------
extension UpdateBMIReadingPopupVC {
    
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
extension UpdateBMIReadingPopupVC : UITextFieldDelegate {
    
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
        return true
        
    case self.txtTime:
        
        if self.txtTime.text?.trim() == "" {
            self.dateFormatter.dateFormat   = appTimeFormat
            self.dateFormatter.timeZone     = .current
            self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
            self.txtTime.text               = self.dateFormatter.string(from: self.timePicker.date)
        }
        return true
    
    case self.txtHeightUnit:
        
        if self.txtHeightUnit.text?.trim() == "" {
            let obj = self.arrHeightUnit[0]
            self.txtHeightUnit.text = obj.unitTitle
        }
        return true
        
    case self.txtWeightUnit:
        
        if self.txtWeightUnit.text?.trim() == "" {
            let obj = self.arrWeightUnit[0]
            self.txtWeightUnit.text = obj.unitTitle
        }
        return true
    
    default:
        return true
    }
    
}
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        
        
        switch textField {
        case self.txtHeightCm:
            self.calculateBMI(height: newText, weight: self.txtWeight.text!)
            return NSPredicate(format: "SELF MATCHES %@", Validations.RegexType.OnlyNumber.rawValue).evaluate(with: newText)
            
        case self.txtHeightFt:
            let result = GFunction.shared.getFinalHeightWeight(heightUnit: GFunction.shared.getUnit(from: self.arrHeightUnit),
                                                               weightUnit: GFunction.shared.getUnit(from: self.arrWeightUnit),
                                                               heightCm: self.txtHeightCm.text!,
                                                               heightFt: newText,
                                                               heightIn: self.txtHeightIn.text!,
                                                               weight: self.txtWeight.text!,
                                                               goalWeight: "")
            self.calculateBMI(height: result.height, weight: result.weight)
            return NSPredicate(format: "SELF MATCHES %@", Validations.RegexType.OnlyNumber.rawValue).evaluate(with: newText)
            
        case self.txtHeightIn:
            let result = GFunction.shared.getFinalHeightWeight(heightUnit: GFunction.shared.getUnit(from: self.arrHeightUnit),
                                                               weightUnit: GFunction.shared.getUnit(from: self.arrWeightUnit),
                                                               heightCm: self.txtHeightCm.text!,
                                                               heightFt: self.txtHeightFt.text!,
                                                               heightIn: newText,
                                                               weight: self.txtWeight.text!,
                                                               goalWeight: "")
            self.calculateBMI(height: result.height, weight: result.weight)
            return NSPredicate(format: "SELF MATCHES %@", Validations.RegexType.OnlyNumber.rawValue).evaluate(with: newText) &&
            Int(newText) < 12
            
        case self.txtWeight:
        let weightUnit = GFunction.shared.getUnit(from: self.arrWeightUnit)
            let result = GFunction.shared.getFinalHeightWeight(heightUnit: GFunction.shared.getUnit(from: self.arrHeightUnit),
                                                               weightUnit: weightUnit,
                                                               heightCm: self.txtHeightCm.text!,
                                                               heightFt: self.txtHeightFt.text!,
                                                               heightIn: self.txtHeightIn.text!,
                                                               weight: newText,
                                                               goalWeight: "")
            self.calculateBMI(height: result.height, weight: result.weight)
            if WeightUnit.init(rawValue: weightUnit) == .kg {
                return NSPredicate(format: "SELF MATCHES %@", newText.decimalRegex(maxLength: Int(kMaxBodyWeightKg.size), decimalLength: 1)).evaluate(with: newText)
            }
            else {
                return NSPredicate(format: "SELF MATCHES %@", newText.decimalRegex(maxLength: Int(kMaxBodyWeightLbs.size), decimalLength: 1)).evaluate(with: newText)
            }
            
            
        default:break
        }
        
        
        return true
    }
}

//MARK: --------------------- UIPickerVIew Method ---------------------
extension UpdateBMIReadingPopupVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerWeight:
            return self.arrWeightUnit.count
        case self.pickerHeight:
            return self.arrHeightUnit.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerWeight:
            return self.arrWeightUnit[row].unitTitle
        case self.pickerHeight:
            return self.arrHeightUnit[row].unitTitle
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
            
            if self.txtWeightUnit.text != obj.unitTitle {
                self.txtWeightUnit.text = obj.unitTitle
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
//            if self.txtWeightUnit.text != obj["name"].stringValue {
//                self.txtWeightUnit.text = obj["name"].stringValue
//                self.calculateWeightValue()
//            }
            break
       
        case self.pickerHeight:
            let obj = self.arrHeightUnit[row]
            
            self.arrHeightUnit = self.arrHeightUnit.map({ data in
                data.isSelected = false
                if data.unitKey == obj.unitKey {
                    data.isSelected = true
                }
                return data
            })
            
            if self.txtHeightUnit.text != obj.unitTitle {
                self.txtHeightUnit.text = obj.unitTitle
                self.updateHeightUI()
                self.calculateHeightValue(isAllowChange: true)
            }
            
//            for i in 0...self.arrHeightUnit.count - 1 {
//                var item = self.arrHeightUnit[i]
//                item["is_select"] = 0
//                if self.arrHeightUnit[i]["key"].stringValue == obj["key"].stringValue {
//                    item["is_select"] = 1
//                }
//                self.arrHeightUnit[i] = item
//            }
//            if self.txtHeightUnit.text != obj["name"].stringValue {
//                self.txtHeightUnit.text = obj["name"].stringValue
//                self.updateHeightUI()
//                self.calculateHeightValue()
//            }
            
            break
        default: break
        }
    }
}

//MARK: ------------------ Set data Methods ------------------
extension UpdateBMIReadingPopupVC {
    
    fileprivate func setData(){
        WebengageManager.shared.navigateScreenEvent(screen: .LogReading, postFix: self.readingListModel.keys)
        
        self.vwImgTitle
            .backGroundColor(color: UIColor.hexStringToUIColor(hex: self.readingListModel.backgroundColor).withAlphaComponent(0.1))
        self.imgTitle.image         = nil
        self.imgTitle.setCustomImage(with: self.readingListModel.imageUrl, renderingMode: .alwaysTemplate)
        self.imgTitle.tintColor     = UIColor.hexStringToUIColor(hex: self.readingListModel.colorCode)
        self.lblTitle.text          = self.readingListModel.readingName
        
        self.txtWeight.text         = self.readingListModel.readingValueData.weight ?? ""
        self.txtHeightCm.text       = self.readingListModel.readingValueData.height ?? ""
        self.txtReadingUnit.text    = self.readingListModel.measurements
        
        self.arrHeightUnit.removeAll()
        self.arrWeightUnit.removeAll()
        
        if UserModel.shared.unitData != nil  {
            for data in UserModel.shared.unitData {
                if let _ = HeightUnit.init(rawValue: data.unitKey) {
                    self.arrHeightUnit.append(data)
                }
                if let _ = WeightUnit.init(rawValue: data.unitKey) {
                    self.arrWeightUnit.append(data)
                }
            }
        }
        
        self.arrHeightUnit = self.arrHeightUnit.map({ data in
            var appHeightUnit = ""
            if UserModel.shared.heightUnit.trim() != "" {
                appHeightUnit = UserModel.shared.heightUnit
            }
            else {
                appHeightUnit = HeightUnit.cm.rawValue
            }
            
            data.isSelected = false
            if data.unitKey == appHeightUnit {
                data.isSelected = true
                self.txtHeightUnit.text = data.unitTitle
            }
            
            return data
        })
        
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
                self.txtWeightUnit.text = data.unitTitle
            }
            return data
        })
        
        ///Set default picker values
        for i in 0...self.arrHeightUnit.count - 1 {
            if self.arrHeightUnit[i].isSelected {
                self.pickerHeight.selectRow(i, inComponent: 0, animated: true)
            }
        }
        for i in 0...self.arrWeightUnit.count - 1 {
            if self.arrWeightUnit[i].isSelected {
                self.pickerWeight.selectRow(i, inComponent: 0, animated: true)
            }
        }
        
        self.txtHeightCm.backGroundColor(color: UIColor.white)
        self.txtHeightCm.isUserInteractionEnabled = true
        
        self.txtHeightFt.backGroundColor(color: UIColor.white)
        self.txtHeightFt.isUserInteractionEnabled = true
        
        self.txtHeightIn.backGroundColor(color: UIColor.white)
        self.txtHeightIn.isUserInteractionEnabled =  true
        if Float(UserModel.shared.height) > 0 {
            self.txtHeightCm.text = String(format: "%0.f", Float(UserModel.shared.height) ?? 0)
            self.txtHeightCm.backGroundColor(color: UIColor.themeLightGray)
            self.txtHeightCm.isUserInteractionEnabled = false
            
            self.txtHeightFt.backGroundColor(color: UIColor.themeLightGray)
            self.txtHeightFt.isUserInteractionEnabled = false
            
            self.txtHeightIn.backGroundColor(color: UIColor.themeLightGray)
            self.txtHeightIn.isUserInteractionEnabled = false
        }
        
        self.lblStandardVal.text    = self.readingListModel.defaultReading!
        self.txtReading.text        = "\(self.readingListModel.readingValue!)"
        
        self.updateHeightUI()
        self.calculateHeightValue(isAllowChange: false)
        self.calculateWeightValue(isAllowChange: false)
        
        let result = GFunction.shared.getFinalHeightWeight(heightUnit: GFunction.shared.getUnit(from: self.arrHeightUnit),
                                                           weightUnit: GFunction.shared.getUnit(from: self.arrWeightUnit),
                                                           heightCm: self.txtHeightCm.text!,
                                                           heightFt: self.txtHeightFt.text!,
                                                           heightIn: self.txtHeightIn.text!,
                                                           weight: self.txtWeight.text!,
                                                           goalWeight: "")
        
        self.calculateBMI(height: result.height, weight: result.weight)
    }
}

//MARK: -------------------- UI Update Methods--------------------
extension UpdateBMIReadingPopupVC {

    fileprivate func calculateBMI(height: String, weight: String) {
        if height.trim() != "" &&
            weight.trim() != "" {
           
            let heightVal           = Double(height) ?? 0
            let weightVal           = Double(weight) ?? 0
            
            let heightMeter         = heightVal / 100
            let BMI                 = weightVal / (heightMeter * heightMeter)
            
            if BMI.isNaN ||
                BMI.isInfinite {
                self.txtReading.text = ""
            }
            else {
                self.txtReading.text = String(format: "%0.1f", BMI)
            }
        }
        else {
            self.txtReading.text = ""
        }
    }
    
    fileprivate func updateHeightUI(){
        let currentUnit = GFunction.shared.getUnit(from: self.arrHeightUnit)
        
        if currentUnit == HeightUnit.cm.rawValue {
            self.stackHeightFtInch.isHidden     = true
            self.txtHeightFt.isHidden           = true
            self.txtHeightIn.isHidden           = true
            self.txtHeightCm.isHidden           = false
        }
        else {
            self.stackHeightFtInch.isHidden     = false
            self.txtHeightFt.isHidden           = false
            self.txtHeightIn.isHidden           = false
            self.txtHeightCm.isHidden           = true
        }
        
//        UIView.animate(withDuration: kAnimationSpeed, delay: 0, options: [.curveEaseIn]) {
//            self.view.layoutIfNeeded()
//        } completion: { isDone in
//        }
    }
    
    fileprivate func calculateHeightValue(isAllowChange: Bool){
        let unit = GFunction.shared.getUnit(from: self.arrHeightUnit)
        let heightUnit = HeightUnit.init(rawValue: unit) ?? .cm
        
        switch heightUnit {
        case .feet_inch:
            /*
             cm to feet / inches:
             Let the value entered in cm be X
             Step-1: Calculate (X/2.54)
             Step-2: Divide the value obtained in Step-2 by 12. Quotient / Remainder = feet / inches
             */
            
            self.txtHeightFt.text   = ""
            self.txtHeightIn.text   = ""
            if self.txtHeightCm.text!.trim() != "" {
//                let value: Double   = JSON(value).doubleValue
//                let total_inch      = (value/2.54)
//                let feet            = floor(total_inch/12)
//                let inch            = total_inch.truncatingRemainder(dividingBy: 12)
                
                // * feet
                let result = GFunction.shared.convertToFeetInch(from: JSON(self.txtHeightCm.text!).doubleValue)
                self.txtHeightFt.text = String(format:"%0.f",result.ft)
                self.txtHeightIn.text = String(format:"%0.f",result.inch)
            }
            
            break
        case .cm:
            /*
             feet / inches to cm:
             Calculate: feet * 30.48 + inches * 2.54
             */
            if isAllowChange {
                self.txtHeightCm.text   = ""
                if self.txtHeightFt.text?.trim() != "" &&
                    self.txtHeightIn.text?.trim() != "" {
    //                let feet: Double    = JSON(value).doubleValue
    //                let inch: Double    = JSON(self.txtHeightIn.text!).doubleValue
    //                let cm              = (feet * 30.48) + (inch * 2.54)
                    
                    let cm = GFunction.shared.convertToCm(from: JSON(self.txtHeightFt.text!).doubleValue,
                                                              inch: JSON(self.txtHeightIn.text!).doubleValue)
                    
                    self.txtHeightCm.text = String(format:"%0.f",cm)
                }
            }
            
            break
        }
        
    }
    
    fileprivate func calculateWeightValue(isAllowChange: Bool){
        let unit = GFunction.shared.getUnit(from: self.arrWeightUnit)
        let weightUnit = WeightUnit.init(rawValue: unit) ?? .kg
        
        switch weightUnit {
        case .kg:
            if isAllowChange {
                let weight = GFunction.shared.convertWeight(toLbs: false,
                                                            value: JSON(self.txtWeight.text!).doubleValue)
//                self.txtWeight.text = String(format:"%0.1f",weight)
                self.txtWeight.text = "\(weight.floorToPlaces(places: 1))"
            }
            
            break
        case .lbs:
            let weight = GFunction.shared.convertWeight(toLbs: true,
                                                        value: JSON(self.txtWeight.text!).doubleValue)
//            self.txtWeight.text = String(format:"%0.1f",weight)
            self.txtWeight.text = "\(weight.floorToPlaces(places: 1))"
            break
        }
    }

}

//MARK: -------------------- setupViewModel Observer --------------------
extension UpdateBMIReadingPopupVC {
    
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
                
                HealthKitManager.shared.addLogToHealthKit(identifier: .bodyMassIndex,
                                                          reading: Double(self.txtReading.text!) ?? 0,
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
                    GlobalAPI.shared.getPatientDetailsAPI(withLoader: true){ [weak self] isDone in
                        guard let self = self else {return}
                        if isDone {
                            Alert.shared.showSnackBar(kBMISuccessMessage)
                            var obj         = JSON()
                            obj["isDone"]   = true
                            self.dismissPopUp(true, objAtIndex: obj)
                        }
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

