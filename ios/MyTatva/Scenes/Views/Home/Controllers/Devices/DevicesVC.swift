//
//  DevicesVC.swift
//  MyTatva
//
//  Created by Himanshu on 02/10/23.
//

import UIKit

class DevicesVC: WhiteNavigationBaseVC {
    
    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var tblView          : UITableView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    let viewModel                   = DevicesViewModel()
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
    @IBAction func onGoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension DevicesVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MyDevicesCell2 = tableView.dequeueReusableCell(withClass: MyDevicesCell2.self, for: indexPath)
        let userModel = UserModel.shared
        cell.lblLastSync.text = userModel.bcaSync == nil ? AppMessages.deviceConnectionRequired : userModel.bcaSync.createdAt.isEmpty ? AppMessages.deviceConnectionRequired : "Last synced on " + GFunction.shared.convertDateFormat(dt: UserModel.shared.bcaSync.createdAt, inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue, outputFormat: DateTimeFormaterEnum.ddMMMYYYYhhmma.rawValue, status: .NOCONVERSION).str
        cell.lblDeviceName.text = userModel.devices != nil ? userModel.devices[indexPath.row].title : "Smart Analyser"
        cell.btnConnect.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.viewModel.showDeviceConnectPopUp()
        }
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension DevicesVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

