//
//  AddWeightHeightVC.swift
//  MyTatva
//
//  Created by on 10/11/21.
//

import UIKit

class AddWeightHeightCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!

    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var btnSelect            : UIButton!
    
    var object = AppointmentListModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .bold, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblDesc
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 5)
            //self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            self.vwBg.borderColor(color: UIColor.ThemeBorder, borderWidth: 0.5)
            
        }
    }
}

class AddWeightHeightVC: ClearNavigationFontBlackBaseVC {
    
    //MARK: -------------------------- Outlet --------------------------
    @IBOutlet weak var lblAddWeightHeight       : UILabel!
    
    @IBOutlet weak var lblHeight                : UILabel!
    @IBOutlet weak var vwHeightCm               : ThemeTextfieldBorderView!
    @IBOutlet weak var txtHeightCm              : UITextField!
    
    @IBOutlet weak var stackHeightFtInch        : UIStackView!
    @IBOutlet weak var txtHeightFt              : UITextField!
    @IBOutlet weak var txtHeightIn              : UITextField!
    
    @IBOutlet weak var vwHeightUnit             : UIView!
    @IBOutlet weak var txtHeightUnit            : UITextField!
    
    @IBOutlet weak var lblWeight                : UILabel!
    @IBOutlet weak var vwWeight                 : ThemeTextfieldBorderView!
    @IBOutlet weak var txtWeight                : UITextField!
    
    @IBOutlet weak var vwWeightUnit             : UIView!
    @IBOutlet weak var txtWeightUnit            : UITextField!
    
    @IBOutlet weak var lblSetGoal               : UILabel!
    @IBOutlet weak var lblSetIn                 : UILabel!
    @IBOutlet weak var txtSetWeight             : UITextField!
    @IBOutlet weak var txtSetWeightDays         : UITextField!
    
    @IBOutlet weak var lblBMIDisclaimer         : UILabel!
    @IBOutlet weak var lblCalorieDisclaimer     : UILabel!
    
    @IBOutlet weak var lblChooseActivity        : UILabel!
    @IBOutlet weak var lblChooseActivityDesc    : UILabel!
    
    @IBOutlet weak var tblView                  : UITableView!
    @IBOutlet weak var tblViewHeight            : NSLayoutConstraint!
    
    @IBOutlet weak var btnUpdate                : UIButton!
    @IBOutlet weak var btnSkip                  : UIButton!
    
    //MARK: -------------------------- Class Variable --------------------------
    private let viewModel               = AddWeightHeightVM()
    let pickerDays                      = UIPickerView()
    var isEdit                          = false
    var selectedMonths                  = WeightMonthsModel()
    let pickerHeight                    = UIPickerView()
    let pickerWeight                    = UIPickerView()
    
    var timerAPI                        = Timer()
    
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
    
