//
//  CorrectAnswerPopUpVC.swift
//  MyTatva
//
//  Created by hyperlink on 14/10/21.
//

import UIKit

class CorrectAnswerPopUpVC : ClearNavigationFontBlackBaseVC {

    //MARK: Outlets
    
    @IBOutlet weak var imgBg : UIImageView!
    @IBOutlet weak var vwBg : UIView!
    @IBOutlet weak var lblScore : UILabel!
    @IBOutlet weak var lblCongratulation : UILabel!
    @IBOutlet weak var progressScore : LinearProgressBar!
    
    //-------------------------------------------------------------------
    
    //MARK: - class variables
    
    let viewModel                       = CorrectAnswerPopUpVM()
    var value : Float      = 0
    var maxValue : Float   = 0
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    //-------------------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //------------------------------------------------------
    
    //MARK: - Life cycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
        
        // Do any additional setup after loading the view.
    }
    
    //-------------------------------------------------------------------
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    private func setUpView(){
        self.lblCongratulation.font(name: .bold, size: 30)
        self.lblScore.font(name: .bold, size: 14)
        
        self.progressScore.trackColor          = UIColor.themeLightGray
        self.progressScore.trackPadding        = 0
        self.progressScore.capType             = 1
        self.progressScore.barThickness        = 10
        self.progressScore.barColor            = UIColor.colorExercise
        self.progressScore.progressValue = GFunction.shared.getProgress(
            value: self.value,
            maxValue: self.maxValue)
        
        self.lblScore.text = String(format: "%.f", self.value) + " " + AppMessages.of + " " + String(format: "%.f", self.maxValue) + " " + AppMessages.Correct
        
        DispatchQueue.main.async{
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners(corners: .allCorners, radius: 7)
            self.progressScore.setRound()
        }
        
        self.setupViewModelObserver()
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
    

    
    //-------------------------------------------------------------------
    
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
    }
    
}


//MARK: -------------------- setupViewModel Observer --------------------
extension CorrectAnswerPopUpVC {
    
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
