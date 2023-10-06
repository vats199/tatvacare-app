//

import UIKit
import Alamofire

enum LabTestType: String{
    case all
    case package
    case test
}

class LabTestList2TestCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    
    var objGoal = GoalListModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .regular, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            //self.vwBg.cornerRadius(cornerRadius: 7)
            //self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
        }
    }
    
    func setData(){
    }
}

class LabTestList2PkgCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var lblTest          : UILabel!
    @IBOutlet weak var lblLab           : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .regular, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.lblTest
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblLab
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            //            self.vwBg.cornerRadius(cornerRadius: 7)
            //            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
        }
    }
}

class AllLabTestListVC: WhiteNavigationBaseVC {
    
    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var vwSearch             : UIView!
    @IBOutlet weak var txtSearch            : UITextField!
    
    @IBOutlet weak var vwShadow             : UIView!
    @IBOutlet weak var tblView              : UITableView!
    
    @IBOutlet weak var vwLocation           : UIView!
    @IBOutlet weak var lblLocation          : UILabel!
    @IBOutlet weak var lblLocationVal       : UILabel!
    @IBOutlet weak var btnChangeLocation    : UIButton!
    
    @IBOutlet weak var btnCart              : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                           = AllLabTestListVM()
    let refreshControl                      = UIRefreshControl()
    var strErrorMessage : String            = ""
    //    var strPincode                          = ""
    var labTestType: LabTestType            = .all
    var isSearchOn                          = false
    var timerSearch                         = Timer()
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    var locationStatus              : CLAuthorizationStatus?
    var isFromFirstTime = true
    //var arrGoal = [GoalListModel]()
    //    var arrGoal : [JSON] = [
    //        [
    //            "img" : "goals_calories",
    //            "name" : "Calories",
    //            "desc" : "2500  calories per day",
    //            "type": GoalType.Calories.rawValue,
    //            "isSelected": 0,
    //        ],
    //        [
    //            "img" : "goals_steps",
    //            "name" : "Steps",
    //            "desc" : "2500 steps per day",
    //            "type": GoalType.Steps.rawValue,
    //            "isSelected": 0,
    //        ],
    //        [
    //            "img" : "goals_exercise",
    //            "name" : "Exercise",
    //            "desc" : "30 minutes per day",
    //            "type": GoalType.Exercise.rawValue,
    //            "isSelected": 0,
    //        ]
    //    ]
    
    //var arrReading : [ReadingListModel] = []
    //        [
    //            [
    //                "img" : "reading_lung",
    //                "name" : "Lung Function",
    //                "desc" : "2500  calories per day",
    //                "type": ReadingType.Lung.rawValue,
    //                "isSelected": 0,
    //            ],
    //            [
    //                "img" : "reading_pulseOxy",
    //                "name" : "Pulse Oxygen",
    //                "desc" : "2500 steps per day",
    //                "type": ReadingType.PulseOxygen.rawValue,
    //                "isSelected": 0,
    //            ],
    //            [
    //                "img" : "reading_bp",
    //                "name" : "Blood Pressure",
    //                "desc" : "30 minutes per day",
    //                "type": ReadingType.BloodPressure.rawValue,
    //                "isSelected": 0,
    //            ]
    //        ]
    
    //MARK: -------------------- Memory management --------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: -------------------- Custome Methods --------------------
    //Desc:- Centre method to call in View
    func setUpView(){
        self.configureUI()
        self.manageActionMethods()
        self.applyStyle()
        
        switch self.labTestType {
            
        case .all:
            self.txtSearch.becomeFirstResponder()
            break
        case .package:
            break
        case .test:
            break
        }
    }
    
    private func applyStyle() {
        
        self.txtSearch
            .font(name: .medium, size: 15).textColor(color: .themeBlack.withAlphaComponent(1))
        self.txtSearch.delegate = self
        
        self.lblLocation
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblLocationVal
            .font(name: .medium, size: 12)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.btnChangeLocation
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
    }
    
