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

class AskExpertTopicCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var imgTitle     : UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!
    
    //MARK:- Class Variable
    var arrData = [JSON]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.lblTitle.font(name: .medium, size: 12)
//            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            //    .backGroundColor(color: UIColor.themeLightGray)
        }
    }
}

//MARK: -------------------------  UIViewController -------------------------
class AskExpertQuestionDetailsVC : UIViewController {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var scrollMain           : UIScrollView!
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var vwShadow             : UIView!
    @IBOutlet weak var lblTitleTop          : UILabel!
    
    @IBOutlet weak var colMedia             : UICollectionView!
    @IBOutlet weak var pageControlMedia     : AdvancedPageControlView!
    
    @IBOutlet weak var lblQuestion          : UILabel!
    @IBOutlet weak var lblQuestionTime      : UILabel!
    @IBOutlet weak var btnBookmarkQuestion  : UIButton!
    @IBOutlet weak var btnQuestionMore      : UIButton!
    @IBOutlet weak var btnReportQuestion    : UIButton!
    
    @IBOutlet weak var btnAnsThis           : UIButton!
    
    //for top ans
    @IBOutlet weak var stackTopAns          : UIStackView!
    @IBOutlet weak var lblTopAnsTitle       : UILabel!
    @IBOutlet weak var lblTopAnsTime        : UILabel!
    @IBOutlet weak var lblTopAnsDesc        : UILabel!
    @IBOutlet weak var btnFullAns           : UIButton!
    @IBOutlet weak var btnTopAnsMore        : UIButton!
    
    @IBOutlet weak var stackAnsTag          : UIStackView!
    @IBOutlet weak var vwAnsTag             : UIView!
    @IBOutlet weak var lblAnsTag            : UILabel!
    
    @IBOutlet weak var btnLikeAns           : UIButton!
    @IBOutlet weak var btnReportAns         : UIButton!
    @IBOutlet weak var btnCommentAns        : UIButton!
    
    @IBOutlet weak var lblLikeAnsCount      : UILabel!
    @IBOutlet weak var lblCommentAnsCount   : UILabel!
    
    //For all bottom answers
    @IBOutlet weak var vwAnsParent          : UIView!
    @IBOutlet weak var tblAns               : UITableView!
    @IBOutlet weak var tblAnsHeight         : NSLayoutConstraint!
    
    //For read
    @IBOutlet weak var vwTotalAns           : UIView!
    @IBOutlet weak var lblTotalAns          : UILabel!
    @IBOutlet weak var btnSelectTotalAns    : UIButton!
    
    
    //For topic
    @IBOutlet weak var vwTopic                  : UIView!
//    @IBOutlet weak var lblTopic               : UILabel!
    @IBOutlet weak var colTopic                 : UICollectionView!
    @IBOutlet weak var colTopicHeight           : NSLayoutConstraint!
 
    //MARK:- Class Variable
    var videoUrl: URL?
    var player: AVPlayer?
    let avPVC = AVPlayerViewController()
    
