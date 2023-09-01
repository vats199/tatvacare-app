//
//  NotificationListVC.swift
//  SM Company
//
//  Created by Hyperlink on 13/12/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class MyDevicesTblCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var imgView      : UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnConnect   : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.9))
        
        self.btnConnect.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
        
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.btnConnect.layoutIfNeeded()
            
            self.btnConnect.cornerRadius(cornerRadius: 5)
            
//            self.vwBg.cornerRadius(cornerRadius: 7)
//            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
//
//            self.imgView.layoutIfNeeded()
//            self.imgView.cornerRadius(cornerRadius: 5)
        }
    }
}

class MyDevicesVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblFitness       : UILabel!
    @IBOutlet weak var tblView          : UITableView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    var arrDaysOffline : [JSON] = []
    var arrLanguage : [JSON] = [
        [
            "img": "healthKit",
            "name": "Apple Health Fit",
            "type": enumAccountSetting.profile.rawValue,
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
        
        self.lblFitness.font(name: .semibold, size: 17)
            .textColor(color: UIColor.themeBlack)
        
        self.configureUI()
        self.manageActionMethods()
    }
    
    @objc func updateAPIData(){
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
//        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
//        self.tblView.addSubview(self.refreshControl)
           
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        
        WebengageManager.shared.navigateScreenEvent(screen: .MyDevices)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tblView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .MyDevices, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAnalytics.manageTimeSpent(on: .MyDevices, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension MyDevicesVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrLanguage.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MyDevicesTblCell = tableView.dequeueReusableCell(withClass: MyDevicesTblCell.self, for: indexPath)

        let object = self.arrLanguage[indexPath.row]
        
        cell.imgView.image          = UIImage(named: object["img"].stringValue)
        cell.lblTitle.text          = object["name"].stringValue
        
        HealthKitManager.shared.checkHealthKitPermission { (isSync) in
            if isSync {
                cell.btnConnect.setTitle(AppMessages.connected, for: .normal)
            }
            else {
                cell.btnConnect.setTitle(AppMessages.connect, for: .normal)
            }
        }
        
        cell.btnConnect.addTapGestureRecognizer {
            if cell.btnConnect.currentTitle ?? "" != AppMessages.connected{
                let vc = SyncDeviceVC.instantiate(fromAppStoryboard: .setting)
                self.present(vc, animated: true, completion: nil)
                //self.navigationController?.pushViewController(vc, animated: true)
            }else{
                Alert.shared.showAlert(message: AppMessages.healthKitDisconnect, completion: nil)
            }
        }
        
//        cell.btnSelect.isSelected = false
//        if object["isSelected"].intValue == 1 {
//            cell.btnSelect.isSelected = true
//        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension MyDevicesVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

