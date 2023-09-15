//
//  RecordsVC.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import UIKit

//enum AppointmentStatus: String {
//    case Scheduled
//    case Cancelled
//    case Complete
//}

class TestPackageListCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var vwTest               : UIView!
    @IBOutlet weak var lblTest              : UILabel!
    @IBOutlet weak var lblShowAll           : UILabel!
    
    @IBOutlet weak var lblOldPrice          : UILabel!
    @IBOutlet weak var lblNewPrice          : UILabel!
    @IBOutlet weak var lblOffer             : UILabel!
    
    @IBOutlet weak var btnAddToCart         : UIButton!
    @IBOutlet weak var btnRemove            : UIButton!
    
    var object = AppointmentListModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.lblTitle
            .font(name: .semibold, size: 18)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblDesc
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblTest
            .font(name: .medium, size: 12)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.lblShowAll
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.btnAddToCart
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.white.withAlphaComponent(1))
        
        self.btnRemove
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblOffer
            .font(name: .medium, size: 12)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.lblOldPrice
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblNewPrice
            .font(name: .regular, size: 18)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .semibold, withSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        self.lblOldPrice.attributedText = self.lblOldPrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            //            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            //            self.vwBg.borderColor(color: UIColor.themeBlack.withAlphaComponent(0.09), borderWidth: 0.5)
            
            self.btnAddToCart
                .backGroundColor(color: UIColor.themePurple)
                .cornerRadius(cornerRadius: 5)
            
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.cornerRadius(cornerRadius: 5)
            
            self.vwTest.layoutIfNeeded()
            self.vwTest.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themeLightPurple.withAlphaComponent(0.1))
        }
    }
    
    func setCellData(object: BookTestListModel){
        self.imgTitle.setCustomImage(with: object.imageLocation)
        self.lblTitle.text              = object.name
        self.lblTest.text               = "Includes " + "\(object.childs.count)" + " tests"
        self.lblNewPrice.text           = CurrencySymbol.INR.rawValue + object.discountPrice
        
        if JSON(object.discountPercent as Any).intValue > 0 {
            self.lblOldPrice.text           = CurrencySymbol.INR.rawValue + object.price
            self.lblOffer.text              = "\(object.discountPercent!)% OFF"
        }
        else {
            self.lblOldPrice.text           = ""
            self.lblOffer.text              = ""
        }
        
        self.btnAddToCart.isHidden  = true
        self.btnRemove.isHidden     = true
        //        if let arr = CartListModel.shared.testsList {
        //            if arr.count > 0 {
        //                if arr.contains(where: { obj in
        //                    return obj.labTestId == object.labTestId
        //                }) {
        //                    self.btnAddToCart.isHidden  = true
        //                    self.btnRemove.isHidden     = false
        //                }
        //                else {
        //                    self.btnAddToCart.isHidden  = false
        //                    self.btnRemove.isHidden     = true
        //                }
        //            }
        //            else {
        //                self.btnAddToCart.isHidden  = false
        //                self.btnRemove.isHidden     = true
        //            }
        //        }
        if object.inCart == "N" {
            self.btnAddToCart.isHidden  = false
            self.btnRemove.isHidden     = true
        }
        else {
            self.btnAddToCart.isHidden  = true
            self.btnRemove.isHidden     = false
        }
    }
}

class TestPackageListVC: ClearNavigationFontBlackBaseVC {
    
    //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var vwSearch             : UIView!
    @IBOutlet weak var txtSearch            : UITextField!
    
    @IBOutlet weak var vwLocation           : UIView!
    @IBOutlet weak var lblLocation          : UILabel!
    @IBOutlet weak var lblLocationVal       : UILabel!
    @IBOutlet weak var btnChangeLocation    : UIButton!
    
    @IBOutlet weak var btnCart              : UIButton!
    
    @IBOutlet weak var tblView              : UITableView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = AllLabTestListVM()
    let labTestListVM               = LabTestListVM()
    let refreshControl              = UIRefreshControl()
    var isShowDoc                   = false
    //    var strPincode                  = ""
    var strErrorMessage : String    = ""
    var timerSearch                 = Timer()
    var locationStatus              : CLAuthorizationStatus?    //----------------------------------------------------------------------------
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
    
    //Desc:- Set layout desing customize
    func configureUI(){
        
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
        
        DispatchQueue.main.async {
            
            self.vwSearch.layoutIfNeeded()
            self.vwSearch.cornerRadius(cornerRadius: 10)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
            
            self.vwLocation.layoutIfNeeded()
            self.vwLocation.backGroundColor(color: UIColor.themeLightGray)
        }
        
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
        
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
        LocationManager.shared.delegate = self
    }
    
