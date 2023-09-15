
import UIKit


class ProfileSetupSuccessVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var imgBg            : UIImageView!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        WebengageManager.shared.navigateScreenEvent(screen: .ProfileCompleteSuccess)
        FIRAnalytics.FIRLogEvent(eventName: .USER_PROFILE_COMPLETED,
                                 screen: .MyProfile,
                                 parameter: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //-----------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        self.applyStyle()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.currentUser)
            UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.authorization)
            UIApplication.shared.manageLogin()
        }
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.vwBg.themeShadow()
        }
        
        
    }
    
    private func applyStyle() {
        self.lblTitle
            .font(name: .bold, size: 30).textColor(color: .themeBlack)
        self.lblDesc
            .font(name: .medium, size: 16).textColor(color: .themeBlack)
    }
    
    //MARK:- Action Method
   
}
