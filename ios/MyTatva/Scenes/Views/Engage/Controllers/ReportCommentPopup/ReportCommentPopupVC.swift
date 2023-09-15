
import UIKit

enum ReportType: String {
    case contentComment
    case question
    case answer
    case answerComment
}

class ReportCommentPopupCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    
    //MARK:- Class Variable
    var arrData = [JSON]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.lblTitle.font(name: .semibold, size: 17)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
                .borderColor(color: UIColor.colorReport, borderWidth: 1)
        }
    }
}

class ReportCommentPopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var tblView          : UITableView!
    @IBOutlet weak var tblViewHeight    : NSLayoutConstraint!
    
    @IBOutlet weak var tvDesc           : UITextView!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    
    //MARK:- Class Variable
    let viewModel                       = ReportCommentPopupVM()
    let askExpertviewModel              = AskExpertListVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    
    var content_master_id               = ""
    var content_type                    = ""
    var content_comments_id             = ""
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    var reportType: ReportType = .contentComment
    
    var arrDoseOffline : [DoseListModel] = []
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
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
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
            .textColor(color: UIColor.themeRed)
        
        self.tvDesc
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack)
        
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
//        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
//        self.tblView.addSubview(self.refreshControl)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 20)
        }
        DispatchQueue.main.async {
            self.tvDesc.layoutIfNeeded()
            self.tvDesc.cornerRadius(cornerRadius: 10)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
        }
    }
    
    @objc func updateAPIData(){
//        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
//                                        tblView: self.tblView,
//                                        withLoader: true)
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
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnSubmit.addTapGestureRecognizer {
            
            for i in 0...self.arrData.count - 1 {
                let obj  = self.arrData[i]

                if obj["isSelected"].intValue == 1 {
                    
                    switch self.reportType {
                        
                    case .contentComment:
                        self.viewModel.apiCall(vc: self,
                                               content_master_id: self.content_master_id,
                                               content_type: self.content_type,
                                               content_comments_id: self.content_comments_id,
                                               reported: "Y",
                                               description: self.tvDesc.text!,
                                               report_type: obj["type"].stringValue,
                                               isReport: true,
                                               screen: .ReportComment){ [weak self] isDone in
                            
                            guard let self = self else {return}
                        }
                        break
                    case .question:
                        
                            self.askExpertviewModel.reportPostAPICall(vc: self,
                                                                      content_master_id: self.content_master_id,
                                                                      content_type: "",
                                                                      content_comments_id: self.content_comments_id,
                                                                      reported: "Y",
                                                                      description: self.tvDesc.text!,
                                                                      report_type: obj["type"].stringValue,
                                                                      forQuestion: true,
                                                                      isReport: true) { [weak self] isDone in
                                guard let _ = self else {return}
                                if isDone{}
                            }
                        break
                    case .answer:
                        self.askExpertviewModel.reportPostAPICall(vc: self,
                                                                  content_master_id: self.content_master_id,
                                                                  content_type: "",
                                                                  content_comments_id: self.content_comments_id,
                                                                  reported: "Y",
                                                                  description: self.tvDesc.text!,
                                                                  report_type: obj["type"].stringValue,
                                                                  forQuestion: false,
                                                                  isReport: true) { isDone in
                            if isDone{}
                        }
                    break
                    case .answerComment:
                        self.askExpertviewModel.reportPostAPICall(vc: self,
                                                                  content_master_id: self.content_master_id,
                                                                  content_type: "",
                                                                  content_comments_id: self.content_comments_id,
                                                                  reported: "Y",
                                                                  description: self.tvDesc.text!,
                                                                  report_type: obj["type"].stringValue,
                                                                  forQuestion: false,
                                                                  isReport: true) { isDone in
                            if isDone{}
                        }
                    }
                    
                    self.dismissPopUp(true, objAtIndex: obj)
                }
            }
        }
    }
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.addObserverOnHeightTbl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .ReportComment)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
//                                        tblView: self.tblView,
//                                        withLoader: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: ------------------ UITableView Methods ------------------
extension ReportCommentPopupVC {
    
    fileprivate func setData(){

        
    }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension ReportCommentPopupVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ReportCommentPopupCell = tableView.dequeueReusableCell(withClass: ReportCommentPopupCell.self, for: indexPath)

        let object = self.arrData[indexPath.row]
        
        cell.vwBg.backGroundColor(color: UIColor.white)
        if object["isSelected"].intValue == 1 {
            cell.vwBg.backGroundColor(color: UIColor.colorReport)
        }
        
        cell.lblTitle.text = object["name"].stringValue
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object  = self.arrData[indexPath.row]


        for i in 0...self.arrData.count - 1 {
            var obj  = self.arrData[i]

            obj["isSelected"].intValue = 0
            if obj["name"].stringValue == object["name"].stringValue {
                obj["isSelected"].intValue = 1
            }
            self.arrData[i] = obj
        }
        self.tblView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension ReportCommentPopupVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension ReportCommentPopupVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblViewHeight.constant = newvalue.height
        }
   
    }
    
    func addObserverOnHeightTbl() {
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblView else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension ReportCommentPopupVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
               // self.strErrorMessage = self.viewModel.strErrorMessage
            
                
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