    private func addGeoLocationAddress(search: String? = nil) {
        if LocationManager.shared.checkStatus() == .authorizedAlways || LocationManager.shared.checkStatus() == .authorizedWhenInUse {
            let lat     = LocationManager.shared.getUserLocation().coordinate.latitude
            let long    = LocationManager.shared.getUserLocation().coordinate.longitude
            
            GoogleNavigationAdddress.getAddressFromLatLong(lat: lat, lng: long) { (response) in
                let response = JSON(response)
                
                if response[StringConstant.PinCode].stringValue != "" {
                    
                    kGlobalPincode              = response[StringConstant.PinCode].stringValue
                    self.lblLocationVal.text    = kGlobalPincode
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.viewModel.apiCallFromStart(tblView: self.tblView,
                                                    refreshControl: self.refreshControl,
                                                    search: search ?? self.txtSearch.text!,
                                                    type: self.labTestType,
                                                    pincode: kGlobalPincode,
                                                    withLoader: false)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                _ = LocationManager.shared.isLocationServiceEnabled(showAlert: true)
                self.viewModel.apiCallFromStart(tblView: self.tblView,
                                                refreshControl: self.refreshControl,
                                                search: search ?? self.txtSearch.text!,
                                                type: self.labTestType,
                                                pincode: kGlobalPincode,
                                                withLoader: false)
            }
        }
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        
        self.setup(tblView: self.tblView)
        DispatchQueue.main.async {
            self.vwShadow.layoutIfNeeded()
            self.vwShadow.cornerRadius(cornerRadius: 5)
            self.vwShadow.themeShadow()
            
            self.vwSearch.layoutIfNeeded()
            self.vwSearch.cornerRadius(cornerRadius: 10)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
        }
        
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
        
        LocationManager.shared.delegate = self
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
    
    @objc func APICallToGetPackages() {
        
        self.refreshControl.beginRefreshing()
        self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
        
        self.timerSearch.invalidate()
        self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { timer in
            
            self.strErrorMessage = ""
            
            LocationManager.shared.getLocation(isAskForPermission: true)
            
            if LocationManager.shared.checkStatus() == .authorizedAlways || LocationManager.shared.checkStatus() == .authorizedWhenInUse {
                let lat     = LocationManager.shared.getUserLocation().coordinate.latitude
                let long    = LocationManager.shared.getUserLocation().coordinate.longitude
                
                WebengageManager.shared.setUserLocation()
                
                GoogleNavigationAdddress.getAddressFromLatLong(lat: lat, lng: long) { (response) in
                    let response = JSON(response)
                    
                    if response[StringConstant.PinCode].stringValue != "" {
                        
                        kGlobalPincode              = response[StringConstant.PinCode].stringValue
                        self.lblLocationVal.text    = kGlobalPincode
                    }
                    
                    
                    self.viewModel.apiCallFromStart(tblView: self.tblView,
                                                    refreshControl: self.refreshControl,
                                                    search: self.txtSearch.text!,
                                                    type: .package,
                                                    pincode: kGlobalPincode,
                                                    withLoader: false)
                    
                }
            }else {
                _ = LocationManager.shared.isLocationServiceEnabled(showAlert: true)
                self.viewModel.apiCallFromStart(tblView: self.tblView,
                                                refreshControl: self.refreshControl,
                                                search: self.txtSearch.text!,
                                                type: .package,
                                                pincode: kGlobalPincode,
                                                withLoader: false)
            }
            
        }
    }
    
    @objc func updateAPIData(sender: UIButton, search: String? = nil){
        self.refreshControl.beginRefreshing()
        self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
        
        self.timerSearch.invalidate()
        self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            
            self.strErrorMessage = ""
            if kGlobalPincode.trim() != "" {
                self.lblLocationVal.text    = kGlobalPincode
                
                self.viewModel.apiCallFromStart(tblView: self.tblView,
                                                refreshControl: self.refreshControl,
                                                search: search ?? self.txtSearch.text!,
                                                type: self.labTestType,
                                                pincode: kGlobalPincode,
                                                withLoader: false)
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.viewModel.apiCallFromStart(tblView: self.tblView,
                                                    refreshControl: self.refreshControl,
                                                    search: search ?? self.txtSearch.text!,
                                                    type: self.labTestType,
                                                    pincode: kGlobalPincode,
                                                    withLoader: false)
                }
                
                //   ----------------- Comment ----------
                if LocationManager.shared.checkStatus() == .authorizedAlways || LocationManager.shared.checkStatus() == .authorizedWhenInUse {
                    let lat     = LocationManager.shared.getUserLocation().coordinate.latitude
                    let long    = LocationManager.shared.getUserLocation().coordinate.longitude
                    
                    GoogleNavigationAdddress.getAddressFromLatLong(lat: lat, lng: long) { (response) in
                        let response = JSON(response)
                        
                        if response[StringConstant.PinCode].stringValue != "" {
                            
                            kGlobalPincode              = response[StringConstant.PinCode].stringValue
                            self.lblLocationVal.text    = kGlobalPincode
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            self.viewModel.apiCallFromStart(tblView: self.tblView,
                                                            refreshControl: self.refreshControl,
                                                            search: search ?? self.txtSearch.text!,
                                                            type: self.labTestType,
                                                            pincode: kGlobalPincode,
                                                            withLoader: false)
                        }
                    }
                } else {
                    
                    if self.isFromFirstTime {
                        self.isFromFirstTime = false
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.10) {
                            let vc = LocationPermissionPopUpVC.instantiate(fromAppStoryboard: .BCP_temp)
                            vc.selectManuallyCompletion = { [weak self] _ in
                                guard let self = self else { return }
                                let vc = SelectLocationPopUpVC.instantiate(fromAppStoryboard: .BCP_temp)
                                vc.completionHandler = { obj in
                                    if obj?.count > 0 {
                                        kGlobalPincode              = obj!["code"].stringValue
                                        self.lblLocationVal.text    = kGlobalPincode
                                        self.updateAPIData(sender: self.btnChangeLocation, search: self.txtSearch.text!)
                                    }
                                }
                                UIApplication.topViewController()?.present(vc, animated: true)
                            }
                            vc.selectGrantCompletion = { [weak self] _ in
                                guard let self = self else { return }
                                
                                if (UIApplication.topViewController()?.isKind(of: LocationPermissionPopUpVC.self) ?? false) {
                                    UIApplication.topViewController()?.dismiss(animated: true, completion: { [weak self] in
                                        guard let self = self else { return }
                                        self.addGeoLocationAddress(search: search)
                                    })
                                    return
                                }
                                self.addGeoLocationAddress(search: search)
                                
                            }
                            
                            let navi = UINavigationController(rootViewController: vc)
                            navi.modalPresentationStyle = .overFullScreen
                            navi.modalTransitionStyle = .crossDissolve
                            UIApplication.topViewController()?.present(navi, animated: true)
                        }
                    }
                    
                }
                
            // --------- Comment -----------
               /* LocationManager.shared.getLocation(isAskForPermission: true)
                self.locationStatus = LocationManager.shared.checkStatus()
                if LocationManager.shared.checkStatus() == .authorizedAlways || LocationManager.shared.checkStatus() == .authorizedWhenInUse {
                    let lat     = LocationManager.shared.getUserLocation().coordinate.latitude
                    let long    = LocationManager.shared.getUserLocation().coordinate.longitude
                    
                    GoogleNavigationAdddress.getAddressFromLatLong(lat: lat, lng: long) { (response) in
                        let response = JSON(response)
                        
                        if response[StringConstant.PinCode].stringValue != "" {
                            
                            kGlobalPincode              = response[StringConstant.PinCode].stringValue
                            self.lblLocationVal.text    = kGlobalPincode
                        }
                        
                        
                        self.viewModel.apiCallFromStart(tblView: self.tblView,
                                                        refreshControl: self.refreshControl,
                                                        search: search ?? self.txtSearch.text!,
                                                        type: self.labTestType,
                                                        pincode: kGlobalPincode,
                                                        withLoader: false)
                        
                    }
                }else {
                    _ = LocationManager.shared.isLocationServiceEnabled(showAlert: true)
                    self.viewModel.apiCallFromStart(tblView: self.tblView,
                                                    refreshControl: self.refreshControl,
                                                    search: search ?? self.txtSearch.text!,
                                                    type: self.labTestType,
                                                    pincode: kGlobalPincode,
                                                    withLoader: false)
                } */
                
                /*if LocationManager.shared.isLocationServiceEnabled(showAlert: false) {
                 LocationManager.shared.getLocation()
                 let lat     = LocationManager.shared.getUserLocation().coordinate.latitude
                 let long    = LocationManager.shared.getUserLocation().coordinate.longitude
                 
                 GoogleNavigationAdddress.getAddressFromLatLong(lat: lat, lng: long) { (response) in
                 let response = JSON(response)
                 
                 if response[StringConstant.PinCode].stringValue != "" {
                 
                 kGlobalPincode              = response[StringConstant.PinCode].stringValue
                 self.lblLocationVal.text    = kGlobalPincode
                 }
                 
                 
                 self.viewModel.apiCallFromStart(tblView: self.tblView,
                 refreshControl: self.refreshControl,
                 search: search ?? self.txtSearch.text!,
                 type: self.labTestType,
                 pincode: kGlobalPincode,
                 withLoader: false)
                 
                 }
                 }
                 else {
                 self.viewModel.apiCallFromStart(tblView: self.tblView,
                 refreshControl: self.refreshControl,
                 search: search ?? self.txtSearch.text!,
                 type: self.labTestType,
                 pincode: kGlobalPincode,
                 withLoader: false)
                 }*/
            }
        }
    }
    
    //MARK: -------------------- Action Methods --------------------
    func manageActionMethods(){
        self.vwLocation.addTapGestureRecognizer {
            /*let vc = ChooseLocationPinVC.instantiate(fromAppStoryboard: .carePlan)
            //            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.completionHandler = { obj in
                if obj?.count > 0 {
                    kGlobalPincode              = obj!["code"].stringValue
                    self.lblLocationVal.text    = kGlobalPincode
                    self.updateAPIData(sender: self.btnChangeLocation, search: self.txtSearch.text!)
                }
            }
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
             */
            let vc = SelectLocationPopUpVC.instantiate(fromAppStoryboard: .BCP_temp)
            vc.completionHandler = { obj in
                if obj?.count > 0 {
                    kGlobalPincode              = obj!["code"].stringValue
                    self.lblLocationVal.text    = kGlobalPincode
                    self.updateAPIData(sender: self.btnChangeLocation, search: self.txtSearch.text!)
                }
            }
            UIApplication.topViewController()?.present(vc, animated: true)
        }
        
    }
    
    //MARK: -------------------- View life cycle --------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
        self.updateAPIData(sender: self.btnChangeLocation, search: self.txtSearch.text!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        WebengageManager.shared.navigateScreenEvent(screen: .LabtestList)
        
        GFunction.shared.updateCartCount(btn: self.btnCart)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .SetUpGoalsReadings, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAnalytics.manageTimeSpent(on: .SetUpGoalsReadings, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
}

//MARK: -------------------------- TableView Methods --------------------------
extension AllLabTestListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblView:
            return self.viewModel.getCount()
            
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.tblView:
            
            let cell : LabTestList2TestCell = tableView.dequeueReusableCell(withClass: LabTestList2TestCell.self, for: indexPath)
            let object                      = self.viewModel.getObject(index: indexPath.row)
            cell.lblTitle.text              = object.name
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tblView:
            let object = self.viewModel.getObject(index: indexPath.item)
            let vc = LabTestDetailsVC.instantiate(fromAppStoryboard: .carePlan)
            vc.lab_test_id  = object.labTestId
            vc.hidesBottomBarWhenPushed = true
            vc.completionHandler = { obj in
                if obj?.name != nil {
                    self.viewModel.arrList[indexPath.row] = obj!
                    self.tblView.reloadData()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.isSearchOn {
            self.viewModel.managePagenation(tblView: self.tblView,
                                            refreshControl: self.refreshControl,
                                            search: self.txtSearch.text!,
                                            type: self.labTestType,
                                            pincode: kGlobalPincode,
                                            index: indexPath.row)
        }
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension AllLabTestListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension AllLabTestListVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        
        switch textField {
        case self.txtSearch:
            self.isSearchOn = true
            self.updateAPIData(sender: self.btnChangeLocation, search: newText)
            return true
        default:
            return true
        }
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
}

//MARK: -------------------- setupViewModel Observer --------------------
extension AllLabTestListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                DispatchQueue.main.async {
                    self.strErrorMessage        = self.viewModel.strErrorMessage
                    self.tblView.reloadData()
                }
                
                break
                
            case .failure(let error):
                self.strErrorMessage        = error.errorDescription ?? ""
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

extension AllLabTestListVC: LocationManagerDelegate {
    
    func didChangeAuthorizationStatus(status: CLAuthorizationStatus) {
        if self.locationStatus != status && kGlobalPincode == "" {
            self.locationStatus = status
            self.APICallToGetPackages()
        }
    }
    
}
