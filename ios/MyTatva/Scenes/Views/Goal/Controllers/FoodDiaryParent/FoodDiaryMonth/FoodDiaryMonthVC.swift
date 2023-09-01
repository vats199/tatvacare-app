
//
//  FoodDiaryMonthVC.swift
//  MyTatva
//
//  Created by Darshan Joshi on 26/10/21.
//

import UIKit

class FoodDiaryMonthVC: WhiteNavigationBaseVC {
    
    //MARK: -------------------------- Outlet --------------------------
    @IBOutlet weak var vwBg                         : UIView!
    @IBOutlet weak var vwCalendarHeader             : UIView!
    @IBOutlet weak var lblCalendarHeader            : UILabel!
    
    @IBOutlet weak var btnCalendarLeft              : UIButton!
    @IBOutlet weak var btnCalendarRight             : UIButton!
    
    @IBOutlet weak var calendar                     : FSCalendar!
    
    @IBOutlet weak var lblWhatDoesCircle            : UILabel!
    @IBOutlet weak var btnSelectWhatDoesCircle      : UIButton!
    
    @IBOutlet weak var vwCircleMeanParent           : UIView!
    @IBOutlet weak var vwcaloriesLimit              : UIView!
    @IBOutlet weak var lblcaloriesLimit             : UILabel!
    
    @IBOutlet weak var vwcaloriesLess               : UIView!
    @IBOutlet weak var lblcaloriesLess              : UILabel!
    
    @IBOutlet weak var vwcaloriesExcess             : UIView!
    @IBOutlet weak var lblcaloriesExcess            : UILabel!
    
    
    //MARK: -------------------------- Class Variable --------------------------
    var dateFormatter           = DateFormatter()
    var isEdit                  = false
    var viewModel               = FoodDiaryMonthVM()
    var strErrorMessage         = ""
    
    var month                   = 0
    var year                    = 0
    
    //MARK: -------------------------- Memory Management Method --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: -------------------------- Custom Method --------------------------
    
    private func setUpView() {
        
        self.applyFont()
        self.setCalendar()
        self.manageActionMethods()
        self.setupViewModelObserver()
        
        self.vwcaloriesLimit.backGroundColor(color: UIColor.colorCalorieLimit)
        self.vwcaloriesLess.backGroundColor(color: UIColor.colorCalorieLess)
        self.vwcaloriesExcess.backGroundColor(color: UIColor.colorCalorieExcess)
        
        DispatchQueue.main.async {
            self.vwcaloriesLimit.layoutIfNeeded()
            self.vwcaloriesLess.layoutIfNeeded()
            self.vwcaloriesExcess.layoutIfNeeded()
            self.vwCalendarHeader.layoutIfNeeded()
            
            self.vwcaloriesLimit.cornerRadius(cornerRadius: self.vwcaloriesLimit.frame.height / 2)
            self.vwcaloriesLess.cornerRadius(cornerRadius: self.vwcaloriesLess.frame.height / 2)
            self.vwcaloriesExcess.cornerRadius(cornerRadius: self.vwcaloriesExcess.frame.height / 2)
            self.vwCalendarHeader.cornerRadius(cornerRadius: 5)
            
            self.btnSelectWhatDoesCircle.isSelected = true
            self.handleCircleMeanParent(isHide: false)
        }
      
    }
    
    private func applyFont(){
        
        self.lblCalendarHeader
            .font(name: .bold, size: 18)
            .textColor(color: UIColor.themeBlack)
        
        self.lblWhatDoesCircle
            .font(name: .regular, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.lblcaloriesLimit
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblcaloriesLess
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblcaloriesExcess
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
    }
    
    private func setCalendar(){
        self.calendar.delegate                          = self
        self.calendar.today                             = Date()
        self.calendar.allowsMultipleSelection           = false
        self.calendar.allowsSelection                   = true
        self.calendar.appearance.todayColor             = UIColor.themeBlack
        self.calendar.appearance.selectionColor         = UIColor.themeBlack
        self.calendar.appearance.titleSelectionColor    = UIColor.white
        self.calendar.appearance.headerTitleColor       = UIColor.systemPink
        self.calendar.appearance.weekdayTextColor       = UIColor.themeBlack
        self.calendar.appearance.titleDefaultColor      = UIColor.themeBlack
        //self.calendar.appearance.titleTodayColor      = UIColor.ColorGrey
        self.calendar.appearance.headerTitleFont        = UIFont.customFont(ofType: .regular, withSize: 16)
        self.calendar.appearance.weekdayFont            = UIFont.customFont(ofType: .regular, withSize: 16)
        self.calendar.appearance.titleFont              = UIFont.customFont(ofType: .regular, withSize: 16)
        self.calendar.appearance.caseOptions            = .headerUsesUpperCase
        self.calendar.firstWeekday                      = 1
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0
        self.calendar.headerHeight                      = 0
        self.setCalendaerSelection(date: Date(), allowDateSelect: true)
        self.calendar.reloadData()
    }
    
    private func handleCircleMeanParent(isHide: Bool){
        UIView.animate(withDuration: 0.5) {
            if isHide {
                self.vwCircleMeanParent.isHidden = true
            }
            else {
                self.vwCircleMeanParent.isHidden = false
            }
        }
    }
    
    //MARK: -------------------------- Action Method --------------------------
    private func manageActionMethods(){
        
        self.btnCalendarLeft.addTapGestureRecognizer {
            self.view.endEditing(true)
            self.setCalenderSwipe(sender: self.btnCalendarLeft)
        }
        
        self.btnCalendarRight.addTapGestureRecognizer {
            self.view.endEditing(true)
            self.setCalenderSwipe(sender: self.btnCalendarRight)
        }
        
        self.btnSelectWhatDoesCircle.addTapGestureRecognizer {
            if self.btnSelectWhatDoesCircle.isSelected {
                self.btnSelectWhatDoesCircle.isSelected = false
                self.handleCircleMeanParent(isHide: true)
            }
            else {
                self.btnSelectWhatDoesCircle.isSelected = true
                self.handleCircleMeanParent(isHide: false)
            }
        }
    }
    
    private func setCalendaerSelection(date: Date, allowDateSelect: Bool){
        
        if allowDateSelect {
            self.calendar.select(date, scrollToDate: true)
        }
        
        self.dateFormatter.dateFormat   = DateTimeFormaterEnum.MMMM.rawValue
        self.dateFormatter.timeZone     = .current
        self.lblCalendarHeader.text     = self.dateFormatter.string(from: date)
    }
    
    private func setCalenderSwipe(sender: UIButton){
        
        DispatchQueue.main.async {
            switch sender {
            case self.btnCalendarLeft:
                
                let dt = Calendar.current.date(byAdding: .month, value: -1, to: self.calendar.currentPage)
                self.calendar.setCurrentPage(dt!, animated: true)
                break
                
            case self.btnCalendarRight:
                let dt = Calendar.current.date(byAdding: .month, value: 1, to: self.calendar.currentPage)
                self.calendar.setCurrentPage(dt!, animated: true)
                break
                
            default:break
            }
        }
        
    }
    
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .FoodDiaryMonth)
        
