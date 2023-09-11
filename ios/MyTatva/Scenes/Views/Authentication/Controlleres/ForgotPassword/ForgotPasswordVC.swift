//
//  ForgotPasswordVC.swift
//
//  Created by 2020M03 on 16/06/21.
//

import UIKit

class ForgotPasswordVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblForgotPassword        : UILabel!
    @IBOutlet weak var lblForgotPasswordDesc    : UILabel!
    @IBOutlet weak var btnSubmit                : UIButton!
    
    @IBOutlet weak var txtMobile                : UITextField!
    
    @IBOutlet weak var lblDontHaveAccount       : UILabel!
    @IBOutlet weak var btnSignUp                : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel = ForgotPasswordViewModel()
    
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
        FIRAnalytics.FIRLogEvent(eventName: .FORGOT_PASSWORD_ATTEMPT,
                                 screen: .ForgotPasswordPhone,
                                 parameter: nil)
        WebengageManager.shared.navigateScreenEvent(screen: .ForgotPasswordPhone)
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
    }
    
    private func applyStyle() {
        self.lblForgotPassword.font(name: .bold, size: 22).textColor(color: .themePurple)
        self.lblForgotPasswordDesc.font(name: .regular, size: 16).textColor(color: .themeBlack)
        
        self.lblDontHaveAccount.font(name: .medium, size: 18).textColor(color: .themeBlack)
        self.btnSignUp.font(name: .medium, size: 18).textColor(color: .themePurple)
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    @IBAction func btnSubmitTapped(_ sender: Any) {
        viewModel.apiForgotPassword(vc: self,
                                    countryCode: "+91",
                                    mobile: self.txtMobile)
    }
    
    @IBAction func btnCreateAccountTapped(_ sender: Any) {
        let vc = SignupMobileVC.instantiate(fromAppStoryboard: .auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //------------------------------------------------------
}

//MARK: -------------------- setupViewModel Observer --------------------
extension ForgotPasswordVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        self.viewModel.forgotPasswordResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                //Alert.shared.showAlert(message: "Password changed", completion: nil)
                //self.navigationController?.popViewController(animated: true)
                GlobalAPI.shared.sendOtpAPI(country_code: "+91",
                                            mobile: self.txtMobile.text!,
                                            type: .forgotPassword,
                                            screen: .ForgotPasswordPhone) { [weak self]  (isDone, userAlreadyRegistered) in
                    guard let self = self else {return}
                    if isDone {
                        let vc = ForgotPasswordOTPVC.instantiate(fromAppStoryboard: .auth)
                        vc.strCountryCode   = "+91"
                        vc.strMobile        = self.txtMobile.text!
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

