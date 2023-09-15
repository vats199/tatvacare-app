
import UIKit

class SelectPatientDetailsCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var imgView      : UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblEmail     : UILabel!
    @IBOutlet weak var lblAge       : UILabel!
    @IBOutlet weak var lblGender    : UILabel!
    @IBOutlet weak var btnSelect    : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblEmail
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblAge
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblGender
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
//            self.vwBg.cornerRadius(cornerRadius: 7)
//            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
            self.imgView.layoutIfNeeded()
            self.imgView.cornerRadius(cornerRadius: 5)
        }
    }
}

class SelectPatientDetailsVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var txtSearch        : UITextField!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var tblView          : UITableView!
    
    @IBOutlet weak var btnAddNew        : UIButton!
    @IBOutlet weak var btnSubmit        : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = SelectPatientDetailsVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    var cartListModel               = CartListModel()
    
    var completionHandler: ((_ obj : StateListModel?) -> Void)?
    
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
    
    @objc func updateAPIData(){
        self.strErrorMessage = ""
        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                        tblView: self.tblView,
                                        withLoader: true)
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        self.lblTitle
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.btnAddNew
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.btnSubmit
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.white.withAlphaComponent(1))
        
        
        self.txtSearch.delegate = self
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
        
        DispatchQueue.main.async {
            self.btnAddNew.layoutIfNeeded()
            self.btnAddNew.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
                .backGroundColor(color: UIColor.white)
            
            self.btnSubmit.layoutIfNeeded()
            self.btnSubmit.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
                .backGroundColor(color: UIColor.themePurple)
        }
           
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        self.btnSubmit.addTapGestureRecognizer {
            if let obj = self.viewModel.getSelectedObject() {
                var params1 = [String: Any]()
                params1[AnalyticsParameters.member_id.rawValue]  = obj.patientMemberRelId
                FIRAnalytics.FIRLogEvent(eventName: .LABTEST_PATIENT_SELECTED,
                                         screen: .SelectPatient,
                                         parameter: params1)
                
                let vc = SelectAddressVC.instantiate(fromAppStoryboard: .carePlan)
                vc.cartListModel = self.cartListModel
                vc.labPatientListModel = obj
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                Alert.shared.showSnackBar(AppError.validation(type: .selectPatient).errorDescription ?? "")
            }
            
        }
        self.btnAddNew.addTapGestureRecognizer {
            let vc = AddPatientDetailsVC.instantiate(fromAppStoryboard: .carePlan)
            self.navigationController?.pushViewController(vc, animated: true)
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .SelectPatient)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.viewModel.apiCallFromStart(tblView: self.tblView,
                                   withLoader: true)
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
extension SelectPatientDetailsVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SelectPatientDetailsCell = tableView.dequeueReusableCell(withClass: SelectPatientDetailsCell.self, for: indexPath)

        let object = self.viewModel.getObject(index: indexPath.row)
        
        cell.imgView.isHidden   = false
        cell.btnSelect.isHidden = false
        cell.lblTitle.text      = object.name
        cell.lblEmail.text      = object.email
        cell.lblGender.text     = AppMessages.Gender + " : " + object.gender
        cell.lblAge.text        = AppMessages.Age + " : " + "\(object.age!)"
        
        cell.btnSelect.isSelected = false
        if object.isSelected {
            cell.btnSelect.isSelected = true
        }
        
//        cell.btnSelect.isSelected = false
//        if object["isSelected"].intValue == 1 {
//            cell.btnSelect.isSelected = true
//        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.manageSelection(index: indexPath.row)
        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension SelectPatientDetailsVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension SelectPatientDetailsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            //self.apiCallFromStart(search: newText, withLoader: false)
            self.viewModel.manageSearch(keyword: newText,
                                        tblView: self.tblView)
        }
        return true
    }
     
}

//MARK: -------------------- setupViewModel Observer --------------------
extension SelectPatientDetailsVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
