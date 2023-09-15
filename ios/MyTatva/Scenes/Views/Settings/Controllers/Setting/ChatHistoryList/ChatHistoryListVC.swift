
import UIKit

class ChatHistoryListCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var lblDesc2         : UILabel!
    @IBOutlet weak var lblTime          : UILabel!
    
    //MARK:- Class Variable
    var arrData = [JSON]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.lblTitle.font(name: .bold, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblDesc2.font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblTime.font(name: .regular, size: 10)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.vwBg.themeShadow()
            
            self.imgView.layoutIfNeeded()
            self.imgView.cornerRadius(cornerRadius: 10)
        }
    }
}

class ChatHistoryListVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var btnSearch        : UIButton!
    
    @IBOutlet weak var vwBot            : UIView!
    @IBOutlet weak var imgBot           : UIImageView!
    @IBOutlet weak var lblBotTitle      : UILabel!
    @IBOutlet weak var lblBotDesc       : UILabel!
    @IBOutlet weak var lblBotDesc2      : UILabel!
    @IBOutlet weak var lblBotTime       : UILabel!
    
    @IBOutlet weak var vwChatHC         : UIView!
    @IBOutlet weak var imgChatHC        : UIImageView!
    @IBOutlet weak var lblChatHCTitle     : UILabel!
    
    @IBOutlet weak var tblView          : UITableView!
    @IBOutlet weak var btnClose         : UIButton!
    
    //MARK: -------------------- Class Variable --------------------
    let viewModel                       = ChatHistoryListVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    
    ///set up DiffableDataSource of list table
    typealias tblDataSource = UITableViewDiffableDataSource<Int, HealthCoachListModel>
    lazy var dataSource: tblDataSource = {
      let datasource = tblDataSource(tableView: self.tblView,
                                         cellProvider: { (tableView, indexPath, object) -> UITableViewCell? in
          let cell      = tableView.dequeueReusableCell(withClass: ChatHistoryListCell.self, for: indexPath)
          
          let object = self.viewModel.getObject(index: indexPath.row)
          cell.imgView.setCustomImage(with: object.profilePic)
          cell.lblTitle.text      = object.firstName + " " + object.lastName
          cell.lblDesc.text       = object.role
          cell.lblDesc2.text      = ""
          cell.lblTime.text       = ""
          
          cell.imgView.addTapGestureRecognizer {
              GlobalAPI.shared.getHealthCoachDetailsAPI(health_coach_id: object.healthCoachId) { [weak self] isDone, obj in
                  
                  guard let self = self else {return}
                  
                  if isDone {
                      
                      let vc1 = HealthCoachDetailsVC.instantiate(fromAppStoryboard: .setting)
                      vc1.object = obj
                      vc1.modalPresentationStyle = .overCurrentContext
                      vc1.modalTransitionStyle = .crossDissolve
                      vc1.hidesBottomBarWhenPushed = true
                      let nav = UINavigationController(rootViewController: vc1)
                      self.present(nav, animated: true, completion: nil)
                      
                  }
              }
          }
          
          return cell
      })
      return datasource
    }()
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    var arrDoseOffline : [HealthCoachListModel] = []
    var arrData : [JSON] = [
        [
            "name" : "It’s spam",
            "isSelected": 0,
            "type": "S"
        ],
        [
            "name" : "It‘s inappropriate",
            "isSelected": 0,
            "type": "I"
        ],
        [
            "name" : "It’s false information",
            "isSelected": 0,
            "type": "F"
        ]
    ]
    
    //MARK: -------------------- Memory Management Method --------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    
    //MARK: -------------------- Custom Method --------------------
    fileprivate func setUpView() {
        self.setupViewModelObserver()
        
        self.vwBot.isHidden = false
        self.lblBotTitle.font(name: .bold, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblBotDesc.font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblBotDesc2.font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack)
        self.lblBotTime.font(name: .regular, size: 10)
            .textColor(color: UIColor.themeBlack)
        
        self.lblChatHCTitle.font(name: .bold, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        Settings().isHidden(setting: .chat_bot) { isHidden in
            self.vwBot.isHidden = isHidden
        } 
        
        self.configureUI()
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
        self.setupHero()
        self.setup(tblView: self.tblView)
    }
    
    fileprivate func setupHero(){
        self.hero.isEnabled         = true
        self.vwBg.hero.id           = "btnChat"
        self.vwBg.hero.modifiers    = [.translate(x:100)]
    }
    
    @objc func updateAPIData(withLoader: Bool){
        self.applySnapshot()
        self.strErrorMessage = ""
        
        self.vwChatHC.isHidden = true
        PlanManager.shared.isAllowedByPlan(type: .coach_list,
                                           sub_features_id: "",
                                           completion: { isAllow in
            if isAllow{
                if UserModel.shared.hcList != nil && UserModel.shared.hcList.count > 0 {
                    Settings().isHidden(setting: .hide_home_chat_bubble_hc) { isHidden in
                        self.vwChatHC.isHidden = isHidden
                    }
                }
                //                self.chatHistoryListVM.apiCallFromStart(list_type: "A",
                //                                                        refreshControl: self.refreshControl,
                //                                                        tblView: self.tblHC,
                //                                                        withLoader: withLoader)
            }
        })
    }
    
    fileprivate func configureUI(){
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 20)
            
            self.vwBot.layoutIfNeeded()
            self.vwBot.cornerRadius(cornerRadius: 10)
            
            self.imgBot.layoutIfNeeded()
            self.imgBot.cornerRadius(cornerRadius: 10)
            
            let colorvwDoctorQuotesBg = GFunction.shared.applyGradientColor(startColor: UIColor.themeLightPurple.withAlphaComponent(0.1),
                                                            endColor: UIColor.themeLightPurple.withAlphaComponent(1),
                                                            locations: [0, 1],
                                                            startPoint: CGPoint(x: 0, y: self.vwBot.frame.maxY),
                                                            endPoint: CGPoint(x: self.vwBot.frame.maxX, y: self.vwBot.frame.maxY),
                                                            gradiantWidth: self.vwBot.frame.width,
                                                            gradiantHeight: self.vwBot.frame.height)
            
            
            self.vwBot.backgroundColor = colorvwDoctorQuotesBg
            self.vwBot.themeShadow()
            
            self.imgChatHC.layoutIfNeeded()
            self.imgChatHC.cornerRadius(cornerRadius: 10)
            
            self.vwChatHC.layoutIfNeeded()
            self.vwChatHC.cornerRadius(cornerRadius: 10)
                .backGroundColor(color: colorvwDoctorQuotesBg)
                .themeShadow()
                
        }
    }
    
    fileprivate func setup(tblView: UITableView){
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
//        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
    }
    
    func applySnapshot(arr: [HealthCoachListModel]? = nil){
        ///Apply snapshot
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteAllItems()
        if let arr = arr {
            snapshot.appendSections([0])
            snapshot.appendItems(arr, toSection: 0)
        }
        self.dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : JSON? = nil) {
        
        func sendData() {
            if let obj = objAtIndex {
                if let completionHandler = completionHandler {
                    completionHandler(obj)
                }
            }
        }
        
        self.dismiss(animated: animated) {
            sendData()
        }
    }
    
    //MARK: -------------------- Action Method --------------------
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnClose.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.vwBot.addTapGestureRecognizer {
            PlanManager.shared.isAllowedByPlan(type: .chatbot,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow{
                    let vc1 = WebviewChatBotVC.instantiate(fromAppStoryboard: .setting)
                    vc1.modalPresentationStyle = .overFullScreen
                    vc1.modalTransitionStyle = .coverVertical
                    vc1.hidesBottomBarWhenPushed = true
                    let nav = UINavigationController(rootViewController: vc1)
                    self.present(nav, animated: true, completion: nil)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
        
        self.vwChatHC.addTapGestureRecognizer {
            PlanManager.shared.isAllowedByPlan(type: .chat_healthcoach,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow{
                    FreshDeskManager.shared.showConversations(tags: [""],
                                                              screen: .ChatList)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
    }
    
    //MARK: -------------------- Life Cycle Method --------------------
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .ChatList)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.updateAPIData(withLoader: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: -------------------- UITableView Methods --------------------
extension ChatHistoryListVC: UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ChatHistoryListCell = tableView.dequeueReusableCell(withClass: ChatHistoryListCell.self, for: indexPath)

        let object = self.viewModel.getObject(index: indexPath.row)
        cell.imgView.setCustomImage(with: object.profilePic)
        cell.lblTitle.text      = object.firstName + " " + object.lastName
        cell.lblDesc.text       = object.role
        cell.lblDesc2.text      = ""
        cell.lblTime.text       = ""
        
        cell.imgView.addTapGestureRecognizer {
            GlobalAPI.shared.getHealthCoachDetailsAPI(health_coach_id: object.healthCoachId) {   [weak self] isDone, obj in
                
                guard let self = self else {return}
                
                if isDone {
                    
                    let vc1 = HealthCoachDetailsVC.instantiate(fromAppStoryboard: .setting)
                    vc1.object = obj
                    vc1.modalPresentationStyle = .overCurrentContext
                    vc1.modalTransitionStyle = .crossDissolve
                    vc1.hidesBottomBarWhenPushed = true
                    let nav = UINavigationController(rootViewController: vc1)
                    self.present(nav, animated: true, completion: nil)
                    
                }
            }
            
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.viewModel.getObject(index: indexPath.row)
        PlanManager.shared.isAllowedByPlan(type: .chat_healthcoach,
                                           sub_features_id: "",
                                           completion: { isAllow in
            if isAllow{
                FreshDeskManager.shared.health_coach_id = object.healthCoachId
                FreshDeskManager.shared.showConversations(tags: [object.tagName],
                                                          screen: .ChatList)
            }
            else {
                PlanManager.shared.alertNoSubscription()
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension ChatHistoryListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension ChatHistoryListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
            
                self.applySnapshot(arr: self.viewModel.arrList)
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                break
            case .none: break
            }
        })
    }
}
    
