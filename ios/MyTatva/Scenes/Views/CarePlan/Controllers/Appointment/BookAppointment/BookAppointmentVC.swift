//
//  RecordsVC.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import UIKit

class BookAppointmentSlotHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    
    //MARK:- Class Variable
    var arrData = [JSON]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            //    .backGroundColor(color: UIColor.themeLightGray)
        }
    }
}

class BookAppointmentVC: ClearNavigationFontBlackBaseVC {
    
    //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblBookingFor        : UILabel!
    @IBOutlet weak var btnDoctor            : UIButton!
    @IBOutlet weak var btnCoach             : UIButton!
    
    @IBOutlet weak var stackCoach           : UIStackView!
    @IBOutlet weak var vwSelectCoach        : UIView!
    @IBOutlet weak var lblSelectCoach       : UILabel!
    @IBOutlet weak var txtSelectCoach       : UITextField!
    
    @IBOutlet weak var stackClinic          : UIStackView!
    @IBOutlet weak var vwSelectClinic       : UIView!
    @IBOutlet weak var lblSelectClinic      : UILabel!
    @IBOutlet weak var txtSelectClinic      : UITextField!
    
    @IBOutlet weak var stackDoc             : UIStackView!
    @IBOutlet weak var vwSelectDoc          : UIView!
    @IBOutlet weak var lblSelectDoc         : UILabel!
    @IBOutlet weak var txtSelectDoc         : UITextField!
    
    @IBOutlet weak var vwSelectType         : UIView!
    @IBOutlet weak var lblSelectType        : UILabel!
    @IBOutlet weak var txtSelectType        : UITextField!
    
    @IBOutlet weak var vwCalendarParent     : UIView!
    @IBOutlet weak var lblCalendarTitle     : UILabel!
    @IBOutlet weak var txtCalendarTitle     : UITextField!
    @IBOutlet weak var vwCalendar           : HorizontalCalendarView!
    
    @IBOutlet weak var vwTimeSlotParent     : UIView!
    @IBOutlet weak var lblTimeSlotParent    : UILabel!
    @IBOutlet weak var colView              : UICollectionView!
    
    @IBOutlet weak var btnBook              : UIButton!
    @IBOutlet weak var btnViewAllAppointments : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = BookAppointmentVM()
    let commonSelectAppointmentPopupVM = CommonSelectAppointmentPopupVM()
    let chatHistoryListVM           = ChatHistoryListVM()
    let refreshControl              = UIRefreshControl()
    var selectedDate                = Date()
    var selectedDoctorClinic        = ClinicDoctorResult()
    var selectedCoach               = HealthCoachListModel()
    var selectedType                = JSON()
    var selectedTimeSlot            = ""
    var strErrorMessage : String    = ""
    
    var datePicker                  = UIDatePicker()
    var dateFormatter               = DateFormatter()
    var dateFormat                  = DateTimeFormaterEnum.ddmm_yyyy.rawValue
    var selectedFor                 = AppointmentFor.D
    var timerSearch                 = Timer()
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
        
