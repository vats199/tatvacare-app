//
//  ConfirmAccountDeleteVC.swift
//  MyTatva
//

import UIKit

class ConfirmAccountDeleteVC: ClearNavigationFontBlackBaseVC { //----------------------------------
    
    //MARK: -------------------------- UIControl's Outlets --------------------------
    @IBOutlet weak var lblTop       : UILabel!
    @IBOutlet weak var imgTitle     : UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!

    @IBOutlet weak var lblDesc      : UILabel!
    
    @IBOutlet weak var btnDelete    : UIButton!
    @IBOutlet weak var btnCancel    : UIButton!
    
    @IBOutlet weak var scrollVw     : UIScrollView!
    
    //MARK: -------------------------- Class Variables --------------------------
    
    //MARK: -------------------------- Memory management --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: -------------------------- Custome Methods --------------------------
    
    //Desc:- Centre method to call in View
    func setUpView(){
        
        DispatchQueue.main.async {
            self.btnDelete.layoutIfNeeded()
            self.btnDelete.cornerRadius(cornerRadius: 5)
        }
        
        self.lblTitle
            .font(name: .semibold, size: 20)
            .textColor(color: UIColor.themePurple)
     
        self.lblDesc
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.85))
        
        self.btnDelete
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.white)
            .backGroundColor(color: UIColor.themePurple)
        self.btnCancel
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack)
            .backGroundColor(color: UIColor.white)
        
        self.configureUI()
        self.manageActionMethods()
        
    }
    
    //Desc:- Set layout desing customize
    func configureUI(){
        //self.scrollVw.delegate = self
      
    }
    
    //MARK: -------------------------- Action Methods --------------------------
    func manageActionMethods(){
        self.btnDelete.addTapGestureRecognizer {
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { (isDone) in
                        if isDone {
                            //UIApplication.shared.forceLogOut()
                            GlobalAPI.shared.deleteAccountAPI { (isDone) in
                                if isDone {
                                    
                                    if kUserSessionActive {
                                        kUserSessionActive      = false
                                        FIRAnalytics.FIRLogEvent(eventName: .USER_SESSION_END,
                                                                 screen: .AccountDelete,
                                                                 parameter: nil)
                                    }
                                    
                                    UIApplication.shared.forceLogOut()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.btnCancel.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: -------------------------- View life cycle Methods --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        WebengageManager.shared.navigateScreenEvent(screen: .AccountDelete)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .HelpSupportFaq, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //FIRAnalytics.manageTimeSpent(on: .HelpSupportFaq, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

