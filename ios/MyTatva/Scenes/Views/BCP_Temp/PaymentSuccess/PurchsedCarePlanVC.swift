//
//  PurchsedCarePlanVC.swift
//  MyTatva
//
//  Created by 2022M43 on 08/06/23.
//

import Foundation
import UIKit
class ServicesCell: UITableViewCell {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var vwBG: UIView!
    
    @IBOutlet weak var imgService: UIImageView!
    
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblServiceDesc: UILabel!
    @IBOutlet weak var lblTestCount: UILabel!
    @IBOutlet weak var btnAlign: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK: - Class Variables -
    
    //MARK: - Class Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblServiceName.font(name: .bold, size: 14).textColor(color: .themeBlack2)
        self.lblServiceDesc.font(name: .light, size: 12).textColor(color: .ThemeGray61)
        self.lblTestCount.font(name: .regular, size: 12).textColor(color: .themeGreenAlert)
        self.vwBG.cornerRadius(cornerRadius: 12).themeShadowBCP()
    }
}

class PurchsedCarePlanVC: LightPurpleNavigationBase {
    
    //MARK: - Outlets -
    @IBOutlet weak var lblNavTitle: SemiBoldBlackTitle!
    
    @IBOutlet weak var vwYourService: UIView!
    @IBOutlet weak var lblYourServvice: UILabel!
    @IBOutlet weak var lblContactUS: UILabel!
    @IBOutlet weak var lblHelp: UILabel!
    
    @IBOutlet weak var tblServices: UITableView!
    
    @IBOutlet weak var svExpect: UIStackView!
    @IBOutlet weak var lblWhatToExpect: UILabel!
    @IBOutlet weak var vwWebkit: WKWebView!
    
    @IBOutlet weak var vwHelp: UIView!
    
    @IBOutlet weak var btnHelp: UIButton!
    
    @IBOutlet weak var tblServiceConstHeight: NSLayoutConstraint!
    @IBOutlet weak var webKitConstHeight: NSLayoutConstraint!
    
    //-------------------------- CarePlan Renew box
    @IBOutlet weak var vwCarePlan: UIView!
    @IBOutlet weak var svProgress: UIStackView!
    @IBOutlet weak var lblCarePlanName: UILabel!
    @IBOutlet weak var lblDaysRemaining: UILabel!
    @IBOutlet weak var vwProgress: UIProgressView!
    @IBOutlet weak var lblCareDetails: UILabel!
    @IBOutlet weak var imgCarePlan: UIImageView!
    @IBOutlet weak var vwBtnRenew: UIView!
    @IBOutlet weak var btnRenew: ThemePurple16Corner!
    
    //------------------------------------------------------
    
    //MARK: - Class Variables -
    var viewModel = PurchsedCarePlanVM()
    var isBack = false
    var planName = ""
    var planDetails: PlanDetail?
    
    var durationDetails : DurationDetailModel?
    
    var isDiagnosticTests = false
    var isPlanExpired = false
    var isPlanActive = false
    var renewCompletion:((Bool) -> Void)?
    
    //------------------------------------------------------
    //MARK: - UIView Life Cycle Methods -
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
        self.viewModel.getCarePlanService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        //self.isBack = false
        WebengageManager.shared.navigateScreenEvent(screen: .BcpPurchasedDetails)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        if !self.isBack {
        //            self.navigationController?.setNavigationBarHidden(true, animated: true)
        //        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //------------------------------------------------------
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    //MARK: - Custome Methods -
    func setUpView() {
        self.applyStyle()
        self.addObserverOnHeightTbl()
        
        self.tblServices.delegate = self
        self.tblServices.dataSource = self
        
        self.vwWebkit.navigationDelegate = self
        self.vwWebkit.scrollView.isScrollEnabled = true
        self.vwWebkit.scrollView.bounces = false
        self.vwWebkit.getZoomDisableScript()
        self.vwWebkit.backGroundColor(color: .clear)
        self.webKitConstHeight.constant = 0
        
        self.btnHelp.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            GFunction.shared.openContactUs()
            var params              = [String : Any]()
            params[AnalyticsParameters.plan_id.rawValue] = self.viewModel.planDetails.planMasterId
            //            params[AnalyticsParameters.plan_type.rawValue] = self.viewModel.planDetails.planType
            //            params[AnalyticsParameters.patient_plan_rel_id.rawValue] = self.viewModel.planDetails.patientPlanRelId
            //            params[AnalyticsParameters.plan_duration.rawValue]      = selectedDuration?.duration ?? 0
            //            params[AnalyticsParameters.rentOrBuy.rawValue]          = selectedDuration?.rentBuyType ?? ""
            //            params[AnalyticsParameters.plan_value.rawValue]         = self.finalAmount
            
            FIRAnalytics.FIRLogEvent(eventName: .TAP_CONTACT_US,
                                     screen: .BcpPurchasedDetails,
                                     parameter: params)
        }
        
        self.vwBtnRenew.isHidden = true
        
    }
    
