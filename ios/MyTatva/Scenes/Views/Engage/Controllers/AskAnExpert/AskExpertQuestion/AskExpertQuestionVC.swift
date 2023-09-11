
//
//  AddSupportQuestionPopupVC.swift
//  MyTatva
//
//  Created by hyperlink on 26/10/21.
//

import UIKit
import SwiftUI

class AskExpertQuestionImageCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var btnDelete           : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.0))
        }
    }
}

class AskExpertQuestionVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var vwQusetion       : UIView!
    @IBOutlet weak var txtQusetion      : UITextField!
    @IBOutlet weak var btnAttach        : UIButton!
    
    @IBOutlet weak var lblUploadDoc     : UILabel!
    @IBOutlet weak var tblView          : UITableView!
    @IBOutlet weak var tblViewHeight    : NSLayoutConstraint!
    
    @IBOutlet weak var lblSelectCategory: UILabel!
    @IBOutlet weak var colView          : UICollectionView!
    @IBOutlet weak var colViewHeight    : NSLayoutConstraint!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    
    //MARK:- Class Variable
    var object                          = AskExpertListModel()
    let viewModel                       = AskExpertQuestionVM()
    let askExpertListVM                 = AskExpertListVM()
    var kMaxReloadAttempTopic           = 0
    let pickerSubject                   = UIPickerView()
    var selectedImage                   = String()
    var completionHandler: ((_ obj : AskExpertListModel?) -> Void)?
    var strErrorMessage                 = ""
    var strErrorMessageTopicList        = ""
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {
        
        self.btnSubmit
            .font(name: .medium, size: 14)
            .backGroundColor(color: UIColor.themePurple)
        
        self.txtQusetion
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblUploadDoc
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack)
            
        self.lblSelectCategory
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack)
 
        self.btnSubmit
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.white)
        
        
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
        self.addObserverOnHeightTbl()
        self.setupViewModelObserver()
        
        self.setup(colView: self.colView)
        self.setup(tblView: self.tblView)
    }
    
    fileprivate func configureUI(){
     
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.btnSubmit.layoutIfNeeded()
            
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.btnSubmit.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple)
            
            self.vwQusetion.layoutIfNeeded()
            self.vwQusetion
                .cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
                .backGroundColor(color: UIColor.ThemeLightGray2)
        }
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
    
    func setup(tblView: UITableView){
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
//        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
//        tblView.addSubview(self.refreshControl)
    }
    
    func setup(colView: UICollectionView){
        colView.delegate                   = self
        colView.dataSource                 = self
        colView.emptyDataSetSource         = self
        colView.emptyDataSetDelegate       = self
        colView.reloadData()
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.btnCancelTop.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnAttach.addTapGestureRecognizer {
            DispatchQueue.main.async {
                Alert.shared.showAlert(message: AppMessages.PleaseSelect, actionTitles: [AppMessages.Image, AppMessages.File], actions: [ {(img) in
                    
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
                },
                                                                                                                                          {(file) in
                    
                    DispatchQueue.main.async {
                        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage),String(kUTTypeJPEG),String(kUTTypePNG)]/*["public.item"]*/, in: .import)
                        documentPicker.delegate = self
                        documentPicker.allowsMultipleSelection = false
                        self.present(documentPicker, animated: true, completion: nil)
                    }
                }
                                                                                                                                        ])
            }
        }
        
      
        self.btnSubmit.addTapGestureRecognizer {
            
            var topic_ids: [String] = []
            if self.askExpertListVM.arrListTopicList.count != 0 {
                let arrTemp = self.askExpertListVM.arrListTopicList.filter { (obj) in
                    return obj.isSelected
                }
                topic_ids = arrTemp.map { (obj) -> String in
                    return obj.topicMasterId
                }
            }
            
            var documents = [[String: Any]]()
            for item in self.viewModel.arrDocumentList {
                var obj = [String: Any]()
                obj["document"] = item.title
                obj["document_type"] = item.isImage ? "Photo" : "PDF"
                documents.append(obj)
            }
            
            self.viewModel.apiCall(vc: self,
                                   content_master_id: self.object.contentMasterId ?? "",
                                   question: self.txtQusetion.text!,
                                   topic_ids: topic_ids,
                                   documents: documents,
                                   isEdit: self.object.title != nil ? true : false)
            
//            let queryId = self.viewModel.arrQueryType.filter { $0.queryReason == self.txtSelecttype.text ?? ""
//            }
//            var queryDoc : [String] = []
//            if self.txtUpload.text?.trim() != ""{
//                queryDoc.append(self.txtUpload.text ?? "")
//            }
//
//            self.viewModel.apiAddSupportQuestion(withLoader: true,
//                                                 query_reason_master_id: queryId.first?.queryReasonMasterId ?? "",
//                                                 description: self.txtvDes.text ?? "",
//                                                 query_docs: queryDoc) { (isDone) in
//                if isDone{
//                    var obj = JSON()
//                    obj["isDone"] = true
//                    self.dismissPopUp(true, objAtIndex: obj)
//                }
//            }
            
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        WebengageManager.shared.navigateScreenEvent(screen: .PostQuestion)
        
        if self.askExpertListVM.getCountTopicList() == 0 {
            self.askExpertListVM.apiCallFromStart_TopicList(refreshControl: nil, colView: self.colView, withLoader: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: -------------------------- UITableView Methods --------------------------
extension AskExpertQuestionVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrDocumentList.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : AskExpertQuestionImageCell = tableView.dequeueReusableCell(withClass: AskExpertQuestionImageCell.self, for: indexPath)
        let object = self.viewModel.arrDocumentList[indexPath.row]
        cell.lblTitle.text = object.title
        
        if object.isImage {
            cell.imgTitle.image = UIImage(named: "image-upload")
        }
        else {
            cell.imgTitle.image = UIImage(named: "pdf_ic")
        }
        
        cell.btnDelete.addTapGestureRecognizer {
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

//MARK: -------------------------- Empty TableView Methods --------------------------
extension AskExpertQuestionVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        var text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        if scrollView == self.tblView {
            text = self.strErrorMessage
        }
        else if scrollView == self.colView {
            text = self.strErrorMessageTopicList
        }
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension AskExpertQuestionVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colView:
            return self.askExpertListVM.getCountTopicList()
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case self.colView:
            let cell : DiscoverEngageTopicCell = collectionView.dequeueReusableCell(withClass: DiscoverEngageTopicCell.self, for: indexPath)
            
            let obj = self.askExpertListVM.getObjectTopicList(index: indexPath.item)

            cell.imgTitle.image = UIImage()
            cell.imgTitle.isHidden = true
            if obj.imageUrl.trim() != "" {
                cell.imgTitle.isHidden = false
                cell.imgTitle.setCustomImage(with: obj.imageUrl)
            }

            cell.lblTitle.text = obj.name
            cell.vwBg.backgroundColor = UIColor.hexStringToUIColor(hex: obj.colorCode)

            cell.vwBg.backGroundColor(color: UIColor.themeBlack.withAlphaComponent(0.2))
            if obj.isSelected {
                cell.vwBg.backGroundColor(color: UIColor.init(hexString: obj.colorCode))
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colView:
            self.askExpertListVM.manageSelectionTopicList(index: indexPath.item)
            self.colView.reloadData()
            
            break
        
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colView:
            let obj = self.askExpertListVM.getObjectTopicList(index: indexPath.item)
            let width       = obj.name.width(withConstraintedHeight: 18.0, font: UIFont.customFont(ofType: .medium, withSize: 12))
            let height      = CGFloat(40)
            
            return CGSize(width: width + 60,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: -------------------------- Observers Methods --------------------------
extension AskExpertQuestionVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblViewHeight.constant = newvalue.height
        }
        
        if let obj = object as? UICollectionView, obj == self.colView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.colViewHeight.constant = newvalue.height
        }
   
    }
    
    func addObserverOnHeightTbl() {
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.colView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblView else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let colView = self.colView else {return}
        if let _ = colView.observationInfo {
            colView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension AskExpertQuestionVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        switch textField {
//
//
//        case self.txtUpload:
////            let documentPicker = UIDocumentPickerViewController(documentTypes:["public.item"], in: .import)
////            documentPicker.delegate = self
////            documentPicker.allowsMultipleSelection = false
////
////            self.present(documentPicker, animated: true, completion: nil)
//            DispatchQueue.main.async {
//                ImagePickerController(isAllowEditing: true) { [weak self] (pickedImage) in
//
//                    guard let self = self else {return}
//
//
//                    self.viewModel.attachnmentUploadSetup(image: pickedImage, document: nil) { (isDone, title) in
//                        if isDone{
//                            //self.selectedImage
//                            DispatchQueue.main.async {
//                                self.txtUpload.text = title
//                                self.view.endEditing(true)
//                            }
//
//                        }
//                    }
//
//                }.present()
//            }
//
//            return false
//
//        default:
//            break
//        }
        
        return true
    }
}

//MARK: -------------------- DocumentPicker Methods --------------------
extension AskExpertQuestionVC : UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        GFunction.shared.allowedFileSize(sizeInKb: Int(url.fileSize/1000)) { isAllowed in
            if isAllowed{
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
        
        self.view.endEditing(true)
        //controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.view.endEditing(true)
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK: -------------------- setdata Methods --------------------
extension AskExpertQuestionVC {
    
    func setData(){
        if self.object.title != nil {
            self.txtQusetion.text = self.object.title
            
            self.askExpertListVM.arrListTopicList = self.askExpertListVM.arrListTopicList.filter({ obj in
                for item in self.object.topics {
                    if item.topicMasterId == obj.topicMasterId {
                        obj.isSelected = true
                    }
                }
                return true
            })
            self.colView.reloadData()
            
            for item in self.object.documents {
                self.viewModel.arrDocumentList.append(DocumentData(title: item.media,
                                                                   urlPath: "",
                                                                   isImage: item.mediaType == "Photo" ? true : false,
                                                                   image: nil))
            }
            self.tblView.reloadData()
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension AskExpertQuestionVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        self.askExpertListVM.vmResultTopicList.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                
                DispatchQueue.main.async {
                    if self.askExpertListVM.arrListTopicList.count > 0 {
                        self.colView.isHidden = false
                    }
                    else {
                        self.colView.isHidden = false
                        
                        if self.kMaxReloadAttempTopic < kMaxReloadAttemp {
                            self.kMaxReloadAttempTopic += 1
                            self.askExpertListVM.apiCallFromStart_TopicList(refreshControl: nil, colView: self.colView, withLoader: false)
                        }
                    }
                    self.strErrorMessageTopicList = self.askExpertListVM.strErrorMessageTopicList
                    self.colView.reloadData()
                    self.setData()
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                
//                var obj = JSON()
//                obj["isDone"].stringValue = "yes"
                self.dismissPopUp(true, objAtIndex: self.viewModel.object)
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

