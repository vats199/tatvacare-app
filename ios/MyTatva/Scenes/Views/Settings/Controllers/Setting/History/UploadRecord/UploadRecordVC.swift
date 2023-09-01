//
//  UploadRecordVC.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import UIKit

class UploadRecordCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var imgTitle     : UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblProgress  : UILabel!
    @IBOutlet weak var progressUpload : LinearProgressBar!
    @IBOutlet weak var btnCancel    : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .regular, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblProgress.font(name: .medium, size: 10).textColor(color: UIColor.themeBlack)
        
        GFunction.shared.setProgress(progressBar: self.progressUpload, color: UIColor.themePurple)
        self.progressUpload.isHidden = true
        self.lblProgress.isHidden = true
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.imgTitle.layoutIfNeeded()
            self.progressUpload.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            self.progressUpload.setRound()
        }
    }
}


class UploadRecordVC: ClearNavigationFontBlackBaseVC {
    
    //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblDocTitle  : UILabel!
    @IBOutlet weak var txtDocTitle  : UITextField!
    
    @IBOutlet weak var lblTestType: UILabel!
    @IBOutlet weak var txtTestType: UITextField!
    @IBOutlet weak var txtDesc: IQTextView!
    @IBOutlet weak var lblIns       : UILabel!
    @IBOutlet weak var lblTakePic   : UILabel!
    @IBOutlet weak var imgCamera    : UIImageView!
    @IBOutlet weak var lblOr        : UILabel!
    @IBOutlet weak var vwUploadBg   : UIView!
    @IBOutlet weak var btnBrowse    : UIButton!
    
    @IBOutlet weak var tblView      : UITableView!
    @IBOutlet weak var tblHeight    : NSLayoutConstraint!
    
    @IBOutlet weak var btnDone      : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = UploadRecordsVM()
    var selectedTitle               = Title()
    var completionHandler           : ((_ objc : Bool) -> Void)?
    let refreshControl              = UIRefreshControl()
    let pickerSubject               = UIPickerView()
    
    var strErrorMessage : String    = ""
    
    
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        
        DispatchQueue.main.async {
            self.vwUploadBg.layoutIfNeeded()
            self.btnDone.layoutIfNeeded()
            self.txtDesc.layoutIfNeeded()
            self.btnDone.cornerRadius(cornerRadius: 5)
            self.vwUploadBg.cornerRadius(cornerRadius: 5)
            self.vwUploadBg.addLineDashedStroke(pattern: [4,4], radius: 5, color: UIColor.ThemeBorder.cgColor)
            self.txtDesc.cornerRadius(cornerRadius: 5).borderColor(color: UIColor.ThemeBorder, borderWidth: 1.0)
            self.txtDesc.textContainerInset = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 15)
        }
        
        self.lblTestType.font(name: .medium, size: 16).textColor(color: UIColor.themeBlack)
        self.txtTestType.setRightImage(img: UIImage(named: "IconDownArrow"))
