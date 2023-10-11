//
//  NotificationVC.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import UIKit

class NotificationContentCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var imgTitle     : UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblTime      : UILabel!
    @IBOutlet weak var lblDetail    : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblDetail.font(name: .regular, size: 14).textColor(color: UIColor.black.withAlphaComponent(0.7))
        
        self.lblTime
            .font(name: .regular, size: 10)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.cornerRadius(cornerRadius: 4)
            
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
        }
    }
}

class NotificationVC: ClearNavigationFontBlackBaseVC {

    //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var vwBadge      : UIView!
    @IBOutlet weak var lblBadge     : UILabel!
    @IBOutlet weak var tblView      : UITableView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = NotificationVM()
    let refreshControl              = UIRefreshControl()
    var isEdit                      = false
    
    var strErrorMessage : String    = ""
    
    //Language: English, Hindi, Kannada
    var arrData : [JSON] = [
        [
            "name" : "English",
            "isSelected": 1,
        ],[
            "name" : "Hindi",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
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
        
        DispatchQueue.main.async {
            self.vwBadge.layoutIfNeeded()
            self.lblBadge.layoutIfNeeded()
            self.vwBadge.setRound()
            self.vwBadge.backGroundColor(color: .themePurple)
            self.lblBadge.font(name: .medium, size: 14)
        }
        
        self.configureUI()
        self.manageActionMethods()
      
    }
    
    @objc func updateAPIData(withLoader: Bool){
        self.strErrorMessage = ""
        self.viewModel.apiCallFromStartNotification(tblView: self.tblView,
                                                    refreshControl: self.refreshControl,
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .NotificationList)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.updateAPIData(withLoader: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //@IBAction func onGoBack(_ sender: Any) {
      //     self.dismiss(animated: true, completion: nil)
      // }
}


//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension NotificationVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNotificationCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : NotificationContentCell = tableView.dequeueReusableCell(withClass: NotificationContentCell.self, for: indexPath)
    
        let object = self.viewModel.getNotificationObject(index: indexPath.row)
        
        cell.imgTitle.isHidden = true
        if object.imageUrl.trim() != "" {
            cell.imgTitle.isHidden = false
            cell.imgTitle.setCustomImage(with: object.imageUrl)
        }
        
        cell.lblTitle.text      = object.title
        cell.lblDetail.text     = object.mesage
        
        let time = GFunction.shared.convertDateFormate(dt: object.createdAt,
                                                       inputFormat: DateTimeFormaterEnum.yyyyMMddTHHmmsssZ.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        
        
        cell.lblTime.text = time.1.timeAgoSince()
        
        if object.isRead == 1 {
            DispatchQueue.main.async {
                cell.vwBg.layoutIfNeeded()
                cell.vwBg.borderColor(color: UIColor.themePurple, borderWidth: 0)
            }
        }
        else {
            DispatchQueue.main.async {
                cell.vwBg.layoutIfNeeded()
                cell.vwBg.borderColor(color: UIColor.themePurple, borderWidth: 0.5)
            }
        }
        
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.viewModel.getNotificationObject(index: indexPath.row)
        if let url = URL(string: object.deepLink) {
            let _ = DynamicLinks.dynamicLinks()
                .handleUniversalLink(url) { dynamiclink, error in
                    // ...
                    print("dynamiclink: \(dynamiclink)")
                    print("dynamiclink url: \(dynamiclink?.url)")
                    sceneDelegate.fetchDeepLinkData(link: dynamiclink?.url)
                }
        }
        else {
            if let data = object.data,
               let custom = data.custom,
               let msg = custom.message,
               let otherDetails = msg.otherDetails,
               let key = otherDetails.key,
               let flag = msg.flag {
                
                UIApplication.shared.setHome()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                    if let vc = UIApplication.topViewController() as? HomeVC{
                        
                        switch flag {
                        case "LogGoal":
                            vc.isOpenGoal = true
                            vc.isOpenGoalReadingKey = key
                            break
                            
                        case "LogReading":
                            vc.isOpenReading = true
                            vc.isOpenGoalReadingKey = key
                            break
                            
                        case "DoctorAppointment":
                            let navVC = AppointmentsHistoryVC.instantiate(fromAppStoryboard: .setting)
                            navVC.isForList = true
                            navVC.hidesBottomBarWhenPushed = true
                            vc.navigationController?.pushViewController(navVC, animated: true)
                            break
                            
                        case "UpdateGoalValue":
                            let navVC = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
                            navVC.isEdit = true
                            navVC.hidesBottomBarWhenPushed = true
                            vc.navigationController?.pushViewController(navVC, animated: true)
                            break
                        
                        case "HealthcoachTask":
                            break
                            
                        case "HealthcoachContent":
                            let message         = msg
                            let other_details   = otherDetails
                            let deepLink        = object.deepLink ?? ""
                            
                            if let url = URL(string: deepLink) {
                                let _ = DynamicLinks.dynamicLinks()
                                    .handleUniversalLink(url) { dynamiclink, error in
                                        // ...
                                        print("dynamiclink: \(dynamiclink)")
                                        print("dynamiclink url: \(dynamiclink?.url)")
                                        sceneDelegate.fetchDeepLinkData(link: dynamiclink?.url)
                                    }
                            }
                            
                            break
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
       self.viewModel.manageNotificationPagenation(tblView: tableView,
                                                   index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension NotificationVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension NotificationVC {
    
    fileprivate func setData(){
        
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension NotificationVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                
//                self.lblBadge.text = "23321"
//                self.vwBadge.isHidden = false
                self.lblBadge.text = "\(self.viewModel.unReadCount)"
                self.vwBadge.isHidden = true
                if self.viewModel.unReadCount > 0 {
                    self.vwBadge.isHidden = false
                }
                
                DispatchQueue.main.async {
                    self.vwBadge.layoutIfNeeded()
                    self.lblBadge.layoutIfNeeded()
                    self.vwBadge.setRound()
                }
                
                self.setData()
                self.tblView.reloadData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
