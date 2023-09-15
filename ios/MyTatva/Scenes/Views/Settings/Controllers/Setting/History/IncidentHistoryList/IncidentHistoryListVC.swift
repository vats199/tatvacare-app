//
//  NotificationListVC.swift
//  SM Company
//
//  Created by Hyperlink on 13/12/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit


class IncidentHistoryListCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var lblDuration      : UILabel!
    @IBOutlet weak var lblDurationValue : UILabel!
    
    @IBOutlet weak var lblImprove       : UILabel!
    @IBOutlet weak var lblImproveValue  : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .semibold, size: 17)
            .textColor(color: UIColor.themePurple)
        
        self.lblDuration
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblDurationValue
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.lblImprove
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblImproveValue
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
//            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
//
//            self.imgView.layoutIfNeeded()
//            self.imgView.cornerRadius(cornerRadius: 5)
        }
    }
}

class IncidentHistoryListVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var tblView              : UITableView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let refreshControl                      = UIRefreshControl()
    var strErrorMessage : String            = ""
    let viewModel                           = IncidentHistoryListVM()
    var timerSearch                         = Timer()
    
    var isGloabalSearch                     = false
    var strSearch                           = ""
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    var arrDaysOffline : [JSON] = []
    var arrLanguage : [JSON] = [
        [
            "img": "acc_profile",
            "name": "Profile",
            "type": enumAccountSetting.profile.rawValue,
            "isSelected": 0
        ],
        [
            "img": "acc_goals",
            "name": "Goals",
            "type": enumAccountSetting.goals.rawValue,
            "isSelected": 0
        ],
        [
            "img": "acc_plans",
            "name": "Plans",
            "type": enumAccountSetting.plans.rawValue,
            "isSelected": 0
        ],
        [
            "img": "acc_care_team",
            "name": "Care team",
            "type": enumAccountSetting.careTeam.rawValue,
            "isSelected": 0
        ],
        [
            "img": "acc_connected_device",
            "name": "Connected devices",
            "type": enumAccountSetting.conncetedDevice.rawValue,
            "isSelected": 0
        ],
        [
            "img": "acc_notification",
            "name": "Notification settings",
            "type": enumAccountSetting.notificationSettings.rawValue,
            "isSelected": 0
        ],
        [
            "img": "location_pin_gray",
            "name": "Update location",
            "type": enumAccountSetting.location.rawValue,
            "isSelected": 0
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
    
    @objc func updateAPIData(){
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                                tblView: self.tblView,
                                                withLoader: false)
            }
        }
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
        self.tblView.themeShadow()
        self.refreshControl.addTarget(self, action: #selector(updateAPIData), for: UIControl.Event.valueChanged)
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
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        
        WebengageManager.shared.navigateScreenEvent(screen: .HistoryIncident)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.updateAPIData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .HistoryIncident, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let _ = self.parent?.parent as? TabbarVC {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        FIRAnalytics.manageTimeSpent(on: .HistoryIncident, when: .Disappear)
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
extension IncidentHistoryListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : IncidentHistoryListCell = tableView.dequeueReusableCell(withClass: IncidentHistoryListCell.self, for: indexPath)

        let object = self.viewModel.getObject(index: indexPath.row)
        
//        let time = GFunction.shared.convertDateFormate(dt: object.durationUpdatedAt,
//                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
//                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
//                                                       status: .LOCAL)
        
        let time = GFunction.shared.convertDateFormate(dt: object.durationUpdatedAt,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        
        
        cell.lblTitle.text          = time.0
        cell.lblDuration.text       = object.durationQuestion
        cell.lblDurationValue.text  = object.durationAnswer + " " + AppMessages.Min
        cell.lblImprove.text        = object.occurQuestion.htmlToString
        cell.lblImproveValue.text   = object.occurAnswer.htmlToString
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.viewModel.getObject(index: indexPath.row)
        let vc = IncidentHistoryDetailVC.instantiate(fromAppStoryboard: .setting)
        vc.incident_tracking_master_id = object.incidentTrackingMasterId
        vc.patient_incident_add_rel_id = object.patientIncidentAddRelId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.managePagenation(tblView: self.tblView,
                                        refreshControl: self.refreshControl,
                                        index: indexPath.row)
        
    }
    
    
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension IncidentHistoryListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------- GlobalSearch Methods --------------------
extension IncidentHistoryListVC {
    
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
extension IncidentHistoryListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.tblView.reloadData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