    fileprivate var arrData : [JSON] = [
        [
            "name" : "Little or No Activity",
            "desc" : "Mostly sitting through the day (eg. desk job, Bank Teller)",
            "key": "S",
            "isSelected": 1,
        ],
        [
            "name" : "Lightly Active",
            "desc" : "Mostly standing through the day (eg. Teacher, Sales associate)",
            "key": "L",
            "isSelected": 0,
        ],
        [
            "name" : "Moderately Active",
            "desc" : "Mostly walking or doing physical activities through the day (eg. Tour guide, waiter)",
            "key": "M",
            "isSelected": 0,
        ],
        [
            "name" : "Very Active",
            "desc" : "Mostly doing heavy physical activities through the day (eg. Gym Instructor, Construction worker)",
            "key": "V",
            "isSelected": 0,
        ],
    ]
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.setData()
        self.updateDisclaimer(heightCm: self.txtHeightCm.text!,
                              heightFt: self.txtHeightFt.text!,
                              heightIn: self.txtHeightIn.text!,
                              weight: self.txtWeight.text!,
                              goalWeight: self.txtSetWeight.text!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .SetHeightWeight, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAnalytics.manageTimeSpent(on: .SetHeightWeight, when: .Disappear)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //-----------------------------------------------------
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: -------------------------- Custom Method --------------------------
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        self.applyStyle()
        self.manageActionMethods()
        self.addObserverOnHeightTbl()
        self.initPicker()
        self.updateHeightUI()
        
        self.txtHeightCm.keyboardType   = .numberPad
        self.txtHeightFt.keyboardType   = .numberPad
        self.txtHeightIn.keyboardType   = .numberPad
        self.txtWeight.keyboardType     = .decimalPad
        self.txtSetWeight.keyboardType  = .decimalPad

        self.txtHeightCm.maxLength      = kMaxHeightCm.size
        self.txtHeightFt.maxLength      = kMaxHeightFt.size
        self.txtHeightIn.maxLength      = kMaxHeightIn.size
//        self.txtWeight.maxLength        = kMaxBodyWeightKg.size
//        self.txtSetWeight.maxLength     = kMaxBodyWeightKg.size
        
//        self.txtHeightCm.regex          = Validations.RegexType.OnlyNumber.rawValue
//        self.txtHeightFt.regex          = Validations.RegexType.OnlyNumber.rawValue
//        self.txtHeightIn.regex          = Validations.RegexType.Inch.rawValue
//        self.txtWeight.regex            = Validations.RegexType.OnlyNumber.rawValue
//        self.txtSetWeight.regex         = Validations.RegexType.OnlyNumber.rawValue
        
        self.txtHeightUnit.setRightImage(img: UIImage(named: "IconDownArrow"))
        self.txtWeightUnit.setRightImage(img: UIImage(named: "IconDownArrow"))
//        self.txtHeightUnit.isEnabled = false
//        self.txtWeightUnit.isEnabled = false
        self.txtSetWeightDays.setRightImage(img: UIImage(named: "IconDownArrow"))
        
        self.setup(tblView: self.tblView)
        
        self.txtHeightCm.delegate       = self
        self.txtHeightFt.delegate       = self
        self.txtHeightIn.delegate       = self
        self.txtHeightUnit.delegate     = self
        self.txtWeight.delegate         = self
        self.txtWeightUnit.delegate     = self
        self.txtSetWeight.delegate      = self
        self.txtSetWeightDays.delegate  = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.vwHeightCm.layoutIfNeeded()
            self.vwWeight.layoutIfNeeded()
            self.txtWeight.layoutIfNeeded()
            self.txtHeightCm.layoutIfNeeded()
        }
    }
    
    private func applyStyle() {
        self.lblAddWeightHeight
            .font(name: .bold, size: 20).textColor(color: .themeBlack)
        self.lblHeight
            .font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.lblWeight
            .font(name: .medium, size: 16).textColor(color: .themeBlack)
        
        self.lblSetGoal
            .font(name: .bold, size: 18).textColor(color: .themeBlack.withAlphaComponent(1))
        self.lblSetIn
            .font(name: .medium, size: 15).textColor(color: .themeBlack.withAlphaComponent(1))
        
        self.lblChooseActivity
            .font(name: .bold, size: 18).textColor(color: .themeBlack.withAlphaComponent(1))
        self.lblChooseActivityDesc
            .font(name: .semibold, size: 15).textColor(color: .themeBlack.withAlphaComponent(1))
        
        self.lblBMIDisclaimer
            .font(name: .regular, size: 12).textColor(color: .themeRed.withAlphaComponent(1))
        self.lblCalorieDisclaimer
            .font(name: .regular, size: 12).textColor(color: .themeRed.withAlphaComponent(1))
        
        self.btnSkip
            .font(name: .medium, size: 16).textColor(color: UIColor.themePurple)
        
        self.txtWeightUnit.tintColor        = UIColor.clear
        self.txtHeightUnit.tintColor        = UIColor.clear
        self.txtSetWeightDays.tintColor     = UIColor.clear
        
        lblBMIDisclaimer.isHidden = true
        lblCalorieDisclaimer.isHidden = true
    }
    
    private func setup(tblView: UITableView) {
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
    }
    
    private func initPicker(){
        self.pickerDays.delegate            = self
        self.pickerDays.dataSource          = self
        self.txtSetWeightDays.delegate      = self
        self.txtSetWeightDays.inputView     = self.pickerDays
        
        self.pickerHeight.delegate          = self
        self.pickerHeight.dataSource        = self
        self.txtHeightUnit.delegate         = self
        self.txtHeightUnit.inputView        = self.pickerHeight
        
        self.pickerWeight.delegate          = self
        self.pickerWeight.dataSource        = self
        self.txtWeightUnit.delegate         = self
        self.txtWeightUnit.inputView        = self.pickerWeight
    }
    
    //MARK: -------------------------- Action Methods --------------------------
    func manageActionMethods(){
        self.btnSkip.addTapGestureRecognizer {
            let vc = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnUpdate.addTapGestureRecognizer {
            var activity_level = ""
            for item in self.arrData {
                if item["isSelected"].intValue == 1 {
                    activity_level = item["key"].stringValue
                }
            }
            
            let result = GFunction.shared.getFinalHeightWeight(heightUnit: GFunction.shared.getUnit(from: self.arrHeightUnit),
                                                               weightUnit: GFunction.shared.getUnit(from: self.arrWeightUnit),
                                                               heightCm: self.txtHeightCm.text!,
                                                               heightFt: self.txtHeightFt.text!,
                                                               heightIn: self.txtHeightIn.text!,
                                                               weight: self.txtWeight.text!,
                                                               goalWeight: self.txtSetWeight.text!)
            
            self.viewModel.apiCall(vc: self,
                                   heightUnit: GFunction.shared.getUnit(from: self.arrHeightUnit),
                                   weightUnit: GFunction.shared.getUnit(from: self.arrWeightUnit),
                                   heightCm: result.height,
                                   heightFt: self.txtHeightFt.text!,
                                   heightIn: self.txtHeightIn.text!,
                                   weightKg: result.weight,
                                   weightLbs: self.txtWeight.text!,
                                   setWeightKg: result.setWeight,
                                   setWeightLbs: self.txtSetWeight.text!,
                                   setWeightDays: self.txtSetWeightDays.text!,
                                   activity_level: activity_level,
                                   weightMonthsModel: self.selectedMonths)
        }
    }
}

