//
//  CartVC.swift
//

//

import UIKit

class TestOrderSuccessVC: ClearNavigationFontBlackBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var lblSuccess               : UILabel!
    @IBOutlet weak var lblSuccessVal            : UILabel!
    @IBOutlet weak var vwSuccess                : UIView!
    
    @IBOutlet weak var lblName                  : UILabel!
    @IBOutlet weak var lblPrice                 : UILabel!
    @IBOutlet weak var lblOrderPlaced           : UILabel!
    @IBOutlet weak var lblItemName              : UILabel!
    @IBOutlet weak var lblDate                  : UILabel!
    @IBOutlet weak var lblTime                  : UILabel!
    @IBOutlet weak var btnTrackOrder            : UIButton!
    @IBOutlet weak var btnHome                  : UIButton!
    
    
    //MARK: ------------------------- Class Variable -------------------------
    var finalPayableAmount          = 0
    var cartListModel               = CartListModel()
    var labPatientListModel         = LabPatientListModel()
    var labAddressListModel         = LabAddressListModel()
    var selectedTimeSlot            = ""
    var selectedDate                = Date()
    var order_master_id             = ""
    
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
        self.setData()
    }
    
    func configureUI(){
        
        
        self.lblSuccess
            .font(name: .semibold, size: 22)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblSuccessVal
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        
        self.lblName
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblPrice
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblOrderPlaced
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblItemName
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblDate
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblTime
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
       
        self.btnTrackOrder
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.btnHome
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.white.withAlphaComponent(1))
        
        DispatchQueue.main.async {
            self.btnTrackOrder.layoutIfNeeded()
            self.btnHome.layoutIfNeeded()
            
            self.btnHome.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnTrackOrder.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.vwSuccess.layoutIfNeeded()
            self.vwSuccess.cornerRadius(cornerRadius: 10)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
        }
    }
    
    //MARK: ------------------------- Action Method -------------------------
    func manageActionMethods(){
        
        self.btnHome.addTapGestureRecognizer {
            UIApplication.shared.setHome()
        }
        
        self.btnTrackOrder.addTapGestureRecognizer {
            let vc = TestOrderDetailParentVC.instantiate(fromAppStoryboard: .carePlan)
            vc.order_master_id = self.order_master_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        
        WebengageManager.shared.navigateScreenEvent(screen: .BookLabtestAppointmentSuccess)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}



//MARK: -------------------------- Set data --------------------------
extension TestOrderSuccessVC {
    
    func setData(){
        self.lblName.text = UserModel.shared.name
        if self.labPatientListModel.name != nil {
            self.lblName.text       = self.labPatientListModel.name
        }
        
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = DateTimeFormaterEnum.ddmm_yyyy.rawValue
        self.lblDate.text               = formatter.string(from: self.selectedDate)
        self.lblTime.text               = self.selectedTimeSlot
        
        if self.cartListModel.lab != nil {
            //self.imgLab.setCustomImage(with: self.cartListModel.lab.image)
//            self.lblLabName.text        = self.cartListModel.lab.name
//            self.lblLabAddress.text     = self.cartListModel.lab.address
            
            self.lblPrice.text          = self.finalPayableAmount == 0 ? KFree : CurrencySymbol.INR.rawValue + "\(self.finalPayableAmount)"
            
            var arr = [String]()
            for item in self.cartListModel.testsList {
                arr.append(item.name)
            }
            self.lblItemName.text = arr.joined(separator: ", ")
        }
        
//        if self.labAddressListModel.name != nil {
//            self.lblPickupAddressName.text  = self.labAddressListModel.addressType
//            self.lblPickupAddressVal.text   = """
//\(self.labAddressListModel.name ?? "")
//\(self.labAddressListModel.address ?? "")
//\(self.labAddressListModel.street ?? "")
//\(self.labAddressListModel.pincode!)
//\(self.labAddressListModel.contactNo!)
//"""
//        }
    }
    
}
