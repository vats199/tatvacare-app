
import UIKit

class MedicalConditionCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var btnDelete        : UIButton!
    
    override func awakeFromNib() {
        
        self.lblTitle.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


class AddAccountDetailsVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var scrollMain           : UIScrollView!
    @IBOutlet weak var btnBack              : UIButton!
    
    @IBOutlet weak var lblAddAccDetails     : UILabel!
    
    @IBOutlet weak var lblVerifiedMobile    : UILabel!
    @IBOutlet weak var imgVerifiedMobile    : UIImageView!
    @IBOutlet weak var txtVerifiedMobile    : UITextField!
    @IBOutlet weak var btnEditVerifiedMobile: UIButton!
    
    @IBOutlet weak var txtFirstName         : UITextField!
    @IBOutlet weak var txtLastName          : UITextField!
    @IBOutlet weak var txtEmail             : UITextField!
    @IBOutlet weak var txtPassword          : UITextField!
    @IBOutlet weak var txtConfirmPassword   : UITextField!
    @IBOutlet weak var lblPasswordMsg       : UILabel!
    @IBOutlet weak var vwPassword           : UIView!
    @IBOutlet weak var vwConfirmPassword    : UIView!
    
    @IBOutlet weak var btnShowPassword      : UIButton!
    @IBOutlet weak var btnShowConfirmPassword : UIButton!
    
    
    @IBOutlet weak var lblGender            : UILabel!
    @IBOutlet weak var sgGender             : UISegmentedControl!
    
    @IBOutlet weak var vwDob                : UIView!
    @IBOutlet weak var lblDob               : UILabel!
    @IBOutlet weak var txtDob               : UITextField!
    
    @IBOutlet weak var lblAccountRole       : UILabel!
    @IBOutlet weak var sgAccountRole        : UISegmentedControl!
    
    @IBOutlet weak var btnSelectTerms       : UIButton!
    @IBOutlet weak var lblTerms             : UILabel!
    @IBOutlet weak var btnOpenTerms         : UIButton!
    @IBOutlet weak var lblAnd               : UILabel!
    @IBOutlet weak var btnPrivacy           : UIButton!
    
    @IBOutlet weak var vwLinkDoctor         : UIView!
    @IBOutlet weak var lblLinkDoctor        : UILabel!
    @IBOutlet weak var btnNeedHelp          : UIButton!
    @IBOutlet weak var lblAccessCode        : UILabel!
    @IBOutlet weak var txtAccessCode        : UITextField!
    @IBOutlet weak var btnVerifyAccessCode  : UIButton!
    
    @IBOutlet weak var btnOr                : UIButton!
    
    @IBOutlet weak var btnScanQrCode        : UIButton!
    
    @IBOutlet weak var vwSelectMedicalCondition : UIView!
    @IBOutlet weak var lblSelectMedicalCondition : UILabel!
    @IBOutlet weak var txtSelectMedicalCondition : UITextField!
    
    @IBOutlet weak var btnAddMedicalCondition  : UIButton!
    @IBOutlet weak var colMedicalCondition     : UICollectionView!
    
    @IBOutlet weak var btnSubmit            : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel               = AddAccountDetailsVM()
    
    var datePicker                      = UIDatePicker()
    var dateFormatter                   = DateFormatter()
    //var dateFormat                      = DateTimeFormaterEnum.ddmm_yyyy.rawValue
    
    var strMale                         = "Male"
    var strFemale                       = "Female"
    var strPreferNotToSay               = "Prefer not to say"
    var strSelectedGender               = "M"
    
    var strPatient                      = "Patient"
    var strCaregiver                    = "Caregiver"
    var strSelectedRole                 = "P"
    
    var strCountryCode                  = "+91"
    var strMobile                       = ""
    var selectedLanguageListModel       = LanguageListModel()
    var selectedMedicalCondition        = MedicalConditionListModel()
    var verifyUserModel                 = VerifyUserModel()
    var isAccessCodeVerified            = false
    
    var arrMedicalCondition : [MedicalConditionListModel] = []
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
        WebengageManager.shared.navigateScreenEvent(screen: .AddAccountDetails)
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
    func setUpView() {
        self.applyStyle()
        self.initDatePicker()
        self.manageActionMethods()
        self.setup(collectionView: self.colMedicalCondition)
        
//        self.txtMobile.regex            = Validations.RegexType.OnlyNumber.rawValue
//        self.txtMobile.maxLength        = Validations.PhoneNumber.Maximum.rawValue
        
        
        self.txtFirstName.defaultcharacterSet    = CharacterSet.letters.union(CharacterSet(charactersIn: ".' "))
        self.txtFirstName.maxLength      = Validations.MaxCharacterLimit.Name.rawValue
//        self.txtFullName.regex          = Validations.RegexType.AlpabetsDotQuoteSpace.rawValue
        self.txtFirstName.keyboardType  = .default
        
        self.txtLastName.maxLength      = Validations.MaxCharacterLimit.Name.rawValue
//        self.txtFullName.regex          = Validations.RegexType.AlpabetsDotQuoteSpace.rawValue
        self.txtLastName.defaultcharacterSet    = CharacterSet.letters.union(CharacterSet(charactersIn: ".' "))
        self.txtLastName.keyboardType   = .default
        
        self.txtEmail.maxLength         = Validations.MaxCharacterLimit.Email.rawValue
        self.txtEmail.keyboardType      = .emailAddress
        
        //self.txtPassword.regex          = Validations.RegexType.Password.rawValue
        self.txtPassword.maxLength      = Validations.Password.Maximum.rawValue
        self.txtPassword.keyboardType   = .default
        
        self.txtSelectMedicalCondition.delegate = self
        
        if kAccessCode.trim() == "" {
            self.vwLinkDoctor.alpha         = 1
            self.vwLinkDoctor.isHidden      = false
            self.vwLinkDoctor.isUserInteractionEnabled = true
            
//            self.vwLinkDoctor.alpha         = 0.5
//            self.vwLinkDoctor.isHidden      = true
//            self.vwLinkDoctor.isUserInteractionEnabled = false
//            self.txtAccessCode.text         = kDoctorAccessCode
        }
        else {
            self.isAccessCodeVerified       = true
            self.vwLinkDoctor.alpha         = 0.5
            self.vwLinkDoctor.isHidden      = true
            self.vwLinkDoctor.isUserInteractionEnabled = false
            self.txtAccessCode.text         = kAccessCode
        }
        
        self.txtVerifiedMobile.isUserInteractionEnabled = false
        self.txtVerifiedMobile.text = self.strCountryCode + " " + self.strMobile
        if DeviceManager.Platform.isSimulator {
            self.txtFirstName.text = "John"
            self.txtLastName.text = "Doe"
            self.txtEmail.text = "a@gmail.com"
            self.txtPassword.text = "Abcd@123"
            self.txtConfirmPassword.text = "Abcd@123"
            //self.txtDob.text = "Abcd@123"
        }
        self.setData()
    }
    
    private func applyStyle() {
        self.lblAddAccDetails.font(name: .bold, size: 22).textColor(color: .themePurple)
        
        self.lblVerifiedMobile.font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.txtVerifiedMobile.font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.lblGender.font(name: .medium, size: 16).textColor(color: .themeBlack)
        
        self.sgGender .setTitle(self.strMale, forSegmentAt: 0)
        self.sgGender.setWidth(self.sgGender.frame.width / 4.2, forSegmentAt: 0)
        
        self.sgGender.setTitle(self.strFemale, forSegmentAt: 1)
        self.sgGender.setWidth(self.sgGender.frame.width / 4.2, forSegmentAt: 1)
        
        self.sgGender.setTitle(self.strPreferNotToSay, forSegmentAt: 2)
        self.sgGender.selectedSegmentIndex = 0
        self.strSelectedGender = "M"
        self.lblPasswordMsg.font(name: .regular, size: 12).textColor(color: .themeBlack.withAlphaComponent(1))
        self.lblPasswordMsg.text = """
Enter password with
1. Minimum of \(Validations.Password.Minimum.rawValue) characters
2. Must contain at least one uppercase letter
3. One lowercase letter
4. One number and
5. One special character (i.e #@$!%*&)
"""

//        for i in 0...self.sgGender.segmentTitles.count - 1{
//
//            let width   = self.sgGender.segmentTitles[i]?.width(withConstraintedHeight: self.sgGender.frame.height, font: UIFont.customFont(ofType: .medium, withSize: 16))
//            self.sgGender.setWidth(width ?? 0 + 100, forSegmentAt: i)
//        }
        
        self.sgAccountRole.setTitle(self.strPatient, forSegmentAt: 0)
        //self.sgAccountRole.setTitle(self.strCaregiver, forSegmentAt: 1)
        self.sgAccountRole.selectedSegmentIndex = 0
        self.sgAccountRole.removeAllSegments()
        self.sgAccountRole.insertSegment(withTitle: self.strPatient, at: 0, animated: true)
        self.sgAccountRole.selectedSegmentIndex = 0
        self.strSelectedRole = "P"
        
        self.lblDob.font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.lblAccountRole.font(name: .medium, size: 16).textColor(color: .themeBlack)
        
        self.lblTerms.font(name: .regular, size: 15).textColor(color: .themeBlack)
        self.lblAnd.font(name: .regular, size: 15).textColor(color: .themeBlack)
        self.btnOpenTerms.font(name: .regular, size: 15).textColor(color: .themePurple)
        self.btnPrivacy.font(name: .regular, size: 15).textColor(color: .themePurple)
        
        self.lblLinkDoctor.font(name: .semibold, size: 18).textColor(color: .themeBlack)
        self.btnNeedHelp.font(name: .medium, size: 14).textColor(color: .themePurple)
        self.lblAccessCode.font(name: .medium, size: 16).textColor(color: .themeBlack)
        
        self.btnScanQrCode.font(name: .medium, size: 16).textColor(color: .themePurple)
        
        self.lblSelectMedicalCondition.font(name: .semibold, size: 18).textColor(color: .themeBlack)
        self.txtSelectMedicalCondition.setRightImage(img: UIImage(named: "IconDownArrow"))
        self.btnAddMedicalCondition.font(name: .medium, size: 14).textColor(color: .themePurple)
        self.btnAddMedicalCondition.isHidden = true
        
        self.btnOr.font(name: .medium, size: 16).textColor(color: .themeBlack)
    }
    
    func setup(collectionView: UICollectionView){
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
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
    
    @IBAction func selectGender(sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            self.strSelectedGender = "M"
        }
        else if sender.selectedSegmentIndex == 1 {
            self.strSelectedGender = "F"
        }
        else if sender.selectedSegmentIndex == 2 {
            self.strSelectedGender = "P"
        }
    }
    
    @IBAction func selectRole(sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            self.strSelectedRole = "P"
        }
        else if sender.selectedSegmentIndex == 1 {
            self.strSelectedRole = "C"
        }
    }
    
    func hideShowPassword(sender: UIButton){
        if sender.isSelected {
            sender.isSelected                   = false
            self.txtPassword.isSecureTextEntry  = true
            sender.alpha                        = 1
        }
        else {
            sender.isSelected                   = true
            self.txtPassword.isSecureTextEntry  = false
            sender.alpha                        = 0.6
        }
    }
    
    func hideShowConfirmPassword(sender: UIButton){
        if sender.isSelected {
            sender.isSelected                   = false
            self.txtConfirmPassword.isSecureTextEntry  = true
            sender.alpha                        = 1
        }
        else {
            sender.isSelected                   = true
            self.txtConfirmPassword.isSecureTextEntry  = false
            sender.alpha                        = 0.6
        }
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
        self.btnShowPassword.isSelected = true
        self.hideShowPassword(sender: self.btnShowPassword)
        self.btnShowPassword.addTapGestureRecognizer {
            self.hideShowPassword(sender: self.btnShowPassword)
        }
        
        self.btnAddMedicalCondition.addTapGestureRecognizer {
            if self.txtSelectMedicalCondition.text?.trim() != "" {
//                var obj: JSON = ["name": ""]
//                obj["name"].stringValue = self.txtSelectMedicalCondition.text!
//
                self.txtSelectMedicalCondition.text = ""
                if self.arrMedicalCondition.count > 0 {
                    if self.arrMedicalCondition.contains(where: { (obj) -> Bool in
                        return !(obj.medicalConditionGroupId == self.selectedMedicalCondition.medicalConditionGroupId)
                    }) {
                        self.arrMedicalCondition.append(self.selectedMedicalCondition)
                        self.colMedicalCondition.reloadData()
                    }
                }
                else {
                    self.arrMedicalCondition.append(self.selectedMedicalCondition)
                    self.colMedicalCondition.reloadData()
                }
            }
        }
        
        self.btnShowConfirmPassword.isSelected = true
        self.hideShowConfirmPassword(sender: self.btnShowConfirmPassword)
        self.btnShowConfirmPassword.addTapGestureRecognizer {
            self.hideShowConfirmPassword(sender: self.btnShowConfirmPassword)
        }
    
        self.btnOpenTerms.addTapGestureRecognizer {
            //GFunction.shared.openLink(strLink: kTerms, inApp: true)
            let vc = WebViewPopupVC.instantiate(fromAppStoryboard: .setting)
            vc.webType = .Terms
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            UIApplication.topViewController()?.navigationController?.present(vc, animated: true)
        }
        
        self.btnPrivacy.addTapGestureRecognizer {
//            GFunction.shared.openLink(strLink: kPrivacy, inApp: true)
            let vc = WebViewPopupVC.instantiate(fromAppStoryboard: .setting)
            vc.webType = .Privacy
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            UIApplication.topViewController()?.navigationController?.present(vc, animated: true)
        }
        
        self.btnSelectTerms.isSelected = false
        //self.updateSubmit()
        self.btnSelectTerms.addTapGestureRecognizer {
            self.btnSelectTerms.isSelected = !self.btnSelectTerms.isSelected
            //self.updateSubmit()
        }
        
        self.btnEditVerifiedMobile.addTapGestureRecognizer {
            //self.txtVerifiedMobile.becomeFirstResponder()
            self.navigationController?.popViewController(animated: true)
        }
        
        self.btnNeedHelp.addTapGestureRecognizer {
            let vc = WebviewVC.instantiate(fromAppStoryboard: .setting)
            vc.webType = .needHelp
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnBack.addTapGestureRecognizer {
            kDoctorAccessCode   = ""
            kAccessCode         = ""
            UIApplication.shared.setLogin()
        }
        
        
        self.btnScanQrCode.addTapGestureRecognizer {
            let vc = ScanQRVC.instantiate(fromAppStoryboard: .auth)
            vc.pageType = .LinkDoctor
            vc.completionHandler = { obj in 
                if obj.count > 0 {
                    self.isAccessCodeVerified = true
                    self.btnVerifyAccessCode.isUserInteractionEnabled = false
                    self.btnVerifyAccessCode.alpha =	 0.5
                    self.txtAccessCode.isUserInteractionEnabled = false
                    self.txtAccessCode.text = kAccessCode
                    self.scrollMain.scrollToView(view: self.lblVerifiedMobile, animated: true)
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnVerifyAccessCode.addTapGestureRecognizer {
            if self.txtAccessCode.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .enterAccessCode).errorDescription ?? "")
            }
            else {
                //API CALL
                GlobalAPI.shared.verifyDoctorLinkAPI(doctorAccessCode: self.txtAccessCode.text!) { [weak self]  isDone, msg in
                    guard let self = self else {return}
                    if isDone {
                        self.isAccessCodeVerified = true
                        self.btnVerifyAccessCode.isUserInteractionEnabled = false
                        self.btnVerifyAccessCode.alpha =     0.5
                        self.txtAccessCode.isUserInteractionEnabled = false
                        self.txtAccessCode.text = kDoctorAccessCode
                        self.scrollMain.scrollToView(view: self.lblVerifiedMobile, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
       
        self.viewModel.registerApiCall(vc: self,
                                       countryCode: "+91",
                                       contact_no: self.strMobile,
                                       email: self.txtEmail,
                                       language_id: UserDefaultsConfig.languageId,
                                       firstName: self.txtFirstName,
                                       lastName: self.txtLastName,
                                       dob: self.txtDob,
                                       vwDob: self.vwDob,
                                       gender: self.strSelectedGender,
                                       password: self.txtPassword,
                                       confirmPassword: self.txtConfirmPassword,
                                       vwPassword: self.vwPassword,
                                       vwConfirmPassword: self.vwConfirmPassword,
                                       account_role: self.strSelectedRole,
                                       isAccessCodeVerified: self.isAccessCodeVerified,
                                       access_code: self.txtAccessCode.text!,
                                       active_deactive_id: "",
                                       is_accept_terms_accept: self.btnSelectTerms.isSelected,
                                       profile_pic: "",
                                       whatsapp_optin: false,
                                       email_verified: false,
                                       medical_condition_ids: self.arrMedicalCondition)
        
//        self.viewModel.apiLogin(vc: self,
//                                countryCode: "+91",
//                                mobile: self.txtMobile.text!,
//                                password: self.txtPassword.text!,
//                                isAgreeTerms: self.btnSelectTerms.isSelected,
//                                isRemember: self.btnRemember.isSelected)
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension AddAccountDetailsVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.txtDob:
            
            if let _ = self.presentedViewController {
                return false
            }
            else {
                if self.txtDob.text?.trim() == "" {
                    self.dateFormatter.dateFormat   = appDateFormat
                    self.dateFormatter.timeZone     = .current
                    self.txtDob.text                = self.dateFormatter.string(from: self.datePicker.date)
                }
                return true
            }
            
        case self.txtSelectMedicalCondition:
            
            let vc = SelectMedicalConditionPopupVC.instantiate(fromAppStoryboard: .auth)
//            let arrTemp: [JSON] = [
//                [
//                    "name" : self.txtSelectMedicalCondition.text!,
//                    "short" : "Sun",
//                    "isSelected": 0,
//                ]
//            ]
            vc.arrDaysOffline = [self.selectedMedicalCondition]
            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandler = { obj in
                //Do your task here
                self.selectedMedicalCondition      = obj
                self.txtSelectMedicalCondition.text         = self.selectedMedicalCondition.medicalConditionName
                self.arrMedicalCondition.append(self.selectedMedicalCondition)
            }
            self.present(vc, animated: true, completion: nil)
            
            return false
            
        default:
            break
        }
        
        return true
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension AddAccountDetailsVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colMedicalCondition:
            self.colMedicalCondition.isHidden = true
            //self.colMedicalCondition.isHidden = self.arrMedicalCondition.count > 0 ? false : true
            
            return self.arrMedicalCondition.count
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView {
        
        case self.colMedicalCondition:
            let cell : MedicalConditionCell = collectionView.dequeueReusableCell(withClass: MedicalConditionCell.self, for: indexPath)
            let obj                     = self.arrMedicalCondition[indexPath.item]
            
//            let time = GFunction.shared.convertDateFormate(dt: object.createdAt,
//                                                           inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
//                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
//                                                           status: .LOCAL)
            
            
            cell.lblTitle.text          = obj.medicalConditionName
            
            cell.btnDelete.addTapGestureRecognizer {
                self.arrMedicalCondition.remove(at: indexPath.item)
                self.colMedicalCondition.reloadData()
            }
      
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colMedicalCondition:
//            var obj = arrFavDrink[indexPath.item]
//            obj["is_select"].intValue = obj["is_select"].intValue == 1 ? 0 : 1
//            arrFavDrink[indexPath.item] = obj
            
//            for i in 0...self.arrDealsData.count - 1 {
//                var object = self.arrDealsData[i]
//                object["is_select"].intValue = 0
//                if object["title"].stringValue == obj["title"].stringValue {
//                    object["is_select"].intValue = 1
//                }
//                self.arrDealsData[i] = object
//            }
            //self.colSuggestedDose.reloadData()
          
            break
       
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colMedicalCondition:
            let obj     = self.arrMedicalCondition[indexPath.item]
            let width   = obj.medicalConditionName.width(withConstraintedHeight: 15.0, font: UIFont.customFont(ofType: .medium, withSize: 12.0))
            let height  = self.colMedicalCondition.frame.size.height
            
            return CGSize(width: width + 60,
                          height: height)
            
        default:
            
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
}

//MARK: -------------------- set data func --------------------
extension AddAccountDetailsVC {
    
    func setData(){
        if self.verifyUserModel.severityId != nil {
            
            if self.verifyUserModel.name.trim() != "" {
                self.txtFirstName.text   = self.verifyUserModel.name
                self.txtFirstName.isUserInteractionEnabled = false
            }
            
            if self.verifyUserModel.email.trim() != "" {
                self.txtEmail.text      = self.verifyUserModel.email
                self.txtEmail.isUserInteractionEnabled = false
            }
            
            if self.verifyUserModel.gender.trim() != "" {
                self.strSelectedGender  = self.verifyUserModel.gender
                
                if self.strSelectedGender == "M" {
                    self.sgGender.selectedSegmentIndex = 0
                }
                else if self.strSelectedGender == "F" {
                    self.sgGender.selectedSegmentIndex = 1
                }
                else if self.strSelectedGender == "P" {
                    self.sgGender.selectedSegmentIndex = 2
                }
                
                self.sgGender.isUserInteractionEnabled = false
            }
            
            if self.verifyUserModel.dob.trim() != "" {
                //"dob" : "1998-01-08",
                let date = GFunction.shared.convertDateFormate(dt: self.verifyUserModel.dob,
                                                               inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                               outputFormat: appDateFormat,
                                                               status: .NOCONVERSION)
                self.txtDob.text = date.0
            }
            
            if self.verifyUserModel.medicalConditionGroupId.trim() != "" {
                self.txtSelectMedicalCondition.text = self.verifyUserModel.indicationName
                self.txtSelectMedicalCondition.isUserInteractionEnabled = false
                
                self.selectedMedicalCondition.medicalConditionName      = self.verifyUserModel.indicationName
                self.selectedMedicalCondition.medicalConditionGroupId   = self.verifyUserModel.medicalConditionGroupId
                self.arrMedicalCondition.append(self.selectedMedicalCondition)
            }
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension AddAccountDetailsVC {
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                FIRAnalytics.FIRLogEvent(eventName: .USER_SIGNUP_COMPLETE,
                                         screen: .AddAccountDetails,
                                         parameter: nil)
                
                /*kAppSessionTimeStart    = Date()
                kUserSessionActive      = true
                FIRAnalytics.FIRLogEvent(eventName: .USER_SESSION_START,
                                         screen: .AddAccountDetails,
                                         parameter: nil)*/
                
                //Alert.shared.showAlert(message: "Login success", completion: nil)
                
//                UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.currentUser)
//                UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.authorization)

//
                //UIApplication.shared.manageLogin()

//                if BiometricsManager.shared.getBiometricType() != .none {
//                    let vc = BiometricVC.instantiate(fromAppStoryboard: .auth)
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                else {
//                    
//                }
                
                DispatchQueue.main.async {
                    let vc = AllSetVC.instantiate(fromAppStoryboard: .auth)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.completionHandler = { obj in
                        //if obj?.count > 0 {
                            if let obj = UserModel.shared.profileCompletionStatus {
                                if obj.location == "N" {
                                    
                                    let loc = SetLocationVC.instantiate(fromAppStoryboard: .auth)
                                    loc.hidesBottomBarWhenPushed = true
                                    self.navigationController?.pushViewController(loc, animated: true)
                                }
                                else if obj.drugPrescription == "N" {
                                    
                                    let goal = AddPrescriptionVC.instantiate(fromAppStoryboard: .auth)
                                    goal.hidesBottomBarWhenPushed = true
                                    self.navigationController?.pushViewController(goal, animated: true)
                                }
                                else if obj.goalReading == "N" {
                                    
                                    let goal = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
                                    goal.hidesBottomBarWhenPushed = true
                                    self.navigationController?.pushViewController(goal, animated: true)
                                    
                                }
                            }
                        //}
                    }
                    self.present(vc, animated: true, completion: nil)
                }
                
            break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
