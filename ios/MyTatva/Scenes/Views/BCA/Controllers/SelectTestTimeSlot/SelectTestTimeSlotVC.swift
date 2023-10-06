//
//  SelectTestTimeSlotVC.swift
//  MyTatva
//
//  Created by Uttam patel on 09/08/23.
//


import Foundation
import UIKit

class DynamicCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = contentSize
        size.height += (contentInset.top + contentInset.bottom)
        size.width += (contentInset.left + contentInset.right)
        return size
    }
}

class SelectTestTimeSlotListCell : UITableViewCell {
    
    //MARK: - IBoutlet Variables -
    
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var imgDayType: UIImageView!
    @IBOutlet weak var colView: DynamicCollectionView!
    
    @IBOutlet weak var colHeightConstant: NSLayoutConstraint!
    //----------------------------------------------------------------------
    
    //MARK: - Custom Variables -
    
    
    var arrSlotData: [String] = []
    var selectedTimeSlot            = ""
    var selectedTimeDetails         = ""
    var completion: ((String) -> Void)?
    
    //----------------------------------------------------------------------
    
    //MARK: - custom Methods -
    func setup() {
        
        //        self.addObserverOnHeightTbl()
        
        self.applyStyle()
        //        self.setup(colView: self.colView)
    }
    
    func applyStyle() {
        
        self.vwBg.shadow(color: UIColor.themeBlack2.withAlphaComponent(0.7), shadowOffset: .zero, shadowOpacity: 0.2).cornerRadius(cornerRadius: 12.0)
        self.lblHeader.font(name: .bold, size: 14)
            .textColor(color: UIColor.themeBlack2)
        
    }
    
    func setup(colView: UICollectionView){
        colView.delegate                   = self
        colView.dataSource                 = self
        colView.reloadData()
        
    }
    
