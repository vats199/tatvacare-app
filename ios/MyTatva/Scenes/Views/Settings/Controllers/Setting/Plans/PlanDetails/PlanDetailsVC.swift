//
//  HelpAndSupportVC.swift
//  MyTatva
//
//  Created by hyperlink on 26/10/21.
//

import UIKit
import SwiftUI
import WebKit

class PlanDetailsCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgLabel         : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    
    @IBOutlet weak var vwOffer          : UIView!
    @IBOutlet weak var lblOffer         : UILabel!
    
    @IBOutlet weak var lblOldPrice      : UILabel!
    @IBOutlet weak var lblPrice         : UILabel!
    @IBOutlet weak var lblPriceRatio    : UILabel!
    @IBOutlet weak var lblTotalPrice    : UILabel!
    
    @IBOutlet weak var btnSelection     : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 18)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc
            .font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        
        self.lblPrice
            .font(name: .semibold, size: 18)
            .textColor(color: UIColor.themeBlack)
        self.lblTotalPrice
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack)
        self.lblPriceRatio
            .font(name: .semibold, size: 13)
            .textColor(color: UIColor.themeBlack)
       
        self.lblOldPrice
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblOffer
            .font(name: .semibold, size: 7)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            //self.vwBg.roundCorners([.topLeft, .bottomLeft, .bottomRight], radius: 7)
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.borderColor(color: UIColor.ThemeBorder, borderWidth: 0)
//            self.vwBg.themeShadow()
        }
    }
}

class PlanDetailsVC: ClearNavigationFontBlackBaseVC { //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTop           : UILabel!
    @IBOutlet weak var imgTitle         : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var lblWhatIncluded  : UILabel!
    @IBOutlet weak var lblDesc2         : UILabel!
    
    @IBOutlet weak var webViewDesc          : WKWebView!
    @IBOutlet weak var heightWebViewDesc    : NSLayoutConstraint!
    
    @IBOutlet weak var lblDuration      : UILabel!
    
    @IBOutlet weak var tblView          : UITableView!
    @IBOutlet weak var tblHeight        : NSLayoutConstraint!
    
    @IBOutlet weak var btnBuy           : UIButton!
    
    @IBOutlet weak var scrollMain         : UIScrollView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = PlanListVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    var plan_id                     = ""
    var object                      = PlanDetailsModel()
    var isScrollToBuy               = false
    var completionHandler: ((_ obj : JSON?) -> Void)?
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        
        DispatchQueue.main.async {
            self.btnBuy.layoutIfNeeded()
            self.btnBuy.cornerRadius(cornerRadius: 5)
        }
        
        self.lblTitle
            .font(name: .semibold, size: 20)
            .textColor(color: UIColor.themePurple)
        
        self.lblDesc
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        self.lblWhatIncluded
            .font(name: .bold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc2
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.85))
        
        self.lblDuration
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.btnBuy
            .font(name: .medium, size: 18)
            .textColor(color: UIColor.white)
            .backGroundColor(color: UIColor.themePurple)
        
        self.configureUI()
        self.addObserverOnHeightTbl()
        self.manageActionMethods()
        
    }
    
    //Desc:- Set layout desing customize
    func configureUI(){
        self.scrollMain.delegate = self
        
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.tableHeaderView            = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: Double.leastNormalMagnitude))
        self.tblView.reloadData()
