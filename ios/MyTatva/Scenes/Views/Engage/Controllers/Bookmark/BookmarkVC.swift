
import UIKit

class BookmarkTitleCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnViewAll   : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .medium, size: 17)
            .textColor(color: UIColor.themeBlack)
        
        self.btnViewAll
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
        
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 7)
        }
    }
}

class BookmarkContentCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var imgTitle     : UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblTime      : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.lblTime
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeGray)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.cornerRadius(cornerRadius: 4)
            //self.vwBg.cornerRadius(cornerRadius: 7)
        }
    }
}

class BookmarkVC: WhiteNavigationBaseVC {

    //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var tblView      : UITableView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = BookmarkVM()
    let refreshControl              = UIRefreshControl()
    var isEdit                      = false
    
    var strErrorMessage : String    = ""
    var timerSearch                 = Timer()
    
    var completionHandler: ((_ obj : LanguageListModel) -> Void)?
    //Language: English, Hindi, Kannada
    var arrData : [JSON] = [
        [
            "name" : "English",
            "isSelected": 1,
        ],
        [
            "name" : "Hindi",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ]
    ]
    
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        
        self.configureUI()
        self.manageActionMethods()
        self.tblView.themeShadow()
      
    }
    
    @objc func updateAPIData(){
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                                tblView: self.tblView,
                                                withLoader: false)
            }
        }
    }
    
    //Desc:- Set layout desing customize
    func configureUI(){
    
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
        
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        
    }
    
    @IBAction func btnMoveTopTapped(sender: UIButton){
        self.tblView.scrollToTop()
    }
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .BookmarkList)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = .default
        self.updateAPIData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func onGoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension BookmarkVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell : BookmarkTitleCell = tableView.dequeueReusableCell(withClass: BookmarkTitleCell.self)
    
        let obj = self.viewModel.getObject(index: section)
        cell.lblTitle.text = obj.displayValue
        
        cell.btnViewAll.addTapGestureRecognizer {
            print("view all")
            let vc = ViewAllBookmarkVC.instantiate(fromAppStoryboard: .engage)
            vc.type = obj.type
            vc.currentBookmarkType = obj.displayValue
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell.contentView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getObject(index: section).data.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : BookmarkContentCell = tableView.dequeueReusableCell(withClass: BookmarkContentCell.self, for: indexPath)
    
        let object = self.viewModel.getObject(index: indexPath.section).data[indexPath.row]
        
        cell.imgTitle.alpha = 0
        if object.media.count > 0 {
            cell.imgTitle.alpha = 1
            cell.imgTitle.setCustomImage(with: object.media[0].imageUrl)
        }
        
        cell.lblTitle.text = object.title
        let start_Time = GFunction.shared.convertDateFormate(dt: object.updatedAt,
                                                           inputFormat:  DateTimeFormaterEnum.UTCFormat.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                           status: .NOCONVERSION)
        cell.lblTime.text = start_Time.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            cell.vwBg.layoutIfNeeded()
            if indexPath.row == self.viewModel.getObject(index: indexPath.section).data.count - 1 {
                cell.vwBg.roundCorners([.bottomLeft, .bottomRight], radius: 7)
            }
            else {
                cell.vwBg.roundCorners([.bottomLeft, .bottomRight], radius: 0)
            }
        }
        
        if object.contentType == "AskAnExpert" {
            cell.imgTitle.isHidden = true
        }
        else {
            cell.imgTitle.isHidden = false
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.viewModel.getObject(index: indexPath.section).data[indexPath.row]
        if object.contentType == "ExerciseVideo" {
            if object.media.count > 0 {
                kGoalMasterId = ""
                GFunction.shared.openVideoPlayer(strUrl: object.media[0].mediaUrl,
                                                 content_master_id: object.contentMasterId,
                                                 content_type: object.contentType)
                
                var param = [String : Any]()
                param[AnalyticsParameters.content_master_id.rawValue]   = object.contentMasterId
                param[AnalyticsParameters.content_type.rawValue]        = object.contentType
                FIRAnalytics.FIRLogEvent(eventName: .USER_PLAY_VIDEO_EXERCISE,
                                         screen: .VideoPlayer,
                                         parameter: nil)
            }
        }
        else if object.contentType == "AskAnExpert" {
            let vc = AskExpertQuestionDetailsVC.instantiate(fromAppStoryboard: .engage)
            vc.contentMasterId = object.contentMasterId
            vc.completionHandler = { obj in
                if obj != nil {
                    if obj!.contentMasterId != nil {
                        
                        //self.viewModel.arrListContentList[index] = obj!
                        self.tblView.reloadData()
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
        else {
            let vc = EngageContentDetailVC.instantiate(fromAppStoryboard: .engage)
            vc.contentMasterId = object.contentMasterId
            vc.completionHandler = { obj in
                if obj != nil {
                    if vc.object.contentMasterId != nil {
                        //self.viewModel.arrListContentList[indexPath.row] = vc.object
                        self.tblView.reloadData()
                    }
                }
            }
            //vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension BookmarkVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension BookmarkVC {
    
    fileprivate func setData(){
        
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension BookmarkVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.setData()
                self.tblView.reloadData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
                                                               
