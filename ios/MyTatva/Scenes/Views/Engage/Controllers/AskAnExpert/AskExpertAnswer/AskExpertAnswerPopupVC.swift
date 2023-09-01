//
//  AddSupportQuestionPopupVC.swift
//  MyTatva
//
//  Created by hyperlink on 26/10/21.
//

import UIKit

class AskExpertAnswerPopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var txtvDes          : UITextView!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    
    
    //MARK:- Class Variable
    let viewModel               = AskExpertAnswerPopupVM()
    var object                  = AskExpertListModel()
    
    let pickerSubject           = UIPickerView()
    var selectedImage           = String()
    var completionHandler: ((_ obj : AskExpertListModel?) -> Void)?
    var content_comments_id     = ""
    var content_master_id       = ""
    var strQue                  = ""
    var strAns                  = ""
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
            .textColor(color: UIColor.themeBlack)
        
        self.btnSubmit
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.white)
       
        self.txtvDes.delegate = self
        self.txtvDes.font(name: .regular, size: 14).textColor(color: UIColor.themeBlack)
        
        self.lblTitle.text  = self.strQue
        self.txtvDes.text   = self.strAns
        
        //validate max 200 from api
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.btnSubmit.layoutIfNeeded()
            self.txtvDes.layoutIfNeeded()
            
            self.vwBg
                .cornerRadius(cornerRadius: 10)
            self.btnSubmit
                .cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple)
            
            self.txtvDes
                .cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.ThemeBorder, borderWidth: 1.0)
            self.txtvDes.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
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
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : AskExpertListModel? = nil) {
        
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
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnSubmit.addTapGestureRecognizer {
            self.viewModel.apiCall(vc: self, content_master_id: self.content_master_id,
                                   description: self.txtvDes.text!,
                                   content_comments_id: self.content_comments_id)
        }
        
        self.imgBg.addTapGestureRecognizer {
            
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
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .SubmitAnswer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: --------------------- UITextView delegate Method ---------------------
extension AskExpertAnswerPopupVC : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if GFunction.shared.isBackspace(text){
            return true
        }
        
        switch textView {
        case self.txtvDes:
            if self.txtvDes.text?.count ?? 0 < kMaxQuestionChar{
                return true
            }
        default:
            break
        }
        return false
    }
    
}

//MARK: -------------------- DocumentPicker Methods --------------------

extension AskExpertAnswerPopupVC : UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//        self.selectedDocUrl = url.absoluteString
//        self.txtUpload.text = url.lastPathComponent
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.view.endEditing(true)
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension AskExpertAnswerPopupVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                DispatchQueue.main.async {
                    self.dismissPopUp(true, objAtIndex: self.viewModel.object)
                }
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}


