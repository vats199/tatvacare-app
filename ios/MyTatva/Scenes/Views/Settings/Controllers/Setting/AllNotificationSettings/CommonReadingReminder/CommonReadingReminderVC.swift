
import UIKit

class CommonReadingReminderCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var btnSelect            : UIButton!
    @IBOutlet weak var btnExpand            : UIButton!
    
    @IBOutlet weak var lblSelectWeek        : UILabel!
    @IBOutlet weak var lblSelectFrequency   : UILabel!
    @IBOutlet weak var lblSelectTime        : UILabel!
    
    @IBOutlet weak var txtSelectWeek        : UITextField!
    @IBOutlet weak var txtSelectFrequency   : UITextField!
    @IBOutlet weak var txtSelectTime        : UITextField!
    @IBOutlet weak var stackData            : UIStackView!
    
    var pickerWeek                          = UIPickerView()
    var pickerFrequency                     = UIPickerView()
    var datePicker                          = UIDatePicker()
    var dateFormatter                       = DateFormatter()

    var arrTemp                             = ["1", "2", "3", "4"]
    var obj                                 = ReadingDetailModel()
    var notificationReadingReminderModel    = NotificationReadingReminderModel()
    var arrSelectedDays                     = [DaysListModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.lblSelectWeek
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblSelectFrequency
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblSelectTime
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.txtSelectWeek
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
        self.txtSelectFrequency
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
        self.txtSelectTime
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
        
//        self.lblTitle.font(name: .medium, size: 16)
//            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        
        self.initPicker()
        self.initDatePicker()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0, shdowRadious: 4)
        }
    }
}

//MARK: -------------------- Date picker methods --------------------
extension CommonReadingReminderCell {
    
    func initDatePicker(){
       
        self.txtSelectTime.inputView            = self.datePicker
        self.txtSelectTime.delegate             = self
        self.datePicker.datePickerMode          = .time
        self.datePicker.minuteInterval          = 15
//        self.datePicker.minimumDate             =  Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.datePicker.timeZone                = .current
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
            self.dateFormatter.dateFormat   = appTimeFormat
            self.dateFormatter.timeZone     = .current
            self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
            self.txtSelectTime.text         = self.dateFormatter.string(from: sender.date)
            
            self.dateFormatter.dateFormat   = DateTimeFormaterEnum.HHmmss.rawValue
            self.dateFormatter.timeZone     = .current
            self.obj.dayTime                = self.dateFormatter.string(from: sender.date)
            
            self.updateParentTable()
            break
        default:break
        }
    }
    
    func updateParentTable(){
//        if let tbl = self.superview as? UITableView {
//            tbl.reloadData()
//        }
    }
    
}

extension CommonReadingReminderCell {
    
    func initPicker(){
        
        self.pickerWeek.delegate            = self
        self.pickerWeek.dataSource          = self
        self.txtSelectWeek.delegate         = self
//        self.txtSelectWeek.inputView        = self.pickerWeek
        
        self.pickerFrequency.delegate       = self
        self.pickerFrequency.dataSource     = self
        self.txtSelectFrequency.delegate    = self
        self.txtSelectFrequency.inputView   = self.pickerFrequency
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension CommonReadingReminderCell : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        switch textField {
        case self.txtSelectTime:
            DispatchQueue.main.async {
                if self.txtSelectTime.text?.trim() == "" {
                    self.dateFormatter.dateFormat   = appTimeFormat
                    self.dateFormatter.timeZone     = .current
                    self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
                    self.txtSelectTime.text         = self.dateFormatter.string(from: self.datePicker.date)
                    
                    self.dateFormatter.dateFormat   = DateTimeFormaterEnum.HHmmss.rawValue
                    self.dateFormatter.timeZone     = .current
                    self.obj.dayTime                = self.dateFormatter.string(from: self.datePicker.date)
                    self.updateParentTable()
                }
            }
            break
        case self.txtSelectWeek:
            let vc = DaySelectionPopupVC.instantiate(fromAppStoryboard: .auth)
            vc.arrDaysOffline = self.arrSelectedDays
            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandler = { obj in
                self.arrSelectedDays = obj ?? []
                if obj?.count > 0 &&
                    obj != nil {
                    
                    let arr1 : [String] = self.arrSelectedDays.map { (object) -> String in
                        return String(object.daysKeys.prefix(3))
                    }
                    let arr2 : [String] = self.arrSelectedDays.map { (object) -> String in
                        return String(object.day.prefix(3))
                    }
                    self.obj.daysOfWeek     = arr1.joined(separator: ",")
                    self.txtSelectWeek.text = arr2.joined(separator: ",")
                    
//                    if let vc = UIApplication.topViewController() as? CommonReadingReminderVC {
//                        //vc.arrSelectedDays = self.arrSelectedDays
//                        vc.tblView1.reloadData()
//                    }
                }
            }
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            return false
            
//            if self.txtSelectWeek.text?.trim() == "" {
//                self.txtSelectWeek.text         = self.arrTemp[0]
//            }
            
        case self.txtSelectFrequency:
            DispatchQueue.main.async {
                if self.txtSelectFrequency.text?.trim() == "" {
                    self.txtSelectFrequency.text    = self.notificationReadingReminderModel.frequency[0].frequencyName
                    self.obj.frequency = self.notificationReadingReminderModel.frequency[0].key
                    self.updateParentTable()
                }
            }
            break
    
        default:
            break
        }
        return true
    }
}

