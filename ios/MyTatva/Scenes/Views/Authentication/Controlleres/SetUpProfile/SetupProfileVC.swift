//
//  QuestionsOneVC.swift
//  MyTatva
//
//  Created by Uttam patel on 04/07/23.
//

import Foundation
import UIKit

class SetupProfileVC: UIViewController {
    //MARK: - Outlets -
    
    @IBOutlet weak var lblSetupProfile: UILabel!
    @IBOutlet weak var txtName: ThemeFloatingTextField!
    @IBOutlet weak var txtEmail: ThemeFloatingTextField!
    @IBOutlet weak var txtDOB: ThemeFloatingTextField!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblDoctorCode: UILabel!
    @IBOutlet weak var txtEnterCode: ThemeFloatingTextField!
    @IBOutlet weak var btnScanner: UIButton!
    @IBOutlet weak var imgSuceessDoctor: UIImageView!
    @IBOutlet weak var lblDoctorName: UILabel!
    @IBOutlet weak var btnSelectTerm: UIButton!
    @IBOutlet weak var lblTermsCondition: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet var btnGenders: [UIButton]!
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var vwDoctorCode: UIView!
    @IBOutlet weak var lblShowAccessCode: UILabel!
    @IBOutlet weak var svDoctorAccessCode: UIStackView!
    
    @IBOutlet weak var vwTxtName: UIView!
    @IBOutlet weak var vwTxtEmail: UIView!
    @IBOutlet weak var vwTxtDOB: UIView!
    @IBOutlet weak var vwTxtEnterCode: UIView!
    
    @IBOutlet weak var vwErrorEnterCode: UIView!
    @IBOutlet weak var vwErrorEmail: UIView!
    @IBOutlet weak var lblEroorEnterCode: UILabel!
    @IBOutlet weak var lblErrorEmail: UILabel!
    
    @IBOutlet weak var vwErrorName: UIView!
    @IBOutlet weak var lblEroorName: UILabel!
    //MARK: - Class Variables -
    
    var datePicker           = UIDatePicker()
    var dateFormatter        = DateFormatter()
    var viewModel: SetupProfileVM!
    
    var isBackShown = false
    var isToRoot = false
    var isShowAccessField = true {
        didSet {
            self.setDoctorCode()
        }
    }
    
    var isCheck = false
    
    var inputs: [UITextField] {
        get {
            return !(UserModel.shared.accessCode.trim().isEmpty || UserModel.shared.doctorAccessCode.trim().isEmpty) ? [txtName, txtEmail, txtDOB] : [txtName, txtEmail, txtDOB, txtEnterCode]
        }
    }
    
    
    var selectedGender = 1 {
        didSet {
            self.btnGenders.forEach({ $0.font(name: .semibold, size: $0.tag == self.selectedGender ? 12 : 12).textColor(color: $0.tag == self.selectedGender ? .themeBlack2 : .themeGray4).borderColor(color: $0.tag == self.selectedGender ? .themePurpleBlack : .themeBorder2).backGroundColor(color: $0.tag == self.selectedGender ? .themePurple.withAlphaComponent(0.08) : .white).cornerRadius(cornerRadius: $0.tag == self.selectedGender ? 16 : 12).setTitle($0.tag == 1 ? "Male" : "Female", for: UIControl.State()) })
            
            self.btnGenders.forEach({ $0.applyViewShadow(shadowOffset: .zero, shadowColor: $0.tag == self.selectedGender ? .clear : .themeBlack2.withAlphaComponent(0.3), shadowOpacity: 0.3, shdowRadious: 3) })
            
            
            if self.selectedGender == 0 {
                self.btnGenders.forEach({ $0.setImage($0.tag == 1 ? UIImage(named: "ic_deseMale") : UIImage(named: "ic_deseFemale"), for: UIControl.State()) })
                
            } else if self.selectedGender == 1 {
                self.btnGenders.forEach({ $0.setImage($0.tag == 1 ? UIImage(named: "ic_seMale") : UIImage(named: "ic_deseFemale"), for: UIControl.State()) })
                
            } else {
                self.btnGenders.forEach({ $0.setImage($0.tag == 2 ? UIImage(named: "ic_seFemale") : UIImage(named: "ic_deseMale"), for: UIControl.State()) })
            }
            
        }
    }
    