//MARK: -------------------------- TableView Methods --------------------------
extension AddWeightHeightVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : AddWeightHeightCell = tableView.dequeueReusableCell(withClass: AddWeightHeightCell.self, for: indexPath)
        let object          = self.arrData[indexPath.row]
        cell.lblTitle.text  = object["name"].stringValue
        cell.lblDesc.text   = object["desc"].stringValue
        
        cell.btnSelect.isSelected = false
        if object["isSelected"].intValue == 1 {
            cell.btnSelect.isSelected = true
        }
            
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object          = self.arrData[indexPath.row]

        for i in 0...self.arrData.count - 1 {
            var obj  = self.arrData[i]
            
            obj["isSelected"] = 0
            if obj["name"].stringValue == object["name"].stringValue {
                obj["isSelected"] = 1
            }
            self.arrData[i] = obj
        }
        
        self.tblView.reloadData()
        self.updateDisclaimer(heightCm: self.txtHeightCm.text!,
                              heightFt: self.txtHeightFt.text!,
                              heightIn: self.txtHeightIn.text!,
                              weight: self.txtWeight.text!,
                              goalWeight: self.txtSetWeight.text!)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension AddWeightHeightVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = ""//self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension AddWeightHeightVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            DispatchQueue.main.async {
                self.tblViewHeight.constant = newvalue.height
                UIView.animate(withDuration: kAnimationSpeed) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblView else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------- UITextField Delegate --------------------
