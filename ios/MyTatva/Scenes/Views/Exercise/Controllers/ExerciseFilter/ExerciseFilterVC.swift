
import UIKit

class ExerciseFilterVC: ClearNavigationFontBlackBaseVC {
    
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var tblView          : UITableView!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnReset         : UIButton!
    
    //MARK:- Class Variable
    let viewModel                       = ExerciseFilterVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    var arrOfflineobject                = [ExerciseFilterModel]()
    var completionHandler: ((_ obj : [ExerciseFilterModel]?) -> Void)?
    
    var arrDoseOffline : [DoseListModel] = []
    var arrData : [JSON] = [
        [
            "name" : "Languages",
            "short" : [
                [
                    "name" : "English",
                    "isSelected": 0,
                ],
                [
                    "name" : "Gujarati",
                    "isSelected": 0,
                ],
                [
                    "name" : "Hindi",
                    "isSelected": 0,
                ],
                [
                    "name" : "Marathi",
                    "isSelected": 0,
                ],
            ]
        ],
        [
            "name" : "Genres",
            "short" : [
                [
                    "name" : "Article",
                    "isSelected": 0,
                ],
                [
                    "name" : "Video",
                    "isSelected": 0,
                ],
                [
                    "name" : "Photos",
                    "isSelected": 0,
                ],
                [
                    "name" : "Webinar",
                    "isSelected": 0,
                ],
            ]
        ],
        [
            "name" : "Topics",
            "short" : [
                [
                    "name" : "COPD Basics",
                    "isSelected": 0,
                ],
                [
                    "name" : "Medication & Vitals",
                    "isSelected": 0,
                ],
                [
                    "name" : "Trending",
                    "isSelected": 0,
                ],
                [
                    "name" : "Lifestyle",
                    "isSelected": 0,
                ],
                [
                    "name" : "Diet",
                    "isSelected": 0,
                ],
                [
                    "name" : "success stories",
                    "isSelected": 0,
                ],
            ]
        ],
        [
            "name" : "Content Types",
            "short" : [
                [
                    "name" : "Article",
                    "isSelected": 0,
                ],
                [
                    "name" : "Video",
                    "isSelected": 0,
                ],
                [
                    "name" : "Photos",
                    "isSelected": 0,
                ],
                [
                    "name" : "Webinar",
                    "isSelected": 0,
                ],
            ]
        ]
    ]
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {
        self.setupViewModelObserver()
        
        self.lblTitle.font(name: .semibold, size: 22)
            .textColor(color: UIColor.themeBlack)
        
        self.btnReset.font(name: .medium, size: 18)
            .textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 20)
        }
        
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
    }
    
    fileprivate func configureUI(){
    
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
    
    @objc func updateAPIData(){
        self.refreshControl.beginRefreshing()
        self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
        
        self.strErrorMessage = ""
        self.viewModel.content_filtersAPI(tblView: self.tblView, withLoader: false) { (isDone) in
            
            self.refreshControl.endRefreshing()
            self.strErrorMessage = self.viewModel.strErrorMessage
            self.tblView.reloadData()
            if isDone {
            }
        }
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : [ExerciseFilterModel]? = nil) {
        
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
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnSubmit.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: self.viewModel.arrList)
        }
        
        self.btnReset.addTapGestureRecognizer {
            
            for item in self.viewModel.arrList {
                for value in item.arrTime {
                    value.isSelected = false
                }
                for value in item.arrExercise_tools {
                    value.isSelected = false
                }
                for value in item.arrFitnessLevel {
                    value.isSelected = false
                }
                for value in item.filterGenreList {
                    value.isSelected = false
                }
            }
            self.tblView.reloadData()
        }
        
    }
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAPIData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: ------------------ UITableView Methods ------------------
extension ExerciseFilterVC {
    
    fileprivate func setData(){
        
        //Check selected language
        if self.arrOfflineobject.count != 0 {
            for parent in arrOfflineobject {
                for child in self.viewModel.arrList {
                    if parent.type == child.type {
                        let type = ExerciseFilterType.init(rawValue: parent.type) ?? .exercise_tool
                        
                        switch type {
                       
                        case .exercise_tool:
                            
                            for item1 in parent.arrExercise_tools {
                                for item2 in child.arrExercise_tools {
                                    if item1.exerciseTools == item2.exerciseTools {
                                        item2.isSelected = item1.isSelected
                                    }
                                }
                            }
                            break
                        case .genre:
                            for item1 in parent.filterGenreList {
                                for item2 in child.filterGenreList {
                                    if item1.genreMasterId == item2.genreMasterId {
                                        item2.isSelected = item1.isSelected
                                    }
                                    
                                }
                            }
                            break
                        case .fitness_level:
                            for item1 in parent.arrFitnessLevel {
                                for item2 in child.arrFitnessLevel {
                                    if item1.fitnessLevel == item2.fitnessLevel {
                                        item2.isSelected = item1.isSelected
                                    }
                                }
                            }
                            break
                            
                        case .time:
                            for item1 in parent.arrTime {
                                for item2 in child.arrTime {
                                    if item1.showTime == item2.showTime {
                                        item2.isSelected = item1.isSelected
                                    }
                                }
                            }
                            break
                        }
                    }
                }
            }
            self.tblView.reloadData()
        }
    }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension ExerciseFilterVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ExerciseFilterCell = tableView.dequeueReusableCell(withClass: ExerciseFilterCell.self, for: indexPath)

        let object = self.viewModel.getObject(index: indexPath.row)
        
        DispatchQueue.main.async {
            cell.lblTitle.text  = object.label
            cell.type = ExerciseFilterType.init(rawValue: object.type) ?? .exercise_tool
            cell.object         = object
            cell.colView.reloadData()
        }
        
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let object  = self.arrDays[indexPath.row]
//
//
//        for i in 0...self.arrDays.count - 1 {
//            var obj  = self.arrDays[i]
//
//            obj["isSelected"].intValue = 0
//            if obj["name"].stringValue == object["name"].stringValue {
//                obj["isSelected"].intValue = 1
//            }
//            self.arrDays[i] = obj
//        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension ExerciseFilterVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension ExerciseFilterVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.tblView.reloadData()
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
