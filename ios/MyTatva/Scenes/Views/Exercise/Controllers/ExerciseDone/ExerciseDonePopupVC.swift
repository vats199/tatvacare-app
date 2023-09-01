//
//  ExerciseDonePopupVC.swift
//  MyTatva
//
//  Created by hyperlink on 27/10/21.
//

import UIKit

class ExerciseDonePopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgExercise      : UIImageView!
    @IBOutlet weak var lblDone          : UILabel!
    @IBOutlet weak var lblDetail        : UILabel!
    @IBOutlet weak var btnDone          : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    
    //MARK:- Class Variable
    let viewModel                       = ExerciseDonePopupVM()
    var currentExerciseType  : GoalType = .Pranayam
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
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
        
        self.lblDone.font(name: .semibold, size: 24).textColor(color: UIColor.themeBlack)
        self.lblDetail.font(name: .regular, size: 20).textColor(color: UIColor.themeBlack)
        self.btnDone.font(name: .medium, size: 14).textColor(color: UIColor.white)
        
        self.lblDetail.text = AppMessages.ExerciselogDone//"Your \(self.currentExerciseType.rawValue) time will be added to your daily goal count"
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            
            self.btnDone.layoutIfNeeded()
            self.btnDone.cornerRadius(cornerRadius: 5)
            
            self.btnCancelTop.layoutIfNeeded()
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
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.btnCancelTop.addTapGestureRecognizer {
            self.dismissPopUp(true)
        }
        
        self.btnDone.addTapGestureRecognizer {
            var objc = JSON()
            objc["isDone"] = true
            self.dismissPopUp(true, objAtIndex: objc)
        }
        
    }
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: -------------------- setupViewModel Observer --------------------
extension ExerciseDonePopupVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}


