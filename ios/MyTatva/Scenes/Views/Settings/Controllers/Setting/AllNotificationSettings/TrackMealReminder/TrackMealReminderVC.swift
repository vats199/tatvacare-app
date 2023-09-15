
import UIKit

class TrackMealReminderCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnSelect    : UIButton!
    @IBOutlet weak var txtTime      : UITextField!
    @IBOutlet weak var imgEdit      : UIImageView!
    
    var datePicker                  = UIDatePicker()
    var dateFormatter               = DateFormatter()
    var obj                         = MealDetailModel()
    var objEverydayRemind           = EverydayRemind()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.txtTime
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
        
//        self.lblTitle.font(name: .medium, size: 16)
//            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        
        self.initDatePicker()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0, shdowRadious: 4)
        }
    }
}

//MARK: -------------------- Date picker methods --------------------
extension TrackMealReminderCell {
    
    func initDatePicker(){
       
        self.txtTime.inputView                  = self.datePicker
        self.txtTime.delegate                   = self
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
            self.txtTime.text               = self.dateFormatter.string(from: sender.date)
            
            self.dateFormatter.dateFormat   = DateTimeFormaterEnum.HHmmss.rawValue
            self.dateFormatter.timeZone     = .current
            
            if self.obj.mealTime != nil {
                self.obj.mealTime               = self.dateFormatter.string(from: sender.date)
            }
            else {
                self.objEverydayRemind.remindEverydayTime = self.dateFormatter.string(from: sender.date)
            }
            break
        default:break
        }
    }
    
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension TrackMealReminderCell : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtTime:
            
            if self.txtTime.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appTimeFormat
                self.dateFormatter.timeZone     = .current
                self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
                self.txtTime.text               = self.dateFormatter.string(from: self.datePicker.date)
                
                self.dateFormatter.dateFormat   = DateTimeFormaterEnum.HHmmss.rawValue
                self.dateFormatter.timeZone     = .current
                
                
                if self.obj.mealTime != nil {
                    self.obj.mealTime           = self.dateFormatter.string(from: self.datePicker.date)
                }
                else {
                    self.objEverydayRemind.remindEverydayTime = self.dateFormatter.string(from: self.datePicker.date)
                }
            }
            break
    
        default:
            break
        }
        return true
    }
}

class TrackMealReminderVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    
    @IBOutlet weak var tblView1         : UITableView!
    @IBOutlet weak var tblView1Height   : NSLayoutConstraint!
    
    @IBOutlet weak var tblView2         : UITableView!
    @IBOutlet weak var tblView2Height   : NSLayoutConstraint!
    @IBOutlet weak var btnSwitch        : UIButton!
    @IBOutlet weak var btnSubmit        : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    var object                      = NotificationMealReminderModel()
    let viewModel                   = TrackMealReminderVM()
    let notificationSettingsVM      = NotificationSettingsVM()
    var notification_master_id      = ""
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
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
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        
        self.lblTitle.font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .medium, size: 14)
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
                   "meal_types_id": "string",
                   "meal_time": "string",
                   "is_active": "Y"
                 }
             */
            var arrTemp = [[String: Any]]()
            for data in self.object.details {
                var temp = [String: Any]()
                temp["meal_types_id"]   = data.mealTypesId
                temp["meal_time"]       = data.mealTime
                temp["is_active"]       = data.isActive
                arrTemp.append(temp)
            }
            
            self.notificationSettingsVM.update_meal_reminderAPI(notification_master_id: self.notification_master_id,
                                                                meal_data: arrTemp,
                                                                remind_everyday: self.object.everydayRemind.remindEveryday,
                                                                remind_everyday_time: self.object.everydayRemind.remindEverydayTime) { [weak self] isDone in
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
extension TrackMealReminderVC : UITableViewDataSource, UITableViewDelegate{
    
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
        
        let cell : TrackMealReminderCell = tableView.dequeueReusableCell(withClass: TrackMealReminderCell.self, for: indexPath)
        
        switch tableView {
        case self.tblView1:
            let obj = self.object.details[indexPath.row]
            cell.btnSelect.isHidden     = false
            cell.lblTitle.text          = obj.mealType
            cell.obj                    = obj
            
            let time = GFunction.shared.convertDateFormate(dt: obj.mealTime,
                                                           inputFormat: DateTimeFormaterEnum.HHmmss.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.hhmma.rawValue,
                                                           status: .NOCONVERSION)
            cell.txtTime.text = time.0
            
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
                
                self.object.everydayRemind.remindEveryday = "N"
                self.tblView2.reloadData()
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
            
            if self.isActive == "N" {
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
            else {
            }
            
            cell.btnSelect.addTapGestureRecognizer {
                if self.isActive == "Y" {
                    obj.isActive = obj.isActive == "Y" ? "N" : "Y"
                    self.tblView1.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            break
        case self.tblView2:
            
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
                
                if self.object.everydayRemind.remindEveryday == "Y" {
                    for data in self.object.details {
                        data.isActive = "N"
                    }
                }
                
                self.tblView2.reloadRows(at: [indexPath], with: .automatic)
                self.tblView1.reloadData()
            }
            break
            
        default: break
        }
        
        
//        cell.btnSelect.isSelected = false
//        if object["isSelected"].intValue == 1 {
//            cell.btnSelect.isSelected = true
//        }
        
        return cell
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
extension TrackMealReminderVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension TrackMealReminderVC {
    
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


//MARK: -------------------- Set data --------------------
extension TrackMealReminderVC {
    
    func setData(){
        self.btnSwitch.isSelected   = true
        if self.isActive == "N" {
            self.btnSwitch.isSelected = false
        }
        
        self.updateStatus()
        self.tblView1.reloadData()
        self.tblView2.reloadData()
    }
}
