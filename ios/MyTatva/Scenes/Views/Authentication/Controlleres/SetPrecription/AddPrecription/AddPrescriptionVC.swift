//

import UIKit

class AddPrescriptionVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblAddPrecription        : UILabel!
    
    @IBOutlet weak var lblMedicineName          : UILabel!
    @IBOutlet weak var txtMedicineName          : UITextField!
    @IBOutlet weak var vwMedicineName           : UIView!
    
    @IBOutlet weak var lblSuggestedDose         : UILabel!
    @IBOutlet weak var txtSuggestedDose         : UITextField!
    @IBOutlet weak var vwSuggestedDose          : UIView!
    @IBOutlet weak var colSuggestedDose         : UICollectionView!
    
    @IBOutlet weak var lblStartDate             : UILabel!
    @IBOutlet weak var txtStartDate             : UITextField!
    @IBOutlet weak var vwStartDate              : UIView!
    @IBOutlet weak var lblEndDate               : UILabel!
    @IBOutlet weak var txtEndDate               : UITextField!
    @IBOutlet weak var vwEndDate                : UIView!
    
    @IBOutlet weak var vwDaySelection           : UIView!
    @IBOutlet weak var lblDaySelection          : UILabel!
    @IBOutlet weak var txtDaySelection          : UITextField!
    
    @IBOutlet weak var btnAddAnotherMedication  : UIButton!
    @IBOutlet weak var colMedication            : UICollectionView!
    
    @IBOutlet weak var lblPrecription           : UILabel!
    @IBOutlet weak var btnAddPrecription        : UIButton!
    @IBOutlet weak var colPrecription           : UICollectionView!
    
    @IBOutlet weak var btnSubmit                : UIButton!
    @IBOutlet weak var btnSkip                  : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel               = AddPrecriptionVM()
    
    var startDatePicker                 = UIDatePicker()
    var endDatePicker                   = UIDatePicker()
    var dateFormatter                   = DateFormatter()
    //var dateFormat                      = DateTimeFormaterEnum.ddmm_yyyy.rawValue
    var arrSelectedDays                 = [DaysListModel]()
    var arrSelectedDose                 = [DoseListModel]()
    var isEdit                          = false
    var objcet                          = MyPrescriptionDataModel()
    var medicine_id                     = ""
    var arrSuggestedDose : [DoseTimeslotModel] = []
//        [
//            "time": "10:00 AM",
//            "is_select": 0
//        ],
//        [
//            "time": "02:00 AM",
//            "is_select": 0
//        ],
//        [
//            "time": "04:00 AM",
//            "is_select": 0
//        ]
//    ]
    var arrMedication : [MedicineData] = []
//        [
//            "dose_id": "71e737c3-196b-11ec-9978-a87eea410734",
//            "medicine_name": "medicine_name",
//            "start_date": "2021-01-01",
//            "end_date": "2021-12-12",
//            "dose_days": "M,T,W,TH,F,S,SU",
//            "dose_time_slot": ["10:00","14:00","18:00"],
//            "time": "3 times a day",
//        ],
//        [
//            "name": "Forglyn",
//            "time": "3 times a day",
//            "is_select": 0
//        ],
//    ]
    
    var arrPrecription : [DocumentDataModel] = []
