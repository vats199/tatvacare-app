//


import UIKit
import AVKit
import WebKit

class ExerciseDetailsTblCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var vwImgTitle           : UIView!
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    @IBOutlet weak var btnPlay              : UIButton!
    
    @IBOutlet weak var btnLike              : UIButton!
    @IBOutlet weak var btnBookmark          : UIButton!
    @IBOutlet weak var btnShare             : UIButton!
    @IBOutlet weak var btnInfo              : UIButton?
    
    @IBOutlet weak var lblLikeCount         : UILabel!
    
    @IBOutlet weak var vwRead               : UIView!
    @IBOutlet weak var lblRead              : UILabel!
    
    @IBOutlet weak var vwFitnessLevel       : UIView!
    @IBOutlet weak var lblFitnessLevel      : UILabel!
    
    @IBOutlet weak var vwExerciseTool       : UIView!
    @IBOutlet weak var lblExerciseTool      : UILabel!
    
    @IBOutlet weak var vwReps               : UIView?
    @IBOutlet weak var lblReps              : UILabel?
    
    var videoUrl: URL?
    var player: AVPlayer?
    let avPVC = AVPlayerViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 17)
            .textColor(color: UIColor.themeBlack)
        
        self.lblDesc
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
    
        self.lblRead
            .font(name: .semibold, size: 9)
            .textColor(color: UIColor.themeBlack)
        
        self.lblFitnessLevel
            .font(name: .semibold, size: 9)
            .textColor(color: UIColor.themeBlack)
        
        self.lblExerciseTool
            .font(name: .semibold, size: 9)
            .textColor(color: UIColor.themeBlack)
        
        self.lblReps?
            .font(name: .semibold, size: 9)
            .textColor(color: UIColor.themeBlack)
        
        self.lblLikeCount
            .font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.roundCorners([.topLeft, .topRight], radius: 10)
            
            self.vwRead.layoutIfNeeded()
            self.vwRead.cornerRadius(cornerRadius: 2)
                .backGroundColor(color: UIColor.themeLightGray)
            
            self.vwFitnessLevel.layoutIfNeeded()
            self.vwFitnessLevel.cornerRadius(cornerRadius: 2)
                .backGroundColor(color: UIColor.themeLightGray)
            
            self.vwExerciseTool.layoutIfNeeded()
            self.vwExerciseTool.cornerRadius(cornerRadius: 2)
                .backGroundColor(color: UIColor.themeLightGray)
            
            self.vwReps?.layoutIfNeeded()
            self.vwReps?.cornerRadius(cornerRadius: 2)
                .backGroundColor(color: UIColor.themeLightGray)
            
            self.btnPlay.layoutIfNeeded()
            self.btnPlay.themeShadow()
        }
    }
    
}

class ExerciseContentTblCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var webViewDescHeight    : NSLayoutConstraint!
    @IBOutlet weak var webViewDesc          : WKWebView!
    @IBOutlet weak var indicatorView        : UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.webViewDesc.alpha = 0

        self.webViewDesc.scrollView.isScrollEnabled = false
        
        self.webViewDesc.configuration.userContentController.addUserScript(getZoomDisableScript())
        self.webViewDesc.navigationDelegate = self
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.webViewDesc.layoutIfNeeded()
        }
        
    }
    
    func getZoomDisableScript() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
}

//MARK: -------------------------  WebView method -------------------------
extension ExerciseContentTblCell : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in

            DispatchQueue.main.async {
                if let vc = self.parentViewController as? ExerciseDetailsListVC{
                    
                    UIView.performWithoutAnimation {
                        vc.tblView.performBatchUpdates {
                        } completion: { isDone in
                        }
                    }
                    
    //                        vc.tblView.beginUpdates()
    //                        vc.tblView.endUpdates()
                }
            }
            
            if (self.webViewDescHeight.constant != 20.0)
            {
                // we already know height, no need to reload cell
                self.indicatorView.isHidden         = true
                AppLoader.shared.removeLoader()
                return
            }
            if complete != nil {
                
                webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                    //self.contentHeights[webView.tag] = height as! CGFloat
                    self.indicatorView.isHidden         = true
                    AppLoader.shared.removeLoader()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
                        //print("-- webView load done: \(height)")
                        self.webViewDesc.alpha              = 1
                        self.webViewDescHeight.constant     = height as! CGFloat
                        
                        if let vc = self.parentViewController as? ExerciseDetailsListVC{
                            
                            vc.tblView.performBatchUpdates {
                            } completion: { isDone in
                            }
                            
                            
            //                        vc.tblView.beginUpdates()
            //                        vc.tblView.endUpdates()
                        }
                    }
                })
            }
        })
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\(navigation.debugDescription)")
    }
    
}


