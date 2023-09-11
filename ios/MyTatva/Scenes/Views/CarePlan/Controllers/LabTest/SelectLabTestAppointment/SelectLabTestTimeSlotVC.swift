//
//  RecordsVC.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import UIKit

class SelectLabTestAppointmentHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var imgTitle     : UIImageView!
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

class SelectLabTestTimeSlotVC: ClearNavigationFontBlackBaseVC {
    
    //----------------------------------
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblSelectDate        : UILabel!
    @IBOutlet weak var lblSelectTime        : UILabel!
    
    @IBOutlet weak var vwCalendarParent     : UIView!
    @IBOutlet weak var lblCalendarTitle     : UILabel!
    @IBOutlet weak var txtCalendarTitle     : UITextField!
    @IBOutlet weak var vwCalendar           : HorizontalCalendarView!
    
    @IBOutlet weak var vwTimeSlotParent     : UIView!
    @IBOutlet weak var lblTimeSlotParent    : UILabel!
    @IBOutlet weak var colView              : UICollectionView!
    
    @IBOutlet weak var btnBook              : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = SelectLabTestAppointmentVM()
    let refreshControl              = UIRefreshControl()
    var selectedDate                = Date()
    var selectedType                = JSON()
    
    var strErrorMessage : String    = ""
    
    var datePicker                  = UIDatePicker()
    var dateFormatter               = DateFormatter()
    var dateFormat                  = DateTimeFormaterEnum.ddmm_yyyy.rawValue
    
    var cartListModel               = CartListModel()
    var labPatientListModel         : LabPatientListModel?
    var labAddressListModel         = LabAddressListModel()
    var selectedTimeSlot            = ""
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
        
        self.lblSelectDate
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblSelectTime
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.lblCalendarTitle.isHidden = true
        self.lblCalendarTitle
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblTimeSlotParent
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.txtCalendarTitle
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.btnBook
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.white)
        
        self.vwCalendar.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.vwCalendar.moveToDate(Date(), animated: false)
        }

        self.initDatePicker()
        self.configureUI()
        self.manageActionMethods()
        self.setup(colView: self.colView)
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        DispatchQueue.main.async {
            self.btnBook.layoutIfNeeded()
            self.btnBook.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple)
            
            self.vwCalendarParent.layoutIfNeeded()
            self.vwCalendarParent.backGroundColor(color: UIColor.themeLightGray)
            
            self.vwCalendar.layoutIfNeeded()
            self.vwCalendar.backGroundColor(color: UIColor.clear)
            self.vwCalendar.collectionView?.backGroundColor(color: UIColor.clear)
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
    
    @objc func updateAPIData(withLoader: Bool = false){
        self.strErrorMessage    = ""
        self.selectedTimeSlot   = ""
        
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = DateTimeFormaterEnum.yyyymmdd.rawValue
        let strDate                     = formatter.string(from: self.selectedDate)
        
        self.timerSearch.invalidate()
        self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false) { timer in
            self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                            colView: self.colView,
                                            pincode: JSON(self.labAddressListModel.pincode as Any).stringValue,
                                            date: strDate,
                                            withLoader: withLoader)
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        self.btnBook.addTapGestureRecognizer {
            if self.selectedTimeSlot.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .PleaseSelectTimeSlot).errorDescription ?? "")
            }
            else {
                let formatter: DateFormatter    = DateFormatter()
                formatter.timeZone              = .current
                formatter.dateFormat            = DateTimeFormaterEnum.yyyymmdd.rawValue
                let appointment_date            = formatter.string(from: self.selectedDate)
                
                var params1 = [String: Any]()
                params1[AnalyticsParameters.appointment_date.rawValue]  = appointment_date
                params1[AnalyticsParameters.slot_time.rawValue]         = self.selectedTimeSlot
                params1[AnalyticsParameters.slot_booking_for.rawValue]  = "labTest"
                
                FIRAnalytics.FIRLogEvent(eventName: .LABTEST_APPOINTMENT_TIME_SELECTED,
                                         screen: .SelectLabtestAppointmentDateTime,
                                         parameter: params1)
                let vc = OrderReviewVC.instantiate(fromAppStoryboard: .BCP_temp)
                vc.cartListModel            = self.cartListModel
                if let labPatientListModel = self.labPatientListModel {
                    vc.labPatientListModel  = labPatientListModel
                }
                vc.labAddressListModel      = self.labAddressListModel
                vc.selectedTimeSlot         = self.selectedTimeSlot
                vc.selectedDate             = self.selectedDate
                self.navigationController?.pushViewController(vc, animated: true)
                
                /*let vc = TestOrderReviewVC.instantiate(fromAppStoryboard: .carePlan)
                vc.cartListModel            = self.cartListModel
                if let labPatientListModel = self.labPatientListModel {
                    vc.labPatientListModel  = labPatientListModel
                }
                vc.labAddressListModel      = self.labAddressListModel
                vc.selectedTimeSlot         = self.selectedTimeSlot
                vc.selectedDate             = self.selectedDate
                self.navigationController?.pushViewController(vc, animated: true)*/
            }
            
