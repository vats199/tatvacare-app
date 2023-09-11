//
//  CreateAccountVC.swift
//
//

import UIKit


class ChangePasswordVC: WhiteNavigationBaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var txtOldPassword           : CustomSkyTextField!
    @IBOutlet weak var txtNewPassword           : CustomSkyTextField!
    @IBOutlet weak var txtConfirmPassword       : CustomSkyTextField!
    
    @IBOutlet weak var btnShowOldPassword       : UIButton!
    @IBOutlet weak var btnShowNewPassword       : UIButton!
    @IBOutlet weak var btnShowConfirmPassword   : UIButton!
    
    @IBOutlet weak var btnSubmit                : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel = ChangePasswordViewModel()
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    //MARK: ----------------------- Custom Method -----------------------
    private func setUpView() {
        self.applyStyle()
        
        DispatchQueue.main.async {
            self.btnSubmit.layoutIfNeeded()
            
            self.btnSubmit.cornerRadius(cornerRadius: self.btnSubmit.frame.height / 2)
            
            self.navigationController?.clearNavigation(textColor: UIColor.themePurple, navigationColor: UIColor.white)
        }
        
        self.btnShowOldPassword.isSelected = true
        self.btnShowNewPassword.isSelected = true
        self.btnShowConfirmPassword.isSelected = true
        
        self.passwordSecure(sender: self.btnShowOldPassword)
        self.passwordSecure(sender: self.btnShowNewPassword)
        self.passwordSecure(sender: self.btnShowConfirmPassword)
    }
    
    private func applyStyle() {
        
        self.btnSubmit.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
            .backGroundColor(color: UIColor.themePurple)
    }
    
    func passwordSecure(sender: UIButton){
        switch sender {
        case self.btnShowOldPassword:
            if sender.isSelected {
                self.btnShowOldPassword.isSelected = false
                self.txtOldPassword.isSecureTextEntry = true
            }
            else {
                self.btnShowOldPassword.isSelected = true
                self.txtOldPassword.isSecureTextEntry = false
            }
            
            break
        case self.btnShowNewPassword:
            
            if sender.isSelected {
                self.btnShowNewPassword.isSelected = false
                self.txtNewPassword.isSecureTextEntry = true
            }
            else {
                self.btnShowNewPassword.isSelected = true
                self.txtNewPassword.isSecureTextEntry = false
            }
            break
        case self.btnShowConfirmPassword:
            
            if sender.isSelected {
                self.btnShowConfirmPassword.isSelected = false
                self.txtConfirmPassword.isSecureTextEntry = true
            }
            else {
                self.btnShowConfirmPassword.isSelected = true
                self.txtConfirmPassword.isSecureTextEntry = false
            }
            break
        default:break
        }
    }
    
    //MARK: -------------------- Action Method --------------------
    @IBAction func btnUpdateTapped(_ sender: Any) {
        self.viewModel.apiCall(vc: self,
                               oldPwd: self.txtOldPassword.text!,
                               newPwd: self.txtNewPassword.text!,
                               confirmPwd: self.txtConfirmPassword.text!)
    }
    
    @IBAction func btnPasswordSecureTapped(_ sender: UIButton) {
        self.passwordSecure(sender: sender)
    }
    
}

//MARK: -------------------- setupViewModel Observer --------------------
extension ChangePasswordVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.navigationController?.popViewController(animated: true)
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

