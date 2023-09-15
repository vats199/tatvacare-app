

import UIKit
import IQKeyboardManagerSwift

class CommentListCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblDesc      : UILabel!
    @IBOutlet weak var lblTime      : UILabel!
    @IBOutlet weak var btnReport    : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack)
        self.lblTime.font(name: .regular, size: 10)
            .textColor(color: UIColor.themeGray)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
        }
    }
}

class CommentListVC: WhiteNavigationBaseVC {

    //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var tblView          : UITableView!
    
    @IBOutlet weak var vwCommentParent  : UIView!
    @IBOutlet weak var vwComment        : UIView!
    @IBOutlet weak var tvComment        : IQTextView!
    @IBOutlet weak var btnSend          : UIButton!
    @IBOutlet weak var btnMoveTop       : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = CommentListVM()
    let viewModelReport             = ReportCommentPopupVM()
    let refreshControl              = UIRefreshControl()
    var arrDaysOffline              = [LanguageListModel]()
    var isEdit                      = false
    var content_master_id           = ""
    var content_type                = ""
    var strErrorMessage : String    = ""
    var totalComment                = 0
    
    var completionHandler: ((_ obj : LanguageListModel) -> Void)?
    //Language: English, Hindi, Kannada
    var arrLanguage : [JSON] = [
        [
            "name" : "English",
            "isSelected": 1,
        ],[
            "name" : "Hindi",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ]
    ]
    
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        self.configureUI()
        self.manageActionMethods()
        
        self.btnSend
            .font(name: .bold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.tvComment
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.tvComment.delegate = self
    }
    
    @objc func updateAPIData(){
        self.strErrorMessage = ""
        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                        tblView: self.tblView,
                                        content_master_id: self.content_master_id,
                                        withLoader: false)
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
    
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
           
        DispatchQueue.main.async {
            self.vwComment.layoutIfNeeded()
            self.vwComment.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        self.btnSend.addTapGestureRecognizer {
            if self.tvComment.text!.trim() != "" {
                PlanManager.shared.isAllowedByPlan(type: .commenting_on_articles,
                                                   sub_features_id: "",
                                                   completion: { isAllow in
                    if isAllow{
                        self.viewModel.update_commentAPI(content_master_id: self.content_master_id,
                                                         content_type: self.content_type,
                                                         comment: self.tvComment.text!.trim(), content_comments_id: "",
                                                         screen: .CommentList) { [weak self] (isDone, obj) in
                            guard let self = self else {return}
                            
                            if isDone {
                                self.tvComment.text = ""
                                //self.updateAPIData()
                                if obj.comment != nil {
                                    if obj.comment.commentData.count > 0 {
                                        self.viewModel.arrList.insert(obj.comment.commentData[0], at: 0)
                                        self.tblView.reloadData()
                                        self.totalComment += 1
                                        self.lblTitle.text = "Comments(\(self.totalComment))"
                                    }
                                }
                            }
                        }
                    }
                    else {
                        self.tvComment.text = ""
                        PlanManager.shared.alertNoSubscription()
                    }
                })
            }
            else {
                self.tvComment.text = ""
            }
        }
    }
    