    override func awakeFromNib() {
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    deinit {
        //        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
}

class SelectTestTimeSlotVC: LightPurpleNavigationBase {
    //MARK: - Outlets -
    
    @IBOutlet weak var tblTimeSlot: UITableView!
    @IBOutlet weak var vwCalendarParent     : UIView!
    @IBOutlet weak var lblCalendarTitle     : UILabel!
    @IBOutlet weak var txtCalendarTitle     : UITextField!
    
    @IBOutlet weak var vwCalendar           : HorizontalCalendarView!
    
    @IBOutlet weak var vwCalendarHeader     : UIView!
    @IBOutlet weak var lblCalendarHeader    : UILabel!
    
    @IBOutlet weak var btnCalendarLeft      : UIButton!
    @IBOutlet weak var btnCalendarRight     : UIButton!
    
    @IBOutlet weak var svCalendar           : UIView!
    @IBOutlet weak var vwCalendarMain       : UIView!
    @IBOutlet weak var vwBottomBar          : UIView!
    @IBOutlet weak var calendar             : FSCalendar!
    @IBOutlet weak var calendarHeight       : NSLayoutConstraint!
    
    @IBOutlet weak var vwTimeSlotParent     : UIView!
    @IBOutlet weak var lblChooseTime        : UILabel!
    
    @IBOutlet weak var lblNoData            : UILabel!
    @IBOutlet weak var btnReviewDetails     : UIButton!
    
    @IBOutlet weak var vwBtn: UIView!
    
    //MARK: - Class Variables -
    
    let viewModel                   = SelectTestTimeSlotVM()
    
    var selectedTimeSlot            = ""{
        didSet {
            self.btnReviewDetails.isEnabled = !self.selectedTimeSlot.isEmpty
//            self.btnReviewDetails.alpha = self.selectedTimeSlot.isEmpty ? 0.5 : 1.0
            self.btnReviewDetails.backgroundColor = self.selectedTimeSlot.isEmpty ? .themeGray4 : .themePurple
        }
    }
    var selectedTimeDetails         = ""
    var selectedDate                = Date()
    var datePicker                  = UIDatePicker()
    var dateFormatter               = DateFormatter()
    var dateFormat                  = DateTimeFormaterEnum.MMMyyyy.rawValue
    var selectedFor                 = AppointmentFor.D
    var timerSearch                 = Timer()
    
    var pendingRequest: DispatchWorkItem?
    
    var completion : ((_ selectDate: Date, _ selectTime: String, _ selectTimeDetails: String) -> Void)? = nil
    
    var isFromPhysio                = false
    
    var cartListModel               = CartListModel()
    var labPatientListModel         : LabPatientListModel?
    var labAddressListModel         = LabAddressListModel()
    var isFromSelectPatient         = true
    
    //MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
    }
    
    private func setCalendaerSelection(date: Date, allowDateSelect: Bool){
        
        if allowDateSelect {
            self.calendar.select(date, scrollToDate: true)
        }
        
        self.dateFormatter.dateFormat   = DateTimeFormaterEnum.MMMyyyy.rawValue
        self.dateFormatter.timeZone     = .current
        self.lblCalendarHeader.text     = self.dateFormatter.string(from: date)
//
        let calendar                    = Calendar.current
        let isLeftVisible               = calendar.component(.weekOfYear, from: date) <= Calendar.current.component(.weekOfYear, from: self.calendar.minimumDate)
        self.btnCalendarLeft.alpha      = isLeftVisible ? 0.25 : 1.0
        self.btnCalendarLeft.isUserInteractionEnabled = !isLeftVisible
        
//        let isRightVisible              = calendar.component(.weekOfYear, from: date) >= Calendar.current.component(.weekOfYear, from: self.calendar.maximumDate)
//        self.btnCalendarRight.alpha     = isRightVisible ? 0.25 : 1.0
//        self.btnCalendarRight.isUserInteractionEnabled = !isRightVisible
        
    }
    
    //------------------------------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .BcpHcServiceSelectTimeSlot)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //WebengageManager.shared.navigateScreenEvent(screen: .SetUpGoalsReadings)
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            guard let self = self else { return }
            self.viewModel.get_appointment_slots(date: self.selectedDate, pinCode: JSON(self.labAddressListModel.pincode as Any).stringValue,withLoader: true) { isDone in
                DispatchQueue.main.async {
                    self.tblTimeSlot.reloadData()
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = self.parent?.parent as? TabbarVC {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
        //FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    //------------------------------------------------------------------------------------------
    
    
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //------------------------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        
        self.manageActionMethods()
        self.setCalendar()
        
        self.tblTimeSlot.dataSource = self
        self.tblTimeSlot.delegate = self
        
        //        self.lblCalendarTitle.isHidden = true
        
        self.lblCalendarHeader
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblCalendarTitle
            .font(name: .bold, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.txtCalendarTitle
            .font(name: .bold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblChooseTime
            .font(name: .bold, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.btnReviewDetails
            .font(name: .bold, size: 16)
            .textColor(color: UIColor.white)
        
        self.lblNoData
            .font(name: .bold, size: 14)
            .textColor(color: UIColor.themePurple).isHidden = true
        
        self.vwCalendarParent.cornerRadius(cornerRadius: 12)
        
        self.vwCalendar.isExcluded = true
        self.vwCalendar.excludingSunday()
     //   self.vwCalendar.delegate = self
        
        self.vwCalendarParent.cornerRadius(cornerRadius: 12)
        self.vwBottomBar.cornerRadius(cornerRadius: 2.0).backGroundColor(color: .ThemeDeviceShadow)
        self.svCalendar.layoutIfNeeded()
        self.svCalendar.backGroundColor(color: .BCPBG).roundCorners([.bottomLeft,.bottomRight], radius: 12.0)
        self.svCalendar.themeShadow()//applyViewShadow(shadowOffset: CGSize(width: 0, height: 3), shadowColor: UIColor.themeBlack, shadowOpacity: 0.2, shdowRadious: 4)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.vwCalendar.moveToDate(Date(), animated: false)
            /*self.svCalendar.layoutIfNeeded()
            self.svCalendar.backGroundColor(color: .BCPBG).roundCorners([.bottomLeft,.bottomRight], radius: 12.0)
            self.svCalendar.themeShadow()*/
        }
        
        self.initDatePicker()
        self.configureUI()
        //        self.setup(colView: self.colView)
        DispatchQueue.main.async {
            self.tblTimeSlot.reloadData()
        }
        self.setupViewModelObserver()
        
        //        self.vwBtn.isHidden = true
        self.btnReviewDetails.isEnabled = false
//        self.btnReviewDetails.alpha = 0.5
        
        self.btnReviewDetails.backGroundColor(color: .themeGray4)
        
        /*DispatchQueue.main.async {
            self.vwCalendarHeader.cornerRadius(cornerRadius: 5).layoutIfNeeded()
        }*/
        
        self.vwBtn.themeShadowBCP()
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        DispatchQueue.main.async {
            self.btnReviewDetails.layoutIfNeeded()
            self.btnReviewDetails.cornerRadius(cornerRadius: 16)
                .backGroundColor(color: UIColor.themeGray4)
        }
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
    
    private func setupViewModelObserver() {
        self.viewModel.vmResult.bind { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.lblNoData.numberOfLines = 0
                self.lblNoData.text = error.localizedDescription
                self.lblNoData.isHidden = false
                self.tblTimeSlot.isHidden = true
                self.lblChooseTime.isHidden = true
            case .success(_):
                self.lblNoData.isHidden = true
                self.tblTimeSlot.isHidden = false
                self.lblChooseTime.isHidden = false
            case .none:
                break
            }
            
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
    
    private func manageActionMethods() {
        self.btnCalendarLeft.addTapGestureRecognizer {
            self.view.endEditing(true)
            self.setCalenderSwipe(sender: self.btnCalendarLeft)
        }
        
        self.btnCalendarRight.addTapGestureRecognizer {
            self.view.endEditing(true)
            self.setCalenderSwipe(sender: self.btnCalendarRight)
        }
    }
    
    private func setCalenderSwipe(sender: UIButton){
        
        DispatchQueue.main.async {
            
            switch sender {
            case self.btnCalendarLeft:
                let dt = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: self.calendar.currentPage)
                self.calendar.setCurrentPage(dt!, animated: true)
                print(dt as Any)
                break
                
            case self.btnCalendarRight:
                let dt = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: self.calendar.currentPage)
                self.calendar.setCurrentPage(dt!, animated: true)
                print(dt as Any)
                break
                
            default:break
            }
        }
        
    }
    
    private func setCalendar(){
        self.selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        self.calendar.backgroundColor                   = .clear
        self.calendar.delegate                          = self
        self.calendar.dataSource                        = self
        self.calendar.today                             = self.selectedDate
        self.calendar.allowsMultipleSelection           = false
        self.calendar.allowsSelection                   = true
        self.calendar.appearance.todayColor             = UIColor.white
        self.calendar.appearance.selectionColor         = UIColor.themePurple
        self.calendar.appearance.titleSelectionColor    = UIColor.white
        self.calendar.appearance.headerTitleColor       = UIColor.systemPink
        self.calendar.appearance.weekdayTextColor       = UIColor.themeGray5
        self.calendar.appearance.titleDefaultColor      = UIColor.red
        //self.calendar.appearance.titleTodayColor      = UIColor.ColorGrey
        self.calendar.appearance.headerTitleFont        = UIFont.customFont(ofType: .regular, withSize: 12)
        self.calendar.appearance.weekdayFont            = UIFont.customFont(ofType: .regular, withSize: 12)
        self.calendar.appearance.titleFont              = UIFont.customFont(ofType: .regular, withSize: 14)
        self.calendar.weekdayHeight                     = 15
        self.calendar.appearance.caseOptions            = .headerUsesUpperCase
        self.calendar.firstWeekday                      = 2
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0
        self.calendar.headerHeight                      = 0
        self.calendar.scope                             = .week
        self.calendar.appearance.borderRadius           = 12
        self.setCalendaerSelection(date: self.selectedDate, allowDateSelect: true)
        self.calendar.reloadData()
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Button Action Methods
    
    @IBAction func btnReviewDetailsTapped(_ sender: UIButton) {
        
//        let date = DateFormatter()
//        date.dateFormat = DateTimeFormaterEnum.yyyymmdd.rawValue
//        let stringDate : String = date.string(from: self.selectedDate)
//
//        let dates = self.selectedTimeSlot.components(separatedBy: "-")
//
//        let startTime: String = dates.first?.trim() ?? ""
//        let endTime: String = dates.last?.trim() ?? ""
        
        let vc = OrderReviewVC.instantiate(fromAppStoryboard: .BCP_temp)
        vc.cartListModel            = self.cartListModel
        vc.labAddressListModel      = self.labAddressListModel
        vc.selectedTimeTitle        = self.selectedTimeDetails
        vc.selectedTimeSlot         = self.selectedTimeSlot
        vc.selectedDate             = self.selectedDate
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    override func popViewController(sender: AnyObject) {
        print("back tapped")
        
        guard self.isFromSelectPatient else  {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        guard let arrViewController = self.navigationController?.viewControllers else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        _ = arrViewController.map({
            if $0.isKind(of: SelectPatientDetailsVC.self) {
                self.navigationController?.popToViewController($0, animated: true)
            }
        })
    }
    //----------------------------------------------------------------------------
    
}

// MARK: - TableViewDataSource

extension SelectTestTimeSlotVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfSection()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SelectTestTimeSlotListCell.self)
        
        cell.lblHeader.text = self.viewModel.valueForHeader(indexPath.row)
        cell.selectedTimeSlot = self.selectedTimeSlot
        self.btnReviewDetails.isEnabled = self.selectedTimeSlot.isEmpty ? false : true
//        self.btnReviewDetails.alpha = self.selectedTimeSlot.isEmpty ? 0.5 : 1
        self.btnReviewDetails.backgroundColor = self.selectedTimeSlot.isEmpty ? .themeGray4 : .themePurple
        
        cell.colView.tag = indexPath.row
        cell.completion = { timeSlot in
            self.selectedTimeDetails = self.viewModel.valueForHeader(cell.colView.tag)
            self.selectedTimeSlot = timeSlot
            DispatchQueue.main.async {
                self.tblTimeSlot.reloadData()
            }
            
        }
        
        cell.imgDayType.setCustomImage(with: self.viewModel.valueForCollection(indexPath.row).icon_url)
        cell.arrSlotData = self.viewModel.valueForCollection(indexPath.row).slots
        cell.setup(colView: cell.colView)
        cell.layoutIfNeeded()
        return cell
    }
}


//MARK: -------------------------- UICollectionView Methods --------------------------
extension SelectTestTimeSlotListCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            
        case self.colView:
            return self.arrSlotData.count
            
        default:
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case self.colView:
            let cell : DiscoverEngageFilterTypeCell = collectionView.dequeueReusableCell(withClass: DiscoverEngageFilterTypeCell.self, for: indexPath)
            
            let obj = self.arrSlotData[indexPath.row]
            
            var title = obj.replacingOccurrences(of: "AM", with: "")
            title = title.replacingOccurrences(of: "PM", with: "")
            
            cell.lblTitle.text = title
            
            cell.vwBg.backGroundColor(color: UIColor.white).borderColor(color: UIColor.themeGray3.withAlphaComponent(0.5))
            cell.lblTitle.font(name: .medium, size: 12)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
            
            if obj == self.selectedTimeSlot {
                cell.vwBg.backGroundColor(color: UIColor.themeLightPurple.withAlphaComponent(0.07)).borderColor(color: UIColor.themePurpleBlack2).applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.ThemeDeviceShadow, shadowOpacity: 0.5)
                cell.lblTitle.font(name: .semibold, size: 12)
                cell.lblTitle.font(name: .semibold, size: 12)
                    .textColor(color: UIColor.themeBlack2)
            } else {
                cell.vwBg.backGroundColor(color: UIColor.white).borderColor(color: UIColor.themeGray3.withAlphaComponent(0.5))
                cell.lblTitle.font(name: .medium, size: 12)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case self.colView:
            self.selectedTimeSlot = self.arrSlotData[indexPath.row]
            self.completion?(self.selectedTimeSlot)
            //            self.colView.reloadData()
            
            break
            
        default:break
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
            
        case self.colView:
            let font = UIFont.customFont(ofType: .medium, withSize: 12.0)
            var wid = "00:00 - 00:00".widthOfString(usingFont: font)
            wid = wid + 24
            let width       = wid
            let height      = 40 * ScreenSize.widthAspectRatio
            
            
            return CGSize(width: width,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: -------------------------- HorizontalCalendar Delegate Methods --------------------------
extension SelectTestTimeSlotVC : HorizontalCalendarDelegate {
    
    func horizontalCalendarViewDidUpdate(_ calendar: HorizontalCalendarView, date: Date) {
        
        self.pendingRequest?.cancel()
        
        self.selectedDate               = date
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = self.dateFormat
        let strDate                     = formatter.string(from: self.selectedDate)
        print("Updated calendarView \(strDate)")
        
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedAscending {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.vwCalendar.moveToDate(Date(), animated: false)
            }
        }
        else {
            self.pendingRequest = DispatchWorkItem{ [weak self] in
                guard let self = self else { return }
                self.selectedTimeSlot = ""
                self.txtCalendarTitle.text  = strDate
                self.tblTimeSlot.reloadData()
                
                formatter.dateFormat = "EEE"
                if formatter.string(from: self.selectedDate) == "Sun" {
                    self.lblNoData.text = "No slots available for now, check for different date."
                    self.lblNoData.isHidden = false
                    self.tblTimeSlot.isHidden = true
                    self.lblChooseTime.isHidden = true
                }else {
                    self.lblNoData.isHidden = true
                    self.tblTimeSlot.isHidden = false
                    self.lblChooseTime.isHidden = false
                    self.viewModel.get_appointment_slots(date: self.selectedDate, pinCode: JSON(self.labAddressListModel.pincode as Any).stringValue,withLoader: true) { [weak self] isDone in
                        guard let self = self else { return }
                        self.tblTimeSlot.reloadData()
                    }
                }
                
            }
            self.viewModel.arrSlotsData.removeAll()
            self.tblTimeSlot.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: self.pendingRequest!)
        }
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension SelectTestTimeSlotVC : UITextFieldDelegate {
    
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
                    DispatchQueue.main.async {
                        self.tblTimeSlot.reloadData()
                    }
                }
                return true
            }
            
        default:
            break
        }
        
        return true
    }
    
}

//MARK: -------------------------- Observers Methods --------------------------
extension SelectTestTimeSlotListCell {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UICollectionView, obj == self.colView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            let oldHeight = self.colHeightConstant.constant
            self.colHeightConstant.constant = newvalue.height
            
            if let tbl = self.superview as? UITableView {
                if oldHeight != self.colHeightConstant.constant {
                    tbl.performBatchUpdates {
                        
                    } completion: { isDone in
                        
                    }
                    tbl.layoutIfNeeded()
                    
                    //                    tbl.beginUpdates()
                    //                    tbl.endUpdates()
                }
            }
        }
    }
    
