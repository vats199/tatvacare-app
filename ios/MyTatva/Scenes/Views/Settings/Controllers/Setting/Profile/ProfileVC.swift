//
//  CartVC.swift
//

//

import UIKit
import IQKeyboardManagerSwift

class ProfileIndicationCell : UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle          : UILabel!
    
    override func awakeFromNib() {
        self.lblTitle.font(name: .regular, size: 20)
            .textColor(color: UIColor.themeBlack)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            
        }
    }
}

class ProfileConsultingDocCell : UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblGender        : UILabel!
    @IBOutlet weak var lblPhone         : UILabel!
    
    @IBOutlet weak var stackEmail       : UIStackView!
    @IBOutlet weak var lblEmail         : UILabel!
    @IBOutlet weak var lblAddress       : UILabel!
    
    override func awakeFromNib() {
        
        self.lblTitle.font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblGender.font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblPhone.font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblEmail.font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblAddress.font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            
            self.vwBg.cornerRadius(cornerRadius: 0)
            self.vwBg.borderColor(color: UIColor.themeLightGray, borderWidth: 0)
            
            self.imgView.layoutIfNeeded()
            self.imgView.cornerRadius(cornerRadius: self.imgView.frame.size.height / 2)
            //self.vwBg.applyViewShadow(shadowOffset: CGSize.zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 3)
        }
    }
}

class ProfileVC: ClearNavigationFontBlackBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    
    //Top
    @IBOutlet weak var vwProfile                    : UIView!
    @IBOutlet weak var imgUser                      : UIImageView!
    @IBOutlet weak var btnEditImage                 : UIButton!
    @IBOutlet weak var lblUser                      : UILabel!
    @IBOutlet weak var btnLanguage                  : UIButton!
    @IBOutlet weak var lblYearGender                : UILabel!
    @IBOutlet weak var lblMobile                    : UILabel!
    @IBOutlet weak var lblEmail                     : UILabel!
    
    @IBOutlet weak var vwLocation                   : UIView!
    @IBOutlet weak var lblLocation                  : UILabel!
    @IBOutlet weak var lblLocationVal               : UILabel!
    @IBOutlet weak var btnEditLocation              : UIButton!
    
    @IBOutlet weak var vwAddress                    : UIView!
    @IBOutlet weak var lblAddress                   : UILabel!
    @IBOutlet weak var btnEditAddress               : UIButton!
    @IBOutlet weak var vwAddressBox                 : UIView!
    @IBOutlet weak var tvAddress                    : IQTextView!
    
    @IBOutlet weak var vwIndication                 : UIView!
    @IBOutlet weak var lblIndication                : UILabel!
    @IBOutlet weak var tblIndication                : UITableView!
    @IBOutlet weak var tblIndicationHeight          : NSLayoutConstraint!
    
    @IBOutlet weak var vwConsultingDoctor           : UIView!
    @IBOutlet weak var btnAddNewDoctor              : UIButton!
    @IBOutlet weak var lblConsultingDoctor          : UILabel!
    @IBOutlet weak var tblConsultingDoctor          : UITableView!
    @IBOutlet weak var tblConsultingDoctorHeight    : NSLayoutConstraint!
    
    @IBOutlet weak var vwHC                         : UIView!
    @IBOutlet weak var lblHC                        : UILabel!
    @IBOutlet weak var tblHC                        : UITableView!
    @IBOutlet weak var tblHCHeight                  : NSLayoutConstraint!
    @IBOutlet weak var vwStudyID                    : UIView!
    @IBOutlet weak var lblStudyID                   : UILabel!
    @IBOutlet weak var btnEditStudyID               : UIButton!
    @IBOutlet weak var vwTxtStudyID                 : UIView!
    @IBOutlet weak var txtStudyID                   : UITextField!
    @IBOutlet weak var constTxtLeft                 : NSLayoutConstraint!
    
    //MARK:- Class Variable
    let refreshControl                      = UIRefreshControl()
    var strErrorMessage : String            = ""
    private var selectedLanguageListModel   = LanguageListModel()
    private let chatHistoryListVM           = ChatHistoryListVM()
    
    ///set up DiffableDataSource of list table
    typealias tblDataSource = UITableViewDiffableDataSource<Int, HealthCoachListModel>
    lazy var dataSource: tblDataSource = {
        let datasource = tblDataSource(tableView: self.tblHC,
                                       cellProvider: { (tableView, indexPath, object) -> UITableViewCell? in
            let cell : ChatHistoryListCell = tableView.dequeueReusableCell(withClass: ChatHistoryListCell.self, for: indexPath)
            
            let object = self.chatHistoryListVM.getObject(index: indexPath.row)
            cell.imgView.setCustomImage(with: object.profilePic)
            cell.lblTitle.text      = object.firstName + " " + object.lastName
            cell.lblDesc.text       = object.role
            cell.lblDesc2.text      = ""
            cell.lblTime.text       = ""
            
            cell.imgView.addTapGestureRecognizer {
                GlobalAPI.shared.getHealthCoachDetailsAPI(health_coach_id: object.healthCoachId) { [weak self] isDone, obj in
                    
                    guard let self = self else {return}
                    
                    if isDone {
                        
                        let vc1 = HealthCoachDetailsVC.instantiate(fromAppStoryboard: .setting)
                        vc1.object = obj
                        vc1.modalPresentationStyle = .overCurrentContext
                        vc1.modalTransitionStyle = .crossDissolve
                        vc1.hidesBottomBarWhenPushed = true
                        let nav = UINavigationController(rootViewController: vc1)
                        self.present(nav, animated: true, completion: nil)
                        
                    }
                }
                
            }
            
            return cell
            
        })
        return datasource
    }()
    
    var arrIndication : [JSON] = [
        [
            "img" : "indication_ic",
            "title" : "COPD Gold 4",
            "is_select" : 0
        ]
    ]
    
    var arrConsultingDoctor : [JSON] = [
        [
            "img" : "defaultUser",
            "title" : "Dr. Sameer Sharma",
            "desc" : "Pulmonologist | MBBS",
            "address" : "Breach Candy, Cumballa Hill, Mumbai, 60 A, Bhulabhai Desai Marg",
            "is_select" : 0
        ]
    ]
    
    //MARK: ------------------------- Memory Management Method -------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    func setUpView() {
        self.addObserverOnHeightTbl()
        self.configureUI()
        self.manageActionMethods()
        self.configureUI()
        self.setupViewModelObserver()
        
        self.btnEditAddress.setTitle(AppMessages.edit, for: .normal)
        self.btnEditAddress.setTitle(AppMessages.save, for: .selected)
        
        self.btnEditStudyID.setTitle(AppMessages.edit, for: .normal)
        self.btnEditStudyID.setTitle(AppMessages.save, for: .selected)
        
        //        UserModel.shared.getUserDetailAPI { (isDone) in
        //            if isDone {
        //                self.setData()
        //            }
        //        }
        self.setData()
        GlobalAPI.shared.getPatientDetailsAPI { [weak self] (isDone) in
            
            guard let self = self else {return}
            
            if isDone {
                self.setData()
            }
        }
        
    }
    
    func configureUI(){
        
        self.lblUser
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblYearGender
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblMobile
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblEmail
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.btnLanguage
            .font(name: .regular, size: 9)
            .textColor(color: UIColor.themeBlack)
        
        self.lblLocation
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblLocationVal
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.btnEditLocation
            .font(name: .medium, size: 10)
            .textColor(color: UIColor.themePurple)
        
        self.lblAddress
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.tvAddress
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.btnEditAddress
            .font(name: .medium, size: 10)
            .textColor(color: UIColor.themePurple)
        
        
        self.lblIndication
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.lblConsultingDoctor
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.btnAddNewDoctor
            .font(name: .medium, size: 10)
            .textColor(color: UIColor.themePurple)
        
        self.lblHC
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblStudyID
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack).text = "Study Id"
        self.txtStudyID
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
            .delegate = self
        self.btnEditStudyID
            .font(name: .medium, size: 10)
            .textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.tvAddress.layoutIfNeeded()
            self.imgUser.layoutIfNeeded()
            self.vwProfile.layoutIfNeeded()
            self.vwLocation.layoutIfNeeded()
            self.vwAddress.layoutIfNeeded()
            self.vwIndication.layoutIfNeeded()
            self.vwConsultingDoctor.layoutIfNeeded()
            self.vwHC.layoutIfNeeded()
            self.btnLanguage.layoutIfNeeded()
            self.btnEditLocation.layoutIfNeeded()
            self.btnEditAddress.layoutIfNeeded()
            self.btnAddNewDoctor.layoutIfNeeded()
            
            self.imgUser.cornerRadius(cornerRadius: self.imgUser.frame.height / 2)
            self.btnEditStudyID.layoutIfNeeded()
            self.btnEditStudyID.isSelected = false
            
            self.btnLanguage.cornerRadius(cornerRadius: 3)
            self.btnLanguage.borderColor(color: UIColor.themeLightGray, borderWidth: 1)
            
            self.btnEditLocation.cornerRadius(cornerRadius: 4)
            self.btnEditLocation.borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.btnEditAddress.cornerRadius(cornerRadius: 4)
            self.btnEditAddress.borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.btnAddNewDoctor.cornerRadius(cornerRadius: 4)
            self.btnAddNewDoctor.borderColor(color: UIColor.themePurple, borderWidth: 1)
            self.btnEditStudyID.cornerRadius(cornerRadius: 4)
            self.btnEditStudyID.borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.vwProfile.cornerRadius(cornerRadius: 6)
            self.vwProfile.themeShadow()
            
            self.vwAddress.cornerRadius(cornerRadius: 6)
            self.vwAddress.themeShadow()
            
            self.vwLocation.cornerRadius(cornerRadius: 6)
            self.vwLocation.themeShadow()
            
            self.vwIndication.cornerRadius(cornerRadius: 6)
            self.vwIndication.themeShadow()
            
            self.vwConsultingDoctor.cornerRadius(cornerRadius: 6)
            self.vwConsultingDoctor.themeShadow()
            
            self.vwHC.cornerRadius(cornerRadius: 6)
            self.vwHC.themeShadow()
            self.vwStudyID.cornerRadius(cornerRadius: 6)
            self.vwStudyID.themeShadow()
        }
        
        self.setup(tblView: self.tblIndication)
        self.setup(tblView: self.tblConsultingDoctor)
        //        self.setup(tblView: self.tblHC)
        self.tblHC.delegate = self
    }
    
    func setup(tblView: UITableView) {
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
    }
    
    func applySnapshot(arr: [HealthCoachListModel]? = nil){
        ///Apply snapshot
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteAllItems()
        if let arr = arr {
            snapshot.appendSections([0])
            snapshot.appendItems(arr, toSection: 0)
        }
        self.dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    func manageAddressEdit(withApi: Bool, isAlert: Bool){
        if !self.btnEditAddress.isSelected {
            self.btnEditAddress.isSelected              = true
            self.tvAddress.isEditable                   = true
            
            self.tvAddress.borderColor(color: UIColor.themeLightGray, borderWidth: 1)
            self.tvAddress.becomeFirstResponder()
        }
        else {
            self.btnEditAddress.isSelected              = false
            self.tvAddress.isEditable                   = false
            self.tvAddress.borderColor(color: UIColor.themeLightGray, borderWidth: 0)
            self.tvAddress.resignFirstResponder()
            if self.tvAddress.text.trim() != "" {
                if withApi {
                    GlobalAPI.shared.updateProfileAPI(address: self.tvAddress.text!.trim()) { [weak self] (isDone) in
                        
                        guard let self = self else {return}
                        
                        self.setData()
                    }
                }
            }
            else {
                if isAlert {
                    Alert.shared.showSnackBar(AppError.validation(type: .enterAddress).errorDescription ?? "")
                }
            }
        }
    }
    
    func manageStudyIDEdit(withApi: Bool, isAlert: Bool){
        
        guard (self.txtStudyID.text?.trim().count == 11) else {
            if isAlert {
                Alert.shared.showSnackBar(AppError.validation(type: self.txtStudyID.text?.trim() == "" ? .enterStudyID : .enterValidStudyID ).errorDescription ?? "")
                return
            }
            return
        }
        
        if !self.btnEditStudyID.isSelected {
            self.btnEditStudyID.isSelected              = true
            self.txtStudyID.isUserInteractionEnabled    = true
            
            self.constTxtLeft.constant = 8
            self.vwTxtStudyID.borderColor(color: UIColor.themeLightGray, borderWidth: 1)
            self.txtStudyID.becomeFirstResponder()
        }
        else {
            self.btnEditStudyID.isSelected              = false
            self.txtStudyID.isUserInteractionEnabled                   = false
            self.constTxtLeft.constant = 0
            self.vwTxtStudyID.borderColor(color: UIColor.themeLightGray, borderWidth: 0)
            self.txtStudyID.resignFirstResponder()
            if self.txtStudyID.text?.trim() != "" && self.txtStudyID.text?.trim().count == 11 {
                if withApi {
                    GlobalAPI.shared.updateProfileAPI(studyID: self.txtStudyID.text!.trim()) { [weak self] (isDone) in
                        guard let self = self else {return}
                        //                        self.btnEditStudyID.isSelected = false
                        //                        self.manageStudyIDEdit(withApi: false, isAlert: false)
                        self.setData()
                    }
                }
            }
            else {
                if isAlert {
                    Alert.shared.showSnackBar(AppError.validation(type: self.txtStudyID.text?.trim() == "" ? .enterStudyID : .enterValidStudyID ).errorDescription ?? "")
                }
            }
        }
    }
    
    @objc func updateAPIData(withLoader: Bool){
        self.strErrorMessage = ""
        
        PlanManager.shared.isAllowedByPlan(type: .coach_list,
                                           sub_features_id: "",
                                           completion: { isAllow in
            if isAllow{
                self.applySnapshot()
                self.chatHistoryListVM.apiCallFromStart(list_type: "A",
                                                        refreshControl: self.refreshControl,
                                                        tblView: self.tblHC,
                                                        withLoader: withLoader)
            }
        })
    }
    
    //MARK: ------------------------- Action Method -------------------------
    func manageActionMethods(){
        
        self.btnEditImage.addTapGestureRecognizer {
            self.hero.isEnabled         = true
            self.imgUser.hero.id        = "imgUser"
            self.lblUser.hero.id        = "lblUser"
            self.lblEmail.hero.id       = "lblEmail"
            self.lblYearGender.hero.id  = "lblYearGender"
            let vc = EditProfileVC.instantiate(fromAppStoryboard: .setting)
            self.navigationController?.hero.isEnabled = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            var params                                  = [String : Any]()
            params[AnalyticsParameters.cards.rawValue]   = ProfileCard.Profile.rawValue
            FIRAnalytics.FIRLogEvent(eventName: .PROFILE_NAVIGATION,
                                     screen: .MyProfile,
                                     parameter: params)
        }
        
        self.btnEditLocation.addTapGestureRecognizer {
            let vc = SetLocationVC.instantiate(fromAppStoryboard: .auth)
            vc.isEdit = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            var params                                  = [String : Any]()
            params[AnalyticsParameters.cards.rawValue]   = ProfileCard.Location.rawValue
            FIRAnalytics.FIRLogEvent(eventName: .PROFILE_NAVIGATION,
                                     screen: .MyProfile,
                                     parameter: params)
        }
        
        self.btnLanguage.addTapGestureRecognizer {
            let vc = LanguageListVC.instantiate(fromAppStoryboard: .auth)
            vc.isEdit = true
            vc.arrDaysOffline = [self.selectedLanguageListModel]
            vc.completionHandler = { obj in
                //Do your task here
                self.selectedLanguageListModel  = obj
                UserDefaultsConfig.languageId   = self.selectedLanguageListModel.languagesId
                self.btnLanguage.setTitle(self.selectedLanguageListModel.languageName, for: .normal)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnEditAddress.isSelected = true
        self.manageAddressEdit(withApi: false, isAlert: false)
        self.btnEditAddress.addTapGestureRecognizer {
            self.manageAddressEdit(withApi: true, isAlert: true)
            
            var params                                  = [String : Any]()
            params[AnalyticsParameters.cards.rawValue]  = ProfileCard.Address.rawValue
            FIRAnalytics.FIRLogEvent(eventName: .PROFILE_NAVIGATION,
                                     screen: .MyProfile,
                                     parameter: params)
        }
        
        self.btnAddNewDoctor.addTapGestureRecognizer {
        }
        
        self.btnEditStudyID.isSelected = true
        self.manageStudyIDEdit(withApi: false, isAlert: false)
        self.btnEditStudyID.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.manageStudyIDEdit(withApi: true, isAlert: true)
        }
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        
        WebengageManager.shared.navigateScreenEvent(screen: .MyProfile)
        
        FIRAnalytics.FIRLogEvent(eventName: .USER_PROFILE_VIEW,
                                 screen: .MyProfile,
                                 parameter: nil)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.updateAPIData(withLoader: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    @IBAction func onGoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK: ----------------- UITableView DataSource and Delegate Methods -----------------
extension ProfileVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblIndication:
            return UserModel.shared.medicalConditionName.count
            
        case self.tblConsultingDoctor:
            if let doc = UserModel.shared.patientLinkDoctorDetails, doc.count > 0 {
                return doc.count
            }
            return 0//self.arrConsultingDoctor.count
            
        case self.tblHC:
            return self.chatHistoryListVM.getCount()
            
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.tblIndication:
            
            let cell : ProfileIndicationCell = tableView.dequeueReusableCell(withClass: ProfileIndicationCell.self, for: indexPath)
            
            //let object              = self.arrIndication[indexPath.row]
            let object              = UserModel.shared.medicalConditionName[indexPath.row]
            //cell.imgView.image      = UIImage(named: object["img"].stringValue)
            cell.imgView.isHidden   = true
            cell.lblTitle.text      = object.medicalConditionName
            
            return cell
            
        case self.tblConsultingDoctor:
            let cell : ProfileConsultingDocCell = tableView.dequeueReusableCell(withClass: ProfileConsultingDocCell.self, for: indexPath)
            
            if let doc = UserModel.shared.patientLinkDoctorDetails, doc.count > 0 {
                let object              = doc[indexPath.row]
                cell.imgView.setCustomImage(with: object.profileImage, placeholder: UIImage(named: "defaultUser"), andLoader: true, completed: nil)
                cell.lblTitle.text      = object.name!
                cell.lblPhone.text      = object.countryCode! + " " + object.contactNo!
                
                cell.stackEmail.isHidden = true
                if object.email!.trim() != "" {
                    cell.stackEmail.isHidden    = false
                    cell.lblEmail.text          = object.email!
                }
                
                //cell.lblDesc.text       = object.specialization! + " | " + object.qualification!
                var address = ""
                if object.city!.trim() != "" {
                    address    = object.city!
                }
                if object.state!.trim() != "" {
                    address    = address + " " + object.state!
                }
                if object.country!.trim() != "" {
                    address    = address + " " + object.country!
                }
                
                let arr = address.components(separatedBy: " ")
                address = ""
                for item in arr {
                    if address.trim() == "" {
                        address += item
                    }
                    else {
                        address += ", " + item
                    }
                }
                
                cell.lblAddress.text    = address
                cell.lblGender.isHidden = true
                if object.gender.trim() != "" {
                    cell.lblGender.isHidden     = false
                    cell.lblGender.text         = object.gender == "M" ? AppMessages.male : AppMessages.female
                }
                
            }
            
            //            let object              = self.arrConsultingDoctor[indexPath.row]
            //            cell.imgView.image      = UIImage(named: object["img"].stringValue)
            //            cell.lblTitle.text      = object["title"].stringValue
            //            cell.lblDesc.text       = object["desc"].stringValue
            //            cell.lblAddress.text    = object["address"].stringValue
            
            return cell
            
        case self.tblHC:
            let cell : ChatHistoryListCell = tableView.dequeueReusableCell(withClass: ChatHistoryListCell.self, for: indexPath)
            
            let object = self.chatHistoryListVM.getObject(index: indexPath.row)
            cell.imgView.setCustomImage(with: object.profilePic)
            cell.lblTitle.text      = object.firstName + " " + object.lastName
            cell.lblDesc.text       = object.role
            cell.lblDesc2.text      = ""
            cell.lblTime.text       = ""
            
            cell.imgView.addTapGestureRecognizer {
                GlobalAPI.shared.getHealthCoachDetailsAPI(health_coach_id: object.healthCoachId) { [weak self]  isDone, obj in
                    
                    guard let self = self else {return}
                    
                    if isDone {
                        
                        let vc1 = HealthCoachDetailsVC.instantiate(fromAppStoryboard: .setting)
                        vc1.object = obj
                        vc1.modalPresentationStyle = .overCurrentContext
                        vc1.modalTransitionStyle = .crossDissolve
                        vc1.hidesBottomBarWhenPushed = true
                        let nav = UINavigationController(rootViewController: vc1)
                        self.present(nav, animated: true, completion: nil)
                        
                    }
                }
                
            }
            
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tblIndication:
            break
            
        case self.tblConsultingDoctor:
            //            let vc = DoctorProfileVC.instantiate(fromAppStoryboard: .setting)
            //            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case self.tblHC:
            
            //            let object = self.chatHistoryListVM.getObject(index: indexPath.row)
            //            PlanManager.shared.isAllowedByPlan(type: .chat_healthcoach,
            //                                               sub_features_id: "",
            //                                               completion: { isAllow in
            //                if isAllow{
            //                    FreshDeskManager.shared.health_coach_id = object.healthCoachId
            //                    FreshDeskManager.shared.showConversations(tags: [object.tagName],
            //                                                              screen: .MyProfile)
            //                }
            //                else {
            //                    PlanManager.shared.alertNoSubscription()
            //                }
            //            })
            break
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
        //                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension ProfileVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Dynamic TableView Height Methods --------------------------
extension ProfileVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.tblIndication, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblIndicationHeight.constant = newvalue.height
        }
        
        if let obj = object as? UITableView, obj == self.tblConsultingDoctor, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblConsultingDoctorHeight.constant = newvalue.height
        }
        
        if let obj = object as? UITableView, obj == self.tblHC, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblHCHeight.constant = newvalue.height
        }
        
    }
    
    func addObserverOnHeightTbl() {
        self.tblIndication.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblConsultingDoctor.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblHC.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblIndication else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView2 = self.tblConsultingDoctor else {return}
        if let _ = tblView2.observationInfo {
            tblView2.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView3 = self.tblHC else {return}
        if let _ = tblView3.observationInfo {
            tblView3.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------------- Set data --------------------------
extension ProfileVC {
    
    func setData(){
        let object = UserModel.shared
        
        self.btnLanguage.isHidden = true
        Settings().isHidden(setting: .language_page) { isHidden in
            if isHidden {
                self.btnLanguage.isHidden = true
            }
            else {
                self.btnLanguage.isHidden = false
                self.btnLanguage.setTitle(object.languageName, for: .normal)
                self.selectedLanguageListModel.languagesId = object.languagesId
            }
        }
        
        self.imgUser.setCustomImage(with: object.profilePic ?? "",
                                    placeholder: UIImage(named: "defaultUser")) { img, err, cache, url in
            if img != nil {
                self.imgUser.tapToZoom(with: img)
            }
        }
        
        self.lblUser.text               = object.name//"Rakesh Kappor"
        self.lblYearGender.text         = "\(object.patientAge ?? 0)" + " " + AppMessages.years + ", " + UserModel.patientGender //"52 Years, Male"
        self.lblMobile.text             = object.countryCode + " " + object.contactNo//"+91 9876543210"
        self.lblEmail.text              = object.email//"rakesh.kapoor@gmail.com"
        self.tvAddress.text             = object.address//"B-607 Fairdeal House, Swastik Char Rasta, Navrangpura Apt, Ahmedabad, Gujarat, 399802"
        
        self.lblLocationVal.text = UserModel.shared.city + ", " + UserModel.shared.state
        
        self.txtStudyID.text = object.studyID
        self.txtStudyID.isUserInteractionEnabled = false
        
        self.vwConsultingDoctor.isHidden = true
        if let doc = UserModel.shared.patientLinkDoctorDetails, doc.count > 0 {
            self.vwConsultingDoctor.isHidden = false
            self.tblConsultingDoctor.reloadData()
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension ProfileVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.chatHistoryListVM.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                //self.strErrorMessage = self.viewModel.strErrorMessage
                
                self.applySnapshot(arr: self.chatHistoryListVM.arrList)
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                break
            case .none: break
            }
        })
    }
}

//------------------------------------------------------
//MARK: - UITextFieldDelegate
extension ProfileVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isBackspace() {
            switch textField.text?.count {
            case 5,9:
                var str = self.txtStudyID.text ?? ""
                str = String(str.dropLast())
                str = String(str.dropLast())
                self.txtStudyID.text = str
                return false
            default :
                return true
            }
        }
        
        guard string.isValid(.alphabet) || string.isValid(.number) else {
            return false
        }
        
        switch textField.text?.count{
        case 3,7:
            self.txtStudyID.text = self.txtStudyID.text! + "-" + string
            return false
        default:
            return self.txtStudyID.text!.count < 11
        }
    }
    
}
