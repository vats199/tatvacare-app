//
//  BasicVC.swift
//  Darshan Manojkumar Joshi
//
//  Created by apple on 07/12/18.
//  Copyright © 2018 DMJ. All rights reserved.
//

import UIKit
import WebKit
import AVKit

class AskExpertAnsDetailsCommentCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblTime              : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var btnLike              : UIButton!
    @IBOutlet weak var lblLikeAnsCount      : UILabel!
    
    @IBOutlet weak var btnReport            : UIButton!
    @IBOutlet weak var btnMore              : UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 13)
            .textColor(color: UIColor.themeBlack)
        self.lblTime
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblDesc
            .font(name: .light, size: 11)
            .textColor(color: UIColor.themeBlack)
        self.lblLikeAnsCount
            .font(name: .light, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.0))
        }
    }
}

//MARK: -------------------------  UIViewController -------------------------
class AskExpertAnsDetailsVC : UIViewController {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var scrollMain               : UIScrollView!
    @IBOutlet weak var vwBg                     : UIView!
    @IBOutlet weak var vwShadow                 : UIView!
    @IBOutlet weak var lblTitleTop              : UILabel!
    
    @IBOutlet weak var lblQuestion              : UILabel!
    
    //for ans
    @IBOutlet weak var vwTopAns                 : UIView!
    @IBOutlet weak var lblTopAnsTitle           : UILabel!
    @IBOutlet weak var lblTopAnsTime            : UILabel!
    @IBOutlet weak var lblTopAnsDesc            : UILabel!
    
    //For all bottom answers
    @IBOutlet weak var lblCommentsTitle         : UILabel!
    @IBOutlet weak var vwCommentParent          : UIView!
    @IBOutlet weak var tblComment               : UITableView!
    @IBOutlet weak var tblCommentHeight         : NSLayoutConstraint!
    
    //For comments
    @IBOutlet weak var vwAddComment             : UIView!
    @IBOutlet weak var txtAddComment            : UITextField!
    @IBOutlet weak var btnAddComment            : UIButton!
    
    //MARK:- Class Variable
    var videoUrl: URL?
    var player: AVPlayer?
    let avPVC = AVPlayerViewController()
    
    var objCommentEdit                  = AskExpertAnsCommentModel()
    let viewModel                       = AskExpertAnsDetailsVM()
    let viewModelReport                 = ReportCommentPopupVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    var object                          = AskExpertAnsListModel()
    var askExpertListVM                 = AskExpertListVM()
    var contentMasterId                 = ""
    var answer_id                       = ""
    var completionHandler: ((_ obj : AskExpertAnsListModel?) -> Void)?
    var totalComment                    = 0
    
    var arrTopic : [String] = []
    var arrData: [JSON] = [
        [
            "title": "Strategies that support a person with COPD to remain healthy",
            "desc": "Live session about Strategies that support a person with COPD to remain healthy bt nutritionist Sameer Shah",
            "type": EngageContentType.Webinar.rawValue,
            "date": "10 Sept,2021",
            "time": "3 pm",
            "topic": "COPD Basics",
            "recommend": "Recommmended by Dr Sharma",
            "is_comment_selected": false,
        ],
        [
            "title": "What you can do this COPD day to take better care of your health?",
            "desc": "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore",
            "type": EngageContentType.BlogArticle.rawValue,
            "date": "10 Sept,2021",
            "time": "3 pm",
            "topic": "Trending",
            "recommend": "Recommmended by Dr Sharma",
            "is_comment_selected": false,
        ],
        [
            "title": "What you can do this COPD day to take better care of your health?",
            "desc": "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore",
            "type": EngageContentType.KOLVideo.rawValue,
            "date": "10 Sept,2021",
            "time": "3 pm",
            "topic": "Medication & Vitals",
            "recommend": "Recommmended by Dr Sharma",
            "is_comment_selected": false,
        ],
        [
            "title": "Dr Patel explains how to deal with season change",
            "desc": "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore",
            "type": EngageContentType.Video.rawValue,
            "date": "10 Sept,2021",
            "time": "3 pm",
            "topic": "COPD Basics",
            "recommend": "Recommmended by Dr Sharma",
            "is_comment_selected": false,
        ],
        [
            "title": "Dr Patel explains how to deal with season change",
            "desc": "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore",
            "type": EngageContentType.Photo.rawValue,
            "date": "10 Sept,2021",
            "time": "3 pm",
            "topic": "Diet",
            "recommend": "Recommmended by Dr Sharma",
            "is_comment_selected": false,
        ]
    ]
    
