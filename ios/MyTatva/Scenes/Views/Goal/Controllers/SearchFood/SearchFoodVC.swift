
import UIKit

class SearchFoodCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblDesc      : UILabel!
    
    @IBOutlet weak var btnSelect    : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
        }
    }
}

class SearchFoodVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var txtSearch    : UITextField!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var tblView      : UITableView!
    
    @IBOutlet weak var btnSubmit    : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = SearchFoodVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    var timerSearch                 = Timer()
    private var isSearchOn : Bool   = false
    
    var completionHandler: ((_ obj : FoodSearchListModel?) -> Void)?
    
    var arrDaysOffline : [JSON] = []
    var arrLanguage : [JSON] = [
        [
            "name" : "Abacavir.",
            "isSelected": 1,
        ],[
            "name" : "Abacavir / dolutegravir / lamivudine (Triumeq®) ",
            "isSelected": 0,
        ],
        [
            "name" : "Add Aba as a Drug",
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
    }
    
    @objc func updateAPIData(withLoader: Bool = false, search: String = ""){
        self.strErrorMessage = ""
        self.viewModel.apiCallFromStart_search_food(refreshControl: nil,
                                                    tblView: self.tblView,
                                                    withLoader: withLoader,
                                                    food_name: search)
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
    
        self.txtSearch.delegate = self
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
        
        self.txtSearch.becomeFirstResponder()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        WebengageManager.shared.navigateScreenEvent(screen: .SearchFood)
//        self.updateAPIData(withLoader: true, search: self.txtSearch.text!)
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

}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension SearchFoodVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SearchFoodCell = tableView.dequeueReusableCell(withClass: SearchFoodCell.self, for: indexPath)

        let object = self.viewModel.getObject(index: indexPath.row)
        cell.lblTitle.text  = object.foodName
        let energyKcal      = object.energyKcal.components(separatedBy: " ").first!
        let unit            = object.calUnitName
        
        cell.lblDesc.text   = energyKcal + " " + (unit ?? "")
        if let gm = object.bASICUNITMEASURE, gm.trim() != "" {
            cell.lblDesc.text   = "\(gm) gm - " + energyKcal + " " + (unit ?? "")
        }
        
        cell.btnSelect.isUserInteractionEnabled = false
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.arrList.count > 0 {
            let object = self.viewModel.getObject(index: indexPath.row)
            if let completionHandler = self.completionHandler {
                completionHandler(object)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.isSearchOn {
            self.viewModel.managePagenationSeachList(tblView: self.tblView,
                                                     withLoader: false,
                                                     food_name: self.txtSearch.text!,
                                                     index: indexPath.row)
        }
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension SearchFoodVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------- UITextField Delegate --------------------
extension SearchFoodVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        self.isSearchOn = true
        
//        let searchCall = GFunction.shared.debounce(interval: 1000, queue: .main) {
//            self.updateAPIData(withLoader: false, search: newText)
//            print("debounce")
//        }
        
        self.timerSearch.invalidate()
        self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.updateAPIData(withLoader: false, search: newText)
        }
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//            self.updateAPIData(withLoader: false, search: newText)
//            searchCall()
//        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.txtSearch:
            self.isSearchOn = false
            self.tblView.reloadData()
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtSearch:
            self.txtSearch.resignFirstResponder()
            self.isSearchOn = false
            self.tblView.reloadData()
            
            break
        default:
            break
        }
        
        return true
    }
     
}

//MARK: -------------------- setupViewModel Observer --------------------
extension SearchFoodVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResultSearch.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                
                DispatchQueue.main.async {
                    self.strErrorMessage        = self.viewModel.strErrorMessageNoSearch
                    self.tblView.reloadData()
                }
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
