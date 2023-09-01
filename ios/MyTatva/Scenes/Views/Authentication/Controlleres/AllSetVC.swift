//

//

import UIKit

class AllSetVC: ClearNavigationFontBlackBaseVC {
    
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    
    @IBOutlet weak var btnCreateProfile : UIButton!
    @IBOutlet weak var btnGoToHome      : UIButton!
    
    //MARK:- Class Variable
    var readingType: ReadingType        = .HeartRate
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
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
        
        
        self.lblTitle.font(name: .bold, size: 30)
            .textColor(color: UIColor.themeBlack)
        
        self.lblDesc.font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.btnCreateProfile.font(name: .medium, size: 16)
            .textColor(color: UIColor.white)
        
        self.btnGoToHome.font(name: .medium, size: 16)
            .textColor(color: UIColor.themePurple)
            
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.btnCreateProfile.layoutIfNeeded()
            self.btnGoToHome.layoutIfNeeded()
            
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.btnCreateProfile
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnGoToHome
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.white)
        }
        
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
    }
    
    fileprivate func configureUI(){
        
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
            UIApplication.shared.manageLogin()
        }
        
        self.btnCreateProfile.addTapGestureRecognizer { [weak self] in
            guard let self = self else {return}
            
            FIRAnalytics.FIRLogEvent(eventName: .USER_CONTINUE_PROFILE,
                                     screen: .RegisterSuccess,
                                     parameter: nil)
            
            var obj         = JSON()
            obj["isDone"]   = "Yes"
            self.dismissPopUp(true, objAtIndex: obj)
        }
        
        self.btnGoToHome.addTapGestureRecognizer {
            
            FIRAnalytics.FIRLogEvent(eventName: .USER_SKIP_PROFILE,
                                     screen: .RegisterSuccess,
                                     parameter: nil)
            
            //let obj         = JSON()
            self.dismissPopUp(true, objAtIndex: nil)
            UIApplication.shared.manageLogin()
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .RegisterSuccess)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