    //MARK: ------------------------- Memory Management Method -------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    func setUpView() {
        self.applyStyle()
        self.configureUI()
        self.addObserverOnHeightTbl()
        self.setupViewModelObserver()
    }
    
    func configureUI(){
        
        self.scrollMain.delegate = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            
            self.vwTopAns.layoutIfNeeded()
            self.vwTopAns.backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.02))
            
            self.vwAddComment.layoutIfNeeded()
            self.vwAddComment.cornerRadius(cornerRadius: 5)
            self.vwAddComment.backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.09))
            
            self.vwShadow.layoutIfNeeded()
            self.vwShadow.cornerRadius(cornerRadius: 10)
                .themeShadow()
        }
    }
    
    func applyStyle() {
    
        //for questions
        self.lblQuestion
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        
        self.lblTopAnsTitle
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblTopAnsTime
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblTopAnsDesc
            .font(name: .light, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblCommentsTitle
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        //for comments
        self.txtAddComment
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack)
        
        self.setup(tblView: self.tblComment)
        self.manageActionMethods()
    }
    
    func setup(tblView: UITableView){
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
//        tblView.emptyDataSetSource         = self
//        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        tblView.addSubview(self.refreshControl)
    }
    
    //MARK: ------------------------- Action Method -------------------------
    func manageActionMethods(){
        self.btnAddComment.addTapGestureRecognizer {
            if self.txtAddComment.text!.trim() != "" {
                self.viewModel.update_commentAPI(answer_id: self.answer_id,
                                                 content_master_id: self.contentMasterId,
                                                 description: self.txtAddComment.text!,
                                                 isEdit: self.objCommentEdit.contentCommentsId == nil ? false : true,
                                                 content_comments_id: self.objCommentEdit.contentCommentsId ?? "") { [weak self] isDone, obj in
                    guard let self = self else {return}
                    
                    if isDone {
                        self.txtAddComment.text = ""
                        
                        if obj.comment != nil {
                            if self.objCommentEdit.contentCommentsId != nil {
                                let index = self.viewModel.arrList.firstIndex { obj in
                                    return obj.contentCommentsId == self.objCommentEdit.contentCommentsId
                                }
                                self.viewModel.arrList[index!] = obj
                                self.tblComment.reloadData()
                                self.objCommentEdit = AskExpertAnsCommentModel()
                            }
                            else {
                                self.viewModel.arrList.insert(obj, at: 0)
                                self.tblComment.reloadData()
                                self.object.totalComments! += 1
                                self.totalComment               = self.object.totalComments!
                                self.lblCommentsTitle.text = AppMessages.Comments + "( \(self.totalComment) )"
                            }
                        }
                        else {
                            self.updateAPIData(withLoader: true)
                        }
                    }
                }
            }
            else {
                self.txtAddComment.text = ""
            }
        }
    }
    
    @IBAction func btnBackTapped(sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            if let completion = self.completionHandler {
                if self.object.liked != nil {
                    completion(self.object)
                }
            }
        }
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    
        WebengageManager.shared.navigateScreenEvent(screen: .AnswerDetails)
        
        self.vwBg.isHidden = true
        self.viewModel.answer_detailAPI(tblView: self.tblComment,
                                        withLoader: true,
                                        content_comments_id: self.answer_id)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .AskAnExpert, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //FIRAnalytics.manageTimeSpent(on: .ContentDetailVC, when: .Disappear, content_master_id: self.object.contentMasterId, content_type: self.object.contentType)
    }
    
}

//MARK: -------------------------- UITableView Methods --------------------------
extension AskExpertAnsDetailsVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.object.comment != nil {
//            //return self.object.comment.commentData.count
//            return 20
//        }
//        else {
//            return 0
//        }
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : AskExpertAnsDetailsCommentCell = tableView.dequeueReusableCell(withClass: AskExpertAnsDetailsCommentCell.self, for: indexPath)
        
