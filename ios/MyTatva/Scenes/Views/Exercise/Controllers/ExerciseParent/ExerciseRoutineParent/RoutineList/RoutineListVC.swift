//

//  MyTatva
//
//  Created by Darshan Joshi on 11/4/23.
//

import UIKit
import AVKit

class RoutineListCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var lblTopTitle          : UILabel!
    @IBOutlet weak var btnDone              : UIButton!
    
    @IBOutlet weak var vwImgTitle           : UIView!
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var btnPlay              : UIButton!
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var lblExerciseType      : UILabel!
    @IBOutlet weak var lblExerciseTypeVal   : UILabel!
    
    @IBOutlet weak var lblReps              : UILabel!
    @IBOutlet weak var lblRepsVal           : UILabel!
    
    @IBOutlet weak var lblSets              : UILabel!
    @IBOutlet weak var lblSetsVal           : UILabel!
    
    @IBOutlet weak var lblRestPostSets      : UILabel!
    @IBOutlet weak var lblRestPostSetsVal   : UILabel!
    
    @IBOutlet weak var lblRestPostExercise  : UILabel!
    @IBOutlet weak var lblRestPostExerciseVal : UILabel!
    
    @IBOutlet weak var btnReadMore          : UIButton!
    
    var videoUrl: URL?
    var player: AVPlayer?
    let avPVC = AVPlayerViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTopTitle
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        self.btnDone
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeGray)
        
        self.lblDesc
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        
        self.btnReadMore
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
    
        self.lblExerciseType
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblExerciseTypeVal
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblReps
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblRepsVal
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblSets
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblSetsVal
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblRestPostSets
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblRestPostSetsVal
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblRestPostExercise
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblRestPostExerciseVal
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
    
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.vwImgTitle.layoutIfNeeded()
            self.vwImgTitle.roundCorners([.topLeft, .topRight], radius: 10)
            
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.vwBg.themeShadow()
            
            self.btnDone.layoutIfNeeded()
            self.btnDone.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
                .backGroundColor(color: .white)
            
            self.btnPlay.layoutIfNeeded()
            self.btnPlay.themeShadow()
        }
    }
    
}

//MARK: -------------------------  UIViewController -------------------------
class RoutineListVC : WhiteNavigationBaseVC {
    
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
        //self.tblView.themeShadow()
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
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        WebengageManager.shared.navigateScreenEvent(screen: .ExerciseViewAll)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

//MARK: -------------------------- UITableView Methods --------------------------
extension RoutineListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RoutineListCell = tableView.dequeueReusableCell(withClass: RoutineListCell.self, for: indexPath)
        
        let obj = self.viewModel.getObject(index: indexPath.row)

//        cell.lblTitle.text                  = obj.title
        cell.lblDesc.text                   = obj.descriptionField.htmlToString
        //
        //            self.vwTopic.isHidden = true
        //            if self.object.topicName.trim() != "" {
        //                self.vwTopic.isHidden = false
        //                self.lblTopic.text                  = self.object.topicName
        //            }
 
 
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
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row,
//                                        genre_master_id: self.genre_master_id)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension RoutineListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension RoutineListVC {
    
    @objc func updateAPIData(withLoader: Bool = false){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.strErrorMessage = ""
            self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                            tblView: self.tblView,
                                            withLoader: withLoader,
                                            genre_master_id: "22c7afe4-411e-11ec-ae06-4ec4eb4dc0dd")
        }
    }
    
    func setData(){
        self.tblView.reloadData()
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension RoutineListVC {
    
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
