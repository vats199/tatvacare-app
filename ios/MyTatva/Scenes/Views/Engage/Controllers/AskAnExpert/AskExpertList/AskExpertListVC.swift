//
//  BasicVC.swift
//
//  Created by apple on 07/12/18.
//  Copyright © 2018 DMJ. All rights reserved.
//

import UIKit

class AskExpertListAllAnsCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblTime              : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var stackAnsTag          : UIStackView!
    @IBOutlet weak var vwAnsTag             : UIView!
    @IBOutlet weak var lblAnsTag            : UILabel!
    
    @IBOutlet weak var btnFullAns           : UIButton!
    @IBOutlet weak var btnLike              : UIButton!
    @IBOutlet weak var btnComment           : UIButton!
    @IBOutlet weak var btnReport            : UIButton!
    @IBOutlet weak var btnAnsMore           : UIButton!
    
    @IBOutlet weak var lblLikeAnsCount      : UILabel!
    @IBOutlet weak var lblCommentAnsCount   : UILabel!
    
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
    
        self.lblAnsTag
            .font(name: .regular, size: 10)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.btnFullAns
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themePurple)
        
        self.lblLikeAnsCount
            .font(name: .light, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblCommentAnsCount
            .font(name: .light, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.02))
            
            self.vwAnsTag.layoutIfNeeded()
            self.vwAnsTag.cornerRadius(cornerRadius: 5)
        }
    }
}

//MARK: -------------------------  UIViewController -------------------------
class AskExpertListVC : UIViewController {
    
    //MARK: ------------------------- Outlet -------------------------
    
    @IBOutlet weak var vwLanguage           : UIView!
    @IBOutlet weak var vwLanguageBtn        : UIView!
    @IBOutlet weak var lblLanguage          : UILabel!
    @IBOutlet weak var lblSelectedLanguage  : UILabel!
    
    @IBOutlet weak var vwPostQuestionParent : UIView!
    @IBOutlet weak var vwPostQuestion       : UIView!
    @IBOutlet weak var lblPostQuestion      : UILabel!
    
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var colTopic             : UICollectionView!
    @IBOutlet weak var btnMoveTop           : UIButton!

    //MARK:- Class Variable
    let viewModel                           = AskExpertListVM()
    private let listViewModel               = LanguageListVM()
    let refreshControl                      = UIRefreshControl()
    var strErrorMessage : String            = ""
    var strErrorMessageTopicList: String    = ""
    var kMaxReloadAttempTopic               = 0
    var selectedFilterobject                = ContenFilterListModel()
    var lastSyncDate                        = Date()
    let dropDown                            = DropDown()
    
