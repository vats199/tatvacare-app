
import UIKit
import LocalAuthentication

class BiometricVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var lblBiometric         : UILabel!
    @IBOutlet weak var lblBiometricDesc     : UILabel!
    
    @IBOutlet weak var btnEnable            : UIButton!
    @IBOutlet weak var btnSkip              : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel               = BiometricVM()

    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        WebengageManager.shared.navigateScreenEvent(screen: .UseBiometric)
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
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        self.applyStyle()
        self.manageActionMethods()
    }
    
    private func applyStyle() {
        self.lblBiometric.font(name: .bold, size: 22).textColor(color: .themePurple)
        self.lblBiometricDesc.font(name: .regular, size: 16).textColor(color: .themeBlack)
        self.btnSkip.font(name: .medium, size: 16).textColor(color: .themePurple)
    }
    
    //MARK:- Action Method
    func manageActionMethods(){
        self.btnEnable.addTapGestureRecognizer {
            BiometricsManager.shared.authenticationWithTouchID { [weak self] (isDone) in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    let vc = AllSetVC.instantiate(fromAppStoryboard: .auth)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.completionHandler = { obj in
                        if obj?.count > 0 {
                            let vc = SetLocationVC.instantiate(fromAppStoryboard: .auth)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        
        self.btnSkip.addTapGestureRecognizer {
            DispatchQueue.main.async {
                let vc = AllSetVC.instantiate(fromAppStoryboard: .auth)
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.completionHandler = { obj in
                    if obj?.count > 0 {
                        let vc = SetLocationVC.instantiate(fromAppStoryboard: .auth)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
   
}

//MARK: -------------------- setupViewModel Observer --------------------
extension BiometricVC {
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                //Alert.shared.showAlert(message: "Login success", completion: nil)
                //self.navigationController?.popViewController(animated: true)
                UIApplication.shared.setLogin()
            break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
    }
    
}