extension CommonReadingReminderCell : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerWeek:
            return self.arrTemp.count
            
        case self.pickerFrequency:
            return self.notificationReadingReminderModel.frequency.count
        
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerWeek:
            return self.arrTemp[row]
            
        case self.pickerFrequency:
            
            return self.notificationReadingReminderModel.frequency[row].frequencyName
        
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pickerWeek:
//            self.txtSelectWeek.text = self.arrTemp[row]
            break
            
        case self.pickerFrequency:
            self.txtSelectFrequency.text =  self.notificationReadingReminderModel.frequency[row].frequencyName
            self.obj.frequency = self.notificationReadingReminderModel.frequency[row].key
            self.updateParentTable()
            break
       
        default: break
        }
    }
}

class CommonReadingReminderVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK: - UIControl's Outlets
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var tblView1             : UITableView!
    @IBOutlet weak var tblView1Height       : NSLayoutConstraint!
    
    @IBOutlet weak var tblView2             : UITableView!
    @IBOutlet weak var tblView2Height       : NSLayoutConstraint!
    @IBOutlet weak var btnSwitch            : UIButton!
    @IBOutlet weak var btnSubmit            : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK: - Class Variables
    let viewModel                   = CommonReadingReminderVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    var notification_master_id      = ""
    var object                      = NotificationReadingReminderModel()
    var isActive                    = ""
    let notificationSettingsVM      = NotificationSettingsVM()
    var arrSelectedDays             = [DaysListModel]()
    let daySelectionPopupVM         = DaySelectionPopupVM()
    
    var completionHandler: ((_ obj : StateListModel?) -> Void)?
    
    var arrDaysOffline : [JSON] = []
    var arrLanguage : [JSON] = [
        [
            "name" : "Abacavir.",
            "isSelected": 1,
        ],[
            "name" : "Abacavir / dolutegravir / lamivudine (Triumeq®) ",
            "isSelected": 0,
        ],
        [
            "name" : "Add Aba as a Drug",
            "isSelected": 0,
        ]
    ]
    
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        self.configureUI()
        self.manageActionMethods()
        self.addObserverOnHeightTbl()
        self.setupViewModelObserver()
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        
        self.lblTitle
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.setup(tblView: self.tblView1)
        self.setup(tblView: self.tblView2)
    }
    
    func setup(tblView: UITableView) {
        tblView.tableFooterView             = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource          = self
        tblView.emptyDataSetDelegate        = self
        tblView.delegate                    = self
        tblView.dataSource                  = self
        tblView.rowHeight                   = UITableView.automaticDimension
        tblView.reloadData()
//        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
//        tblView.addSubview(self.refreshControl)
    }
    
    func updateStatus(){
        if self.btnSwitch.isSelected {
            self.btnSwitch.isSelected = true
            self.btnSubmit.isUserInteractionEnabled = true
            self.btnSubmit.backGroundColor(color: UIColor.themePurple.withAlphaComponent(1))
        }
        else {
            self.btnSwitch.isSelected = false
            self.btnSubmit.isUserInteractionEnabled = false
            self.btnSubmit.backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.5))
        }
        self.tblView1.reloadData()
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        self.btnSwitch.addTapGestureRecognizer {
            
            self.notificationSettingsVM.update_notification_reminderAPI(notification_master_id: self.notification_master_id, is_active: !self.btnSwitch.isSelected) { [weak self] isDone in
                guard let self = self else {return}
                
                if isDone {
                    self.btnSwitch.isSelected = !self.btnSwitch.isSelected
                    if self.isActive == "Y" {
                        self.isActive = "N"
                    }
                    else {
                        self.isActive = "Y"
                    }
                    self.updateStatus()
                }
            }
        }
        
        self.btnSubmit.addTapGestureRecognizer {
            
            /*
             {
             {
               "notification_data": [
                 {
                   "days_of_week": "string",
                   "frequency": "string",
                   "day_time": "string",
                   "readings_master_id": "string",
                   "is_active": "Y"
                 }
               ]
             }
             
             */
                        
            for item in self.object.details {
                if item.isActive == "Y" {
                    if item.daysOfWeek.trim() == "" ||
                        item.frequency.trim() == "" ||
                        item.dayTime.trim() == "" {
                        
                        Alert.shared.showSnackBar(AppMessages.PleaseSelectAllVitals)
                        return
                    }
                }
            }
            
            var arrTemp = [[String: Any]]()
            for item in self.object.details {
                var obj                     = [String: Any]()
                obj["days_of_week"]         = item.daysOfWeek
                obj["frequency"]            = item.frequency
                obj["day_time"]             = item.dayTime
                obj["readings_master_id"]   = item.readingsMasterId
                obj["is_active"]            = item.isActive
                arrTemp.append(obj)
            }
            
            self.notificationSettingsVM.update_readings_notificationsAPI(notification_data: arrTemp) { [weak self] isDone in
                guard let self = self else {return}
                
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
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.daySelectionPopupVM.apiCallFromStart(refreshControl: self.refreshControl,
                                        tblView: nil,
                                        withLoader: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}


//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension CommonReadingReminderVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case self.tblView1:
            return self.object.details.count
            
        case self.tblView2:
            return 0
            
        default:
            return 0
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.tblView1:
            let cell : CommonReadingReminderCell = tableView.dequeueReusableCell(withClass: CommonReadingReminderCell.self, for: indexPath)
            
            
            let obj                         = self.object.details[indexPath.row]
            cell.obj                        = obj
            cell.notificationReadingReminderModel = self.object
            cell.btnSelect.isHidden         = false
            cell.lblTitle.text              = obj.readingName
            
            let arrBin = obj.daysOfWeek.components(separatedBy: ",")
            let arrTemp1 = self.arrSelectedDays.filter({ data in
                return arrBin.contains(data.daysKeys)
            })
            
            let arr : [String] = arrTemp1.map { (data) -> String in
                return String(data.day.prefix(3))
            }
            
            cell.txtSelectWeek.text = arr.joined(separator: ", ")
            cell.arrSelectedDays    = arrTemp1
            
            for item in self.object.frequency {
                if item.key == obj.frequency {
                    cell.txtSelectFrequency.text    = item.frequencyName
                }
            }
            
            let time = GFunction.shared.convertDateFormate(dt: obj.dayTime,
                                                           inputFormat: DateTimeFormaterEnum.HHmmss.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.hhmma.rawValue,
                                                           status: .NOCONVERSION)
            cell.txtSelectTime.text         = time.0
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.0) {
                if obj.isActive == "Y" {
                    cell.btnExpand.isSelected           = true
                    cell.btnSelect.isSelected           = true
                    
                    cell.stackData.isHidden             = false
                    cell.lblSelectWeek.isHidden         = false
                    cell.lblSelectFrequency.isHidden    = false
                    cell.lblSelectTime.isHidden         = false
                    cell.txtSelectWeek.isHidden         = false
                    cell.txtSelectFrequency.isHidden    = false
                    cell.txtSelectTime.isHidden         = false
                }
                else {
                    cell.btnExpand.isSelected           = false
                    cell.btnSelect.isSelected           = false
                    
                    cell.stackData.isHidden             = true
                    cell.lblSelectWeek.isHidden         = true
                    cell.lblSelectFrequency.isHidden    = true
                    cell.lblSelectTime.isHidden         = true
                    cell.txtSelectWeek.isHidden         = true
                    cell.txtSelectFrequency.isHidden    = true
                    cell.txtSelectTime.isHidden         = true
                }
                
                if self.isActive == "N" {
                    cell.btnExpand.isSelected           = false
                    cell.btnSelect.isSelected           = false
                    cell.btnSelect.alpha                = 0.5
                    
                    cell.stackData.isHidden             = true
                    cell.lblSelectWeek.isHidden         = true
                    cell.lblSelectFrequency.isHidden    = true
                    cell.lblSelectTime.isHidden         = true
                    cell.txtSelectWeek.isHidden         = true
                    cell.txtSelectFrequency.isHidden    = true
                    cell.txtSelectTime.isHidden         = true
                }
                else {
                    cell.btnSelect.alpha        = 1
                }
                
                UIView.performWithoutAnimation {
                    self.tblView1.performBatchUpdates {
                    }
                }
                
                if self.object.everydayRemind.remindEveryday == "Y" {
                    
                }
            }
            
            
            cell.btnSelect.addTapGestureRecognizer {
                if self.isActive == "Y" {
                    DispatchQueue.main.async {
                        obj.isActive = obj.isActive == "Y" ? "N" : "Y"
                        self.tblView1.reloadRows(at: [indexPath], with: .none)
                    }
                    
                    //                    DispatchQueue.main.async {
                    //                        UIView.performWithoutAnimation {
                    //                            self.tblView1.reloadData()
                    //                            self.tblView1.performBatchUpdates {
                    //                                self.tblView1.reloadData()
                    //                            } completion: { isDone in
                    //
                    //                            }
                    //                        }
                    //                    }
                }
            }
            
            
            return cell
            
        case self.tblView2:
            let cell : TrackMealReminderCell = tableView.dequeueReusableCell(withClass: TrackMealReminderCell.self, for: indexPath)
            
            cell.btnSelect.isHidden     = false
            cell.lblTitle.text          = self.object.everydayRemind.title
            cell.objEverydayRemind      = self.object.everydayRemind
            
            let time = GFunction.shared.convertDateFormate(dt: self.object.everydayRemind.remindEverydayTime,
                                                           inputFormat: DateTimeFormaterEnum.HHmmss.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.hhmma.rawValue,
                                                           status: .NOCONVERSION)
            cell.txtTime.text = time.0
            
            if self.object.everydayRemind.remindEveryday == "Y" {
                cell.btnSelect.isSelected = true
                cell.lblTitle
                    .font(name: .medium, size: 16)
                    .textColor(color: UIColor.themeBlack)
                cell.txtTime
                    .font(name: .medium, size: 14)
                    .textColor(color: UIColor.themePurple)
                cell.txtTime.isUserInteractionEnabled = true
                cell.imgEdit.alpha = 1
            }
            else {
                cell.btnSelect.isSelected = false
                cell.lblTitle
                    .font(name: .medium, size: 16)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
                cell.txtTime
                    .font(name: .medium, size: 14)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
                cell.txtTime.isUserInteractionEnabled = false
                cell.imgEdit.alpha = 0
            }
            
            cell.btnSelect.addTapGestureRecognizer {
                self.object.everydayRemind.remindEveryday = self.object.everydayRemind.remindEveryday == "Y" ? "N" : "Y"
                
                self.tblView1.reloadData()
                self.tblView2.reloadData()
                
                //                DispatchQueue.main.async {
                //                    UIView.performWithoutAnimation {
                //                        self.tblView1.reloadData()
                //                        self.tblView2.reloadData()
                //
                //                        self.tblView1.performBatchUpdates {
                //                            self.tblView1.reloadData()
                //                            self.tblView2.reloadData()
                //                        } completion: { isDone in
                //
                //                        }
                //                    }
                //                }
            }
            return cell
            
        default: break
        }
        
        
