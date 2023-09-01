//
//  AddSupportQuestionPopupVC.swift
//  MyTatva
//
//  Created by hyperlink on 26/10/21.
//

import UIKit

class AddSupportQuestionPopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var svMain           : UIStackView!
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblLine          : UILabel!
    
    @IBOutlet weak var svFields         : UIStackView!
    @IBOutlet weak var txtSelecttype    : UITextField!
    @IBOutlet weak var txtvDes          : UITextView!
    @IBOutlet weak var txtUpload        : UITextField!
    
    @IBOutlet weak var vwButtons        : UIView!
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancel        : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    @IBOutlet weak var btnContinue      : ThemePurpleButton!
    
    //MARK:- Class Variable
    let viewModel                       = AddSupportQuestionPopupVM()
    
    let pickerSubject       = UIPickerView()
    var selectedImage       = String()
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
        
        self.btnContinue.font(name: .medium, size: 14.0).setTitle("Continue", for: UIControl.State())
        self.btnContinue.isHidden = true
        
        self.lblTitle.font(name: .semibold, size: 18)
            .textColor(color: UIColor.themeBlack)
        
        self.btnCancel.font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
            .backGroundColor(color: UIColor.white)
        
        self.btnSubmit.font(name: .medium, size: 14)

        self.txtSelecttype.setRightImage(img: UIImage(named: "IconDownArrow"))
        self.txtUpload.setRightImage(img: UIImage(named: "support-attachment"))
        self.txtUpload.delegate = self
        
        self.txtvDes.delegate = self
        self.txtvDes.font(name: .regular, size: 14).textColor(color: UIColor.themeBlack)
        
        
        //validate max 200 from api
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.btnSubmit.layoutIfNeeded()
            self.btnCancel.layoutIfNeeded()
            self.txtvDes.layoutIfNeeded()
            
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.btnSubmit.cornerRadius(cornerRadius: 5)
            self.txtvDes.cornerRadius(cornerRadius: 5).borderColor(color: UIColor.ThemeBorder, borderWidth: 1.0)
            self.txtvDes.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        self.initPicker()
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
    }
    
    fileprivate func configureUI(){
        
    }
    
    func initPicker(){
        
        self.pickerSubject.delegate = self
        self.pickerSubject.dataSource = self
        self.txtSelecttype.delegate = self
        self.txtSelecttype.inputView = self.pickerSubject
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    func sendData(obj:JSON? = nil) {
        if let obj = obj {
            if let completionHandler = completionHandler {
                completionHandler(obj)
            }
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
        self.btnContinue.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            var obj = JSON()
            obj["isDone"] = true
            self.dismissPopUp(true, objAtIndex: obj)
        }
        self.btnCancelTop.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnCancel.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnSubmit.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            
            
            let queryId = self.viewModel.arrQueryType.filter { $0.queryReason == self.txtSelecttype.text ?? ""
            }
            var queryDoc : [String] = []
            if self.txtUpload.text?.trim() != ""{
                queryDoc.append(self.txtUpload.text ?? "")
            }
            
            self.viewModel.apiAddSupportQuestion(withLoader: true,
                                                 query_reason_master_id: queryId.first?.queryReasonMasterId ?? "",
                                                 description: self.txtvDes.text ?? "",
                                                 query_docs: queryDoc) { [weak self] (isDone) in
                
                guard let self = self else {return}
                
                if isDone{
                }
            }
            
        }
        
        self.imgBg.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .FaqQuery)
        
        self.viewModel.queryReasonListAPI(withLoader: false) { [weak self] (isDone) in
            guard let self = self else { return }            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension AddSupportQuestionPopupVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtSelecttype:
            
            if self.txtSelecttype.text?.trim() == "" {
                if self.viewModel.arrQueryType.count > 0{
                    self.txtSelecttype.text         = self.viewModel.arrQueryType[0].queryReason
                }
            }
           
            break
            
        case self.txtUpload:
//            let documentPicker = UIDocumentPickerViewController(documentTypes:["public.item"], in: .import)
//            documentPicker.delegate = self
//            documentPicker.allowsMultipleSelection = false
//
//            self.present(documentPicker, animated: true, completion: nil)
            DispatchQueue.main.async {
                ImagePickerController(isAllowEditing: true) { [weak self] (pickedImage) in
                    
                    guard let self = self else {return}
                    
                    
                    self.viewModel.attachnmentUploadSetup(image: pickedImage, document: nil) { [weak self]  (isDone, title) in
                        
                        guard let self = self else {return}
                        
                        if isDone{
                            //self.selectedImage
                            DispatchQueue.main.async {
                                self.txtUpload.text = title
                                self.view.endEditing(true)
                            }
                            
                        }
                    }
                    
                }.present()
            }
            
            return false
            
        default:
            break
        }
        
        return true
    }
}

//MARK: --------------------- UITextView delegate Method ---------------------
extension AddSupportQuestionPopupVC : UITextViewDelegate{
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

//MARK: --------------------- UIPickerVIew Method ---------------------
extension AddSupportQuestionPopupVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerSubject:
            return self.viewModel.arrQueryType.count
        
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerSubject:
            if self.viewModel.arrQueryType.count > 0 {
                return self.viewModel.arrQueryType[row].queryReason
            }
            return ""
        
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pickerSubject:
            
            if self.viewModel.arrQueryType.count > 0 {
                self.txtSelecttype.text = self.viewModel.arrQueryType[row].queryReason
            }
            break
       
        default: break
        }
    }
}

//MARK: -------------------- DocumentPicker Methods --------------------

extension AddSupportQuestionPopupVC : UIDocumentPickerDelegate{
    
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
extension AddSupportQuestionPopupVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(let msg):
                // Redirect to next screen
                self.lblTitle.text = msg
                self.lblTitle.numberOfLines = 0
                self.lblLine.isHidden = true
                self.svFields.isHidden = true
                self.svMain.spacing = 0
                self.vwButtons.isHidden = true
                self.btnContinue.isHidden = false
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}