//            let clinic_id           = self.selectedDoctorClinic.clinicId ?? ""
//            var doctor_id           = ""
//            var consulation_type    = ""
//            var appointment_date    = ""
//
//            if let obj = self.selectedDoctorClinic.doctorDetails {
//                let arrObj      = obj.filter { obj in
//                    return obj.isSelected
//                }
//
//                if arrObj.count > 0 {
//                    doctor_id = arrObj[0].doctorUniqId
//                }
//            }
//
//            if self.selectedType.count > 0 {
//                consulation_type = self.selectedType["key"].stringValue
//            }
//
//            let formatter: DateFormatter    = DateFormatter()
//            formatter.timeZone              = .current
//            formatter.dateFormat            = DateTimeFormaterEnum.dd_mm_yyyy.rawValue
//            appointment_date                = formatter.string(from: self.selectedDate)
//
//            self.viewModel.apiCallSubmit(vc: self,
//                                         clinic_id: clinic_id,
//                                         doctor_id: doctor_id,
//                                         consulation_type: consulation_type,
//                                         appointment_date: appointment_date,
//                                         time_slot: self.selectedTimeSlot)

        }
        
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .SelectLabtestAppointmentDateTime)
        self.navigationController?.isNavigationBarHidden = false
        self.updateAPIData(withLoader: true)
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
extension SelectLabTestTimeSlotVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        
        case self.colView:
            return self.viewModel.getCount()
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colView:
            
            return self.viewModel.getObject(index: section).slots.count
           
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SelectLabTestAppointmentHeaderCell", for: indexPath) as! SelectLabTestAppointmentHeaderCell
            
            let object                      = self.viewModel.getObject(index: indexPath.section)
            headerView.lblTitle.text        = object.title
            headerView.imgTitle.isHidden    = true
            headerView.backgroundColor      = UIColor.white
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SelectLabTestAppointmentHeaderCell", for: indexPath) as! SelectLabTestAppointmentHeaderCell
            
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
                
                // Automagically get the right height
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
            
            
            let obj = self.viewModel.getObject(index: indexPath.section).slots[indexPath.row]
            
            cell.lblTitle.text = obj
            cell.vwBg.backGroundColor(color: UIColor.themeLightGray)
            cell.lblTitle.font(name: .medium, size: 12)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
            if obj == self.selectedTimeSlot {
                cell.vwBg.backGroundColor(color: UIColor.themeLightPurple)
                cell.lblTitle.font(name: .medium, size: 12)
                    .textColor(color: UIColor.white)
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colView:
            self.selectedTimeSlot = self.viewModel.getObject(index: indexPath.section).slots[indexPath.row]
            self.colView.reloadData()
            
            break
        
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colView:
//            let obj         = self.viewModel.getObject(index: indexPath.section).slots[indexPath.row]
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
extension SelectLabTestTimeSlotVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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

extension SelectLabTestTimeSlotVC : HorizontalCalendarDelegate {
    
    func horizontalCalendarViewDidUpdate(_ calendar: HorizontalCalendarView, date: Date) {
        
        self.selectedDate               = date
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = self.dateFormat
        let strDate                     = formatter.string(from: self.selectedDate)
        //let dtDate                      = formatter.date(from: strDate)
        print("Updated calendarView \(strDate)")
        
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedAscending {
            self.vwCalendar.moveToDate(Date(), animated: false)
            
        }
        else {
            self.lblCalendarTitle.text  = strDate
            self.txtCalendarTitle.text  = strDate
            self.updateAPIData(withLoader: true)
        }
        //self.updateTimeSlot()
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension SelectLabTestTimeSlotVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        return true
    }
    
}

//MARK: -------------------- setupViewModel Observer --------------------
extension SelectLabTestTimeSlotVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
       
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
