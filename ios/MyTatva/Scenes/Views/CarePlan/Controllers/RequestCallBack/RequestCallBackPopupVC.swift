//
//  RequestCallBackPopupVC.swift
//  MyTatva
//
//  Created by hyperlink on 14/10/21.
//

import UIKit

class RequestCallBackPopupVC: ClearNavigationFontBlackBaseVC {

    //MARK: - Outlets
    
    @IBOutlet weak var imgBg                : UIImageView!
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var lbltitle             : UILabel!
    @IBOutlet weak var lblSubtitle          : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    @IBOutlet weak var btnReqCallback       : UIButton!
    @IBOutlet weak var btnChangeAddress     : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //------------------------------------------------------
    
    //MARK: - Class variables
    
    let viewModel = RequestCallBackPopupVM()
    var completionHandler: ((_ obj : JSON?) -> Void)?
    var patient_dose_rel_id = ""
    //------------------------------------------------------
    
    //MARK: - Lifecycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setUpView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .RequestCallBack)
    }
    //------------------------------------------------------
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    private func setUpView(){
        self.lbltitle.font(name: .semibold, size: 22)
        self.lblSubtitle.font(name: .medium, size: 14)
        
        self.btnReqCallback.font(name: .medium, size: 14)
        self.btnChangeAddress.font(name: .regular, size: 14)
        
        let dic = [NSAttributedString.Key.font : UIFont.customFont(ofType: .medium, withSize: 14), NSAttributedString.Key.foregroundColor : UIColor.themePurple,
                   NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                   NSAttributedString.Key.underlineColor : UIColor.themePurple] as [NSAttributedString.Key : Any]
        
        let attrString = NSMutableAttributedString(string: self.lblDesc.text ?? "")
        attrString.addAttributes(dic, range:  NSRange(location: 0, length: (self.lblDesc.text ?? "").count))
        
        self.lblDesc.attributedText = attrString
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners(corners: .allCorners, radius: 7)
        }
        
        self.setupViewModelObserver()
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
       
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func configureUI(){
          
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : JSON? = nil) {
        
        func sendData() {
            self.completionHandler?(nil)
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
    
    //------------------------------------------------------
    
    //MARK: - Action methods
    
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.lblDesc.addTapGestureRecognizer {
            //self.dismissPopUp(true, objAtIndex: nil)
            
            GlobalAPI.shared.get_zydus_infoAPI { [weak self] isDone, object, msg in
                guard let self = self else {return}
                if isDone {
                    self.dismiss(animated: true) {
                        let vc = HospitalDetailPopupVC.instantiate(fromAppStoryboard: .carePlan)
                        vc.object = object
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        UIApplication.topViewController()?.navigationController?.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func ActionRequestCallback(_ sender : UIButton){
        
        self.viewModel.apiRequestCallback(withLoader: true,
                                          patient_dose_rel_id: self.patient_dose_rel_id) { [weak self] (isDone) in
            guard let self = self else {return}
            if isDone {
                
            }
        }
        
        self.dismissPopUp(true, objAtIndex: nil)
    }
    
    @IBAction func ActionChangeAddress(_ sender : UIButton){
        var obj         = JSON()
        obj["change"]   = "change"
        self.dismissPopUp(true, objAtIndex: obj)
    }
    
    //------------------------------------------------------
    
}

//MARK: -------------------- setupViewModel Observer --------------------
extension RequestCallBackPopupVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                let obj = JSON()
                self.dismissPopUp(true, objAtIndex: obj)
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
