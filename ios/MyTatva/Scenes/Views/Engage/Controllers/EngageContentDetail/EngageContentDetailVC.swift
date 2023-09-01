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

//MARK: -------------------------  UIViewController -------------------------
class EngageContentDetailVC : UIViewController {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var vwBg                     : UIView!
    @IBOutlet weak var lblTitleTop              : UILabel!
    
    @IBOutlet weak var vwImgTitle               : UIView!
    @IBOutlet weak var imgTitle                 : UIImageView!
    @IBOutlet weak var btnPlay                  : UIButton!
    
    @IBOutlet weak var colMedia                 : UICollectionView!
    @IBOutlet weak var pageControlMedia         : AdvancedPageControlView!
    
    @IBOutlet weak var vwAuthor                 : UIView!
    @IBOutlet weak var vwDateTime               : UIView!
    @IBOutlet weak var lblTitle                 : UILabel!
    @IBOutlet weak var webViewDesc              : WKWebView!
    @IBOutlet weak var webViewDescHeight        : NSLayoutConstraint!
    
    @IBOutlet weak var lblDate                  : UILabel!
    @IBOutlet weak var lblTime                  : UILabel!
    @IBOutlet weak var btnAttending             : UIButton!
    @IBOutlet weak var btnBookSeat              : UIButton!
    
    @IBOutlet weak var btnLike                  : UIButton!
    @IBOutlet weak var btnBookmark              : UIButton!
    @IBOutlet weak var btnShare                 : UIButton!
    @IBOutlet weak var btnComment               : UIButton!
    
    @IBOutlet weak var lblLikeCount             : UILabel!
    
    //For comment
    @IBOutlet weak var vwCommentParent          : UIView!
    @IBOutlet weak var btnViewAllComment        : UIButton!
    @IBOutlet weak var tblComment               : UITableView!
    @IBOutlet weak var tblCommentHeight         : NSLayoutConstraint!
    @IBOutlet weak var vwAddComment             : UIView!
    @IBOutlet weak var txtAddComment            : UITextField!
    @IBOutlet weak var btnAddComment            : UIButton!
    
    
    //For topic
    @IBOutlet weak var vwTopic                  : UIView!
//    @IBOutlet weak var lblTopic               : UILabel!
    @IBOutlet weak var colTopic                 : UICollectionView!
    @IBOutlet weak var colTopicHeight           : NSLayoutConstraint!
    
    //For recommended
    @IBOutlet weak var vwRecommendedParent       : UIView!
    @IBOutlet weak var vwRecommendedDoc          : UIView!
    @IBOutlet weak var lblRecommendedDoc         : UILabel!
    @IBOutlet weak var vwRecommendedHealthCoach  : UIView!
    @IBOutlet weak var lblRecommendedHealthCoach : UILabel!
    
    //For read
    @IBOutlet weak var lblAuthor                : UILabel!
    @IBOutlet weak var vwAuthorLine             : UIView!
    @IBOutlet weak var lblRead                  : UILabel!

    //MARK:- Class Variable
    var videoUrl: URL?
    var player: AVPlayer?
    
    let viewModel                       = CommentListVM()
    let viewModelReport                 = ReportCommentPopupVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    var object                          = ContentListModel()
    var contentMasterId                 = ""
    var completionHandler: ((_ obj : ContentListModel?) -> Void)?
    
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
        self.stopPlayer()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    func setUpView() {
        self.applyStyle()
        self.configureUI()
        self.addObserverOnHeightTbl()
        self.setup(tblView: self.tblComment)
        
    }
    
