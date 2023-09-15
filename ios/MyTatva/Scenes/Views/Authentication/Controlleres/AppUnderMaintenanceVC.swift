//
//  AppUnderMaintenanceVC.swift
//  MyTatva
//
//  Created by Darshan Joshi on 27/12/21.
//

import UIKit

class AppUnderMaintenanceVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var imgBg            : UIImageView!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var strtitle   = ""
    var strDesc    = ""
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
        self.lblTitle.text  = self.strtitle
        self.lblDesc.text   = self.strDesc
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //FIRAnalytics.FIRLogEvent(eventName: .USER_PROFILE_COMPLETED, parameter: nil)
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
      
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
            self.vwBg.themeShadow()
        }
        
    }
    
    private func applyStyle() {
        self.lblTitle
            .font(name: .medium, size: 20).textColor(color: .themePurple)
        self.lblDesc
            .font(name: .light, size: 16).textColor(color: .themeBlack.withAlphaComponent(0.7))
    }
    
    //MARK:- Action Method
   
}
