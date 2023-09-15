//
//  BackToCarePlanPopupVC.swift
//  MyTatva
//
//  Created by hyperlink on 14/10/21.
//

import UIKit

class BackToCarePlanPopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK: - Outlets
    
    @IBOutlet weak var imgBg : UIImageView!
    @IBOutlet weak var vwBg : UIView!
    @IBOutlet weak var lbltitle : UILabel!
    @IBOutlet weak var btnCarePlan : UIButton!
    
    @IBOutlet weak var btnCancel : UIButton!
    
    //------------------------------------------------------
    
    
    //MARK: - class variable
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
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
    
    //MARK: - Lifecycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
        // Do any additional setup after loading the view.
    }

    //------------------------------------------------------
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    private func setUpView(){
        self.lbltitle.font(name: .medium, size: 20)
        
        self.btnCarePlan.font(name: .medium, size: 14)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.vwBg.layoutIfNeeded()
            self.btnCancel.layoutIfNeeded()
            self.vwBg.roundCorners(corners: .allCorners, radius: 7)
        }
        
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
//            if let obj = objAtIndex {
//                if let completionHandler = completionHandler {
//                    completionHandler(obj)
//                }
//            }
            
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
        
    }
    
    @IBAction func ActionCarePlan(_ sender : UIButton){
        self.dismissPopUp(true, objAtIndex: nil)
    }
    
    
    //------------------------------------------------------
    
}