    var isContinueCoachmark                 = false
    var timerSearch                         = Timer()
    var isGloabalSearch                     = false
    var strSearch                           = ""
    
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
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    func setUpView() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchDidUpdate(_:)), name: kPostSearchData, object: nil)
        self.setup(tblView: tblView)
        self.setup(colView: self.colTopic)
        self.setData()
        self.configureUI()
        self.setupViewModelObserver()
        self.manageActionMethods()
        
        self.lblPostQuestion
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        
        self.lblLanguage
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        
        self.lblSelectedLanguage
            .font(name: .medium, size: 10)
            .textColor(color: UIColor.white)
    }
    
    func configureUI(){
        self.tblView.themeShadow()
        self.tblView.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.vwLanguageBtn.layoutIfNeeded()
            self.vwLanguageBtn.cornerRadius(cornerRadius: 4)
                .backGroundColor(color: UIColor.themePurple)
            
            self.vwPostQuestion.layoutIfNeeded()
            self.vwPostQuestion.cornerRadius(cornerRadius: 10)
            self.vwPostQuestion.themeShadow()
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
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        tblView.addSubview(self.refreshControl)
    }
    
    func setup(colView: UICollectionView){
        colView.delegate                   = self
        colView.dataSource                 = self
        colView.emptyDataSetSource         = self
        colView.emptyDataSetDelegate       = self
        colView.reloadData()
    }
    
    //MARK: ------------------------- Action Method -------------------------
    @IBAction func btnMoveTopTapped(sender: UIButton){
        self.tblView.scrollToTop(animated: false)
    }
    
    private func manageActionMethods(){
        
        self.vwPostQuestion.addTapGestureRecognizer {
            let vc = AskExpertQuestionVC.instantiate(fromAppStoryboard: .engage)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandler = { obj in
                if obj != nil {
                    self.updateAPIData()
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
        
        self.vwLanguageBtn.addTapGestureRecognizer {
            
            DropDown.appearance().textColor = UIColor.themeBlack
            DropDown.appearance().selectedTextColor = UIColor.themeBlack
            DropDown.appearance().textFont = UIFont.customFont(ofType: .medium, withSize: 14)
            DropDown.appearance().backgroundColor = UIColor.white
            DropDown.appearance().selectionBackgroundColor = UIColor.white
            DropDown.appearance().cellHeight = 40
            
            self.dropDown.anchorView = self.vwLanguageBtn
            if self.listViewModel.getCount_contentLanguageList() > 0 {
                let arr: [String] = self.listViewModel.arrList.map { (obj) -> String in
                    return obj.languageName
                }
                
                self.dropDown.dataSource = arr
                self.dropDown.selectionAction = { (index, str) in
                    
                    DispatchQueue.main.async {
                        if self.selectedFilterobject.language != nil {
                            if self.lblSelectedLanguage.text != self.listViewModel.arrList[index].languageName {
                                AppLoader.shared.addLoader()
                                
                                self.lblSelectedLanguage.text = self.listViewModel.arrList[index].languageName
                                
                                self.selectedFilterobject.language = [self.listViewModel.arrList[index]]
                                self.updateAPIData()
                                
                            }
                        }
                    }
                    self.dropDown.hide()
                }
                self.dropDown.show()
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
        
        //        NSObject.cancelPreviousPerformRequests(withTarget: self)
        //        self.perform(#selector(self.apiStart), with: nil, afterDelay: 1)
        self.apiStart()
        
        WebengageManager.shared.navigateScreenEvent(screen: .AskAnExpert)
        self.kMaxReloadAttempTopic = 0
        
        if !self.isGloabalSearch {
            self.vwPostQuestionParent.isHidden = false
        }
        else {
            self.vwPostQuestionParent.isHidden = true
        }
        
        self.vwLanguage.isHidden = true
        PlanManager.shared.isAllowedByPlan(type: .engage_article_selection_of_language,
                                           sub_features_id: "",
                                           completion: { isAllow in
            if isAllow {
                self.vwLanguage.isHidden = true
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .AskAnExpert, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
       FIRAnalytics.manageTimeSpent(on: .AskAnExpert, when: .Disappear)
    }   
}

//MARK: -------------------------- UITableView Methods --------------------------
extension AskExpertListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCountContentList()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : AskExpertListCell = tableView.dequeueReusableCell(withClass: AskExpertListCell.self, for: indexPath)
        let object = self.viewModel.getObjectContentList(index: indexPath.row)
        
        cell.object = object
        //cell.btnShare.isHidden = true
        
        cell.vwBg.layoutIfNeeded()
        cell.vwBg.layoutSubviews()
//        cell.setCellData()
        
        cell.vwBg.addTapGestureRecognizer {
            self.openContentDetails(index: indexPath.row)
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var genre_ids: [String] = []
        if self.selectedFilterobject.genre != nil {
            genre_ids = self.selectedFilterobject.genre.map { (obj) -> String in
                return obj.genreMasterId
            }
        }
        
        var topic_ids: [String] = []
        if self.selectedFilterobject.topic != nil {
            topic_ids = self.selectedFilterobject.topic.map { (obj) -> String in
                return obj.topicMasterId
            }
        }
        
        var languages_id: [String] = []
        if self.selectedFilterobject.language != nil {
            languages_id = self.selectedFilterobject.language.map { (obj) -> String in
                return obj.languagesId
            }
        }
        
        
        var content_types: [String] = []
        if self.selectedFilterobject.contentType != nil {
            content_types = self.selectedFilterobject.contentType.map { (obj) -> String in
                return obj.keys
            }
        }
        
        var question_types: [String] = []
        if self.selectedFilterobject.questionType != nil {
            question_types = self.selectedFilterobject.questionType.map { (obj) -> String in
                return obj.value
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            //if self.viewModel.arrListContentList.count == 0 {
            self.viewModel.managePagenationContentList(tblView: self.tblView,
                                                       refreshControl: self.refreshControl,
                                                       withLoader: false,
                                                       search: self.strSearch,
                                                       filter_by_words: "",
                                                       topic_ids: topic_ids,
                                                       languages_id: languages_id,
                                                       question_types: question_types,
                                                       content_types: content_types,
                                                       recommended_health_doctor: self.selectedFilterobject.isShowContentFromDocHealthCoach,
                                                       index: indexPath.row)
            //}
        }
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension AskExpertListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        var text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        if scrollView == self.tblView {
            text = self.strErrorMessage
        }
        else if scrollView == self.colTopic {
            text = self.strErrorMessageTopicList
        }
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension AskExpertListVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colTopic:
            return self.viewModel.getCountTopicList()
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case self.colTopic:
            let cell : DiscoverEngageTopicCell = collectionView.dequeueReusableCell(withClass: DiscoverEngageTopicCell.self, for: indexPath)
            
            let obj = self.viewModel.getObjectTopicList(index: indexPath.item)
            
            cell.imgTitle.image = UIImage()
            if obj.imageUrl.trim() != "" {
                cell.imgTitle.setCustomImage(with: obj.imageUrl)
            }
            
            cell.lblTitle.text = obj.name
            cell.vwBg.backgroundColor = UIColor.hexStringToUIColor(hex: obj.colorCode)
            
            cell.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0, shdowRadious: 4)
            if obj.isSelected {
                cell.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.7, shdowRadious: 4)
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colTopic:
            self.viewModel.manageSelectionTopicList(index: indexPath.item)
            self.colTopic.reloadData()
            
            DispatchQueue.main.async {
                let selectedTopics = self.viewModel.getSelectedObjectTopicList()
                
                func updateData() {
                    self.selectedFilterobject.topic = selectedTopics
                    if let vc = self.parent?.parent as? EngageParentVC {
                        vc.selectedFilterobject_askExpert = self.selectedFilterobject
                    }
                    self.updateAPIData()
                }
                
                guard let topic = selectedTopics, topic.count > 0 else {
                    updateData()
                    return
                }
                
                if self.selectedFilterobject.topic != nil {
                    if self.selectedFilterobject.topic.count > 0 {
                        updateData()
                        if topic.first!.topicMasterId != self.selectedFilterobject.topic.first!.topicMasterId {

                            updateData()
                        }
                    }
                    else {
                        updateData()
                    }
                }
                else {
                    updateData()
                }
            }
            break
        
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colTopic:
            //let obj         = self.arrTitle[indexPath.item]
            //let width       = obj["name"].stringValue.width(withConstraintedHeight: 18.0, font: UIFont.customFont(ofType: .semibold, withSize: 18.0))
            let width       = self.colTopic.frame.size.height //+ 10
            let height      = self.colTopic.frame.size.height
            
            return CGSize(width: width,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
}


//MARK: -------------------------- Set data Methods --------------------------
extension AskExpertListVC {
    
    @objc func apiStart(){
        self.listViewModel.apiCallFromStart_contentLanguageList(refreshControl: nil,
                                                                tblView: nil,
                                        withLoader: false)
    }
    
    @objc func updateAPIData(){
        self.strErrorMessage = ""
        self.strErrorMessageTopicList = ""
        var genre_ids: [String] = []
        if self.selectedFilterobject.genre != nil {
            genre_ids = self.selectedFilterobject.genre.map { (obj) -> String in
                return obj.genreMasterId
            }
        }
        
        var topic_ids: [String] = []
        if self.selectedFilterobject.topic != nil {
            topic_ids = self.selectedFilterobject.topic.map { (obj) -> String in
                return obj.topicMasterId
            }
        }
        
        var languages_id: [String] = []
        if self.selectedFilterobject.language != nil {
            languages_id = self.selectedFilterobject.language.map { (obj) -> String in
                return obj.languagesId
            }
        }
        
        var content_types: [String] = []
        if self.selectedFilterobject.contentType != nil {
            content_types = self.selectedFilterobject.contentType.map { (obj) -> String in
                return obj.keys
            }
        }
        
        var question_types: [String] = []
        if self.selectedFilterobject.questionType != nil {
            question_types = self.selectedFilterobject.questionType.map { (obj) -> String in
                return obj.value
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            let withLoader = false
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.viewModel.pageContentList = 1
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.viewModel.apiCallFromStart_ContentList(refreshControl: self.refreshControl,
                                                            tblView: self.tblView,
                                                            withLoader: withLoader,
                                                            search: self.strSearch,
                                                            filter_by_words: "",
                                                            topic_ids: topic_ids,
                                                            languages_id: languages_id,
                                                            question_types: question_types,
                                                            recommended_health_doctor: self.selectedFilterobject.isShowContentFromDocHealthCoach,
                                                            content_types: content_types)
            }
        }
        
        if self.isGloabalSearch {
            self.colTopic.isHidden = true
        }
        else {
            var withLoader = true
            if self.viewModel.getCountTopicList() > 0 {
                withLoader = false
            }
            
            self.colTopic.isHidden = false
            if self.viewModel.getCountTopicList() == 0 {
                self.viewModel.apiCallFromStart_TopicList(refreshControl: nil, colView: self.colTopic, withLoader: withLoader)
            }
        }
    }
    
    func setData(){
        
    }

}

//MARK: -------------------- open Content Details Method --------------------
extension AskExpertListVC {
    
    func openContentDetails(index: Int){
        DispatchQueue.main.async {
            let object = self.viewModel.getObjectContentList(index: index)
            
//            var params = [String: Any]()
//            params[AnalyticsParameters.content_master_id.rawValue] = object.contentMasterId
//            params[AnalyticsParameters.content_type.rawValue]      = object.contentType
//            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_CARD, parameter: params)
            
            let vc = AskExpertQuestionDetailsVC.instantiate(fromAppStoryboard: .engage)
            vc.contentMasterId = object.contentMasterId
            vc.completionHandler = { obj in
                if obj != nil {
                    if obj!.contentMasterId != nil {
                        
//                        self.viewModel.arrListContentList[index] = obj!
//                        self.tblView.reloadData()
                    }
                    else {
                        self.updateAPIData()
                    }
                }
                else {
                    self.updateAPIData()
                }
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

//MARK: -------------------- UIScrollView Delegate Methods --------------------
extension AskExpertListVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tblView {
            if scrollView.contentSize.height > self.view.frame.size.height && scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height - scrollView.frame.size.height), animated: false)
            }
            else if scrollView.contentSize.height < self.tblView.frame.size.height && scrollView.contentOffset.y >= 0 {
                scrollView.setContentOffset(CGPoint.zero, animated: false)
            }
        }
    }
}

//MARK: -------------------- GlobalSearch Methods --------------------
extension AskExpertListVC {
    
    @objc func searchDidUpdate(_ notification: NSNotification) {
        if let _ = self.parent {
            if let searchKeyword = notification.userInfo?["search"] as? String {
                self.strSearch = searchKeyword
                self.updateAPIData()
             }
        }
    }
    
}

//MARK: -------------------- setupViewModel Observer --------------------
extension AskExpertListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        self.viewModel.vmResultTopicList.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                
                DispatchQueue.main.async {
                    if self.viewModel.arrListTopicList.count > 0 {
                        self.colTopic.isHidden = false
                    }
                    else {
                        self.colTopic.isHidden = false
                        
                        if self.kMaxReloadAttempTopic < kMaxReloadAttemp {
                            self.kMaxReloadAttempTopic += 1
                            self.viewModel.apiCallFromStart_TopicList(refreshControl: nil, colView: self.colTopic, withLoader: false)
                        }
                    }
                    self.strErrorMessageTopicList = self.viewModel.strErrorMessageTopicList
                    self.colTopic.reloadData()
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
        self.viewModel.vmResultContentList.bind(observer: { (result) in
            switch result {
            case .success(_):
                
                DispatchQueue.main.async {
                    self.strErrorMessage = self.viewModel.strErrorMessageContentList
                    self.tblView.reloadData()
                    
                    if self.viewModel.arrListContentList.count > 0 {
                        self.btnMoveTop.isHidden = false
                    }
                    else {
                        self.btnMoveTop.isHidden = true
                    }
                }
                
                self.startAppTour()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
        self.listViewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                if self.listViewModel.getCount_contentLanguageList() > 0 {
                    if self.selectedFilterobject.language == nil {
                        self.lblSelectedLanguage.text = self.listViewModel.arrList[0].languageName
                        self.selectedFilterobject.language = [self.listViewModel.arrList[0]]
                    }
                }
                
                //self.updateAPIData(withLoader: true)
                //if self.viewModel.getCountContentList() == 0 {
                    self.updateAPIData()
                //}
                
                DispatchQueue.main.async {
                    if Calendar.current.dateComponents([.minute], from: self.lastSyncDate, to: Date()).minute > kAPI_RELOAD_DELAY_BY {
                        self.lastSyncDate = Date()
                        self.updateAPIData()
                    }
                }
                
                break
            case .failure(_):
                //Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                break
                
            case .none: break
            }
        })
    }
    
    func startAppTour(){
        
        DispatchQueue.main.async {
            if self.isContinueCoachmark {
                self.isContinueCoachmark = false
                self.tblView.scrollToTop(animated: false)
                let vc = CoachmarkAskExpertVC.instantiate(fromAppStoryboard: .home)
                vc.targetView = self.tblView
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.completionHandler = { obj in
                    if obj?.count > 0 {
                        let vc = CoachmarkEngageToExerciseVC.instantiate(fromAppStoryboard: .home)
                        if let item = self.tabBarController?.tabBar {
                            vc.targetTabbar = item
                        }
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        vc.completionHandler = { obj3 in
                            if obj3?.count > 0 {
                                if let tab = self.tabBarController {
                                    tab.selectedIndex = 3
                                    if let exerciseParentVC = (tab.viewControllers?[3] as? UINavigationController)?.viewControllers.first as? ExerciseParentVC{
                                        exerciseParentVC.isContinueCoachmark = true
                                    }
                                }
                            }
                        }
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

