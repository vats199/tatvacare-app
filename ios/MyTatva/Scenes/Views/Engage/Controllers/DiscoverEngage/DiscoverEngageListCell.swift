//
//  DiscoverEngageListCell.swift
//  MyTatva
//
//  Created by Darshan Joshi on 12/10/21.
//

import Foundation

class DiscoverEngageListCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var vwImgTitle           : UIView!
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var btnPlay              : UIButton!
    
    @IBOutlet weak var colMedia             : UICollectionView!
    @IBOutlet weak var pageControlMedia     : AdvancedPageControlView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var stackDateTimeBook    : UIStackView!
    @IBOutlet weak var vwDateTime           : UIView!
    @IBOutlet weak var lblDate              : UILabel!
    @IBOutlet weak var lblTime              : UILabel!
    @IBOutlet weak var btnBookSeat          : UIButton!
    
    @IBOutlet weak var btnLike              : UIButton!
    @IBOutlet weak var btnBookmark          : UIButton!
    @IBOutlet weak var btnShare             : UIButton!
    @IBOutlet weak var btnComment           : UIButton!
    
    @IBOutlet weak var lblLikeCount         : UILabel!
    @IBOutlet weak var lblCommentCount      : UILabel!
    
    //For comment
    @IBOutlet weak var vwCommentParent      : UIView!
    @IBOutlet weak var btnViewAllComment    : UIButton!
    @IBOutlet weak var tblComment           : UITableView!
    @IBOutlet weak var tblCommentHeight     : NSLayoutConstraint!
    @IBOutlet weak var vwAddComment         : UIView!
    @IBOutlet weak var txtAddComment        : UITextField!
    @IBOutlet weak var btnAddComment        : UIButton!
    
    //For topic
    @IBOutlet weak var vwTopic              : UIView!
    @IBOutlet weak var lblTopic             : UILabel!
    
    //For recommended
    @IBOutlet weak var vwRecommended        : UIView!
    @IBOutlet weak var lblRecommended       : UILabel!
    
    //For read
    @IBOutlet weak var vwRead               : UIView!
    @IBOutlet weak var lblRead              : UILabel!
    
    //MARK:- Class Variable
    //var object = ContentListModel()
    
    var object = ContentListModel() {
        didSet {
            self.setCellData()
        }
    }
    var viewModel = CommentListVM()
    var viewModelReport = ReportCommentPopupVM()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addObserverOnHeightTbl()
        self.lblTitle
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack)
        
        self.lblDate
            .font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack)
        self.lblTime
            .font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack)
        self.btnBookSeat
            .font(name: .medium, size: 11)
            .textColor(color: UIColor.white)
        
        self.lblTopic
            .font(name: .semibold, size: 9)
            .textColor(color: UIColor.themeBlack)
        self.lblRecommended
            .font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack)
        
        self.lblRead
            .font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack)
        
        self.lblLikeCount
            .font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblCommentCount
            .font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.btnViewAllComment
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themePurple)
        self.txtAddComment
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            
            self.vwRead.layoutIfNeeded()
            self.vwRead.cornerRadius(cornerRadius: 3)
            self.vwRead.backGroundColor(color: UIColor.themeLightGray.withAlphaComponent(0.4))
            
            self.vwTopic.layoutIfNeeded()
            self.vwTopic.cornerRadius(cornerRadius: 5)
                .themeShadow()
            
            self.vwRecommended.layoutIfNeeded()
            self.vwRecommended.cornerRadius(cornerRadius: 5)
            self.vwRecommended.backGroundColor(color: UIColor.themeYellow)
            
            self.btnBookSeat.layoutIfNeeded()
            self.btnBookSeat.cornerRadius(cornerRadius: 5)
            
            self.vwAddComment.layoutIfNeeded()
            self.vwAddComment.cornerRadius(cornerRadius: 5)
            self.vwAddComment.backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.3))
            
            self.btnPlay.layoutIfNeeded()
            self.btnPlay.themeShadow()
        }
        
        self.setup(tblView: self.tblComment)
        self.setup(colView: self.colMedia)
        self.pageControlMedia.drawer = ExtendedDotDrawer.init(numberOfPages: 0,
                                                         height: self.pageControlMedia.frame.height, width: 12, space: 5, raduis: self.pageControlMedia.frame.height / 2, currentItem: 0, indicatorColor: UIColor.themePurple, dotsColor: UIColor.themePurple.withAlphaComponent(0.5), isBordered: false, borderColor: UIColor.clear, borderWidth: 0, indicatorBorderColor: UIColor.clear, indicatorBorderWidth: 0)
        
        self.manageActionMethods()
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    func setup(tblView: UITableView){
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
    }
    
    func setup(colView: UICollectionView){
        colView.delegate                   = self
        colView.dataSource                 = self
        colView.reloadData()
    }
    
    func setCellData(){
        self.txtAddComment.isUserInteractionEnabled = true
        self.colMedia.decelerationRate = UIScrollView.DecelerationRate.normal
        
        let type: EngageContentType = EngageContentType.init(rawValue: self.object.contentType) ?? .BlogArticle
        
        self.lblTitle.text                      = self.object.title
        self.lblDesc.text                       = self.object.descriptionFieldTemp
        self.object.descriptionFieldTemp        = ""
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.object.descriptionFieldTemp = self.object.descriptionField.htmlToString
                self.lblDesc.text = self.object.descriptionFieldTemp
            }
        }
        
        self.vwTopic.isHidden = true
        if self.object.topicName.trim() != "" {
            self.vwTopic.isHidden = false
            let arr = self.object.topicName.components(separatedBy: ",")
            self.lblTopic.text                  = arr.joined(separator: ", ")
        }
        
        self.lblRead.text                   = "\(self.object.xminReadTime!)" + " " + AppMessages.Min + " " + AppMessages.read
        
        
        self.imgTitle.alpha = 0
        if self.object.media.count > 0 {
            self.imgTitle.alpha = 1
            self.imgTitle.setCustomImage(with: self.object.media[0].imageUrl)
            
            func openDetails(){
                if let vc = self.parentViewController as? DiscoverEngageListVC {
                    if let tbl = self.superview as? UITableView {
                        if let index = tbl.indexPath(for: self) {
                            vc.openContentDetails(index: index.row)
                        }
                    }
                }
            }
            
            self.imgTitle.addTapGestureRecognizer {
                openDetails()
            }
            
            self.colMedia.addTapGestureRecognizer {
                openDetails()
            }
        }
        
        
        let time = GFunction.shared.convertDateFormate(dt: self.object.scheduledDate,
                                                           inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                           status: .NOCONVERSION)
        self.lblDate.text = time.0
        
        self.manageCommnetTap()
