
import UIKit

class LoginWithPassVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var lblLoginWithPass     : UILabel!
    @IBOutlet weak var txtMobile            : UITextField!
    @IBOutlet weak var txtPassword          : UITextField!
    @IBOutlet weak var vwPassword           : UIView!
    @IBOutlet weak var btnShowPassword      : UIButton!
    
    @IBOutlet weak var lblTerms             : UILabel!
    @IBOutlet weak var btnOpenTerms         : UIButton!
    @IBOutlet weak var btnSelectTerms       : UIButton!
    
    @IBOutlet weak var btnSubmit            : UIButton!
    @IBOutlet weak var btnRemember          : UIButton!
    @IBOutlet weak var lblRemember          : UILabel!
    @IBOutlet weak var btnForgetPassword    : UIButton!
    
    @IBOutlet weak var btnOr1               : UIButton!
    
    @IBOutlet weak var btnFb                : UIButton!
    @IBOutlet weak var btnGoogle            : UIButton!
    @IBOutlet weak var btnApple             : UIButton!
    
    @IBOutlet weak var lblDontHavePassword  : UILabel!
    @IBOutlet weak var btnLoginWithOtp      : UIButton!
    
    @IBOutlet weak var lblDontHaveAccount   : UILabel!
    @IBOutlet weak var btnSignUp            : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel               = LoginWithPassVM()
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupViewModelObserver()
        
        FIRAnalytics.FIRLogEvent(eventName: .LOGIN_PASSWORD_ATEMPT, parameter: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        FIRAnalytics.FIRLogEvent(eventName: .LOGIN_PASSWORD_ATTEMPT,
                                 screen: .LoginWithPassword,
                                 parameter: nil)
        WebengageManager.shared.navigateScreenEvent(screen: .LoginWithPassword)
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
        
        self.txtMobile.regex            = Validations.RegexType.OnlyNumber.rawValue
        self.txtMobile.maxLength        = Validations.PhoneNumber.Maximum.rawValue
        self.txtMobile.keyboardType     = .numberPad
        
        //self.txtPassword.regex          = Validations.RegexType.Password.rawValue
        self.txtPassword.maxLength      = Validations.Password.Maximum.rawValue
        self.txtPassword.keyboardType   = .default
        
        if DeviceManager.Platform.isSimulator {
            self.txtMobile.text = "9099069344"
            self.txtPassword.text = "Abcd@123"
        }
        
        if UserDefaultsConfig.rememberMe {
            self.txtMobile.text = UserDefaultsConfig.mobile
            self.txtPassword.text = UserDefaultsConfig.password
        }
        
        self.btnApple.isHidden = true
        if #available(iOS 13.0, *) {
            self.btnApple.isHidden = true
        }
        
        self.btnShowPassword.isSelected = true
        self.hideShowPassword(sender: self.btnShowPassword)
        self.btnShowPassword.addTapGestureRecognizer {
            self.hideShowPassword(sender: self.btnShowPassword)
        }
        
        self.btnOpenTerms.addTapGestureRecognizer {
        }
        
        self.btnSelectTerms.isSelected = true
        self.updateSubmit()
        self.btnSelectTerms.addTapGestureRecognizer {
            self.btnSelectTerms.isSelected = !self.btnSelectTerms.isSelected
            self.updateSubmit()
        }
        
        self.btnRemember.addTapGestureRecognizer {
            self.btnRemember.isSelected = !self.btnRemember.isSelected
        }
        
        self.btnForgetPassword.addTapGestureRecognizer {
            let vc = ForgotPasswordVC.instantiate(fromAppStoryboard: .auth)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func applyStyle() {
        self.lblLoginWithPass.font(name: .bold, size: 22).textColor(color: .themePurple)
        
        self.lblTerms.font(name: .regular, size: 16).textColor(color: .themeBlack)
        self.btnOpenTerms.font(name: .regular, size: 16).textColor(color: .themePurple)
        
        self.lblRemember.font(name: .regular, size: 16).textColor(color: .themeBlack)
        self.btnForgetPassword.font(name: .regular, size: 16).textColor(color: .themePurple)
        
        self.btnOr1.font(name: .bold, size: 16).textColor(color: .themeBlack)
        
        self.lblDontHavePassword.font(name: .medium, size: 18).textColor(color: .themeBlack)
        self.btnLoginWithOtp.font(name: .medium, size: 18).textColor(color: .themePurple)
        
        self.lblDontHaveAccount.font(name: .medium, size: 18).textColor(color: .themeBlack)
        self.btnSignUp.font(name: .medium, size: 18).textColor(color: .themePurple)
       
    }
    
    func updateSubmit(){
        if self.btnSelectTerms.isSelected {
            self.btnSubmit.isUserInteractionEnabled = true
            self.btnSubmit.alpha = 1
        }
        else {
            self.btnSubmit.isUserInteractionEnabled = false
            self.btnSubmit.alpha = 0.5
        }
    }
    
    func hideShowPassword(sender: UIButton){
        if sender.isSelected {
            sender.isSelected                   = false
            self.txtPassword.isSecureTextEntry  = true
            sender.alpha                        = 1
        }
        else {
            sender.isSelected                   = true
            self.txtPassword.isSecureTextEntry  = false
            sender.alpha                        = 0.6
        }
    }
    
    //MARK:- Action Method
    
    @IBAction func btnLoginTapped(_ sender: Any) {
       
        self.viewModel.apiLogin(vc: self,
                                countryCode: "+91",
                                mobile: self.txtMobile,
                                password: self.txtPassword,
                                vwPassword: self.vwPassword,
                                isAgreeTerms: true,
                                isRemember: self.btnRemember.isSelected)
    }
    
    @IBAction func btnLoginWithOtpTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
extension LoginWithPassVC {
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                //Alert.shared.showAlert(message: "Login success", completion: nil)
                
//                UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.currentUser)
//                UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.authorization)
//
                //UIApplication.shared.manageLogin()
//                let vc = PersonalDetailsVC.instantiate(fromAppStoryboard: .auth)
//                self.navigationController?.pushViewController(vc, animated: true)
            break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
    }    
}
