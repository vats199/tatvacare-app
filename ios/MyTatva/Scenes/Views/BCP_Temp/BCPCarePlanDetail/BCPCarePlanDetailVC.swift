//
//  BCPCarePlanDetailVC.swift
//  MyTatva
//
//  Created by Hlink on 05/06/23.
//

import UIKit

class BCPCarePlanDetailCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var vwMain: UIView!
    
    @IBOutlet weak var vwRecommended: UIView!
    @IBOutlet weak var lblRecommended: UILabel!
    
    @IBOutlet weak var lblbName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblActualPrice: UILabel!
    
    
    //MARK: - Class Variables
    
    //MARK: - deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(self) ‼️‼️‼️")
    }
    
    //MARK: - LifeCycleMethods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    //MARK: - Custom Methods
    private func applyStyle() {
        self.backGroundColor(color: .clear)
        self.contentView.backGroundColor(color: .clear)
        self.vwMain.cornerRadius(cornerRadius: 12.0).shadow(color: .themeGray, shadowOffset: .zero, shadowOpacity: 0.1)
        self.lblRecommended.font(name: .bold, size: 12.0).textColor(color: .white).text = "Recommended"
        self.vwRecommended.backGroundColor(color: .themeGreen).cornerRadius(cornerRadius: 8.0)
        self.lblbName.font(name: .regular, size: 14.0).textColor(color: .themeBlack).numberOfLines = 0
        self.lblPrice.font(name: .semibold, size: 20.0).textColor(color: .themeBlack)
    }
    
    func configure(_ data: DurationDetailModel) {
        self.vwRecommended.isHidden = !JSON(data.isRecommended as Any).boolValue
        self.vwMain.borderColor(color: data.isSelected ? .themePurple : .ThemeBorder, borderWidth: 1.0)
        self.vwMain.backGroundColor(color: data.isSelected ? .themePurple.withAlphaComponent(0.08) : .white)
        self.lblbName.text = data.durationTitle + " - " + data.durationName
        
        Settings().isHidden(setting: .is_bcp_with_in_app) { [weak self] isInApp in
            guard let self = self else { return }
            guard isInApp else {
                self.lblPrice.text = data.androidPrice == 0 ? AppMessages.Free : appCurrencySymbol.rawValue + JSON(data.androidPrice as Any).stringValue
                return
            }
            self.lblPrice.text = data.iosPrice == 0 ? AppMessages.Free : appCurrencySymbol.rawValue + JSON(data.iosPrice as Any).stringValue
        }
        
        self.lblActualPrice.isHidden = data.offerPrice == 0
        self.lblActualPrice.text = appCurrencySymbol.rawValue + JSON(data.offerPrice as Any).stringValue
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .light, withSize: 12),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        self.lblActualPrice.attributedText = self.lblActualPrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
    }
    
    
}

class FeatureTitleCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var consTitleBottom: NSLayoutConstraint!
    
    //MARK: - Class Variables
    
    //MARK: - deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(self) ‼️‼️‼️")
    }
    
    //MARK: - LifeCycleMethods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    //MARK: - Custom Methods
    private func applyStyle() {
        self.backGroundColor(color: .clear)
        self.contentView.backGroundColor(color: .clear)
        self.lblTitle.font(name: .regular, size: 12.0).textColor(color: .ThemeGray61)
    }
    
    func configure(data: String) {
        self.lblTitle.text = data
        self.lblTitle.numberOfLines = 0
    }
    
    
}

class BCPFeatureCell: UICollectionViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnInfo: UIButton!
    
    //MARK: - Class Variables
    
    //MARK: - deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(self) ‼️‼️‼️")
    }
    
    //MARK: - LifeCycleMethods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    //MARK: - Custom Methods
    private func applyStyle() {
        self.backGroundColor(color: .clear)
        self.contentView.backGroundColor(color: .clear)
        self.lblTitle.font(name: .semibold, size: 12.0).textColor(color: .ThemeGray61)
        self.btnInfo.setImage(UIImage(named: "bcp_info")?.withRenderingMode(.alwaysTemplate), for: UIControl.State())
        self.btnInfo.tintColor = .ThemeGray61
        self.btnInfo.isHidden = true
    }
    
    func configure() {
        
    }
    
    
}