extension AddWeightHeightVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateAPIData(withLoader: false)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
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
            
        case self.txtSetWeightDays:
            
            let heightUnitVal   = HeightUnit.init(rawValue: GFunction.shared.getUnit(from: self.arrHeightUnit)) ?? .cm
            let weightUnitVal   = WeightUnit.init(rawValue: GFunction.shared.getUnit(from: self.arrWeightUnit)) ?? .kg
            
            if txtHeightCm.text!.trim() == "" && txtHeightFt.text!.trim() == ""{
                Alert.shared.showSnackBar(AppError.validation(type: .enterHeight).errorDescription ?? "")
                return false
            }
             
            switch heightUnitVal {
                
            case .cm:
                if JSON(self.txtHeightCm.text!).intValue > kMaxHeightCm || JSON(self.txtHeightCm.text!).intValue < kMinHeightCm{
                    Alert.shared.showSnackBar(AppError.validation(type: .enterValidHeightCm).errorDescription ?? "")
                    return false
                }
                break
            case .feet_inch:
                if (JSON(self.txtHeightFt.text!).intValue >= kMaxHeightFt && JSON(self.txtHeightIn.text!).intValue > 0)
                    || JSON(self.txtHeightFt.text!).intValue < kMinHeightFt{
                    Alert.shared.showSnackBar(AppError.validation(type: .enterValidHeightFt).errorDescription ?? "")
                    return false
                }
                else if self.txtHeightIn.text!.trim() == ""{
                    Alert.shared.showSnackBar(AppError.validation(type: .enterHeight).errorDescription ?? "")
                    return false
                }
                break
            }
            
            if self.txtWeight.text!.trim() == ""{
                Alert.shared.showSnackBar(AppError.validation(type: .enterWeight).errorDescription ?? "")
                return false
            }
            
            switch weightUnitVal {
            case .kg:
                if JSON(self.txtWeight.text!).doubleValue > JSON(kMaxBodyWeightKg).doubleValue ||
                            JSON(self.txtWeight.text!).doubleValue < JSON(kMinBodyWeightKg).doubleValue {
                    Alert.shared.showSnackBar(AppError.validation(type: .enterValidWeightKg).errorDescription ?? "")
                    return false
                }
                break
            case .lbs:
                if JSON(self.txtWeight.text!).doubleValue > JSON(kMaxBodyWeightLbs).doubleValue ||
                            JSON(self.txtWeight.text!).doubleValue < JSON(kMinBodyWeightLbs).doubleValue {
                        Alert.shared.showSnackBar(AppError.validation(type: .enterValidWeightLbs).errorDescription ?? "")
                    return false
                }
                break
            }
            
            if self.txtSetWeight.text!.trim() == ""{
                Alert.shared.showSnackBar(AppError.validation(type: .enterSetWeight).errorDescription ?? "")
                return false
            }
            
            switch weightUnitVal {
            case .kg:
                if JSON(self.txtSetWeight.text!).doubleValue > JSON(kMaxBodyWeightKg).doubleValue ||
                            JSON(self.txtSetWeight.text!).doubleValue < JSON(kMinBodyWeightKg).doubleValue {
                    Alert.shared.showSnackBar(AppError.validation(type: .enterValidSetWeightKg).errorDescription ?? "")
                    return false
                }
                break
            case .lbs:
                if JSON(self.txtSetWeight.text!).doubleValue > JSON(kMaxBodyWeightLbs).doubleValue ||
                            JSON(self.txtSetWeight.text!).doubleValue < JSON(kMinBodyWeightLbs).doubleValue {
                        Alert.shared.showSnackBar(AppError.validation(type: .enterValidSetWeightLbs).errorDescription ?? "")
                    return false
                }
                break
            }
            
            
            if self.txtSetWeightDays.text?.trim() == ""
                && self.viewModel.getCount() > 0{
                
                    self.selectedMonths         = self.viewModel.getObject(index: 0)
                    self.txtSetWeightDays.text  = self.selectedMonths.months
                }
                return true
            
            
        default: return true
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        
        switch textField {
        case self.txtHeightCm:
            
            self.txtSetWeightDays.text  = ""
            self.selectedMonths         =  WeightMonthsModel()
            self.updateDisclaimer(heightCm: newText,
                                  heightFt: self.txtHeightFt.text!,
                                  heightIn: self.txtHeightIn.text!,
                                  weight: self.txtWeight.text!,
                                  goalWeight: self.txtSetWeight.text!)
            return NSPredicate(format: "SELF MATCHES %@", Validations.RegexType.OnlyNumber.rawValue).evaluate(with: newText)
            
        case self.txtHeightFt:
            
            self.txtSetWeightDays.text  = ""
            self.selectedMonths         =  WeightMonthsModel()
            self.updateDisclaimer(heightCm: self.txtHeightCm.text!,
                                  heightFt: newText,
                                  heightIn: self.txtHeightIn.text!,
                                  weight: self.txtWeight.text!,
                                  goalWeight: self.txtSetWeight.text!)
            return NSPredicate(format: "SELF MATCHES %@", Validations.RegexType.OnlyNumber.rawValue).evaluate(with: newText)
            
            
        case self.txtHeightIn:
            
            self.txtSetWeightDays.text  = ""
            self.selectedMonths         =  WeightMonthsModel()
            self.updateDisclaimer(heightCm: self.txtHeightCm.text!,
                                  heightFt: self.txtHeightFt.text!,
                                  heightIn: newText,
                                  weight: self.txtWeight.text!,
                                  goalWeight: self.txtSetWeight.text!)
            
            return NSPredicate(format: "SELF MATCHES %@", Validations.RegexType.OnlyNumber.rawValue).evaluate(with: newText) &&
            Int(newText) < 12
            

        case self.txtWeight:
            let weightUnit = GFunction.shared.getUnit(from: self.arrWeightUnit)
            self.txtSetWeightDays.text  = ""
            self.selectedMonths         =  WeightMonthsModel()
            self.updateDisclaimer(heightCm: self.txtHeightCm.text!,
                                  heightFt: self.txtHeightFt.text!,
                                  heightIn: self.txtHeightIn.text!,
                                  weight: newText,
                                  goalWeight: self.txtSetWeight.text!)
            
            if WeightUnit.init(rawValue: weightUnit) == .kg {
                return NSPredicate(format: "SELF MATCHES %@", newText.decimalRegex(maxLength: Int(kMaxBodyWeightKg.size + 20), decimalLength: 1)).evaluate(with: newText)
            }
            else {
                return NSPredicate(format: "SELF MATCHES %@", newText.decimalRegex(maxLength: Int(kMaxBodyWeightLbs.size + 20), decimalLength: 1)).evaluate(with: newText)
            }
            
        case self.txtSetWeight:
            let weightUnit = GFunction.shared.getUnit(from: self.arrWeightUnit)
            self.txtSetWeightDays.text  = ""
            self.selectedMonths         =  WeightMonthsModel()
            self.updateDisclaimer(heightCm: self.txtHeightCm.text!,
                                  heightFt: self.txtHeightFt.text!,
                                  heightIn: self.txtHeightIn.text!,
                                  weight: self.txtWeight.text!,
                                  goalWeight: newText)
            if WeightUnit.init(rawValue: weightUnit) == .kg {
                return NSPredicate(format: "SELF MATCHES %@", newText.decimalRegex(maxLength: Int(kMaxBodyWeightKg.size + 20), decimalLength: 1)).evaluate(with: newText)
            }
            else {
                return NSPredicate(format: "SELF MATCHES %@", newText.decimalRegex(maxLength: Int(kMaxBodyWeightLbs.size + 20), decimalLength: 1)).evaluate(with: newText)
            }
            
        default:break
        }
        
        return true
    }
    
    func updateAPIData(withLoader: Bool){
     
        let result = GFunction.shared.getFinalHeightWeight(heightUnit: GFunction.shared.getUnit(from: self.arrHeightUnit),
                                                           weightUnit: GFunction.shared.getUnit(from: self.arrWeightUnit),
                                                           heightCm: self.txtHeightCm.text!,
                                                           heightFt: self.txtHeightFt.text!,
                                                           heightIn: self.txtHeightIn.text!,
                                                           weight: self.txtWeight.text!,
                                                           goalWeight: self.txtSetWeight.text!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            //self.apiCallFromStart(search: newText, withLoader: false)
            self.viewModel.calculate_bmr_monthsAPI(withLoader: withLoader,
                                                   height: result.height,
                                                   current_weight: result.weight,
                                                   goal_weight: result.setWeight) { [weak self] isDone in
                guard let self = self else {return}
                
                if isDone {
                   self.pickerDays.reloadAllComponents()
                }
                else {
                   self.txtSetWeightDays.resignFirstResponder()
                }
            }
        }
    }
}

