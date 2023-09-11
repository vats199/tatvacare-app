//
//  AppointmentDateAndTimeVC.swift
//  MyTatva
//
//  Created by Uttam patel on 02/06/23.
//

import Foundation

import UIKit

class AppointmentTimeSlotHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var imgHeading: UIImageView!
    
    
    //MARK:- Class Variable
    var arrData = [JSON]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.backGroundColor(color: .red)
//            self.vwBg.cornerRadius(cornerRadius: 20)
            
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 12.0)
        }
            //    .backGroundColor(color: UIColor.themeLightGray)
        }
    }


class AppointmentDateAndTimeVC: UIViewController {
    
    //----------------------------------
    //MARK:- UIControl's Outlets
   
    @IBOutlet weak var vwCalendarParent     : UIView!
    @IBOutlet weak var lblCalendarTitle     : UILabel!
    @IBOutlet weak var txtCalendarTitle     : UITextField!
    
    @IBOutlet weak var vwCalendar           : HorizontalCalendarView!
    
    @IBOutlet weak var vwTimeSlotParent     : UIView!
    @IBOutlet weak var lblChooseTime        : UILabel!
    @IBOutlet weak var colView              : UICollectionView!
    
    @IBOutlet weak var lblNoData            : UILabel!
    
    @IBOutlet weak var btnReviewDetails     : UIButton!
    