class ColCheckedCell: UICollectionViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var imgChecked: UIImageView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var consLabelCenter: NSLayoutConstraint!
    @IBOutlet weak var consImgCenter: NSLayoutConstraint!
    
    //MARK: - Class Variables
    
    //MARK: - deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(self) ‼️‼️‼️")
    }
    
    //MARK: - LifeCycleMethods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    //MARK: - Custom Methods
    private func applyStyle() {
        self.backGroundColor(color: .clear)
        self.contentView.backGroundColor(color: .clear)
        self.lblCount.font(name: .regular, size: 12.0).textColor(color: .ThemeGray61)
    }
    
    func configure() {
        
    }
    
}

class FeatureCheckedCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var colFeatures: UICollectionView!
    @IBOutlet weak var consFeaturesHeight: NSLayoutConstraint!
    @IBOutlet weak var consTop: NSLayoutConstraint!
    
    //MARK: - Class Variables
    
    var cellFrame: CGSize = .zero
    var isHeader = false
    var arrFeatureData: [String] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.colFeatures.reloadData()
            }
        }
    }
    
    //MARK: - deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(self) ‼️‼️‼️")
    }
    
    //MARK: - LifeCycleMethods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    //MARK: - Custom Methods
    private func applyStyle() {
        self.backGroundColor(color: .clear)
        self.contentView.backGroundColor(color: .clear)
        self.colFeatures.delegate = self
        self.colFeatures.dataSource = self
//        self.colFeatures.backGroundColor(color: .red)
    }
    
    func configure(arrFeature:[String], frame: CGSize, consTop: CGFloat = 0, isHeader:Bool = false) {
        self.consTop.constant = consTop
        self.cellFrame = frame
        self.consFeaturesHeight.constant = frame.height
        self.arrFeatureData = arrFeature
        self.isHeader = isHeader
    }
    
}

//------------------------------------------------------
//MARK: - UICollectionViewDelegate,DataSource
extension FeatureCheckedCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrFeatureData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ColCheckedCell.self, for: indexPath)
        let isChecked = JSON(self.arrFeatureData[indexPath.row] as Any).boolValue
//        debugPrint(JSON(self.arrFeatureData[indexPath.row] as Any).int)
        
        if let _ = Int(self.arrFeatureData[indexPath.row]) {
            cell.lblCount.text = self.arrFeatureData[indexPath.row]
            cell.lblCount.isHidden = false
            cell.imgChecked.isHidden = true
        }else {
            cell.lblCount.isHidden = true
            cell.imgChecked.isHidden = false
            cell.imgChecked.image = UIImage(named: isChecked ? "feature_selected" : "feature_unselected")
        }
        
        cell.consLabelCenter.constant = self.isHeader ? 4 : 0
        
        cell.lblCount.font(name: .regular, size: 12.0).textColor(color: self.isHeader ? .themeBlack : .ThemeGray61)
        
        DispatchQueue.main.async {
            cell.contentView.layoutSubviews()
            cell.contentView.layoutIfNeeded()
        }
        
//        cell.contentView.backGroundColor(color: .blue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellFrame
    }
    
}


class BCPCarePlanDetailVC: LightPurpleNavigationBase {
    
    //MARK: Outlet
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwPatientType: UIView!
    @IBOutlet weak var lblPatientType: UILabel!
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var constWebViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblPlans: UITableView!
    @IBOutlet weak var constPlanHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwBuyOrRent: UIView!
    @IBOutlet weak var lblBuyOrRentTitle: UILabel!
    
    @IBOutlet var arrPurchaseLabel: [UILabel]!
    @IBOutlet var arrPurchaseIV: [UIImageView]!
    