        self.navigationController?.clearNavigation()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.updateAPIData(withLoader: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .FoodDiaryMonth, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAnalytics.manageTimeSpent(on: .FoodDiaryMonth, when: .Disappear)
    }
}


//MARK: -------------------------- Set data --------------------------
extension FoodDiaryMonthVC {

    @objc func updateAPIData(withLoader: Bool = false){
      
        self.month = Calendar.current.component(.month, from: self.calendar.currentPage)
        self.year = Calendar.current.component(.year, from: self.calendar.currentPage)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
            
            self.viewModel.apiCallFromStart(month: "\(self.month)",
                                            year: "\(self.year)",
                                            withLoader: withLoader)
        }
    }
    
    func setData(){
        
    }
}

//MARK: -------------------------- FSCalendar Delegate Method --------------------------
extension FoodDiaryMonthVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedAscending ||
            Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedSame {
            
            if let vc = UIApplication.topViewController() as? FoodDiaryParentVC {
                vc.selectedDate = date
                vc.goPrevious()
            }
        }
        
        ///OLD LOGIC
        /*
         dateFormatter.dateFormat    = DateTimeFormaterEnum.yyyymmdd.rawValue
         dateFormatter.timeZone      = .current
         let strDate                 = dateFormatter.string(from: date)
         
         if self.viewModel.arrList.count > 0 {
             if self.viewModel.arrList.contains(where: { (obj) -> Bool in
                 if obj.achievedDate == strDate {
                     if obj.achievedValue > 0 {
                         return true
                     }
                 }
                 return false
             }) {
                 let vc = FoodDiaryDetailVC.instantiate(fromAppStoryboard: .goal)
                 let dateFormatter           = DateFormatter()
                 dateFormatter.dateFormat    = DateTimeFormaterEnum.yyyymmdd.rawValue
                 dateFormatter.timeZone      = .current
                 vc.insight_date             = dateFormatter.string(from: date)
                 dateFormatter.dateFormat    = DateTimeFormaterEnum.MMMDD.rawValue
                 dateFormatter.timeZone      = .current
                 vc.dateMonth                = dateFormatter.string(from: date)
                 self.navigationController?.pushViewController(vc, animated: true)
             }
         }
         
         */
        
        
        self.setCalendaerSelection(date: date, allowDateSelect: true)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        dateFormatter.dateFormat    = DateTimeFormaterEnum.yyyymmdd.rawValue
        dateFormatter.timeZone      = .current
        let strDate                 = dateFormatter.string(from: date)
        
        if self.viewModel.arrList.count > 0 {
            var strColor = ""
            if self.viewModel.arrList.contains(where: { (obj) -> Bool in
                if obj.achievedDate == strDate {
                    if obj.achievedValue > 0 {
                        strColor = obj.colorCode
                        return true
                    }
                }
                return false
            }) {
                return UIColor.init(hexString: strColor)
            }
        }
        
        return UIColor.clear
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
//        return UIColor.clear
//    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        dateFormatter.dateFormat    = DateTimeFormaterEnum.yyyymmdd.rawValue
        dateFormatter.timeZone      = .current
        let strDate                 = dateFormatter.string(from: date)
        
        if self.viewModel.arrList.count > 0 {
            
            if self.viewModel.arrList.contains(where: { (obj) -> Bool in
                if obj.achievedDate == strDate {
                    if obj.achievedValue > 0 {
                        
                        return true
                    }
                }
                return false
            }) {
                return UIColor.themeBlack
            }
        }
        
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedDescending {
            return UIColor.themeGray
        }
        return UIColor.themeBlack
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.setCalendaerSelection(date: calendar.currentPage, allowDateSelect: false)
        self.updateAPIData(withLoader: true)
    }
    
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return Date()
//    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension FoodDiaryMonthVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                DispatchQueue.main.async {
                    self.strErrorMessage = self.viewModel.strErrorMessage
                    self.calendar.reloadData()
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