    @IBOutlet weak var vwBtn: UIView!
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    
    let viewModel                   = AppointmentDateAndTimeVM()
    var selectedTimeSlot            = ""
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
        
//        self.lblCalendarTitle.isHidden = true
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
        self.vwCalendar.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.vwCalendar.moveToDate(Date(), animated: false)
        }

        self.initDatePicker()
        self.configureUI()
        self.setup(colView: self.colView)
        self.setupViewModelObserver()
        
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        DispatchQueue.main.async {
            self.btnReviewDetails.layoutIfNeeded()
            self.btnReviewDetails.cornerRadius(cornerRadius: 10)
                .backGroundColor(color: UIColor.themePurple)
        }
    }
    
    func setup(colView: UICollectionView){
        colView.delegate                   = self
        colView.dataSource                 = self
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
    
    private func setupViewModelObserver() {
        self.viewModel.vmResult.bind { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.lblNoData.text = error.localizedDescription
                self.lblNoData.isHidden = false
                self.colView.isHidden = true
                self.lblChooseTime.isHidden = true
            case .success(_):
                self.lblNoData.isHidden = true
                self.colView.isHidden = false
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
    
    //----------------------------------------------------------------------------
    //MARK:- Button Action Methods
    
    @IBAction func btnReviewDetailsTapped(_ sender: UIButton) {

        let date = DateFormatter()
        date.dateFormat = DateTimeFormaterEnum.yyyymmdd.rawValue
        let stringDate : String = date.string(from: self.selectedDate)
        
        let dates = self.selectedTimeSlot.components(separatedBy: "-")

        let startTime: String = dates[0].trim()
        let endTime: String = dates[1].trim()
        
     /*   let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeFormaterEnum.hhmma.rawValue

        guard let start24 = dateFormatter.date(from: startTime) else { return }
        guard let end24 = dateFormatter.date(from: endTime) else { return }
        dateFormatter.dateFormat = "HH:mm"

        let startDate24 = dateFormatter.string(from: start24)
        let endDate24 = dateFormatter.string(from: end24) */

        if isFromPhysio {
            self.viewModel.update_bcp_hc_details(patient_plan_rel_id: self.viewModel.pateintPlanRefID, physiotherapist_availability_date: stringDate, physiotherapist_start_time: startTime, physiotherapist_end_time: endTime, withLoader: true) { isDone in
                if isDone {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            self.viewModel.update_bcp_hc_details(patient_plan_rel_id: self.viewModel.pateintPlanRefID, nutritionist_availability_date: stringDate, nutritionist_start_time: startTime, nutritionist_end_time: endTime, withLoader: true) { isDone in
                if isDone {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    


    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .BcpHcServiceSelectTimeSlot)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //WebengageManager.shared.navigateScreenEvent(screen: .SetUpGoalsReadings)
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        self.viewModel.get_bcp_time_slots(date: self.selectedDate,withLoader: true) { isDone in }
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
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension AppointmentDateAndTimeVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        
        case self.colView:
           return self.viewModel.numberOfSection()
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colView:
            return self.viewModel.numberofRows(section)
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AppointmentTimeSlotHeaderCell", for: indexPath) as! AppointmentTimeSlotHeaderCell
            
            headerView.lblTitle.text = self.viewModel.valueForHeader(indexPath.section)
            
            if self.viewModel.valueForHeader(indexPath.section) == "Morning" {
                headerView.imgHeading.image = UIImage(named: "ic_Morning")
            } else if self.viewModel.valueForHeader(indexPath.section) == "Evening" {
                headerView.imgHeading.image = UIImage(named: "ic_Evening")
            } else {
                headerView.imgHeading.image = UIImage(named: "ic_Afternoon")
            }
            
            headerView.backgroundColor = UIColor.white
            
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AppointmentTimeSlotHeaderCell", for: indexPath) as! AppointmentTimeSlotHeaderCell
            
            footerView.backgroundColor = UIColor.clear
            return footerView
            
        default:
            
//            assert(false, "Unexpected element kind")
            fatalError("Unexpected element kind")

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).count > 0 {
            if let headerView = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? AppointmentTimeSlotHeaderCell {
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
            
            let obj = self.viewModel.valueForCell(indexPath.section, row: indexPath.row)
            cell.lblTitle.text = obj
            
            cell.vwBg.backGroundColor(color: UIColor.white).borderColor(color: UIColor.themeGray3.withAlphaComponent(0.5))
            cell.lblTitle.font(name: .medium, size: 12)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
            
            if obj == self.selectedTimeSlot {
                cell.vwBg.backGroundColor(color: UIColor.themeLightPurple)
                cell.lblTitle.font(name: .medium, size: 12)
                    .textColor(color: UIColor.white)
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
            self.selectedTimeSlot = self.viewModel.valueForCell(indexPath.section, row: indexPath.row)
            self.selectedTimeDetails = self.viewModel.valueForHeader(indexPath.section)
            self.colView.reloadData()

            break

        default:break
        }
    }

              
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colView:
            let width       = colView.frame.size.width / 2
            let height      = 40 * ScreenSize.widthAspectRatio
            
            return CGSize(width: width,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
}



//MARK: -------------------------- HorizontalCalendar Delegate Methods --------------------------
extension AppointmentDateAndTimeVC : HorizontalCalendarDelegate {
    
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
                self.colView.reloadData()
                
                formatter.dateFormat = "EEE"
                if formatter.string(from: self.selectedDate) == "Sun" {
                    self.lblNoData.text = "No slots available for now, check for different date."
                    self.lblNoData.isHidden = false
                    self.colView.isHidden = true
                    self.lblChooseTime.isHidden = true
                }else {
                    self.lblNoData.isHidden = true
                    self.colView.isHidden = false
                    self.lblChooseTime.isHidden = false
                    FIRAnalytics.FIRLogEvent(eventName: .USER_CHANGES_DATE, screen: .BcpHcServiceSelectTimeSlot,parameter: nil)
                    self.viewModel.get_bcp_time_slots(date: self.selectedDate,withLoader: true) { [weak self] isDone in
                        guard let self = self else { return }
                        self.colView.reloadData()
                    }
                }
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: self.pendingRequest!)
        }
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension AppointmentDateAndTimeVC : UITextFieldDelegate {
    
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
                    self.colView.reloadData()
                }
                return true
            }
  
        default:
            break
        }
        
        return true
    }
    
}


