
import UIKit

class SelectAddressCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var btnSelect    : UIButton!
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblName      : UILabel!
    @IBOutlet weak var lblPhone     : UILabel!
    @IBOutlet weak var lblAddress   : UILabel!
    
    @IBOutlet weak var btnDelete    : UIButton!
    @IBOutlet weak var btnEdit      : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblName
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblAddress
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblPhone
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.btnDelete
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.btnEdit
            .font(name: .medium, size: 10)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg
                .cornerRadius(cornerRadius: 7)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
//            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
            self.btnEdit
                .cornerRadius(cornerRadius: 4)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
        }
    }
}

class SelectAddressVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var txtSearch        : UITextField!
    @IBOutlet weak var btnAddAddress    : UIButton!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var tblView          : UITableView!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = SelectAddressVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    var cartListModel               = CartListModel()
    var labPatientListModel         = LabPatientListModel()
    
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
        
        self.btnAddAddress
            .font(name: .regular, size: 18)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        
        self.txtSearch.delegate = self
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
        self.setup(tblView: self.tblView)
        
        DispatchQueue.main.async {
            self.btnAddAddress.layoutIfNeeded()
            self.btnAddAddress.cornerRadius(cornerRadius: 10)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
        }
    }
    
    func setup(tblView: UITableView) {
        
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        
        self.btnAddAddress.addTapGestureRecognizer {
            let vc = AddAddressVC.instantiate(fromAppStoryboard: .carePlan)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnSubmit.addTapGestureRecognizer {
            
            if let obj = self.viewModel.getSelectedObject() {
                var params1 = [String: Any]()
                params1[AnalyticsParameters.address_id.rawValue]  = obj.patientAddressRelId
                FIRAnalytics.FIRLogEvent(eventName: .LABTEST_ADDRESS_SELECTED,
                                         screen: .SelectAddress,
                                         parameter: params1)
                
//                let vc = SelectLabTestTimeSlotVC.instantiate(fromAppStoryboard: .carePlan)
//                vc.cartListModel            = self.cartListModel
//                vc.labPatientListModel      = self.labPatientListModel
//                vc.labAddressListModel      = obj
//                self.navigationController?.pushViewController(vc, animated: true)
                
                let vc = SelectTestTimeSlotVC.instantiate(fromAppStoryboard: .bca)
                vc.cartListModel = self.cartListModel
                vc.labAddressListModel = obj
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                Alert.shared.showSnackBar(AppError.validation(type: .selectAddress).errorDescription ?? "")
            }
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .SelectAddress)
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
extension SelectAddressVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SelectAddressCell = tableView.dequeueReusableCell(withClass: SelectAddressCell.self, for: indexPath)

        let object = self.viewModel.getObject(index: indexPath.row)
        
        cell.btnSelect.isHidden     = false
        cell.lblTitle.text          = object.addressType
        cell.lblName.text           = object.name
        cell.lblPhone.text          = object.contactNo
        cell.lblAddress.text        = """
\(object.address ?? "")
\(object.street ?? "")
\(object.pincode!)
"""
        
        cell.btnSelect.isSelected = false
        if object.isSelected {
            cell.btnSelect.isSelected = true
        }
        
        cell.btnDelete.isHidden = object.isBCPAddrees
        
        cell.btnDelete.addTapGestureRecognizer {
            Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    self.viewModel.delete_addressAPI(address_id: object.patientAddressRelId) { [weak self] isDone in
                        guard let self = self else {return}
                        if isDone {
                            self.viewModel.arrFilteredList.remove(at: indexPath.row)
                            self.tblView.reloadData()
                            
                            var params1 = [String: Any]()
                            params1[AnalyticsParameters.address_id.rawValue]  = object.patientAddressRelId
                            FIRAnalytics.FIRLogEvent(eventName: .LABTEST_ADDRESS_DELETED,
                                                     screen: .SelectAddress,
                                                     parameter: params1)
                        }
                    }
                }
            }
        }
        
        cell.btnEdit.addTapGestureRecognizer {
            let vc = AddAddressVC.instantiate(fromAppStoryboard: .carePlan)
            vc.object = object
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
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
extension SelectAddressVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension SelectAddressVC: UITextFieldDelegate {
    
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
extension SelectAddressVC {
    
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