//    var arrPrecription : [JSON] = [
//        [
//            "img": "b1",
//            "name": "Prescription name",
//            "time": "Aug 02, 2021",
//            "is_select": 0
//        ],
//        [
//            "img": "b1",
//            "name": "Prescription abc",
//            "time": "Aug 03, 2021",
//            "is_select": 0
//        ],
//        [
//            "img": "b1",
//            "name": "Prescription xyz",
//            "time": "Aug 04, 2021",
//            "is_select": 0
//        ],
//        [
//            "img": "b1",
//            "name": "Prescription test",
//            "time": "Aug 05, 2021",
//            "is_select": 0
//        ],
//        [
//            "img": "b1",
//            "name": "Prescription name",
//            "time": "Aug 06, 2021",
//            "is_select": 0
//        ]
//    ]
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupViewModelObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        WebengageManager.shared.navigateScreenEvent(screen: .SetUpDrugs)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .SetUpDrugs, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAnalytics.manageTimeSpent(on: .SetUpDrugs, when: .Disappear)
    }
    
    
    @IBAction func onGoBack(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
       }
    
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        self.applyStyle()
        self.initDatePicker()
        self.manageActionMethods()
        self.arrSuggestedDose.removeAll()
        
        self.btnSubmit.setTitle(AppMessages.Next, for: .normal)
        DispatchQueue.main.async {
            if self.isEdit {
                self.btnSubmit.setTitle(AppMessages.Update, for: .normal)
                self.btnSkip.isHidden = true
                self.viewModel.get_prescription_detailsAPI(isActiveMedicineOnly: "N") { [weak self] (isDone, object, msg) in
                    guard let self = self else {return}
                    if isDone {
                        self.objcet = object
                        self.arrMedication = object.medicineData
                        self.arrPrecription = object.documentData
                        self.colMedication.reloadData()
                        self.colPrecription.reloadData()
                    }
                }
            }
        }
        
        
        self.txtDaySelection.delegate = self
        self.txtSuggestedDose.delegate = self
        
        self.dateFormatter.dateFormat   = appDateFormat
        self.txtStartDate.text          = self.dateFormatter.string(from: Date())
        let endDate                     = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        self.txtEndDate.text            = self.dateFormatter.string(from: endDate ?? Date())
        
//        self.txtMobile.regex            = Validations.RegexType.OnlyNumber.rawValue
//        self.txtMobile.maxLength        = Validations.PhoneNumber.Maximum.rawValue
//        self.txtMobile.keyboardType     = .numberPad
    }
    
    private func applyStyle() {
        self.lblAddPrecription.font(name: .bold, size: 20).textColor(color: .themeBlack)
        
        self.lblMedicineName.font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.txtMedicineName.setRightImage(img: UIImage(named: "search_ic"))
        self.txtMedicineName.delegate = self
        
        self.lblSuggestedDose.font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.txtSuggestedDose.setRightImage(img: UIImage(named: "IconDownArrow"))
        
        self.lblStartDate.font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.lblEndDate.font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.lblDaySelection.font(name: .medium, size: 16).textColor(color: .themeBlack)
        
        self.btnAddAnotherMedication
            .font(name: .medium, size: 14).textColor(color: .themePurple)
            .cornerRadius(cornerRadius: 5)
            .borderColor(color: UIColor.themePurple, borderWidth: 1)
        
        self.lblPrecription.font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.btnAddPrecription.font(name: .medium, size: 14).textColor(color: .themePurple)
        
        self.btnSkip.font(name: .medium, size: 16).textColor(color: .themePurple)
        
        DispatchQueue.main.async {
            self.setup(collectionView: self.colSuggestedDose)
            self.setup(collectionView: self.colMedication)
            self.setup(collectionView: self.colPrecription)
        }
    }
    
    func setup(collectionView: UICollectionView){
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    //------------------------------------------------------
    
    //MARK:- Action Method
    private func manageActionMethods(){
        
        self.btnAddAnotherMedication.addTapGestureRecognizer {
            if self.txtMedicineName.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .enterMedicineName).errorDescription ?? "")
            }
            else if self.txtSuggestedDose.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .selectDosage).errorDescription ?? "")
            }
            else if self.txtStartDate.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .selectStartDate).errorDescription ?? "")
            }
            else if self.txtEndDate.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .selectEndDate).errorDescription ?? "")
            }
            else if self.txtDaySelection.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .selectDays).errorDescription ?? "")
            }
            else {
                //SUCCESS
                let object = MedicineData()
                var obj: JSON = [
                    "dose_id": "71e737c3-196b-11ec-9978-a87eea410734",
                    "medicine_name": "medicine_name",
                    "start_date": "2021-01-01",
                    "end_date": "2021-12-12",
                    "dose_days": "M,T,W,TH,F,S,SU",
                    "dose_time_slot": ["10:00","14:00","18:00"],
                    "time": "3 times a day",
                ]
                
                object.doseId           = self.arrSelectedDose.first?.doseMasterId ?? ""
                object.medicineName     = self.txtMedicineName.text!
                object.medecineId       = self.medicine_id
                
                let start_dt = GFunction.shared.convertDateFormate(dt: self.txtStartDate.text!,
                                                                   inputFormat: appDateFormat,
                                                               outputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                               status: .NOCONVERSION)
                
                object.startDate       = start_dt.0
                
                let end_dt = GFunction.shared.convertDateFormate(dt: self.txtEndDate.text!,
                                                                   inputFormat: appDateFormat,
                                                               outputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                               status: .NOCONVERSION)
                
                object.endDate = end_dt.0
                
                
                let arr : [String] = self.arrSelectedDays.map { (object) -> String in
                    return String(object.daysKeys)
                }
                
                object.doseDays = arr.joined(separator: ",")
                
                var arrSlot: [String] = []
                for item in self.arrSuggestedDose {
                    let time = GFunction.shared.convertDateFormate(dt: item.time,
                                                                   inputFormat: appTimeFormat,
                                                                   outputFormat: DateTimeFormaterEnum.HHmm.rawValue,
                                                                   status: .NOCONVERSION)
                    arrSlot.append(time.0)
                }
                object.doseTimeSlot = arrSlot//arrSlot.joined(separator: ",")
                object.doseType = self.txtSuggestedDose.text!
                
                self.arrMedication.append(object)
                self.colMedication.reloadData()
                
                self.txtMedicineName.text = ""
                self.txtSuggestedDose.text = ""
                self.txtStartDate.text = ""
                self.txtEndDate.text = ""
                self.txtDaySelection.text = ""
                self.arrSuggestedDose.removeAll()
                self.colSuggestedDose.reloadData()
                self.arrSelectedDose.removeAll()
                self.arrSelectedDays.removeAll()
            }
        }
        
        self.btnSkip.addTapGestureRecognizer {
//            let vc = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
//            self.navigationController?.pushViewController(vc, animated: true)
            let vc = AddWeightHeightVC.instantiate(fromAppStoryboard: .auth)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnAddPrecription.addTapGestureRecognizer {
            DispatchQueue.main.async {
                ImagePickerController(isAllowEditing: true) { [weak self] (pickedImage) in
                    
                    let obj = DocumentDataModel()
                    obj.image = pickedImage
                    self?.arrPrecription.append(obj)
                    self?.colPrecription.reloadData()
                }.present()
            }
        }
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        if self.isEdit {
            self.viewModel.apiCall(vc: self,
                                   arrPreciption: self.arrPrecription,
                                   arrMedication: self.arrMedication,
                                   isEdit: true)
        }
        else {
            self.viewModel.apiCall(vc: self,
                                   arrPreciption: self.arrPrecription,
                                   arrMedication: self.arrMedication,
                                   isEdit: false)
        }
    }
}