    let viewModel                       = AskExpertQuestionDetailsVM()
    let viewModelReport                 = ReportCommentPopupVM()
    let askExpertListVM                 = AskExpertListVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    var object                          = AskExpertListModel()
    var contentMasterId                 = ""
    var completionHandler: ((_ obj : AskExpertListModel?) -> Void)?
    
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
        
//        self.viewModel
    }
    
    func configureUI(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.scrollMain.delegate = self
            self.colMedia.layoutIfNeeded()
            self.colMedia.cornerRadius(cornerRadius: 10)
            self.setup(colView: self.colMedia)
            self.setup(colView: self.colTopic)
            
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            
            self.vwTopic.layoutIfNeeded()
//            self.vwTopic.cornerRadius(cornerRadius: 6)
//            self.vwTopic.backGroundColor(color: UIColor.themeLightGray)
            
            self.btnAnsThis.layoutIfNeeded()
            self.btnAnsThis.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.vwAnsTag.layoutIfNeeded()
            self.vwAnsTag.cornerRadius(cornerRadius: 5)
            
            self.vwShadow.layoutIfNeeded()
            self.vwShadow.cornerRadius(cornerRadius: 10)
            self.vwShadow.themeShadow()
        }
    }
    
    func applyStyle() {
    
        //for questions
        self.lblQuestion
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblQuestionTime
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.btnAnsThis
            .font(name: .regular, size: 10)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblAnsTag
            .font(name: .regular, size: 10)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblTopAnsTitle
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblTopAnsTime
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblTopAnsDesc
            .font(name: .light, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.btnFullAns
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblLikeAnsCount
            .font(name: .light, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblCommentAnsCount
            .font(name: .light, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        //for total ans
        self.lblTotalAns
            .font(name: .regular, size: 10)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.setup(tblView: self.tblAns)
        self.setup(colView: self.colMedia)
        self.pageControlMedia.drawer = ExtendedDotDrawer.init(numberOfPages: 0,
                                                         height: self.pageControlMedia.frame.height, width: 12, space: 5, raduis: self.pageControlMedia.frame.height / 2, currentItem: 0, indicatorColor: UIColor.themePurple, dotsColor: UIColor.themePurple.withAlphaComponent(0.5), isBordered: false, borderColor: UIColor.clear, borderWidth: 0, indicatorBorderColor: UIColor.clear, indicatorBorderWidth: 0)
        
        
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
    
    func setup(colView: UICollectionView){
        colView.delegate                   = self
        colView.dataSource                 = self
        colView.reloadData()
    }
    
    //MARK: ------------------------- Action Method -------------------------
    func manageActionMethods(){
        self.btnAnsThis.addTapGestureRecognizer {
            let vc = AskExpertAnswerPopupVC.instantiate(fromAppStoryboard: .engage)
            vc.content_master_id        = self.object.contentMasterId
            vc.strQue                   = self.object.title
            vc.modalPresentationStyle   = .overFullScreen
            vc.modalTransitionStyle     = .crossDissolve
            vc.completionHandler = { obj in
                if obj != nil {
                    self.viewModel.question_detailAPI(tblView: self.tblAns,
                                                      withLoader: true,
                                                      content_master_id: self.contentMasterId)
                }
            }
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }
        
        self.btnReportQuestion.addTapGestureRecognizer {
            
            if !self.btnReportQuestion.isSelected {
                let vc = ReportCommentPopupVC.instantiate(fromAppStoryboard: .engage)
                vc.reportType               = .question
                vc.content_master_id        = self.object.contentMasterId
                //vc.content_type         = self.object.contentType
                //vc.content_comments_id  = self.object.contentCommentsId
                vc.completionHandler = { obj in
                    if obj?.count > 0 {
                        self.object.reported = "Y"
                        self.btnReportQuestion.isSelected = true
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
        
        self.btnReportAns.addTapGestureRecognizer {
            
            if !self.btnReportAns.isSelected {
                let vc = ReportCommentPopupVC.instantiate(fromAppStoryboard: .engage)
                vc.reportType               = .contentComment
                vc.content_master_id        = self.object.topAnswer.contentMasterId
                //vc.content_type         = self.object.contentType
                vc.content_comments_id      = self.object.topAnswer.contentCommentsId
                vc.completionHandler = { obj in
                    if obj?.count > 0 {
                        self.object.topAnswer.reported = "Y"
                        self.btnReportAns.isSelected = true
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
        
        self.btnLikeAns.addTapGestureRecognizer {
            if self.btnLikeAns.isSelected {
                self.btnLikeAns.isSelected = false
                self.object.topAnswer.liked = "N"
                self.object.topAnswer.likeCount -= 1
                
                self.askExpertListVM.update_likesOfAnswersAPI(content_comments_id: self.object.topAnswer.contentCommentsId,
                                                              is_active: "N",
                                                              forComment: false,
                                                              screen: .QuestionDetails) { [weak self] (isDone, msg) in
                    guard let _ = self else {return}
                    if isDone{
                    }
                }
            }
            else {
                self.btnLikeAns.isSelected = true
                self.object.topAnswer.liked = "Y"
                self.object.topAnswer.likeCount += 1
                
                self.askExpertListVM.update_likesOfAnswersAPI(content_comments_id: self.object.topAnswer.contentCommentsId,
                                                              is_active: "Y",
                                                              forComment: false,
                                                              screen: .QuestionDetails) { [weak self] (isDone, msg) in
                    guard let _ = self else {return}
                    if isDone{
                    }
                }
            }
            self.setData()
        }
        
        self.btnQuestionMore.addTapGestureRecognizer {
            let alertMore : UIAlertController = UIAlertController(title: "".localized, message: "", preferredStyle: .actionSheet)
            
            let actionEdit : UIAlertAction = UIAlertAction(title: AppMessages.edit, style: .default) { (action) in
                let vc = AskExpertQuestionVC.instantiate(fromAppStoryboard: .engage)
                vc.object                   = self.object
                vc.modalPresentationStyle   = .overFullScreen
                vc.modalTransitionStyle     = .crossDissolve
                vc.completionHandler        = { obj in
                    if obj != nil {
                        self.object = obj!
                        self.setData()
//                        self.viewModel.question_detailAPI(tblView: self.tblAns,
//                                                          withLoader: true,
//                                                          content_master_id: self.contentMasterId)
                    }
                }
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
            let actionDelete : UIAlertAction = UIAlertAction(title: AppMessages.delete, style: .default) { (action) in
                Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { [weak self] (isDone) in
                    
                    guard let self = self else {return}
                    
                    if isDone {
                        self.askExpertListVM.deleteQuestionAnswersCommentsAPI(content_master_id: self.object.contentMasterId,
                                                                        content_comments_id: "",
                                                                        type: .question) { isDone, msg, obj in
                            
                            if isDone {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
            let actionCancel : UIAlertAction = UIAlertAction(title: AppMessages.cancel, style: .cancel) { (action) in
               
            }
            //alertMore.addAction(actionEdit)
            alertMore.addAction(actionDelete)
            alertMore.addAction(actionCancel)
            UIApplication.topViewController()?.present(alertMore, animated: true, completion: nil)
        }
        
        self.btnTopAnsMore.addTapGestureRecognizer {
            let alertMore : UIAlertController = UIAlertController(title: "".localized, message: "", preferredStyle: .actionSheet)
            
            let actionEdit : UIAlertAction = UIAlertAction(title: AppMessages.edit, style: .default) { (action) in
                let vc = AskExpertAnswerPopupVC.instantiate(fromAppStoryboard: .engage)
                vc.content_master_id        = self.object.topAnswer.contentMasterId
                vc.content_comments_id      = self.object.topAnswer.contentCommentsId
                vc.strQue                   = self.object.title
                vc.strAns                   = self.object.topAnswer.comment
                vc.modalPresentationStyle   = .overFullScreen
                vc.modalTransitionStyle     = .crossDissolve
                vc.completionHandler = { obj in
                    if obj != nil {
                        self.object = obj!
                        self.setData()
                        self.updateAPIData(withLoader: true)
                    }
                }
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
            let actionDelete : UIAlertAction = UIAlertAction(title: AppMessages.delete, style: .default) { (action) in
                Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { [weak self] (isDone) in
                    guard let self = self else {return}
                    
                    if isDone {
                        self.askExpertListVM.deleteQuestionAnswersCommentsAPI(content_master_id: self.object.topAnswer.contentMasterId,
                                                                        content_comments_id: self.object.topAnswer.contentCommentsId,
                                                                        type: .answer) { isDone, msg, obj in
                            
                            if isDone {
                                self.object = obj
                                self.setData()
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
        
        self.stackTopAns.addTapGestureRecognizer {
            let vc = AskExpertAnsDetailsVC.instantiate(fromAppStoryboard: .engage)
            vc.contentMasterId = self.object.contentMasterId
            vc.answer_id = self.object.topAnswer.contentCommentsId
            vc.completionHandler = { obj in
                if obj != nil {
                    if obj!.contentMasterId != nil {
                        
                        //self.viewModel.arrListContentList[indexPath.row] = obj!
                       // self.tblView.reloadData()
                    }
                    else {
                       // self.updateAPIData(withLoader: true)
                    }
                }
                else {
                   // self.updateAPIData(withLoader: true)
                }
            }
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnBookmarkQuestion.addTapGestureRecognizer {
            if self.btnBookmarkQuestion.isSelected {
                self.btnBookmarkQuestion.isSelected = false
                self.object.bookmarked = "N"
                
                GlobalAPI.shared.update_bookmarksAPI(content_master_id: self.object.contentMasterId,
                                                     content_type: "",
                                                     is_active: "N",
                                                     forQuestion: true,
                                                     screen: .QuestionDetails) { [weak self] (isDone, msg) in
                    guard let _ = self else {return}
                    if isDone{
                    }
                }
            }
            else {
                self.btnBookmarkQuestion.isSelected = true
                self.object.bookmarked = "Y"
                
                GlobalAPI.shared.update_bookmarksAPI(content_master_id: self.object.contentMasterId,
                                                     content_type: "",
                                                     is_active: "Y",
                                                     forQuestion: true,
                                                     screen: .QuestionDetails) { [weak self] (isDone, msg) in
                    guard let _ = self else {return}
                    if isDone{
                    }
                }
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
    
        WebengageManager.shared.navigateScreenEvent(screen: .QuestionDetails)
        
        self.vwBg.isHidden = true
        self.viewModel.question_detailAPI(tblView: self.tblAns,
                                          withLoader: true,
                                          content_master_id: self.contentMasterId)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //FIRAnalytics.manageTimeSpent(on: .ContentDetailVC, when: .Disappear, content_master_id: self.object.contentMasterId, content_type: self.object.contentType)
    }
    
}

//MARK: -------------------------- UITableView Methods --------------------------
extension AskExpertQuestionDetailsVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : AskExpertListAllAnsCell = tableView.dequeueReusableCell(withClass: AskExpertListAllAnsCell.self, for: indexPath)
        let object = self.viewModel.getObject(index: indexPath.row)
        
        if object.patientId == UserModel.shared.patientId {
            cell.lblTitle.text          = AppMessages.You
            cell.btnAnsMore.isHidden    = false
            cell.btnReport.isHidden     = true
        }
        else {
            cell.lblTitle.text          = object.username
            cell.btnAnsMore.isHidden    = true
            cell.btnReport.isHidden     = false
        }
        
        cell.lblDesc.text       = object.comment
        
        cell.stackAnsTag.isHidden = false
        cell.lblAnsTag.text = object.userTitle ?? ""
        if object.userType == "P" {
            cell.stackAnsTag.isHidden = true
        }
        else if object.userType == "A" {
            cell.stackAnsTag.isHidden = true
        }
        
        let time = GFunction.shared.convertDateFormate(dt: object.createdAt,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        
        
        cell.lblTime.text               = time.1.timeAgoSince()
        cell.btnReport.isSelected       = object.reported == "N" ? false : true
        cell.btnLike.isSelected         = object.liked == "N" ? false : true
        cell.lblLikeAnsCount.text       = object.likeCount.roundedWithAbbreviations
        cell.lblCommentAnsCount.text    = object.totalComments.roundedWithAbbreviations
        
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
                        self.tblAns.reloadData()
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
                self.askExpertListVM.update_likesOfAnswersAPI(content_comments_id:
                                                                object.contentCommentsId,
                                                              is_active: "N",
                                                              forComment: false,
                                                              screen: .QuestionDetails) { [weak self] (isDone, msg) in
                    guard let _ = self else {return}
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
                                                              forComment: false,
                                                              screen: .QuestionDetails) { [weak self] (isDone, msg) in
                    guard let _ = self else {return}
                    if isDone{
                    }
                }
            }
            self.tblAns.reloadData()
        }
        
        cell.btnAnsMore.addTapGestureRecognizer {
            let alertMore : UIAlertController = UIAlertController(title: "".localized, message: "", preferredStyle: .actionSheet)
            
            let actionEdit : UIAlertAction = UIAlertAction(title: AppMessages.edit, style: .default) { (action) in
                let vc = AskExpertAnswerPopupVC.instantiate(fromAppStoryboard: .engage)
                vc.content_master_id        = object.contentMasterId
                vc.content_comments_id      = object.contentCommentsId
                vc.strQue                   = self.object.title
                vc.strAns                   = object.comment
                vc.modalPresentationStyle   = .overFullScreen
                vc.modalTransitionStyle     = .crossDissolve
                vc.completionHandler = { obj in
                    if obj != nil {
                        self.object = obj!
                        self.setData()
                        self.updateAPIData(withLoader: true)
                    }
                }
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
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
                                self.object = obj
                                self.setData()
                                self.updateAPIData(withLoader: true)
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
        
        cell.vwBg.addTapGestureRecognizer {
            let object = self.object.recentAnswers[indexPath.row]
            let vc = AskExpertAnsDetailsVC.instantiate(fromAppStoryboard: .engage)
            vc.contentMasterId = object.contentMasterId
            vc.answer_id = object.contentCommentsId
            vc.completionHandler = { obj in
                if obj != nil {
                    if obj!.contentMasterId != nil {
                        
                        //self.viewModel.arrListContentList[indexPath.row] = obj!
                        //self.tblView.reloadData()
                    }
                    else {
                        //self.updateAPIData(withLoader: true)
                    }
                }
                else {
                    //self.updateAPIData(withLoader: true)
                }
            }
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
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
extension AskExpertQuestionDetailsVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UICollectionView, obj == self.colTopic, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.colTopicHeight.constant = newvalue.height
        }
        
        if let obj = object as? UITableView, obj == self.tblAns, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblAnsHeight.constant = newvalue.height
        }
   
    }
    
    func addObserverOnHeightTbl() {
        self.colTopic.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblAns.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let colView = self.colTopic else {return}
        if let _ = colView.observationInfo {
            colView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView = self.tblAns else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension AskExpertQuestionDetailsVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colMedia:
            if self.object.documents != nil {
                self.pageControlMedia.numberOfPages = self.object.documents.count
                return self.object.documents.count
            }
            else {
                return 0
            }
        case self.colTopic:
            if self.object.topics != nil {
                return self.object.topics.count
            }
            else {
                return 0
            }
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case self.colMedia:
            let cell : AskExpertListMediaCell = collectionView.dequeueReusableCell(withClass: AskExpertListMediaCell.self, for: indexPath)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                if let media = self.object.documents {
                    if media.count > 0 && indexPath.item < media.count {
                        
                        let object                  = media[indexPath.item]
                        
                        if object.mediaType == "PDF" {
                            cell.imgTitle.isHidden  = true
                            cell.imgDoc.isHidden    = false
                            
                            cell.imgDoc.image           = UIImage(named: "pdf_ic")
                            cell.imgDoc.contentMode     = .center
                            
                            cell.imgDoc.addTapGestureRecognizer {
                                if let url = URL(string: object.imageUrl) {
                                    GFunction.shared.openPdf(url: url)
                                }
                            }
                        }
                        else {
                            //for photo
                            cell.imgTitle.isHidden  = false
                            cell.imgDoc.isHidden    = true
                            
                            cell.imgTitle.contentMode   = .scaleAspectFill
                            cell.imgTitle.setCustomImage(with: object.imageUrl) { img, err, cache, url in
                                if img != nil {
                                    cell.imgTitle.tapToZoom(with: img)
                                }
                            }
                        }
                    }
                }
                //cell.imgTitle.tapToZoom(with: cell.imgTitle.image ?? UIImage())
                
                cell.vwBg.layoutIfNeeded()
                cell.vwBg.cornerRadius(cornerRadius: 10)
                    .borderColor(color: UIColor.ThemeLightGray2, borderWidth: 1)
            }
            
            DispatchQueue.main.async  {
                cell.vwBg.layoutIfNeeded()
                cell.vwBg.cornerRadius(cornerRadius: 10)
                    .borderColor(color: UIColor.ThemeLightGray2, borderWidth: 1)
            }
            
            return cell
          
        case self.colTopic:
            let cell : AskExpertTopicCell = collectionView.dequeueReusableCell(withClass: AskExpertTopicCell.self, for: indexPath)
            
            if self.object.topics != nil {
                
                let object = self.object.topics[indexPath.item]
                
                cell.imgTitle.setCustomImage(with: object.imageUrl)
                cell.lblTitle.font(name: .semibold, size: 10).textColor(color: UIColor.white)
                
                cell.lblTitle.text = object.name
                cell.vwBg.backGroundColor(color: UIColor.init(hexString: object.colorCode))
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colMedia:
            
            break
        
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colMedia:
            //let obj         = self.arrTitle[indexPath.item]
            //let width       = obj["name"].stringValue.width(withConstraintedHeight: 18.0, font: UIFont.customFont(ofType: .semibold, withSize: 18.0))
            self.colMedia.layoutIfNeeded()
            let width       = self.colMedia.frame.size.width / 2.5
            let height      = self.colMedia.frame.size.height
            
            return CGSize(width: width,
                          height: height)
        case self.colTopic:
            
            let width = self.object.topics[indexPath.row].name.widthOfString(usingFont: UIFont.customFont(ofType: .semibold, withSize: 10))
            let height = self.object.topics[indexPath.row].name.heightOfString(usingFont: UIFont.customFont(ofType: .semibold, withSize: 10))
            
            return CGSize(width: width + 40, height: height + 12)
            
        default:
            
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension AskExpertQuestionDetailsVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.colMedia {
            if !decelerate {
                //self.colMedia.scrollToCenter()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.colMedia {
            //self.colMedia.scrollToCenter()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.colMedia {
//            let pageWidth:CGFloat = scrollView.frame.width
//            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
//            //Change the indicator
//            self.pageControl.setPage(Int(currentPage))
            
            let visibleRect = CGRect(origin: self.colMedia.contentOffset, size: self.colMedia.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = self.colMedia.indexPathForItem(at: visiblePoint) {
                self.pageControlMedia.setPage(visibleIndexPath.row)
            }
        }
        
        if scrollView == self.scrollMain {
            let currentOffsetY : CGFloat = scrollView.contentOffset.y
            let maximumOffsetY : CGFloat = scrollView.contentSize.height - scrollView.frame.size.height + 20
            
            //Pagenation Logic for TrendingProfileList
            if maximumOffsetY - currentOffsetY <= 1 {
                if let indexPath = self.tblAns.indexPathForRow(at: scrollView.contentOffset) {
                    self.viewModel.managePagenation(content_master_id: self.contentMasterId,
                                                    top_answer_id: self.object.topAnswer != nil ? self.object.topAnswer.contentCommentsId : "",
                                                    index: self.viewModel.arrListAnsList.count - 1)
                }
            }
        }
    }
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension AskExpertQuestionDetailsVC: WKNavigationDelegate {
    
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
extension AskExpertQuestionDetailsVC {
    
    func setData(){
        self.vwBg.isHidden = false
        //if UserModel.shared.patientId == self.object.
        
        //let type: EngageContentType = EngageContentType.init(rawValue: self.object.contentType) ?? .BlogArticle
        
        self.lblQuestion.text                   = self.object.title
        self.btnReportQuestion.isSelected       = self.object.reported == "N" ? false : true
        self.btnBookmarkQuestion.isSelected     = self.object.bookmarked == "N" ? false : true
        
        let time = GFunction.shared.convertDateFormate(dt: self.object.createdAt,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        
        
        self.lblQuestionTime.text = time.1.timeAgoSince()
        self.lblTotalAns.text = "\(self.object.totalAnswers!)" + " " + AppMessages.Answers
        self.btnSelectTotalAns.isSelected = self.object.isSelected
        
        self.btnQuestionMore.isHidden           = true
        self.btnReportQuestion.isHidden         = false
        if self.object.updatedBy == UserModel.shared.patientId {
            self.btnQuestionMore.isHidden       = false
            self.btnReportQuestion.isHidden     = true
        }
        
        //for media
        //self.colMedia.decelerationRate = UIScrollView.DecelerationRate.normal
        self.colMedia.isHidden = true
        self.pageControlMedia.isHidden = true
        if self.object.documents != nil {
            if self.object.documents.count > 0 {
                self.colMedia.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                    self.colMedia.reloadData()
                }
            }
        }
        
        //for topics
        self.lblTopAnsTitle.isHidden    = true
        self.lblTopAnsTime.isHidden     = true
        self.btnTopAnsMore.isHidden     = true
        self.lblTopAnsDesc.isHidden     = true
        self.btnFullAns.isHidden        = true
        self.btnLikeAns.isHidden        = true
        self.btnReportAns.isHidden      = true
        self.btnCommentAns.isHidden     = true
        self.vwTotalAns.isHidden        = true
        self.vwTopic.isHidden           = true
        
        self.stackTopAns.isHidden       = true
        self.vwAnsParent.isHidden       = true
        self.stackAnsTag.isHidden       = true
        
        if self.object.topics.count > 0 {
            self.vwTopic.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                self.colTopic.reloadData()
            }
        }
        
        //for top ans
        //for top and recent ans
        if let object = self.object.topAnswer, object.comment != nil {
            self.lblTopAnsTitle.isHidden    = false
            self.lblTopAnsTime.isHidden     = false
            self.btnTopAnsMore.isHidden     = false
            self.lblTopAnsDesc.isHidden     = false
            self.btnFullAns.isHidden        = false
            self.btnLikeAns.isHidden        = false
            self.btnReportAns.isHidden      = false
            self.btnCommentAns.isHidden     = false
            self.vwTotalAns.isHidden        = false
            
            self.stackTopAns.isHidden       = false
            self.vwAnsParent.isHidden       = false

            self.lblAnsTag.text = self.object.topAnswer.userTitle ?? ""
            if self.object.topAnswer.userType == "P" {
                self.stackAnsTag.isHidden = true
            }
            else if self.object.topAnswer.userType == "A" {
                self.stackAnsTag.isHidden = true
            }
            
            if object.patientId == UserModel.shared.patientId {
                self.lblTopAnsTitle.text        = AppMessages.You + " (\(AppMessages.TopAnswer))"
                self.btnTopAnsMore.isHidden     = false
                self.btnReportAns.isHidden      = true
            }
            else {
                self.lblTopAnsTitle.text        = object.username + " (\(AppMessages.TopAnswer))"
                self.btnTopAnsMore.isHidden     = true
                self.btnReportAns.isHidden      = false
            }

            self.lblTopAnsDesc.text             = object.comment

            let time = GFunction.shared.convertDateFormate(dt: object.createdAt,
                                                           inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                           status: .NOCONVERSION)

            self.lblTopAnsTime.text         = time.1.timeAgoSince()
            self.btnReportAns.isSelected    = object.reported == "N" ? false : true
            self.btnLikeAns.isSelected      = object.liked == "N" ? false : true
            self.lblLikeAnsCount.text       = object.likeCount.roundedWithAbbreviations
            self.lblCommentAnsCount.text    = object.totalComments.roundedWithAbbreviations
            self.tblAns.reloadData()
        }
        else {
        }

        
//        let time = GFunction.shared.convertDateFormate(dt: self.object.scheduledDate,
//                                                           inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
//                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
//                                                           status: .NOCONVERSION)
//        self.lblDate.text = time.0
        
        
//        if self.object.isCommentSelected {
//            self.btnComment.isSelected      = true
//            self.vwCommentParent.isHidden   = false
//            self.tblComment.reloadData()
//        }
//        else {
//            self.btnComment.isSelected      = false
//            self.vwCommentParent.isHidden   = true
//        }
        
//        self.btnLike.isSelected = object.liked == "N" ? false : true
//        self.btnBookmark.isSelected = object.bookmarked == "N" ? false : true
        
        
        
        //self.lblTitle.isHidden                  = true
       
    }
}

//MARK: -------------------------- Set data Methods --------------------------
extension AskExpertQuestionDetailsVC {
    
    @objc func updateAPIData(withLoader: Bool = false){
        self.strErrorMessage = ""
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
            self.viewModel.pageAnsList = 1
            self.viewModel.apiCallFromStart_AnswerList(refreshControl: self.refreshControl,
                                                       tblView: self.tblAns,
                                                       withLoader: withLoader,
                                                       content_master_id: self.contentMasterId,
                                                       top_answer_id: self.object.topAnswer != nil ? self.object.topAnswer.contentCommentsId : "")
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension AskExpertQuestionDetailsVC {
    
    private func setupViewModelObserver() {
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                
                self.vwBg.isHidden = false
                DispatchQueue.main.async {
                    self.object = self.viewModel.contentDetails
                    self.setData()
                    self.updateAPIData(withLoader: true)
                    
                    var params = [String: Any]()
                    params[AnalyticsParameters.content_master_id.rawValue] = self.object.contentMasterId
//                    params[AnalyticsParameters.content_type.rawValue]      = self.object.contentType
                    FIRAnalytics.FIRLogEvent(eventName: .USER_VIEW_QUESTION,
                                             screen: .QuestionDetails,
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
                    self.tblAns.reloadData()
                }
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
    }
    
}