//        if self.object.isCommentSelected {
//            self.btnComment.isSelected      = true
//            self.vwCommentParent.isHidden   = false
//            self.tblComment.reloadData()
//        }
//        else {
//            self.btnComment.isSelected      = false
//            self.vwCommentParent.isHidden   = true
//        }
        
        Settings().isHidden(setting: .hide_engage_discover_comments) { isHidden in
            if isHidden {
                self.btnComment.isSelected      = false
                self.btnComment.isHidden        = isHidden
                self.lblCommentCount.isHidden   = isHidden
            }
        }
        
        self.btnLike.isHidden = object.likeCapability == "No" ? true : false
        self.lblLikeCount.isHidden = object.likeCapability == "No" ? true : false
        
        self.btnBookmark.isHidden = object.bookmarkCapability == "No" ? true : false
        
        self.btnLike.isSelected = object.liked == "N" ? false : true
        self.btnBookmark.isSelected = object.bookmarked == "N" ? false : true
        
        self.lblLikeCount.text      = self.object.noOfLikes.roundedWithAbbreviations
        
        self.vwRecommended.layoutIfNeeded()
        self.vwRecommended.isHidden             = true
        var strRecommended = ""
        if self.object.recommendedByDoctor == "Yes" &&
            self.object.recommendedByHealthcoach == "Yes" {
            strRecommended = "Recommended by Doctor & Health coach"
        }
        else if object.recommendedByDoctor == "Yes" {
            strRecommended = "Recommended by Doctor"
        }
        else if object.recommendedByHealthcoach == "Yes" {
            strRecommended = "Recommended by Health coach"
        }
        else {
            strRecommended = ""
        }
        
        if strRecommended.trim() != "" {
            self.vwRecommended.isHidden     = false
            self.lblRecommended.text        = strRecommended
        }
        
        //self.lblTitle.isHidden                  = true
        self.lblDesc.layoutIfNeeded()
        self.lblDesc.isHidden                   = true
        
        self.btnPlay.layoutIfNeeded()
        self.btnPlay.isHidden                   = true
        
        self.vwDateTime.layoutIfNeeded()
        self.vwDateTime.isHidden                = true
        
        self.btnBookSeat.layoutIfNeeded()
        self.btnBookSeat.isHidden               = true
        
        self.vwRead.layoutIfNeeded()
        self.vwRead.isHidden                    = true
        
        self.colMedia.layoutIfNeeded()
        self.colMedia.isHidden                  = true
        
        self.pageControlMedia.layoutIfNeeded()
        self.pageControlMedia.isHidden          = true
        
        self.vwImgTitle.layoutIfNeeded()
        self.vwImgTitle.isHidden                = true
        
        self.stackDateTimeBook.layoutIfNeeded()
        self.stackDateTimeBook.isHidden         = true
        
        switch type {
            
        case .BlogArticle:
            self.vwRead.isHidden                = false
            self.lblDesc.isHidden               = false
            self.vwImgTitle.isHidden            = false
            //self.imgTitle.tapToZoom(with: self.imgTitle.image ?? UIImage())
            break
        case .Photo:
            self.colMedia.isHidden              = false
            DispatchQueue.main.async {
                self.colMedia.reloadData()
            }
            self.colMedia.setNeedsLayout()
            self.colMedia.layoutSubviews()
            self.pageControlMedia.isHidden      = false
            self.lblDesc.isHidden               = false
            break
        case .KOLVideo:
            //thumb and video in media array
            self.btnPlay.isHidden               = false
            self.lblDesc.isHidden               = false
            self.vwImgTitle.isHidden            = false
            break
        case .Video:
            self.btnPlay.isHidden               = false
            self.lblDesc.isHidden               = false
            self.vwImgTitle.isHidden            = false
            break
        case .Webinar:
            self.vwRecommended.isHidden         = false
            self.vwDateTime.isHidden            = false
            self.btnBookSeat.isHidden           = false
            self.lblDesc.isHidden               = false
            self.vwImgTitle.isHidden            = false
            self.stackDateTimeBook.isHidden     = false
            //self.imgTitle.tapToZoom(with: self.imgTitle.image ?? UIImage())
            break
        case .ExerciseVideo:
            break
        }
        
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    //MARK: -------------------- Action Method --------------------
    func manageActionMethods() {
        
        self.btnAddComment.addTapGestureRecognizer {
            let index = self.tag
            PlanManager.shared.isAllowedByPlan(type: .commenting_on_articles,
                                               sub_features_id: "",
                                               completion: { [weak self] isAllow in
                guard let self = self else {return}
                
                if isAllow{
                    if self.txtAddComment.text!.trim() != "" {
                        self.viewModel.update_commentAPI(content_master_id: self.object.contentMasterId,
                                                         content_type: self.object.contentType,
                                                         comment: self.txtAddComment.text!, content_comments_id: "",
                                                         screen: .DiscoverEngage) { [weak self] (isDone, obj) in
                            guard let self = self else {return}
                            
                            if isDone {
                                self.txtAddComment.text = ""
                                if let vc = self.parentViewController as? DiscoverEngageListVC {
                                    if let tbl = self.superview as? UITableView {
                                        if let _ = tbl.indexPath(for: self) {
                                            DispatchQueue.main.async {
                                                vc.viewModel.arrListContentList[index] = obj
                                                vc.viewModel.arrListContentList[index].isCommentSelected = true
                                                tbl.layoutIfNeeded()
                                                tbl.reloadData()
                                            }
                                        }
                                    }
                                }
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
            self.object.isCommentSelected = !self.object.isCommentSelected
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                
                self.manageCommnetTap()
                
                if #available(iOS 15.0, *) {
                    
                }
                else {
                    if let tbl = self.superview as? UITableView {
                        if let indexPath = tbl.indexPath(for: self) {
                            //tbl.reloadRows(at: [indexPath], with: .fade)
                            tbl.reloadData()
                        }
                    }
                }
            }
        }
        
        self.btnViewAllComment.addTapGestureRecognizer {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                let vc = CommentListVC.instantiate(fromAppStoryboard: .engage)
                vc.hidesBottomBarWhenPushed = true
                vc.content_master_id    = self.object.contentMasterId
                vc.content_type         = self.object.contentType
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
            
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
        
        self.btnLike.addTapGestureRecognizer {
            if self.btnLike.isSelected {
                self.btnLike.isSelected = false
                self.object.liked = "N"
                self.object.noOfLikes -= 1
                
                GlobalAPI.shared.update_likesAPI(content_master_id: self.object.contentMasterId,
                                                 content_type: self.object.contentType,
                                                 is_active: "N",
                                                 screen: .DiscoverEngage) { [weak self] (isDone, msg) in
                    guard let _ = self else {return}
                    if isDone{
                    }
                }
            }
            else {
                self.btnLike.isSelected = true
                self.object.liked = "Y"
                self.object.noOfLikes += 1
                
                GlobalAPI.shared.update_likesAPI(content_master_id: self.object.contentMasterId,
                                                 content_type: self.object.contentType,
                                                 is_active: "Y",
                                                 screen: .DiscoverEngage) { [weak self] (isDone, msg) in
                    
                    guard let self = self else {return}
                    
                    if isDone{
                    }
                }
            }
            
            if let tbl = self.superview as? UITableView {
                tbl.reloadData()
            }
        }
        
        self.btnBookmark.addTapGestureRecognizer {
            PlanManager.shared.isAllowedByPlan(type: .bookmarks,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow {
                    if self.btnBookmark.isSelected {
                        self.btnBookmark.isSelected = false
                        self.object.bookmarked = "N"
                        
                        GlobalAPI.shared.update_bookmarksAPI(content_master_id: self.object.contentMasterId,
                                                             content_type: self.object.contentType,
                                                             is_active: "N",
                                                             forQuestion: false,
                                                             screen: .DiscoverEngage) { [weak self] (isDone, msg) in
                            guard let self = self else {return}
                            if isDone{
                            }
                        }
                    }
                    else {
                        self.btnBookmark.isSelected = true
                        self.object.bookmarked = "Y"
                        
                        GlobalAPI.shared.update_bookmarksAPI(content_master_id: self.object.contentMasterId,
                                                             content_type: self.object.contentType,
                                                             is_active: "Y",
                                                             forQuestion: false,
                                                             screen: .DiscoverEngage) { [weak self] (isDone, msg) in
                            guard let _ = self else {return}
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
        
        self.btnShare.addTapGestureRecognizer {
            if self.object.title != nil {
                let msg = """
                \(self.object.title!)

                \(self.object.deepLink!)
                """
                if let vc = UIApplication.topViewController() {
                    GFunction.shared.openShareSheet(this: vc, msg: msg)
                    GlobalAPI.shared.update_share_countAPI(content_master_id: self.object.contentMasterId) { [weak self] (isDone, msg) in
                        guard let _ = self else {return}
                    }
                }
            }
        }
        
        self.vwAddComment.addTapGestureRecognizer {
            let vc = CommentListVC.instantiate(fromAppStoryboard: .engage)
            vc.hidesBottomBarWhenPushed = true
            vc.content_master_id    = self.object.contentMasterId
            vc.content_type         = self.object.contentType
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
//            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
            
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
    }
    
    func manageCommnetTap(){
        
        func updateCell(){
//            self.layoutIfNeeded()
//            self.layoutSubviews()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                if let vc = self.parentViewController as? DiscoverEngageListVC {
                    if let tbl = self.superview as? UITableView {
                        if tbl.numberOfRows(inSection: 0) == vc.viewModel.getCountContentList() {
                            
                            if #available(iOS 15.0, *) {
                                tbl.performBatchUpdates {
                                } completion: { isDone in
                                }
                                tbl.layoutIfNeeded()
                            }
                            else {
                            }
                        }
                    }
                }
                
            }
        }
        
        self.btnViewAllComment.isHidden = true
        self.lblCommentCount.text       = "0"
        if self.object.comment != nil {
            
            self.lblCommentCount.text   = self.object.comment.total.roundedWithAbbreviations
            
            if self.object.comment.total > 2 {
                self.btnViewAllComment.isHidden = false
                
                let count = GFunction.shared.formatPoints(from: self.object.comment.total)
                self.btnViewAllComment.setTitle("View all \(count) comments", for: .normal)
            }
            else {
                self.btnViewAllComment.isHidden = true
            }
        }
        else {
            self.btnViewAllComment.isHidden = true
        }
        
        if self.object.isCommentSelected {
            self.btnComment.isSelected      = true
            self.vwCommentParent.isHidden   = false
            self.tblComment.reloadData()
        }
        else {
            self.btnComment.isSelected      = false
            self.vwCommentParent.isHidden   = true
        }
        
        updateCell()
    }
}

//MARK: -------------------------- UITableView Methods --------------------------
extension DiscoverEngageListCell : UITableViewDataSource, UITableViewDelegate{
    
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

        if self.object.comment != nil &&
            self.object.comment.commentData != nil {
            let object          = self.object.comment.commentData[indexPath.row]
            cell.lblTitle.text  = object.commentedBy
            cell.lblDesc.text   = object.comment
            
            

            //cell.btnReport.isHidden = false
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
            
            cell.btnReport.addTapGestureRecognizer {
                if object.patientId == UserModel.shared.patientId{

                    GlobalAPI.shared.apiDeleteComment(content_comments_id: object.contentCommentsId,
                                                      screen: .DiscoverEngage) { [weak self] isDone, message, data in
                        guard let self = self else {return}
                        if isDone {
                            if let vc = self.parentViewController as? DiscoverEngageListVC {
                                if let tbl = self.superview as? UITableView {
                                    if let indexPath = tbl.indexPath(for: self) {
                                        DispatchQueue.main.async {
                                            vc.viewModel.arrListContentList[indexPath.row] = data
                                            vc.viewModel.arrListContentList[indexPath.row].isCommentSelected = true
                                            tbl.layoutIfNeeded()
                                            tbl.reloadData()
                                        }
                                    }
                                }
                            }
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
extension DiscoverEngageListCell {
    
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

//MARK: -------------------------- UICollectionView Methods --------------------------
extension DiscoverEngageListCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colMedia:
            self.pageControlMedia.numberOfPages = self.object.media.count
            return self.object.media.count
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case self.colMedia:
            let cell : DiscoverEngageMediaCell = collectionView.dequeueReusableCell(withClass: DiscoverEngageMediaCell.self, for: indexPath)
            
            cell.imgTitle.image = nil
            if let media = self.object.media {
                if media.count > 0 && indexPath.item < media.count {
                    
                    let object = media[indexPath.item]
                    cell.imgTitle.setCustomImage(with: object.imageUrl)
                }
            }
            //cell.imgTitle.tapToZoom(with: cell.imgTitle.image ?? UIImage())
            
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
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension DiscoverEngageListCell: UIScrollViewDelegate {
    
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
