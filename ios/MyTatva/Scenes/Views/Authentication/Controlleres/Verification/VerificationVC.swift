//
//  VerificationVC.swift
//  MyTatva
//
//  Created by Hlink on 25/04/23.
//

import UIKit

class VerificationVC: UIViewController {

    //MARK: Outlet
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var vwOTP                : VPMOTPView!
        
    @IBOutlet weak var lblResend            : UILabel!
    @IBOutlet weak var btnResend            : UIButton!
    @IBOutlet weak var lblTimer             : UILabel!
    
    @IBOutlet weak var btnValidateOTP: ThemePurpleButton!
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var countdownTimer: Timer!
    var totalTime                       = kTotalOtpTime
    var strOTPValue                     = ""
    var isOTPEntered                    = false
    var strCountryCode                  = "+91"
    var strMobile                       = ""
    
    var viewModel: VerificationVM!
    var isLogin_send_otp                = false
    
    var verifyUserModel                 = VerifyUserModel()
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.applyStyle()
        self.startTimer()
        self.setOTPView()
        self.addActions()
    }
    
    private func applyStyle() {
        self.lblTitle.font(name: .semibold, size: 17.0).textColor(color: .themeBlack).numberOfLines = 0
        self.lblTitle.textAlignment = .center
        self.lblTitle.text = "Verify your Phone Number".capitalized
        self.lblSubTitle.font(name: .regular, size: 14.0).textColor(color: .themeGray).numberOfLines = 0
        self.lblSubTitle.text = "Please enter the OTP, we have sent to your \nphone number \(self.strCountryCode) - \(self.strMobile)"
        self.lblSubTitle.textAlignment = .center
        self.lblTimer.font(name: .medium, size: 15.0).textColor(color: .themeBlack).text = nil
        self.lblResend.font(name: .medium, size: 15.0).textColor(color: .themeBlack)
        self.btnResend.font(name: .medium, size: 15.0).textColor(color: .themePurple)
        self.btnValidateOTP.fontSize(size: 17.0).setTitle("Validate OTP", for: UIControl.State())
    }
    
    private func setupViewModelObserver() {
//        self.viewModel.isResult.bind { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(_):
//                UserDefaultsConfig.accountFor = true
//                UIApplication.shared.manageLogin()
////                let vc = AccountCreationForVC.instantiate(fromAppStoryboard: .auth)
////                vc.leftBarItem = self.navigationItem.leftBarButtonItem ?? UIBarButtonItem()
////                self.navigationController?.pushViewController(vc, animated: true)
//                break
//            case .failure(let error):
//                Alert.shared.showSnackBar(error.localizedDescription)
//                break
//            case .none: break
//            }
//        }
        
        self.viewModel.isResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
//                UserDefaultsConfig.accountFor = true
                guard UserModel.isUserLoggedIn && UserModel.isVerifiedUser else {
                    
                    var params = [String: Any]()
                    params[AnalyticsParameters.phone_no.rawValue]   = self.strMobile
                    FIRAnalytics.FIRLogEvent(eventName: .NEW_USER_OTP_VERIFY,
                                             screen: .SignUpOtp,
                                             parameter: params)
                    
                    switch UserDefaultsConfig.kUserStep {
                    case 3 :
                        let vc = AddpatientDetailsVC.instantiate(fromAppStoryboard: .auth)
                        vc.isBackShown = true
                        vc.isToRoot = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    case 2 :
                        let vc = DoctorAccessCodeVC.instantiate(fromAppStoryboard: .auth)
                        vc.isBackShown = true
                        vc.isToRoot = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    default:
                        let vc = AccountCreationForVC.instantiate(fromAppStoryboard: .auth)
                        vc.isBackShown = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    return
                }
                var params = [String: Any]()
                params[AnalyticsParameters.phone_no.rawValue]   = self.strMobile
                FIRAnalytics.FIRLogEvent(eventName: .LOGIN_OTP_SUCCESS,
                                         screen: .LoginOtp,
                                         parameter: params)
                
                UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.currentUser)
                UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.authorization)
                UIApplication.shared.manageLogin()
                
                kAppSessionTimeStart    = Date()
                kUserSessionActive      = true
                /*FIRAnalytics.FIRLogEvent(eventName: .USER_SESSION_START,
                                         screen: .LoginOtp,
                                         parameter: nil)*/
            break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
    
    func setOTPView(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwOTP.layoutIfNeeded()
            self.vwOTP.delegate                          = self
            self.vwOTP.otpFieldsCount                    = kOTPCount
            self.vwOTP.otpFieldSize                      = (self.vwOTP.frame.size.width / CGFloat(kOTPCount)) - 10
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
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    private func addActions() {
        
        self.btnResend.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            
            GlobalAPI.shared.sendOtpAPI(country_code: self.strCountryCode,
                                        mobile: self.strMobile,
                                        type: self.isLogin_send_otp ? .login : .signup,
                                        screen: self.isLogin_send_otp ? .LoginOtp : .SignUpOtp) { [weak self]  (isDone, userAlreadyRegistered)  in
                guard let self = self else {return}
                if isDone {
                    
                    if self.isLogin_send_otp {
                        FIRAnalytics.FIRLogEvent(eventName: .LOGIN_SMS_SENT,
                                                 screen: .LoginOtp,
                                                 parameter: nil)
                    }
                    
                    self.startTimer()
                    self.setOTPView()
                }
            }
            
        }
        
        self.btnValidateOTP.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            //self.viewModel.apiVerifyOTP(otp: self.strOTPValue, optEntered: self.isOTPEntered)
            
            self.viewModel.apiCall(vc: self,
                                   countryCode: self.strCountryCode,
                                   mobile: self.strMobile,
                                   otp: self.strOTPValue,
                                   isOTPEntered: self.isOTPEntered,
                                   otpType: self.isLogin_send_otp ? .login : .signup)
            
        }
        
    }
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = VerificationVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.clearNavigation()
        WebengageManager.shared.navigateScreenEvent(screen: self.isLogin_send_otp ? .LoginOtp : .SignUpOtp)
    }

}

//MARK: -------------------- VPMOTPView Delegate Method --------------------
extension VerificationVC: VPMOTPViewDelegate {
    
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

//MARK: -------------------- Timer Method --------------------
extension VerificationVC {
    
    func startTimer() {
        if self.countdownTimer == nil {
            self.lblTimer.isHidden                      = false
            self.btnResend.isUserInteractionEnabled     = false
            self.btnResend.alpha                        = 0.5
            self.totalTime                              = kTotalOtpTime
            self.lblTimer.text = "\(self.timeFormatted(self.totalTime))"
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
