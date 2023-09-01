
import UIKit
import SwiftUI

class DrinkWaterReminderCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnSelect    : UIButton!
    @IBOutlet weak var txtTime      : UITextField!
    @IBOutlet weak var imgEdit      : UIImageView!
    
    
    var pickerView                  = UIPickerView()
    var obj                         = DetailModel()
    var notificationWaterReminderModel = NotificationWaterReminderModel()
    
    var arrTemp = ["1", "2", "3", "4"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.txtTime.font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
        
//        self.lblTitle.font(name: .medium, size: 16)
//            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        
        self.initPicker()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0, shdowRadious: 4)
        }
    }
}

//MARK: -------------------- Date picker methods --------------------
extension DrinkWaterReminderCell {
    
    func initPicker(){
        
        self.pickerView.delegate     = self
        self.pickerView.dataSource   = self
        self.txtTime.delegate        = self
        self.txtTime.inputView       = self.pickerView
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension DrinkWaterReminderCell : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtTime:
            
            if self.txtTime.text?.trim() == "" {
                if obj.valueType == "hour" {
                    self.txtTime.text = self.notificationWaterReminderModel.hoursData[0].title
                    self.obj.value = "\(self.notificationWaterReminderModel.hoursData[0].value!)"
                }
                else if obj.valueType == "times" {
                    self.txtTime.text = self.notificationWaterReminderModel.timesData[0].title
                    self.obj.value = "\(self.notificationWaterReminderModel.timesData[0].value!)"
                }
            }
            break
    
        default:
            break
        }
        return true
    }
}

extension DrinkWaterReminderCell : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerView:
            if obj.valueType == "hour" {
                return self.notificationWaterReminderModel.hoursData.count
            }
            else if obj.valueType == "times" {
                return self.notificationWaterReminderModel.timesData.count
            }
        
            return 0
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerView:
            if obj.valueType == "hour" {
                return self.notificationWaterReminderModel.hoursData[row].title
            }
            else if obj.valueType == "times" {
                return self.notificationWaterReminderModel.timesData[row].title
            }
            return ""
        
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pickerView:
            if self.obj.valueType == "hour" {
                self.txtTime.text = self.notificationWaterReminderModel.hoursData[row].title
                self.obj.value = "\(self.notificationWaterReminderModel.hoursData[row].value!)"
                
            }
            else if self.obj.valueType == "times" {
                self.txtTime.text = self.notificationWaterReminderModel.timesData[row].title
                self.obj.value = "\(self.notificationWaterReminderModel.timesData[row].value!)"
            }
            break
       
        default: break
        }
    }
}

class DrinkWaterReminderVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var tblView1             : UITableView!
    @IBOutlet weak var tblView1Height       : NSLayoutConstraint!
    
    @IBOutlet weak var tblView2             : UITableView!
    @IBOutlet weak var tblView2Height       : NSLayoutConstraint!
    @IBOutlet weak var btnSwitch            : UIButton!
    @IBOutlet weak var btnSubmit            : UIButton!
    
    @IBOutlet weak var lblStartTime         : UILabel!
    @IBOutlet weak var lblEndTime           : UILabel!
    @IBOutlet weak var txtStartTime         : UITextField!
    @IBOutlet weak var txtStartTimeWidth    : NSLayoutConstraint!
    @IBOutlet weak var txtEndTime           : UITextField!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = DrinkWaterReminderVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    
    var startDatePicker             = UIDatePicker()
    var endDatePicker               = UIDatePicker()
    var dateFormatter               = DateFormatter()
    
    var type: GoalType              = .Pranayam
    var notification_master_id      = ""
    var object                      = NotificationWaterReminderModel()
    let notificationSettingsVM      = NotificationSettingsVM()
    var isActive                    = ""
    
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
        self.setData()
        self.initDatePicker()
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        
        self.lblTitle
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.txtStartTime.delegate = self
        self.txtEndTime.delegate = self
        
        
        
        self.lblStartTime
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblEndTime
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.txtStartTime
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.txtEndTime
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
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
            var isValid = true
            if self.txtStartTime.text?.trim() == "" {
                Alert.shared.showSnackBar(AppMessages.SelectFromTime)
                isValid = false
            }
            else if self.txtEndTime.text?.trim() == "" {
                Alert.shared.showSnackBar(AppMessages.SelectToTime)
                isValid = false
            }
            else if self.object.everydayRemind.remindEveryday == "N" {
                for item in self.object.details {
                    if item.valueType == "hour" &&
                        item.value.trim() == "" {
                        Alert.shared.showSnackBar(AppMessages.SelectRemindMeEvery)
                        isValid = false
                    }
                    else if item.valueType == "times" &&
                                item.value.trim() == "" {
                        Alert.shared.showSnackBar(AppMessages.SelectRemindMe)
                        isValid = false
                    }
                }
            }
            
            if isValid {
                var reminds_type        = ""
                var remind_every        = ""
                var total_reminds       = ""
                if self.object.everydayRemind.remindEveryday == "N" {
                    for item in self.object.details {
                        if item.valueType == "hour" &&
                            item.isActive == "Y" {
                            reminds_type = "H"
                        }
                        else if item.valueType == "times" &&
                                    item.isActive == "Y"{
                            reminds_type = "T"
                        }
                    }
                    
                    for item in self.object.details {
                        if item.valueType == "hour" {
                            remind_every = item.value
                        }
                        else if item.valueType == "times" {
                            total_reminds = item.value
                        }
                    }
                }
                
                let startTime = GFunction.shared.convertDateFormate(dt: self.txtStartTime.text!,
                                                               inputFormat: DateTimeFormaterEnum.hhmma.rawValue,
                                                               outputFormat: DateTimeFormaterEnum.HHmmss.rawValue,
                                                               status: .NOCONVERSION)
                
                let endTime = GFunction.shared.convertDateFormate(dt: self.txtEndTime.text!,
                                                               inputFormat: DateTimeFormaterEnum.hhmma.rawValue,
                                                               outputFormat: DateTimeFormaterEnum.HHmmss.rawValue,
                                                               status: .NOCONVERSION)
                
                self.notificationSettingsVM.update_water_reminderAPI(notification_master_id: self.notification_master_id,
                                                                     notify_from: startTime.0,
                                                                     notify_to: endTime.0,
                                                                     remind_every: remind_every,
                                                                     total_reminds: total_reminds,
                                                                     remind_everyday: self.object.everydayRemind.remindEveryday,
                                                                     is_active: self.isActive,
                                                                     reminds_type: reminds_type,
                                                                     remind_everyday_time: self.object.everydayRemind.remindEverydayTime) { [weak self] isDone in
                    guard let self = self else {return}
                    if isDone {
                        self.navigationController?.popViewController(animated: true)
                    }
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

//MARK: -------------------- Date picker methods --------------------
extension DrinkWaterReminderVC {
    
    func initDatePicker(){
       
        self.txtStartTime.inputView             = self.startDatePicker
        self.txtStartTime.delegate              = self
        self.startDatePicker.datePickerMode     = .time
        self.startDatePicker.minuteInterval     = 15
        
//        self.datePicker.minimumDate             =  Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.startDatePicker.timeZone                = .current
        self.startDatePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
       
        if #available(iOS 14, *) {
            self.startDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        self.txtEndTime.inputView               = self.endDatePicker
        self.txtEndTime.delegate                = self
        self.endDatePicker.datePickerMode       = .time
        self.endDatePicker.minuteInterval       = 15
//        self.endDatePicker.minimumDate          = Calendar.current.date(byAdding: .minute, value: 15, to: self.startDatePicker.date)
        self.endDatePicker.timeZone             = .current
        self.endDatePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
        //self.txtEndTime.text = ""
        
        if #available(iOS 14, *) {
            self.endDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.startDatePicker:
            self.dateFormatter.dateFormat   = appTimeFormat
            self.dateFormatter.timeZone     = .current
            self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
            self.txtStartTime.text          = self.dateFormatter.string(from: sender.date)
            
            //self.endDatePicker.minimumDate          = Calendar.current.date(byAdding: .minute, value: 15, to: self.startDatePicker.date)
            
            let width = self.txtStartTime.getWidth(text: self.txtStartTime.text!)
            self.txtStartTimeWidth.constant = width
            
            self.txtEndTime.text = ""
            break
            
        case self.endDatePicker:
            self.dateFormatter.dateFormat   = appTimeFormat
            self.dateFormatter.timeZone     = .current
            self.dateFormatter.locale           = NSLocale(localeIdentifier: "en_US") as Locale
            self.txtEndTime.text            = self.dateFormatter.string(from: sender.date)
            break
        default:break
        }
    }
    
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension DrinkWaterReminderVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case self.tblView1:
            return self.object.details.count
            
        case self.tblView2:
            return 1
            
        default:
            return 0
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.tblView1:
            let cell : DrinkWaterReminderCell = tableView.dequeueReusableCell(withClass: DrinkWaterReminderCell.self, for: indexPath)
            
            let obj                     = self.object.details[indexPath.row]
            cell.obj                    = obj
            cell.notificationWaterReminderModel = self.object
            cell.btnSelect.isHidden     = false
            cell.lblTitle.text          = obj.title
            
            if obj.valueType == "hour" {
                for item in self.object.hoursData {
                    if "\(item.value!)" == obj.value {
                        cell.txtTime.text = item.title
                    }
                }
            }
            else if obj.valueType == "times" {
                for item in self.object.timesData {
                    if item.title.contains(obj.value) {
                        cell.txtTime.text = item.title
                    }
                }
            }
            
            if obj.isActive == "Y" {
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
                
                for i in 0...self.object.details.count - 1 {
                    let data = self.object.details[i]
                    if data.valueType == obj.valueType {
                        data.isActive = "Y"
                    }
                    else {
                        data.isActive = "N"
                    }
                }
                
//                obj.isActive = obj.isActive == "Y" ? "N" : "Y"
                self.tblView1.reloadData()
                
                self.object.everydayRemind.remindEveryday = "N"
                self.tblView2.reloadData()
            }
            
            if self.object.everydayRemind.remindEveryday == "Y" {
                cell.imgEdit.alpha = 0
                cell.txtTime.isUserInteractionEnabled = false
                cell.txtTime
                    .font(name: .medium, size: 15)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
            }
            else {
                //cell.imgEdit.alpha = 1
                //cell.txtTime.isUserInteractionEnabled = true
                //cell.txtTime
                 //   .font(name: .medium, size: 15)
                 //   .textColor(color: UIColor.themePurple)
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
                self.tblView2.reloadRows(at: [indexPath], with: .automatic)
                
                if self.object.everydayRemind.remindEveryday == "N" {
                    if self.object.details.count > 0 {
                        for i in 0...self.object.details.count - 1{
                            let data = self.object.details[i]
                            if i == 0 {
                                data.isActive = "Y"
                            }
                            else {
                                data.isActive = "N"
                            }
                        }
                    }
                }
                else {
                    if self.object.details.count > 0 {
                        for i in 0...self.object.details.count - 1{
                            let data = self.object.details[i]
                            data.isActive = "N"
                        }
                    }
                }
                
                self.tblView1.reloadData()
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
extension DrinkWaterReminderVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension DrinkWaterReminderVC {
    
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

//MARK: -------------------- UITextField Delegate --------------------
extension DrinkWaterReminderVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtStartTime:
            
            if self.txtStartTime.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appTimeFormat
                self.dateFormatter.timeZone     = .current
                self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
                self.txtStartTime.text          = self.dateFormatter.string(from: self.startDatePicker.date)
                
                //self.endDatePicker.minimumDate          = Calendar.current.date(byAdding: .minute, value: 15, to: self.startDatePicker.date)
                
                let width = self.txtStartTime.getWidth(text: self.txtStartTime.text!)
                self.txtStartTimeWidth.constant = width
            }
            break
            
        case self.txtEndTime:
            
            if self.txtEndTime.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appTimeFormat
                self.dateFormatter.timeZone     = .current
                self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
                self.txtEndTime.text            = self.dateFormatter.string(from: self.endDatePicker.date)
            }
            break
            
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case self.txtStartTime:
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            let width = self.txtStartTime.getWidth(text: newText)
            self.txtStartTimeWidth.constant = width

            return true
            
        case self.txtEndTime:
            return true
            
        default:
            return true
        }
        
    }
     
}

