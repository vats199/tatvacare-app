
import UIKit

class EditProfileVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var vwProfile                    : UIView!
    @IBOutlet weak var imgUser                      : UIImageView!
    @IBOutlet weak var btnEditImage                 : UIButton!
    
    @IBOutlet weak var lblName                      : UILabel!
    @IBOutlet weak var txtName                      : UITextField!
    
    @IBOutlet weak var lblEmail                     : UILabel!
    @IBOutlet weak var txtEmail                     : UITextField!
    
    @IBOutlet weak var lblDob                       : UILabel!
    @IBOutlet weak var txtDob                       : UITextField!
    
    @IBOutlet weak var btnSubmit                    : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel               = EditProfileViewModel()
    
    var datePicker                      = UIDatePicker()
    var dateFormatter                   = DateFormatter()
    //var dateFormat                      = DateTimeFormaterEnum.ddmm_yyyy.rawValue
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .EditProfile)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        self.initDatePicker()
        self.manageActionMethods()
        self.setupHero()
        self.imgUser.image = UIImage(named: "defaultUser")
        
//        self.txtMobile.regex            = Validations.RegexType.OnlyNumber.rawValue
//        self.txtMobile.maxLength        = Validations.PhoneNumber.Maximum.rawValue
        
        self.txtName.defaultcharacterSet    = CharacterSet.letters.union(CharacterSet(charactersIn: ".' "))
        self.txtName.keyboardType           = .default
        self.txtName.maxLength              = Validations.MaxCharacterLimit.Name.rawValue
//        self.txtName.regex              = Validations.RegexType.AlpabetsDotQuoteSpace.rawValue
        
        self.txtEmail.keyboardType              = .emailAddress
        self.txtDob.isUserInteractionEnabled    = false
        
        DispatchQueue.main.async {
            self.imgUser.layoutIfNeeded()
            self.imgUser.cornerRadius(cornerRadius: self.imgUser.frame.height / 2)
        }
        
        self.setData()
//        GlobalAPI.shared.getPatientDetailsAPI { (isDone) in
//            if isDone {
//                self.setData()
//            }
//        }
    }
    
    private func applyStyle() {
        self.lblName.font(name: .semibold, size: 15).textColor(color: .themeBlack)
        self.lblEmail.font(name: .semibold, size: 15).textColor(color: .themeBlack)
        self.lblDob.font(name: .semibold, size: 15).textColor(color: .themeBlack)
       
    }
    
    private func setupHero(){
        self.hero.isEnabled         = true
        self.imgUser.hero.id        = "imgUser"
        self.txtName.hero.id        = "lblUser"
        self.txtEmail.hero.id       = "lblEmail"
        self.txtDob.hero.id         = "lblYearGender"
        self.imgUser.hero.modifiers = [.translate(y:100)]
    }
    
    func initDatePicker(){
       
        self.txtDob.inputView               = self.datePicker
        self.txtDob.delegate                = self
        self.datePicker.datePickerMode      = .date
        self.datePicker.maximumDate         =  Calendar.current.date(byAdding: .year, value: -18, to: Date())
        self.datePicker.timeZone            = .current
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
    
        if #available(iOS 14, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.datePicker:
            self.dateFormatter.dateFormat   = appDateFormat
            self.dateFormatter.timeZone     = .current
            self.txtDob.text                = self.dateFormatter.string(from: sender.date)
            break
     
        default:break
        }
    }
    
    //MARK:- Action Method
    private func manageActionMethods(){
        
        self.btnEditImage.addTapGestureRecognizer {
            DispatchQueue.main.async {
                ImagePickerController(isAllowEditing: true) { [weak self] (pickedImage) in
                    
                    self?.imgUser.image = pickedImage
                    
                }.present()
            }
        }
        
        self.imgUser.addTapGestureRecognizer {
            DispatchQueue.main.async {
                ImagePickerController(isAllowEditing: true) { [weak self] (pickedImage) in
                    
                    self?.imgUser.image = pickedImage
                    
                }.present()
            }
        }
        
        
        self.btnSubmit.addTapGestureRecognizer {
            self.viewModel.apiUpdatePatientDetails(vc: self,
                                                   profileImage: self.imgUser.image!,
                                                   name: self.txtName.text!,
                                                   email: self.txtEmail.text!,
                                                   dob: self.txtDob.text!)
        }
    }
    
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension EditProfileVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtDob:
            
            if self.txtDob.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appDateFormat
                self.dateFormatter.timeZone     = .current
                self.txtDob.text                = self.dateFormatter.string(from: self.datePicker.date)
            }
            break
            
        default:
            break
        }
        return true
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension EditProfileVC {
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                //Alert.shared.showAlert(message: "Login success", completion: nil)
                self.navigationController?.popViewController(animated: true)
                
            break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
    }
    
}

//MARK: -------------------------- Set data --------------------------
extension EditProfileVC {
    
    func setData(){
        let object = UserModel.shared
        
        //self.imgUser.setCustomImage(with: object.profilePic)
        self.imgUser.setCustomImage(with: object.profilePic ?? "",
                                    placeholder: UIImage(named: "defaultUser"), andLoader: true, completed: nil)
        self.txtName.text               = object.name//"Rakesh Kappor"
        
        let dob_time = GFunction.shared.convertDateFormate(dt: object.dob,
                                                           inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           outputFormat: appDateFormat,
                                                           status: .NOCONVERSION)
        
        self.txtDob.text                = dob_time.0//"15 Sep, 1995"
        self.txtEmail.text              = object.email//"rakesh.kapoor@gmail.com"
        
    }
    
}
