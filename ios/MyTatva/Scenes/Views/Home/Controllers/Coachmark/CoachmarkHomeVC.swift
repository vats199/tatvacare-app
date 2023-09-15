
import UIKit


class CoachmarkHomeVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg                : UIImageView!
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var btnStart             : UIButton!
    @IBOutlet weak var btnSkip              : UIButton!
    @IBOutlet weak var btnCancelTop         : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var completionHandler: ((_ obj : JSON?) -> Void)?
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UserDefaults.standard.setValue(false, forKey: UserDefaults.Keys.isShowCoachmark)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //-----------------------------------------------------
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
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
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        self.applyStyle()
        self.openPopUp()
        self.manageActionMethods()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.vwBg.themeShadow()
          
            self.btnStart.layoutIfNeeded()
            self.btnStart.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnStart.transform = CGAffineTransform(translationX: 30, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn]) {
                self.btnStart.transform = .identity
            }
        }
        
        self.lblTitle.text = CoachmarkListModel.shared.description(page: .welcome)
        
        
    }
    
    private func applyStyle() {
        self.lblTitle
            .font(name: .semibold, size: 20).textColor(color: .themeBlack)
        
        self.btnStart
            .font(name: .bold, size: 16).textColor(color: .white)
        self.btnSkip
            .font(name: .regular, size: 16).textColor(color: .themePurple)
        
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        
        self.imgBg.addTapGestureRecognizer {
            //self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnCancelTop.addTapGestureRecognizer {
            [weak self] in
            guard let self = self else {return}
            //self.dismissPopUp(true, objAtIndex: nil)
            self.dismiss(animated: true) {
                Alert.shared.showAlert(message: AppMessages.skipCoachmarkMessage) { [weak self] isDone in
                    guard let _ = self else {return}
                    
                }
            }
        }
        
        self.btnStart.addTapGestureRecognizer {
            [weak self] in
            guard let self = self else {return}
            var obj         = JSON()
            obj["isDone"]   = "Yes"
            self.dismissPopUp(true, objAtIndex: obj)
        }
        
        self.btnSkip.addTapGestureRecognizer { [weak self] in
            guard let self = self else {return}
            //let obj         = JSON()
            
            //self.dismissPopUp(true, objAtIndex: nil)
            self.dismiss(animated: true) {
                Alert.shared.showAlert(message: AppMessages.skipCoachmarkMessage) { [weak self] isDone in
                    guard let _ = self else {return}
                    
                }
            }
        }
    }
}
