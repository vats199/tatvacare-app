//
//  ExerciseMoreVC.swift

import UIKit

//MARK: -------------------------  UIViewController -------------------------
class ExerciseMoreVC : UIViewController {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var btnMoveTop           : UIButton!

    //MARK:- Class Variable
    let viewModel                           = ExerciseMoreVM()
    let refreshControl                      = UIRefreshControl()
    var strErrorMessage : String            = ""
    var arrSelectedFilterObject             = [ExerciseFilterModel]()
    var lastSyncDate                        = Date()
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
        self.setData()
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
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          
        WebengageManager.shared.navigateScreenEvent(screen: .ExerciseMore)
        
//        if Calendar.current.dateComponents([.minute], from: lastSyncDate, to: Date()).minute > kAPI_RELOAD_DELAY_BY {
//            self.lastSyncDate = Date()
//        }
        self.updateAPIData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .ExerciseMore, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAnalytics.manageTimeSpent(on: .ExerciseMore, when: .Disappear)
    }
}

//MARK: -------------------------- UITableView Methods --------------------------
extension ExerciseMoreVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCountContentList()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ExerciseMoreTblCell = tableView.dequeueReusableCell(withClass: ExerciseMoreTblCell.self, for: indexPath)
        let object = self.viewModel.getObjectContentList(index: indexPath.row)
        cell.lblTitle.text  = object.genre
        cell.btnViewMore.addTapGestureRecognizer {
            let vc = AllExerciseListVC.instantiate(fromAppStoryboard: .exercise)
            vc.genre_master_id  = object.genreMasterId
            vc.strTitle         = object.genre
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.object = object
        cell.colView.reloadData()
        
        if object.genreMasterId.trim() == "" {
            //This is exercise of the week
            cell.btnViewMore.isHidden = true
            cell.lblTitle
                .font(name: .semibold, size: 23)
                .textColor(color: UIColor.themePurple)
        }
        else {
            cell.btnViewMore.isHidden = false
            cell.lblTitle
                .font(name: .semibold, size: 23)
                .textColor(color: UIColor.themeBlack)
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        self.viewModel.managePagenationContentList(tblView: self.tblView,
                                                   refreshControl: self.refreshControl,
                                                   withLoader: false,
                                                   search: self.strSearch,
                                                   index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension ExerciseMoreVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension ExerciseMoreVC {
    
    @objc func updateAPIData(){
        
        var genre_ids: [String]         = []
        var exercise_tools: [String]    = []
        var fitness_level: [String]     = []
        var show_time: [String]         = []
        
        if arrSelectedFilterObject.count > 0 {
            for item in self.arrSelectedFilterObject {
                let type = ExerciseFilterType.init(rawValue: item.type) ?? .exercise_tool
                
                switch type {
                
                case .exercise_tool:
                    let arrTemp = item.arrExercise_tools.filter { (obj) -> Bool in
                        return obj.isSelected
                    }
                    exercise_tools = arrTemp.map { (obj) -> String in
                        if obj.isSelected {
                            return obj.exerciseTools
                        }
                        return ""
                    }
                    break
                case .genre:
                    let arrTemp = item.filterGenreList.filter { (obj) -> Bool in
                        return obj.isSelected
                    }
                    genre_ids = arrTemp.map { (obj) -> String in
                        if obj.isSelected {
                            return obj.genreMasterId
                        }
                        return ""
                    }
                    break
                case .fitness_level:
                    let arrTemp = item.arrFitnessLevel.filter { (obj) -> Bool in
                        return obj.isSelected
                    }
                    fitness_level = arrTemp.map { (obj) -> String in
                        if obj.isSelected {
                            return obj.fitnessLevel
                        }
                        return ""
                    }
                    break
                case .time:
                    let arrTemp = item.arrTime.filter { (obj) -> Bool in
                        return obj.isSelected
                    }
                    show_time = arrTemp.map { (obj) -> String in
                        if obj.isSelected {
                            return obj.showTime
                        }
                        return ""
                    }
                }
            }
        }
       
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            
            let withLoader = false
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                                tblView: self.tblView,
                                                withLoader: withLoader,
                                                search: self.strSearch,
                                                genre_ids: genre_ids,
                                                exercise_tools: exercise_tools,
                                                fitness_level: fitness_level)
            }
        }
    }
    
    func setData(){
        
    }

}

//MARK: -------------------- GlobalSearch Methods --------------------
extension ExerciseMoreVC {
    
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
extension ExerciseMoreVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResultContentList.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                DispatchQueue.main.async {
                    self.strErrorMessage = self.viewModel.strErrorMessageContentList
                    self.tblView.reloadData()
                }
                
                if self.viewModel.arrListContentList.count > 0 {
                    self.btnMoveTop.isHidden = true
                }
                else {
                    self.btnMoveTop.isHidden = true
                }
                
                self.startAppTour()

                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
    }
    
    func startAppTour(){
        DispatchQueue.main.async {
            
            if self.isContinueCoachmark {
                self.isContinueCoachmark = false
                self.tblView.scrollToTop(animated: false)
                let vc = CoachmarkExerciseExploreVC.instantiate(fromAppStoryboard: .home)
                vc.targetView = self.tblView
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.completionHandler = { obj in
                    if obj?.count > 0 {
                        FIRAnalytics.FIRLogEvent(eventName: .USER_COMPLETED_COACH_MARKS,
                                                 screen: .ExerciseMore,
                                                 parameter: nil)
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