    func applyStyle() {
        self.lblYourServvice.font(name: .bold, size: 20).textColor(color: .themeBlack).text = "Your Services"
        self.lblWhatToExpect.font(name: .bold, size: 20).textColor(color: .themeBlack).text = "What to expect"
        self.lblNavTitle.text = self.viewModel.planDetails.planName
        self.lblHelp.font(name: .regular, size: 12).textColor(color: .ThemeBlack21).text = "Need Help with something?"
        self.lblContactUS.font(name: .bold, size: 12).textColor(color: .themePurple).text = "Contact Us"
        
        self.vwHelp.cornerRadius(cornerRadius: 12).themeShadowBCP()
        
        self.vwCarePlan.cornerRadius(cornerRadius: 12).themeShadowBCP()
        self.lblCarePlanName.font(name: .bold, size: 14).textColor(color: .themeBlack).text = nil
        self.lblCareDetails.font(name: .regular, size: 10).textColor(color: .themeGray4).text = "Bundled with diagnostic tests and monitoring devices."
        self.lblDaysRemaining.font(name: .regular, size: 12).textColor(color: .themeGray4).text = nil
        self.vwProgress.progress = 0
        self.btnRenew.setTitle("Renew Now", for: .normal)
        self.vwBtnRenew.isHidden = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwCarePlan.cornerRadius(cornerRadius: 12).themeShadowBCP()
        }
        
        self.lblCarePlanName.font(name: .bold, size: 14).textColor(color: .themeBlack).text = nil
        self.lblCareDetails.font(name: .regular, size: 10).textColor(color: .themeGray4).text = "Bundled with diagnostic tests and monitoring devices."
        self.lblDaysRemaining.font(name: .regular, size: 12).textColor(color: .themeGray4).text = nil
        self.vwProgress.progress = 0
        self.btnRenew.setTitle("Renew Now", for: .normal)
        self.btnRenew.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self, let object = self.planDetails else { return }
            
