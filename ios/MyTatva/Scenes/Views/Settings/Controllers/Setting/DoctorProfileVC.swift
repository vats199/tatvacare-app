//
//  CartVC.swift
//

//

import UIKit


class DoctorProfileVC: ClearNavigationFontBlackBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------

    //Top
    @IBOutlet weak var vwProfile                    : UIView!
    @IBOutlet weak var imgUser                      : UIImageView!
    
    
    @IBOutlet weak var vwDetails                    : UIView!
    
    @IBOutlet weak var lblUser                      : UILabel!
    @IBOutlet weak var lblUserDesc                  : UILabel!
    @IBOutlet weak var lblUserExp                   : UILabel!
    
    @IBOutlet weak var lblMobile                    : UILabel!
    @IBOutlet weak var lblMobileValue               : UILabel!
    
    @IBOutlet weak var lblLanguage                  : UILabel!
    @IBOutlet weak var lblLanguageValue             : UILabel!
    
    @IBOutlet weak var lblAddress                   : UILabel!
    @IBOutlet weak var lblAddressValue1             : UILabel!
    @IBOutlet weak var lblAddressValue2             : UILabel!
    
    @IBOutlet weak var btnBookAppointment          : UIButton!
    
    //MARK:- Class Variable
    
    //MARK: ------------------------- Memory Management Method -------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    func setUpView() {
        
        self.configureUI()
        self.manageActionMethods()
        self.configureUI()
        self.setData()
        
        
        
//        UserModel.shared.getUserDetailAPI { (isDone) in
//            if isDone {
//                self.setData()
//            }
//        }
    }
    
    func configureUI(){
        
        self.lblUser
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblUserDesc
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblUserExp
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblMobile
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblMobileValue
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblLanguage
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblLanguageValue
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblAddress
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblAddressValue1
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themePurple)
        self.lblAddressValue2
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
      
        DispatchQueue.main.async {
            
            self.imgUser.layoutIfNeeded()
            self.vwProfile.layoutIfNeeded()
            self.vwDetails.layoutIfNeeded()
            self.imgUser.cornerRadius(cornerRadius: self.imgUser.frame.height / 2)
            
            self.vwDetails.cornerRadius(cornerRadius: 10)
            self.vwDetails.themeShadow()
        }
        
    }
    
    //MARK: ------------------------- Action Method -------------------------
    func manageActionMethods(){
        
        self.btnBookAppointment.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        
        WebengageManager.shared.navigateScreenEvent(screen: .DoctorProfile)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
}

//MARK: -------------------------- Set data --------------------------
extension DoctorProfileVC {
    
    func setData(){
        //let object = UserModel.shared
//
//        self.imgUser.image              = UIImage(named: "user1")
//        self.lblUser.text               = "Rakesh Kappor"
//        self.lblYearGender.text         = "52 Years, Male"
//        self.lblMobile.text             = "+91 9876543210"
//        self.lblEmail.text              = "rakesh.kapoor@gmail.com"
//        self.tvAddress.text             = "B-607 Fairdeal House, Swastik Char Rasta, Navrangpura Apt, Ahmedabad, Gujarat, 399802"
    }
    
}