    @IBOutlet weak var btnRent: UIButton!
    @IBOutlet weak var btnBuy: UIButton!
    
    @IBOutlet weak var vwFeature: UIView!
    @IBOutlet weak var lblFeature: UILabel!
    @IBOutlet weak var colFeature: UICollectionView!
    @IBOutlet weak var consFeatureWidth: NSLayoutConstraint!
    
    @IBOutlet weak var tblFeatureTitles: UITableView!
    @IBOutlet weak var consFeatureHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblFeatures: UITableView!
    
    @IBOutlet weak var vwBuyNow: UIView!
    @IBOutlet weak var btnBuyNow: ThemePurple16Corner!
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel: BCPCarePlanDetailVM!
    
    var patientPlanRelId = ""
    var selectedBCPIndex: Int = 0 {
        didSet {
            self.vwFeature.isHidden = true            
            self.arrPurchaseIV.forEach({ $0.image = UIImage(named: $0.tag == self.selectedBCPIndex ? "radio-plan-checked" : "radio-plan-unchecked") })
            self.viewModel.getPlanDetails(durationType: self.selectedBCPIndex == 0 ? kRent : kBuy,patientPlanRelId: self.patientPlanRelId)
            //            UIView.animate(withDuration: 0.5) { [weak self] in
            //                guard let self = self else { return }
            //                self.vwFeature.isHidden = true
            //                self.tblPlans.isHidden = true
            //            }
        }
    }
    
    var plan_id                     = ""
    var completionHandler: ((_ obj : JSON?) -> Void)?
    var isFromPurchasedPlan = false
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(self) ‼️‼️‼️")
        self.tblPlans.removeObserver(self, forKeyPath: "contentSize")
        self.tblFeatureTitles.removeObserver(self, forKeyPath: "contentSize")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.applyStyle()
        self.setData()
    }
    
    private func applyStyle() {
        if self.isFromPurchasedPlan {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }else {
            self.navigationController?.isNavigationBarHidden = false
        }
        
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = true
        
        self.webView.navigationDelegate = self
        self.webView.scrollView.isScrollEnabled = true
        self.webView.scrollView.bounces = false
        
        self.webView.getZoomDisableScript()
        self.webView.isOpaque = false
        self.webView.backgroundColor = .BCPBG
        
        //        self.navigationController?.setThemeNavigation()
        
        self.lblTitle.text = nil
        self.vwPatientType.backGroundColor(color: UIColor(hex: 0x6E78FF)).cornerRadius(cornerRadius: 8.0)
        self.lblPatientType.font(name: .bold, size: 12.0).textColor(color: .white).text = nil
        
        self.lblBuyOrRentTitle.font(name: .semibold, size: 16.0).textColor(color: .themeBlack)
        
        self.btnBuy.tag = 1
        self.btnRent.tag = 0
        
        self.arrPurchaseLabel.forEach({ $0.textColor(color: .themeBlack).font(name: .medium, size: 14.0).text = $0.tag == 0 ? kRent : kBuy })
        self.selectedBCPIndex = 0
        
        self.manageActions()
        
        self.tblPlans.delegate = self
        self.tblPlans.dataSource = self
        self.tblPlans.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblPlans.isScrollEnabled = false
        
        self.lblFeature.font(name: .semibold, size: 12.0).textColor(color: .ThemeGray61).text = "Included in Program"
        
        self.colFeature.delegate = self
        self.colFeature.dataSource = self
        self.colFeature.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.tblFeatureTitles.delegate = self
        self.tblFeatureTitles.dataSource = self
        self.tblFeatureTitles.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblFeatureTitles.isScrollEnabled = false
        
        self.tblFeatures.delegate = self
        self.tblFeatures.dataSource = self
        
        if #available(iOS 15.0, *) {
            self.tblFeatureTitles.sectionHeaderTopPadding = 0.0
            self.tblFeatures.sectionHeaderTopPadding = 0.0
        }
        
    }
    
    private func setData() {
        let medicalCondition = UserModel.shared.medicalConditionName.map({$0.medicalConditionName ?? ""}).joined(separator: "/ ")
        self.lblPatientType.text = medicalCondition
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.btnBuyNow.font(name: .bold, size: 16.0).cornerRadius(cornerRadius: 16.0).setTitle(self.patientPlanRelId.isEmpty ? "Buy Now" : "Cancel", for: UIControl.State())
        }
        
        //        self.btnBuyNow.font(name: .bold, size: 15.0)
        self.vwBuyNow.themeShadowBCP()
        self.webView.loadHTMLString(self.viewModel.cpDetail.planDetails.descriptionField.replacingOccurrences(of: """
                                        \"
                                        """, with: """
                                        "
                                        """), baseURL: Bundle.main.bundleURL)
        guard let planDetails = self.viewModel.cpDetail.planDetails else { return }
        self.lblTitle.text = planDetails.planName
        self.vwBuyOrRent.isHidden = !planDetails.enableRentBuy //planDetails.planType == kSubscription
    }
    
    private func firebaseEventForRentOrBuy() {
        var params              = [String : Any]()
        params[AnalyticsParameters.plan_id.rawValue]            = self.viewModel.cpDetail.planDetails.planMasterId
        params[AnalyticsParameters.plan_type.rawValue]          = self.viewModel.cpDetail.planDetails.planType
                                
        FIRAnalytics.FIRLogEvent(eventName: .TAP_RENT_BUY,
                                 screen: .BcpDetails,
                                 parameter: params)
    }
    
    private func manageActions() {
        self.btnBuy.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self, self.selectedBCPIndex != self.btnBuy.tag else { return }
            self.selectedBCPIndex = self.btnBuy.tag
            self.firebaseEventForRentOrBuy()
        }
        
        self.btnRent.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self, self.selectedBCPIndex != self.btnRent.tag else { return }
            self.selectedBCPIndex = self.btnRent.tag
            self.firebaseEventForRentOrBuy()
        }
        
        self.btnBuyNow.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
