
import UIKit


class CustomiseProfilePopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg                        : UIImageView!
    @IBOutlet weak var vwBg                         : UIView!
    
    @IBOutlet weak var vwWelcomeParent              : UIView!
    @IBOutlet weak var vwWelcomeBox                 : UIView!
    
    @IBOutlet weak var lblTitle                     : UILabel!
    @IBOutlet weak var lblDesc                      : UILabel!
    @IBOutlet weak var btnCustomiseProfile          : UIButton!
    @IBOutlet weak var btnCancel                    : UIButton!
    
    
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
            
            //-------------------------- Welcome box
            //vwWelcomeParent
            self.vwWelcomeBox.layoutIfNeeded()
            self.vwWelcomeBox.cornerRadius(cornerRadius: 15)
            let colorWelcomeBg = GFunction.shared.applyGradientColor(startColor: UIColor.themePurple.withAlphaComponent(0.5),
                                                            endColor: UIColor.themePurple,
                                                            locations: [0, 1],
                                                            startPoint: CGPoint(x: 0, y: self.vwWelcomeBox.frame.maxY),
                                                            endPoint: CGPoint(x: self.vwWelcomeBox.frame.maxX, y: self.vwWelcomeBox.frame.maxY),
                                                            gradiantWidth: self.vwWelcomeBox.frame.width,
                                                            gradiantHeight: self.vwWelcomeBox.frame.height)
            
            self.vwWelcomeBox.backgroundColor = colorWelcomeBg
        }
    }
    
    private func applyStyle() {
        self.lblTitle
            .font(name: .bold, size: 22).textColor(color: .themeBlack)
        self.lblDesc
            .font(name: .regular, size: 12).textColor(color: .white)
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        
        self.imgBg.addTapGestureRecognizer { [weak self] in
            guard let self = self else {return}
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnCustomiseProfile.addTapGestureRecognizer { [weak self] in
            guard let self = self else {return}
            var obj         = JSON()
            obj["isDone"]   = "Yes"
            self.dismissPopUp(true, objAtIndex: obj)
        }
        
        self.btnCancel.addTapGestureRecognizer { [weak self] in
            guard let self = self else {return}
            //let obj         = JSON()
            self.dismissPopUp(true, objAtIndex: nil)
        }
    }
    
}
