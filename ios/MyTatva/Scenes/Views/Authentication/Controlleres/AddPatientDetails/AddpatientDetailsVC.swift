//
//  AddpatientDetailsVC.swift
//  MyTatva
//
//  Created by Hlink on 26/04/23.
//

import UIKit

class AddpatientDetailsVC: UIViewController {

    //MARK: Outlet
    
    @IBOutlet weak var constProgressTop     : NSLayoutConstraint!
    @IBOutlet weak var linearProgressBar    : LinearProgressBar!
    @IBOutlet weak var vwMain: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet var lblTitles: [UILabel]!
    @IBOutlet weak var txtFirstName: ThemeTextField!
    @IBOutlet weak var txtLastName: ThemeTextField!
    
    @IBOutlet var btnGenders: [UIButton]!
    
    @IBOutlet weak var txtDOB: ThemeTextField!
    @IBOutlet weak var txtEmail: ThemeTextField!
    @IBOutlet weak var txtCondition: ThemeTextField!
    
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var lblTerms: UILabel!
    
    @IBOutlet weak var btnNext: ThemePurpleButton!
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var datePicker                      = UIDatePicker()
    var dateFormatter                   = DateFormatter()
    
    var viewModel: AddPatientDetailVM!
    var selectedMedicalCondition        = MedicalConditionListModel()
    var arrMedicalCondition : [MedicalConditionListModel] = []
    
    var isBackShown = false
    var isToRoot = false
    var selectedGender = 1 {
        didSet {
            self.btnGenders.forEach({ $0.font(name: .medium, size: $0.tag == self.selectedGender ? 15 : 13).textColor(color: $0.tag == self.selectedGender ? .white : .themeBlack).backGroundColor(color: $0.tag == self.selectedGender ? .themePurple : .themeLightGray).cornerRadius(cornerRadius: 4.0).setTitle($0.tag == 1 ? "Male" : "Female", for: UIControl.State()) })
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
        self.setData()
        self.initDatePicker()
        self.addActions()
    }
    
    private func setData() {
        
        UserModel.shared.retrieveUserData()
        let userData = UserModel.shared
        
        if userData.severityId != nil {
            
            if userData.name.trim() != "" {
                var  name = userData.name.components(separatedBy: " ")
                self.txtFirstName.text   = name.first ?? ""
                self.txtFirstName.isUserInteractionEnabled = self.txtFirstName.text!.isEmpty
                name.removeFirst()
                self.txtLastName.text   = name.joined(separator: " ")
                self.txtLastName.isUserInteractionEnabled = txtLastName.text!.isEmpty
            }
            
            if userData.email.trim() != "" {
                self.txtEmail.text      = userData.email
                self.txtEmail.isUserInteractionEnabled = false
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
            }
            
            if userData.medicalConditionGroupId.trim() != "" {
                self.txtCondition.text = userData.indicationName
                self.txtCondition.isUserInteractionEnabled = self.txtCondition.text!.isEmpty
                
                self.selectedMedicalCondition.medicalConditionName      = userData.indicationName
                self.selectedMedicalCondition.medicalConditionGroupId   = userData.medicalConditionGroupId
                self.arrMedicalCondition.append(self.selectedMedicalCondition)
            }
        }
        
    }
    
    private func applyStyle() {
        
        self.constProgressTop.constant = DeviceManager.shared.hasNotch ? 40 : 20
        
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
        
        self.txtCondition.setRightImage(img: UIImage(named: "IconDownArrow"))
        self.txtCondition.delegate = self
        
        self.linearProgressBar.progressValue = 100
        self.linearProgressBar.cornerRadius(cornerRadius: 3)
        self.setProgress(progressBar: self.linearProgressBar, color: .themePurple)

        self.navigationItem.leftBarButtonItem = self.isBackShown || isBackVisible ? self.navigationItem.leftBarButtonItem ?? UIBarButtonItem() : nil
        
        self.lblTitle.font(name: .semibold, size: 17.0).textColor(color: .themeBlack).numberOfLines = 0
        self.lblTitle.textAlignment = .center
        self.lblTitle.text = "Almost there!"
        self.lblSubTitle.font(name: .regular, size: 14.0).textColor(color: .themeGray).numberOfLines = 0
        self.lblSubTitle.text = "Help us with your details so that we can set up\nthe app for you"
        self.lblSubTitle.textAlignment = .center
             
        self.lblTitles.forEach({ $0.font(name: .medium, size: 13.0).textColor(color: .themeBlack) })
        self.selectedGender = 1
        
        [self.txtFirstName,self.txtLastName,self.txtDOB,self.txtEmail,self.txtCondition].forEach({ $0?.placeholder = nil })
        
        self.lblTerms.text = "By signing up, you agree to our Terms & Conditions and Privacy Policy"
        self.lblTerms.font(name: .regular, size: 13.0).numberOfLines = 0
        self.lblTerms.isUserInteractionEnabled = true
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(tapLabelTerms(gesture:)))
        self.lblTerms.addGestureRecognizer(gesture2)

        self.lblTerms.setAttributedString(["By signing up, you agree to our","Terms & Conditions","and","Privacy Policy"], attributes: [[
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack
        ],[
            NSAttributedString.Key.foregroundColor : UIColor.themePurple
        ],[
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack
        ],[
            NSAttributedString.Key.foregroundColor : UIColor.themePurple
        ]])
        self.btnNext.fontSize(size: 17.0).setTitle("Next", for: UIControl.State())
//        self.self.txtMobileNumber.font(name: .medium, size: 13.0)
        
    }
    