//        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
//        self.tblView.addSubview(self.refreshControl)
        
        self.webViewDesc.navigationDelegate = self
        self.webViewDesc.scrollView.isScrollEnabled = true
        self.webViewDesc.scrollView.delegate = self
        self.webViewDesc.scrollView.bounces = false
        func getZoomDisableScript() -> WKUserScript {
            let source: String = "var meta = document.createElement('meta');" +
                "meta.name = 'viewport';" +
                "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
                "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
            return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        }
        self.webViewDesc.configuration.userContentController.addUserScript(getZoomDisableScript())
    }
    
    //MARK: -------------------------- Action Methods --------------------------
    func manageActionMethods(){
        self.btnBuy.addTapGestureRecognizer {
            if self.object.planType == "Free" {
                if let completionHandler = self.completionHandler {
                    var obj         = JSON()
                    obj["isDone"]   = true
                    completionHandler(obj)
                }
                self.navigationController?.popViewController(animated: true)
            }
            else {
                if self.object.planPurchased == "Y" {
                    //New purchase
                    if self.object.deviceType == "A" {
                        Alert.shared.showAlert(message: AppMessages.CrossPlatformSubscribeCancel, completion: nil)
                    }
                    else {
                        //cancel purchase
                        let vc = CancelPlanPopupVC.instantiate(fromAppStoryboard: .setting)
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        vc.completionHandler = { obj in
                            
                            let selectedDuration = self.object.duration.filter { item in
                                return item.isSelected
                            }
                            if obj?.count > 0 {
                                if selectedDuration[0].iosPerMonthPrice > 0 {
                                    if self.object.planType == kIndividual {
                                        InAppManager.shared.cancelPurchase()
                                        //                                self.viewModel.cancelPlanAPI(patient_plan_rel_id: self.object.patientPlanRelId, withLoader: true) { isDone in
                                        //                                    if isDone {
                                        //                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                                        //                                            GlobalAPI.shared.getPatientDetailsAPI { (isDone) in
                                        //                                                if isDone {
                                        //                                                }
                                        //                                            }
                                        //                                        }
                                        //                                        self.navigationController?.popViewController(animated: true)
                                        //                                    }
                                        //                                }
                                    }
                                    else {
                                        InAppManager.shared.cancelPurchase()
                                    }
                                }
                                else {
                                    //For free plan, use api
                                    self.viewModel.cancelPlanAPI(patient_plan_rel_id: self.object.patientPlanRelId,
                                                                 withLoader: true) { [weak self] isDone in
                                        
                                        guard let self = self else {return}
                                        
                                        if isDone {
                                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                                                GlobalAPI.shared.getPatientDetailsAPI(withLoader: true) { (isDone) in
                                                    
                                                    self.navigationController?.popViewController(animated: true)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        UIApplication.topViewController()?.navigationController?.present(vc, animated: true, completion: nil)
                    }
                }
                else {
                    //----NEW PURCHASE
                    let selectedDuration = self.object.duration.filter { item in
                        return item.isSelected
                    }
                    
                    var params              = [String : Any]()
                    params[AnalyticsParameters.plan_id.rawValue]            = self.object.planMasterId
                    params[AnalyticsParameters.plan_type.rawValue]          = self.object.planType
                    params[AnalyticsParameters.plan_duration.rawValue]      = selectedDuration[0].durationTitle
                    params[AnalyticsParameters.plan_value.rawValue]         = selectedDuration[0].iosPrice
                    
                    var screenName: ScreenName = .MyTatvaPlanDetail
                    if self.object.planType == kIndividual {
                        screenName = .MyTatvaIndividualPlanDetail
                    }
                    
                    FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_SUBSCRIPTION_BUY,
                                             screen: screenName,
                                             parameter: params)
                   
                    func purchasePlan(){
                        if selectedDuration.count > 0 {
                            if selectedDuration[0].iosPerMonthPrice > 0 {
                                InAppManager.shared.purchaseProduct(productID: selectedDuration[0].iosProductId) { (jsonObj, stringObj) in

                                    if jsonObj != nil {
                                        InAppManager.shared.completeTransaction()
                                        
                                        var transaction_id = InAppManager.shared.getOriginalTransectionId(jsonResponse: jsonObj!)
                                        
                                        if self.object.planType == kSubscription {
                                            transaction_id = InAppManager.shared.getOriginalSubscriptionTransectionId(jsonResponse: jsonObj!)
                                        }
                                        
                                        self.viewModel.addPlanAPI(plan_master_id: self.object.planMasterId,
                                                                  transaction_id: transaction_id,
                                                                  receipt_data: stringObj ?? "", plan_type: self.object.planType,
                                                                  plan_package_duration_rel_id: selectedDuration[0].planPackageDurationRelId,
                                                                  purchase_amount: selectedDuration[0].iosPrice,
                                                                  withLoader: true) { [weak self] isDone in
                                            
                                            guard let self = self else {return}
                                            
                                            if isDone {
                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                                                    GlobalAPI.shared.getPatientDetailsAPI(withLoader: true) { [weak self] (isDone) in
                                                        
                                                        guard let self = self else {return}
                                                        
                                                        self.navigationController?.popViewController(animated: true)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            else {
                                //Free plan
                                self.viewModel.addPlanAPI(plan_master_id: self.object.planMasterId,
                                                          transaction_id: "Free",
                                                          receipt_data: "",
                                                          plan_type: self.object.planType,
                                                          plan_package_duration_rel_id: selectedDuration[0].planPackageDurationRelId,
                                                          purchase_amount: selectedDuration[0].iosPrice,
                                                          withLoader: true) { isDone in
                                    if isDone {
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                                            GlobalAPI.shared.getPatientDetailsAPI(withLoader: true) { [weak self] (isDone) in
                                                
                                                guard let self = self else {return}
                                                
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            
                        }
                    }
                    
                    if self.object.planType == kIndividual {
                        purchasePlan()
                    }
                    else {
                        var isAlreaadyHavePlan = false
                        if UserModel.shared.patientPlans != nil {
                            for plan in UserModel.shared.patientPlans {
                                if plan.planType == kSubscription {
                                    isAlreaadyHavePlan = true
                                    
                                }
                            }
                        }
                        
                        if isAlreaadyHavePlan {
                            Alert.shared.showAlert(title: Bundle.appName(),
                                                   message: AppMessages.MultipleSubscribePlan,
                                                   actionTitles: [AppMessages.yes, AppMessages.no],
                                                   actions: [ { yes in
                                
                                DispatchQueue.main.async {
                                    purchasePlan()
                                }
                            }, { no in
                                DispatchQueue.main.async {
                                }
                            }])
                        }
                        else {
                            purchasePlan()
                        }
                    }
                    
                }
            }
        }
    }
    
    //MARK: -------------------------- View life cycle Methods --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setData()
        //WebengageManager.shared.navigateScreenEvent(screen: .HelpSupportFaq)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .HelpSupportFaq, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //FIRAnalytics.manageTimeSpent(on: .HelpSupportFaq, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
//    @IBAction func onGoBack(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
}

//MARK: -------------------------- UITableView Methods --------------------------
extension PlanDetailsVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1//self.viewModel.getCount()
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.object.duration.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : PlanDetailsCell = tableView.dequeueReusableCell(withClass: PlanDetailsCell.self, for: indexPath)
        
        let obj = self.object.duration[indexPath.row]
        
        let themeColor          = UIColor.init(hexString: self.object.colourScheme)
        cell.lblTitle
            .font(name: .semibold, size: 18)
            .textColor(color: themeColor)
        
        cell.lblTitle.text          = ""
        cell.lblDesc.text           = ""
        DispatchQueue.main.async {
            cell.lblTitle.text      = obj.durationName
            cell.lblDesc.text       = obj.durationTitle
            UIView.performWithoutAnimation {
                self.tblView.performBatchUpdates {
                }
            }
        }
        
        
        cell.imgLabel.isHidden = true
//        if obj.offerTag.lowercased().contains("best".lowercased()){
//            cell.imgLabel.isHidden = false
//            cell.imgLabel.image = UIImage(named: "best_value")
//        }
//        else if obj.offerTag.lowercased().contains("most".lowercased()){
//            cell.imgLabel.isHidden = false
//            cell.imgLabel.image = UIImage(named: "most_popular")
//        }
        
        cell.vwOffer.isHidden = true
        if obj.discountPercentage > 0 {
            cell.vwOffer.isHidden = false
            cell.lblOffer.text              = """
                        \(obj.discountPercentage!)%
                        Off
                        """
        }
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .semibold, withSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        
        cell.lblOldPrice.text   = ""
        cell.lblPrice.text      = ""
        var oldPrice            = ""
        var actualPrice         = ""
        actualPrice = appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(obj.iosPerMonthPrice!).doubleValue.floorToPlaces(places: 0))
        
        
        if obj.offerPerMonthPrice > 0 {
            oldPrice = appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(obj.offerPerMonthPrice!).doubleValue.floorToPlaces(places: 0))
        }
        else {
        }
        
        cell.lblOldPrice.attributedText = oldPrice.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
        cell.lblTotalPrice.text =  AppMessages.Total + "- " +
        appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(obj.iosPrice!).doubleValue.floorToPlaces(places: 0))
        
        if obj.iosPerMonthPrice > 0 {
            cell.lblOldPrice.isHidden       = false
            cell.lblPriceRatio.isHidden     = false
            cell.lblTotalPrice.isHidden     = false
            
            cell.lblPrice.isHidden          = false
            cell.lblPrice.text              = actualPrice
        }
        else {
            //Free
            cell.lblOldPrice.isHidden       = false
            cell.lblPriceRatio.isHidden     = true
            cell.lblTotalPrice.isHidden     = true
            
            cell.lblPrice.isHidden          = false
            cell.lblPrice.text              = AppMessages.Free
        }
        
        cell.btnSelection.isSelected = obj.isSelected

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let obj = self.object.duration[indexPath.row]
            for object in self.object.duration {
                object.isSelected = false
                 if obj.orderNo == object.orderNo {
                    object.isSelected = true
                }
            }
            
            var params              = [String : Any]()
            params[AnalyticsParameters.plan_id.rawValue]            = self.object.planMasterId
            params[AnalyticsParameters.plan_type.rawValue]          = self.object.planType
            params[AnalyticsParameters.plan_duration.rawValue]      = obj.durationTitle
            
            var screenName: ScreenName = .MyTatvaPlanDetail
            if self.object.planType == kIndividual {
                screenName = .MyTatvaIndividualPlanDetail
            }
            
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_SUBSCRIPTION_DURATION,
                                     screen: screenName,
                                     parameter: params)
            
//            self.tblView.reloadData()
            self.tblView.reloadSections([0], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension PlanDetailsVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension PlanDetailsVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblHeight.constant = newvalue.height
            
            UIView.animate(withDuration: kAnimationSpeed) {
                self.view.layoutIfNeeded()
            }
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

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension PlanDetailsVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //self.webViewDesc.frame.size.height = 1
        //        self.webViewDesc.frame.size = webView.scrollView.contentSize
        //self.webViewDescHeight.constant = webView.scrollView.contentSize.height
        self.webViewDesc.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webViewDesc.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                    UIView.animate(withDuration: kAnimationSpeed, delay: 0, options: [.curveEaseIn]) {
                        self.heightWebViewDesc.constant = height as! CGFloat
                        self.view.layoutIfNeeded()
                        
                        if self.isScrollToBuy {
                            self.scrollMain.scrollToView(view: self.btnBuy, animated: true)
                        }
                    } completion: { isDone in
                    }
                })
            }
        })
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\(navigation.debugDescription)")
    }
    
}
//MARK: ------------------ UIScrollView Delegate Methods ------------------
extension PlanDetailsVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.webViewDesc.scrollView {
            if scrollView.contentOffset.y > 0 ||
                scrollView.contentOffset.y < 0 {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
            }
        }
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension PlanDetailsVC {
    
    fileprivate func setData(){
        DispatchQueue.main.async {
            let obj = self.object
            if obj.planName != nil {
                
                self.imgTitle.setCustomImage(with: self.object.imageUrl,placeholder: UIImage(named: "defaultUser"))
                self.lblTop.text        = obj.planName
                self.lblTitle.text      = obj.planName
                
                let themeColor          = UIColor.init(hexString: obj.colourScheme)
                self.lblTitle
                    .font(name: .semibold, size: 20)
                    .textColor(color: themeColor)
                
                self.lblDesc.text       = obj.subTitle
                self.lblDesc2.isHidden  = true
//                self.lblDesc2.attributedText = NSAttributedString(html: obj.descriptionField)
                
                self.webViewDesc.loadHTMLString(obj.descriptionField.replacingOccurrences(of: """
                                                    \"
                                                    """, with: """
                                                    "
                                                    """), baseURL: Bundle.main.bundleURL)
                
                self.btnBuy.backGroundColor(color: themeColor)
                
                if obj.planPurchased == "Y" {
                    self.btnBuy.setTitle(AppMessages.cancel, for: .normal)
                    if self.object.planType == kIndividual {
                        self.btnBuy.isHidden = true
                    }
                }
                else {
                    self.btnBuy.setTitle(AppMessages.buyNow, for: .normal)
                }
                
                if obj.planType == "Free" {
                    self.btnBuy.setTitle(AppMessages.upgrade, for: .normal)
                    self.lblDuration.isHidden   = true
                    self.tblView.isHidden       = true
                }
                
//                if self.object.duration.count > 0 {
//                    self.object.duration[0].isSelected = true
//                }
                
                if let maxDuration = self.object.duration.max(by: { $0.duration < $1.duration }) {
                    maxDuration.isSelected = true
                    print("The maximum duration is \(maxDuration)")
                }
                
                if self.object.planType == kIndividual {
                    WebengageManager.shared.navigateScreenEvent(screen: .MyTatvaIndividualPlanDetail)
                }
                else {
                    WebengageManager.shared.navigateScreenEvent(screen: .MyTatvaPlanDetail)
                }
                
                self.tblView.reloadData()
                self.tblView.layoutIfNeeded()
                self.tblView.performBatchUpdates {
                } completion: { isDone in
                }
            }
        }
    }
}