//MARK: --------------------- UIPickerVIew Method ---------------------
extension AddWeightHeightVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerDays:
            return self.viewModel.getCount()
        case self.pickerWeight:
            return self.arrWeightUnit.count
        case self.pickerHeight:
            return self.arrHeightUnit.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerDays:
            return self.viewModel.getObject(index: row).months
        case self.pickerWeight:
            return self.arrWeightUnit[row].unitTitle
        case self.pickerHeight:
            return self.arrHeightUnit[row].unitTitle
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pickerDays:
            self.selectedMonths         = self.viewModel.getObject(index: row)
            self.txtSetWeightDays.text  = self.selectedMonths.months
            self.updateDisclaimer(heightCm: self.txtHeightCm.text!,
                                  heightFt: self.txtHeightFt.text!,
                                  heightIn: self.txtHeightIn.text!,
                                  weight: self.txtWeight.text!,
                                  goalWeight: self.txtSetWeight.text!)
            
            break
       
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
            
//            let obj = self.arrHeightUnit[row]
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

//MARK: -------------------- Set Data method --------------------
extension AddWeightHeightVC {
    
    func setData(){
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
        
        ///set unit values
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
        
        if Float(UserModel.shared.height) > 0{
            self.txtHeightCm.text = String(format: "%0.0f", Float(UserModel.shared.height) ?? 0)
        }
        if Float(UserModel.shared.weight) > 0 {
//            self.txtWeight.text = String(format: "%0.0f", Float(UserModel.shared.weight) ?? 0)
            self.txtWeight.text = "\((Double(UserModel.shared.weight) ?? 0).floorToPlaces(places: 1))"
        }
        
        if UserModel.shared.bmrDetails != nil &&
            UserModel.shared.bmrDetails.goalWeight != nil {
            if Float(UserModel.shared.bmrDetails.goalWeight) > 0 {
//                self.txtSetWeight.text = String(format: "%0.0f", Float(UserModel.shared.bmrDetails.goalWeight) ?? 0)
                self.txtSetWeight.text = "\((Double(UserModel.shared.bmrDetails.goalWeight) ?? 0).floorToPlaces(places: 1))"
            }
            self.txtSetWeightDays.text = UserModel.shared.bmrDetails.months
            
            for i in 0...self.arrData.count - 1 {
                var obj = self.arrData[i]
                obj["isSelected"].intValue = 0
                if obj["key"].stringValue == UserModel.shared.bmrDetails.activityLevel {
                    obj["isSelected"].intValue = 1
                }
                self.arrData[i] = obj
            }
            
            self.selectedMonths.months  = UserModel.shared.bmrDetails.months
            self.selectedMonths.rate    = JSON(UserModel.shared.bmrDetails.rate as Any).floatValue
            self.selectedMonths.type    = UserModel.shared.bmrDetails.type
            
            self.tblView.reloadData()
            
            self.updateAPIData(withLoader: true)
        }
       
        self.updateHeightUI()
        self.calculateHeightValue(isAllowChange: false)
        self.calculateWeightValue(isAllowChange: false)
        self.btnSkip.isHidden = self.isEdit
    }
    