    func addObserverOnHeightTbl() {
        self.colView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let colView = self.colView else {return}
        if let _ = colView.observationInfo {
            colView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
//MARK: -------------------------- FSCalendar Delegate Method --------------------------
extension SelectTestTimeSlotVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        print("Calendar height:",bounds)
        self.calendarHeight.constant = bounds.height
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .year, value: 5, to: Date()) ?? Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
//        guard self.selectedDate != date else { return }
        
        self.selectedDate = date
        self.selectedTimeSlot = ""
        self.viewModel.arrSlotsData.removeAll()
        self.tblTimeSlot.reloadData()
        self.viewModel.get_appointment_slots(date: self.selectedDate, pinCode: JSON(self.labAddressListModel.pincode as Any).stringValue,withLoader: true) { [weak self] isDone in
            guard let self = self else { return }
            self.tblTimeSlot.reloadData()
        }
        self.setCalendaerSelection(date: date, allowDateSelect: true)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return UIColor.clear
    }
    
    //    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
    //        return UIColor.clear
    //    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return date <= Date() ? UIColor.colorFromHex(hex: 0x9E9E9E) : .themeGray5
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.setCalendaerSelection(date: calendar.currentPage, allowDateSelect: false)
        
        
        //        self.updateAPIData(withLoader: true)
        self.selectedDate               = calendar.currentPage
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = self.dateFormat
        let strDate                     = formatter.string(from: self.selectedDate)
        /*self.viewModel.get_appointment_slots(date: self.selectedDate, pinCode: JSON(self.labAddressListModel.pincode as Any).stringValue,withLoader: true) { [weak self] isDone in
         guard let self = self else { return }
         self.tblTimeSlot.reloadData()
         }*/
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    }
}