//        self.txtDocTitle.setRightImage(img: UIImage(named: "IconDownArrow"))
        self.txtTestType.tintColor = UIColor.clear
        self.txtDocTitle.delegate = self
        
        self.lblDocTitle.font(name: .medium, size: 16).textColor(color: UIColor.themeBlack)
        self.lblIns.font(name: .medium, size: 16).textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblTakePic.font(name: .medium, size: 14).textColor(color: UIColor.themeBlack)
        self.btnBrowse.font(name: .medium, size: 12)
        self.lblOr.font(name: .medium, size: 12).textColor(color: UIColor.themeBlack)
        
        self.btnDone.font(name: .medium, size: 20)
        self.btnDone.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.05, shdowRadious: 4)
        self.txtDesc.font(name: .medium, size: 15).textColor(color: UIColor.themeBlack)
        
        self.addObserverOnHeightTbl()
        self.configureUI()
        self.manageActionMethods()
        self.initPicker()
      
    }
    
    @objc func updateAPIData(){
        //self.viewModel.apiCallFromStartNotification(tblView: self.tblView,refreshControl: self.refreshControl, withLoader: true)
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
    
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
           
        DispatchQueue.main.async {
           
        }
    }
    
    func initPicker(){
        
        self.pickerSubject.delegate = self
        self.pickerSubject.dataSource = self
        self.txtTestType.delegate = self
        self.txtTestType.inputView = self.pickerSubject
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        self.imgCamera.addTapGestureRecognizer {
            DispatchQueue.main.async {
                ImagePickerController(isAllowEditing: true) { [weak self] (pickedImage) in
                    
                    guard let self = self else {return}
                    
                    self.viewModel.documentUploadSetup(image: pickedImage, document: nil){ (status , title) in
                        if status{
                            DispatchQueue.main.async {
                                self.viewModel.arrDocumentList.append(DocumentData(title: title,
                                                                                   urlPath:nil ,
                                                                                   isImage: true,
                                                                                   image: pickedImage))
                                self.tblView.reloadData()
                            }
                        }
                    }
                }.present()
            }
        }
        
        self.btnBrowse.addTapGestureRecognizer {
            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage),String(kUTTypeJPEG),String(kUTTypePNG)]/*["public.item"]*/, in: .import)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            
            self.present(documentPicker, animated: true, completion: nil)
        }
        
        self.btnDone.addTapGestureRecognizer {
            
            let docData = self.viewModel.arrDocumentList.map { $0.title ?? "" } /*["IwQdRDRXYh1635510397.jpeg"]*/
            let test_type_id = self.viewModel.object.testType.filter { $0.testName == self.txtTestType.text ?? ""
            }
            self.viewModel.uploadRecordAPI(withLoader: true,
                                           test_type: self.txtTestType.text ?? "",
                                           test_type_id: test_type_id.first?.testTypeId ?? "",
                                           title: self.txtDocTitle.text!,
                                           description: self.txtDesc.text!,
                                           document_data: docData){ [weak self] (isDone) in
                guard let self = self else {return}
                
                print(isDone)
                self.completionHandler?(isDone)
            }
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .UploadRecord)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.viewModel.testTypeListAPI(withLoader: false) { (isDone) in
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension UploadRecordVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getDocumentCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UploadRecordCell = tableView.dequeueReusableCell(withClass: UploadRecordCell.self, for: indexPath)
        let object = self.viewModel.getDocumentObject(index: indexPath.row)
        
        cell.lblTitle.text      = object.title
        
        if object.isImage {
            cell.imgTitle.image = UIImage(named: "image-upload")
        }
        else {
            cell.imgTitle.image = UIImage(named: "pdf_ic")
        }
        
        cell.btnCancel.addTapGestureRecognizer {
            self.viewModel.arrDocumentList.remove(at: indexPath.row)
            self.tblView.reloadData()
        }
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension UploadRecordVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblView else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: --------------------- UIPickerVIew Method ---------------------
extension UploadRecordVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerSubject:
            if self.viewModel.object.testType.count > 0{
                return self.viewModel.object.testType.count
            }
            return 0
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerSubject:
            return self.viewModel.object.testType[row].testName
        
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pickerSubject:
            if self.viewModel.object.testType.count - 1 >= row{
                self.txtTestType.tag    = row
                self.txtTestType.text   = self.viewModel.object.testType[row].testName
            }
            break
       
        default: break
        }
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension UploadRecordVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtTestType:
            
            if self.txtTestType.text?.trim() == "" &&
                self.viewModel.object.testType.count > 0 {
                
                self.txtTestType.tag        = 0
                self.txtTestType.text       = self.viewModel.object.testType[0].testName
            }
            
        case self.txtDocTitle:
            self.view.endEditing(true)

//            let vc = SelectDocumentTitleVC.instantiate(fromAppStoryboard: .setting)
//            vc.arrDocTitle = self.viewModel.object.title
//            vc.completionHandler = { obj in
//                Do your task here
//                if obj != nil {
//                    self.selectedTitle     = obj!
//                    self.txtDocTitle.text  = self.selectedTitle.title
//                }
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//            return false
            
            return true
        default:
            break
        }
        
        return true
    }
}

//MARK: -------------------- DocumentPicker Methods --------------------

extension UploadRecordVC: UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {

        GFunction.shared.allowedFileSize(sizeInKb: Int(url.fileSize/1000)) { isAllowed in
            if isAllowed{
                DispatchQueue.main.async {
                    self.viewModel.documentUploadSetup(image: nil, document: url.absoluteString){ (status , title) in
                        if status{
                            DispatchQueue.main.async {
                                self.viewModel.arrDocumentList.append(DocumentData(title: title,
                                                                                   urlPath: url.absoluteString,
                                                                                   isImage: url.absoluteString.isImageType(),
                                                                                   image: nil))
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}


//MARK: ------------------ UITableView Methods ------------------
extension UploadRecordVC {
    
    fileprivate func setData(){
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension UploadRecordVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                
                self.navigationController?.popViewController(animated: true)
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}



