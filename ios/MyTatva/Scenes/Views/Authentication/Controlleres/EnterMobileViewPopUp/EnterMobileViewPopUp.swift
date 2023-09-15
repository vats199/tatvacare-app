//
//  EnterMobileViewPopUp.swift
//  MyTatva
//
//  Created by Uttam patel on 05/06/23.
//

import Foundation
import UIKit

class EnterMobileViewPopUp: UIViewController {
    //MARK: - Outlets -
    
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var imgTopLine: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblSubHeader: UILabel!
    @IBOutlet weak var vwMainMobileContainer: UIView!
    @IBOutlet weak var vwCountryFlag: UIView!
    @IBOutlet weak var vwMobileContainer: UIView!
    
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtMobileNum: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    //MARK: - Class Variables -
    
    
    var complition: (() -> Void)?
    
    var viewModel: EnterMobileViewPopUpVM!
    var mobileNumber = "" {
        didSet {
            let isValid = self.mobileNumber.count >= 10
            self.btnContinue.backGroundColor(color: isValid ? .themePurple : .ThemeDarkBlack.withAlphaComponent(0.5)).isUserInteractionEnabled = isValid
        }
    }
    
    //MARK: - View Life Cycle -
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = EnterMobileViewPopUpVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
        
    }
    
    //------------------------------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        UserModel.accessToken = ""
        self.txtMobileNum.becomeFirstResponder()
        
        UserDefaults.standard.set(true, forKey: "isWalk")
        UserDefaults.standard.synchronize()
        
        UserDefaultsConfig.kUserStep = 0
    }
    
    //------------------------------------------------------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(false, forKey: "isWalk")
        UserDefaults.standard.synchronize()
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmissVC))
        tapGesture.numberOfTapsRequired = 1
        self.imgBg.isUserInteractionEnabled = true
        self.imgBg.addGestureRecognizer(tapGesture)
    }
    
    //------------------------------------------------------------------------------------------
    
    func applyStyle() {
        self.mobileNumber = ""
        DispatchQueue.main.async { [weak self]  in
            guard let self = self else {return}
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 20)
        }
        
        self.imgTopLine.backGroundColor(color: .themeGray3)
        self.lblHeader.font(name: .bold, size: 24).textColor(color: .themeBlack2)
        
        self.lblMobileNumber.font(name: .regular, size: 10).textColor(color: .themeGray5)
        self.lblSubHeader.font(name: .regular, size: 14).textColor(color: .themeGray5)
    
        self.vwMainMobileContainer.cornerRadius(cornerRadius: 12).borderColor(color: .themePurpleBlack)
        
        self.lblCountryCode.font(name: .semibold, size: 14).textColor(color: .themeBlack).text = "+91"
        self.txtMobileNum.font(name: .semibold, size: 14).textColor(color: .themeBlack)
        self.txtMobileNum.regex            = Validations.RegexType.OnlyNumber.rawValue
        self.txtMobileNum.maxLength        = Validations.PhoneNumber.Maximum.rawValue
        self.txtMobileNum.keyboardType     = .numberPad
        self.txtMobileNum.delegate         = self
        
        self.btnContinue.cornerRadius(cornerRadius: 16).backGroundColor(color: .ThemeDarkBlack.withAlphaComponent(0.5))
        self.btnContinue.font(name: .bold, size: 16).textColor(color: UIColor.white)
        
        self.txtMobileNum.tintColor = .themePurpleBlack
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.imgTopLine.setRound()
        }
    
    }
    
    //------------------------------------------------------------------------------------------
    
    @objc  func dissmissVC() {
        self.dismiss(animated: true, completion: nil)
        self.fireLogEvent(mobileNum: !self.txtMobileNum.isEmpty ? self.txtMobileNum.text! : "")
        self.complition!()
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
                                                mobileNumber: self.txtMobileNum.text!)
                    }
                    else {
                        //Continue with signup flow
                        let vc = AutoVerificationOTPVC.instantiate(fromAppStoryboard: .auth)
                        vc.strCountryCode   = "+91"
                        vc.strMobile        = self.txtMobileNum.text!
                        vc.isLogin_send_otp = self.viewModel.isLogin_send_otp
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                break
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                self.txtMobileNum.becomeFirstResponder()
                break
            case .none: break
            }
        })
    }
    
     //------------------------------------------------------------------------------------------
    
    func fireLogEvent(mobileNum: String) {
        var params = [String: Any]()
        params[AnalyticsParameters.bottom_sheet_name.rawValue]   = mobileNum
        FIRAnalytics.FIRLogEvent(eventName: .CLOSE_BOTTOM_SHEET,
                                 screen: .LoginSignup,
                                 parameter: params)
    }
    
     //------------------------------------------------------------------------------------------
    
    
    
    //MARK: - Button Action Methods -
    
    
    @IBAction func btnDownSheetTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.fireLogEvent(mobileNum: !self.txtMobileNum.isEmpty ? self.txtMobileNum.text! : "")
        self.complition!()
    }
    
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.viewModel.apiCheckMobileNumber(countryCode: self.lblHeader.text!, mobileNumber: self.txtMobileNum.text!)
        
    }
    
    //------------------------------------------------------------------------------------------
    
}

//------------------------------------------------------
//MARK: - UITextFieldDelegate
extension EnterMobileViewPopUp: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard (textField.text! + string).count < 10 else { return false }
//        self.mobileNumber = string.isBackspace() ? String(self.mobileNumber.dropLast()) : textField.text! + string
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            guard let self = self else { return }
            self.mobileNumber = self.txtMobileNum.text!
        }
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
        
    }
}