//        cell.btnSelect.isSelected = false
//        if object["isSelected"].intValue == 1 {
//            cell.btnSelect.isSelected = true
//        }
        
        return UITableViewCell()
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
//            let object = self.viewModel.getObject(index: indexPath.row)
//            if let completionHandler = self.completionHandler {
//                completionHandler(object)
//            }
//            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension CommonReadingReminderVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension CommonReadingReminderVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblView1, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            DispatchQueue.main.async {
                self.tblView1Height.constant = newvalue.height
                UIView.animate(withDuration: kAnimationSpeed) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        if let obj = object as? UITableView, obj == self.tblView2, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            DispatchQueue.main.async {
                self.tblView2Height.constant = newvalue.height
                UIView.animate(withDuration: kAnimationSpeed) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblView1.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblView2.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblView1 else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView2 = self.tblView2 else {return}
        if let _ = tblView2.observationInfo {
            tblView2.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------- setData Method --------------------
extension CommonReadingReminderVC {
    
    func setData(){
        self.btnSwitch.isSelected   = true
        if self.isActive == "N" {
            self.btnSwitch.isSelected = false
        }
        
        self.updateStatus()
//        DispatchQueue.main.async {
//            UIView.performWithoutAnimation {
//                self.tblView1.reloadData()
//                self.tblView1.performBatchUpdates {
//                    self.tblView1.reloadData()
//                } completion: { isDone in
//
//                }
//            }
//        }
        
        self.tblView1.reloadData()
        self.tblView2.reloadData()
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension CommonReadingReminderVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.daySelectionPopupVM.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.arrSelectedDays = self.daySelectionPopupVM.arrList
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}


