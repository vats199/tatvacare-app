//
//  LoginSignupVC.swift
//  MyTatva
//
//  Created by Hlink on 24/04/23.
//

import UIKit

class LoginSignupVC: UIViewController {

    //MARK: Outlet
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var vwMobileNumber: UIView!
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtMobileNumber: UITextField!
    
    @IBOutlet weak var btnContinue: ThemePurpleButton!
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel: LoginSignupVM!
    var mobileNumber = "" {
        didSet {
            let isValid = self.mobileNumber.count >= 10
            self.btnContinue.backGroundColor(color: isValid ? .themePurple : .themePurple.withAlphaComponent(0.5)).isUserInteractionEnabled = isValid
        }
    }
    
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
        self.addActions()
//        self.addHeaderView()
    }
    
    private func applyStyle() {
        self.mobileNumber = ""
        self.lblCountryCode.font(name: .medium, size: 13.0).textColor(color: .themeBlack).text = "+91"
        self.lblTitle.font(name: .semibold, size: 17.0).textColor(color: .themeBlack).numberOfLines = 0
        self.lblTitle.textAlignment = .center
        self.lblTitle.text = "Login / Sign - Up via Phone Number to start using MyTatva"
        self.lblSubTitle.font(name: .regular, size: 14.0).textColor(color: .themeGray).numberOfLines = 0
        self.lblSubTitle.text = "We’ll send you a One Time Password"
        self.lblSubTitle.textAlignment = .center
        self.txtMobileNumber.placeholder = "Mobile Number"
        
        self.txtMobileNumber.borderStyle = .none
        self.txtMobileNumber.font(name: .medium, size: 13.0)
        self.txtMobileNumber.regex            = Validations.RegexType.OnlyNumber.rawValue
        self.txtMobileNumber.maxLength        = Validations.PhoneNumber.Maximum.rawValue
        self.txtMobileNumber.keyboardType     = .numberPad
        self.txtMobileNumber.delegate         = self
        self.vwMobileNumber.cornerRadius(cornerRadius: 4.0).borderColor(color: .ThemeBorder, borderWidth: 1.0)
        
        self.btnContinue.fontSize(size: 17.0).setTitle("Continue", for: UIControl.State())
//        self.self.txtMobileNumber.font(name: .medium, size: 13.0)
        
    }
    
    private func setupViewModelObserver() {
        
        self.viewModel.isResult.bind(observer: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    if self.viewModel.userAlreadyRegistered {
                        //User is already registered
                        self.viewModel.apiLogin(vc: self,
                                                countryCode: "+91",
                                                mobileNumber: self.txtMobileNumber.text!)
                    }
                    else {
                        //Continue with signup flow
                        let vc = VerificationVC.instantiate(fromAppStoryboard: .auth)
                        vc.strCountryCode   = "+91"
                        vc.strMobile        = self.txtMobileNumber.text!
                        vc.isLogin_send_otp = self.viewModel.isLogin_send_otp
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
    }
    
    private func addHeaderView() {
        guard let vw = UINib(nibName: "LoginHeaderView", bundle: nil).instantiate(withOwner: self, options: nil).first! as? LoginHeaderView else { return }
        vw.getViewHeight(completion: { [weak self] height in
            guard let self = self else { return }
            vw.frame = CGRect(x: 0, y: 0, width: self.vwMain.frame.width, height: height)
//            self.constHeaderHeight.constant = height
            self.vwMain.layoutIfNeeded()
            self.vwMain.layoutSubviews()
            /*UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self = self else { return }
                vw.frame = CGRect(x: 0, y: 0, width: self.vwMain.frame.width, height: height)
                self.constHeaderHeight.constant = height
                vw.layoutIfNeeded()
                self.vwMain.layoutSubviews()
                self.vwMain.addSubview(vw)
                vw.bringSubviewToFront(self.vwMain)
            }*/
        })
//        vw.setData(title: "Login / Sign - Up via Phone Number to start using MyTatva", subTitle: "We’ll send you a One Time Password")
        vw.backgroundColor = .white
        self.vwMain.addSubview(vw)
        vw.bringSubviewToFront(self.view)
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    private func addActions() {
        self.btnContinue.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.viewModel.apiCheckMobileNumber(countryCode: self.lblTitle.text!, mobileNumber: self.txtMobileNumber.text!)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = LoginSignupVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
        FIRAnalytics.FIRLogEvent(eventName: .NEW_USER_SIGNUP_ATTEMPT,
                                 screen: .LoginSignup,
                                 parameter: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        UserModel.accessToken = ""
        WebengageManager.shared.navigateScreenEvent(screen: .LoginSignup)
    }

}

//------------------------------------------------------
//MARK: - UITextFieldDelegate
extension LoginSignupVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard (textField.text! + string).count < 10 else { return false }
//        self.mobileNumber = string.isBackspace() ? String(self.mobileNumber.dropLast()) : textField.text! + string
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            guard let self = self else { return }
            self.mobileNumber = self.txtMobileNumber.text! 
        }
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered

    }
}
