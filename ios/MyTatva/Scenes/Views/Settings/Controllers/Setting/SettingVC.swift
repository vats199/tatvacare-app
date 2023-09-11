//
//  PaymentMethodVC.swift
//

import UIKit

class SettingCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var vwSep            : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
//            self.vwBg.cornerRadius(cornerRadius: 15)
//            self.vwBg.applyViewShadow(shadowOffset: CGSize.zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.2, shdowRadious: 5)
        }
    }
}

class SettingVC: WhiteNavigationBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------

    //Top
    @IBOutlet weak var vwAccount                : UIView!
    @IBOutlet weak var lblAccount               : UILabel!

    @IBOutlet weak var tblAccount               : UITableView!
    @IBOutlet weak var tblAccountHeight         : NSLayoutConstraint!
    
    @IBOutlet weak var vwNotification           : UIView!
    @IBOutlet weak var lblNotificationTitle     : UILabel!
    @IBOutlet weak var lblNotificationSubTitle  : UILabel!
    @IBOutlet weak var btnNotification          : UIButton!
    
    @IBOutlet weak var vwMore                   : UIView!
    @IBOutlet weak var lblMore                  : UILabel!
    
    @IBOutlet weak var tblMore                  : UITableView!
    @IBOutlet weak var tblMoreHeight            : NSLayoutConstraint!
    
    //Deals
    
    //MARK:- Class Variable
    
    var arrAccount : [JSON] = [
        [
            "image" : "pencil",
            "title" : "Edit Profile",
            "is_select" : 0
        ],
        [
            "image" : "lock",
            "title" : "Change Password",
            "is_select" : 0
        ]
    ]
    
    var arrMore : [JSON] = [
//        [
//            "image" : "shareApp",
//            "title" : "Share App",
//            "is_select" : 0
//        ],
//        [
//            "image" : "rateApp",
//            "title" : "Rate the app",
//            "is_select" : 0
//        ],
        [
            "image" : "helpFAQ",
            "title" : "Help & FAQ",
            "is_select" : 0
        ],
        [
            "image" : "terms",
            "title" : "Terms & Privacy Policy",
            "is_select" : 0
        ],
        [
            "image" : "terms",
            "title" : "About Us",
            "is_select" : 0
        ],
        [
            "image" : "contact_us",
            "title" : "Contact Us",
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
        
//        if UserModel.shared.signupType != "Normal" {
//            self.arrAccount = [
//                [
//                    "image" : "pencil",
//                    "title" : "Edit Profile",
//                    "is_select" : 0
//                ]
//            ]
//            self.tblAccount.reloadData()
//        }
        
        self.setData()
        GlobalAPI.shared.getPatientDetailsAPI { [weak self] isDone in
            guard let self = self else {return}
            if isDone {
                self.setData()
            }
        }
    }
    
    func configureUI(){
        
        self.lblAccount.font(name: .semibold, size: 20)
            .textColor(color: UIColor.themeBlack)
        
        self.lblNotificationTitle.font(name: .semibold, size: 20)
            .textColor(color: UIColor.themeBlack)
        self.lblNotificationSubTitle.font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        self.lblMore.font(name: .semibold, size: 20)
            .textColor(color: UIColor.themeBlack)
        
        self.setup(tableView: self.tblAccount)
        self.setup(tableView: self.tblMore)
        
        self.btnNotification.addTapGestureRecognizer {
            if self.btnNotification.isSelected {
                GlobalAPI.shared.editNotificationSettingAPI(isAllow: false) {  [weak self] (isDone) in
                    
                    guard let self = self else {return}
                    
                    if isDone {
                        self.btnNotification.isSelected = false
                    }
                }
            }
            else {
                GlobalAPI.shared.editNotificationSettingAPI(isAllow: true) { [weak self]  (isDone) in
                    guard let self = self else {return}
                    
                    if isDone {
                        self.btnNotification.isSelected = true
                    }
                }
            }
        }
    }
    
    func setup(tableView: UITableView){
        tableView.layoutIfNeeded()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    //MARK: ------------------------- Action Method -------------------------
    
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
}

//MARK: -------------------------- Set data --------------------------
extension SettingVC {
    
    func setData(){
        let data = UserModel.shared
//        self.btnNotification.isSelected = data.allowPushNotification == 1 ? true : false
    }
}

//MARK: -------------------------- TableView methods --------------------------
extension SettingVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case self.tblAccount:
            return self.arrAccount.count
      
        case self.tblMore:
            return self.arrMore.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.tblAccount:
            let cell : SettingCell = tableView.dequeueReusableCell(withClass: SettingCell.self, for: indexPath)
            let obj = self.arrAccount[indexPath.row]
            
            cell.imgView.image          = UIImage(named: obj["image"].stringValue)!
            cell.lblTitle.text          = obj["title"].stringValue
        
            cell.vwSep.isHidden = false
            if indexPath.row == self.arrAccount.count - 1 {
                cell.vwSep.isHidden = true
            }
            
            return cell
            
        case self.tblMore:
            let cell : SettingCell = tableView.dequeueReusableCell(withClass: SettingCell.self, for: indexPath)
            let obj = self.arrMore[indexPath.row]
            
            cell.imgView.image          = UIImage(named: obj["image"].stringValue)!
            cell.lblTitle.text          = obj["title"].stringValue
        
            cell.vwSep.isHidden = false
            if indexPath.row == self.arrMore.count - 1 {
                cell.vwSep.isHidden = true
            }
            
            return cell
            
        default:
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tblAccount:
            
            let value = self.arrAccount[indexPath.row]["title"].stringValue.lowercased()
            switch value {
            case let str where str.contains("Profile".lowercased()):
                print(value)
                let vc = EditProfileVC.instantiate(fromAppStoryboard: .setting)
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case let str where str.contains("Change Password".lowercased()):
                let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .setting)
                self.navigationController?.pushViewController(vc, animated: true)
                print(value)
                break
                
            default:
                break
            }
                
                break
            case self.tblMore:
                
                let value = self.arrMore[indexPath.row]["title"].stringValue.lowercased()
                switch value {
                case let str where str.contains("Share".lowercased()):
                    print(value)
                    break
                    
                case let str where str.contains("Rate".lowercased()):
                    print(value)
                    break
                    
                case let str where str.contains("Help".lowercased()):
                    print(value)
                    let vc = WebviewVC.instantiate(fromAppStoryboard: .setting)
                    vc.webType = .helpFaq
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                    
                case let str where str.contains("Terms".lowercased()):
                    print(value)
                    let vc = WebviewVC.instantiate(fromAppStoryboard: .setting)
                    vc.webType = .Terms
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                    
                case let str where str.contains("About".lowercased()):
                    print(value)
                    let vc = WebviewVC.instantiate(fromAppStoryboard: .setting)
                    vc.webType = .AboutUs
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    break
                    
                case let str where str.contains("Contact".lowercased()):
                    print(value)
                    let vc = ContactUsVC.instantiate(fromAppStoryboard: .setting)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    break
                    
                default:
                    break
                }
                
                break
            default:
                break
            }
    }
    
}

extension SettingVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblAccount, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblAccountHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.tblMore, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblMoreHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblAccount.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblMore.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblAccount else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView2 = self.tblMore else {return}
        if let _ = tblView2.observationInfo {
            tblView2.removeObserver(self, forKeyPath: "contentSize")
        }
        
    }
}
