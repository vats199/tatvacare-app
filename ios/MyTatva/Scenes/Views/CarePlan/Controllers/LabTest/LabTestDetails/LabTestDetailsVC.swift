//
//

//

import UIKit


class LabTestDetailsVC: ClearNavigationFontBlackBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    
    //Top
    @IBOutlet weak var scrollMain               : UIScrollView!
    @IBOutlet weak var vwLocation               : UIView!
    @IBOutlet weak var lblLocation              : UILabel!
    @IBOutlet weak var lblLocationVal           : UILabel!
    @IBOutlet weak var btnChangeLocation        : UIButton!
    
    @IBOutlet weak var imgTitle                 : UIImageView!
    @IBOutlet weak var lblTitle                 : UILabel!
    
    @IBOutlet weak var lblOldPrice              : UILabel!
    @IBOutlet weak var lblNewPrice              : UILabel!
    @IBOutlet weak var lblOffer                 : UILabel!
    
    @IBOutlet weak var imgSelectedFrom          : UIImageView!
    @IBOutlet weak var lblSelectedFrom          : UILabel!
    @IBOutlet weak var btnRemove                : UIButton!
    @IBOutlet weak var btnAddToCart             : UIButton!
    
    @IBOutlet weak var vwTest                   : UIView!
    @IBOutlet weak var lblTest                  : UILabel!
    @IBOutlet weak var lblShowAll               : UILabel!
    @IBOutlet weak var btnExpandTest            : UIButton!
    
    @IBOutlet weak var tblView                  : UITableView!
    @IBOutlet weak var tblViewHeight            : NSLayoutConstraint!
    
    @IBOutlet weak var stackDesc                : UIStackView!
    @IBOutlet weak var btnDesc                  : UIButton!
    @IBOutlet weak var btnTest                  : UIButton!
    
    @IBOutlet weak var vwLineDesc               : UIView!
    @IBOutlet weak var vwLineTest               : UIView!
    
    @IBOutlet weak var lblDesc                  : UILabel!
    
    @IBOutlet weak var stackTest                : UIStackView!
    @IBOutlet weak var lblSampleType            : UILabel!
    @IBOutlet weak var lblSampleTypeVal         : UILabel!
    @IBOutlet weak var lblFastReq               : UILabel!
    @IBOutlet weak var lblFastReqVal            : UILabel!
    
    @IBOutlet weak var btnCart                  : UIButton!
    @IBOutlet weak var stackCart                : UIStackView!
    @IBOutlet weak var vwCart                   : UIView!
    @IBOutlet weak var btnViewCart              : UIButton!
    @IBOutlet weak var btnViewMoreTest          : UIButton!
    @IBOutlet weak var lblCartVal               : UILabel!
    
    
    //MARK:- Class Variable
    var viewModel               = LabTestDetailsVM()
    var object                  = BookTestListModel()
    let labTestListVM           = LabTestListVM()
    var lab_test_id             = ""
    //    var strPincode              = ""
    var completionHandler: ((_ obj : BookTestListModel?) -> Void)?
    var locationStatus              : CLAuthorizationStatus?
    
    var isForFirstTime = true
    
    //MARK: ------------------------- Memory Management Method -------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    fileprivate func setUpView() {
        
        self.configureUI()
        self.manageActionMethods()
        self.addObserverOnHeightTbl()
        self.btnExpandTest.isSelected = false
        self.updateIncludedTest()
        self.updateDescTab(sender: self.btnDesc)
        self.setupViewModelObserver()
    }
    
    fileprivate func configureUI(){
        
        self.lblLocation
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        self.lblLocationVal
            .font(name: .medium, size: 12)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.btnChangeLocation
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblTitle
            .font(name: .semibold, size: 18)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblNewPrice
            .font(name: .regular, size: 17)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblOldPrice
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        self.lblOldPrice.attributedText = self.lblOldPrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
        
        self.lblOffer
            .font(name: .medium, size: 12)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblSelectedFrom
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.btnRemove
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.btnAddToCart
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.white.withAlphaComponent(1))
        
        self.btnDesc
            .font(name: .semibold, size: 18)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.btnTest
            .font(name: .semibold, size: 18)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblTest
            .font(name: .regular, size: 18)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblDesc
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.65))
        
        self.lblSampleType
            .font(name: .regular, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblSampleTypeVal
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblFastReq
            .font(name: .regular, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblFastReqVal
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblCartVal
            .font(name: .regular, size: 18)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.btnViewCart
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.white.withAlphaComponent(1))
        
        self.btnViewMoreTest
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.vwLocation.layoutIfNeeded()
            self.vwLocation.backGroundColor(color: UIColor.themeLightGray)
            
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.cornerRadius(cornerRadius: 5)
            
            self.imgSelectedFrom.layoutIfNeeded()
            self.imgSelectedFrom.cornerRadius(cornerRadius: 5)
            
            self.btnAddToCart.layoutIfNeeded()
            self.btnAddToCart.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnViewCart.layoutIfNeeded()
            self.btnViewCart.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnViewMoreTest.layoutIfNeeded()
            self.btnViewMoreTest.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.white)
                .borderColor(color: .themePurple, borderWidth: 1)
            
            self.vwLineDesc.layoutIfNeeded()
            self.vwLineTest.layoutIfNeeded()
            
            self.vwLineDesc.cornerRadius(cornerRadius: self.vwLineDesc.frame.size.height / 2)
            self.vwLineTest.cornerRadius(cornerRadius: self.vwLineTest.frame.size.height / 2)
        }
        
        self.setup(tblView: self.tblView)
        LocationManager.shared.delegate = self
    }
    
    fileprivate func setup(tblView: UITableView){
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.sectionHeaderHeight        = UITableView.automaticDimension
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.sectionFooterHeight        = 0
        tblView.reloadData()
    }
    
    private func getAddressFromGeo(withLoader: Bool = true) {
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
                    self.viewModel.test_detailAPI(lab_test_id: self.lab_test_id,
                                                  pincode: kGlobalPincode,
                                                  withLoader: withLoader)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                _ = LocationManager.shared.isLocationServiceEnabled(showAlert: true)
                self.viewModel.test_detailAPI(lab_test_id: self.lab_test_id,
                                              pincode: kGlobalPincode,
                                              withLoader: withLoader)
            }
        }
    }
    
    //MARK: ------------------------- Action Method -------------------------
    fileprivate func manageActionMethods(){
        
        self.vwLocation.addTapGestureRecognizer {
           /* let vc = ChooseLocationPinVC.instantiate(fromAppStoryboard: .carePlan)
            //            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.completionHandler = { obj in
                if obj?.count > 0 {
                    kGlobalPincode              = obj!["code"].stringValue
                    self.lblLocationVal.text    = kGlobalPincode
                    
                    self.scrollMain.isHidden = true
                    self.updateAPIData(withLoader: true)
                }
            }
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            */
            let vc = SelectLocationPopUpVC.instantiate(fromAppStoryboard: .BCP_temp)
            vc.completionHandler = { obj in
                if obj?.count > 0 {
                    kGlobalPincode              = obj!["code"].stringValue
                    self.lblLocationVal.text    = kGlobalPincode
                    self.updateAPIData(withLoader: true)
                }
            }
            UIApplication.topViewController()?.present(vc, animated: true)
        }
        
        self.btnAddToCart.addTapGestureRecognizer {
            if self.object.inCart == "N" {
                self.labTestListVM.updateCartAPI(isAdd: true,
                                                 code: self.object.code,
                                                 labTestId: self.object.labTestId,
                                                 screen: .LabtestDetails) { [weak self] isDone in
                    guard let self = self else {return}
                    if isDone {
                        /*kApplyCouponName = ""
                        kCouponCodeAmount = 0
                        kDiscountMasterId = ""
                        kDiscountType = ""*/
                        kIsCartModified = true
                        self.object.inCart = "Y"
                        //                        self.tblView.reloadData()
                        self.object.cart.totalTest += 1
                        self.updateAPIData(withLoader: true)
                    }
                }
            }
        }
        
        self.btnRemove.addTapGestureRecognizer {
            Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    self.labTestListVM.updateCartAPI(isAdd: false,
                                                     code: self.object.code,
                                                     labTestId: self.object.labTestId,
                                                     screen: .LabtestDetails) { [weak self] isDone in
                        guard let self = self else {return}
                        if isDone {
                            self.object.inCart = "N"
                            self.updateAPIData(withLoader: true)
                        }
                    }
                }
            }
        }
        
        self.btnViewCart.addTapGestureRecognizer {
            //            let vc = LabTestCartVC.instantiate(fromAppStoryboard: .carePlan)
            let vc = BCPCartDetailVC.instantiate(fromAppStoryboard: .BCP_temp)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnCart.addTapGestureRecognizer {
            if let cart = self.object.cart, cart.totalTest != nil {
                if cart.totalTest > 0 {
                    //                    let vc = LabTestCartVC.instantiate(fromAppStoryboard: .carePlan)
                    let vc = BCPCartDetailVC.instantiate(fromAppStoryboard: .BCP_temp)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    Alert.shared.showSnackBar(AppMessages.YourCartIsEmpty, isError: true, isBCP: true)
                }
            }
        }
        
        self.btnViewMoreTest.addTapGestureRecognizer {
            let vc = LabTestListVC.instantiate(fromAppStoryboard: .carePlan)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnExpandTest.addTapGestureRecognizer {
            self.btnExpandTest.isSelected = !self.btnExpandTest.isSelected
            self.updateIncludedTest()
        }
        
        self.btnDesc.addTapGestureRecognizer {
            self.updateDescTab(sender: self.btnDesc)
        }
        
        self.btnTest.addTapGestureRecognizer {
            self.updateDescTab(sender: self.btnTest)
        }
    }
    
    @IBAction func btnBackTapped(sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            if let completion = self.completionHandler {
                if self.object.name != nil {
                    completion(self.object)
                }
            }
        }
    }
    
    fileprivate func updateIncludedTest(){
        if self.btnExpandTest.isSelected {
            self.tblView.isHidden = false
        }
        else {
            self.tblView.isHidden = true
        }
        UIView.animate(withDuration: kAnimationSpeed) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func updateDescTab(sender: UIButton){
        switch sender {
        case self.btnDesc:
            self.btnDesc
                .font(name: .semibold, size: 18)
                .textColor(color: UIColor.themePurple.withAlphaComponent(1))
            self.btnTest
                .font(name: .regular, size: 16)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
            
            self.vwLineDesc.isHidden    = false
            self.vwLineTest.isHidden    = true
            
            self.lblDesc.isHidden       = false
            self.stackTest.isHidden     = true
            break
        case self.btnTest:
            self.btnTest
                .font(name: .semibold, size: 18)
                .textColor(color: UIColor.themePurple.withAlphaComponent(1))
            self.btnDesc
                .font(name: .regular, size: 16)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
            
            self.vwLineTest.isHidden    = false
            self.vwLineDesc.isHidden    = true
            
            self.lblDesc.isHidden       = true
            self.stackTest.isHidden     = false
            
        default:
            break
        }
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        
        WebengageManager.shared.navigateScreenEvent(screen: .LabtestDetails)
        self.scrollMain.isHidden = true
        self.updateAPIData(withLoader: true)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

//MARK: -------------------------- UITableView Methods --------------------------
extension LabTestDetailsVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.object.childs != nil {
            return self.object.childs.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0//self.viewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : IncludedTestsHeaderCell = tableView.dequeueReusableCell(withClass: IncludedTestsHeaderCell.self)
        let object = self.object.childs[section]
        cell.lblTitle.text = object.name
        //cell.vwBg.backGroundColor(color: UIColor.red)
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : IncludedTestsCell = tableView.dequeueReusableCell(withClass: IncludedTestsCell.self, for: indexPath)
        
        //        let object = self.viewModel.getObject(index: indexPath.row)
        //
        //        if object.doseType == "1"{
        //            cell.lblTitle.text = object.doseType //+ " " + AppMessages.timePerDay
        //        }
        //        else {
        //            cell.lblTitle.text = object.doseType //+ " " + AppMessages.timesPerDay
        //        }
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
        
        //self.viewModel.manageSelection(index: indexPath.row)
        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
        //                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension LabTestDetailsVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = ""//self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension LabTestDetailsVC {
    
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

//MARK: -------------------------- Set data --------------------------
extension LabTestDetailsVC {
    
    fileprivate func setData(){
        self.scrollMain.isHidden = false
        
        self.imgTitle.setCustomImage(with: self.object.imageLocation)
        self.lblTitle.text              = self.object.name
        self.lblDesc.text               = self.object.descriptionField
        
        self.lblNewPrice.text           = CurrencySymbol.INR.rawValue + self.object.discountPrice
        if JSON(object.discountPercent as Any).intValue > 0 {
            self.lblOldPrice.text       = CurrencySymbol.INR.rawValue + self.object.price
            self.lblOffer.text          = "\(self.object.discountPercent!)% OFF"
        }
        else {
            self.lblOldPrice.text       = ""
            self.lblOffer.text          = ""
        }
        
        if self.object.lab != nil {
            self.lblSelectedFrom.text = self.object.lab.name //AppMessages.SelectedFrom + " " + self.object.lab.name
            self.imgSelectedFrom.setCustomImage(with: self.object.lab.image)
        }
        
        self.lblCartVal.text            = CurrencySymbol.INR.rawValue + self.object.cart.totalPrice
        
        self.lblSampleTypeVal.text      = ": \(self.object.specimenType!)"
        self.lblFastReqVal.text         = ": \(self.object.fasting!)"
        
        if self.object.childs.count > 0 {
            self.vwTest.isHidden        = false
            self.lblTest.text           = "Includes " + "\(self.object.childs.count)" + " tests"
            
            self.tblView.reloadData()
            self.tblView.isScrollEnabled = true
        }
        else{
            self.vwTest.isHidden        = true
        }
        
        if self.object.inCart == "N" {
            self.btnAddToCart.isHidden  = false
            self.btnRemove.isHidden     = true
        }
        else {
            self.btnAddToCart.isHidden  = true
            self.btnRemove.isHidden     = true
        }
        
        if self.object.type == "OFFER" {
            //This is package
            //            self.stackDesc.isHidden = true
            //            self.lblDesc.isHidden   = true
            
            self.stackDesc.isHidden = false
            self.lblDesc.isHidden   = false
        }
        else {
            self.stackDesc.isHidden = false
            self.lblDesc.isHidden   = false
        }
        
        self.stackCart.isHidden = true
        if self.object.cart.totalTest > 0 {
            self.stackCart.isHidden = true
            //            GFunction.shared.setBadge(view: self.vwCart, value: self.object.cart.totalTest)
        }
        GFunction.shared.setBadge(view: self.btnCart, value: self.object.cart.totalTest)
    }
    
    private func APICallLabTestDetails() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
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
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.viewModel.test_detailAPI(lab_test_id: self.lab_test_id,
                                                      pincode: kGlobalPincode,
                                                      withLoader: true)
                    }
                }
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    _ = LocationManager.shared.isLocationServiceEnabled(showAlert: true)
                    self.viewModel.test_detailAPI(lab_test_id: self.lab_test_id,
                                                  pincode: kGlobalPincode,
                                                  withLoader: true)
                }
            }
            
        }
        
    }
    
    @objc func updateAPIData(withLoader: Bool = false){
        
        //        self.strErrorMessage        = ""
        self.lblLocationVal.text    = kGlobalPincode
        if kGlobalPincode.trim() != "" {
            self.lblLocationVal.text    = kGlobalPincode
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                
                self.viewModel.test_detailAPI(lab_test_id: self.lab_test_id,
                                              pincode: kGlobalPincode,
                                              withLoader: withLoader)
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.viewModel.test_detailAPI(lab_test_id: self.lab_test_id,
                                              pincode: kGlobalPincode,
                                              withLoader: withLoader)
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
                        self.viewModel.test_detailAPI(lab_test_id: self.lab_test_id,
                                                      pincode: kGlobalPincode,
                                                      withLoader: withLoader)
                    }
                }
            } else {
                
                if self.isForFirstTime {
                    self.isForFirstTime = false
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.10) {
                        let vc = LocationPermissionPopUpVC.instantiate(fromAppStoryboard: .BCP_temp)
                        vc.selectManuallyCompletion = { [weak self] _ in
                            guard let self = self else { return }
                            let vc = SelectLocationPopUpVC.instantiate(fromAppStoryboard: .BCP_temp)
                            vc.completionHandler = { obj in
                                if obj?.count > 0 {
                                    kGlobalPincode              = obj!["code"].stringValue
                                    self.lblLocationVal.text    = kGlobalPincode
                                    self.updateAPIData(withLoader: true)
                                }
                            }
                            UIApplication.topViewController()?.present(vc, animated: true)
                        }
                        vc.selectGrantCompletion = { [weak self] _ in
                            guard let self = self else { return }
                            
                            if (UIApplication.topViewController()?.isKind(of: LocationPermissionPopUpVC.self) ?? false) {
                                UIApplication.topViewController()?.dismiss(animated: true, completion: { [weak self] in
                                    guard let self = self else { return }
                                    self.getAddressFromGeo(withLoader: withLoader)
                                })
                                return
                            }
                            self.getAddressFromGeo(withLoader: withLoader)
                        }
                        
                        let navi = UINavigationController(rootViewController: vc)
                        navi.modalPresentationStyle = .overFullScreen
                        navi.modalTransitionStyle = .crossDissolve
                        UIApplication.topViewController()?.present(navi, animated: true)
                    }
                }
                
            }
            
            
         //   ----------------- Comment ----------