    func configureUI(){
        
        self.btnShare.isHidden = true
        
        self.webViewDesc.navigationDelegate = self
        self.webViewDesc.scrollView.isScrollEnabled = true
        self.webViewDesc.scrollView.bounces = false
        func getZoomDisableScript() -> WKUserScript {
            let source: String = "var meta = document.createElement('meta');" +
                "meta.name = 'viewport';" +
                "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
                "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
            return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        }
        self.webViewDesc.configuration.userContentController.addUserScript(getZoomDisableScript())
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
          
            self.vwImgTitle.layoutIfNeeded()
            self.vwImgTitle.cornerRadius(cornerRadius: 10)
            
            self.colMedia.layoutIfNeeded()
            self.colMedia.cornerRadius(cornerRadius: 10)
            self.setup(colView: self.colMedia)
            self.setup(colView: self.colTopic)
            
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            
            self.vwTopic.layoutIfNeeded()
//            self.vwTopic.cornerRadius(cornerRadius: 6)
//            self.vwTopic.backGroundColor(color: UIColor.themeLightGray)
            
            self.vwRecommendedDoc.layoutIfNeeded()
            self.vwRecommendedDoc.cornerRadius(cornerRadius: 5)
            self.vwRecommendedDoc.backGroundColor(color: UIColor.themeYellow)
            
            self.vwRecommendedHealthCoach.layoutIfNeeded()
            self.vwRecommendedHealthCoach.cornerRadius(cornerRadius: 5)
            self.vwRecommendedHealthCoach.backGroundColor(color: UIColor.colorHealthCoach)
            
            self.btnBookSeat.layoutIfNeeded()
            self.btnBookSeat.cornerRadius(cornerRadius: 5)
            
            self.vwAddComment.layoutIfNeeded()
            self.vwAddComment.cornerRadius(cornerRadius: 5)
            self.vwAddComment.backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.3))
            
            self.btnPlay.layoutIfNeeded()
            self.btnPlay.themeShadow()
        }
    }
    
    func applyStyle() {
    
        self.lblTitle
            .font(name: .bold, size: 17)
            .textColor(color: UIColor.themeBlack)
        
        self.lblAuthor
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack)
        self.lblRead
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblLikeCount
            .font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblDate
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblTime
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.btnBookSeat
            .font(name: .medium, size: 17)
            .textColor(color: UIColor.white)
        self.btnAttending
            .font(name: .medium, size: 17)
            .textColor(color: UIColor.themePurple)
        