        let object = self.viewModel.getObject(index: indexPath.row)
        
        if object.patientId == UserModel.shared.patientId {
            cell.lblTitle.text          = AppMessages.You
            cell.btnMore.isHidden       = false
            cell.btnReport.isHidden     = true
        }
        else {
            cell.lblTitle.text          = object.username
            cell.btnMore.isHidden       = true
            cell.btnReport.isHidden     = false
        }
        
        cell.lblDesc.text       = object.comment
        
        let time = GFunction.shared.convertDateFormate(dt: object.createdAt,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        
        cell.lblTime.text               = time.1.timeAgoSince()
        cell.btnReport.isSelected       = object.reported == "N" ? false : true
        cell.btnLike.isSelected         = object.liked == "N" ? false : true
        cell.lblLikeAnsCount.text       = object.likeCount.roundedWithAbbreviations
        cell.vwBg.backGroundColor(color: UIColor.white)
        
        cell.btnReport.addTapGestureRecognizer {
            
            if !cell.btnReport.isSelected {
                let vc = ReportCommentPopupVC.instantiate(fromAppStoryboard: .engage)
                vc.reportType               = .contentComment
                vc.content_master_id        = object.contentMasterId
                //vc.content_type         = self.object.contentType
                vc.content_comments_id      = object.contentCommentsId
                vc.completionHandler = { obj in
                    if obj?.count > 0 {
                        object.reported = "Y"
                        self.tblComment.reloadData()
                    }
                }
                let nav: UINavigationController = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
            }
            else {
                
            }
        }
        
        cell.btnLike.addTapGestureRecognizer {
            if cell.btnLike.isSelected {
                cell.btnLike.isSelected = false
                object.liked = "N"
                object.likeCount -= 1
                self.askExpertListVM.update_likesOfAnswersAPI(content_comments_id: object.contentCommentsId,
                                                              is_active: "N",
                                                              forComment: true,
                                                              screen: .AnswerDetails) { [weak self] (isDone, msg) in
                    guard let self = self else {return}
                    if isDone{
                    }
                }
            }
            else {
                cell.btnLike.isSelected = true
                object.liked = "Y"
                object.likeCount += 1
                self.askExpertListVM.update_likesOfAnswersAPI(content_comments_id: object.contentCommentsId,
                                                              is_active: "Y",
                                                              forComment: true,
                                                              screen: .AnswerDetails) { [weak self] (isDone, msg) in
                    guard let self = self else {return}
                    if isDone{
                    }
                }
            }
            self.tblComment.reloadData()
        }
        
        cell.btnMore.addTapGestureRecognizer {
            let alertMore : UIAlertController = UIAlertController(title: "".localized, message: "", preferredStyle: .actionSheet)
            
            let actionEdit : UIAlertAction = UIAlertAction(title: AppMessages.edit, style: .default) { (action) in
                self.objCommentEdit         = object
                self.txtAddComment.text     = self.objCommentEdit.comment
                self.txtAddComment.becomeFirstResponder()
            }
            let actionDelete : UIAlertAction = UIAlertAction(title: AppMessages.delete, style: .default) { (action) in
                Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { [weak self] (isDone) in
                    
                    guard let self = self else {return}
                    
                    if isDone {
                        self.askExpertListVM.deleteQuestionAnswersCommentsAPI(content_master_id: object.contentMasterId,
                                                                        content_comments_id: object.contentCommentsId,
                                                                              type: .answer) { [weak self] isDone, msg, obj in
                            guard let self = self else {return}
                            
                            if isDone {
                                self.viewModel.arrList.remove(at: indexPath.row)
                                self.tblComment.reloadData()
                                self.object.totalComments! -= 1
                                self.totalComment               = self.object.totalComments!
                                self.lblCommentsTitle.text = AppMessages.Comments + "( \(self.totalComment) )"
                            }
                        }
                    }
                }
            }
            let actionCancel : UIAlertAction = UIAlertAction(title: AppMessages.cancel, style: .cancel) { (action) in
               
            }
            alertMore.addAction(actionEdit)
            alertMore.addAction(actionDelete)
            alertMore.addAction(actionCancel)
            UIApplication.topViewController()?.present(alertMore, animated: true, completion: nil)
        }
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension AskExpertAnsDetailsVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.tblComment, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblCommentHeight.constant = newvalue.height
        }
   
    }
    
    func addObserverOnHeightTbl() {
        self.tblComment.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.tblComment else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension AskExpertAnsDetailsVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollMain {
            let currentOffsetY : CGFloat = scrollView.contentOffset.y
            let maximumOffsetY : CGFloat = scrollView.contentSize.height - scrollView.frame.size.height + 20
            
            //Pagenation Logic for TrendingProfileList
            if maximumOffsetY - currentOffsetY <= 1 {
                if let indexPath = self.tblComment.indexPathForRow(at: scrollView.contentOffset) {
                    self.viewModel.managePagenation(tblView: self.tblComment,
                                                    withLoader: false, answer_id: self.answer_id,
                                                    index: self.viewModel.arrList.count - 1)
                }
            }
        }
    }
    
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension AskExpertAnsDetailsVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //self.webViewDesc.frame.size.height = 1
        //        self.webViewDesc.frame.size = webView.scrollView.contentSize
        //self.webViewDescHeight.constant = webView.scrollView.contentSize.height
