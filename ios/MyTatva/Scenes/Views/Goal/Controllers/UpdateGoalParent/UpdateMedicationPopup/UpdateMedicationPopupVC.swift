//
//  PheromonePopupVC.swift
//

//

import UIKit

class UpdateMedicationPopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var stackDetails     : UIView!
    
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var txtDate          : UITextField!
    
    @IBOutlet weak var lblProgress      : UILabel!
    @IBOutlet weak var linearProgressBar: LinearProgressBar!
    
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var tblView          : UITableView!
    
    @IBOutlet weak var btnAddMedication : UIButton!

    @IBOutlet weak var vwAddPrescription: UIView!
    @IBOutlet weak var btnAddPrescription: UIButton!
    
    @IBOutlet weak var vwSubmit         : UIView!
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnMarkAllDone   : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    @IBOutlet weak var btnBackTop     : UIButton!
    
    @IBOutlet weak var vwHKConnect      : UIView!
    @IBOutlet weak var lblHKConnect     : UILabel!
    
    //MARK:- Class Variable
    private let viewModel                   = UpdateMedicationPopupVM()
    private let addPrecriptionVM            = AddPrecriptionVM()
    private var readingType: ReadingType    = .HeartRate
    var goalListModel                       = GoalListModel()
    private var myIndex : Int               = 0
    private var arrList                     = [GoalListModel]()
    private var isNext                      = false
    private var strErrorMessage             = ""
    
    private var datePicker                  = UIDatePicker()
    private var dateFormatter               = DateFormatter()
    
    private var completionHandler: ((_ obj : JSON?) -> Void)?
    private var arrData : [JSON] = [
        [
            "img" : "medicine_temp",
            "name" : "Formonide",
            "dose_list": [
                [
                    "name" : "05:00 AM",
                    "isSelected": 1,
                ],
                [
                    "name" : "06:00 AM",
                    "isSelected": 1,
                ],
                [
                    "name" : "08:00 AM",
                    "isSelected": 0,
                ],
                [
                    "name" : "10:00 PM",
                    "isSelected": 1,
                ]
            ],
            "isSelected": 0,
        ],
        [
            "img" : "medicine_temp",
            "name" : "Forglyn",
            "dose_list": [
                [
                    "name" : "05:00 AM",
                    "isSelected": 1,
                ],
                [
                    "name" : "06:00 AM",
                    "isSelected": 0,
                ],
                [
                    "name" : "08:00 AM",
                    "isSelected": 1,
                ],
                [
                    "name" : "10:00 PM",
                    "isSelected": 1,
                ]
            ],
            "isSelected": 0,
        ],
        [
            "img" : "medicine_temp",
            "name" : "Formonide",
            "dose_list": [
                [
                    "name" : "05:00 AM",
                    "isSelected": 0,
                ],
                [
                    "name" : "06:00 AM",
                    "isSelected": 0,
                ],
                [
                    "name" : "08:00 AM",
                    "isSelected": 1,
                ],
                [
                    "name" : "10:00 PM",
                    "isSelected": 0,
                ]
            ],
            "isSelected": 0,
        ]
    ]
    
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
        
        self.lblTitle.font(name: .semibold, size: 18)
            .textColor(color: UIColor.themeBlack)
        self.txtDate.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack)
        self.txtDate.delegate = self
        self.lblProgress.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.btnAddMedication.font(name: .medium, size: 12)
            .textColor(color: UIColor.themePurple)
        self.btnAddPrescription.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
        
        self.btnMarkAllDone.font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
            .borderColor(color: UIColor.themePurple, borderWidth: 1)
            .cornerRadius(cornerRadius: 7)
            .backGroundColor(color: UIColor.white)
        
        self.btnSubmit.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
            
        //self.setProgress(progressBar: self.linearProgressBar, color: UIColor.colorMedication)
        
