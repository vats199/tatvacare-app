
import UIKit

class ForgotPasswordOTPVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var lblForgotPassword    : UILabel!
    @IBOutlet weak var lblVerifyMobile      : UILabel!
    @IBOutlet weak var lblMobile            : UILabel!
    @IBOutlet weak var txtMobile            : ThemeTextFieldNoBorder!
    
    @IBOutlet weak var lblEnterOtp          : UILabel!
    @IBOutlet weak var vwOTP                : VPMOTPView!
    
    @IBOutlet weak var lblResend            : UILabel!
    @IBOutlet weak var btnResend            : UIButton!
    @IBOutlet weak var lblTimer             : UILabel!
    
    @IBOutlet weak var lblTerms             : UILabel!
    @IBOutlet weak var btnOpenTerms         : UIButton!
    @IBOutlet weak var btnSelectTerms       : UIButton!
    
    @IBOutlet weak var btnSubmit            : UIButton!
    
    @IBOutlet weak var lblAlreadyHaveAccount: UILabel!
    @IBOutlet weak var btnSignin            : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var countdownTimer: Timer!
    var totalTime                       = kTotalOtpTime
    var strOTPValue                     = ""
    var isOTPEntered                    = false
    var strCountryCode                  = "+91"
    var strMobile                       = ""
    
    private let viewModel               = OTPViewModel()
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        WebengageManager.shared.navigateScreenEvent(screen: .ForgotPasswordOtp)
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
        
        if DeviceManager.Platform.isSimulator {
            self.txtMobile.text = "9099069344"
        }
        self.txtMobile.regex            = Validations.RegexType.OnlyNumber.rawValue
        self.txtMobile.maxLength        = Validations.PhoneNumber.Maximum.rawValue
        self.txtMobile.keyboardType     = .numberPad
        self.txtMobile.isUserInteractionEnabled = false
        self.txtMobile.text             = self.strMobile
        
        self.lblTimer.isHidden                      = true
        self.btnOpenTerms.addTapGestureRecognizer {
        }
        
        self.btnSelectTerms.isSelected = true
        self.updateSubmit()
        self.btnSelectTerms.addTapGestureRecognizer {
            self.btnSelectTerms.isSelected = !self.btnSelectTerms.isSelected
            self.updateSubmit()
        }
        
        self.startTimer()
        self.setOTPView()
    }
    
    private func applyStyle() {
        self.lblForgotPassword.font(name: .bold, size: 22).textColor(color: .themePurple)
        self.lblVerifyMobile.font(name: .regular, size: 16).textColor(color: .themeBlack)
        
        self.lblMobile.font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.lblEnterOtp.font(name: .medium, size: 16).textColor(color: .themeBlack)
        
        self.lblResend.font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.btnResend.font(name: .medium, size: 16).textColor(color: .themePurple)
        self.lblTimer.font(name: .medium, size: 16).textColor(color: .themeBlack)
        
        self.lblTerms.font(name: .regular, size: 16).textColor(color: .themeBlack)
        self.btnOpenTerms.font(name: .regular, size: 16).textColor(color: .themePurple)
    
        self.lblAlreadyHaveAccount.font(name: .medium, size: 18).textColor(color: .themeBlack)
        self.btnSignin.font(name: .medium, size: 18).textColor(color: .themePurple)
       
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
    
    func setOTPView(){
        DispatchQueue.main.async {
            self.vwOTP.layoutIfNeeded()
            self.vwOTP.delegate                          = self
            self.vwOTP.otpFieldsCount                    = 4
            self.vwOTP.otpFieldSize                      = (self.vwOTP.frame.size.width / 4) - 15
            self.vwOTP.otpFieldDisplayType               = .custom
            self.vwOTP.otpFieldCustomCorner              = 5
            self.vwOTP.otpFieldDefaultBackgroundColor    = UIColor.white
            self.vwOTP.otpFieldEnteredBackgroundColor    = UIColor.white
            self.vwOTP.otpFieldSeparatorSpace            = 10
            self.vwOTP.otpFieldDefaultBorderColor        = UIColor.ThemeBorder
            self.vwOTP.otpFieldEnteredBorderColor        = UIColor.ThemeBorder
            self.vwOTP.otpFieldErrorBorderColor          = UIColor.ThemeBorder
            self.vwOTP.otpFieldBorderWidth               = 1
            self.vwOTP.otpFieldFont                      = UIFont.customFont(ofType: .medium, withSize: 16)
            self.vwOTP.cursorColor                       = UIColor.themeBlack
            self.vwOTP.otpFieldEntrySecureType           = false
            self.vwOTP.shouldAllowIntermediateEditing    = false
            self.vwOTP.otpFieldInputType                 = .numeric
            
            // Create the UI
            self.vwOTP.initializeUI()
        }
    }
    
    //MARK:- Action Method
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        self.viewModel.apiCall(vc: self,
                                          countryCode: self.strCountryCode,
                                          mobile: self.txtMobile,
                                          otp: self.strOTPValue,
                                          isOTPEntered: self.isOTPEntered,
                                          otpType: .forgotPassword)
    }
    
    @IBAction func btnResendTapped(_ sender: Any) {
        
        GlobalAPI.shared.sendOtpAPI(country_code: "+91",
                                    mobile: self.txtMobile.text!,
                                    type: .forgotPassword,
                                    screen: .ForgotPasswordOtp) { [weak self]  (isDone, userAlreadyRegistered) in
            guard let self = self else {return}
            if isDone {
                self.startTimer()
                self.setOTPView()
            }
        }
    }
    
    @IBAction func btnSignInTapped(_ sender: Any) {
        UIApplication.shared.setLogin()
    }
    
    //------------------------------------------------------
}

//MARK: -------------------- Timer Method --------------------
extension ForgotPasswordOTPVC {
    
    func startTimer() {
        if self.countdownTimer == nil {
            self.lblTimer.isHidden                      = false
            self.btnResend.isUserInteractionEnabled     = false
            self.btnResend.alpha                        = 0.5
            self.totalTime                              = kTotalOtpTime
            
            self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }

    @objc func updateTime() {
        self.lblTimer.text = "\(self.timeFormatted(self.totalTime))"

        if self.totalTime != 0 {
            self.totalTime -= 1
        } else {
            self.endTimer()
        }
    }

    func endTimer() {
        self.lblTimer.isHidden                      = true
        self.btnResend.isUserInteractionEnabled     = true
        self.btnResend.alpha                        = 1
        
        if self.countdownTimer != nil {
            self.countdownTimer.invalidate()
            self.countdownTimer = nil
        }
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

//MARK: -------------------- VPMOTPView Delegate Method ---------1-----------
extension ForgotPasswordOTPVC: VPMOTPViewDelegate {
    
    func shouldBecomeFirstResponderForOTP(optView: VPMOTPView, otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        self.strOTPValue = otpString
    }
    
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        self.isOTPEntered = hasEntered
        
        return hasEntered
    }
    
}

//MARK: -------------------- setupViewModel Observer --------------------
extension ForgotPasswordOTPVC {
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.otpResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                let vc = CreatePasswordVC.instantiate(fromAppStoryboard: .auth)
                vc.strMobile    = self.txtMobile.text!
                vc.strCode      = "+91"
                self.navigationController?.pushViewController(vc, animated: true)
            
            break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
    
}
