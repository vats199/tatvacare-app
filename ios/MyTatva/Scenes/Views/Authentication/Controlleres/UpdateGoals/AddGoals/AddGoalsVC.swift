class AddGoalsVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var tblView      : UITableView!
    @IBOutlet weak var searchBar    : UISearchBar!
    @IBOutlet weak var btnSubmit    : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = AddGoalsVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    
    var completionHandler: ((_ obj : [GoalListModel]?) -> Void)?
    
    var arrDataOffline : [GoalListModel] = []
    var arrData : [JSON] = [
        [
            "img" : "goals_calories",
            "name" : "Calories",
            "desc" : "2500  calories per day",
            "type": GoalType.Calories.rawValue,
            "isSelected": 0,
        ],
        [
            "img" : "goals_steps",
            "name" : "Steps",
            "desc" : "2500 steps per day",
            "type": GoalType.Steps.rawValue,
            "isSelected": 0,
        ],
        [
            "img" : "goals_exercise",
            "name" : "Exercise",
            "desc" : "30 minutes per day",
            "type": GoalType.Exercise.rawValue,
            "isSelected": 0,
        ],
        [
            "img" : "goals_pranayam",
            "name" : "Pranayam",
            "desc" : "30 minutes per day",
            "type": GoalType.Pranayam.rawValue,
            "isSelected": 0,
        ],
        [
            "img" : "goals_sleep",
            "name" : "Sleep",
            "desc" : "30 minutes per day",
            "type": GoalType.Sleep.rawValue,
            "isSelected": 0,
        ],
        [
            "img" : "goals_water",
            "name" : "Water",
            "desc" : "30 minutes per day",
            "type": GoalType.Water.rawValue,
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
        self.searchBar.isHidden = true
        self.configureUI()
        self.manageActionMethods()
    }
    
    @objc func updateAPIData(){
        self.strErrorMessage = ""
        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                        tblView: self.tblView,
                                        withLoader: true)
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
//        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
//        self.tblView.addSubview(self.refreshControl)
           
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        
        self.btnSubmit.addTapGestureRecognizer {
//            var arrTemp     = [JSON]()
//            for i in 0...self.arrData.count - 1 {
//                let obj  = self.arrData[i]
//
//                if obj["isSelected"].intValue == 1 {
//                    arrTemp.append(obj)
//                }
//            }
            
            let arrTemp = self.viewModel.getSelectedObject()
            
            if let completionHandler = self.completionHandler {
                completionHandler(arrTemp)
            }
            self.navigationController?.popViewController(animated: true)
        }
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.viewModel.apiCallFromStart(tblView: self.tblView,
                                   withLoader: true)
        WebengageManager.shared.navigateScreenEvent(screen: .SelectGoals)
        
//        self.viewModel.apiCallFromStart(tblView: self.tblView,
//                                   withLoader: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .SelectGoals, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAnalytics.manageTimeSpent(on: .SelectGoals, when: .Disappear)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension AddGoalsVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : LanguageTblCell = tableView.dequeueReusableCell(withClass: LanguageTblCell.self, for: indexPath)

        let object              = self.viewModel.getObject(index: indexPath.row)
//        let type = GoalType.init(rawValue: object["type"].stringValue) ?? .Calories
//        cell.imgView.image      = type.image//UIImage(named: object["img"].stringValue)
        cell.imgView.image      = nil
        cell.imgView.setCustomImage(with: object.imageUrl)
        cell.lblTitle.text      = object.goalName
    
        cell.btnSelect.isHidden = false
        if object.mandatory == "Y" {
            cell.btnSelect.isHidden     = true
            object.isSelected           = true
        }
        
        cell.btnSelect.isSelected = false
        if object.isSelected {
            cell.btnSelect.isSelected = true
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.manageSelection(index: indexPath.row)
        
        let object = self.viewModel.getObject(index: indexPath.row)
        var params = [String: Any]()
        params[AnalyticsParameters.goal_name.rawValue]  = object.goalName
        params[AnalyticsParameters.goal_id.rawValue]    = object.goalMasterId
        if object.isSelected {
            params[AnalyticsParameters.is_select.rawValue] = "1"
        }
        else {
            params[AnalyticsParameters.is_select.rawValue] = "0"
        }
        FIRAnalytics.FIRLogEvent(eventName: .USER_SELECT_GOAL,
                                 screen: .SelectGoals,
                                 parameter: params)
        
//        let object  = self.arrData[indexPath.row]
//        for i in 0...self.arrData.count - 1 {
//            var obj  = self.arrData[i]
//
//            if obj["name"].stringValue == object["name"].stringValue {
//                if obj["isSelected"].intValue == 1 {
//                    obj["isSelected"].intValue = 0
//                }
//                else {
//                    obj["isSelected"].intValue = 1
//                }
//            }
//            self.arrData[i] = obj
//        }
        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension AddGoalsVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension AddGoalsVC {
    
    fileprivate func setData(){
        if self.arrDataOffline.count > 0 {
            if viewModel.arrList.count > 0 {
                
                for parent in self.viewModel.arrList {
                    parent.isSelected = false
                    
                    for child in self.arrDataOffline {
                        if parent.goalMasterId == child.goalMasterId {
                            parent.isSelected = true
                        }
                    }
                }
                self.tblView.reloadData()
            }
        }
        
//        if self.arrDataOffline.count > 0 {
//            for i in 0...self.arrData.count - 1 {
//                var parent = self.arrData[i]
//
//                for item in self.arrDataOffline {
//
//                    parent["isSelected"].intValue = 0
//                    if item["name"].stringValue == parent["name"].stringValue {
//                        parent["isSelected"].intValue = 1
//                        self.arrData[i] = parent
//                    }
//                }
//            }
//            self.tblView.reloadData()
//        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension AddGoalsVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
