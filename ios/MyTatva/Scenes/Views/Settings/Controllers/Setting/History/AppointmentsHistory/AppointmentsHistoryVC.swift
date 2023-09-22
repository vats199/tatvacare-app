//
//  RecordsVC.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import UIKit

enum AppointmentStatus: String {
    case Scheduled
    case Cancelled
    case Complete
    case Missed
    case Completed
}

enum AppointmentFor: String, CaseIterable {
    case D
    case H
}

class AppointmentsHistoryCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var stackType            : UIStackView!
    @IBOutlet weak var vwType               : UIView!
    @IBOutlet weak var lblType              : UILabel!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblQualification     : UILabel!
    
    @IBOutlet weak var lblDate              : UILabel!
    @IBOutlet weak var lblTime              : UILabel!
    
    @IBOutlet weak var lblAddress           : UILabel!
    
    @IBOutlet weak var btnCancel            : UIButton!
    @IBOutlet weak var btnJoinVideo         : UIButton!
    @IBOutlet weak var btnInClinic          : UIButton!
    
    @IBOutlet weak var stackDischargeSummary : UIStackView!
    @IBOutlet weak var lblDischargeSummary  : UILabel!
    @IBOutlet weak var lblDischargeSummaryCount : UILabel!
    @IBOutlet weak var btnViewDischargeSummary : UIButton!
    
    @IBOutlet weak var stackPrescription    : UIStackView!
    @IBOutlet weak var lblPrescription      : UILabel!
    @IBOutlet weak var lblPrescriptionCount : UILabel!
    @IBOutlet weak var btnViewPrescription  : UIButton!
    
    var object = AppointmentListModel() {
        didSet {
            self.setCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblType
            .font(name: .medium, size: 11)
            .textColor(color: UIColor.white)
        
        self.lblTitle
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblQualification
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        
        self.lblDate
            .font(name: .semibold, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblTime
            .font(name: .semibold, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblAddress
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.9))
        
        self.btnCancel
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.btnJoinVideo
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.white.withAlphaComponent(1))
        self.btnInClinic
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblDischargeSummaryCount
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.lblDischargeSummary
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.btnViewDischargeSummary
            .font(name: .medium, size: 10)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblPrescriptionCount
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.lblPrescription
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.btnViewPrescription
            .font(name: .medium, size: 10)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            self.vwBg.borderColor(color: UIColor.themeBlack.withAlphaComponent(0.09), borderWidth: 0.5)
            
            self.vwType.layoutIfNeeded()
            self.vwType.cornerRadius(cornerRadius: 4)
                .backGroundColor(color: UIColor.themeYellow)
            
            self.btnJoinVideo.layoutIfNeeded()
            self.btnJoinVideo.cornerRadius(cornerRadius: 4)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnViewDischargeSummary.layoutIfNeeded()
            self.btnViewDischargeSummary.cornerRadius(cornerRadius: 4)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.btnViewPrescription.layoutIfNeeded()
            self.btnViewPrescription.cornerRadius(cornerRadius: 4)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.cornerRadius(cornerRadius: self.imgTitle.frame.size.height / 2)
        }
    }
    
    func setCellData(){
       
        self.imgTitle.setCustomImage(with: self.object.profilePicture)
        self.lblTitle.text          = self.object.doctorName
        self.lblQualification.text  = self.object.doctorQualification
       
        let date = GFunction.shared.convertDateFormate(dt: self.object.appointmentDate,
                                                           inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                           status: .NOCONVERSION)
        self.lblDate.text       = date.0
        self.lblTime.text       = self.object.appointmentTime
        self.lblAddress.text    = self.object.clinicAddress
        self.stackDischargeSummary.isHidden     = true
        self.stackPrescription.isHidden         = true
        self.lblPrescriptionCount.isHidden      = true
        if self.object.prescriptionPdf.trim() != "" {
            self.stackPrescription.isHidden = false
            
            self.btnViewPrescription.addTapGestureRecognizer {
                if let url = URL(string: self.object.prescriptionPdf) {
                    GFunction.shared.openPdf(url: url)
                }
            }
        }
        
        self.btnJoinVideo.isHidden  = true
        self.btnInClinic.isHidden   = true
        if self.object.appointmentType == "in clinic" {
            self.btnJoinVideo.isHidden  = true
            self.btnInClinic.isHidden   = false
        }
        else {
            self.btnJoinVideo.isHidden  = false
            self.btnInClinic.isHidden   = true
            
            if self.object.action {
                self.btnJoinVideo.isUserInteractionEnabled  = true
                self.btnJoinVideo.alpha = 1
            }
            else {
                self.btnJoinVideo.isUserInteractionEnabled  = false
                self.btnJoinVideo.alpha = 0.5
                
//                self.btnJoinVideo.isUserInteractionEnabled  = true
//                self.btnJoinVideo.alpha = 1
            }
        }
        
        DispatchQueue.main.async {
            let type = AppointmentStatus.init(rawValue: self.object.appointmentStatus) ?? .Scheduled
            self.btnCancel.isHidden = true
            self.vwType.backGroundColor(color: UIColor.themeYellow)
            switch type {
                
            case .Scheduled:
                
                self.btnCancel.isHidden = false
                self.lblType.text       = AppMessages.Upcoming//self.object.appointmentStatus
                self.vwType.backGroundColor(color: UIColor.themeYellow)
                break
            case .Cancelled:
//                self.btnJoinVideo.isHidden  = true
//                self.btnInClinic.isHidden   = true
                
                self.lblType.text       = self.object.appointmentStatus
                self.vwType.backGroundColor(color: UIColor.themeRed)
                break
            case .Complete:
//                self.btnJoinVideo.isHidden  = true
//                self.btnInClinic.isHidden   = true
                
                self.lblType.text       = AppMessages.completed//self.object.appointmentStatus
                self.vwType.backGroundColor(color: UIColor.themeGreen)
            
            case .Completed:
//                self.btnJoinVideo.isHidden  = true
//                self.btnInClinic.isHidden   = true
                
                self.lblType.text       = AppMessages.completed//self.object.appointmentStatus
                self.vwType.backGroundColor(color: UIColor.themeGreen)
                
            case .Missed:
//                self.btnJoinVideo.isHidden  = true
//                self.btnInClinic.isHidden   = true
                
                self.lblType.text       = self.object.appointmentStatus
                self.vwType.backGroundColor(color: UIColor.themeRed)
                break
            }
        }
    }
}

