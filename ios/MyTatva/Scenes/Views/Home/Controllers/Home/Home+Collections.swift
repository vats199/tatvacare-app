//
//  AddPrecription+Collection.swift
//  MyTatva
//

//

import Foundation
import SurveySparrowSdk
import SwiftUI

class HomeRecommendedCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var vwShadow         : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    
    //MARK:- Class Variable
    
    override func awakeFromNib() {
        
        self.lblTitle.font(name: .semibold, size: 17)
            .textColor(color: UIColor.white)
        self.lblDesc.font(name: .regular, size: 11)
            .textColor(color: UIColor.white)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 8)
            self.vwShadow.layoutIfNeeded()
            
            let color = GFunction.shared.applyGradientColor(startColor: UIColor.themeBlack.withAlphaComponent(0.8),
                                                            endColor: UIColor.themeBlack.withAlphaComponent(0.1),
                                                            locations: [0, 1],
                                                            startPoint: CGPoint.zero,
                                                            endPoint: CGPoint(x: 0, y: self.vwShadow.frame.maxY),
                                                            gradiantWidth: self.vwShadow.frame.width,
                                                            gradiantHeight: self.vwShadow.frame.height)
            
            self.vwShadow.backgroundColor = color
        }
    }
}

class HomeReadingCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgViewBg        : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var imgAlert         : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var lblDesc2         : UILabel!
    @IBOutlet weak var lblAutoInsight   : UILabel!
    
    @IBOutlet weak var vwInfo           : UIView!
    @IBOutlet weak var btnInfo          : UIButton!
    
    
    override func awakeFromNib() {
        
        self.lblTitle.font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblDesc.font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc2.font(name: .medium, size: 9)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
        self.lblAutoInsight.font(name: .medium, size: 9)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwInfo.layoutIfNeeded()
            self.vwInfo.cornerRadius(cornerRadius: self.vwInfo.frame.size.height / 2)
            self.vwInfo.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.4, shdowRadious: 4)
            
            self.imgView.layoutIfNeeded()
            self.imgView.roundCorners([.topLeft, .topRight], radius: 10)
            
            self.imgViewBg.layoutIfNeeded()
            self.imgViewBg.roundCorners([.topLeft, .topRight], radius: 10)
        }
    }
}

class HomeBookTestCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var vwOffer          : UIView!
    @IBOutlet weak var lblOffer         : UILabel!
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    
    @IBOutlet weak var lblOldPrice      : UILabel!
    @IBOutlet weak var lblNewPrice      : UILabel!
    
    @IBOutlet weak var imgView          : UIImageView!
    
    override func awakeFromNib() {
        
        self.lblTitle
            .font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblDesc
            .font(name: .regular, size: 9)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblOffer
            .font(name: .semibold, size: 7)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblOldPrice
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblNewPrice
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .semibold, withSize: 11),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        self.lblOldPrice.attributedText = self.lblOldPrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            //self.vwBg.themeShadow()
        }
    }
    
    func setData(object: BookTestListModel){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            self.imgView.layoutIfNeeded()
            self.imgView.image      = nil
            self.imgView.setCustomImage(with: object.imageLocation, placeholder: nil, andLoader: true){ img, err, cache, url in
                if img != nil {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        self.imgView.image          = img!.imageWithSize(size: self.imgView.frame.size)
                        self.imgView.contentMode    = .bottomRight
                    }
                }
            }
        }
        
        self.lblTitle.text              = object.name
        self.lblDesc.text               = object.descriptionField
        self.lblOldPrice.text           = CurrencySymbol.INR.rawValue + object.price
        self.lblNewPrice.text           = CurrencySymbol.INR.rawValue + object.discountPrice
        self.lblOffer.text              = """
                    \(object.discountPercent!)%
                    Off
                    """
        if JSON(object.discountPercent as Any).intValue > 0 {
            self.vwOffer.isHidden = false
        }
        else {
            self.vwOffer.isHidden   = true
            self.lblOldPrice.text   = ""
        }
    }
}

class HomePollQuizCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var vwShadow         : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var btnSelect        : UIButton!
    
    //MARK:- Class Variable
    
    override func awakeFromNib() {
        
        self.lblTitle.font(name: .semibold, size: 17)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack)
        self.btnSelect.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwShadow.layoutIfNeeded()
            self.btnSelect.layoutIfNeeded()
            
            self.btnSelect.cornerRadius(cornerRadius: 7)
            
            let color = GFunction.shared.applyGradientColor(startColor: UIColor.themePurple.withAlphaComponent(0.4),
                                                            endColor: UIColor.themePurple.withAlphaComponent(0.1),
                                                            locations: [0, 1],
                                                            startPoint: CGPoint(x: 0, y: self.vwShadow.frame.maxY),
                                                            endPoint: CGPoint(x: self.vwShadow.frame.maxX, y: self.vwShadow.frame.maxY),
                                                            gradiantWidth: self.vwShadow.frame.width,
                                                            gradiantHeight: self.vwShadow.frame.height)
            
            self.vwShadow.backgroundColor = color
            self.vwShadow.roundCorners(.allCorners, radius: 8)
            
        }
    }
}

class HomeInformationCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var btnBookmark      : UIButton!
    @IBOutlet weak var btnShare         : UIButton!
    
    override func awakeFromNib() {
        
        self.lblTitle.font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack)
        self.btnBookmark.font(name: .regular, size: 9)
            .textColor(color: UIColor.themeBlack)
        self.btnShare.font(name: .regular, size: 9)
            .textColor(color: UIColor.themeBlack)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 8)
                .themeShadow()
            
            self.imgView.layoutIfNeeded()
            self.imgView.roundCorners([.topRight, .bottomRight], radius: 8)
        }
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colRecommended:
            return self.viewModel.getRecommendedCount()
            
        case self.colReading:
            let arrCount = self.viewModel.getReadingCount()
            self.vwReadingParent.isHidden = arrCount > 0 ? false : true
            
            return arrCount
            
            //return self.arrReading.count
        case self.colBookTest:
            let arrCount = self.viewModel.getTestListCount()
            self.vwBookTestParent.isHidden = arrCount > 0 ? false : true
            return arrCount
        
        case self.colStayInformed:
            let arrCount = self.viewModel.getStayInformedCount()
            self.vwStayInformed.isHidden = arrCount > 0 ? false : true
            return arrCount
            
        case self.colPollQuiz:
            let count = self.viewModel.getPollQuizCount()
            self.vwPollQuizParent.isHidden = count > 0 ? false : true
            self.pageControlPollQuiz.numberOfPages = count
            
            return count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView {
        
        case self.colRecommended:
            let cell : HomeRecommendedCell = collectionView.dequeueReusableCell(withClass: HomeRecommendedCell.self, for: indexPath)
            let object                     = self.viewModel.getRecommendedObject(index: indexPath.item)
            
            //let type: EngageContentType = EngageContentType.init(rawValue: object.contentType) ?? .BlogArticle
            
            cell.lblTitle.text                  = object.title
            cell.lblDesc.text                   = object.descriptionField.htmlToString
            
            cell.imgView.image      = nil
            if object.media[0].imageUrl.trim() != "" {
                cell.imgView.setCustomImage(with: object.media[0].imageUrl)
            }
            
            return cell
            
        case self.colReading:
            let cell : HomeReadingCell = collectionView.dequeueReusableCell(withClass: HomeReadingCell.self, for: indexPath)
            let obj                     = self.viewModel.getReadingObject(index: indexPath.row)
            
            cell.imgView.image      = nil
            cell.imgView.setCustomImage(with: obj.imageUrl,
                                        placeholder: UIImage(),
                                        andLoader: true,
                                        renderingMode: .alwaysTemplate) { img, err, cache, url in
            }
            cell.imgView.tintColor = UIColor.hexStringToUIColor(hex: obj.colorCode)
            
            cell.imgViewBg
                .backGroundColor(color: UIColor.hexStringToUIColor(hex: obj.backgroundColor).withAlphaComponent(0.1))
            cell.lblTitle.text          = obj.readingName
            cell.btnInfo.tintColor      = UIColor.hexStringToUIColor(hex: obj.colorCode)
            //cell.lblAutoInsight.text    = AppMessages.AverageReadingsOfOthers + " - " + obj.totalReadingAverage + " " + obj.measurements
            
            cell.lblAutoInsight.text        = obj.defaultReading!
            cell.lblAutoInsight.isHidden    = true
            
            GFunction.shared.setReadingData(obj: obj,
                                            lblReading: cell.lblDesc,
                                            lblUpdate: cell.lblDesc2,
                                            fontDefault: UIFont.customFont(ofType: .medium, withSize: 15),
                                            fontAttributed: UIFont.customFont(ofType: .medium, withSize: 9)){ isReadingAvailable in
                
            }
            
            
            cell.imgAlert.isHidden = true
            //cell.imgView.backGroundColor(color: UIColor.hexStringToUIColor(hex: obj.colorCode))
            cell.vwBg.cornerRadius(cornerRadius: 10)
            cell.lblDesc2.font(name: .medium, size: 9)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
            cell.vwBg.themeShadow()
            if obj.readingRequired == "Y" {
                cell.imgAlert.isHidden = false
                cell.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeRedHome, shadowOpacity: 0.3, shdowRadious: 5)
                cell.lblDesc2.font(name: .medium, size: 9)
                    .textColor(color: UIColor.themeRedHome.withAlphaComponent(1))
            }
            
            //            if obj["is_alert"].intValue == 1 {
            //                cell.imgAlert.isHidden = false
            //                cell.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeRed, shadowOpacity: 0.3, shdowRadious: 5)
            //            }
            //------------------------------------------------------------
            
            cell.vwBg.addTapGestureRecognizer {
                self.selectReading(obj: obj, cell: cell)
            }
            
            cell.btnInfo.addTapGestureRecognizer {
                var params = [String: Any]()
                params[AnalyticsParameters.reading_name.rawValue]   = obj.readingName
                params[AnalyticsParameters.reading_id.rawValue]     = obj.readingsMasterId
                FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_READING_INFO,
                                         screen: .Home,
                                         parameter: params)
                
                let vc = ReadingInfoPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.readingListModel = obj
                vc.completionHandler = { [weak self] obj1 in
                    
//                    self.viewModel.apiCallFromStartSummary(tblView: self.tblDailySummary, colView: self.colReading, withLoader: false)
                    if obj1?.count > 0 {
                        print(obj1 ?? "")
                        //object
                        self?.selectReading(obj: obj)
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
            
            return cell
            
        case self.colBookTest:
            let cell : HomeBookTestCell = collectionView.dequeueReusableCell(withClass: HomeBookTestCell.self, for: indexPath)
            let object = self.viewModel.getTestListObject(index: indexPath.item)
            cell.setData(object: object)

            return cell
            
        case self.colStayInformed:
            let cell : HomeInformationCell = collectionView.dequeueReusableCell(withClass: HomeInformationCell.self, for: indexPath)
            cell.btnShare.isHidden      = true
            let object                  = self.viewModel.getStayInformedObject(index: indexPath.item)
            
            //let type: EngageContentType = EngageContentType.init(rawValue: object.contentType) ?? .BlogArticle
            
            cell.lblTitle.text          = object.title
            cell.lblDesc.text           = object.descriptionField.htmlToString
            
            cell.imgView.image      = nil
            if object.media.count > 0 {
                if object.media[0].imageUrl.trim() != "" {
                    cell.imgView.setCustomImage(with: object.media[0].imageUrl)
                }
            }
            
//            self.btnLike.isHidden = object.likeCapability == "No" ? true : false
//            self.lblLikeCount.isHidden = object.likeCapability == "No" ? true : false
            
            cell.btnBookmark.isHidden = object.bookmarkCapability == "No" ? true : false
            
            cell.btnBookmark.isSelected = object.bookmarked == "N" ? false : true
            cell.btnBookmark.addTapGestureRecognizer {
                PlanManager.shared.isAllowedByPlan(type: .bookmarks,
                                                   sub_features_id: "",
                                                   completion: { isAllow in
                    if isAllow {
                        if cell.btnBookmark.isSelected {
                            cell.btnBookmark.isSelected = false
                            object.bookmarked = "N"
                            
                            GlobalAPI.shared.update_bookmarksAPI(content_master_id: object.contentMasterId,
                                                                 content_type: object.contentType,
                                                                 is_active: "N",
                                                                 forQuestion: false,
                                                                 screen: .Home) { [weak self] (isDone, msg) in
                                guard let _ = self else {return}
                                if isDone {
                                }
                            }
                        }
                        else {
                            cell.btnBookmark.isSelected = true
                            object.bookmarked = "Y"
                            
                            GlobalAPI.shared.update_bookmarksAPI(content_master_id: object.contentMasterId,
                                                                 content_type: object.contentType,
                                                                 is_active: "Y",
                                                                 forQuestion: false,
                                                                 screen: .Home) { [weak self] (isDone, msg) in
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
            
            cell.btnShare.addTapGestureRecognizer {
                if object.title != nil {
                    let msg = """
                    \(object.title!)

                    \(object.deepLink!)
                    """
                    if let vc = UIApplication.topViewController() {
                        GFunction.shared.openShareSheet(this: vc, msg: msg)
                        GlobalAPI.shared.update_share_countAPI(content_master_id: object.contentMasterId) { [weak self] (isDone, msg) in
                            guard let _ = self else {return}
                        }
                    }
                }
            }
            
            return cell
            
        case self.colPollQuiz:
            let cell : HomePollQuizCell = collectionView.dequeueReusableCell(withClass: HomePollQuizCell.self, for: indexPath)
            let object                  = self.viewModel.getPollQuizObject(index: indexPath.row)
            cell.lblTitle.text          = object.title
            cell.lblDesc.text           = object.descriptionField
//            cell.btnSelect.setTitle(object.pollMasterId.trim() == "" ? AppMessages.StartQuiz
//                                    : AppMessages.StartPollCard, for: .normal)
            cell.btnSelect.setTitle(object.cat, for: .normal)
            //cell.imgView.setCustomImage(with: object.backgroundUrl)
            
            cell.btnSelect.addTapGestureRecognizer {
                SurveySparrowManager.shared.startSurveySparrow(token: object.surveyId)
                
                if object.quizMasterId.count != 0{
                    FIRAnalytics.FIRLogEvent(eventName: .USER_STARTED_QUIZ,
                                             screen: .Home,
                                             parameter: nil)
                }
                
                SurveySparrowManager.shared.completionHandler = { Response in
                    print(Response as Any)
                    
                    if Response != nil &&
                        object.quizMasterId.count != 0 {
                        
                        self.viewModel.add_quiz_answersAPI(quiz_master_id: object.quizMasterId,
                                                           survey_id: object.surveyId,
                                                           Score: String(Response!["score"] as? Int ?? 0),
                                                           quiz_data: Response!["response"] as! [[String: Any]]) { (isDone, message) in
                            if isDone {
//                                let vc = CorrectAnswerPopUpVC.instantiate(fromAppStoryboard: .carePlan)
//                                vc.value = Float(Response!["score"] as? Int ?? 0)
//                                vc.maxValue = Float((Response!["response"] as? [[String: Any]] ?? []).count)
//                                vc.modalPresentationStyle = .overFullScreen
//                                vc.modalTransitionStyle = .crossDissolve
//                                self.present(vc, animated: false, completion: nil)
                            }
                        }
                    }
                    else if Response != nil &&
                                object.pollMasterId.count != 0 {
                        
                        self.viewModel.add_poll_answersAPI(poll_master_id: object.pollMasterId, survey_id: object.surveyId, poll_data: Response!["response"] as! [[String: Any]]) { [weak self] (isDone, message) in
                            guard let _ = self else {return}
                            if isDone{
                            }
                        }
                    }
                }
                
                //                if obj["type"].stringValue ==  "poll" {
                //                    SurveySparrowManager.shared.startSurveySparrow(token: "tt-b24d3663f8")
                //                    SurveySparrowManager.shared.completionHandler = { obj in
                //                        print(obj as Any)
                //                    }
                //                }
                //                else {
                //                    SurveySparrowManager.shared.startSurveySparrow(token: "tt-763c79")
                //                    SurveySparrowManager.shared.completionHandler = { obj in
                //                        print(obj as Any)
                //                    }
                //                }
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colRecommended:
            DispatchQueue.main.async {
                let object = self.viewModel.getRecommendedObject(index: indexPath.item)
                
                var params1 = [String: Any]()
                params1[AnalyticsParameters.content_master_id.rawValue]  = object.contentMasterId
                params1[AnalyticsParameters.content_type.rawValue]       = object.contentType
                FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_RECOMMENDED,
                                         screen: .Home,
                                         parameter: params1)
                
                if let url = URL(string: object.deepLink) {
                    let _ = DynamicLinks.dynamicLinks()
                        .handleUniversalLink(url) { dynamiclink, error in
                            // ...
                            print("dynamiclink: \(dynamiclink)")
                            print("dynamiclink url: \(dynamiclink?.url)")
                            sceneDelegate.fetchDeepLinkData(link: dynamiclink?.url)
                        }
                }
            }
            break
            
        case self.colReading:

            //let obj = self.viewModel.getReadingObject(index: indexPath.row)
            
            break
            
        case self.colBookTest:
            let object = self.viewModel.getTestListObject(index: indexPath.item)

            var params1 = [String: Any]()
            params1[AnalyticsParameters.lab_test_id.rawValue]  = object.labTestId
            FIRAnalytics.FIRLogEvent(eventName: .HOME_LABTEST_CARD_CLICKED,
                                     screen: .Home,
                                     parameter: params1)

            let vc = LabTestDetailsVC.instantiate(fromAppStoryboard: .carePlan)
            vc.lab_test_id = object.labTestId
            vc.hidesBottomBarWhenPushed = true
            vc.completionHandler = { obj in
                if obj?.name != nil {
                    self.viewModel.arrBookTestList[indexPath.item] = obj!
                    self.colBookTest.reloadData()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
//            let vc = BCAOrderDetailsVC.instantiate(fromAppStoryboard: .bca)
//            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case self.colStayInformed:
            
            DispatchQueue.main.async {
                self.isPageVisible = false
                let object = self.viewModel.getStayInformedObject(index: indexPath.item)
                
                var params1 = [String: Any]()
                params1[AnalyticsParameters.content_master_id.rawValue]  = object.contentMasterId
                params1[AnalyticsParameters.content_type.rawValue]       = object.contentType
                FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_STAY_INFORMED,
                                         screen: .Home,
                                         parameter: params1)
                
                var params2 = [String: Any]()
                params2[AnalyticsParameters.content_master_id.rawValue] = object.contentMasterId
                params2[AnalyticsParameters.content_type.rawValue]      = object.contentType
                //FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_CARD, parameter: params)
                
                let vc = EngageContentDetailVC.instantiate(fromAppStoryboard: .engage)
                vc.contentMasterId = object.contentMasterId
                vc.completionHandler = { obj in
                    if obj != nil {
                        if obj!.contentMasterId != nil {
                            
//                            self.viewModel.arrListContentList[indexPath.row] = obj!
//                            self.tblView.reloadData()
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
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
            
        case self.colPollQuiz:
            break
            
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colRecommended:
            
            let width   = self.colRecommended.frame.size.width / 1.5
            let height  = self.colRecommended.frame.size.height
            
            return CGSize(width: width,
                          height: height)
            
        case self.colReading:
            
            let width   = self.colReading.frame.size.height * 0.7//self.colReading.frame.size.width / 3.2
            let height  = self.colReading.frame.size.height
            
            return CGSize(width: width,
                          height: height)
            
        case self.colBookTest:
            
            let width   = self.colBookTest.frame.size.width / 3.2
            let height  = self.colBookTest.frame.size.height
            
            return CGSize(width: width,
                          height: height)
      
        case self.colStayInformed:
            let width   = self.colStayInformed.frame.size.width / 1.3
            let height  = self.colStayInformed.frame.size.height
            
            return CGSize(width: width,
                          height: height)
            
        case self.colPollQuiz:
            let width   = self.colPollQuiz.frame.size.width / 1.1
            let height  = self.colPollQuiz.frame.size.height
            
            return CGSize(width: width,
                          height: height)
            
        default:
            
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension HomeVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        switch scrollView {
        case self.colPollQuiz:
            self.colPollQuiz.scrollToCenter()
            break
            
        case self.colStayInformed:
            self.colStayInformed.scrollToCenter()
            break
            
        case self.colReading:
            self.colReading.scrollToCenter()
            break
        
        case self.colBookTest:
            self.colBookTest.scrollToCenter()
            break
            
        case self.colRecommended:
            self.colRecommended.scrollToCenter()
            break
            
        case self.scrollMain:
            if scrollView.isAtBottom {
                FIRAnalytics.FIRLogEvent(eventName: .USER_SCROLL_DEPTH_HOME,
                                         screen: .Home,
                                         parameter: nil)
            }
            break
        default:break
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        switch scrollView {
        case self.colPollQuiz:
            self.colPollQuiz.scrollToCenter()
            break
            
        case self.colStayInformed:
            self.colStayInformed.scrollToCenter()
            break
            
        case self.colReading:
            self.colReading.scrollToCenter()
            break
            
        case self.colBookTest:
            self.colBookTest.scrollToCenter()
            break
            
        case self.colRecommended:
            self.colRecommended.scrollToCenter()
            break
        
        case self.scrollMain:
            if scrollView.isAtBottom {
                FIRAnalytics.FIRLogEvent(eventName: .USER_SCROLL_DEPTH_HOME,
                                         screen: .Home,
                                         parameter: nil)
            }
            break
            
        default:break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.colPollQuiz {

            let visibleRect = CGRect(origin: self.colPollQuiz.contentOffset, size: self.colPollQuiz.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = self.colPollQuiz.indexPathForItem(at: visiblePoint) {
                self.pageControlPollQuiz.setPage(visibleIndexPath.row)
            }
        }
        
        if scrollView == self.scrollMain {
            let contentOffset = scrollView.contentOffset
            if contentOffset.y <= 0 {

                let scale           = (-contentOffset.y * 0.001) + 1
                let translate       = (-contentOffset.y * 0.1) + 1
                let translation     = CGAffineTransform(translationX: translate, y: 0)
                let scaling         = CGAffineTransform(scaleX: scale, y: scale)
                let fullTransform   = scaling.concatenating(translation)
                
                self.lblVerifyEmail.transform               = scaling
                self.vwVerifyEmailParent.applyViewShadow(shadowOffset: CGSize(width: 1, height: 1), shadowColor: UIColor.themePurple, shadowOpacity: Float(scale) - 1, shdowRadious: CGFloat(scale) - 1)
                self.imgLogo.transform                      = fullTransform
                self.imgLogo.applyViewShadow(shadowOffset: CGSize(width: 1, height: 1), shadowColor: UIColor.themePurple, shadowOpacity: Float(scale) - 1, shdowRadious: CGFloat(scale) - 1)
                FreshDeskManager.shared.btnChat.transform   = scaling
                
//                if let vw = self.tabBarController?.tabBar.subviews[1] as? UIView {
//                    vw.transform     = fullTransform
//                }
            }
        }
    }
}

extension HomeVC {
    
    func selectReading(obj: ReadingListModel, cell: HomeReadingCell? = nil){
        
        var params                  = [String: Any]()
        params[AnalyticsParameters.reading_name.rawValue]   = obj.readingName
        params[AnalyticsParameters.reading_id.rawValue]     = obj.readingsMasterId
        FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_HOME,
                                 screen: .Home,
                                 parameter: params)
        
        if obj.notConfigured.trim() != "" {
            Alert.shared.showSnackBar(obj.notConfigured)
        }
        else {
            PlanManager.shared.isAllowedByPlan(type: .reading_logs,
                                               sub_features_id: obj.keys,
                                               completion: { isAllow in
                if isAllow {
                    if let type = ReadingType.init(rawValue: obj.keys) {
                        if type == .cat {
                            GlobalAPI.shared.get_cat_surveyAPI { [weak self] (isDone, object, id) in
                                guard let self = self else {return}
                                if isDone {
                                    SurveySparrowManager.shared.startSurveySparrow(token: object.surveyId)
                                    SurveySparrowManager.shared.completionHandler = { Response in
                                        print(Response as Any)
                                        
                                        GlobalAPI.shared.add_cat_surveyAPI(cat_survey_master_id: object.catSurveyMasterId,
                                                                           survey_id: object.surveyId,
                                                                           Score: String(Response!["score"] as? Int ?? 0),
                                                                           response: Response!["response"] as! [[String: Any]]) { [weak self] (isDone, msg) in
                                            guard let self = self else {return}
                                            
                                            self.viewModel.apiCallFromStartSummary(tblViewHome: self.tblDailySummary,
                                                                                   colViewHome: self.colReading,
                                                                                   withLoader: false)
                                            
                                            if isDone {
                                                var params = [String: Any]()
                                                params[AnalyticsParameters.reading_name.rawValue]   = obj.readingName
                                                params[AnalyticsParameters.reading_id.rawValue]     = obj.readingsMasterId
                                                
                                                FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATED_READING,
                                                                         screen: .LogReading,
                                                                         parameter: params)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            self.isPageVisible = false
                            let vc = UpdateReadingParentVC.instantiate(fromAppStoryboard: .goal)
                            
                            var selectedIndex = 0
                            if self.viewModel.arrReading.count > 0 {
                                for i in 0...self.viewModel.arrReading.count - 1 {
                                    let data = self.viewModel.arrReading[i]
                                    if data.keys == obj.keys {
                                        selectedIndex = i
                                    }
                                }
                            }
                            
                            vc.selectedIndex            = selectedIndex
                            vc.arrList                  = self.viewModel.arrReading
                            vc.modalPresentationStyle   = .overFullScreen
                            vc.modalTransitionStyle     = .crossDissolve
                            for cell in self.colReading.visibleCells {
                                if let cell2 = cell as? HomeReadingCell {
                                    cell2.hero.id   = nil
                                }
                            }
                            //cell?.imgView.hero.id       = obj.keys
        //                    self.vwReadingParent.hero.id       = obj.keys
                            
                            vc.completionHandler = { obj in
                                cell?.imgView.hero.id   = nil
                                self.viewModel.apiCallFromStartSummary(tblViewHome: self.tblDailySummary,
                                                                       colViewHome: self.colReading,
                                                                       withLoader: false)
                                if obj?.count > 0 {
                                    print(obj ?? "")
                                    //object
                                }
                            }
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
    }
}

