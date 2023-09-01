
import UIKit

class LoginWithOTPVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var lblLoginOTP          : UILabel!
    @IBOutlet weak var txtMobile            : UITextField!
    
    @IBOutlet weak var vwBottom             : UIView!
    
    @IBOutlet weak var btnNext              : UIButton!
    @IBOutlet weak var btnOr1               : UIButton!
    @IBOutlet weak var btnLoginWithPassword : UIButton!
    @IBOutlet weak var btnOr2               : UIButton!
    
    @IBOutlet weak var btnFb                : UIButton!
    @IBOutlet weak var btnGoogle            : UIButton!
    @IBOutlet weak var btnApple             : UIButton!
    
    @IBOutlet weak var lblDontHaveAccount   : UILabel!
    @IBOutlet weak var btnSignUp            : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel               = LoginWithOTPVM()
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        FIRAnalytics.FIRLogEvent(eventName: .LOGIN_ATTEMPT,
                                 screen: .LoginWithPhone,
                                 parameter: nil)
        WebengageManager.shared.navigateScreenEvent(screen: .LoginWithPhone)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //------------------------------------------------------
    
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
        
        self.txtMobile.regex            = Validations.RegexType.OnlyNumber.rawValue
        self.txtMobile.maxLength        = Validations.PhoneNumber.Maximum.rawValue
        self.txtMobile.keyboardType     = .numberPad
        
        
        if DeviceManager.Platform.isSimulator {
            self.txtMobile.text = "9099069344"
        }
        
        self.btnApple.isHidden = true
        if #available(iOS 13.0, *) {
            self.btnApple.isHidden = true
        }
    }
    
    private func applyStyle() {
        self.lblLoginOTP.font(name: .bold, size: 22).textColor(color: .themePurple)
        self.btnOr1.font(name: .bold, size: 16).textColor(color: .themeBlack)
        self.btnOr2.font(name: .bold, size: 16).textColor(color: .themeBlack)
        
        self.btnLoginWithPassword.font(name: .medium, size: 16).textColor(color: .themePurple)
        self.lblDontHaveAccount.font(name: .medium, size: 18).textColor(color: .themeBlack)
        self.btnSignUp.font(name: .medium, size: 18).textColor(color: .themePurple)
       
    }
    
    //MARK:- Action Method
    @IBAction func btnLoginTapped(_ sender: Any) {
        self.viewModel.apiLogin(vc: self,
                                countryCode: "+91",
                                txtMobile: self.txtMobile)
    }
    
    @IBAction func btnLoginWithPasswordTapped(_ sender: Any) {
        let vc = LoginWithPassVC.instantiate(fromAppStoryboard: .auth)
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = AddWeightHeightVC.instantiate(fromAppStoryboard: .auth)
//        self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = AddAccountDetailsVC.instantiate(fromAppStoryboard: .auth)
//        vc.strCountryCode              = "+91"
//        vc.strMobile                   = "2066069344"
//        //vc.selectedLanguageListModel   = self.selectedLanguageListModel
//        self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = AddPrecriptionVC.instantiate(fromAppStoryboard: .auth)
//        self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
//        self.navigationController?.pushViewController(vc, animated: true)
        
//        if BiometricsManager.shared.getBiometricType() != .none {
//            let vc = BiometricVC.instantiate(fromAppStoryboard: .auth)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        
//        let vc = SetLocationVC.instantiate(fromAppStoryboard: .auth)
//        self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = ProfileSetupSuccessVC.instanOtiate(fromAppStoryboard: .auth)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCreateAccountTapped(_ sender: Any) {
        let vc = SignupMobileVC.instantiate(fromAppStoryboard: .auth)
        self.navigationController?.pushViewController(vc, animated: true)
//        let vc = SelectLanguageVC.instantiate(fromAppStoryboard: .auth)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLoginWithFacebookTapped(_ sender: Any) {
//        self.socialLoginManager.performFacebookLogin()
//        if let personalDetailsVC = UIStoryboard.auth.instantiateViewController(withClass: PersonalDetailsVC.self) {
//            self.navigationController?.pushViewController(personalDetailsVC, animated: true)
//        }
    }
    
    @IBAction func btnLoginWithGoogleTapped(_ sender: Any) {
//        self.socialLoginManager.performGoogleLogin()
    }
    
    @IBAction func btnLoginWithAppleTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
//            self.socialLoginManager.performFirebaseAppleLogin()
        }
    }
    
    //------------------------------------------------------
}

//MARK: -------------------- setupViewModel Observer --------------------
extension LoginWithOTPVC {
    private func setupViewModelObserver() {
        // Result binding observer
        
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                //Alert.shared.showAlert(message: "Login success", completion: nil)
                
                FIRAnalytics.FIRLogEvent(eventName: .LOGIN_SMS_SENT,
                                         screen: .LoginWithPhone,
                                         parameter: nil)
                
                let vc = LoginOTP2VC.instantiate(fromAppStoryboard: .auth)
                vc.strCountryCode   = "+91"
                vc.strMobile        = self.txtMobile.text!
                vc.completionHandler = { obj in
                    if obj?.count > 0 {
                        
                        var params = [String: Any]()
                        params[AnalyticsParameters.phone_no.rawValue]   = self.txtMobile.text!
                        FIRAnalytics.FIRLogEvent(eventName: .LOGIN_OTP_SUCCESS,
                                                 screen: .LoginOtp,
                                                 parameter: params)
                        
                        UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.currentUser)
                        UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.authorization)
                        UIApplication.shared.manageLogin()
                        
                        /*kAppSessionTimeStart    = Date()
                        kUserSessionActive      = true
                        FIRAnalytics.FIRLogEvent(eventName: .USER_SESSION_START,
                                                 screen: .LoginOtp,
                                                 parameter: nil)*/
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
    } 
}

