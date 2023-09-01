//
//  DiscoverEngageListCell.swift
//  MyTatva
//
//  Created by Darshan Joshi on 12/10/21.
//

import Foundation
import UIKit

class AskExpertListCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var colMedia             : UICollectionView!
    @IBOutlet weak var pageControlMedia     : AdvancedPageControlView!
    
    //for question
    @IBOutlet weak var lblQuestion          : UILabel!
    @IBOutlet weak var lblQuestionTime      : UILabel!
    @IBOutlet weak var btnBookmarkQuestion  : UIButton!
    @IBOutlet weak var btnReportQuestion    : UIButton!
    @IBOutlet weak var btnQuestionMore      : UIButton!
    
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
    
    //For topic
    @IBOutlet weak var vwTopic              : UIView!
    @IBOutlet weak var imgTopic             : UIImageView!
    @IBOutlet weak var lblTopic             : UILabel!
    @IBOutlet weak var colTopic             : UICollectionView!
    @IBOutlet weak var colTopicHeight       : NSLayoutConstraint!
    
    //For read
    @IBOutlet weak var vwTotalAns           : UIView!
    @IBOutlet weak var lblTotalAns          : UILabel!
    @IBOutlet weak var btnSelectTotalAns    : UIButton!
    
    //MARK:- Class Variable
    var object = AskExpertListModel() {
        didSet {
            self.setCellData()
        }
    }
    var askExpertListVM     = AskExpertListVM()
    var viewModelReport     = ReportCommentPopupVM()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addObserverOnHeightTbl()
        
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
        self.lblTopic
            .font(name: .regular, size: 10)
            .textColor(color: UIColor.white.withAlphaComponent(1))
        
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
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            
            self.vwTotalAns.layoutIfNeeded()
            self.vwTotalAns.cornerRadius(cornerRadius: 3)
            
            self.vwTopic.layoutIfNeeded()
            self.vwTopic.cornerRadius(cornerRadius: 5)
            
            self.vwAnsTag.layoutIfNeeded()
            self.vwAnsTag.cornerRadius(cornerRadius: 5)
            
            self.btnAnsThis.layoutIfNeeded()
            self.btnAnsThis.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
        }
        
        self.setup(tblView: self.tblAns)
        self.setup(colView: self.colMedia)
        self.setup(colView: self.colTopic)
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
        //self.layoutIfNeeded()
        
        self.colMedia.layoutIfNeeded()
        self.colMedia.isHidden = false
        self.pageControlMedia.layoutIfNeeded()
        self.pageControlMedia.isHidden = false
        self.lblQuestion.layoutIfNeeded()
        self.lblQuestion.isHidden = false
        self.lblQuestionTime.layoutIfNeeded()
        self.lblQuestionTime.isHidden = false
        self.btnBookmarkQuestion.layoutIfNeeded()
        self.btnBookmarkQuestion.isHidden = false
        self.btnReportQuestion.layoutIfNeeded()
        self.btnReportQuestion.isHidden = false
        self.btnQuestionMore.layoutIfNeeded()
        self.btnQuestionMore.isHidden = false
        self.btnAnsThis.layoutIfNeeded()
        self.btnAnsThis.isHidden = false
        self.stackTopAns.layoutIfNeeded()
        self.stackTopAns.isHidden = false
        self.lblTopAnsTitle.layoutIfNeeded()
        self.lblTopAnsTitle.isHidden = false
        self.lblTopAnsTime.layoutIfNeeded()
        self.lblTopAnsTime.isHidden = false
        self.lblTopAnsDesc.layoutIfNeeded()
        self.lblTopAnsDesc.isHidden = false
        self.btnFullAns.layoutIfNeeded()
        self.btnFullAns.isHidden = false
        self.btnTopAnsMore.layoutIfNeeded()
        self.btnTopAnsMore.isHidden = false
        self.btnLikeAns.layoutIfNeeded()
        self.btnLikeAns.isHidden = false
        self.btnReportAns.layoutIfNeeded()
        self.btnReportAns.isHidden = false
        self.btnCommentAns.layoutIfNeeded()
        self.btnCommentAns.isHidden = false
        self.vwAnsParent.layoutIfNeeded()
        self.vwAnsParent.isHidden = false
        self.tblAns.layoutIfNeeded()
        self.tblAns.isHidden = false
        
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
        self.btnSelectTotalAns.isHidden = self.object.totalAnswers > 1 ? false : true
        
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
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                self.colMedia.reloadData()
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
            
            self.lblTopic.text      = self.object.topics[0].name
            self.imgTopic.setCustomImage(with: self.object.topics[0].imageUrl)
            //self.vwTopic.backGroundColor(color: UIColor.init(hexString: self.object.topics[0].colorCode))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                self.colTopic.reloadData()
            }
        }
        
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
            self.tblAns.reloadData()
        }
        
        if self.object.isSelected {
            self.vwAnsParent.isHidden = false
        }
        else {
            self.vwAnsParent.isHidden = true
        }
        