//MARK: -------------------- Date picker methods --------------------
extension AddPrescriptionVC {
    
    func initDatePicker(){
       
        self.txtStartDate.inputView             = self.startDatePicker
        self.txtStartDate.delegate              = self
        self.startDatePicker.datePickerMode     = .date
        self.startDatePicker.minimumDate        =  Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.startDatePicker.timeZone           = .current
        self.startDatePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
        
        self.txtEndDate.inputView               = self.endDatePicker
        self.txtEndDate.delegate                = self
        self.endDatePicker.datePickerMode       = .date
        self.endDatePicker.minimumDate          =  Calendar.current.date(byAdding: .month, value: 0, to: Date())
        self.endDatePicker.timeZone             = .current
        self.endDatePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
        
        if #available(iOS 14, *) {
            self.startDatePicker.preferredDatePickerStyle = .wheels
            self.endDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.startDatePicker:
            self.dateFormatter.dateFormat   = appDateFormat
            self.dateFormatter.timeZone     = .current
            self.txtStartDate.text          = self.dateFormatter.string(from: sender.date)
            
            let endDate                     = Calendar.current.date(byAdding: .month, value: 1, to: self.startDatePicker.date)
            self.txtEndDate.text            = self.dateFormatter.string(from: endDate ?? Date())
            
            self.endDatePicker.minimumDate = Calendar.current.date(byAdding: .month, value: 0, to: self.startDatePicker.date)
            break
            
        case self.endDatePicker:
            self.dateFormatter.dateFormat   = appDateFormat
            self.dateFormatter.timeZone     = .current
            self.txtEndDate.text            = self.dateFormatter.string(from: sender.date)
            break
     
        default:break
        }
    }
    
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension AddPrescriptionVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtMedicineName:
            self.view.endEditing(true)
            let vc = SearchMedicineVC.instantiate(fromAppStoryboard: .auth)
            let arrTemp: [JSON] = [
                [
                    "name" : self.txtMedicineName.text!,
                    "short" : "Sun",
                    "isSelected": 0,
                ]
            ]
            vc.arrDaysOffline = arrTemp
            vc.modalPresentationStyle = .overFullScreen
            vc.completionHandler = { obj in
                if obj?.count > 0 {
                    
                    self.txtMedicineName.text   = obj?["name"].stringValue
                    self.medicine_id            = obj?["id"].stringValue ?? ""
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            return false
            
        case self.txtStartDate:
            
            if let _ = self.presentedViewController {
                return false
            }
            else {
                if self.txtStartDate.text?.trim() == "" {
                    self.dateFormatter.dateFormat   = appDateFormat
                    self.dateFormatter.timeZone     = .current
                    self.txtStartDate.text          = self.dateFormatter.string(from: self.startDatePicker.date)
                    
                    let endDate                     = Calendar.current.date(byAdding: .month, value: 1, to: self.startDatePicker.date)
                    self.txtEndDate.text            = self.dateFormatter.string(from: endDate ?? Date())
                    
                    self.endDatePicker.minimumDate = Calendar.current.date(byAdding: .month, value: 0, to: self.startDatePicker.date)
                    //self.txtEndDate.text = ""
                }
                return true
            }
            
            
        case self.txtEndDate:
            
            if let _ = self.presentedViewController {
                return false
            }
            else {
                if self.txtStartDate.text?.trim() == "" {
                    Alert.shared.showSnackBar(AppError.validation(type: .selectStartDate).errorDescription ?? "")
                }
                else {
                    if self.txtEndDate.text?.trim() == "" {
                        self.dateFormatter.dateFormat   = appDateFormat
                        self.dateFormatter.timeZone     = .current
                        self.txtEndDate.text            = self.dateFormatter.string(from: self.endDatePicker.date)
                    }
                }
                
              return true
            }
            
        case self.txtSuggestedDose:
            self.view.endEditing(true)
            let vc = SuggestedDosagePopupVC.instantiate(fromAppStoryboard: .auth)
            vc.arrDoseOffline = self.arrSelectedDose
            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandler = { obj in
                
                if obj != nil {
                    self.arrSelectedDose = [obj!]
                    self.arrSuggestedDose.removeAll()
                    let arrTemp = self.arrSelectedDose.first!.suggestedTimeSlots ?? []
                    
                    if arrTemp.count > 0 {
                        
                        for item in arrTemp {
                            let obj     = DoseTimeslotModel()
                            let time = GFunction.shared.convertDateFormate(dt: item,
                                                                           inputFormat: DateTimeFormaterEnum.HHmm.rawValue,
                                                                           outputFormat: appTimeFormat,
                                                                           status: .NOCONVERSION)
                            obj.time    = time.0
                            self.arrSuggestedDose.append(obj)
                        }
                        self.colSuggestedDose.reloadData()
                    }
                    
                    let arr : [String] = self.arrSelectedDose.map { (object) -> String in
                        return object.doseType
                    }
                    self.txtSuggestedDose.text = arr.joined(separator: ", ")
                }
            }
            self.present(vc, animated: true, completion: nil)
            return false
            
        case self.txtDaySelection:
            self.view.endEditing(true)
            let vc = DaySelectionPopupVC.instantiate(fromAppStoryboard: .auth)
            vc.isFromPrescription = true
            vc.arrDaysOffline = self.arrSelectedDays
            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandler = { obj in
                self.arrSelectedDays = obj ?? []
                if obj?.count > 0 &&
                    obj != nil {
                    
                    let arr : [String] = self.arrSelectedDays.map { (object) -> String in
                        return String(object.day.prefix(3))
                    }
                    self.txtDaySelection.text = arr.joined(separator: ", ")
                }
            }
            self.present(vc, animated: true, completion: nil)
            return false
            
        default:
            break
        }
        
        return true
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension AddPrescriptionVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                FIRAnalytics.FIRLogEvent(eventName: .NEW_USER_MEDICINE_ADDED,
                                         screen: .SetUpDrugs,
                                         parameter: nil)
                
                if self.isEdit {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    let vc = AddWeightHeightVC.instantiate(fromAppStoryboard: .auth)
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