//            kApplyCouponName = ""
//            kDiscountType = ""
//            kDiscountMasterId = ""
//            kCouponCodeAmount = 0
            let isIndividual = self.viewModel.cpDetail.planDetails.planType == kIndividual
            guard let selectedDuration = self.viewModel.getSelectedPlan() else {
//                Alert.shared.showSnackBar(AppMessages.kSelectDuration)
                Alert.shared.showSnackBar(AppMessages.kSelectDuration, isError: true, isBCP: true)
                return }
            
            var params              = [String : Any]()
            params[AnalyticsParameters.plan_id.rawValue]            = selectedDuration.planMasterId
            params[AnalyticsParameters.plan_type.rawValue]          = self.viewModel.cpDetail.planDetails.planType
            params[AnalyticsParameters.plan_duration.rawValue]      = selectedDuration.durationTitle
            params[AnalyticsParameters.plan_value.rawValue]         = selectedDuration.androidPrice
                        
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_SUBSCRIPTION_BUY,
                                     screen: .BcpDetails,
                                     parameter: params)
            
            guard self.patientPlanRelId.isEmpty else {
                
                if (self.viewModel.cpDetail.planDetails.deviceType ?? "") == "A" {
                    Alert.shared.showAlert(message: AppMessages.CrossPlatformSubscribeCancel, completion: nil)
                }
                else {
                    //cancel purchase
                    let vc = CancelPlanPopupVC.instantiate(fromAppStoryboard: .setting)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.completionHandler = { [weak self] obj in
                        guard let self = self else { return }
                        
                        if obj?.count > 0 {
                            if selectedDuration.iosPrice > 0 {
                                if isIndividual {
                                    InAppManager.shared.cancelPurchase()
                                }
                                else {
                                    InAppManager.shared.cancelPurchase()
                                }
                            }
                            else {
                                //For free plan, use api
                                self.viewModel.cancelPlanAPI(patient_plan_rel_id: self.patientPlanRelId,
                                                             withLoader: true) { [weak self] isDone in
                                    
                                    guard let self = self else {return}
                                    
                                    if isDone {
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                                            GlobalAPI.shared.getPatientDetailsAPI(withLoader: true) { [weak self] (isDone) in
                                                guard let self = self else { return }
                                                
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
                
                return
            }
            
            guard isIndividual else {
                self.viewModel.purchasePlan()
                return
            }
            
            guard !selectedDuration.deviceNames.isEmpty || !selectedDuration.diagnosticTests.isEmpty else {
                let vc = BCPPlanDetailsVC.instantiate(fromAppStoryboard: .BCP_temp)
                vc.cpDetails = self.viewModel.cpDetail
                vc.toView = .SelectAddress
                self.navigationController?.pushViewController(vc, animated: true)
//                Settings().isHidden(setting: .is_bcp_with_in_app) { [weak self] isInApp in
//                    guard let self = self else { return }
//                    guard isInApp else {
//                        //TODO: - Razorpay should initiated, same thing will perform on checkout page for BCP
//
//                        return
//                    }
//                    self.viewModel.purchasePlan()
//                }
                return
            }
            
            self.presentAddress()
            
        }
    }
    
    private func presentAddress() {
        
        GlobalAPI.shared.addressListAPI { [weak self] dataResponse in
            guard let self = self else { return }
            
            var params              = [String : Any]()
            params[AnalyticsParameters.bottom_sheet_name.rawValue]            = BottomScreenName.select_address.rawValue
            params[AnalyticsParameters.plan_type.rawValue]          = self.viewModel.cpDetail.planDetails.planType
                                    
            FIRAnalytics.FIRLogEvent(eventName: .SHOW_BOTTOM_SHEET,
                                     screen: .SelectAddressBottomSheet,
                                     parameter: params)
            
            let vc = BCASelectAddressListVC.instantiate(fromAppStoryboard: .bca)
            let navController = UINavigationController(rootViewController: vc) //Add navigation controller
            vc.viewModel.arrList = dataResponse
            vc.viewModel.cpDetails = self.viewModel.cpDetail
            vc.isFromBCP = true
            navController.modalPresentationStyle = .overFullScreen
            navController.modalTransitionStyle = .crossDissolve
            self.present(navController, animated: isShowAddressList, completion: nil)
        }

    }
    
    private func setupViewModelObserver() {
        self.viewModel.isPlanChange.bind { [weak self] isDone in
            guard let self = self, (isDone ?? false) else { return }
            self.tblPlans.reloadData()
            /*UIView.animate(withDuration: 0.5) { [weak self] in
             guard let self = self else { return }*/
            self.tblPlans.isHidden = self.viewModel.cpDetail.durationDetails.isEmpty
            //            }
            
        }
        self.viewModel.isFeatureChange.bind { [weak self] isDone in
            guard let self = self, (isDone ?? false) else { return }
            /*UIView.animate(withDuration: 0.5) { [weak self] in
             guard let self = self else { return }*/
//            self.vwFeature.isHidden = true// self.viewModel.getNumOfSectionInFeature() == 0
            //            }
            self.tblFeatureTitles.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.tblFeatures.reloadData()
                self.vwFeature.isHidden = self.viewModel.getNumOfSectionInFeature() == 0
            }
            
            self.colFeature.reloadData()
        }
        self.viewModel.isDetailsChange.bind { [weak self] isDone in
            guard let self = self, (isDone ?? false) else { return }
            self.setData()
            self.viewModel.getPlans()
            self.viewModel.getFeatures()
            self.lblBuyOrRentTitle.text = "Select to Rent/Buy " + self.viewModel.cpDetail.planDetails.devices.map({ $0.title }).joined(separator: ",")
            self.lblBuyOrRentTitle.numberOfLines = 0
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if keyPath == "contentSize", let size = change?[.newKey] as? CGSize {
                if obj == self.tblPlans {
                    self.constPlanHeight.constant = size.height
                }else if obj == self.tblFeatureTitles {
                    self.consFeatureHeight.constant = size.height
                }
                
            }
        } else if let obj = object as? UICollectionView {
            if obj == self.colFeature && keyPath == "contentSize", let size = change?[.newKey] as? CGSize {
                self.consFeatureWidth.constant = size.width
            }
        }
        
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = BCPCarePlanDetailVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
        self.viewModel.getPlans()
        self.viewModel.getFeatures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        WebengageManager.shared.navigateScreenEvent(screen: .BcpDetails)
        if isShowAddressList {
            self.presentAddress()
            isShowAddressList = false
        } else {
            selectedAddressIndex = 0
        }
    }
    
    
}

//------------------------------------------------------
//MARK: - TableViewDelegate&Datasource
extension BCPCarePlanDetailVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tblPlans {
            return self.viewModel.getNumOfSection()
        }else if tableView == self.tblFeatureTitles || tableView == self.tblFeatures {
            return self.viewModel.getNumOfSectionInFeature()
        }else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tblPlans {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 15, height: 40))
            lbl.font(name: .semibold, size: 16)
            lbl.text = self.viewModel.getTitle(section)
            view.addSubview(lbl)
            return view
        }else if tableView == self.tblFeatureTitles {
            let headerTitle = UINib(nibName: "FeatureHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! FeatureHeaderView
            headerTitle.lblTitle.text = self.viewModel.getTitleForFeature(section).title
            headerTitle.lblTitle.numberOfLines = 0
            headerTitle.constBottom.constant = self.viewModel.getNumOfRowsInFeature(section) == 0 ? 10 : 8
            return headerTitle
        }else if tableView == self.tblFeatures && self.viewModel.getTitleForFeature(section).arrData.count > 0 {
            let cell = tableView.dequeueReusableCell(withClass: FeatureCheckedCell.self)
//            cell.configure(arrFeature: self.viewModel.getTitleForFeature(section).arrData, frame: CGSize(width: self.viewModel.getSizeOfPlan(), height: self.viewModel.getTitleForFeature(section).title.heightForText(width: ((ScreenSize.width / 2) - 16), font: UIFont.customFont(ofType: .regular, withSize: 11.0)) + 32), consTop: 0)
            cell.configure(arrFeature: self.viewModel.getTitleForFeature(section).arrData, frame: CGSize(width: self.viewModel.getSizeOfPlan(), height: self.viewModel.getTitleForFeature(section).height), consTop: 0, isHeader: true)
            //            cell.contentView.backGroundColor(color: .black)
            return cell
        }
        
        return UIView()
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tblPlans {
            return self.viewModel.getTitle(section).heightOfString(usingFont: UIFont.customFont(ofType: .semibold, withSize: 16.0)) + 20
        }else if tableView == self.tblFeatureTitles || tableView == self.tblFeatures {
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: (ScreenSize.width / 2) - 16, height: 100))
            lbl.text = self.viewModel.getTitleForFeature(section).title
            lbl.numberOfLines = 0
                              
            let height = self.viewModel.getTitleForFeature(section).title.heightForText(width: (ScreenSize.width / 2) - 16, font: UIFont.customFont(ofType: .medium, withSize: 12.0)) + (self.viewModel.getNumOfRowsInFeature(section) == 0 ? lbl.calculateMaxLines() > 2 ? 25 : 20 : 18)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.viewModel.setHeight(height, sec: section)
            }
            return height
            //.heightOfString(usingFont: UIFont.customFont(ofType: .medium, withSize: 11.0)) + 12
        }else {
            return CGFloat()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblPlans {
            return self.viewModel.getNumOfRows(section)
        }else if tableView == self.tblFeatureTitles || tableView == self.tblFeatures {
            return self.viewModel.getNumOfRowsInFeature(section)
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblPlans {
            let cell = tableView.dequeueReusableCell(withClass: BCPCarePlanDetailCell.self, for: indexPath)
            cell.configure(self.viewModel.getListOfRow(indexPath))
            return cell
        }else if tableView == self.tblFeatureTitles {
            let cell = tableView.dequeueReusableCell(withClass: FeatureTitleCell.self, for: indexPath)
            cell.configure(data: self.viewModel.getListOfRowInFeature(indexPath).title)
            cell.consTitleBottom.constant = indexPath.row == (self.viewModel.getNumOfRowsInFeature(indexPath.section) - 1) ? 10 : 4
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.viewModel.setHeight(cell.frame.height, ip: indexPath)
            }
            
            return cell
        }else if tableView == self.tblFeatures {
            let cell = tableView.dequeueReusableCell(withClass: FeatureCheckedCell.self, for: indexPath)
            let heightOFTitle = self.viewModel.getListOfRowInFeature(indexPath).title.heightForText(width: ((ScreenSize.width / 2) - 16), font: UIFont.customFont(ofType: .regular, withSize: 12.0))
//            cell.configure(arrFeature: self.viewModel.getListOfRowInFeature(indexPath).arrData,frame: CGSize(width: self.viewModel.getSizeOfPlan(), height: indexPath.row == (self.viewModel.getNumOfRowsInFeature(indexPath.section) - 1) ? heightOFTitle + (indexPath.row == (self.viewModel.getNumOfRowsInFeature(indexPath.section) - 1) ? 10 : 4) : 20))
            
//            cell.configure(arrFeature: self.viewModel.getListOfRowInFeature(indexPath).arrData,frame: CGSize(width: self.viewModel.getSizeOfPlan(), height: indexPath.row == (self.viewModel.getNumOfRowsInFeature(indexPath.section) - 1) ? heightOFTitle + 10 : heightOFTitle + 4))
            
            cell.configure(arrFeature: self.viewModel.getListOfRowInFeature(indexPath).arrData,frame: CGSize(width: self.viewModel.getSizeOfPlan(), height: self.viewModel.getListOfRowInFeature(indexPath).height))
            
            /*cell.configure(numberOfCell: 4, frame: CGSize(width: ScreenSize.width / 4, height: self.viewModel.getListOfRowInFeature(indexPath).heightForText(width: ((ScreenSize.width / 2) - 16), font: UIFont.customFont(ofType: .regular, withSize: 11.0)) + 8.0))*/
            return cell
        }
        else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblPlans {
            self.viewModel.didSelect(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView == self.tblFeatureTitles || tableView == self.tblFeatures ? 1.0 : CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard tableView == self.tblFeatureTitles || tableView == self.tblFeatures else {
            return nil
        }
        let vw = UIView()
        vw.backGroundColor(color: section == (self.viewModel.getNumOfRowsInFeature(section) - 1) ? .clear : .ThemeBorder)
        return vw
        
    }
    
}

//------------------------------------------------------
//MARK: - UICollectionViewDelegate,DataSource
extension BCPCarePlanDetailVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getNumOfRows(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: BCPFeatureCell.self, for: indexPath)
        let obj = self.viewModel.getListOfRow(indexPath)
        cell.lblTitle.text = obj.durationTitle
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = self.viewModel.getListOfRow(indexPath)
        Alert.shared.showAlert(message: obj.durationTitle + " - " + obj.durationName, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.viewModel.getSizeOfPlan(), height: collectionView.frame.height)
    }
    
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension BCPCarePlanDetailVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //self.webViewDesc.frame.size.height = 1
        //        self.webViewDesc.frame.size = webView.scrollView.contentSize
        //self.webViewDescHeight.constant = webView.scrollView.contentSize.height
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                    print(height as! CGFloat)
                    self.constWebViewHeight.constant = height as! CGFloat
                })
            }
        })
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\(navigation.debugDescription)")
    }
    
}
