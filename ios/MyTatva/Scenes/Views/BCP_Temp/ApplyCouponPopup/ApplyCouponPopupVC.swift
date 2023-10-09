//
//  ApplyCouponPopupVC.swift
//  MyTatva
//
//  Created by Uttam patel on 22/08/23.
//

import UIKit

class ApplyCouponPopupVC: ClearNavigationFontBlackBaseVC {
    
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    
    @IBOutlet weak var btnGotIt      : UIButton!
    @IBOutlet weak var lblGotIt          : UILabel!
    
    //MARK:- Class Variable
   
    var completionHandler: ((String) -> Void)?
    var promoCode:String?
    var descriptionTitle: String?
    
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
        
        self.lblTitle.font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack).text = "Congratulations!!!\n‘\(self.promoCode ?? "")’ applied"
        self.lblTitle.numberOfLines = 0
        self.lblTitle.addLineSpacing(5.0)
        self.lblTitle.textAlignment = .center
//        self.lblTitle.setLineSpacing(lineSpacing: 5.0, alignment: .center)
        
        self.lblDesc.font(name: .light, size: 12)
            .textColor(color: .themeGray4).text = self.descriptionTitle
        
        self.lblGotIt.font(name: .semibold, size: 14)
            .textColor(color: UIColor.themePurple).text = "Got it, Thanks"
        
        self.lblGotIt.setAttributedString(["Got it, Thanks"], attributes: [[
            NSAttributedString.Key.foregroundColor : UIColor.themePurple,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]])
        
            
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.btnGotIt.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 24)
           
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
            completionHandler?(self.lblTitle.text ?? "")
        }
        
        self.dismiss(animated: animated) {
            sendData()
        }
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        
        /* self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }*/
        
        self.btnGotIt.addTapGestureRecognizer {
            var params = [String:Any]()
            params[AnalyticsParameters.discount_code.rawValue] = self.promoCode ?? ""
            FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_OK,
                                     screen: .AppliedCouponCodeSuccess,
                                     parameter: params)
            
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

