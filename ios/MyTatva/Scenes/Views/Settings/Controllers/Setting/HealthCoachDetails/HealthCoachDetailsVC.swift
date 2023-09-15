
import UIKit

class HealthCoachDetailsVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var lblExp           : UILabel!
    
    @IBOutlet weak var lblAddress       : UILabel!
    @IBOutlet weak var lblAddressValue  : UILabel!
    
    @IBOutlet weak var lblPhone         : UILabel!
        
    @IBOutlet weak var lblLanguage      : UILabel!
    @IBOutlet weak var lblLanguageValue : UILabel!
    
    @IBOutlet weak var lblLink          : UILabel!
    
    @IBOutlet weak var btnClose         : UIButton!
    
    //MARK:- Class Variable
    let viewModel                       = ChatHistoryListVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    var object                          = HealthCoachDetailsModel()
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    var arrDoseOffline : [DoseListModel] = []
    var arrData : [JSON] = [
        [
            "name" : "It’s spam",
            "isSelected": 0,
            "type": "S"
        ],
        [
            "name" : "It‘s inappropriate",
            "isSelected": 0,
            "type": "I"
        ],
        [
            "name" : "It’s false information",
            "isSelected": 0,
            "type": "F"
        ]
    ]
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {
        
        self.lblTitle.font(name: .bold, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblExp.font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        
        self.lblAddress.font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblAddressValue.font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        
        self.lblPhone.font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblLanguage.font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblLanguageValue.font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        
        self.lblLink.font(name: .regular, size: 15)
            .textColor(color: UIColor.themePurple)
        
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
    }
    
    fileprivate func configureUI(){
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 20)
            
            
            self.imgView.layoutIfNeeded()
            self.imgView.cornerRadius(cornerRadius: 10)
           
        }
    }
    
    @objc func updateAPIData(){
//        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
//                                        tblView: self.tblView,
//                                        withLoader: true)
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : JSON? = nil) {
        
        func sendData() {
            if let obj = objAtIndex {
                if let completionHandler = completionHandler {
                    completionHandler(obj)
                }
            }
        }
        
        self.dismiss(animated: animated) {
            sendData()
        }
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnClose.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
    }
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //WebengageManager.shared.navigateScreenEvent(screen: .ReportComment)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.setData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: ------------------ UITableView Methods ------------------
extension HealthCoachDetailsVC {
    
    fileprivate func setData(){
        if self.object.healthCoachId != nil {
            self.imgView.setCustomImage(with: self.object.profilePic)
            self.lblTitle.text          = self.object.firstName + " " + self.object.lastName
            self.lblDesc.text           = self.object.role
            self.lblExp.text            = "\(self.object.yearsOfExperience!)" + " yrs of experience"
            self.lblAddress.text        = self.object.city
            self.lblAddressValue.text   = self.object.state
            self.lblPhone.text          = self.object.contactNo
            self.lblLanguageValue.text  = self.object.languageSpoken
            
        }
        
    }
}

