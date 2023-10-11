//
//  NotificationListVC.swift
//  SM Company
//
//  Created by Hyperlink on 13/12/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

enum enumAccountSetting: String {
    case profile                = "Profile"
    case goals
    case location
    case heightWeight
    case plans
    case careTeam
    case conncetedDevice        = "Connected devices"
    case notificationSettings   = "Notification settings"
    case deleteAccount          = "Delete Account"
    case logout                 = "Logout"
}

class AccountSettingTblCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var imgView      : UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .regular, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.4))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
//            self.vwBg.cornerRadius(cornerRadius: 7)
//            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
//
//            self.imgView.layoutIfNeeded()
//            self.imgView.cornerRadius(cornerRadius: 5)
        }
    }
}

class AccountSettingVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var tblView      : UITableView!
    @IBOutlet weak var lblVersion   : UILabel!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    var arrDaysOffline : [JSON] = []
    var arrLanguage : [JSON] = [
//        [
//            "img": "acc_profile",
//            "name": "Profile",
//            "type": enumAccountSetting.profile.rawValue,
//            "isSelected": 0
//        ],
//        [
//            "img": "acc_goals",
//            "name": "Goals and Health Trends",//"Goals and Vitals",
//            "type": enumAccountSetting.goals.rawValue,
//            "isSelected": 0
//        ],
//        [
//            "img": "acc_plans",
//            "name": "Plans",
//            "type": enumAccountSetting.plans.rawValue,
//            "isSelected": 0
//        ],
//        [
//            "img": "acc_care_team",
//            "name": "Care team",
//            "type": enumAccountSetting.careTeam.rawValue,
//            "isSelected": 0
//        ],
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
//        [
//            "img": "location_pin_gray",
//            "name": "Update location",
//            "type": enumAccountSetting.location.rawValue,
//            "isSelected": 0
//        ],
//        [
//            "img": "height_weight",
//            "name": "Update height & weight",
//            "type": enumAccountSetting.heightWeight.rawValue,
//            "isSelected": 0
//        ],
        [
            "img": "acc_delete",
            "name": "Delete Account",
            "type": enumAccountSetting.deleteAccount.rawValue,
            "isSelected": 0
        ],
        [
            "img": "acc_logout",
            "name": "Logout",
            "type": enumAccountSetting.logout.rawValue,
            "isSelected": 0
        ],
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
    private func setUpView(){
        self.configureUI()
        self.manageActionMethods()
        //self.setupHero()
        
        self.lblVersion
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblVersion.text = "V " + "\(Bundle.main.releaseVersionNumber ?? "")" + "(\(Bundle.main.buildVersionNumber ?? ""))"
    }
    
    private func setupHero(){
        self.tblView.hero.isEnabled     = true
        self.tblView.hero.modifiers     = [.fade]
    }
    
    @objc func updateAPIData(){
    }
    
    //Desc:- Set layout desing customize
    private func configureUI(){
    
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
//        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
//        self.tblView.addSubview(self.refreshControl)
           
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    private func manageActionMethods(){
        
    }
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        
        WebengageManager.shared.navigateScreenEvent(screen: .MyAccount)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .MyAccount, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAnalytics.manageTimeSpent(on: .MyAccount, when: .Disappear)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
//    @IBAction func onGoBack(_ sender: Any) {
//           self.dismiss(animated: true, completion: nil)
//       }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension AccountSettingVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrLanguage.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : AccountSettingTblCell = tableView.dequeueReusableCell(withClass: AccountSettingTblCell.self, for: indexPath)

        let object = self.arrLanguage[indexPath.row]
        
        cell.imgView.image          = UIImage(named: object["img"].stringValue)
        cell.lblTitle.text          = object["name"].stringValue
        
//        cell.btnSelect.isSelected = false
//        if object["isSelected"].intValue == 1 {
//            cell.btnSelect.isSelected = true
//        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.arrLanguage[indexPath.row]
        
        if let type = enumAccountSetting.init(rawValue: object["type"].stringValue) {
            
            var params                                  = [String : Any]()
            params[AnalyticsParameters.menu.rawValue]   = type.rawValue
            FIRAnalytics.FIRLogEvent(eventName: .ACCOUNT_SETTING_NAVIGATION,
                                     screen: .MyAccount,
                                     parameter: params)
            
            switch type {
            case .profile:
                let vc = ProfileVC.instantiate(fromAppStoryboard: .setting)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .goals:
                let vc = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
                vc.isEdit = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .plans:
                break
            case .careTeam:
                break
            case .conncetedDevice:
                let vc = MyDevicesVC.instantiate(fromAppStoryboard: .setting)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .notificationSettings:
                let vc = NotificationSettingsVC.instantiate(fromAppStoryboard: .setting)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .location:
                let vc = SetLocationVC.instantiate(fromAppStoryboard: .auth)
                vc.isEdit = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .heightWeight:
                let vc = AddWeightHeightVC.instantiate(fromAppStoryboard: .auth)
                vc.isEdit = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .deleteAccount:
                let vc = ConfirmAccountDeleteVC.instantiate(fromAppStoryboard: .setting)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .logout:
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.logoutMessage) { [weak self] (isDone) in
//                            guard let _ = self else {return}
                            if isDone {
                                //UIApplication.shared.forceLogOut()
                                GlobalAPI.shared.logoutAPI { (isDone) in
                                    if isDone {
                                        
                                        if kUserSessionActive {
                                            kUserSessionActive      = false
                                            FIRAnalytics.FIRLogEvent(eventName: .USER_SESSION_END,
                                                                     screen: .Menu  ,
                                                                     parameter: nil)
                                        }
                                        
                                        UIApplication.shared.forceLogOut()
                                    }
                                }
                            }
                        }
                    }
                }
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension AccountSettingVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

                                         
