
 import UIKit

 class SyncDeviceVC: ClearNavigationFontBlackBaseVC {

     //----------------------------------------------------------------------------
     //MARK:- UIControl's Outlets
     @IBOutlet weak var lblTitle        : UILabel!
     @IBOutlet weak var lblDesc         : UILabel!
     
     @IBOutlet weak var btnSyncNow      : UIButton!
     @IBOutlet weak var btnSkip         : UIButton!
     
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
         
         self.lblTitle
             .font(name: .medium, size: 28)
             .textColor(color: UIColor.white)
         self.lblDesc
             .font(name: .regular, size: 16)
             .textColor(color: UIColor.white)
         
         self.btnSyncNow
             .font(name: .medium, size: 16)
            .textColor(color: UIColor.themePurple)
            .backGroundColor(color: UIColor.white)
            .cornerRadius(cornerRadius: 5)
         self.btnSkip
             .font(name: .regular, size: 14)
             .textColor(color: UIColor.white)
         
         self.configureUI()
         self.manageActionMethods()
     }
     
     @objc func updateAPIData(){
     }
     
     //Desc:- Set layout desing customize
     func configureUI(){
            
     }
     
     //----------------------------------------------------------------------------
     //MARK:- Action Methods
     func manageActionMethods(){
         
        self.btnSyncNow.addTapGestureRecognizer {
            AppLoader.shared.addLoader()
            HealthKitManager.shared.requestAccessWithCompletion { [weak self] (isDone, err) in
                guard let self = self else {return}
                
                DispatchQueue.main.async {
                    AppLoader.shared.removeLoader()
                    FIRAnalytics.FIRLogEvent(eventName: .APPLE_HEALTH_OPTIN_ATTEMPT,
                                             screen: .MyDeviceDetail,   
                                             parameter: nil)
                    self.dismiss(animated: true) {
                        
                        var obj = JSON()
                        obj["isDone"] = true
                        if let completionHandler = self.completionHandler {
                            completionHandler(obj)
                        }
                        
                        if isDone {
                            DispatchQueue.main.async {
                                GlobalAPI.shared.update_goal_and_reading_from_healthkitAPI { isDone in
                                    if isDone{
                                    }
                                }
                            }
                        }
                        else {
                            Alert.shared.showAlert(message: AppMessages.healthKitConnect, completion: nil)
                        }
                    }
                }
            }
        }
         
         self.btnSkip.addTapGestureRecognizer {
             self.dismiss(animated: true) {
                 var obj = JSON()
                 obj["isDone"] = true
                 if let completionHandler = self.completionHandler {
                     completionHandler(obj)
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
         self.setUpView()
         
        WebengageManager.shared.navigateScreenEvent(screen: .MyDeviceDetail)
        
         if let tabbar = self.parent?.parent as? TabbarVC {
             tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
         }
         self.navigationController?.setNavigationBarHidden(true, animated: true)
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
