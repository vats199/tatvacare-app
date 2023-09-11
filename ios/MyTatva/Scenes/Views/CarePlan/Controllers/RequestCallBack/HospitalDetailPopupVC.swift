//
//  RequestCallBackPopupVC.swift
//  MyTatva
//
//  Created by hyperlink on 14/10/21.
//

import UIKit

class HospitalDetailPopupVC: ClearNavigationFontBlackBaseVC {

    //MARK: - Outlets
    
    @IBOutlet weak var imgBg                : UIImageView!
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lbltitle             : UILabel!
    
    @IBOutlet weak var lblPhone             : UILabel!
    @IBOutlet weak var lblAddress           : UILabel!
    @IBOutlet weak var btnDone              : UIButton!
    @IBOutlet weak var btnClose             : UIButton!
    
    var object = HospitalDetailsModel()
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
        self.lblPhone.font(name: .medium, size: 14)
        self.lblAddress.font(name: .medium, size: 14)
        
        self.btnDone.font(name: .medium, size: 14)
            .textColor(color: UIColor.white, state: .normal)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners(corners: .allCorners, radius: 7)
        }
        
        self.setData()
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
        
        self.btnClose.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnDone.addTapGestureRecognizer {
            var obj         = JSON()
            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: obj)
            
            GFunction.shared.openLink(strLink: "https://www.google.com/", inApp: true)
        }
    }
  
    //------------------------------------------------------
}

//MARK: -------------------- Set data --------------------
extension HospitalDetailPopupVC {
    
    func setData(){
        self.lbltitle.text = self.object.zydusName
        self.lblPhone.text = self.object.zydusPhone
        self.lblAddress.text = self.object.zydusAddress
    }
}