//        self.webViewDesc.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
//            if complete != nil {
//                self.webViewDesc.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
//                    self.webViewDescHeight.constant = height as! CGFloat
//                })
//            }
//        })
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\(navigation.debugDescription)")
    }
    
}

//MARK: -------------------------- Set data Methods --------------------------
extension AskExpertAnsDetailsVC {
    
    func setData(){
        self.vwBg.isHidden = false
     
        self.lblQuestion.text = self.viewModel.askExpertListModel.title
        
        if self.object.patientId == UserModel.shared.patientId {
            self.lblTopAnsTitle.text    = AppMessages.You
//            self.btnAnsMore.isHidden    = false
        }
        else {
            self.lblTopAnsTitle.text    = self.object.username
//            cell.btnAnsMore.isHidden    = true
        }
        
        self.lblTopAnsDesc.text         = self.object.comment
        self.totalComment               = self.object.totalComments!
        self.lblCommentsTitle.text      = AppMessages.Comments + "( \(self.totalComment) )"
        
        let time = GFunction.shared.convertDateFormate(dt: object.createdAt,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        
        self.lblTopAnsTime.text           = time.1.timeAgoSince()
//        self.btnReport.isSelected   = object.reported == "N" ? false : true
//        self.btnLike.isSelected     = object.liked == "N" ? false : true
        self.vwBg.backGroundColor(color: UIColor.white)
        self.tblComment.reloadData()
    }
}

//MARK: -------------------------- Set data Methods --------------------------
extension AskExpertAnsDetailsVC {
    
    @objc func updateAPIData(withLoader: Bool = false){
        self.strErrorMessage = ""
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
            
            self.viewModel.page = 1
            self.viewModel.apiCallFromStart_AnswerList(refreshControl: self.refreshControl,
                                                       tblView: self.tblComment,
                                                       withLoader: withLoader,
                                                       answer_id: self.answer_id)
            
        }
       
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension AskExpertAnsDetailsVC {
    
    private func setupViewModelObserver() {
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                
                DispatchQueue.main.async {
                    self.object = self.viewModel.askExpertAnsModel
                    self.setData()
                    self.updateAPIData(withLoader: true)
                    
                    var params = [String: Any]()
                    params[AnalyticsParameters.content_comments_id.rawValue]  = self.object.contentCommentsId
                    FIRAnalytics.FIRLogEvent(eventName: .USER_VIEW_ANSWER,
                                             screen: .AnswerDetails,
                                             parameter: params)
                }
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
        self.viewModel.vmResultAnsList.bind(observer: { (result) in
            switch result {
            case .success(_):
                
                DispatchQueue.main.async {
                    self.tblComment.reloadData()
                }
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
    }
    
}