//        GFunction.shared.setUpHealthKitConnectionLabel(vw: self.vwHKConnect, lbl: self.lblHKConnect){ (isDone) in
//            if isDone {
//            }
//        }
        
        self.vwBg.animateBounce()
        self.openPopUp()
        self.setData()
        self.configureUI()
        self.manageActionMethods()
        self.setupViewModelObserver()
        self.initDatePicker()
    }
    
    fileprivate func configureUI(){
        DispatchQueue.main.async {
           
            self.tblView.tableFooterView        = UIView.init(frame: CGRect.zero)
            self.tblView.emptyDataSetSource     = self
            self.tblView.emptyDataSetDelegate   = self
            self.tblView.delegate               = self
            self.tblView.dataSource             = self
            self.tblView.rowHeight              = UITableView.automaticDimension
            self.tblView.reloadData()
        }
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.btnSubmit.layoutIfNeeded()
            self.btnMarkAllDone.layoutIfNeeded()
            self.btnAddMedication.layoutIfNeeded()
            self.btnAddPrescription.layoutIfNeeded()
            
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.btnSubmit
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnMarkAllDone
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.white)
            
            self.btnAddMedication
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.white)
            
            self.btnAddPrescription
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)
        }
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
        
        self.btnSubmit.addTapGestureRecognizer {
            if self.viewModel.getCount() > 0 {
                self.viewModel.apiUpdateData(vc: self,
                                             medication_date: self.txtDate.text!,
                                             goalMasterId: self.goalListModel.goalMasterId)
            }
            else {
                Alert.shared.showSnackBar(AppError.validation(type: .AddPrescription).errorDescription ?? "")
            }
        }
        
        self.btnMarkAllDone.addTapGestureRecognizer {
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_MARK_ALL_AS_DONE,
                                     screen: .LogGoal,
                                     parameter: nil)
            self.viewModel.markAllData()
            self.tblView.reloadData()
        }
        
        self.btnBackTop.addTapGestureRecognizer {
            var obj         = JSON()
            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: obj)
        }
        
        self.btnCancelTop.addTapGestureRecognizer {
            var obj         = JSON()
            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: obj)
        }
        
        func localAddPrescription(){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                PlanManager.shared.isAllowedByPlan(type: .add_medication,
                                                   sub_features_id: "",
                                                   completion: { isAllow in
                    if isAllow {
                        let vc = AddPrescriptionVC.instantiate(fromAppStoryboard: .auth)
                        vc.isEdit = true
                        vc.hidesBottomBarWhenPushed = true
                        (sceneDelegate.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: true)
                        
                        let obj         = JSON()
                        self.dismissPopUp(false, objAtIndex: obj)
                    }
                    else {
                        PlanManager.shared.alertNoSubscription()
                    }
                })
            }
        }
        
        self.btnAddPrescription.addTapGestureRecognizer {
            localAddPrescription()
        }
        
        self.btnAddMedication.addTapGestureRecognizer {
            localAddPrescription()
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
        
        self.vwAddPrescription.isHidden     = true
        self.stackDetails.isHidden          = true
        self.vwSubmit.isHidden              = true
        self.addPrecriptionVM.get_prescription_detailsAPI(isActiveMedicineOnly: "Y") { [weak self] (isDone, object, msg) in
            guard let self = self else {return}
            if isDone {
                if object.medicineData.count > 0 {
                    self.strErrorMessage                = ""
                    self.vwAddPrescription.isHidden     = true
                    self.stackDetails.isHidden          = false
                    self.vwSubmit.isHidden              = false
                    
                    self.viewModel.apiCallFromStart(medication_date: self.txtDate.text!,
                                                    refreshControl: nil,
                                                    tblView: self.tblView,
                                                    withLoader: true)
                }
                else {
                    self.strErrorMessage                = AppMessages.NoPrescriptionMedication
                    self.vwAddPrescription.isHidden     = false
                    self.stackDetails.isHidden          = true
                    self.vwSubmit.isHidden              = true
                    self.tblView.reloadData()
                }
                
                UIView.animate(withDuration: kAnimationSpeed) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        FIRAnalytics.FIRLogEvent(eventName: .USER_LOGGOAL_MEDICINE_CONTENTVIEW,
                                 screen: .LogGoal,
                                 parameter: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
       
    @IBAction func onGoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension UpdateMedicationPopupVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UpdateMedicationPopupCell = tableView.dequeueReusableCell(withClass: UpdateMedicationPopupCell.self, for: indexPath)

        let object = self.viewModel.getObject(index: indexPath.row)
        //cell.arrData = object["dose_list"].arrayValue
        cell.object = object
        cell.colMedicationDosage.reloadData()
        
        DispatchQueue.main.async {
            cell.vwBg.layoutIfNeeded()
            
            if indexPath.row % 2 == 0 {
                cell.vwBg
                    .backGroundColor(color: UIColor.white)
            }
            else {
                cell.vwBg
                    .backGroundColor(color: UIColor.themeLightGray.withAlphaComponent(0.25))
            }
        }
        
        
        cell.imgView.setCustomImage(with: object.imageUrl)
        cell.lblTitle.text      = object.medicineName
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.tblView.frame.height / 3
//    }
}

//MARK: -------------------- Date picker methods --------------------
extension UpdateMedicationPopupVC {
    
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
        
        if #available(iOS 14, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.datePicker:
            self.dateFormatter.dateFormat   = appDateFormat
            self.dateFormatter.timeZone     = .current
            let date                        = self.dateFormatter.string(from: sender.date)
            
            if self.txtDate.text != date {
                self.txtDate.text               = self.dateFormatter.string(from: sender.date)
                
                self.viewModel.apiCallFromStart(medication_date: self.txtDate.text!,
                                                refreshControl: nil,
                                                tblView: self.tblView,
                                                withLoader: true)
            }
            break
        default:break
        }
    }
    
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension UpdateMedicationPopupVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtDate:
            
            if self.txtDate.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appDateFormat
                self.dateFormatter.timeZone     = .current
                self.txtDate.text               = self.dateFormatter.string(from: self.datePicker.date)
                
                self.viewModel.apiCallFromStart(medication_date: self.txtDate.text!,
                                                refreshControl: nil,
                                                tblView: self.tblView,
                                                withLoader: true)
            }
            break
            
        default:
            break
        }
        
        return true
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension UpdateMedicationPopupVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------- setData method --------------------
extension UpdateMedicationPopupVC {
    