//MARK: -------------------- setData Method --------------------
extension DrinkWaterReminderVC {
    
    func setData(){
        self.btnSwitch.isSelected   = true
        if self.isActive == "N" {
            self.btnSwitch.isSelected = false
        }
        
        let startTime = GFunction.shared.convertDateFormate(dt: self.object.basicDetails.notifyFrom,
                                                       inputFormat: DateTimeFormaterEnum.HHmmss.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.hhmma.rawValue,
                                                       status: .NOCONVERSION)
        self.txtStartTime.text = startTime.0
        let width = self.txtStartTime.getWidth(text: self.txtStartTime.text!)
        self.txtStartTimeWidth.constant = width
        
        let endTime = GFunction.shared.convertDateFormate(dt: self.object.basicDetails.notifyTo,
                                                       inputFormat: DateTimeFormaterEnum.HHmmss.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.hhmma.rawValue,
                                                       status: .NOCONVERSION)
        self.txtEndTime.text = endTime.0
        
        var isFound = false
        for item in self.object.details {
            item.isActive = "N"
            if self.object.basicDetails.remindType == "T" &&
                item.valueType == "times" {
                item.isActive = "Y"
                isFound = true
            }
            else if self.object.basicDetails.remindType == "H" &&
                        item.valueType == "hour" {
                item.isActive = "Y"
                isFound = true
            }
        }
        
        
        if !isFound {
            if self.isActive == "Y" &&
                self.object.everydayRemind.remindEveryday == "N"{
                self.object.details[0].isActive = "Y"
            }
        }
        
        self.updateStatus()
        self.tblView1.reloadData()
        self.tblView2.reloadData()
    }
}