    private func setupViewModelObserver() {
        self.viewModel.isResult.bind { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                
                FIRAnalytics.FIRLogEvent(eventName: .USER_SIGNUP_COMPLETE,
                                         screen: .AddAccountDetails,
                                         parameter: nil)
                
                /*kAppSessionTimeStart    = Date()
                kUserSessionActive      = true
                FIRAnalytics.FIRLogEvent(eventName: .USER_SESSION_START,
                                         parameter: nil)*/
                
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
                break
            case .failure(let error):
                Alert.shared.showSnackBar(error.localizedDescription)
                break
            case .none: break
            }
        }
    }
    
    func initDatePicker(){
       
        self.txtDOB.inputView               = self.datePicker
        self.txtDOB.delegate                = self
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
            self.txtDOB.text                = self.dateFormatter.string(from: sender.date)
            break
     
        default:break
        }
    }
    
    @objc func tapLabelTerms(gesture: UITapGestureRecognizer) {
        
        guard let text = lblTerms.attributedText?.string else {
            return
        }
        let vc = WebViewPopupVC.instantiate(fromAppStoryboard: .setting)
        if let range = text.range(of: "Terms & Conditions".localized),gesture.didTapAttributedTextInLabel(label: self.lblTerms, inRange: NSRange(range, in: text)) {
            print("Tapped")
            vc.webType = .Terms
        }else if let range = text.range(of: "Privacy Policy".localized),gesture.didTapAttributedTextInLabel(label: self.lblTerms, inRange: NSRange(range, in: text)) {
            print("Tapped")
            vc.webType = .Privacy
        }else {
            print("Tapped none")
            return
        }
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        UIApplication.topViewController()?.navigationController?.present(vc, animated: true)
        
    }

    
    func setProgress(progressBar: LinearProgressBar, color: UIColor){
        progressBar.trackColor          = UIColor.themeLightGray
        progressBar.trackPadding        = 0
        progressBar.capType             = 1
        
        switch progressBar {
        
        case self.linearProgressBar:
            progressBar.barThickness        = 10
            progressBar.barColor            = color
            
            progressBar.barColorForValue = { value in
                switch value {
                case 0..<20:
                    return color
                case 20..<60:
                    return color
                case 60..<80:
                    return color
                default:
                    return color
                }
            }
            
            break
       
        default: break
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    override func popViewController(sender: AnyObject) {
        
        if self.isToRoot {
            if let viewControllers = self.navigationController?.viewControllers {
                for vc in viewControllers {
                    // some process
                    if vc.isKind(of: EnterMobileViewPopUp.self) {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func addActions() {
        
        self.btnTerms.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.btnTerms.isSelected = !self.btnTerms.isSelected
        }
        
        self.btnNext.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.viewModel.apiAddDetails(firstName: self.txtFirstName.text!, lastName: self.txtLastName.text!, gender: {
                switch self.selectedGender {
                case 1: return "Male"
                case 2: return "Female"
                default: return ""
                }
            }(), dob: self.txtDOB.text!, email: self.txtEmail.text!, condition: self.txtCondition.text!, isTermSelected: self.btnTerms.isSelected, medical_condition_ids: self.arrMedicalCondition)
        }
        
        
    }
    
    @IBAction func btnGenderClicked(_ sender: UIButton) {
        self.selectedGender = sender.tag
    }
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = AddPatientDetailVM()
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
        WebengageManager.shared.navigateScreenEvent(screen: .AddAccountDetails)
    }

}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension AddpatientDetailsVC : UITextFieldDelegate {
    
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
            
        case self.txtCondition:
            
            let vc = SelectMedicalConditionPopupVC.instantiate(fromAppStoryboard: .auth)

            vc.arrDaysOffline = [self.selectedMedicalCondition]
            vc.modalPresentationStyle = .overFullScreen
            vc.completionHandler = { obj in
                //Do your task here
                self.selectedMedicalCondition      = obj
                self.txtCondition.text         = self.selectedMedicalCondition.medicalConditionName
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