        self.lblBookingFor
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.btnDoctor
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.btnCoach
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblSelectCoach
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.txtSelectCoach
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblSelectClinic
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.txtSelectClinic
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblSelectDoc
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.txtSelectDoc
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblSelectType
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.txtSelectType
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblCalendarTitle.isHidden = true
        self.lblCalendarTitle
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.txtCalendarTitle
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblTimeSlotParent
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.btnBook
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.white)
        self.btnViewAllAppointments
            .font(name: .medium, size: 14).textColor(color: .themePurple)
        self.btnViewAllAppointments.isHidden = true
        
        self.txtSelectCoach.delegate    = self
        self.txtSelectClinic.delegate   = self
        self.txtSelectDoc.delegate      = self
        self.txtSelectType.delegate     = self
        
        self.vwCalendar.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.vwCalendar.moveToDate(Date(), animated: false)
        }

        self.initDatePicker()
        self.configureUI()
        self.manageActionMethods()
        self.setup(colView: self.colView)
        
        if UserModel.shared.patientGuid.trim() != "" {
            self.btnDoctor.isHidden = false
            self.manageBookingFor(sender: self.btnDoctor)
        }
        else {
            self.btnDoctor.isHidden = true
            self.manageBookingFor(sender: self.btnCoach)
        }
        
        if !self.btnDoctor.isHidden {
            self.selectedFor == .H ? self.manageBookingFor(sender: self.btnCoach) : self.manageBookingFor(sender: self.btnDoctor)
        }
        
        
        //Subscription Plan logic to let patient access doctor or hc book appointment
        ///1st logic to stays on screen based on subscription plan ------------------------
        var isAllowDoc       = false
        PlanManager.shared.isAllowedByPlan(type: .book_appointments,
                                           sub_features_id: "book_appointments_doctor",
                                           completion: { isAllow in
            if isAllow{
                isAllowDoc               = true
            }
        })
        
        var isAllowHC       = false
        PlanManager.shared.isAllowedByPlan(type: .book_appointments,
                                           sub_features_id: "book_appointments_hc",
                                           completion: { isAllow in
            if isAllow{
                isAllowHC               = true
            }
        })
        
        if !isAllowDoc && !isAllowHC {
            Alert.shared.showAlert(message: AppMessages.SubscribeToContinue) { [weak self] isDone in
                guard let self = self else {return}
                if isDone {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        if self.btnDoctor.isHidden &&
            isAllowDoc &&
            !isAllowHC {
            Alert.shared.showAlert(message: AppMessages.SubscribeToContinue) { [weak self] isDone in
                guard let self = self else {return}
                if isDone {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        ///2nd logic to auto select based on subscription plan ------------------------
        if self.btnDoctor.isSelected && !isAllowDoc {
            self.manageBookingFor(sender: self.btnCoach)
        }
        else if self.btnCoach.isSelected && !isAllowHC {
            self.manageBookingFor(sender: self.btnDoctor)
        }
        
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        DispatchQueue.main.async {
            self.vwSelectCoach.layoutIfNeeded()
            self.vwSelectCoach.cornerRadius(cornerRadius: 5)
            self.vwSelectCoach.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            
            self.vwSelectClinic.layoutIfNeeded()
            self.vwSelectClinic.cornerRadius(cornerRadius: 5)
            self.vwSelectClinic.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            
            self.vwSelectDoc.layoutIfNeeded()
            self.vwSelectDoc.cornerRadius(cornerRadius: 5)
            self.vwSelectDoc.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            
            self.vwSelectType.layoutIfNeeded()
            self.vwSelectType.cornerRadius(cornerRadius: 5)
            self.vwSelectType.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            
            self.btnBook.layoutIfNeeded()
            self.btnBook.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnViewAllAppointments.layoutIfNeeded()
            self.btnViewAllAppointments.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.btnDoctor.layoutIfNeeded()
            self.btnCoach.layoutIfNeeded()
            self.btnDoctor.cornerRadius(cornerRadius: 5)
            self.btnCoach.cornerRadius(cornerRadius: 5)
        }
    }
    
    func setup(colView: UICollectionView){
        colView.delegate                   = self
        colView.dataSource                 = self
        colView.emptyDataSetSource         = self
        colView.emptyDataSetDelegate       = self
        colView.reloadData()
    }
    
    func initDatePicker(){
       
        self.txtCalendarTitle.inputView     = self.datePicker
        self.txtCalendarTitle.delegate      = self
        self.datePicker.datePickerMode      = .date
        self.datePicker.minimumDate         = Date()
        self.datePicker.maximumDate         =  Calendar.current.date(byAdding: .year, value: 1, to: Date())
        self.datePicker.timeZone            = .current
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
    
        if #available(iOS 14, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.datePicker:
            
            self.dateFormatter.dateFormat   = self.dateFormat
            self.dateFormatter.timeZone     = .current
            self.txtCalendarTitle.text      = self.dateFormatter.string(from: sender.date)
            self.vwCalendar.moveToDate(sender.date, animated: false)
            
            break
            
        default:break
        }
    }
    
    func updateTimeSlot(){
        self.strErrorMessage    = ""
        let health_coach_id     = self.selectedCoach.healthCoachId ?? ""
        let clinic_id           = self.selectedDoctorClinic.clinicId ?? ""
        var doctor_id           = ""
        var consulation_type    = ""
        var appointment_date    = ""
        self.selectedTimeSlot   = ""
        
        if let obj = self.selectedDoctorClinic.doctorDetails {
            let arrObj      = obj.filter { obj in
                return obj.isSelected
            }
            
            if arrObj.count > 0 {
                doctor_id = arrObj[0].doctorUniqId
            }
        }
        
        if self.selectedType.count > 0 {
            consulation_type = self.selectedType["key"].stringValue
        }
        
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = DateTimeFormaterEnum.dd_mm_yyyy.rawValue
        appointment_date                = formatter.string(from: self.selectedDate)
        
        if self.btnCoach.isSelected {
            //Time slot for coach
            if health_coach_id.trim() != "" &&
                consulation_type.trim() != "" &&
                appointment_date.trim() != "" {
                
                self.timerSearch.invalidate()
                self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false) { timer in
                    self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                                    colView: self.colView,
                                                    clinic_id: clinic_id,
                                                    doctor_id: doctor_id,
                                                    consulation_type: consulation_type,
                                                    appointment_date: appointment_date,
                                                    health_coach_id: health_coach_id,
                                                    forCoach: true,
                                                    withLoader: true)
                }
            }
        }
        else {
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false) { timer in
                //Time slot for doctor
                if clinic_id.trim() != "" &&
                    doctor_id.trim() != "" &&
                    consulation_type.trim() != "" &&
                    appointment_date.trim() != "" {
                    
                    self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                                    colView: self.colView,
                                                    clinic_id: clinic_id,
                                                    doctor_id: doctor_id,
                                                    consulation_type: consulation_type,
                                                    appointment_date: appointment_date,
                                                    health_coach_id: health_coach_id,
                                                    forCoach: false,
                                                    withLoader: true)
                }
            }
        }
    }
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        
        self.btnDoctor.addTapGestureRecognizer {
            PlanManager.shared.isAllowedByPlan(type: .book_appointments,
                                               sub_features_id: "book_appointments_doctor",
                                               completion: { isAllow in
                if isAllow{
                    self.manageBookingFor(sender: self.btnDoctor)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
        
        self.btnCoach.addTapGestureRecognizer {
            PlanManager.shared.isAllowedByPlan(type: .book_appointments,
                                               sub_features_id: "book_appointments_hc",
                                               completion: { isAllow in
                if isAllow{
                    self.manageBookingFor(sender: self.btnCoach)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
        
        self.btnBook.addTapGestureRecognizer {
            let health_coach_id     = self.selectedCoach.healthCoachId ?? ""
            let clinic_id           = self.selectedDoctorClinic.clinicId ?? ""
            var doctor_id           = ""
            var consulation_type    = ""
            var appointment_date    = ""
            
            if let obj = self.selectedDoctorClinic.doctorDetails {
                let arrObj      = obj.filter { obj in
                    return obj.isSelected
                }
                
                if arrObj.count > 0 {
                     doctor_id = arrObj[0].doctorUniqId
                }
            }
            
            if self.selectedType.count > 0 {
                consulation_type = self.selectedType["key"].stringValue
            }
            
            let formatter: DateFormatter    = DateFormatter()
            formatter.timeZone              = .current
            formatter.dateFormat            = DateTimeFormaterEnum.dd_mm_yyyy.rawValue
            appointment_date                = formatter.string(from: self.selectedDate)
            formatter.dateFormat            = DateTimeFormaterEnum.HHmm.rawValue
            
            self.viewModel.apiCallSubmit(vc: self,
                                         clinic_id: clinic_id,
                                         doctor_id: doctor_id,
                                         consulation_type: consulation_type,
                                         appointment_date: appointment_date,
                                         time_slot: self.selectedTimeSlot,
                                         health_coach_id: health_coach_id,
                                         forCoach: self.btnCoach.isSelected)
        }
        
        self.btnViewAllAppointments.addTapGestureRecognizer {
            let vc = AppointmentsHistoryVC.instantiate(fromAppStoryboard: .setting)
            vc.isForList = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func manageBookingFor(sender: UIButton){
        switch sender {
        case self.btnDoctor:
            
            self.btnDoctor
                .font(name: .semibold, size: 14)
                .textColor(color: UIColor.white)
            self.btnCoach
                .font(name: .semibold, size: 14)
                .textColor(color: UIColor.themeBlack)
            
            self.btnDoctor.backGroundColor(color: UIColor.themePurple.withAlphaComponent(1))
            self.btnCoach.backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.1))
            
            self.stackDoc.isHidden      = false
            self.stackClinic.isHidden   = false
            self.stackCoach.isHidden    = true
            
            if self.btnCoach.isSelected {
                self.txtSelectType.text = ""
            }
            
            self.btnDoctor.isSelected   = true
            self.btnCoach.isSelected    = false
            self.autoFillDocHC()
            
            break
        case self.btnCoach:
            
            self.btnDoctor
                .font(name: .semibold, size: 14)
                .textColor(color: UIColor.themeBlack)
            self.btnCoach
                .font(name: .semibold, size: 14)
                .textColor(color: UIColor.white)
            
            self.btnDoctor.backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.1))
            self.btnCoach.backGroundColor(color: UIColor.themePurple.withAlphaComponent(1))
            
            self.stackDoc.isHidden      = true
            self.stackClinic.isHidden   = true
            self.stackCoach.isHidden    = false
            
            if self.btnDoctor.isSelected {
                self.txtSelectType.text = ""
            }
            
            self.btnDoctor.isSelected   = false
            self.btnCoach.isSelected    = true
            self.autoFillDocHC()
            
            break
        default: break
        }
        self.updateTimeSlot()
    }
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .BookAppointment)
        
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
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension BookAppointmentVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        
        case self.colView:
            if self.viewModel.object.result != nil {
                return self.viewModel.object.result.timeSlot.count
            }
            else {
                return 0
            }
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colView:
            if self.viewModel.object.result != nil {
                return self.viewModel.object.result.timeSlot[section].slots.count
            }
            else {
                return 0
            }
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BookAppointmentSlotHeaderCell", for: indexPath) as! BookAppointmentSlotHeaderCell
            
            let object = self.viewModel.object.result.timeSlot[indexPath.section]
            headerView.lblTitle.text = object.title
            headerView.backgroundColor = UIColor.white
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BookAppointmentSlotHeaderCell", for: indexPath) as! BookAppointmentSlotHeaderCell
            
            footerView.backgroundColor = UIColor.white
            return footerView
            
        default:
            
//            assert(false, "Unexpected element kind")
            fatalError("Unexpected element kind")

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).count > 0 {
            if let headerView = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? BookAppointmentSlotHeaderCell {
                // Layout to get the right dimensions
                headerView.layoutIfNeeded()
                
                // Automagicallowy get the right height
                let height = headerView.contentView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
                
                // return the correct size
                return CGSize(width: collectionView.frame.width, height: height)
            }
        }
        
        // You need this because rhis delegate method will run at least
        // once before the header is available for sizing.
        // Returning zero will stop the delegate from trying to get a supplementary view
        return CGSize(width: 1, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case self.colView:
            let cell : DiscoverEngageFilterTypeCell = collectionView.dequeueReusableCell(withClass: DiscoverEngageFilterTypeCell.self, for: indexPath)
            
            if self.viewModel.object.result != nil {
                let obj = self.viewModel.object.result.timeSlot[indexPath.section].slots[indexPath.row]
               
                cell.lblTitle.text = obj
                cell.vwBg.backGroundColor(color: UIColor.themeLightGray)
                cell.lblTitle.font(name: .medium, size: 12)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
                if obj == self.selectedTimeSlot {
                    cell.vwBg.backGroundColor(color: UIColor.themeLightPurple)
                    cell.lblTitle.font(name: .medium, size: 12)
                        .textColor(color: UIColor.white)
                }
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colView:
            self.selectedTimeSlot = self.viewModel.object.result.timeSlot[indexPath.section].slots[indexPath.row]
            self.colView.reloadData()
            
            break
        
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colView:
//            let obj         = self.viewModel.object.result.timeSlot[indexPath.section].slots[indexPath.row]
//            let width       = obj.width(withConstraintedHeight: 30, font: UIFont.customFont(ofType: .medium, withSize: 12.0)) + 50
            
            let width       = colView.frame.size.width / 2
            let height      = 40 * ScreenSize.widthAspectRatio
            
            return CGSize(width: width,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension BookAppointmentVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        var text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        
        if scrollView == self.colView {
            text = self.strErrorMessage
        }
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- HorizontalCalendar Delegate Methods --------------------------
extension BookAppointmentVC : HorizontalCalendarDelegate {
    
    func horizontalCalendarViewDidUpdate(_ calendar: HorizontalCalendarView, date: Date) {
        
        self.selectedDate               = date
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = self.dateFormat
        let strDate                     = formatter.string(from: self.selectedDate)
        //let dtDate                      = formatter.date(from: strDate)
        print("Updated calendarView \(strDate)")
        
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedAscending {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.vwCalendar.moveToDate(Date(), animated: false)
            }
        }
        else {
            self.lblCalendarTitle.text  = strDate
            self.txtCalendarTitle.text  = strDate
        }
        self.updateTimeSlot()
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension BookAppointmentVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
       
        case self.txtCalendarTitle:
            
            if let _ = self.presentedViewController {
                return false
            }
            else {
                if self.txtCalendarTitle.text?.trim() == "" {
                    self.dateFormatter.dateFormat   = self.dateFormat
                    self.dateFormatter.timeZone     = .current
                    self.txtCalendarTitle.text      = self.dateFormatter.string(from: self.datePicker.date)
                    self.vwCalendar.moveToDate(self.datePicker.date, animated: false)
                }
                return true
            }
            
        case self.txtSelectCoach:
            self.view.endEditing(true)
            let vc = CommonSelectAppointmentPopupVC.instantiate(fromAppStoryboard: .carePlan)
            vc.selectionType            = .coach
            vc.arrClinicOffline         = [self.selectedDoctorClinic]
            vc.modalPresentationStyle   = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandlerCoach = { obj in
                if obj != nil {
                    self.selectedCoach   = obj!
                    self.txtSelectCoach.text   = self.selectedCoach.firstName + " " + self.selectedCoach.lastName + " (\(self.selectedCoach.role!))"
                    //self.txtSelectDoc.text      = ""
                    self.updateTimeSlot()
                }
            }
            self.present(vc, animated: true, completion: nil)
            return false
            
        case self.txtSelectClinic:
            self.view.endEditing(true)
            let vc = CommonSelectAppointmentPopupVC.instantiate(fromAppStoryboard: .carePlan)
            vc.selectionType            = .clinic
            vc.arrClinicOffline         = [self.selectedDoctorClinic]
            vc.modalPresentationStyle   = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandler = { obj in
                if obj != nil {
                    self.selectedDoctorClinic   = obj!
                    self.txtSelectClinic.text   = self.selectedDoctorClinic.clinicName
                    self.txtSelectDoc.text      = ""
                    self.updateTimeSlot()
                }
            }
            self.present(vc, animated: true, completion: nil)
            return false
        
        case self.txtSelectDoc:
            self.view.endEditing(true)
            
            if self.txtSelectClinic.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .PleaseSelectClinic).errorDescription ?? "")
            }
            else {
                let vc = CommonSelectAppointmentPopupVC.instantiate(fromAppStoryboard: .carePlan)
                vc.selectionType            = .doctor
                vc.arrClinicOffline         = [self.selectedDoctorClinic]
                vc.modalPresentationStyle   = .overFullScreen
    //            vc.modalTransitionStyle = .crossDissolve
                vc.completionHandler = { obj in
                    if obj != nil {
                        self.selectedDoctorClinic = obj!
                        
                        let arrObj = self.selectedDoctorClinic.doctorDetails.filter { obj in
                            return obj.isSelected
                        }
                        
                        if arrObj.count > 0 {
                            self.txtSelectDoc.text = arrObj[0].doctorName
                            self.updateTimeSlot()
                        }
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
            return false
            
        case self.txtSelectType:
            
            let vc = CommonSelectAppointmentPopupVC.instantiate(fromAppStoryboard: .carePlan)
            vc.selectionType                = .appointmentType
            vc.isBookingForCoach            = self.btnCoach.isSelected
            vc.modalPresentationStyle       = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandlerAppointmentType = { obj in
                if obj != nil {
                    self.selectedType           = obj!
                    self.txtSelectType.text     = self.selectedType["name"].stringValue
                    self.updateTimeSlot()
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

//MARK: -------------------------- set data Methods --------------------------
extension BookAppointmentVC {
    
    func setData(){
        if self.btnDoctor.isSelected {
            for item in self.commonSelectAppointmentPopupVM.arrList {
                if let doc = UserModel.shared.patientLinkDoctorDetails, doc.count > 0 {
                    if item.clinicId == doc[0].clinicId {
                        self.selectedDoctorClinic   = item
                        self.txtSelectClinic.text   = self.selectedDoctorClinic.clinicName
                        self.txtSelectDoc.text      = ""
                        self.updateTimeSlot()
                    }
                }
            }
            
            if let doctorDetails = self.selectedDoctorClinic.doctorDetails {
                for item in doctorDetails {
                    if let doc = UserModel.shared.patientLinkDoctorDetails, doc.count > 0 {
                        if item.doctorName == doc[0].name {
                            self.txtSelectDoc.text = item.doctorName
                            self.updateTimeSlot()
                        }
                    }
                }
            }
        }
        else {
//            for obj in self.chatHistoryListVM.arrList {
//                for hc in UserModel.shared.hcList {
//                    if obj.healthCoachId == hc.healthCoachId {
//                        self.selectedCoach          = obj
//                        self.txtSelectCoach.text    = self.selectedCoach.firstName + " " + self.selectedCoach.lastName
//                        //self.txtSelectDoc.text      = ""
//                        self.updateTimeSlot()
//                    }
//                }
//            }
        }
    }
    
    func autoFillDocHC(){
        if self.btnDoctor.isSelected {
            //Load clinic and doctor list if doctor is selected
            self.commonSelectAppointmentPopupVM.apiCallFromStart(refreshControl: self.refreshControl,
                                            tblView: nil,
                                            withLoader: true)
        }
        else {
            //Load coach list if coach is selected
            self.chatHistoryListVM.apiCallFromStart(list_type: "A",
                                                    refreshControl: self.refreshControl,
                                                    tblView: nil,
                                                    withLoader: true)
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension BookAppointmentVC {
    
    private func setupViewModelObserver() {
        // Result binding observerr
        self.commonSelectAppointmentPopupVM.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
        self.chatHistoryListVM.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
        self.viewModel.vmResultList.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.colView.reloadData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                func bookingDone(){
                    DispatchQueue.main.async {
                        if self.selectedType.count > 0 {
                            let consulation_type = self.selectedType["key"].stringValue
                            /// Redirect to next screen
                            if consulation_type == AppointmentType.video.rawValue &&
                                self.viewModel.strUrl.trim() != "" {
                                
                                let vc = WebviewVC.instantiate(fromAppStoryboard: .setting)
                                vc.webType  = .AppointmentPayment
                                vc.strUrl   = self.viewModel.strUrl
                                vc.completionHandler = { obj in
                                    if obj?.count > 0 {
                                        self.viewModel.fetch_videocall_dataAPI(withLoader: true) { isDone in
                                            if isDone {
                                                let vc = ConfirmAppointmentPopupVC.instantiate(fromAppStoryboard: .carePlan)
                                                vc.object = self.viewModel.appointmentListModel
                                                vc.modalTransitionStyle = .crossDissolve
                                                vc.modalPresentationStyle = .overFullScreen
                                                vc.completionHandler = { obj in
                                                    if obj?.count > 0 {
                                                        self.navigationController?.popViewController(animated: true)
                                                    }
                                                }
                                                self.present(vc, animated: true, completion: nil)
                                            }
                                        }
                                    }
                                }
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else {
                                let vc = ConfirmAppointmentPopupVC.instantiate(fromAppStoryboard: .carePlan)
                                vc.object = self.viewModel.appointmentListModel
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                vc.completionHandler = { obj in
                                    if obj?.count > 0 {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    }
                }
                
                Alert.shared.showAlert("",
                                       actionOkTitle: AppMessages.yes,
                                       actionCancelTitle: AppMessages.no,
                                       message: AppMessages.calendarsMessage) { [weak self] (isDone) in
                    guard let self = self else {return}
                    if isDone {
                        ///User approved
                        let formatter: DateFormatter    = DateFormatter()
                        formatter.timeZone              = .current
                        formatter.dateFormat            = DateTimeFormaterEnum.dd_mm_yyyy.rawValue
                        let appointment_date            = formatter.string(from: self.selectedDate)
                        formatter.dateFormat            = DateTimeFormaterEnum.HHmm.rawValue
                        
                        let arrSlot                     = self.selectedTimeSlot.components(separatedBy: "-")
                        
                        var name = self.txtSelectDoc.text!
                        if self.btnCoach.isSelected {
                            name = self.txtSelectCoach.text!
                        }
                        
                        if arrSlot.count > 1 {
                            let startTime   = arrSlot[0].trim()
                            let endTime     = arrSlot[1].trim()
                            formatter.dateFormat        = DateTimeFormaterEnum.dd_mm_yyyy_hhmma.rawValue
                            let start                   = formatter.date(from: appointment_date + " " + startTime)
                            let end                     = formatter.date(from: appointment_date + " " + endTime)
                            
                            CalendarsEventManager.shared.addToCalendars(title: "MyTatva Appointment",
                                                                        startDate: start ?? Date(),
                                                                        endDate: end ?? Date(),
                                                                        notes: "You have the \(self.txtSelectType.text!) appointment with \(name)",
                                                                        showNoPermission: true) { [weak self] isDone in
                                guard let self = self else {return}
                                if isDone {
                                }
                                else {
                                    
                                }
                                bookingDone()
                            }
                        }
                    }
                    else {
                        bookingDone()
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