            var params              = [String : Any]()
            params[AnalyticsParameters.plan_id.rawValue]            = object.planMasterId
            params[AnalyticsParameters.plan_type.rawValue]          = object.planType
            params[AnalyticsParameters.plan_expiry_date.rawValue]   = object.expiryDate
            params[AnalyticsParameters.days_to_expire.rawValue]     = object.remainingDays
            FIRAnalytics.FIRLogEvent(eventName: .RENEW_PLAN,
                                     screen: .BcpPurchasedDetails,
                                     parameter: params)
            guard self.isPlanActive else {
                guard let arrVCs = self.navigationController?.viewControllers else { return }
                if arrVCs.contains(where: {$0.isKind(of: BCPCarePlanVC.self)}) {
                    arrVCs.forEach({
                        if $0.isKind(of: BCPCarePlanVC.self) {
                            self.renewCompletion?(true)
                            self.navigationController?.popToViewController($0, animated: true)
                        }
                    })
                }else {
                    let vc = BCPCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
                    vc.hidesBottomBarWhenPushed = true
                    vc.isMoveToOthers = true
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
                return
            }
            
            GlobalAPI.shared.planDetailsAPI(plan_id: object.planMasterId,
                                            durationType: object.enableRentBuy ? object.planType == kIndividual ? kRent : nil : nil,
                                            /*patientPlanRelId: object.patientPlanRelId,*/
                                            withLoader: true) { [weak self] isDone, object1, msg in
                guard let self = self else {return}
                if isDone {
                    //  self.isBack = true
                    let vc = BCPCarePlanDetailVC.instantiate(fromAppStoryboard: .BCP_temp)
                    
                    vc.isFromPurchasedPlan  = true
                    vc.plan_id              = object.planMasterId
                    vc.viewModel.cpDetail   = object1
                    //                    vc.patientPlanRelId     = object.patientPlanRelId
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    private func setupViewModelObserver() {
        self.viewModel.isResult.bind { [weak self] data in
            guard let self = self,let data = data else { return }
            
            self.isPlanActive = data["plan_active"].boolValue
            
            self.lblNavTitle.text = data["plan_name"].stringValue
            
            let durationDetails = DurationDetailModel(fromJson: data["duration_details"])
            self.durationDetails = durationDetails
            
            self.isDiagnosticTests = JSON(data["diagnostic_tests"] as Any).boolValue
            
            if let decription = data["what_to_expect"].string,!decription.isEmpty {
                self.vwWebkit.loadHTMLString(decription.replacingOccurrences(of: """
                                                \"
                                                """, with: """
                                                "
                                                """), baseURL: Bundle.main.bundleURL)
                self.svExpect.isHidden = false
                
                let planDetails = PlanDetail(fromJson: data["plan_details"])
                self.planDetails = planDetails
                
                let totalPlans = JSON(planDetails.totalDays as Any).doubleValue
                let remainingDays = JSON(planDetails.remainingDays as Any).doubleValue
                let differenceDays = (totalPlans - remainingDays)
                
                self.isPlanExpired = false
                
                self.lblCarePlanName.text = planDetails.planName
                self.vwProgress.progress = remainingDays < 0 ? 1.0 : JSON(planDetails.totalDays as Any).doubleValue == 0.0 ? 0.0 : Float( differenceDays / (totalPlans+1))
                
                
                let progressColor: UIColor = {
                    self.vwBtnRenew.isHidden = remainingDays > 14
                    self.lblDaysRemaining.text = "\(JSON(remainingDays as Any).intValue) days remaining"
                    
                    if !(remainingDays > 14) {
                        self.vwBtnRenew.isHidden = !JSON(planDetails.isShowRenew as Any).boolValue
                    }
                    
                    if remainingDays < 0 {
                        self.isPlanExpired = true
                        self.lblDaysRemaining.text = "Plan Expired"
                        return .themeRedAlert
                    } else if remainingDays == 0 || remainingDays == 1 {
                        self.lblDaysRemaining.text = remainingDays == 1 ? "Expiring tomorrow".capitalized : "expiring Today".capitalized
                        return .themeRedAlert
                    }
                    else if remainingDays <= 7 {
                        return .themeRedAlert
                    }else if remainingDays <= 14 {
                        return .themeYellow
                    }else if remainingDays > 14 {
                        self.lblDaysRemaining.text = "Expire on \(GFunction.shared.convertDateFormat(dt: planDetails.expiryDate, inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue, outputFormat: DateTimeFormaterEnum.MMMMDDYYYY.rawValue, status: .NOCONVERSION).0)"
                        return .themeGreenAlert
                    }else {
                        return .themeRedAlert
                    }
                }()
                self.vwProgress.progressTintColor = progressColor
                self.lblDaysRemaining.textColor(color: remainingDays > 14 ? .themeGray4 : progressColor)
                self.vwProgress.tintColor = .ThemeGrayE0
                
            }else {
                self.webKitConstHeight.constant = 0
                self.svExpect.isHidden = true
            }
            
            self.vwYourService.isHidden = (self.viewModel.numberOfCount() == 0) ? true : false
            self.tblServices.reloadData()
            
        }
    }
    
    //MARK: - Button Action Methods -
    @IBAction func btnBackTapped(_ sender: Any) {
        guard self.isBack else {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            UIApplication.shared.setHome()
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: UITableViewDelegate and UITableViewDataSource
extension PurchsedCarePlanVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ServicesCell.self)
        let obj = self.viewModel.listOfRows(indexPath.row)
        
        cell.lblTestCount.isHidden = obj.type == .Time && (self.durationDetails?.diagnosticTestSessionCount != 0) ? false : true
        
        let usedCount = self.durationDetails?.diagnosticTestUsedCount ?? 0
        let sessionCount = self.durationDetails?.diagnosticTestSessionCount ?? 0
        
        let finalCount = sessionCount - usedCount
        
        if self.isDiagnosticTests {
            if self.lblDaysRemaining.text == "Plan Expired" {
                cell.lblTestCount.text = "Plan Expired"
                cell.lblTestCount.textColor(color: .themeRedAlert)
            } else {
                cell.lblTestCount.text = "\(finalCount)/\(sessionCount) Left"
                if finalCount <= 0 {
                    cell.lblTestCount.textColor(color: .themeRedAlert)
                } else {
                    cell.lblTestCount.textColor(color: .themeGreenAlert)
                }
            }
        }
        
        cell.lblServiceName.text = obj.strServiceName
        cell.lblServiceDesc.text = obj.strServiceDesc
        kPateintPlanRefID = self.viewModel.planDetails.patientPlanRelId
        if obj.type == .Time {
            GFunction.shared.updateCartCount(btn: cell.btnAlign,false,vm: self.viewModel, isPlanExpired: self.isPlanExpired)
        }else {
            cell.btnAlign.addAction(for: .touchUpInside) { [weak self] in
                guard let self = self, !self.isPlanExpired else { return }
                if obj.type == .Slot {
                    
                    var params              = [String : Any]()
                    params[AnalyticsParameters.plan_id.rawValue]            = self.viewModel.planDetails.planMasterId
                    FIRAnalytics.FIRLogEvent(eventName: .TAP_HEALTH_COACH_CARD,
                                             screen: .BcpPurchasedDetails,
                                             parameter: params)
                    
                    let vc = ScheduleAppointmentVC.instantiate(fromAppStoryboard: .bca)
                    vc.viewModel.pateintPlanRefID = self.viewModel.planDetails.patientPlanRelId
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if obj.type == .Device {
                    
                    var params = [String:Any]()
                    params[AnalyticsParameters.plan_id.rawValue] = self.viewModel.planDetails.planMasterId
                    FIRAnalytics.FIRLogEvent(eventName: .TAP_DEVICE_CARD,
                                             screen: .BcpPurchasedDetails,
                                             parameter: params)
                    
                    let vc = MyDeviceVC.instantiate(fromAppStoryboard: .BCP_temp)
                    vc.viewModel.pateintPlanRefId = self.viewModel.planDetails.patientPlanRelId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        cell.imgService.image = UIImage(named: obj.imgService)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
        let type = self.viewModel.listOfRows(indexPath.row).type
        switch type {
        case .Time:
            GlobalAPI.shared.get_cart_infoAPI { [weak self] isDone, count, isBCPFlag in
                guard let self = self else { return }
                if count > 0 || isBCPFlag {
                    let vc = BCPCartDetailVC.instantiate(fromAppStoryboard: .BCP_temp)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    Alert.shared.showSnackBar(AppMessages.YourCartIsEmpty, isError: true, isBCP: true)
                }
            }
            break
        case .Slot:
            let vc = ScheduleAppointmentVC.instantiate(fromAppStoryboard: .bca)
            vc.viewModel.pateintPlanRefID = self.viewModel.planDetails.patientPlanRelId
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case .Device:
            
            var params = [String:Any]()
            params[AnalyticsParameters.plan_id.rawValue] = self.viewModel.planDetails.planMasterId
            FIRAnalytics.FIRLogEvent(eventName: .TAP_DEVICE_CARD,
                                     screen: .BcpPurchasedDetails,
                                     parameter: params)
            
            let vc = MyDeviceVC.instantiate(fromAppStoryboard: .BCP_temp)
            vc.viewModel.pateintPlanRefId = self.viewModel.planDetails.patientPlanRelId
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
}

//MARK: -------------------------- Observers Methods --------------------------
extension PurchsedCarePlanVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblServices, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            DispatchQueue.main.async {
                self.tblServiceConstHeight.constant = newvalue.height
            }
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblServices.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblServices else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension PurchsedCarePlanVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.vwWebkit.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.vwWebkit.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                    self.webKitConstHeight.constant = height as! CGFloat
                })
            }
        })
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\(navigation.debugDescription)")
    }
    
}