    fileprivate func updateHeightUI(){
        let currentUnit = GFunction.shared.getUnit(from: self.arrHeightUnit)
        
        if currentUnit == HeightUnit.cm.rawValue {
            self.stackHeightFtInch.isHidden     = true
            self.txtHeightFt.isHidden           = true
            self.txtHeightIn.isHidden           = true
            self.vwHeightCm.isHidden            = false
        }
        else {
            self.stackHeightFtInch.isHidden     = false
            self.txtHeightFt.isHidden           = false
            self.txtHeightIn.isHidden           = false
            self.vwHeightCm.isHidden            = true
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
                if self.txtWeight.text?.trim() != "" {
                    let weight = GFunction.shared.convertWeight(toLbs: false,
                                                                value: JSON(self.txtWeight.text!).doubleValue)
    //                self.txtWeight.text = String(format:"%0.f",weight)
                    self.txtWeight.text = "\(weight.floorToPlaces(places: 1))"
                }
                else {
                    self.txtWeight.text = ""
                }
                
                
                if self.txtSetWeight.text?.trim() != "" {
                    let weight = GFunction.shared.convertWeight(toLbs: false,
                                                                value: JSON(self.txtSetWeight.text!).doubleValue)
//                    self.txtSetWeight.text = String(format:"%0.f",weight)
                    self.txtSetWeight.text = "\(weight.floorToPlaces(places: 1))"
                }
                else {
                    self.txtSetWeight.text = ""
                }
            }
            
            break
        case .lbs:
            if self.txtWeight.text?.trim() != "" {
                let weight = GFunction.shared.convertWeight(toLbs: true,
                                                            value: JSON(self.txtWeight.text!).doubleValue)
    //            self.txtWeight.text = String(format:"%0.f",weight)
                self.txtWeight.text = "\(weight.floorToPlaces(places: 1))"
            }
            else {
                self.txtWeight.text = ""
            }
            
            if self.txtSetWeight.text?.trim() != "" {
                let weight = GFunction.shared.convertWeight(toLbs: true,
                                                            value: JSON(self.txtSetWeight.text!).doubleValue)
//                self.txtSetWeight.text = String(format:"%0.f",weight)
                self.txtSetWeight.text = "\(weight.floorToPlaces(places: 1))"
            }
            else {
                self.txtSetWeight.text = ""
            }
            break
        }
    }
    
    fileprivate func updateDisclaimer(heightCm: String,
                                      heightFt: String,
                                      heightIn: String,
                                      weight: String,
                                      goalWeight: String){
        
        let result = GFunction.shared.getFinalHeightWeight(heightUnit: GFunction.shared.getUnit(from: self.arrHeightUnit),
                                                           weightUnit: GFunction.shared.getUnit(from: self.arrWeightUnit),
                                                           heightCm: heightCm,
                                                           heightFt: heightFt,
                                                           heightIn: heightIn,
                                                           weight: weight,
                                                           goalWeight: goalWeight)
        
        ///Check for activity level
        var activity_level = ""
        for item in self.arrData {
            if item["isSelected"].intValue == 1 {
                activity_level = item["key"].stringValue
            }
        }
        
        self.lblBMIDisclaimer.isHidden = true
        self.lblCalorieDisclaimer.isHidden = true
        self.timerAPI.invalidate()
        self.timerAPI = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.viewModel.check_bmr_disclaimerAPI(withLoader: false,
                                                   height: result.height,
                                                   current_weight: result.weight,
                                                   goal_weight: result.setWeight,
                                                   activity_level: activity_level,
                                                   weightMonthsModel: self.selectedMonths) { [weak self] isDone, bmi, bmr in
                guard let self = self else {return}
                if isDone {
                    if bmi.trim() != "" ||
                        bmr.trim() != "" {
                    
                        self.lblBMIDisclaimer.text      = bmi
                        self.lblCalorieDisclaimer.text  = bmr
                        
                        UIView.animate(withDuration: kAnimationSpeed, delay: 0, options: [.curveEaseIn]) {
                            self.lblBMIDisclaimer.isHidden = false
                            self.lblCalorieDisclaimer.isHidden = false
                            self.view.layoutIfNeeded()
                        } completion: { isDone in
                        }
                    }
                }
            }
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension AddWeightHeightVC {
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                
                FIRAnalytics.FIRLogEvent(eventName: .HEIGHT_WEIGHT_ADDED,
                                         screen: .SetHeightWeight,
                                         parameter: nil)
            
                GlobalAPI.shared.getPatientDetailsAPI(withLoader: true) { [weak self]  (isDone) in
                    guard let self = self else {return}
                    if self.isEdit {
                        self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        let vc = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
                        self.navigationController?.pushViewController(vc, animated: true)
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
