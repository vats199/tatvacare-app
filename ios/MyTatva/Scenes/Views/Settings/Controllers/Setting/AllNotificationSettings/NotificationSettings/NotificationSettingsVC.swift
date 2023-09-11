
import UIKit

class NotificationSettingsCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var imgView      : UIImageView!
    @IBOutlet weak var imgMore      : UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnSelect    : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
            self.imgView.layoutIfNeeded()
            self.imgView.cornerRadius(cornerRadius: 5)
        }
    }
}

class NotificationSettingsVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var tblView      : UITableView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = NotificationSettingsVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    
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
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        self.configureUI()
        self.manageActionMethods()
        
    }
    
    @objc func updateAPIData(withLoader: Bool){
        self.strErrorMessage = ""
        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                        tblView: self.tblView,
                                        withLoader: withLoader)
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
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
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
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
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.updateAPIData(withLoader: true)
        WebengageManager.shared.navigateScreenEvent(screen: .NotificationSettings)
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
extension NotificationSettingsVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : NotificationSettingsCell = tableView.dequeueReusableCell(withClass: NotificationSettingsCell.self, for: indexPath)

        let object = self.viewModel.getObject(index: indexPath.row)
        
        cell.imgView.isHidden       = true
        cell.btnSelect.isHidden     = false
        cell.lblTitle.text          = object.title
        
        cell.btnSelect.isSelected   = true
        if object.isActive == "N" {
            cell.btnSelect.isSelected = false
        }
        
        cell.imgMore.isHidden       = true
        if object.detailPage == "Y" {
            cell.imgMore.isHidden = false
        }
        
        cell.btnSelect.addTapGestureRecognizer {
            self.viewModel.update_notification_reminderAPI(notification_master_id: object.notificationMasterId,
                                                           is_active: !cell.btnSelect.isSelected) { [weak self]  isDone in
                guard let self = self else {return}
                if isDone {
                    object.isActive = object.isActive == "Y" ? "N" : "Y"
                    self.tblView.reloadData()
                }
            }
        }
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.viewModel.getObject(index: indexPath.row)
        
        if object.detailPage == "Y" {
            self.viewModel.notification_detailsAPI(notification_master_id: object.notificationMasterId) { [weak self] isDone, obj in
                guard let self = self else {return}
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.0) {
                    if let type = GoalType.init(rawValue: object.keys) {
                        switch type {
                        case .Medication:
                            break
                        case .Calories:
                            break
                        case .Steps:
                            break
                        case .Exercise:
                            let vc = CommonGoalReminderVC.instantiate(fromAppStoryboard: .setting)
                            vc.type = type
                            vc.notification_master_id = object.notificationMasterId
                            vc.object = NotificationGoalReminderModel(fromJson: obj)
                            vc.isActive = object.isActive
                            self.navigationController?.pushViewController(vc, animated: true)
                            break
                        case .Pranayam:
                            let vc = CommonGoalReminderVC.instantiate(fromAppStoryboard: .setting)
                            vc.notification_master_id = object.notificationMasterId
                            vc.type = type
                            vc.object = NotificationGoalReminderModel(fromJson: obj)
                            vc.isActive = object.isActive
                            self.navigationController?.pushViewController(vc, animated: true)
                            break
                        case .Sleep:
                            let vc = CommonGoalReminderVC.instantiate(fromAppStoryboard: .setting)
                            vc.notification_master_id = object.notificationMasterId
                            vc.type = type
                            vc.object = NotificationGoalReminderModel(fromJson: obj)
                            vc.isActive = object.isActive
                            self.navigationController?.pushViewController(vc, animated: true)
                            break
                        case .Water:
                            let vc = DrinkWaterReminderVC.instantiate(fromAppStoryboard: .setting)
                            vc.notification_master_id = object.notificationMasterId
                            vc.type = type
                            vc.object = NotificationWaterReminderModel(fromJson: obj)
                            vc.isActive = object.isActive
                            self.navigationController?.pushViewController(vc, animated: true)
                            break
                        case .Diet:
                            let vc = TrackMealReminderVC.instantiate(fromAppStoryboard: .setting)
                            vc.notification_master_id = object.notificationMasterId
                            vc.object = NotificationMealReminderModel(fromJson: obj)
                            vc.isActive = object.isActive
                            self.navigationController?.pushViewController(vc, animated: true)
                            break
                        }
                    }
                    else {
                        let vc = CommonReadingReminderVC.instantiate(fromAppStoryboard: .setting)
                        vc.notification_master_id = object.notificationMasterId
                        vc.object = NotificationReadingReminderModel(fromJson: obj)
                        vc.isActive = object.isActive
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension NotificationSettingsVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension NotificationSettingsVC {
    
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
