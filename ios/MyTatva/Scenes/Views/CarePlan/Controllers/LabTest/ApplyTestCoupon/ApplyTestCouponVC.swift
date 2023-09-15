import UIKit

class ApplyTestCouponVC: ClearNavigationFontBlackBaseVC {
    
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var txtCode          : UITextField!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancel        : UIButton!
    
    
    //MARK:- Class Variable
    let viewModel                       = ApplyTestCouponVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    var arrDoseOffline : [DoseListModel] = []
    var arrDays : [JSON] = [
        [
            "name" : "1 time a day",
            "short" : "Sun",
            "isSelected": 0,
        ],[
            "name" : "2 time a day",
            "short" : "Mon",
            "isSelected": 0,
        ],
        [
            "name" : "3 time a day",
            "short" : "Tue",
            "isSelected": 0,
        ],
        [
            "name" : "4 time a day",
            "short" : "Wed",
            "isSelected": 0,
        ],
        [
            "name" : "5 time a day",
            "short" : "Thu",
            "isSelected": 0,
        ],
        [
            "name" : "6 time a day",
            "short" : "Fri",
            "isSelected": 0,
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
        self.setupViewModelObserver()
        
        self.lblTitle.font(name: .semibold, size: 22)
            .textColor(color: UIColor.themeBlack)
        
        self.btnCancel.font(name: .medium, size: 18)
            .textColor(color: UIColor.themePurple)
        
        
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
    }
    
    fileprivate func configureUI(){
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 20)
        }
    }
    
    @objc func updateAPIData(){
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
        
        self.btnSubmit.addTapGestureRecognizer {
//            var arrTemp     = [JSON]()
//            for i in 0...self.arrDays.count - 1 {
//                let obj  = self.arrDays[i]
//
//                if obj["isSelected"].intValue == 1 {
//                    arrTemp.append(obj)
//                }
//            }
            self.viewModel.apiCall(vc: self, code: self.txtCode)
        }
        
        self.btnCancel.addTapGestureRecognizer {
            //let obj         = [JSON]()
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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: -------------------- setupViewModel Observer --------------------
extension ApplyTestCouponVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
//                self.strErrorMessage = self.viewModel.strErrorMessage
//                self.setData()
                
                var obj = JSON()
                obj["isDone"] = true
                self.dismissPopUp(true, objAtIndex: obj)
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