//        self.lblTopic
//            .font(name: .semibold, size: 14)
//            .textColor(color: UIColor.themeBlack)
        self.lblRecommendedDoc
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblRecommendedHealthCoach
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.btnViewAllComment
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themePurple)
        self.txtAddComment
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack)
        
        self.setup(tblView: self.tblComment)
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
        
        self.btnAddComment.addTapGestureRecognizer {
            var screenName:ScreenName = self.getScreenType()
            PlanManager.shared.isAllowedByPlan(type: .commenting_on_articles,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow{
                    if self.txtAddComment.text!.trim() != "" {
                        self.viewModel.update_commentAPI(content_master_id: self.object.contentMasterId,
                                                         content_type: self.object.contentType,
                                                         comment: self.txtAddComment.text!, content_comments_id: "",
                                                         screen: screenName) { [weak self] (isDone, obj) in
                            guard let self = self else {return}
                            
                            
                            if isDone {
                                self.txtAddComment.text = ""
                                self.object = obj
                                self.setData()
                            }
                        }
                    }
                    else {
                        self.txtAddComment.text = ""
                    }
                }
                else {
                    self.txtAddComment.text = ""
                    PlanManager.shared.alertNoSubscription()
                }
            })
            
        }
        
        self.btnComment.addTapGestureRecognizer {
        }
        
        self.btnPlay.addTapGestureRecognizer {
            self.initVideoPlayer()
        }
        
        self.btnViewAllComment.addTapGestureRecognizer {
            let vc = CommentListVC.instantiate(fromAppStoryboard: .engage)
            vc.content_master_id    = self.object.contentMasterId
            vc.content_type         = self.object.contentType
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            
//            PlanManager.shared.isAllowedByPlan(type: .commenting_on_articles,
//                                               sub_features_id: "",
//                                               completion: { isAllow in
//                if isAllow{
//                }
//                else {
//                    PlanManager.shared.alertNoSubscription()
//                }
//            })
        }
        
        self.vwAddComment.addTapGestureRecognizer {
            let vc = CommentListVC.instantiate(fromAppStoryboard: .engage)
            vc.content_master_id    = self.object.contentMasterId
            vc.content_type         = self.object.contentType
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            
//            PlanManager.shared.isAllowedByPlan(type: .commenting_on_articles,
//                                               sub_features_id: "",
//                                               completion: { isAllow in
//                if isAllow{
//                }
//                else {
//                    PlanManager.shared.alertNoSubscription()
//                }
//            })
        }
        
        self.btnShare.addTapGestureRecognizer {
            if self.object.title != nil {
                let msg = """
                \(self.object.title!)

                \(self.object.deepLink!)
                """
                
                GFunction.shared.openShareSheet(this: self, msg: msg)
                GlobalAPI.shared.update_share_countAPI(content_master_id: self.object.contentMasterId) { [weak self] (isDone, msg) in
                    guard let _ = self else {return}
                }
            }
        }
        
        self.btnLike.addTapGestureRecognizer {
            var screenName:ScreenName = self.getScreenType()
            if self.btnLike.isSelected {
                self.object.liked       = "N"
                self.btnLike.isSelected = false
                self.object.noOfLikes -= 1
                
                GlobalAPI.shared.update_likesAPI(content_master_id: self.object.contentMasterId,
                                                 content_type: self.object.contentType,
                                                 is_active: "N",
                                                 screen: screenName) { [weak self] (isDone, msg) in
                    guard let _ = self else {return}
                    if isDone{
                    }
                }
            }
            else {
                self.object.liked       = "Y"
                self.btnLike.isSelected = true
                self.object.noOfLikes += 1
                
                GlobalAPI.shared.update_likesAPI(content_master_id: self.object.contentMasterId,
                                                 content_type: self.object.contentType,
                                                 is_active: "Y",
                                                 screen: screenName) { [weak self] (isDone, msg) in
                    guard let _ = self else {return}
                    if isDone{
                    }
                }
            }
            self.setData()
        }
        
        self.btnBookmark.addTapGestureRecognizer {
            var screenName:ScreenName = self.getScreenType()
            PlanManager.shared.isAllowedByPlan(type: .bookmarks,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow {
                    if self.btnBookmark.isSelected {
                        self.object.bookmarked      = "N"
                        self.btnBookmark.isSelected = false
                        
                        GlobalAPI.shared.update_bookmarksAPI(content_master_id: self.object.contentMasterId,
                                                             content_type: self.object.contentType,
                                                             is_active: "N",
                                                             forQuestion: false,
                                                             screen: screenName) { [weak self] (isDone, msg) in
                            guard let _ = self else {return}
                            if isDone{
                            }
                        }
                    }
                    else {
                        self.object.bookmarked      = "Y"
                        self.btnBookmark.isSelected = true
                        
                        GlobalAPI.shared.update_bookmarksAPI(content_master_id: self.object.contentMasterId,
                                                             content_type: self.object.contentType,
                                                             is_active: "Y",
                                                             forQuestion: false,
                                                             screen: screenName) { (isDone, msg) in
                            if isDone{
                            }
                        }
                    }
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
            
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
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    
        self.vwBg.isHidden = true
        GlobalAPI.shared.content_by_idAPI(content_master_id: self.contentMasterId) { [weak self] (isDone, obj) in
            guard let self = self else {return}
            
            if isDone {
                self.vwBg.isHidden = false
                self.object = obj
                self.setData()
                
                var params = [String: Any]()
                params[AnalyticsParameters.content_master_id.rawValue]  = self.object.contentMasterId
                let screenName = self.getScreenType()
                FIRAnalytics.FIRLogEvent(eventName: FIREventType.USER_VIEW_CONTENT,
                                         screen: screenName,
                                         parameter: params)
                
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .none, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.stopPlayer()
        
        let screenName = self.getScreenType()
        FIRAnalytics.manageTimeSpent(on: screenName,
                                     when: .Disappear,
                                     content_master_id: self.object.contentMasterId,
                                     content_type: self.object.contentType)
        
    }
}

//MARK: -------------------------- UITableView Methods --------------------------
extension EngageContentDetailVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.object.comment != nil {
            return self.object.comment.commentData.count
        }
        else {
            return 0
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : DiscoverEngageCommentCell = tableView.dequeueReusableCell(withClass: DiscoverEngageCommentCell.self, for: indexPath)

        let object          = self.object.comment.commentData[indexPath.row]
        cell.lblTitle.text  = object.commentedBy
        cell.lblDesc.text   = object.comment
        

        cell.btnReport.isHidden = false
        cell.vwBg.backGroundColor(color: UIColor.white)
        if object.patientId == UserModel.shared.patientId {
            cell.btnReport.isSelected = false
            cell.btnReport.setImage(UIImage(named: "ic_delete_comment"), for: .normal)
            //cell.vwBg.backGroundColor(color: UIColor.themeLightPurple.withAlphaComponent(0.3))

        }
        else{
            cell.btnReport.isSelected = object.reported == "N" ? false : true
            cell.btnReport.setImage(UIImage(named: "report_n"), for: .normal)
            cell.btnReport.setImage(UIImage(named: "report_y"), for: .selected)
        }
        
        var screenName:ScreenName = self.getScreenType()
        cell.btnReport.addTapGestureRecognizer {
            if object.patientId == UserModel.shared.patientId{
                GlobalAPI.shared.apiDeleteComment(content_comments_id: object.contentCommentsId,
                                                  screen: screenName) { Status, message, data in
                    if Status{
                        self.object = data
                        self.setData()
                    }
                }
            }
            else {
                let vc = ReportCommentPopupVC.instantiate(fromAppStoryboard: .engage)
                vc.reportType           = .contentComment
                vc.content_master_id    = object.contentMasterId
                vc.content_type         = self.object.contentType
                vc.content_comments_id  = object.contentCommentsId
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
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = CommentListVC.instantiate(fromAppStoryboard: .engage)
        //vc.hidesBottomBarWhenPushed = true
        vc.content_master_id    = self.object.contentMasterId
        vc.content_type         = self.object.contentType
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        
//        PlanManager.shared.isAllowedByPlan(type: .commenting_on_articles,
//                                           sub_features_id: "",
//                                           completion: { isAllow in
//            if isAllow{
//            }
//            else {
//                PlanManager.shared.alertNoSubscription()
//            }
//        })
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension EngageContentDetailVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UICollectionView, obj == self.colTopic, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.colTopicHeight.constant = newvalue.height
        }
        
        if let obj = object as? UITableView, obj == self.tblComment, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblCommentHeight.constant = newvalue.height
        }
   
    }
    
    func addObserverOnHeightTbl() {
        self.colTopic.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblComment.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let colView = self.colTopic else {return}
        if let _ = colView.observationInfo {
            colView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView = self.tblComment else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension EngageContentDetailVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colMedia:
            if self.object.media != nil {
                self.pageControlMedia.numberOfPages = self.object.media.count
                return self.object.media.count
            }
            else {
                return 0
            }
        case self.colTopic:
            return self.arrTopic.count
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case self.colMedia:
            let cell : DiscoverEngageMediaCell = collectionView.dequeueReusableCell(withClass: DiscoverEngageMediaCell.self, for: indexPath)
            
            let object = self.object.media[indexPath.item]
            cell.imgTitle.setCustomImage(with: object.imageUrl) { img, err, cache, url in
                if img != nil {
                    cell.imgTitle.tapToZoom(with: img)
                }
            }
            return cell
          
        case self.colTopic:
            let cell : DiscoverEngageFilterTypeCell = collectionView.dequeueReusableCell(withClass: DiscoverEngageFilterTypeCell.self, for: indexPath)
            cell.vwBg.backGroundColor(color: UIColor.ThemeLightGray2)
            cell.lblTitle.font(name: .semibold, size: 10).textColor(color: UIColor.themeBlack)
            
            cell.lblTitle.text = self.arrTopic[indexPath.row]
            
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
            let width       = self.colMedia.frame.size.width
            let height      = self.colMedia.frame.size.height
            
            return CGSize(width: width,
                          height: height)
        case self.colTopic:
            
            let width = self.arrTopic[indexPath.row].widthOfString(usingFont: UIFont.customFont(ofType: .semibold, withSize: 10))
            let height = self.arrTopic[indexPath.row].heightOfString(usingFont: UIFont.customFont(ofType: .semibold, withSize: 10))
            
            return CGSize(width: width + 16, height: height + 12)
            
        default:
            
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension EngageContentDetailVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.colMedia {
            if !decelerate {
                self.colMedia.scrollToCenter()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.colMedia {
            self.colMedia.scrollToCenter()
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
    }
    
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension EngageContentDetailVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //self.webViewDesc.frame.size.height = 1
        //        self.webViewDesc.frame.size = webView.scrollView.contentSize
        //self.webViewDescHeight.constant = webView.scrollView.contentSize.height
        self.webViewDesc.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webViewDesc.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                    self.webViewDescHeight.constant = height as! CGFloat
                })
            }
        })
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\(navigation.debugDescription)")
    }
    
}
    
