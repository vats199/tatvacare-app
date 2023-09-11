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
    
    @IBOutlet weak var btnAlign: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK: - Class Variables -
    
    //MARK: - Class Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblServiceName.font(name: .bold, size: 14).textColor(color: .themeBlack2)
        self.lblServiceDesc.font(name: .light, size: 12).textColor(color: .ThemeGray61)
        
        self.vwBG.cornerRadius(cornerRadius: 12).themeShadowBCP()
    }
}

class PurchsedCarePlanVC: LightPurpleNavigationBase {
    
    //MARK: - Outlets -
    @IBOutlet weak var lblNavTitle: SemiBoldBlackTitle!
    
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
    
    //------------------------------------------------------
    //MARK: - Class Variables -
    var viewModel = PurchsedCarePlanVM()
    var isBack = false
    var planName = ""
    
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
        WebengageManager.shared.navigateScreenEvent(screen: .BcpPurchasedDetails)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        
    }
    
    func applyStyle() {
        self.lblYourServvice.font(name: .bold, size: 20).textColor(color: .themeBlack).text = "Your Services"
        self.lblWhatToExpect.font(name: .bold, size: 20).textColor(color: .themeBlack).text = "What to expect"
        self.lblNavTitle.text = self.viewModel.planDetails.planName
        self.lblHelp.font(name: .regular, size: 12).textColor(color: .ThemeBlack21).text = "Need Help with something?"
        self.lblContactUS.font(name: .bold, size: 12).textColor(color: .themePurple).text = "Contact Us"
        
        self.vwHelp.cornerRadius(cornerRadius: 12).themeShadowBCP()
        
//        self.vwHelp.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.05), shadowOpacity: 1)
        
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.vwHelp.borderColor(color: .ThemeBorder, borderWidth: 1).setRound()
        
        
//        }
    }
    
    private func setupViewModelObserver() {
        self.viewModel.isResult.bind { [weak self] data in
            guard let self = self,let data = data else { return }
            self.lblNavTitle.text = data["plan_name"].stringValue
            if let decription = data["what_to_expect"].string,!decription.isEmpty {
                self.vwWebkit.loadHTMLString(decription.replacingOccurrences(of: """
                                                \"
                                                """, with: """
                                                "
                                                """), baseURL: Bundle.main.bundleURL)
                self.svExpect.isHidden = false
            }else {
                self.webKitConstHeight.constant = 0
                self.svExpect.isHidden = true
            }
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
        cell.lblServiceName.text = obj.strServiceName
        cell.lblServiceDesc.text = obj.strServiceDesc
        kPateintPlanRefID = self.viewModel.planDetails.patientPlanRelId
        if obj.type == .Time {
            GFunction.shared.updateCartCount(btn: cell.btnAlign,false,vm: self.viewModel)
        }else {
            cell.btnAlign.addAction(for: .touchUpInside) { [weak self] in
                guard let self = self else { return }
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