    @IBAction func btnMoveTopTapped(sender: UIButton){
        self.tblView.scrollToTop()
    }
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
        self.addKeyboardObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .CommentList)
        IQKeyboardManager.shared.enable = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.viewModel.apiCallFromStart(tblView: self.tblView,
                                        content_master_id: self.content_master_id,
                                        withLoader: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension CommentListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : CommentListCell = tableView.dequeueReusableCell(withClass: CommentListCell.self, for: indexPath)
        
        let obj = self.viewModel.getObject(index: indexPath.row)
        cell.lblTitle.text = obj.commentedBy
        cell.lblDesc.text = obj.comment
        
//        let time = GFunction.shared.convertDateFormate(dt: obj.updatedAt,
//                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
//                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
//                                                       status: .LOCAL)
        
        let time = GFunction.shared.convertDateFormate(dt: obj.updatedAt,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        
        
        cell.lblTime.text = time.1.timeAgoSince()
        
        cell.btnReport.isHidden = false
        cell.vwBg.backGroundColor(color: UIColor.white)
        if obj.patientId == UserModel.shared.patientId {
            cell.btnReport.isSelected = false
            cell.btnReport.setImage(UIImage(named: "ic_delete_comment"), for: .normal)
            //cell.vwBg.backGroundColor(color: UIColor.themeLightPurple.withAlphaComponent(0.5))

            //cell.btnReport.isHidden = true
            //cell.vwBg.backGroundColor(color: UIColor.themeLightPurple.withAlphaComponent(0.3))

        }
        else{
            cell.btnReport.isSelected = obj.reported == "N" ? false : true
            cell.btnReport.setImage(UIImage(named: "report_n"), for: .normal)
            cell.btnReport.setImage(UIImage(named: "report_y"), for: .selected)
        }
        
        cell.btnReport.addTapGestureRecognizer {
            if obj.patientId == UserModel.shared.patientId{
                GlobalAPI.shared.apiDeleteComment(content_comments_id: obj.contentCommentsId,
                                                  screen: .CommentList) { [weak self] isDone, message, data in
                    guard let self = self else {return}
                    if isDone{
//                        self.updateAPIData()
                        self.viewModel.arrList.remove(at: indexPath.row)
                        self.tblView.reloadData()
                        self.totalComment -= 1
                        self.lblTitle.text = "Comments(\(self.totalComment))"
                    }
                }
            }
            else {
                let vc = ReportCommentPopupVC.instantiate(fromAppStoryboard: .engage)
                vc.reportType           = .contentComment
                vc.content_master_id    = obj.contentMasterId
                vc.content_type         = self.content_type
                vc.content_comments_id  = obj.contentCommentsId
                vc.completionHandler = { object in
                    if object?.count > 0 {
                        obj.reported = "Y"
                        self.tblView.reloadData()
                    }
                }
                let nav: UINavigationController = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
            }
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.manageSelection(index: indexPath.row)
        self.tblView.reloadData()
//        let object  = self.arrLanguage[indexPath.row]
//        for i in 0...self.arrLanguage.count - 1 {
//            var obj  = self.arrLanguage[i]
//            obj["isSelected"].intValue = 0
//            if obj["name"].stringValue == object["name"].stringValue {
//                obj["isSelected"].intValue = 1
//            }
//            self.arrLanguage[i] = obj
//        }
//        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let obj = self.viewModel.getObject(index: indexPath.row)
        self.viewModel.managePagenation(tblView: self.tblView,
                                        content_master_id: obj.contentMasterId,
                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension CommentListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension CommentListVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.tvComment {
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.tvComment {
        }
    }
}

//MARK: -------------------- Keyboard Observer --------------------
extension CommentListVC {
    
    func addKeyboardObserver(){
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.tblView.contentInset = UIEdgeInsets(top: 0, left: 0.0, bottom: keyboardHeight, right: 0.0)
            
            if self.viewModel.getCount() > 0 {
//                self.tblView.scrollToRow(at: IndexPath(row: self.viewModel.getCount() - 1, section: 0), at: .bottom, animated: true)
                self.tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            self.vwCommentParent.transform = CGAffineTransform(translationX: 0,
                                                               y: -keyboardHeight + 30)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            //let keyboardRectangle = keyboardFrame.cgRectValue
            //let keyboardHeight = keyboardRectangle.height
            
            self.tblView.contentInset = .zero
            self.vwCommentParent.transform = .identity
        }
    }
}
//MARK: ------------------ UITableView Methods ------------------
extension CommentListVC {
    
    fileprivate func setData(){
        
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension CommentListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.tblView.reloadData()
                
                self.totalComment = Int(self.viewModel.strTotalComment) ?? 0
                self.lblTitle.text = "Comments(\(self.totalComment))"
                
                if self.viewModel.arrList.count > 0 {
                    self.btnMoveTop.isHidden = false
                }
                else {
                    self.btnMoveTop.isHidden = true
                }
                
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
