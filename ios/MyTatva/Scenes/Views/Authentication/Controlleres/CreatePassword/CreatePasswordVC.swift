
import UIKit

class CreatePasswordVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var lblCreatePass            : UILabel!
    
    @IBOutlet weak var vwNewPassword            : UIView!
    @IBOutlet weak var vwConfirmPassword        : UIView!
    
    @IBOutlet weak var txtNewPassword           : UITextField!
    @IBOutlet weak var txtConfirmPassword       : UITextField!
    
    @IBOutlet weak var btnShowNewPassword       : UIButton!
    @IBOutlet weak var btnShowConfirmPassword   : UIButton!
    
    @IBOutlet weak var btnSubmit                : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel               = CreatePasswordVM()
    var strMobile                       = ""
    var strCode                         = ""
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
        WebengageManager.shared.navigateScreenEvent(screen: .CreatePassword)
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
        
        //self.txtPassword.regex          = Validations.RegexType.Password.rawValue
        self.txtNewPassword.maxLength           = Validations.Password.Maximum.rawValue
        self.txtNewPassword.keyboardType        = .default
        self.txtConfirmPassword.maxLength       = Validations.Password.Maximum.rawValue
        self.txtConfirmPassword.keyboardType    = .default
        
        if DeviceManager.Platform.isSimulator {
            self.txtNewPassword.text = "123456"
            self.txtConfirmPassword.text = "123456"
        }
        
        self.btnShowNewPassword.isSelected      = true
        self.hideShowPassword(sender: self.btnShowNewPassword)
        self.btnShowNewPassword.addTapGestureRecognizer {
            self.hideShowPassword(sender: self.btnShowNewPassword)
        }
        
        self.btnShowConfirmPassword.isSelected  = true
        self.hideShowPassword(sender: self.btnShowConfirmPassword)
        self.btnShowConfirmPassword.addTapGestureRecognizer {
            self.hideShowPassword(sender: self.btnShowConfirmPassword)
        }
    }
    
    private func applyStyle() {
        self.lblCreatePass.font(name: .bold, size: 22).textColor(color: .themePurple)
    }
    
    func hideShowPassword(sender: UIButton){
        switch sender {
        case self.btnShowNewPassword:
            if sender.isSelected {
                sender.isSelected                       = false
                self.txtNewPassword.isSecureTextEntry   = true
                sender.alpha                            = 1
            }
            else {
                sender.isSelected                       = true
                self.txtNewPassword.isSecureTextEntry   = false
                sender.alpha                            = 0.6
            }
            break
        case self.btnShowConfirmPassword:
            if sender.isSelected {
                sender.isSelected                       = false
                self.txtConfirmPassword.isSecureTextEntry = true
                sender.alpha                            = 1
            }
            else {
                sender.isSelected                       = true
                self.txtConfirmPassword.isSecureTextEntry = false
                sender.alpha                            = 0.6
            }
            break
        default:
            break
        }
    }
    
    //MARK:- Action Method
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
       
        self.viewModel.apiCall(vc: self,
                               countryCode: self.strCode,
                               mobile: self.strMobile,
                               newPwd: self.txtNewPassword,
                               confirmPwd: self.txtConfirmPassword,
                               vwNewPassword: self.vwNewPassword,
                               vwConfirmPassword: self.vwConfirmPassword)
    }
   
}

//MARK: -------------------- setupViewModel Observer --------------------
extension CreatePasswordVC {
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                //Alert.shared.showAlert(message: "Login success", completion: nil)
                //self.navigationController?.popViewController(animated: true)
                FIRAnalytics.FIRLogEvent(eventName: .PASSWORD_CHANGE,
                                         screen: . CreatePassword,
                                         parameter: nil)
                UIApplication.shared.setLogin()
            break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
    }
    
}