//MARK: -------------------------- Video player Methods --------------------------
extension EngageContentDetailVC {
    
    func initVideoPlayer(){
        // 3. make sure the url your using isn't nil
//        self.videoUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")

        
        //self.videoUrl = URL(string: "http://3.7.8.99/hugs_basket/assets/upload/Pexels%20Videos%204697%20(1).mp4")
        
        var params = [String: Any]()
        params[AnalyticsParameters.content_master_id.rawValue] = self.object.contentMasterId
        params[AnalyticsParameters.content_type.rawValue]      = self.object.contentType
        
        let screenName = self.getScreenType()
        FIRAnalytics.FIRLogEvent(eventName: .USER_PLAY_MEDIA_CONTENT,
                                     screen: screenName,
                                     parameter: params)
        
        if self.object.media.count > 0 {
            self.videoUrl = URL(string: self.object.media[0].mediaUrl)
        }
        else {
            Alert.shared.showSnackBar(AppMessages.noVideoData)
            return
        }
        
        guard let videoUrl = videoUrl else {
            Alert.shared.showSnackBar(AppMessages.noVideoData)
            return
        }

        // 4. init an AVPlayer object with the url then set the class property player with the AVPlayer object
        self.player = AVPlayer(url: videoUrl)
        self.player?.play()
        
        // 5. set the class property player to the AVPlayerViewController's player
        avPVC.player?.pause()
        avPVC.player = self.player
        
        // 6. set the the parent vc's bounds to the AVPlayerViewController's frame
        avPVC.view.frame                        = self.vwImgTitle.bounds
        avPVC.showsPlaybackControls             = true
        avPVC.allowsPictureInPicturePlayback    = true
        
        // 7. the parent vc has a method on it: addChildViewController() that takes the child you want to add to it (in this case the AVPlayerViewController) as an argument
        self.addChild(avPVC)
        
        // 8. add the AVPlayerViewController's view as a subview to the parent vc
        self.vwImgTitle.addSubview(avPVC.view)
        
        // 9. on AVPlayerViewController call didMove(toParentViewController:) and pass the parent vc as an argument to move it inside parent
        avPVC.didMove(toParent: self)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    func stopPlayer() {
        avPVC.dismiss(animated: true)
        avPVC.removeFromParent()
        avPVC.view.removeFromSuperview()
        
        if let play = self.player {
            print("stopped")
            play.pause()
            self.player = nil
            print("player deallocated")
        } else {
            print("player was already deallocated")
        }
    }
}

//MARK: -------------------------- Set data Methods --------------------------
extension EngageContentDetailVC {
    
