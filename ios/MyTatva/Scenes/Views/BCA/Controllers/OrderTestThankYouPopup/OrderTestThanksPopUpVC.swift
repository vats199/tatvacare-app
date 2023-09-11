//
//  OrderTestThanksPopUpVC.swift
//  MyTatva
//
//  Created by Hyperlink on 01/06/23.
//  Copyright © 2023. All rights reserved.

import UIKit

class OrderTestThanksPopUpVC: ClearNavigationFontBlackBaseVC {

    //MARK: Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!

    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var btnContinue      : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel: OrderTestThanksPopUpViewModel!
    var completionHandler: ((_ obj : JSON?) -> Void)?
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(OrderTestThanksPopUpVC.self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.applyStyle()
        self.vwBg.animateBounce()
        self.openPopUp()
//        self.setData()
        self.configureUI()
        self.manageActionMethods()
    }
    
    private func applyStyle() {
        self.lblTitle
            .font(name: .bold, size: 19)
            .textColor(color: UIColor.themeBlack).text = "Thank you for your response our team will contact you soon !!"
        
        self.btnContinue.font(name: .bold, size: 13)
            .textColor(color: UIColor.white)
    }
    
    fileprivate func configureUI(){
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.imgBg.layoutIfNeeded()
            self.btnContinue.layoutIfNeeded()
            
            self.imgBg.cornerRadius(cornerRadius: 10)
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.btnContinue
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 10)
                .backGroundColor(color: UIColor.themePurple)
        }
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : JSON? = nil) {
        
        func sendData() {
            if let obj = objAtIndex {
                if let completionHandler = self.completionHandler {
                    completionHandler(obj)
                }
            }
        }
        
        self.dismiss(animated: animated) {
            sendData()
        }
    }
    
    
    //------------------------------------------------------
    
    //MARK: Action Method
    fileprivate func manageActionMethods(){
        
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnCancelTop.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
    }
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = OrderTestThanksPopUpViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