class AppointmentsHistoryVC: ClearNavigationFontBlackBaseVC {
    
    //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var vwSelectType         : UIView!
    @IBOutlet weak var lblSelectType        : UILabel!
    @IBOutlet weak var txtSelectType        : UITextField!
    
    @IBOutlet weak var vwDoctorParent       : UIView!
    @IBOutlet weak var vwDoctor             : UIView!
    @IBOutlet weak var imgDoctor            : UIImageView!
    @IBOutlet weak var lblDoctor            : UILabel!
    @IBOutlet weak var lblDoctorName        : UILabel!
    @IBOutlet weak var lblDoctorQualification : UILabel!
    @IBOutlet weak var btnBookAppointment   : UIButton!
    
    @IBOutlet weak var tblView              : UITableView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let pickerType                      = UIPickerView()
    var selectedType                    = ""
    let viewModel                       = AppointmentsHistoryVM()
    let refreshControl                  = UIRefreshControl()
    var isForList                       = false
    var timerSearch                     = Timer()
    var strErrorMessage : String        = ""
    
    var isFromDeelink                   = false
    var isGloabalSearch                 = false
    var strSearch                       = ""
    var selectedFor                     = AppointmentFor.D
    
    var arrList: [JSON] = []
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        
        self.lblSelectType
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.txtSelectType
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .tintColor = .clear
        
        self.lblDoctor
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.9))
        self.lblDoctorName
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblDoctorQualification
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.9))
        self.btnBookAppointment
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.white.withAlphaComponent(1))
        
        self.vwDoctorParent.isHidden = true
        
        self.configureUI()
        self.manageActionMethods()
        self.initPicker()
        
        