    @objc func APICallToGetPackages() {
        
        self.refreshControl.beginRefreshing()
        self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
        
        self.timerSearch.invalidate()
        self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { timer in
            
            self.strErrorMessage = ""
            
            LocationManager.shared.getLocation(isAskForPermission: true)
            
            if LocationManager.shared.checkStatus() == .authorizedAlways || LocationManager.shared.checkStatus() == .authorizedWhenInUse {
                
                WebengageManager.shared.setUserLocation()
                
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
        self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { timer in
            
            self.strErrorMessage = ""
            if kGlobalPincode.trim() != "" {
                self.lblLocationVal.text    = kGlobalPincode
                
                self.viewModel.apiCallFromStart(tblView: self.tblView,
                                                refreshControl: self.refreshControl,
                                                search: search ?? self.txtSearch.text!,
                                                type: .package,
                                                pincode: kGlobalPincode,
                                                withLoader: false)
            }
            
            else {
                
                LocationManager.shared.getLocation(isAskForPermission: true)
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
                                                        type: .package,
                                                        pincode: kGlobalPincode,
                                                        withLoader: false)
                        
                    }
                }else {
                    _ = LocationManager.shared.isLocationServiceEnabled(showAlert: true)
                    self.viewModel.apiCallFromStart(tblView: self.tblView,
                                                    refreshControl: self.refreshControl,
                                                    search: search ?? self.txtSearch.text!,
                                                    type: .package,
                                                    pincode: kGlobalPincode,
                                                    withLoader: false)
                }
            }
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        
        self.vwLocation.addTapGestureRecognizer {
            let vc = ChooseLocationPinVC.instantiate(fromAppStoryboard: .carePlan)
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
        }
        
        //        self.btnBookAppointment.addTapGestureRecognizer {
        //            let vc = BookAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .HealthPackageList)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.updateAPIData(sender: self.btnChangeLocation, search: self.txtSearch.text!)
        GFunction.shared.updateCartCount(btn: self.btnCart)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = self.parent?.parent as? TabbarVC {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        //FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension TestPackageListVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblView:
            return self.viewModel.getCount()
            
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TestPackageListCell = tableView.dequeueReusableCell(withClass: TestPackageListCell.self, for: indexPath)
        let object                      = self.viewModel.getObject(index: indexPath.row)
        cell.setCellData(object: object)
        cell.vwTest.addTapGestureRecognizer {
            let vc = IncludedTestsVC.instantiate(fromAppStoryboard: .carePlan)
            vc.object = object
            vc.modalPresentationStyle = .overFullScreen
            //vc.modalTransitionStyle = .crossDissolve
            UIApplication.topViewController()?.navigationController?.present(vc, animated: true, completion: nil)
        }
        
        cell.btnAddToCart.addTapGestureRecognizer {
            if object.inCart == "N" {
                self.labTestListVM.updateCartAPI(isAdd: true,
                                                 code: object.code,
                                                 labTestId: object.labTestId,
                                                 screen: .HealthPackageList) { [weak self] isDone in
                    guard let self = self else {return}
                    if isDone {
                        object.inCart = "Y"
                        self.tblView.reloadData()
                        GFunction.shared.updateCartCount(btn: self.btnCart)
                    }
                }
            }
        }
        
        cell.btnRemove.addTapGestureRecognizer {
            Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    self.labTestListVM.updateCartAPI(isAdd: false,
                                                     code: object.code,
                                                     labTestId: object.labTestId,
                                                     screen: .HealthPackageList) { isDone in
                        if isDone {
                            object.inCart = "N"
                            self.tblView.reloadData()
                            GFunction.shared.updateCartCount(btn: self.btnCart)
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.managePagenation(tblView: self.tblView,
                                        refreshControl: self.refreshControl,
                                        search: self.txtSearch.text!,
                                        type: .package,
                                        pincode: kGlobalPincode,
                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension TestPackageListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension TestPackageListVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        self.updateAPIData(sender: self.btnChangeLocation, search: newText)
        
        return true
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension TestPackageListVC {
    
    fileprivate func setData(){
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension TestPackageListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.tblView.reloadData()
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

extension TestPackageListVC: LocationManagerDelegate {
    
    func didChangeAuthorizationStatus(status: CLAuthorizationStatus) {
        if self.locationStatus != status && kGlobalPincode == "" {
            self.locationStatus = status
            self.APICallToGetPackages()
        }
    }
    
}
