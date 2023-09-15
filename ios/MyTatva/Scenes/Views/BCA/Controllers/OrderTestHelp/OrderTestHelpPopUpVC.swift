//
//  OrderTestHelpPopUpVC.swift
//  MyTatva
//
//  Created by Hyperlink on 01/06/23.
//  Copyright © 2023. All rights reserved.

import UIKit

class OrderTestHelpPopUpVC: ClearNavigationFontBlackBaseVC {

    //MARK: Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!

    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var svFields         : UIStackView!
    @IBOutlet weak var txtSelectTest    : ThemeTextField!
    @IBOutlet weak var txtOrderId       : ThemeTextField!
    @IBOutlet weak var vwQuery          : UIView!
    @IBOutlet weak var tvQuery          : UITextView!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancel        : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel: OrderTestHelpPopUpViewModel!
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    var arrSelectionType: [JSON] = [
        [
            "name": "Laboratory Test",
            "type": 1,
        ],
        [
            "name": "Medical Device",
            "type": 2,
        ],
        [
            "name": "Doctor’s Appointment ",
            "type": 3,
        ],
    ]
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
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
            .font(name: .bold, size: 15)
            .textColor(color: UIColor.themeBlack).text = "Let us know how we can help"
        self.txtSelectTest
            .setRightImage(img: UIImage(named: "IconDownArrow")?.imageWithSize(size: CGSize(width: 20, height: 10), extraMargin: 20))
        self.txtSelectTest.delegate = self
        
        self.btnSubmit.font(name: .bold, size: 13)
            .textColor(color: UIColor.white)
        self.btnCancel.font(name: .bold, size: 13)
            .textColor(color: UIColor.themePurple)
        
    }
    
    fileprivate func configureUI(){
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.imgBg.layoutIfNeeded()
            self.btnSubmit.layoutIfNeeded()
            self.btnCancel.layoutIfNeeded()
            self.vwQuery.layoutIfNeeded()
            
            
            self.imgBg.cornerRadius(cornerRadius: 10)
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.btnSubmit
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 6)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnCancel
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
                .cornerRadius(cornerRadius: 6)
            
            self.vwQuery
                .borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
                .cornerRadius(cornerRadius: 5)
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
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.txtSelectTest.addTapGestureRecognizer {
            let dropDown = DropDown()
            DropDown.appearance().textColor = UIColor.themeBlack
            DropDown.appearance().selectedTextColor = UIColor.themeBlack
            DropDown.appearance().textFont = UIFont.customFont(ofType: .medium, withSize: 13)
            DropDown.appearance().backgroundColor = UIColor.white
            DropDown.appearance().selectionBackgroundColor = UIColor.white
            DropDown.appearance().cellHeight = 40
            
            
            dropDown.anchorView = self.txtSelectTest
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
            
            let arr: [String] = self.arrSelectionType.map { (obj) -> String in
                return obj["name"].stringValue
            }
            
            dropDown.dataSource = arr
            dropDown.selectionAction = { [weak self] (index, str) in
                guard let self = self else { return }
                self.txtSelectTest.text = str
                dropDown.hide()
            }
            dropDown.show()
        }
        
        self.btnCancelTop.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnCancel.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnSubmit.addTapGestureRecognizer {
//            var obj         = JSON()
//            obj["isDone"]   = true
//            self.dismissPopUp(true, objAtIndex: obj)
            let vc = OrderTestThanksPopUpVC.instantiate(fromAppStoryboard: .bca)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = OrderTestHelpPopUpViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

//MARK: -------------------- UITextField Delegate --------------------
extension OrderTestHelpPopUpVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