//        if UserModel.shared.patientGuid.trim() != "" {
//            self.arrList.append(
//                [
//                    "name" : "Doctor",
//                    "key"  : AppointmentFor.D.rawValue,
//                    "isSelected": 1,
//                ]
//            )
//        }
        
        if !self.isFromDeelink {
            if let hc = UserModel.shared.hcList, hc.count > 0 {
                self.selectedFor = .H
            }
            else {
                self.selectedFor = .D
            }
        }
        
        for value in AppointmentFor.allCases {
            
            switch value {
            case .H:
                var obj                     = JSON()
                obj["name"].stringValue     = "Health Coach"
                obj["key"].stringValue      = AppointmentFor.H.rawValue
                obj["isSelected"]           = 0
                if self.selectedFor == .H {
                    obj["isSelected"]       = 1
                }
                self.arrList.append(obj)
                break
            case .D:
                var obj                     = JSON()
                obj["name"].stringValue     = "Doctor"
                obj["key"].stringValue      = AppointmentFor.D.rawValue
                obj["isSelected"]           = 0
                if self.selectedFor == .D {
                    obj["isSelected"]       = 1
                }
                self.arrList.append(obj)
                break
            }
        }
    }
    
    private func initPicker(){
        self.pickerType.delegate        = self
        self.pickerType.dataSource      = self
        self.txtSelectType.delegate     = self
        self.txtSelectType.inputView    = self.pickerType
    }
    
    //Desc:- Set layout desing customize
    func configureUI(){
    
        DispatchQueue.main.async {
            self.vwSelectType.layoutIfNeeded()
            self.vwSelectType.cornerRadius(cornerRadius: 5)
            self.vwSelectType.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            
            self.vwDoctor.layoutIfNeeded()
            self.vwDoctor.cornerRadius(cornerRadius: 7)
            
            self.btnBookAppointment.layoutIfNeeded()
            self.btnBookAppointment.cornerRadius(cornerRadius: 5)
            
            self.imgDoctor.layoutIfNeeded()
            self.imgDoctor.cornerRadius(cornerRadius: self.imgDoctor.frame.size.height / 2)
        }
        
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
    }
    
    @objc func updateAPIData(){
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            var screen: ScreenName = .AppointmentList
            if self.isForList {
                screen = .AppointmentList
            }
            else {
                screen = .AppointmentHistory
            }
            
            let appointmentType = AppointmentFor.init(rawValue: self.selectedType) ?? .D
            switch appointmentType {
            case .H:
                FIRAnalytics.FIRLogEvent(eventName: .APPOINTMENT_HISTORY_COACH,
                                         screen: screen,
                                         parameter: nil)
                break
            case .D:
                FIRAnalytics.FIRLogEvent(eventName: .APPOINTMENT_HISTORY_DOCTOR,
                                         screen: screen,
                                         parameter: nil)
                break
            }
            
            self.strErrorMessage = ""
            
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.viewModel.apiCallFromStart_Appointment(forToday: false,
                                                            type: self.selectedType,
                                                            tblView: self.tblView,
                                                            refreshControl: self.refreshControl,
                                                            withLoader: false)
            }
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        self.btnBookAppointment.addTapGestureRecognizer {
            var screen: ScreenName = .AppointmentList
            if self.isForList {
                screen = .AppointmentList
            }
            else {
                screen = .AppointmentHistory
            }
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICK_BOOK_APPOINTMENT,
                                     screen: screen,
                                     parameter: nil)
            
            PlanManager.shared.isAllowedByPlan(type: .book_appointments,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow {
                    let vc = BookAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
        self.setTypeSelection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.updateAPIData()
        
        if self.isForList {
            WebengageManager.shared.navigateScreenEvent(screen: .AppointmentList)
        }
        else {
            WebengageManager.shared.navigateScreenEvent(screen: .AppointmentHistory)
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //WebengageManager.shared.navigateScreenEvent(screen: .SetUpGoalsReadings)
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = self.parent?.parent as? TabbarVC {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        //FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @IBAction func onGoBack(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
       }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension AppointmentsHistoryVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : AppointmentsHistoryCell = tableView.dequeueReusableCell(withClass: AppointmentsHistoryCell.self, for: indexPath)
    
        let object = self.viewModel.getObject(index: indexPath.row)
        cell.object = object
//        cell.setCellData()
        
        cell.btnCancel.addTapGestureRecognizer {
            Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.cancelAppointmentMessage) { (isDone) in
                if isDone {
                    
                    var type_consult = "video"
                    if object.appointmentType == "in clinic" {
                        type_consult = "clinic"
                    }
                    
                    self.viewModel.cancelAppointmentAPI(appointment_id: object.appointmentId,
                                                        clinic_id: object.clinicId,
                                                        doctor_id: object.doctorId,
                                                        type_consult: type_consult,
                                                        appointment_date: object.appointmentDate,
                                                        appointment_slot: object.appointmentTime,
                                                        type: object.type) { [weak self] isDone, msg in
                        guard let self = self else {return}
                        
                        if isDone {
                            var screen: ScreenName = .AppointmentList
                            if self.isForList {
                                screen = .AppointmentList
                            }
                            else {
                                screen = .AppointmentHistory
                            }
                            
                            var params              = [String : Any]()
                            params[AnalyticsParameters.appointment_id.rawValue] = object.appointmentId
                            params[AnalyticsParameters.type.rawValue] = object.type
                            FIRAnalytics.FIRLogEvent(eventName: .APPOINTMENT_HISTORY_REQ_CANCEL,
                                                     screen: screen,
                                                     parameter: params)
                            
                            self.updateAPIData()
                        }
                    }
                }
            }
        }
        
        
        cell.btnJoinVideo.addTapGestureRecognizer {
            if object.action {
                var screen: ScreenName = .AppointmentList
                if self.isForList {
                    screen = .AppointmentList
                }
                else {
                    screen = .AppointmentHistory
                }
                
                var params              = [String : Any]()
                params[AnalyticsParameters.appointment_id.rawValue] = object.appointmentId
                params[AnalyticsParameters.type.rawValue] = object.type
                FIRAnalytics.FIRLogEvent(eventName: .APPOINTMENT_HISTORY_JOIN_VIDEO,
                                         screen: screen,
                                         parameter: params)
                if PIPKit.isPIP {
                    PIPKit.stopPIPMode()
                }
                else {
                    let vc = VideoAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
                    vc.strRoomSid       = object.roomId
                    vc.strRoomName      = object.roomName
                    vc.strTitle         = object.doctorName
                    vc.type             = object.type
                    vc.appointment_id   = object.appointmentId
    //                self.navigationController?.pushViewController(vc, animated: true)
    //                self.present(vc, animated: true)
                    PIPKit.show(with: vc.viewController()){
                        PIPKit.stopPIPMode()
                    }
                }
            }
        }
        
        cell.btnViewPrescription.addTapGestureRecognizer {
            if let doc = object.prescriptionPdf {
                if let url = URL(string: doc) {
                    GFunction.shared.openPdf(url: url)
                }
            }
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var params              = [String : Any]()
//        params[AnalyticsParameters.patient_records_id.rawValue]  = self.viewModel.getRecordObject(index: indexPath.row).patientRecordsId
        //FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_RECORD, parameter: params)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !self.txtSelectType.isFirstResponder {
            self.viewModel.managePagenation(forToday: false,
                                                       type: self.selectedType,
                                                       tblView: tableView,
                                                       index: indexPath.row)
        }
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension AppointmentsHistoryVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: --------------------- UIPickerVIew Method ---------------------
extension AppointmentsHistoryVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerType:
            return self.arrList.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerType:
            return self.arrList[row]["name"].stringValue
            
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pickerType:
            var object                = self.arrList[row]
            for i in 0...self.arrList.count - 1 {
                var item = self.arrList[i]
                item["isSelected"].intValue = 0
                if item["key"].stringValue == object["key"].stringValue {
                    item["isSelected"].intValue       = 1
                }
                self.arrList[i]  = item
            }
            self.setTypeSelection()
            break
       
        default: break
        }
    }
    
    fileprivate func setTypeSelection(index: Int? = nil){
        if index != nil {
            let object                = self.arrList[index!]
            self.selectedType         = object["key"].stringValue
            self.txtSelectType.text   = object["name"].stringValue
        }
        else {
            for i in 0...self.arrList.count - 1 {
                var item = self.arrList[i]
                if item["isSelected"].intValue == 1 {
                    self.selectedType         = item["key"].stringValue
                    self.txtSelectType.text   = item["name"].stringValue
                    self.pickerType.selectRow(i, inComponent: 0, animated: true)
                }
            }
        }
    }
}