//MARK: -------------------------  UIViewController -------------------------
class ExerciseDetailsListVC : UIViewController {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var tblView          : UITableView!
    @IBOutlet weak var btnMoveTop       : UIButton!

    //MARK:- Class Variable
    var exerciseDetailsType: ExerciseDetailsType = .Exercises
    let viewModel                       = ExerciseDetailsListVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    var object                          = ExerciseDetailListModel()
    var lastSyncDate                    = Date()
    
    var exercise_plan_day_id            = ""
    var routine_id                      = ""
    var plan_type                       = ""
    var exerciseAddedBy                 = ""
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
        
        self.setup(tblView: self.tblView)
        self.configureUI()
        self.setupViewModelObserver()
    }
    
    func configureUI(){
        self.tblView.themeShadow()
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
    
    //MARK: ------------------------- Action Method -------------------------
    @IBAction func btnMoveTopTapped(sender: UIButton){
        self.tblView.scrollToTop()
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tblView.isScrollEnabled = true
        self.updateAPIData(withLoader: true)
        //if self.tblView.contentOffset.y == 0 {
            //self.tblView.isScrollEnabled = false
        //}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.exerciseDetailsType == .Exercises {
            FIRAnalytics.manageTimeSpent(on: .ExercisePlanDayDetailExercise, when: .Appear)
        }
        else {
            FIRAnalytics.manageTimeSpent(on: .ExercisePlanDayDetailBreathing, when: .Appear)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.exerciseDetailsType == .Exercises {
            FIRAnalytics.manageTimeSpent(on: .ExercisePlanDayDetailExercise, when: .Disappear)
        }
        else {
            FIRAnalytics.manageTimeSpent(on: .ExercisePlanDayDetailBreathing, when: .Disappear)
        }
    }
    
}