//            LocationManager.shared.getLocation(isAskForPermission: true)
//            self.locationStatus = LocationManager.shared.checkStatus()
//            if LocationManager.shared.checkStatus() == .authorizedAlways || LocationManager.shared.checkStatus() == .authorizedWhenInUse {
//
//                let lat     = LocationManager.shared.getUserLocation().coordinate.latitude
//                let long    = LocationManager.shared.getUserLocation().coordinate.longitude
//
//                GoogleNavigationAdddress.getAddressFromLatLong(lat: lat, lng: long) { (response) in
//                    let response = JSON(response)
//
//                    if response[StringConstant.PinCode].stringValue != "" {
//
//                        kGlobalPincode              = response[StringConstant.PinCode].stringValue
//                        self.lblLocationVal.text    = kGlobalPincode
//                    }
//
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//                        self.viewModel.test_detailAPI(lab_test_id: self.lab_test_id,
//                                                      pincode: kGlobalPincode,
//                                                      withLoader: withLoader)
//                    }
//                }
//            }
//            else {
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//                    _ = LocationManager.shared.isLocationServiceEnabled(showAlert: true)
//                    self.viewModel.test_detailAPI(lab_test_id: self.lab_test_id,
//                                                  pincode: kGlobalPincode,
//                                                  withLoader: withLoader)
//                }
//            }
        }
    }
    
}

//MARK: -------------------- setupViewModel Observer --------------------
extension LabTestDetailsVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.object = self.viewModel.object
                self.setData()
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                self.navigationController?.popViewController(animated: true)
                
                
            case .none: break
            }
        })
    }
}

extension LabTestDetailsVC: LocationManagerDelegate {
    
    func didChangeAuthorizationStatus(status: CLAuthorizationStatus) {
        if self.locationStatus != status && kGlobalPincode == "" {
            self.locationStatus = status
            self.APICallLabTestDetails()
        }
    }
    
}
