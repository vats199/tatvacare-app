
import UIKit

class DiscoverEngageFilterVC: ClearNavigationFontBlackBaseVC {
    
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var btnStatus        : UIButton!
    @IBOutlet weak var tblView          : UITableView!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnReset         : UIButton!
    
    //MARK:- Class Variable
    let viewModel                       = DiscoverEngageFilterVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    var object                          = ContenFilterListModel()
    var offlineobject                   = ContenFilterListModel()
    var completionHandler: ((_ obj : ContenFilterListModel?) -> Void)?
    
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
        self.lblDesc.font(name: .regular, size: 14)
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
        self.viewModel.content_filtersAPI(tblView: self.tblView,
                                          withLoader: false) { [weak self] (isDone) in
            guard let self = self else {return}
            
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
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : ContenFilterListModel? = nil) {
        
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
//            var arrTemp     = [JSON]()
//            for i in 0...self.arrDays.count - 1 {
//                let obj  = self.arrDays[i]
//
//                if obj["isSelected"].intValue == 1 {
//                    arrTemp.append(obj)
//                }
//            }
            let objTemp = ContenFilterListModel()
            objTemp.language = [LanguageListModel]()
            objTemp.genre = [FilterGenreListModel]()
            objTemp.topic = [TopicListModel]()
            objTemp.contentType = [FilterContenTypeListModel]()
            objTemp.isShowContentFromDocHealthCoach = self.object.isShowContentFromDocHealthCoach
            
            if self.object.language != nil {
                for item in self.object.language {
                    if item.isSelected {
                        objTemp.language.append(item)
                    }
                }
                for item in self.object.genre {
                    if item.isSelected {
                        objTemp.genre.append(item)
                    }
                }
                for item in self.object.topic {
                    if item.isSelected {
                        objTemp.topic.append(item)
                    }
                }
                for item in self.object.contentType {
                    if item.isSelected {
                        objTemp.contentType.append(item)
                    }
                }
            }
            
            self.dismissPopUp(true, objAtIndex: objTemp)
        }
        
        self.btnReset.addTapGestureRecognizer {
            
            self.object.isShowContentFromDocHealthCoach = false
            
            if self.object.language != nil {
                for item in self.object.language {
                    item.isSelected = false
                }
            }
            
            if self.object.genre != nil {
                for item in self.object.genre {
                    item.isSelected = false
                }
            }
            
            if self.object.topic != nil {
                for item in self.object.topic {
                    item.isSelected = false
                }
            }
            
            if self.object.contentType != nil {
                for item in self.object.contentType {
                    item.isSelected = false
                }
            }
            
            self.tblView.reloadData()
        }
        
        self.btnStatus.addTapGestureRecognizer {
            self.btnStatus.isSelected = !self.btnStatus.isSelected
            self.object.isShowContentFromDocHealthCoach = self.btnStatus.isSelected
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
extension DiscoverEngageFilterVC {
    
    fileprivate func setData(){
        
        //Check selected language
        if self.offlineobject.language != nil {
            if self.offlineobject.language.count > 0 {
                for parent in self.offlineobject.language {
                    for child in self.object.language {
                        if parent.languagesId == child.languagesId {
                            child.isSelected = true
                        }
                    }
                }
            }
            self.tblView.reloadData()
        }
        
        self.object.isShowContentFromDocHealthCoach = self.offlineobject.isShowContentFromDocHealthCoach
        self.btnStatus.isSelected = self.object.isShowContentFromDocHealthCoach
        
        //Check selected genre
        if self.offlineobject.genre != nil {
            if self.offlineobject.genre.count > 0 {
                for parent in self.offlineobject.genre {
                    for child in self.object.genre {
                        if parent.genreMasterId == child.genreMasterId {
                            child.isSelected = true
                        }
                    }
                }
            }
            self.tblView.reloadData()
        }
        
        //Check selected topic
        if self.offlineobject.topic != nil {
            if self.offlineobject.topic.count > 0 {
                for parent in self.offlineobject.topic {
                    for child in self.object.topic {
                        if parent.topicMasterId == child.topicMasterId {
                            child.isSelected = true
                        }
                    }
                }
            }
            self.tblView.reloadData()
        }
        
        //Check selected content type
        if self.offlineobject.contentType != nil {
            if self.offlineobject.contentType.count > 0 {
                for parent in self.offlineobject.contentType {
                    for child in self.object.contentType {
                        if parent.keys == child.keys {
                            child.isSelected = true
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
extension DiscoverEngageFilterVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : DiscoverEngageFilterTblCell = tableView.dequeueReusableCell(withClass: DiscoverEngageFilterTblCell.self, for: indexPath)

        //let object = self.arrData[indexPath.row]
        //cell.arrData = object["short"].arrayValue
        
        DispatchQueue.main.async {
            cell.object = self.object
            
            switch indexPath.row {
//            case 0:
//                cell.lblTitle.text  = "Languages"
//                cell.type           = .Languages
//                break
//            case 1:
//                cell.lblTitle.text  = "Genres"
//                cell.type           = .Genres
//                break
            case 0:
                cell.lblTitle.text  = "Topics"
                cell.type           = .Topics
                break
            case 1:
                cell.lblTitle.text  = "Content Types"
                cell.type           = .ContentTypes
                break
            default:break
            }
            
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
extension DiscoverEngageFilterVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension DiscoverEngageFilterVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.object = self.viewModel.object
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
