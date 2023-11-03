//
//  BCPCarePlanVC.swift
//  MyTatva
//
//  Created by 2022M43 on 30/05/23.
//

import Foundation
import UIKit
class BCPCareCell: UITableViewCell {
    
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var imgCareImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    private func applyStyle() {
        self.vwBG.themeShadowBCP()
        self.imgCareImage.cornerRadius(cornerRadius: 10.0).contentMode = .scaleAspectFill
    }
    
}

class BCPCarePlanVC: LightPurpleNavigationBase {
    
    //MARK: - Outlets -
    @IBOutlet weak var lblNavTittle: SemiBoldBlackTitle!
    @IBOutlet weak var tblCarePlans: UITableView!
    
    //------------------------------------------------------
    //MARK: - Class Variables -
    let viewModel = BCPCarePlanVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    var isMoveToOthers              = false
    var isHideNav                   = true
    var numberOfCardTap             = 0
    enum planType: String { case show_nutritionist,show_physio,show_book_device }

        var showPlanType: planType?
    //------------------------------------------------------
    //MARK: - UIView Life Cycle Methods -
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isHideNav {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            self.isHideNav = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.updateAPIData()
        WebengageManager.shared.navigateScreenEvent(screen: .BcpList)
    }
    
    //------------------------------------------------------
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    //MARK: - Custome Methods -
    func setUpView() {
        
        self.applyStyle()
        self.configureUI()
        
    }
    
    func applyStyle() {
        self.lblNavTittle.text = "Chronic Care Programs"
    }
    
    func configureUI(){
        
        self.tblCarePlans.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblCarePlans.emptyDataSetSource         = self
        self.tblCarePlans.emptyDataSetDelegate       = self
        self.tblCarePlans.delegate                   = self
        self.tblCarePlans.dataSource                 = self
        self.tblCarePlans.rowHeight                  = UITableView.automaticDimension
        self.tblCarePlans.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: Double.leastNormalMagnitude))
        self.tblCarePlans.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblCarePlans.addSubview(self.refreshControl)
        
    }
    
    @objc func updateAPIData(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.refreshControl.beginRefreshing()
            self.tblCarePlans.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            self.viewModel.apiCallFromStartPlansList(tblView: self.tblCarePlans,
                                                     refreshControl: self.refreshControl,
                                                     plan_type: "S",
                                                     showPlanType:self.showPlanType?.rawValue,
                                                     withLoader: false)
        }
    }
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                // Success handle
                
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.tblCarePlans.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    guard let self = self else { return }
                    if self.isMoveToOthers {
                        self.isMoveToOthers = false
                        if self.tblCarePlans.numberOfSections > 0 {
                            let indexPath = IndexPath(item: 0, section: self.tblCarePlans.numberOfSections - 1)
                            if let cell = self.tblCarePlans.cellForRow(at: indexPath) {
                                self.tblCarePlans.scrollToView(view: cell, animated: true)
                            }
                        }
                    }
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true, isBCP: true)
                
            case .none: break
            }
        })
    }
    
    //MARK: - Button Action Methods -
}

//MARK: UITableViewDelegate and UITableViewDataSource
extension BCPCarePlanVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getObject(index: section).planDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: CarePlansCell.identifier) as! CarePlansCell
        //        cell.configCell()
        let cell = tableView.dequeueReusableCell(withClass: BCPCareCell.self)
        let obj = self.viewModel.getObject(index: indexPath.section).planDetails[indexPath.row]
        cell.imgCareImage.setCustomImage(with: obj.imageUrl, placeholder: UIImage(named: "defaultUser"))
//        cell.imgCareImage.shadow(color: .themeGray, shadowOffset: .zero, shadowOpacity: 0.4)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.numberOfCardTap += 1
        
        let object = self.viewModel.getObject(index: indexPath.section).planDetails[indexPath.row]
        
        var params              = [String : Any]()
        params[AnalyticsParameters.plan_id.rawValue]            = object.planMasterId
        params[AnalyticsParameters.plan_type.rawValue]          = object.planType
        params[AnalyticsParameters.plan_expiry_date.rawValue]   = object.planEndDate
        params[AnalyticsParameters.card_number.rawValue]        = self.numberOfCardTap
        
        FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_CARE_PLAN_CARD,
                                 screen: .BcpList,
                                 parameter: params)
        
        if !object.patientPlanRelId.isEmpty && object.planType == kIndividual {
            //TODO: - Open BCP Detail screen and call service API call
            
            let vc = PurchsedCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
            vc.viewModel.planDetails = object
            vc.isBack = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        GlobalAPI.shared.planDetailsAPI(plan_id: object.planMasterId,
                                        durationType: object.enableRentBuy ? object.planType == kIndividual ? kRent : nil : nil,
                                        patientPlanRelId: object.patientPlanRelId,
                                        withLoader: true) { [weak self] isDone, object1, msg in
            guard let self = self else {return}
            if isDone {
                self.isHideNav = false
                let vc = BCPCarePlanDetailVC.instantiate(fromAppStoryboard: .BCP_temp)
                
                vc.plan_id              = object.planMasterId
                vc.viewModel.cpDetail   = object1
                vc.patientPlanRelId     = object.patientPlanRelId
//                vc.isScrollToBuy    = isScrollToBuy
                vc.completionHandler = { obj in
                    if obj?.count > 0 {
                        self.isMoveToOthers = true
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 16, y: 0, width: view.frame.width - 15, height: 40))
        lbl.font(name: .bold, size: 20)
        lbl.text = self.viewModel.getObject(index: section).title
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.viewModel.getCount() == 1 ? CGFloat.leastNonzeroMagnitude : 30
    }
    
}
//MARK: ------------------ Empty TableView Methods ------------------
extension BCPCarePlanVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
