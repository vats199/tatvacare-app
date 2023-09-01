//
//  PheromonePopupVC.swift
//

//

import UIKit

class ReadingInfoPopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!

    @IBOutlet weak var vwImgTitle       : UIView!
    @IBOutlet weak var imgTitle         : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var lblDescHeight    : NSLayoutConstraint!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    
    //MARK:- Class Variable
    //let viewModel                       = UpdateReadingPopupVM()
    var readingType: ReadingType        = .HeartRate
    var readingListModel                = ReadingListModel()
    
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
        
        self.lblTitle.font(name: .semibold, size: 23)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        self.btnSubmit.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
        
        self.vwBg.animateBounce()
        self.openPopUp()
        self.setData()
        self.configureUI()
        self.manageActionMethods()
    }
    
    fileprivate func configureUI(){
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.imgBg.layoutIfNeeded()
            self.btnSubmit.layoutIfNeeded()
            
            self.imgBg.cornerRadius(cornerRadius: 10)
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.btnSubmit
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)
            
            self.vwImgTitle.layoutIfNeeded()
            self.vwImgTitle.cornerRadius(cornerRadius: 5)
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
        
        
        self.btnCancelTop.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnSubmit.addTapGestureRecognizer {
            var obj         = JSON()
            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: obj)
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

//MARK: ------------------ UITableView Methods ------------------
extension ReadingInfoPopupVC {
    
    fileprivate func setData(){
        //WebengageManager.shared.navigateScreenEvent(screen: .LogReading, postFix: self.readingListModel.keys)
        
        self.vwImgTitle
            .backGroundColor(color: UIColor.hexStringToUIColor(hex: self.readingListModel.backgroundColor).withAlphaComponent(0.1))
        self.imgTitle.setCustomImage(with: self.readingListModel.imageUrl, renderingMode: .alwaysTemplate)
        self.imgTitle.tintColor     = UIColor.hexStringToUIColor(hex: self.readingListModel.colorCode)
        self.lblTitle.text          = self.readingListModel.readingName
        self.lblDesc.text           = self.readingListModel.information
        
        let height = self.readingListModel.information
            .height(withConstrainedWidth: self.lblDesc.frame.width,
                    font: UIFont.customFont(ofType: .regular, withSize: 15))
        self.lblDescHeight.constant = height + 10
        self.vwBg.layoutIfNeeded()
//        + "\n"
//        + self.readingListModel.defaultReading!
        
        self.btnSubmit.setTitle(AppMessages.log + " " + self.readingListModel.readingName, for: .normal)
    }
}