//MARK: -------------------------- UITableView Methods --------------------------
extension ExerciseDetailsListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        if section == 0 {
            switch self.exerciseDetailsType {
            
            case .Breathing:
                if (self.object.breathingDescription != nil) && (self.object.breathingDescription.trim() != "") {
                    return 1
                }
            case .Exercises:
                if (self.object.exerciseDescription != nil) && (self.object.exerciseDescription.trim() != "") {
                    return 1
                }
            }
            return 0
        }
        else {
            switch self.exerciseDetailsType {
            case .Breathing:
                
                if self.object.breathingData != nil{
                    return self.object.breathingData.count
                }
                return 0
                
            case .Exercises:
                if self.object.exerciseData != nil {
                    return self.object.exerciseData.count
                }
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            switch self.exerciseDetailsType {
            case .Breathing:
                guard self.object.breathingData[indexPath.row].contentData != nil else {
                    return 0
                }
            case .Exercises:
                guard self.object.exerciseData[indexPath.row].contentData != nil else {
                    return 0
                }
            }
        }
        return UITableView.automaticDimension
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell : ExerciseContentTblCell = tableView.dequeueReusableCell(withClass: ExerciseContentTblCell.self, for: indexPath)
            cell.webViewDesc.isHidden   = false
            cell.webViewDesc.tag        = indexPath.row
            //contentCell.webViewDesc.navigationDelegate = self
            cell.indicatorView.isHidden = true
            AppLoader.shared.addLoader()
            switch self.exerciseDetailsType {
            case .Breathing:
                if self.object.breathingDescription.trim() != "" {
                    cell.indicatorView.isHidden = false
                    cell.indicatorView.startAnimating()
                    
                    cell.webViewDesc.loadHTMLString(self.object.breathingDescription.replacingOccurrences(of: """
                                                                \"
                                                                """, with: """
                                                                "
                                                                """), baseURL: Bundle.main.bundleURL)
                    
                    //cell.webViewDesc.isLoading
                }
                
                break
                
            case .Exercises:
                if self.object.exerciseDescription != nil {
                    cell.indicatorView.isHidden = false
                    cell.indicatorView.startAnimating()
                    
                    cell.webViewDesc.loadHTMLString(self.object.exerciseDescription.replacingOccurrences(of: """
                                                                \"
                                                                """, with: """
                                                                "
                                                                """), baseURL: Bundle.main.bundleURL)
                }
                break

            }
            return cell
        }
        else {
            let cell : ExerciseDetailsTblCell = tableView.dequeueReusableCell(withClass: ExerciseDetailsTblCell.self, for: indexPath)
            cell.btnShare.isHidden = true
            switch self.exerciseDetailsType {
            case .Breathing:
                guard let obj = self.object.breathingData[indexPath.row].contentData else {
                    let cell = UITableViewCell(frame: .zero)
                    cell.backgroundColor = .clear
                    return cell
                }
                //let obj = self.object.breathingData[indexPath.row]
                
                cell.lblTitle.text                  = obj.title
                cell.lblDesc.text                   = obj.descriptionField.htmlToString
    //
    //            self.vwTopic.isHidden = true
    //            if self.object.topicName.trim() != "" {
    //                self.vwTopic.isHidden = false
    //                self.lblTopic.text                  = self.object.topicName
    //            }
                
                cell.vwRead.isHidden        = true
                cell.lblRead.text           = AppMessages.Duration + " \(obj.timeDuration!)" + " " + obj.durationUnit
                
                cell.lblFitnessLevel.text   = AppMessages.FitnessLevel + " \(obj.fitnessLevel!)"
                cell.lblExerciseTool.text   = AppMessages.ExerciseTool + " \(obj.exerciseTools!)"
                
                cell.lblReps?.text                   = "\(self.object.breathingData[indexPath.row].unitNo!)" + " \(self.object.breathingData[indexPath.row].unit!)"
                if obj.media.count > 0 {
                    cell.imgTitle.setCustomImage(with: obj.media[0].imageUrl)
                }
                
                cell.vwReps?.isHidden = true
                if plan_type == "custom" {
                    cell.vwReps?.isHidden = false
                }
                
                cell.btnPlay.addTapGestureRecognizer {
                    if obj.media.count > 0 {
                        kGoalMasterId = ""
                        GFunction.shared.openVideoPlayer(strUrl: obj.media[0].mediaUrl,
                                                         parentView: cell.vwImgTitle,
                                                         content_master_id: obj.contentMasterId,
                                                         content_type: obj.contentType)
                        
                        var param = [String : Any]()
                        param[AnalyticsParameters.content_master_id.rawValue]   = obj.contentMasterId
                        param[AnalyticsParameters.content_type.rawValue]        = obj.contentType
                        FIRAnalytics.FIRLogEvent(eventName: .USER_PLAY_VIDEO_EXERCISE,
                                                 screen: .VideoPlayer,
                                                 parameter: nil)
                    }
                }
                
                cell.btnLike.isHidden = obj.likeCapability == "No" ? true : false
                cell.lblLikeCount.isHidden = obj.likeCapability == "No" ? true : false
                
                cell.btnBookmark.isHidden = obj.bookmarkCapability == "No" ? true : false
                
                cell.btnLike.isSelected = obj.liked == "N" ? false : true
                cell.btnBookmark.isSelected = obj.bookmarked == "N" ? false : true
                
                cell.lblLikeCount.text = obj.noOfLikes.roundedWithAbbreviations
                
                cell.btnLike.addTapGestureRecognizer {
                    if cell.btnLike.isSelected {
                        cell.btnLike.isSelected = false
                        obj.liked = "N"
                        obj.noOfLikes -= 1
                        
                        GlobalAPI.shared.update_likesAPI(content_master_id: obj.contentMasterId,
                                                         content_type: obj.contentType,
                                                         is_active: "N",
                                                         screen: .ExercisePlanDayDetailBreathing) { [weak self] (isDone, msg) in
                            guard let self = self else {return}
                            if isDone{
                            }
                        }
                    }
                    else {
                        cell.btnLike.isSelected = true
                        obj.liked = "Y"
                        obj.noOfLikes += 1
                        
                        GlobalAPI.shared.update_likesAPI(content_master_id: obj.contentMasterId,
                                                         content_type: obj.contentType,
                                                         is_active: "Y",
                                                         screen: .ExercisePlanDayDetailBreathing) { [weak self] (isDone, msg) in
                            guard let _ = self else {return}
                            if isDone{
                            }
                        }
                    }
                    
                    self.tblView.reloadData()
                }
                
                cell.btnBookmark.addTapGestureRecognizer {
                    
                    PlanManager.shared.isAllowedByPlan(type: .bookmarks,
                                                       sub_features_id: "",
                                                       completion: { isAllow in
                        if isAllow {
                            if cell.btnBookmark.isSelected {
                                cell.btnBookmark.isSelected = false
                                obj.bookmarked = "N"
                                
                                GlobalAPI.shared.update_bookmarksAPI(content_master_id: obj.contentMasterId,
                                                                     content_type: obj.contentType,
                                                                     is_active: "N",
                                                                     forQuestion: false,
                                                                     screen: .ExercisePlanDayDetailBreathing) { [weak self] (isDone, msg) in
                                    guard let _ = self else {return}
                                    if isDone{
                                    }
                                }
                            }
                            else {
                                cell.btnBookmark.isSelected = true
                                obj.bookmarked = "Y"
                                
                                GlobalAPI.shared.update_bookmarksAPI(content_master_id: obj.contentMasterId,
                                                                     content_type: obj.contentType,
                                                                     is_active: "Y",
                                                                     forQuestion: false,
                                                                     screen: .ExercisePlanDayDetailBreathing) { [weak self] (isDone, msg) in
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
                
                cell.btnInfo?.addTapGestureRecognizer{
                    let vc = ExerciseInfoPopupVC.instantiate(fromAppStoryboard: .exercise)
                    vc.infoTitle = obj.title
                    vc.infoDesc = obj.descriptionField
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                }
                
                break
                
            case .Exercises:
                guard let obj = self.object.exerciseData[indexPath.row].contentData else {
                    let cell = UITableViewCell(frame: .zero)
                    cell.backgroundColor = .clear
                    return cell
                }
                
                cell.lblTitle.text                  = obj.title
                cell.lblDesc.text                   = obj.descriptionField.htmlToString
    //
    //            self.vwTopic.isHidden = true
    //            if self.object.topicName.trim() != "" {
    //                self.vwTopic.isHidden = false
    //                self.lblTopic.text                  = self.object.topicName
    //            }
                
                cell.vwRead.isHidden        = true
                cell.lblRead.text           = AppMessages.Duration + " \(obj.timeDuration!)" + " " + obj.durationUnit
                
                cell.lblFitnessLevel.text   = AppMessages.FitnessLevel + " \(obj.fitnessLevel!)"
                cell.lblExerciseTool.text   = AppMessages.ExerciseTool + " \(obj.exerciseTools!)"
                
                if obj.media.count > 0 {
                    cell.imgTitle.setCustomImage(with: obj.media[0].imageUrl)
                }
                
                cell.btnPlay.addTapGestureRecognizer {
                    if obj.media.count > 0 {
                        kGoalMasterId = ""
                        GFunction.shared.openVideoPlayer(strUrl: obj.media[0].mediaUrl,
                                                         parentView: cell.vwImgTitle,
                                                         content_master_id: obj.contentMasterId,
                                                         content_type: obj.contentType)
                        
                        var param = [String : Any]()
                        param[AnalyticsParameters.content_master_id.rawValue]   = obj.contentMasterId
                        param[AnalyticsParameters.content_type.rawValue]        = obj.contentType
                        FIRAnalytics.FIRLogEvent(eventName: .USER_PLAY_VIDEO_EXERCISE,
                                                 screen: .VideoPlayer,
                                                 parameter: nil)
                    }
                }
                
                cell.btnLike.isHidden = obj.likeCapability == "No" ? true : false
                cell.lblLikeCount.isHidden = obj.likeCapability == "No" ? true : false
                
                cell.btnBookmark.isHidden = obj.bookmarkCapability == "No" ? true : false
                
                cell.btnLike.isSelected = obj.liked == "N" ? false : true
                cell.btnBookmark.isSelected = obj.bookmarked == "N" ? false : true
                
                cell.lblLikeCount.text = obj.noOfLikes.roundedWithAbbreviations
                
                cell.btnLike.addTapGestureRecognizer {
                    if cell.btnLike.isSelected {
                        cell.btnLike.isSelected = false
                        obj.liked = "N"
                        obj.noOfLikes -= 1
                        
                        GlobalAPI.shared.update_likesAPI(content_master_id: obj.contentMasterId,
                                                         content_type: obj.contentType,
                                                         is_active: "N",
                                                         screen: .ExercisePlanDayDetailExercise) { (isDone, msg) in
                            if isDone{
                            }
                        }
                    }
                    else {
                        cell.btnLike.isSelected = true
                        obj.liked = "Y"
                        obj.noOfLikes += 1
                        
                        GlobalAPI.shared.update_likesAPI(content_master_id: obj.contentMasterId,
                                                         content_type: obj.contentType,
                                                         is_active: "Y",
                                                         screen: .ExercisePlanDayDetailExercise) { (isDone, msg) in
                            if isDone{
                            }
                        }
                    }
                    self.tblView.reloadData()
                }
                
                cell.btnBookmark.addTapGestureRecognizer {
                    PlanManager.shared.isAllowedByPlan(type: .bookmarks,
                                                       sub_features_id: "",
                                                       completion: { isAllow in
                        if isAllow {
                            if cell.btnBookmark.isSelected {
                                cell.btnBookmark.isSelected = false
                                obj.bookmarked = "N"
                                
                                GlobalAPI.shared.update_bookmarksAPI(content_master_id: obj.contentMasterId,
                                                                     content_type: obj.contentType,
                                                                     is_active: "N",
                                                                     forQuestion: false,
                                                                     screen: .ExercisePlanDayDetailExercise) { (isDone, msg) in
                                    if isDone{
                                    }
                                }
                            }
                            else {
                                cell.btnBookmark.isSelected = true
                                obj.bookmarked = "Y"
                                
                                GlobalAPI.shared.update_bookmarksAPI(content_master_id: obj.contentMasterId,
                                                                     content_type: obj.contentType,
                                                                     is_active: "Y",
                                                                     forQuestion: false,
                                                                     screen: .ExercisePlanDayDetailExercise) { (isDone, msg) in
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
                
                cell.btnInfo?.addTapGestureRecognizer{
                    let vc = ExerciseInfoPopupVC.instantiate(fromAppStoryboard: .exercise)
                    vc.infoTitle = obj.title
                    vc.infoDesc = obj.descriptionField
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                }
                
                break

            }
            
            return cell
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //self.viewModel.managePagenationContentList(index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension ExerciseDetailsListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Set data Methods --------------------------
extension ExerciseDetailsListVC {
    
    @objc func updateAPIData(withLoader: Bool = false){
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            
            self.viewModel.plan_days_details_API(withLoader: withLoader,
                                                 exercise_plan_day_id: self.exercise_plan_day_id,
                                                 routine: self.routine_id,
                                                 plan_type: self.plan_type,
                                                 type: self.exerciseAddedBy) { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    self.object = self.viewModel.object
                    self.setData()
                    self.tblView.isScrollEnabled = true
                }
            }
        }
    }
    
    func setData(){
        self.tblView.reloadData()
        
        if let vc = self.parent?.parent as? ExerciseDetailsParentVC {
            vc.object = self.viewModel.object
            vc.exerciseDetailsType = self.exerciseDetailsType
            vc.setData()
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension ExerciseDetailsListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResultContentList.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessageContentList
                self.tblView.reloadData()
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

extension ExerciseDetailsListVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.manageScroll(scrollView: scrollView)
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        self.manageScroll(scrollView: scrollView)
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.manageScroll(scrollView: scrollView)
//    }
    
    func manageScroll(scrollView: UIScrollView) {
        //        let scrollViewHeight            = CGFloat(scrollView.frame.size.height)
        //        let scrollContentSizeHeight     = CGFloat(scrollView.contentSize.height)
        
        //let scrollOffset                = CGFloat(self.scrollMain.contentOffset.y)
        let scrollOffset                = CGFloat(scrollView.contentOffset.y)
        print("scrollOffset--------------------------",scrollOffset)
        
        if let vc = self.parent?.parent as? ExerciseDetailsParentVC {
            let topViewHeight       = CGFloat(vc.vwTopParent.frame.maxY)
            if scrollOffset == 0 {
                if let scrollView = vc.scrollMain {
                    scrollView.setContentOffset(.zero, animated: true)
                }
//                self.tblView.isScrollEnabled = false
                self.tblView.isScrollEnabled = true
                
            }
            else if CGFloat(scrollOffset) <= CGFloat(vc.colTitle.frame.maxY) {
                if let scrollView = vc.scrollMain {
                    UIView.animate(withDuration: 0.5) {
                        scrollView.setContentOffset(CGPoint(x: 0, y: topViewHeight), animated: false)
                    }
                }
                self.tblView.isScrollEnabled = true
            }
            //            else if CGFloat(scrollOffset + scrollViewHeight) == CGFloat(scrollContentSizeHeight + vc.colTitle.frame.maxY) {
            //                self.tblView.isScrollEnabled = true
            //            }
        }
    }
}
