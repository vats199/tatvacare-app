
import UIKit


class CoachmarkHome4VC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg                : UIImageView!
    @IBOutlet weak var vwBgParent           : UIView!
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var btnStart             : UIButton!
    @IBOutlet weak var btnSkip              : UIButton!
    @IBOutlet weak var btnCancelTop         : UIButton!
    
    //------------------------------------------------------
    var targetView          = UIView()
    var targetTabbar        = UITabBar()
    let showcase            = MaterialShowcase()
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
        CoachmarkListModel.shared.initShowcase(showcase: self.showcase)
        
        self.lblTitle.text = CoachmarkListModel.shared.description(page: .home_careplan)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.vwBg.themeShadow()
            self.imgBg.layoutIfNeeded()
            
            self.btnStart.layoutIfNeeded()
            self.btnStart.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnStart.transform = CGAffineTransform(translationX: 30, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn]) {
                self.btnStart.transform = .identity
            }
            
            Settings().isHidden(setting: .hide_engage_page) { isHidden in
                if isHidden {
                    self.showcase.setTargetView(tabBar: self.targetTabbar, itemIndex: 3, tapThrough: false)
                }
                else {
                    self.showcase.setTargetView(tabBar: self.targetTabbar, itemIndex: 3, tapThrough: false)
                }
            }
            
            self.showcase.primaryText = ""
            self.showcase.secondaryText = ""
            self.showcase.isUserInteractionEnabled = false
            self.showcase.show(completion: {
              // You can save showcase state here
              // Later you can check and do not show it again
            })
            self.imgBg.addSubview(self.showcase)
            
//            let getY = self.vwBgParent.frame.origin.y - (self.targetTabbar.frame.origin.y + self.targetTabbar.frame.height)
//            self.vwBgParent.transform = CGAffineTransform(translationX: 0, y: getY)
            
            let color = GFunction.shared.applyGradientColor(startColor: UIColor.themeBlack.withAlphaComponent(0),
                                                            endColor: UIColor.themeBlack.withAlphaComponent(0.7),
                                                            locations: [0, 0.1],
                                                            startPoint: CGPoint(x: 0, y: self.imgBg.frame.maxY - self.targetTabbar.frame.height),
                                                            endPoint: CGPoint(x: 0, y: 0),
                                                            gradiantWidth: self.imgBg.frame.width,
                                                            gradiantHeight: self.imgBg.frame.height)
            
            self.imgBg.backgroundColor = color
        }
    }
    
    private func applyStyle() {
        self.lblTitle
            .font(name: .medium, size: 20).textColor(color: .themeBlack)
        
        self.btnStart
            .font(name: .bold, size: 16).textColor(color: .white)
        self.btnSkip
            .font(name: .regular, size: 16).textColor(color: .themePurple)
        
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        
        self.imgBg.addTapGestureRecognizer { [weak self] in
            guard let _ = self else {return}
            //self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnCancelTop.addTapGestureRecognizer { [weak self] in
            guard let self = self else {return}
            //self.dismissPopUp(true, objAtIndex: nil)
            self.dismiss(animated: true) {
                Alert.shared.showAlert(message: AppMessages.skipCoachmarkMessage) { [weak self] isDone in
                    guard let _ = self else {return}
                    
                }
            }
        }
        
        self.btnStart.addTapGestureRecognizer { [weak self] in
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
