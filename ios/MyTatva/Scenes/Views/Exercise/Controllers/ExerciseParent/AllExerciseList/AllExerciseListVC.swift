//
//  AllExerciseListVC.swift
//  MyTatva
//
//  Created by Darshan Joshi on 09/11/21.
//

import UIKit

//MARK: -------------------------  UIViewController -------------------------
class AllExerciseListVC : WhiteNavigationBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var tblView          : UITableView!
    @IBOutlet weak var btnMoveTop       : UIButton!

    //MARK:- Class Variable
    var exerciseDetailsType: ExerciseDetailsType = .Exercises
    let viewModel                       = AllExerciseListVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    var lastSyncDate                    = Date()
    var genre_master_id                 = ""
    var strTitle                        = ""
    
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
        
        self.lblTitle.text = self.strTitle
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
        
       self.updateAPIData(withLoader: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        WebengageManager.shared.navigateScreenEvent(screen: .ExerciseViewAll)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

//MARK: -------------------------- UITableView Methods --------------------------
extension AllExerciseListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ExerciseDetailsTblCell = tableView.dequeueReusableCell(withClass: ExerciseDetailsTblCell.self, for: indexPath)
        
        let obj = self.viewModel.getObject(index: indexPath.row)

        cell.lblTitle.text                  = obj.title
        cell.lblDesc.text                   = obj.descriptionField.htmlToString
        //
        //            self.vwTopic.isHidden = true
        //            if self.object.topicName.trim() != "" {
        //                self.vwTopic.isHidden = false
        //                self.lblTopic.text                  = self.object.topicName
        //            }
        cell.vwRead.isHidden        = true
        cell.lblRead.text           = "\(AppMessages.Duration) \(obj.timeDuration!)" + " " + obj.durationUnit
        
        cell.lblFitnessLevel.text   = AppMessages.FitnessLevel + " \(obj.fitnessLevel!)"
        cell.lblExerciseTool.text   = AppMessages.ExerciseTool + " \(obj.exerciseTools!)"
        
        if obj.media.count > 0 {
            cell.imgTitle.setCustomImage(with: obj.media[0].imageUrl)
        }

        cell.btnPlay.addTapGestureRecognizer {
            if obj.media.count > 0 {
                kGoalMasterId = obj.goalMasterId
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
                                                 screen: .ExerciseViewAll) { (isDone, msg) in
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
                                                 screen: .ExerciseViewAll) { (isDone, msg) in
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
                                                             screen: .ExerciseViewAll) { (isDone, msg) in
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
                                                             screen: .ExerciseViewAll) { (isDone, msg) in
                            if isDone {
                            }
                        }
                    }
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
            
        }
        
        cell.btnInfo?.addTapGestureRecognizer {
            let vc = ExerciseInfoPopupVC.instantiate(fromAppStoryboard: .exercise)
            vc.infoTitle = obj.title
            vc.infoDesc = obj.descriptionField
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        self.viewModel.managePagenation(tblView: self.tblView,
                                        index: indexPath.row,
                                        genre_master_id: self.genre_master_id)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension AllExerciseListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension AllExerciseListVC {
    
    @objc func updateAPIData(withLoader: Bool = false){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.strErrorMessage = ""
            self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                            tblView: self.tblView,
                                            withLoader: withLoader,
                                            genre_master_id: self.genre_master_id)
        }
    }
    
    func setData(){
        self.tblView.reloadData()
       
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension AllExerciseListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.tblView.reloadData()
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
