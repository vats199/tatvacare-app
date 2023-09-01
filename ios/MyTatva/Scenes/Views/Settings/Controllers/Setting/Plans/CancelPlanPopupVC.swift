
import UIKit

class CancelPlanPopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var btnClose         : UIButton!
    @IBOutlet weak var btnYes           : UIButton!
    @IBOutlet weak var btnNo            : UIButton!
    
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
        
        self.lblTitle
            .font(name: .medium, size: 20)
            .textColor(color: UIColor.themeBlack)
        
        self.btnYes
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
            .backGroundColor(color: UIColor.themePurple)
        self.btnNo
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themePurple)
        
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
    }
    
    fileprivate func configureUI(){
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
        
            self.btnYes.layoutIfNeeded()
            self.btnYes.cornerRadius(cornerRadius: 5)
        }
    }
    
    @objc func updateAPIData(){
    }
    
    fileprivate func openPopUp() {
        self.imgBg.alpha = 0
        self.vwBg.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 5, delay: 0, options: [.curveEaseIn]) {
            self.imgBg.alpha = kPopupAlpha
            self.vwBg.transform = .identity
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
        
        self.btnNo.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnYes.addTapGestureRecognizer {
            var obj = JSON()
            obj["isDone"] = true
            self.dismissPopUp(true, objAtIndex: obj)
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
extension CancelPlanPopupVC {
    
    fileprivate func setData(){
    }
}

