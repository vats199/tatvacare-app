//
//  AutoVerificationOTPVC.swift
//  MyTatva
//
//  Created by Uttam patel on 05/06/23.
//




import Foundation
import UIKit
class AutoVerificationOTPVC: UIViewController {
    //MARK: - Outlets -
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var vwOTP                : VPMOTPView!
        
    @IBOutlet weak var lblResend            : UILabel!
    @IBOutlet weak var btnResend            : UIButton!
    @IBOutlet weak var lblTimer             : UILabel!
    
    //MARK: - Class Variables -
    
    var countdownTimer: Timer!
    var totalTime                       = kTotalOtpTime2
    var strOTPValue                     = ""
    var isOTPEntered                    = false
    var strCountryCode                  = "+91"
    var strMobile                       = ""
    
    var viewModel: AutoVerificationOTPVM!
    var isLogin_send_otp                = false
    
    var verifyUserModel                 = VerifyUserModel()
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    
    
    //MARK: - View Life Cycle -
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = AutoVerificationOTPVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    //------------------------------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.clearNavigation()
    }
    
    //------------------------------------------------------------------------------------------
    
    
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------------------------------------------
    
    //MARK: - Custom Functions -
    
    func setUpView() {
        self.applyStyle()
        self.startTimer()
        self.setOTPView()
        self.addActions()
 
    }
    
    //------------------------------------------------------------------------------------------
    
    func applyStyle() {
        
        self.lblTitle.font(name: .bold, size: 24.0).textColor(color: .themeBlack2).numberOfLines = 0
        self.lblTitle.textAlignment = .left
        self.lblTitle.text = "OTP Verification"
        self.lblSubTitle.font(name: .regular, size: 14.0).textColor(color: .themeGray5).numberOfLines = 0
        self.lblSubTitle.text = "Please enter the OTP, we have sent to your \nphone number \(self.strCountryCode)-\(self.strMobile)"
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack2 as Any,
        ]
        
        let defaultDicQue1 : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .bold, withSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack2 as Any,
        ]
        self.lblSubTitle.attributedText = self.lblSubTitle.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue1, attributedStrings: ["\(self.strCountryCode)-\(self.strMobile)"])
        
        self.lblSubTitle.textAlignment = .left
        self.lblTimer.font(name: .semibold, size: 13.0).textColor(color: .themeGray4).text = nil
        self.lblResend.font(name: .medium, size: 12.0).textColor(color: .themeGray5)
        self.btnResend.font(name: .semibold, size: 13.0).textColor(color: .themeGray4)
        
    }
    
    //------------------------------------------------------------------------------------------
    
    private func setupViewModelObserver() {

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
                        let vc = ChronicConditionsVC.instantiate(fromAppStoryboard: .AuthTemp)
                        vc.isBackShown = true
                        vc.isToRoot = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    case 2 :
                        let vc = SetupProfileVC.instantiate(fromAppStoryboard: .auth)
                        vc.isBackShown = true
                        vc.isToRoot = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    default:
                        let vc = QuestionsStartingVC.instantiate(fromAppStoryboard: .auth)
                        UserDefaultsConfig.kLetBigGIF = self.viewModel.verifyUserModel.imageUrl
                        vc.verifyUserModel = self.viewModel.verifyUserModel
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    return
                }
                var params = [String: Any]()
                params[AnalyticsParameters.phone_no.rawValue]   = self.strMobile
                FIRAnalytics.FIRLogEvent(eventName: .LOGIN_OTP_SUCCESS,
                                         screen: .LoginOtp,
                                         parameter: params)
                
//                UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.currentUser)
//                UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.authorization)
                UIApplication.shared.manageLogin()
                
                kAppSessionTimeStart    = Date()
                kUserSessionActive      = true
                FIRAnalytics.FIRLogEvent(eventName: .USER_SESSION_START,
                                         screen: .LoginOtp,
                                         parameter: nil)
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
            self.vwOTP.otpFieldCustomCorner              = 12
            self.vwOTP.otpFieldDefaultBackgroundColor    = UIColor.white
            self.vwOTP.otpFieldEnteredBackgroundColor    = UIColor.white
            self.vwOTP.otpFieldSeparatorSpace            = 10
            self.vwOTP.otpFieldDefaultBorderColor        = UIColor.ThemeBorder
            self.vwOTP.otpFieldEnteredBorderColor        = UIColor.themePurpleBlack
            self.vwOTP.otpFieldErrorBorderColor          = UIColor.ThemeBorder
            self.vwOTP.otpFieldBorderWidth               = 1
            self.vwOTP.otpFieldFont                      = UIFont.customFont(ofType: .bold, withSize: 14)
            self.vwOTP.cursorColor                       = UIColor.themeBlack
            self.vwOTP.otpFieldEntrySecureType           = false
            self.vwOTP.shouldAllowIntermediateEditing    = false
            self.vwOTP.otpFieldInputType                 = .numeric
            
            IQKeyboardManager.shared.enable = true
            IQKeyboardManager.shared.enableAutoToolbar = false
            
            // Create the UI
            self.vwOTP.initializeUI()
            
        }
    }
    
    
    private func addActions() {
        
        self.btnResend.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            
            self.view.endEditing(true)
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
                
    }
   
    
    @IBAction func btnBackTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
     //------------------------------------------------------------------------------------------
    
}

//MARK: -------------------- VPMOTPView Delegate Method --------------------
extension AutoVerificationOTPVC: VPMOTPViewDelegate {
    
    func shouldBecomeFirstResponderForOTP(optView: VPMOTPView, otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        self.strOTPValue = otpString
        
    }
    
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        self.isOTPEntered = hasEntered
        if hasEntered {
            self.viewModel.apiCall(vc: self,
                                   countryCode: self.strCountryCode,
                                   mobile: self.strMobile,
                                   otp: self.strOTPValue,
                                   isOTPEntered: self.isOTPEntered,
                                   otpType: self.isLogin_send_otp ? .login : .signup)
        }
        return hasEntered
    }
    
}

//MARK: -------------------- Timer Method --------------------
extension AutoVerificationOTPVC {
    
    func startTimer() {
        if self.countdownTimer == nil {
            self.lblTimer.isHidden                      = false
            self.btnResend.isUserInteractionEnabled     = false
            self.btnResend.alpha                        = 1
            self.btnResend.font(name: .semibold, size: 12.0).textColor(color: .themeGray4).setTitle("Resend code in", for: .normal)
            self.totalTime                              = kTotalOtpTime2
            self.lblTimer.text = self.timeFormatted(self.totalTime)
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
        self.btnResend.textColor(color: .themePurple).setTitle("Resend Code", for: .normal)
        
        if self.countdownTimer != nil {
            self.countdownTimer.invalidate()
            self.countdownTimer = nil
        }
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        guard totalSeconds != kTotalOtpTime2 else { return "30sec"}
        let seconds: Int = totalSeconds % 30
//        let minutes: Int = (totalSeconds / 30) % 30
//        return String(format: "%02d:%02d", minutes, seconds)
        return ("\(seconds)sec")
    }
    
}
