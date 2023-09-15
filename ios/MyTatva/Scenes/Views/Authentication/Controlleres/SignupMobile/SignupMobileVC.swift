//

import UIKit

class SignupMobileVC: ClearNavigationFontBlackBaseVC {
    
    //MARK: -------------------- Outlet --------------------
    
    @IBOutlet weak var lblSignup                : UILabel!
    @IBOutlet weak var btnSubmit                : UIButton!
    
    @IBOutlet var txtMobile                     : UITextField!
    
    @IBOutlet weak var lblAlreadyHaveAccount    : UILabel!
    @IBOutlet weak var btnSignin                : UIButton!
    
    //MARK: -------------------- Class Variable --------------------
    private let viewModel                   = SignupMobileVM()
    private let loginWithOTPVM              = LoginWithOTPVM()
    var selectedLanguageListModel           = LanguageListModel()
    
    //MARK: -------------------- Life Cycle Method --------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupViewModelObserver()
        FIRAnalytics.FIRLogEvent(eventName: .NEW_USER_SIGNUP_ATTEMPT,
                                 screen: .SignUpWithPhone,
                                 parameter: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        WebengageManager.shared.navigateScreenEvent(screen: .SignUpWithPhone)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    //MARK: -------------------- Custom Method --------------------
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        self.applyStyle()
        
        self.txtMobile.regex            = Validations.RegexType.OnlyNumber.rawValue
        self.txtMobile.maxLength        = Validations.PhoneNumber.Maximum.rawValue
        self.txtMobile.keyboardType     = .numberPad
    }
    
    private func applyStyle() {
        self.lblSignup.font(name: .bold, size: 22).textColor(color: .themePurple)
        
        self.lblAlreadyHaveAccount.font(name: .medium, size: 18).textColor(color: .themeBlack)
        self.btnSignin.font(name: .medium, size: 18).textColor(color: .themePurple)
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    @IBAction func btnSubmitTapped(_ sender: Any) {
        self.viewModel.apiSignup(vc: self,
                                 countryCode: "+91",
                                 mobile: self.txtMobile)
    }
    
    @IBAction func btnSignInTapped(_ sender: Any) {
        UIApplication.shared.setLogin()
    }
    
    //------------------------------------------------------
}


//MARK: -------------------- setupViewModel Observer --------------------
extension SignupMobileVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                //Alert.shared.showAlert(message: "Password changed", completion: nil)
                
                DispatchQueue.main.async {
                    if self.viewModel.userAlreadyRegistered {
                        //User is already registered
                        self.loginWithOTPVM.apiLogin(vc: self,
                                                countryCode: "+91",
                                                txtMobile: self.txtMobile)
                    }
                    else {
                        //Continue with signup flow
                        let vc = SignupOTPVC.instantiate(fromAppStoryboard: .auth)
                        vc.strCountryCode   = "+91"
                        vc.strMobile        = self.txtMobile.text!
                        vc.completionHandler = { obj in
                            if obj?.count > 0 {
                                
                                var params = [String: Any]()
                                params[AnalyticsParameters.phone_no.rawValue]   = self.txtMobile.text!
                                FIRAnalytics.FIRLogEvent(eventName: .NEW_USER_OTP_VERIFY,
                                                         screen: .SignUpOtp,
                                                         parameter: params)
                                //FIRAnalytics.FIRLogEvent(eventName: .NEW_USER_MOBILE_CAPTURE, parameter: nil)
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                                    let acc = AddAccountDetailsVC.instantiate(fromAppStoryboard: .auth)
                                    acc.strCountryCode              = "+91"
                                    acc.strMobile                   = self.txtMobile.text!
                                    acc.selectedLanguageListModel   = self.selectedLanguageListModel
                                    acc.verifyUserModel             = vc.verifyUserModel
                                    
                                    self.navigationController?.pushViewController(acc, animated: false)
                                }
                            }
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                break
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                break
            case .none: break
            }
        })
        
        self.loginWithOTPVM.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Login otp sent successfully
                
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