//        DispatchQueue.main.async {
//            if let vc = self.parentViewController as? AskExpertListVC {
//                if let tbl = self.superview as? UITableView {
//                    if tbl.numberOfRows(inSection: 0) == vc.viewModel.getCountContentList() {
//
//                        if #available(iOS 15.0, *) {
//                            tbl.performBatchUpdates {
//                            } completion: { isDone in
//                            }
//                            tbl.layoutIfNeeded()
//                        }
//                        else {
//                        }
//                    }
//                }
//            }
//        }
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            if let vc = self.parentViewController as? AskExpertListVC {
                if let tbl = self.superview as? UITableView {
                    
                    if #available(iOS 15.0, *) {
                        tbl.performBatchUpdates {
                        } completion: { isDone in
                        }
                        tbl.layoutIfNeeded()
                    }
                    else {
                        tbl.performBatchUpdates {
                        } completion: { isDone in
                        }
                        tbl.layoutIfNeeded()
                    }
                    
                    if tbl.numberOfRows(inSection: 0) == vc.viewModel.getCountContentList() {
                    }
                }
            }
        }
    }
    
    //MARK: -------------------- Action Method --------------------
    func manageActionMethods() {
        
        self.vwTotalAns.addTapGestureRecognizer {
            if self.object.totalAnswers > 1 {
                self.object.isSelected = !self.object.isSelected
                
                if let tbl = self.superview as? UITableView {
                    tbl.layoutIfNeeded()
                    tbl.reloadData()
                }
            }
        }
        
        self.btnAnsThis.addTapGestureRecognizer {
            let vc = AskExpertAnswerPopupVC.instantiate(fromAppStoryboard: .engage)
            vc.content_master_id        = self.object.contentMasterId
            vc.strQue                   = self.object.title
            vc.modalPresentationStyle   = .overFullScreen
            vc.modalTransitionStyle     = .crossDissolve
            vc.completionHandler = { objData in
                if let obj = objData, obj.createdAt != nil {
                    if let vc = self.parentViewController as? AskExpertListVC {
                        if let tbl = self.superview as? UITableView {
                            if let indexPath = tbl.indexPath(for: self) {
                                vc.viewModel.arrListContentList[indexPath.row] = obj
                            }
                            tbl.layoutIfNeeded()
                            tbl.reloadData()
                        }
                    }
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
                        if let tbl = self.superview as? UITableView {
                            tbl.layoutIfNeeded()
                            tbl.reloadData()
                        }
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
                        if let tbl = self.superview as? UITableView {
                            tbl.layoutIfNeeded()
                            tbl.reloadData()
                        }
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
                                                              screen: .AskAnExpert) { [weak self] (isDone, msg) in
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
                                                              screen: .AskAnExpert) { [weak self]  (isDone, msg) in
                    guard let _ = self else {return}
                    if isDone{
                    }
                }
            }
           
            if let tbl = self.superview as? UITableView {
                tbl.reloadData()
            }
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
                        if let vc = self.parentViewController as? AskExpertListVC {
                            //vc.updateAPIData(withLoader: true)
                            if let tbl = self.superview as? UITableView {
                                if let indexPath = tbl.indexPath(for: self) {
                                    vc.viewModel.arrListContentList[indexPath.row] = obj!
                                }
                                tbl.layoutIfNeeded()
                                tbl.reloadData()
                            }
                        }
                    }
                }
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
            let actionDelete : UIAlertAction = UIAlertAction(title: AppMessages.delete, style: .default) { (action) in
                
                Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { (isDone) in
                    if isDone {
                        self.askExpertListVM.deleteQuestionAnswersCommentsAPI(content_master_id: self.object.contentMasterId,
                                                                        content_comments_id: "",
                                                                              type: .question) { [weak self] isDone, msg, obj in
                            guard let self = self else {return}
                            
                            if isDone {
                                if let vc = self.parentViewController as? AskExpertListVC {
                                    if let tbl = self.superview as? UITableView {
                                        if let indexPath = tbl.indexPath(for: self) {
                                            vc.viewModel.arrListContentList.remove(at: indexPath.row)
                                        }
                                        
                                        if vc.viewModel.arrListContentList.count == 0 {
                                            vc.apiStart()
                                        }
                                        tbl.layoutIfNeeded()
                                        tbl.reloadData()
                                    }
                                }
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
                        if let vc = self.parentViewController as? AskExpertListVC {
                            if let tbl = self.superview as? UITableView {
                                if let indexPath = tbl.indexPath(for: self) {
                                    vc.viewModel.arrListContentList[indexPath.row] = obj!
                                }
                                tbl.layoutIfNeeded()
                                tbl.reloadData()
                            }
                        }
                    }
                }
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
            let actionDelete : UIAlertAction = UIAlertAction(title: AppMessages.delete, style: .default) { (action) in
                Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { (isDone) in
                    if isDone {
                        self.askExpertListVM.deleteQuestionAnswersCommentsAPI(content_master_id: self.object.topAnswer.contentMasterId,
                                                                        content_comments_id: self.object.topAnswer.contentCommentsId,
                                                                              type: .answer) { [weak self] isDone, msg, obj in
                            guard let self = self else {return}
                            
                            if isDone {
                                if let vc = self.parentViewController as? AskExpertListVC {
                                    if let tbl = self.superview as? UITableView {
                                        if let indexPath = tbl.indexPath(for: self) {
                                            vc.viewModel.arrListContentList[indexPath.row] = obj
                                        }
                                        tbl.layoutIfNeeded()
                                        tbl.reloadData()
                                    }
                                }
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
                if let vc = self.parentViewController as? AskExpertListVC {
                    if obj != nil {
                        if obj!.contentMasterId != nil {
                            if let tbl = self.superview as? UITableView {
                                if let indexPath = tbl.indexPath(for: self) {
                                    vc.viewModel.arrListContentList[indexPath.row].topAnswer.totalComments = obj!.totalComments
                                }
                                tbl.layoutIfNeeded()
                                tbl.reloadData()
                            }
                        }
                        else {
                           vc.updateAPIData()
                        }
                    }
                    else {
                        vc.updateAPIData()
                    }
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
                                                     screen: .AskAnExpert) { [weak self] (isDone, msg) in
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
                                                     screen: .AskAnExpert) { [weak self] (isDone, msg) in
                    guard let _ = self else {return}
                    if isDone{
                    }
                }
            }
        }
    }
}

class AskExpertListMediaCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var imgDoc               : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
        }
    }
}

//MARK: -------------------------- UITableView Methods --------------------------
extension AskExpertListCell : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.object.recentAnswers != nil {
            return self.object.recentAnswers.count
        }
        else {
            return 0
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : AskExpertListAllAnsCell = tableView.dequeueReusableCell(withClass: AskExpertListAllAnsCell.self, for: indexPath)

        let object = self.object.recentAnswers[indexPath.row]
        
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
                        if let tbl = self.superview as? UITableView {
                            tbl.layoutIfNeeded()
                            tbl.reloadData()
                        }
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
                                                              forComment: false,
                                                              screen: .AskAnExpert) { [weak self] (isDone, msg) in
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
                                                              screen: .AskAnExpert) { [weak self] (isDone, msg) in
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
                        if let vc = self.parentViewController as? AskExpertListVC {
                            if let tbl = self.superview as? UITableView {
                                if let indexPath = tbl.indexPath(for: self) {
                                    vc.viewModel.arrListContentList[indexPath.row] = obj!
                                    vc.viewModel.arrListContentList[indexPath.row].isSelected = true
                                }
                                tbl.layoutIfNeeded()
                                tbl.reloadData()
                            }
                        }
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
                                if let vc = self.parentViewController as? AskExpertListVC {
                                    if let tbl = self.superview as? UITableView {
                                        if let indexPath = tbl.indexPath(for: self) {
                                            vc.viewModel.arrListContentList[indexPath.row] = obj
                                            vc.viewModel.arrListContentList[indexPath.row].isSelected = true
                                        }
                                        tbl.layoutIfNeeded()
                                        tbl.reloadData()
                                    }
                                }
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
                if let vc = self.parentViewController as? AskExpertListVC {
                    if obj != nil {
                        if obj!.contentMasterId != nil {
                            if let tbl = self.superview as? UITableView {
                                if let idxPath = tbl.indexPath(for: self) {
                                    vc.viewModel.arrListContentList[idxPath.row].recentAnswers[indexPath.row].totalComments = obj!.totalComments
                                }
                                tbl.layoutIfNeeded()
                                tbl.reloadData()
                            }
                        }
                        else {
                           vc.updateAPIData()
                        }
                    }
                    else {
                        vc.updateAPIData()
                    }
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
extension AskExpertListCell {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblAns, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblAnsHeight.constant = newvalue.height
        }
        if let obj = object as? UICollectionView, obj == self.colTopic, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.colTopicHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblAns.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.colTopic.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblAns else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let colView = self.colTopic else {return}
        if let _ = colView.observationInfo {
            colView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension AskExpertListCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
            
            if let media = self.object.documents {
                if media.count > 0 && indexPath.item < media.count {
                    
                    let object                  = media[indexPath.item]
                    
                    if object.mediaType == "PDF" ||
                        object.mediaType == "Document" {
                        
                        cell.imgTitle.isHidden      = true
                        cell.imgDoc.isHidden        = false
                        
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
                        cell.imgTitle.isHidden      = false
                        cell.imgDoc.isHidden        = true
                        
                        cell.imgTitle.contentMode   = .scaleAspectFill
                        
                        cell.imgTitle.setCustomImage(with: object.imageUrl) { img, err, cache, url in
                            if img != nil {
                                if object.imageUrl.trim() != "" {
                                    cell.imgTitle.tapToZoom(with: img)
                                }
                            }
                        }
                    }
                }
            }
                //cell.imgTitle.tapToZoom(with: cell.imgTitle.image ?? UIImage())
            DispatchQueue.main.async {
                cell.vwBg.layoutIfNeeded()
                cell.vwBg.cornerRadius(cornerRadius: 10)
                    .borderColor(color: UIColor.ThemeLightGray2, borderWidth: 1)
            }
            
            return cell
            
        case self.colTopic:
            let cell : AskExpertTopicCell = collectionView.dequeueReusableCell(withClass: AskExpertTopicCell.self, for: indexPath)
            
           // DispatchQueue.main.async {
                if self.object.topics != nil {
                    
                    let object = self.object.topics[indexPath.item]
                    
                    cell.imgTitle.setCustomImage(with: object.imageUrl)
                    cell.lblTitle.font(name: .semibold, size: 10).textColor(color: UIColor.white)
                    
                    cell.lblTitle.text = object.name
                    cell.vwBg.backGroundColor(color: UIColor.init(hexString: object.colorCode))
                }
         //   }
            
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
            let width       = self.colMedia.frame.size.width / 2.5
            let height      = self.colMedia.frame.size.height
            
            return CGSize(width: width,
                          height: height)
            
        case self.colTopic:
            
            let width = self.object.topics[indexPath.row].name.widthOfString(usingFont: UIFont.customFont(ofType: .semibold, withSize: 10))
            let height = self.object.topics[indexPath.row].name.heightOfString(usingFont: UIFont.customFont(ofType: .semibold, withSize: 10))
            
            return CGSize(width: width + 40, height: height + 12)
            
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension AskExpertListCell: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.colMedia {
            if !decelerate {
               // self.colMedia.scrollToCenter()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.colMedia {
           // self.colMedia.scrollToCenter()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.colMedia {
//            let pageWidth:CGFloat = scrollView.frame.width
//            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
//            //Change the indicator
//            self.pageControl.setPage(Int(currentPage))
            
//            let visibleRect = CGRect(origin: self.colMedia.contentOffset, size: self.colMedia.bounds.size)
//            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//            if let visibleIndexPath = self.colMedia.indexPathForItem(at: visiblePoint) {
//                self.pageControlMedia.setPage(visibleIndexPath.row)
//            }
        }
    }
    
}