    var verifyUserModel = VerifyUserModel()
    var pendingRequest: DispatchWorkItem?
    
    
    //MARK: - View Life Cycle -
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = SetupProfileVM()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    //------------------------------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.navigationController?.isNavigationBarHidden = !self.isBackShown
    }
    
    //------------------------------------------------------------------------------------------
    
    override func popViewController(sender: AnyObject) {
        if self.isToRoot {
            if let viewControllers = self.navigationController?.viewControllers {
                for vc in viewControllers {
                    // some process
                    if vc.isKind(of: EnterMobileViewPopUp.self) {
                        kAccessCode = ""
                        kDoctorAccessCode = ""
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
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
        self.setData()
        self.addActions()
        self.initDatePicker()
        self.checkEnableForInputs(textFields: inputs)
    }
    
    //------------------------------------------------------------------------------------------
    
    func applyStyle() {
        
        self.txtName.keyboardType   = .default
        self.txtEnterCode.keyboardType   = .default
        self.txtEmail.keyboardType      = .emailAddress
        
        self.txtName.autocapitalizationType = .sentences

        self.txtName.defaultcharacterSet   = CharacterSet.letters.union(CharacterSet(charactersIn: ".' "))
        self.txtName.maxLength      = Validations.MaxCharacterLimit.Name.rawValue
        self.txtEmail.maxLength         = Validations.MaxCharacterLimit.Email.rawValue
        
        self.lblSetupProfile.font(name: .bold, size: 20).textColor(color: .themeBlack2)
        self.lblGender.font(name: .bold, size: 14).textColor(color: .themeBlack2).text = "Gender"
        self.lblDoctorCode.font(name: .bold, size: 14).textColor(color: .themeBlack2).text = "Doctor Code"
        self.lblDoctorName.font(name: .regular, size: 12).textColor(color: .themeGreenAlert)
        
        self.lblTermsCondition.text = "By signing up, you agree to our Terms & Conditions and Privacy Policy"
        self.lblTermsCondition.font(name: .regular, size: 12.0).numberOfLines = 0
        self.lblTermsCondition.isUserInteractionEnabled = true
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(tapLabelTerms(gesture:)))
        self.lblTermsCondition.addGestureRecognizer(gesture2)
        
        self.lblTermsCondition.setAttributedString(["By signing up, you agree to our","Terms & Conditions","and","Privacy Policy"], attributes: [[
            NSAttributedString.Key.foregroundColor : UIColor.themeGray5
        ],[
            NSAttributedString.Key.foregroundColor : UIColor.themeGray5,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ],[
            NSAttributedString.Key.foregroundColor : UIColor.themeGray5
        ],[
            NSAttributedString.Key.foregroundColor : UIColor.themeGray5,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]])
        
        self.isShowAccessField = true
        
        self.txtDOB.setRightImage(img: UIImage(named: "ic_downArrow")?.imageWithSize(size: CGSize(width: 16, height: 16), extraMargin: 16))
        
        self.btnNext.cornerRadius(cornerRadius: 16).borderColor(color: .themeGray5.withAlphaComponent(0.5)).backGroundColor(color: .themeGray5.withAlphaComponent(0.03))
        self.btnNext.font(name: .bold, size: 16).textColor(color: .themeGray5.withAlphaComponent(0.5))
        
        self.btnScanner.cornerRadius(cornerRadius: 12).borderColor(color: .themePurple).backGroundColor(color: .themePurple.withAlphaComponent(0.08))
        
        self.btnCheck.font(name: .bold, size: 12).textColor(color: .themeGray4)
        
        self.selectedGender = 0
        self.lblDoctorName.isHidden = true
        self.imgSuceessDoctor.isHidden = true
        
        self.btnNext.isEnabled = false
        self.txtEnterCode.isUserInteractionEnabled = true
        
        self.btnCheck.alpha = 0.3
        self.btnCheck.isUserInteractionEnabled = false
        self.txtName.delegate = self
        self.txtEmail.delegate = self
        self.txtDOB.delegate = self
        self.txtEnterCode.delegate = self
        
        self.btnScanner.isUserInteractionEnabled = true
        self.txtEnterCode.isSecureTextEntry = true
        
        self.vwTxtName.cornerRadius(cornerRadius: 12.0).borderColor(color: .themeBorder2).themeTextFieldShadow()
        self.vwTxtEmail.cornerRadius(cornerRadius: 12.0).borderColor(color: .themeBorder2).themeTextFieldShadow()
        self.vwTxtDOB.cornerRadius(cornerRadius: 12.0).borderColor(color: .themeBorder2).themeTextFieldShadow()
        self.vwTxtEnterCode.cornerRadius(cornerRadius: 12.0).borderColor(color: .themeBorder2).themeTextFieldShadow()
        
        self.vwErrorEmail.isHidden = true
        self.vwErrorEnterCode.isHidden = true
        self.vwErrorName.isHidden = true
        
        self.lblEroorName.font(name: .regular, size: 12).textColor(color: .themeRedAlert)
        self.lblErrorEmail.font(name: .regular, size: 12).textColor(color: .themeRedAlert)
        self.lblEroorEnterCode.font(name: .regular, size: 12).textColor(color: .themeRedAlert)
    }
    
    private func setDoctorCode() {
            let tmpText = self.isShowAccessField ? "Click here, if you don't have a doctor code." : "If you have a doctor code, click here." + "\n(Proceed without code if you don't have one. We will auto-assign a code)"
            self.lblShowAccessCode.text = tmpText
            self.lblShowAccessCode.font(name: .semibold, size: 14.0).numberOfLines = 0
            self.lblShowAccessCode.isUserInteractionEnabled = true
    //        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(tapLabelAccessCode(gesture:)))
    //        self.lblShowAccessCode.addGestureRecognizer(gesture3)
            
            self.lblShowAccessCode.setAttributedString(self.isShowAccessField ? ["Click","here",", if you don't have a doctor code."] : ["If you have a doctor code, click","here",".\n(Proceed without code if you don't have one. We will auto-assign a code)"], attributes: [[
                NSAttributedString.Key.foregroundColor : UIColor.themePurple
            ],[
                NSAttributedString.Key.foregroundColor : UIColor.colorFromHex(hex: 0x052EFF),
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
            ],[
                NSAttributedString.Key.font : UIFont.customFont(ofType: self.isShowAccessField ? .semibold : .regular, withSize: self.isShowAccessField ? 14.0 : 12.0),
                NSAttributedString.Key.foregroundColor : UIColor.themePurple
            ]])
        }
        
    
    func initDatePicker() {
        self.txtDOB.inputView               = self.datePicker
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
    
    private func setData() {
        
        UserModel.shared.retrieveUserData()
        let userData = UserModel.shared
        
        
        if userData.name.trim() != "" {
            self.txtName.text   = userData.name
            self.txtName.isUserInteractionEnabled = txtName.text!.isEmpty
            self.vwTxtName.borderColor(color: .themePurpleBlack)
        }
        
        if userData.email.trim() != "" {
            self.txtEmail.text      = userData.email
            self.txtEmail.isUserInteractionEnabled = false
            self.vwTxtEmail.borderColor(color: .themePurpleBlack)
        }
        
        if userData.gender.trim() != "" {
            self.selectedGender = userData.gender == "M" ? 1 : 0
            self.btnGenders.forEach({ $0.isUserInteractionEnabled = false })
        }
        
        if userData.dob.trim() != "" {
            //"dob" : "1998-01-08",
            let date = GFunction.shared.convertDateFormate(dt: userData.dob,
                                                           inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           outputFormat: appDateFormat,
                                                           status: .NOCONVERSION)
            self.txtDOB.text = date.0
            self.txtDOB.isUserInteractionEnabled = self.txtDOB.text!.isEmpty
            self.vwTxtDOB.borderColor(color: .themePurpleBlack)
        }
        
        self.vwDoctorCode.isHidden = !((userData.accessCode ?? "").trim().isEmpty || (userData.doctorAccessCode ?? "").trim().isEmpty )
            
        if self.vwDoctorCode.isHidden {
                    var params              = [String: Any]()
                    FIRAnalytics.FIRLogEvent(eventName: .DOCTOR_ACCESS_CODE_HIDDEN_BY_DEFAULT,
                                             screen: ScreenName.AddAccountDetails,
                                             parameter: params)
                }

    }
    
    //------------------------------------------------------------------------------------------
    
    @objc func tapLabelAccessCode(gesture: UITapGestureRecognizer) {
        
        guard let text = self.lblShowAccessCode.attributedText?.string else {
            return
        }
        
        if let range = text.range(of: "here"),gesture.didTapAttributedTextInLabel(label: self.lblShowAccessCode, inRange: NSRange(range, in: text)) {
            print("Tapped")
            self.svDoctorAccessCode.isHidden = !self.svDoctorAccessCode.isHidden
        }else {
            print("Tapped none")
            return
        }
    }
    
    @objc func tapLabelTerms(gesture: UITapGestureRecognizer) {
        
        guard let text = lblTermsCondition.attributedText?.string else {
            return
        }
        //        let vc = WebViewPopupVC.instantiate(fromAppStoryboard: .setting)
        let vc = WebviewVC.instantiate(fromAppStoryboard: .setting)
        if let range = text.range(of: "Terms & Conditions".localized),gesture.didTapAttributedTextInLabel(label: self.lblTermsCondition, inRange: NSRange(range, in: text)) {
            print("Tapped")
            vc.webType = .Terms
        }else if let range = text.range(of: "Privacy Policy".localized),gesture.didTapAttributedTextInLabel(label: self.lblTermsCondition, inRange: NSRange(range, in: text)) {
            print("Tapped")
            vc.webType = .Privacy
        }else {
            print("Tapped none")
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        //        vc.modalPresentationStyle = .overFullScreen
        //        vc.modalTransitionStyle = .crossDissolve
        //        UIApplication.topViewController()?.navigationController?.present(vc, animated: true)
        
    }
    
    //------------------------------------------------------------------------------------------
    
    @objc func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.datePicker:
            self.dateFormatter.dateFormat   = appDateFormat
            self.dateFormatter.timeZone     = .current
            self.txtDOB.text                = self.dateFormatter.string(from: sender.date)
            break
            
        default:break
        }
    }
    
    //------------------------------------------------------------------------------------------
    
    private func addActions() {
        self.lblShowAccessCode.addTapGestureRecognizer { [weak self] in
                    guard let self = self else { return }
                    self.svDoctorAccessCode.isHidden = !self.svDoctorAccessCode.isHidden
                    self.isShowAccessField = !self.isShowAccessField
                    self.txtEnterCode.text = nil
                    self.btnCheck.isUserInteractionEnabled = false
                    self.btnCheck.alpha = 0.3
                    self.vwTxtEnterCode.borderColor(color: .themeBorder2)
                    self.vwErrorEnterCode.isHidden = true
                    self.validateForEnable()
                    
                    var params              = [String: Any]()
                    FIRAnalytics.FIRLogEvent(eventName: !self.isShowAccessField ? .USER_CLICK_DONT_HAVE_ACCESS_CODE : .USER_CLICK_HAVE_ACCESS_CODE,
                                             screen: ScreenName.AddAccountDetails,
                                             parameter: params)
                    
                    
                }
                
        self.btnSelectTerm.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.btnSelectTerm.isSelected = !self.btnSelectTerm.isSelected
            self.validateForEnable()
        }
        
        
        self.btnCheck.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.view.endEditing(true)
            
            var params              = [String: Any]()
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICK_CHECK_ACCESS_CODE,
                                     screen: ScreenName.AddAccountDetails,
                                     parameter: params)
            if self.txtEnterCode.text?.trim() == "" {
                //                Alert.shared.showSnackBar(AppError.validation(type: .enterAccessCode).errorDescription ?? "")
                Alert.shared.showSnackBar(AppError.validation(type: .enterAccessCode).errorDescription ?? "", isError: true, isBCP: true)
            }
            else {
                GlobalAPI.shared.verifyDoctorLinkAPI(doctorAccessCode: self.txtEnterCode.text!) { [weak self]  isDone, msg in
                    guard let self = self else {return}
                    self.vwErrorEnterCode.isHidden = false
                    self.lblEroorEnterCode.text = msg
//                    self.vwTxtEnterCode.borderColor(color: UIColor.themeRedAlert)
                    if isDone {
                        self.lblShowAccessCode.isHidden = true
                        self.isCheck = true
                        self.imgSuceessDoctor.isHidden = false
                        self.lblDoctorName.isHidden = false
                        self.txtEnterCode.isUserInteractionEnabled = false
                        self.lblDoctorName.text = kDoctorName
                        self.btnScanner.isUserInteractionEnabled = false
                        self.btnCheck.isUserInteractionEnabled = false
                        self.btnCheck.alpha = 0.5
                    }
                }
            }
        }
        
        self.btnNext.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.apiRegisterTemp(name: self.txtName.text!, email: self.txtEmail.text!, date: self.txtDOB.text!, isTermSelected: self.btnSelectTerm.isSelected, gender: {
                switch self.selectedGender {
                case 1: return "Male"
                case 2: return "Female"
                default: return ""
                }
            }(), code: self.txtEnterCode.text!, isCheck: self.isShowAccessField ? self.isCheck : true)
        }
        
        self.btnScanner.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.openCamera()
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraAuthorizationStatus {
            case .notDetermined:
                self.requestCameraPermission()
                break
            case .authorized:
                self.openScanner()
                break
            case .restricted, .denied:
                self.openAppOrSystemSettingsAlert(title: "Camera permission is currently disabled for the application. Enable Camera permission from the application settings.", message: "")
                break
            @unknown default:
                return
            }
        }
        else{
            Alert.shared.showAlert(message: AppMessages.imagepickerCameraError, completion: nil)
        }
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            self.openScanner()
        })
    }
    
    func openScanner() {
        DispatchQueue.main.async {
            
            let vc = ScanQRVC.instantiate(fromAppStoryboard: .auth)
            vc.pageType = .LinkDoctor
            vc.completionHandler = { obj in
                if obj.count > 0 {
                    
                    var params = [String:Any]()
                    params[AnalyticsParameters.doctor_access_code.rawValue] =
                    FIRAnalytics.FIRLogEvent(eventName: .SCAN_DOCTOR_QR,
                                             screen: .LinkDoctor,
                                             parameter: params)
                    
                    GlobalAPI.shared.verifyDoctorLinkAPI(doctorAccessCode: kAccessCode) { [weak self]  isDone, msg in
                        guard let self = self else {return}
                        self.vwErrorEnterCode.isHidden = false
                        self.lblEroorEnterCode.text = msg
                        self.txtEnterCode.text = kAccessCode
//                        self.vwTxtEnterCode.borderColor(color: .themePurpleBlack)
//                        self.vwTxtEnterCode.borderColor(color: UIColor.themeRedAlert)
                        self.validateForEnable()
                        if isDone {
                            DispatchQueue.main.async {
                                self.lblShowAccessCode.isHidden = true
                                self.isCheck = true
                                self.imgSuceessDoctor.isHidden = false
                                self.lblDoctorName.isHidden = false
                                self.txtEnterCode.text = kAccessCode
                                self.txtEnterCode.isUserInteractionEnabled = false
                                self.lblDoctorName.text = kDoctorName
                                self.btnScanner.isUserInteractionEnabled = false
                                self.vwTxtEnterCode.borderColor(color: .themePurpleBlack)
                                self.btnCheck.alpha = 0.3
                            }
                        }
                    }
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func openAppOrSystemSettingsAlert(title: String, message: String) {
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) -> Void in
            
        }
        alertController.addAction(cancelAction)
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    private func setupViewModelObserver() {
        self.viewModel.isResult.bind { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                UserDefaultsConfig.kUserStep = 3
                let vc = ChronicConditionsVC.instantiate(fromAppStoryboard: .AuthTemp)
                vc.isBackShown = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .failure(let error):
                debugPrint("Error", error.localizedDescription)
                
                self.viewModel.isRChange.bind { [weak self] result in
                    guard let self = self else { return }
                    
                    if result == 1 {
                        self.vwErrorEmail.isHidden = false
                        self.lblErrorEmail.text = error.localizedDescription
                    } else {
                        Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                    }
                }
                break
            case .none: break
            }
        }
    }
    
    func checkEnableForInputs(textFields: [UITextField]) {
        textFields.forEach { (input) -> Void in
            input.addAction(for: .allEditingEvents) {
                self.validateForEnable()
            }
        }
    }
    
    func validateForEnable() {
        
        if self.isShowAccessField {
            self.btnNext.isEnabled = false
            self.btnNext.borderColor(color: .themeGray5.withAlphaComponent(0.5)).backGroundColor(color: .themeGray5.withAlphaComponent(0.03)).textColor(color: .themeGray5.withAlphaComponent(0.5))
            
            if inputs.first(where: { $0.text!.trim().isEmpty }) != nil {
                return
            } else if self.selectedGender == 0 {
                return
            } else if !btnSelectTerm.isSelected {
                return
            }
            
            self.btnNext.isEnabled = true
            self.btnNext.borderColor(color: .themePurple).backGroundColor(color: .white).textColor(color: .themePurple)
        } else {
            self.btnNext.isEnabled = false
            self.btnNext.borderColor(color: .themeGray5.withAlphaComponent(0.5)).backGroundColor(color: .themeGray5.withAlphaComponent(0.03)).textColor(color: .themeGray5.withAlphaComponent(0.5))
            
            if [txtName, txtEmail, txtDOB].first(where: { $0.text!.trim().isEmpty }) != nil {
                return
            } else if self.selectedGender == 0 {
                return
            } else if !btnSelectTerm.isSelected {
                return
            }
            
            self.btnNext.isEnabled = true
            self.btnNext.borderColor(color: .themePurple).backGroundColor(color: .white).textColor(color: .themePurple)
        }
        
    }
    
    @IBAction func btnGenderClicked(_ sender: UIButton) {
        self.selectedGender = sender.tag
        self.validateForEnable()
    }
    
}

//===========================================================================

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension SetupProfileVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.txtDOB:
            if let _ = self.presentedViewController {
                return false
            }
            else {
                if self.txtDOB.text?.trim() == "" {
                    self.dateFormatter.dateFormat   = appDateFormat
                    self.dateFormatter.timeZone     = .current
                    self.txtDOB.text                = self.dateFormatter.string(from: self.datePicker.date)
                }
                return true
            }
            
        default:
            break
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
            
        case self.txtName:
            self.vwErrorName.isHidden = true
            if (range.location == 0 && string == " ") || (textField.text!.isEmpty && !string.containsAlphabets) {
                return false
            } else {
                let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.' "
                let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                let typedCharacterSet = CharacterSet(charactersIn: string)
                let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
                return alphabet
            }

        case self.txtEnterCode:
            self.vwErrorEnterCode.isHidden = true
            self.vwTxtEnterCode.borderColor(color: .themePurpleBlack)
            self.pendingRequest?.cancel()
            self.pendingRequest = DispatchWorkItem(block: { [weak self] in
                guard let self = self else { return }
                self.btnCheck.alpha = self.txtEnterCode.isEmpty ? 0.3 : 1
                self.btnCheck.isUserInteractionEnabled = self.txtEnterCode.isEmpty ? false : true
            })
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.25, execute: self.pendingRequest!)
            break
        case self.txtEmail:
            let str = (string.isBackspace() ? String(textField.text!.dropLast()) : textField.text! + string)
            self.vwErrorEmail.isHidden = (str.count >= 7 && !Validation.isValidEmail(testStr: str)) ? false : true
            self.lblErrorEmail.text = AppError.validation(type: .enterValidEmail).errorDescription
             
            break
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case self.txtName :
            self.vwTxtName.borderColor(color: .themePurpleBlack)
            break
        case self.txtEmail :
            self.vwTxtEmail.borderColor(color: .themePurpleBlack)
            break
        case self.txtDOB :
            self.vwTxtDOB.borderColor(color: .themePurpleBlack)
            break
        case self.txtEnterCode :
            self.vwTxtEnterCode.borderColor(color: .themePurpleBlack)
            break
        default:
            break
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case self.txtName :

            self.vwErrorName.isHidden = textField.text!.isEmpty  ? false : true
            self.lblEroorName.text = AppError.validation(type: .enterName).errorDescription
            self.vwTxtName.borderColor(color: self.txtName.text!.isEmpty ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
            break
        case self.txtEmail :
            if textField.text == ""  {
                self.vwErrorEmail.isHidden = textField.text!.isEmpty  ? false : true
                self.lblErrorEmail.text = AppError.validation(type: .enterEmail).errorDescription
                self.vwTxtEmail.borderColor(color: self.txtEmail.text!.isEmpty ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
            } else {
                self.vwErrorEmail.isHidden = !Validation.isValidEmail(testStr: textField.text!) ? false : true
                self.lblErrorEmail.text = AppError.validation(type: .enterValidEmail).errorDescription
                self.vwTxtEmail.borderColor(color: self.txtEmail.text!.isEmpty ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
            }
           
            break
        case self.txtDOB :
            self.vwTxtDOB.borderColor(color: self.txtDOB.text!.isEmpty ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
            break
        case self.txtEnterCode :
            self.vwErrorEnterCode.isHidden = textField.text!.isEmpty  ? false : true
            self.lblEroorEnterCode.text = AppError.validation(type: .enterAccessCode).errorDescription
            self.vwTxtEnterCode.borderColor(color: self.txtEnterCode.text!.isEmpty ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
            break
        default:
            break
        }
        
    }
    
}