    @objc func updateAPIData(){
        
        GlobalAPI.shared.content_by_idAPI(content_master_id: self.contentMasterId) { [weak self] (isDone, obj) in
            guard let self = self else {return}
            
            if isDone {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                    self.view.layoutIfNeeded()
                    self.colMedia.layoutIfNeeded()
                    self.vwBg.isHidden = false
                    self.object = obj
                    self.setData()
                }
                
            }
            else {
                //self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setData(){
        self.txtAddComment.isUserInteractionEnabled = true
        self.vwCommentParent.isHidden = false
        
        Settings().isHidden(setting: .hide_engage_discover_comments) { isHidden in
            if isHidden {
                self.vwCommentParent.isHidden = true
            }
        }
        
        let type: EngageContentType = EngageContentType.init(rawValue: self.object.contentType) ?? .BlogArticle
        
        self.btnLike.isHidden = object.likeCapability == "No" ? true : false
        self.lblLikeCount.isHidden = object.likeCapability == "No" ? true : false
        
        self.btnBookmark.isHidden = object.bookmarkCapability == "No" ? true : false
        
        self.btnLike.isSelected = self.object.liked == "N" ? false : true
        self.btnBookmark.isSelected = self.object.bookmarked == "N" ? false : true
        
        self.lblLikeCount.text      = self.object.noOfLikes.roundedWithAbbreviations
        
        if self.object.media.count > 0 {
            self.imgTitle.setCustomImage(with: self.object.media[0].imageUrl) { img, err, cache, url in
                if img != nil {
                    if type == .BlogArticle ||
                        type == .Webinar {
                        self.imgTitle.tapToZoom(with: img)
                    }
                }
            }
        }
        
        self.lblTitle.isHidden              = true
        self.webViewDesc.isHidden           = true
        self.btnPlay.isHidden               = true
        
        self.vwDateTime.isHidden            = true
        self.btnBookSeat.isHidden           = true
        self.colMedia.isHidden              = true
        self.pageControlMedia.isHidden      = true
        self.vwImgTitle.isHidden            = true
        self.btnAttending.isHidden          = true
        self.btnBookSeat.isHidden           = true
        self.vwAuthor.isHidden              = true
    
        self.lblTitle.text                  = self.object.title

//        self.lblTopic.text                  = self.object.topicName
        self.arrTopic = self.object.topicName.components(separatedBy: ",")
        self.colTopic.reloadData()
        

        self.lblTitleTop.text               = self.object.title
        
        self.lblAuthor.isHidden             = true
        self.vwAuthorLine.isHidden          = true
        if self.object.author.trim() != "" {
            self.lblAuthor.isHidden         = false
            self.vwAuthorLine.isHidden      = false
            self.lblAuthor.text             = self.object.author
        }
        
        self.lblRead.text                   = "\(self.object.xminReadTime!)" + " " + AppMessages.Min + " " + AppMessages.read
        
        self.webViewDesc.loadHTMLString(self.object.descriptionField.replacingOccurrences(of: """
                                            \"
                                            """, with: """
                                            "
                                            """), baseURL: Bundle.main.bundleURL)

        //"2021-10-18"
        let time = GFunction.shared.convertDateFormate(dt: self.object.scheduledDate,
                                                           inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                           status: .NOCONVERSION)
        
        self.lblDate.text = time.0
        
        switch type {
        
        case .BlogArticle:
            WebengageManager.shared.navigateScreenEvent(screen: .ContentDetailBlog)
            
            self.lblTitle.isHidden              = false
            self.webViewDesc.isHidden           = false
            self.vwImgTitle.isHidden            = false
            self.vwAuthor.isHidden              = false
            
            break
        case .Photo:
            WebengageManager.shared.navigateScreenEvent(screen: .ContentDetailPhotoGallery)
            
            self.lblTitle.isHidden              = false
            self.colMedia.isHidden              = false
            self.pageControlMedia.isHidden      = false
            self.webViewDesc.isHidden           = false
            
            self.colMedia.layoutSubviews()
            self.colMedia.reloadData()
            self.colMedia.layoutIfNeeded()
            
            break
        case .KOLVideo:
            WebengageManager.shared.navigateScreenEvent(screen: .ContentDetailKolVideo)
            self.btnPlay.isHidden               = false
            self.lblTitle.isHidden              = false
            self.webViewDesc.isHidden           = false
            self.vwImgTitle.isHidden            = false
            self.vwAuthor.isHidden              = false
            break
        case .Video:
            WebengageManager.shared.navigateScreenEvent(screen: .ContentDetailNormalVideo)
            self.btnPlay.isHidden               = false
            self.lblTitle.isHidden              = false
            self.webViewDesc.isHidden           = false
            self.vwImgTitle.isHidden            = false
            self.vwAuthor.isHidden              = false
            break
        case .Webinar:
            WebengageManager.shared.navigateScreenEvent(screen: .ContentDetailWebinar)
            self.vwRecommendedDoc.isHidden      = false
            self.vwRecommendedParent.isHidden   = false
            self.vwDateTime.isHidden            = false
            self.btnBookSeat.isHidden           = false
            self.lblTitle.isHidden              = false
            self.webViewDesc.isHidden           = false
            self.vwImgTitle.isHidden            = false
            self.btnAttending.isHidden          = false
            self.btnBookSeat.isHidden           = false
            self.vwAuthor.isHidden              = false
            
            break
        case .ExerciseVideo:
            
            self.navigationController?.popViewController(animated: true)
            if object.media.count > 0 {
                kGoalMasterId = ""
                GFunction.shared.openVideoPlayer(strUrl: self.object.media[0].mediaUrl,
                                                 content_master_id: object.contentMasterId,
                                                 content_type: object.contentType)
                
                var param = [String : Any]()
                param[AnalyticsParameters.content_master_id.rawValue]   = object.contentMasterId
                param[AnalyticsParameters.content_type.rawValue]        = object.contentType
                FIRAnalytics.FIRLogEvent(eventName: .USER_PLAY_VIDEO_EXERCISE,
                                         screen: .VideoPlayer,
                                         parameter: nil)
            }
            break
        }
        
        self.vwRecommendedParent.isHidden       = true
        self.vwRecommendedDoc.isHidden          = true
        self.vwRecommendedHealthCoach.isHidden  = true
        
        if object.recommendedByDoctor == "Yes" &&
        object.recommendedByHealthcoach == "Yes" {
            
            self.vwRecommendedParent.isHidden       = false
            self.vwRecommendedDoc.isHidden          = false
            self.vwRecommendedHealthCoach.isHidden  = false
            
            self.lblRecommendedDoc.text = "Recommended by Doctor"
            self.lblRecommendedHealthCoach.text = "Recommended by Health coach"
            
        }
        else if object.recommendedByDoctor == "Yes" {
            self.vwRecommendedParent.isHidden       = false
            self.vwRecommendedDoc.isHidden          = false
            self.vwRecommendedHealthCoach.isHidden  = true
            
            self.lblRecommendedDoc.text = "Recommended by Doctor"
        }
        else if object.recommendedByHealthcoach == "Yes" {
            self.vwRecommendedParent.isHidden       = false
            self.vwRecommendedDoc.isHidden          = true
            self.vwRecommendedHealthCoach.isHidden  = false
            
            self.lblRecommendedHealthCoach.text = "Recommended by Health coach"
        }
        else {
        }
        self.tblComment.reloadData()
        self.manageCommnetTap()
        self.tblComment.reloadData()
    }
    
    func getScreenType() -> ScreenName {
        if self.object.contentType != nil {
            if let type: EngageContentType = EngageContentType.init(rawValue: self.object.contentType) {
                switch type {
                case .BlogArticle:
                    return .ContentDetailBlog
                case .Photo:
                    return  .ContentDetailPhotoGallery
                case .KOLVideo:
                    return .ContentDetailKolVideo
                case .Video:
                    return .ContentDetailNormalVideo
                case .Webinar:
                    return .ContentDetailWebinar
                case .ExerciseVideo:
                    return .ContentDetailNormalVideo
                }
            }
        }
        return .ContentDetailBlog
    }
    
    func manageCommnetTap(){
        
        self.btnViewAllComment.isHidden = true
        if self.object.comment != nil {
            if self.object.comment.total > 2 {
                self.btnViewAllComment.isHidden = false
                
                let count = GFunction.shared.formatPoints(from: self.object.comment.total)
                self.btnViewAllComment.setTitle("View all \(count) comments", for: .normal)
            }
        }
//        if self.object.isCommentSelected {
//            self.object.isCommentSelected   = false
//            self.btnComment.isSelected      = false
//            self.vwCommentParent.isHidden   = true
//        }
//        else {
//            self.object.isCommentSelected   = true
//            self.btnComment.isSelected      = true
//            self.vwCommentParent.isHidden   = false
//        }
    }

}