    func setData(){
        WebengageManager.shared.navigateScreenEvent(screen: .LogGoal, postFix: self.goalListModel.keys)
        
        GFunction.shared.setGoalProgressData(goalListModel: self.goalListModel,
                                             lblProgress: self.lblProgress,
                                             linearProgressBar: self.linearProgressBar,
                                             lblDuration: nil,
                                             valueLog: nil)
        //self.linearProgressBar.progressValue = 20
        self.lblTitle.text = self.goalListModel.goalName
        
        self.setProgress(progressBar: self.linearProgressBar, color: UIColor.hexStringToUIColor(hex: self.goalListModel.colorCode))
        
        if self.myIndex == self.arrList.count - 1 {
            //self.btnAddAndNext.isHidden = true
        }
        else {
            //self.btnAddAndNext.isHidden = false
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension UpdateMedicationPopupVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                
                
                
                var params              = [String : Any]()
                params[AnalyticsParameters.goal_name.rawValue]  = self.goalListModel.goalName
                params[AnalyticsParameters.goal_id.rawValue]    = self.goalListModel.goalMasterId
                FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATED_ACTIVITY,
                                         screen: .LogGoal,
                                         parameter: params)
                FIRAnalytics.FIRLogEvent(eventName: .USER_MARKS_MEDICINE,
                                         screen: .LogGoal,
                                         parameter: params)
                
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
        
        //FOR ARRAY RESULT
        self.viewModel.vmArrResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                var params              = [String : Any]()
                params[AnalyticsParameters.goal_name.rawValue]      = self.goalListModel.goalName
                params[AnalyticsParameters.goal_id.rawValue]        = self.goalListModel.goalMasterId
                FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATED_ACTIVITY,
                                         screen: .LogGoal,
                                         parameter: params)
                
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.tblView.reloadData()
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}