//MARK: -------------------- UITextField Delegate --------------------
extension AppointmentsHistoryVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtSelectType:
            
            if self.txtSelectType.text!.trim() == ""{
                self.setTypeSelection()
            }
            return true
        default: return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.txtSelectType:
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
            
            if self.txtSelectType.text!.trim() != "" {
                self.updateAPIData()
            }
            break
            
        default: break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
       
        return true
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension AppointmentsHistoryVC {
    
    fileprivate func setData(){
        
        if let doc = UserModel.shared.patientLinkDoctorDetails, doc.count > 0 {
            self.vwDoctorParent.isHidden = false
            let object              = doc[0]
            self.imgDoctor.setCustomImage(with: object.profileImage, placeholder: UIImage(named: "defaultUser"), andLoader: true, completed: nil)
            self.lblDoctorName.text    = object.name!
            //self.lblPhone.text      = object.countryCode! + " " + object.contactNo!
            //cell.lblEmail.text      = object.email!
            self.lblDoctorQualification.text       = object.specialization! + " - " + object.qualification!
            //cell.lblAddress.text    = object.city! + ", " + object.state! + ", " + object.country!
            
            //cell.lblGender.isHidden = true
//            if object.gender.trim() != "" {
//                cell.lblGender.isHidden     = false
//                cell.lblGender.text         = object.gender == "M" ? AppMessages.male : AppMessages.female
//            }
        }
    }
}

//MARK: -------------------- GlobalSearch Methods --------------------
extension AppointmentsHistoryVC {
    
    @objc func searchDidUpdate(_ notification: NSNotification) {
        if let _ = self.parent {
            if let searchKeyword = notification.userInfo?["search"] as? String {
                self.strSearch = searchKeyword
                self.updateAPIData()
             }
        }
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension AppointmentsHistoryVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                self.view.endEditing(true)
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.tblView.reloadData()
                
                self.vwDoctorParent.isHidden = true
                if self.isForList {
                    //self.setData()
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
               
