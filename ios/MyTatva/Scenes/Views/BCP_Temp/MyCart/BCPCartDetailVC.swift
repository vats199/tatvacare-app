//
//  BCPCartDetailVC.swift
//  MyTatva
//
//  Created by Hlink on 26/06/23.
//

import UIKit

class BCPCartDetailVC: LightPurpleNavigationBase {

    //MARK: Outlet
    @IBOutlet weak var lblNavTitle: SemiBoldBlackTitle!
    
    //----------------- Patient Details -------------------
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblPatientName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var imgAddress: UIImageView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var imgMobile: UIImageView!
    @IBOutlet weak var vwPatientDetails: UIView!
    @IBOutlet weak var vwDetails: UIView!
    
    //----------------- test Details -------------------
    @IBOutlet weak var lblTestDetails: UILabel!
    @IBOutlet weak var lblAddTest: UILabel!
    @IBOutlet weak var vwBCPTest: UIView!
    @IBOutlet weak var vwTest: UIView!
    @IBOutlet weak var tblBCPTest: UITableView!
    @IBOutlet weak var tblBCPTestHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnAddTest: UIButton!
    
    //----------------- Billing -------------------
    @IBOutlet weak var vwBilling: UIView!
    @IBOutlet weak var lblBilling: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalOldAmount: UILabel!
    @IBOutlet weak var lblTotalAmountRate: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblSubTotalRate: UILabel!
    @IBOutlet weak var lblSubTotalOldAmount: UILabel!
    @IBOutlet weak var lblCollectionCharge: UILabel!
    @IBOutlet weak var lblCollectionChargeRate: UILabel!
    @IBOutlet weak var lblCollectionOldAmount: UILabel!
    @IBOutlet weak var lblServiceCharge: UILabel!
    @IBOutlet weak var lblServiceChargeRate: UILabel!
    @IBOutlet weak var lblAmountPaid: UILabel!
    @IBOutlet weak var lblAmountPaidRate: UILabel!
    @IBOutlet weak var vwBillingDetails: UIView!
    
    //----------------- booking -------------------
    @IBOutlet weak var vwButtons: UIView!
    @IBOutlet weak var btnPatientDetails: ThemePurple16Corner!
    @IBOutlet weak var btnDateTime: ThemePurple16Corner!
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel           = LabTestCartVM()
    let labTestListVM       = LabTestListVM()
    var object: CartListModel!
    var pendingRequest:DispatchWorkItem?
    var pateintPlanRefID = ""
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(LabTestCartVM.self) ‼️‼️‼️")
        self.tblBCPTest.removeObserver(self, forKeyPath: "contentSize")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.applyStyle()
        self.manageActionMethods()
    }
    
    private func applyStyle() {
        
        self.lblNavTitle.text = "Lab Test Cart"
        self.vwPatientDetails.isHidden = true
        self.vwBilling.isHidden = true
        
        self.btnDateTime.setTitle("Select Date & Time", for: UIControl.State())
        self.btnPatientDetails.setTitle("Select Patient Details", for: UIControl.State())
        
        [self.btnDateTime,self.btnPatientDetails].forEach({$0?.isHidden = true})
        
        // ---------- Patient Details ----------
        self.lblSummary.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Summary"
        self.lblPatientName.font(name: .bold, size: 14).textColor(color: .themeBlack2).text = "Patient Name"
        self.lblAddress.font(name: .regular, size: 14).textColor(color: .ThemeDarkGray).text = "Address"
        self.lblEmail.font(name: .regular, size: 14).textColor(color: .ThemeDarkGray).text = "abc@email.com"
        self.lblMobile.font(name: .regular, size: 14).textColor(color: .ThemeDarkGray).text = "+91-9990000000"
        
        self.imgAddress.image = UIImage(named: "grayAddress_ic")
        self.imgEmail.image = UIImage(named: "grayMail_ic")
//        self.imgMobile.image = UIImage(named: "callGray_ic")
        
        // ---------- Test Details ----------
        self.lblTestDetails.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Test Details"
        self.lblAddTest.font(name: .medium, size: 14).textColor(color: .themePurple).text = "Add Test"
        
        self.tblBCPTest.delegate = self
        self.tblBCPTest.dataSource = self
        if #available(iOS 15.0, *) {
            self.tblBCPTest.sectionHeaderTopPadding = 0.0
        }
        self.tblBCPTest.register(UINib(nibName: "TestListCell", bundle: nil), forCellReuseIdentifier: "TestListCell")
        self.tblBCPTest.separatorStyle = .none
        self.tblBCPTest.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        // ---------- Billing Details ----------
        self.lblBilling.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Billing"
        self.lblTotalAmount.font(name: .regular, size: 14).textColor(color: .ThemeGray61).text = "Total Amount"
        self.lblSubTotal.font(name: .regular, size: 14).textColor(color: .ThemeGray61).text = "Sub Total"
        self.lblCollectionCharge.font(name: .regular, size: 14).textColor(color: .ThemeGray61).text = "Home Collection Charges"
        self.lblServiceCharge.font(name: .regular, size: 14).textColor(color: .ThemeGray61).text = "Service Charge"
        
        self.lblTotalAmountRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "Free"
        self.lblSubTotalRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "Free"
        self.lblCollectionChargeRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "Free"
        self.lblServiceChargeRate.font(name: .medium, size: 14).textColor(color: .ThemeGray61).text = "Free"
        
        self.lblAmountPaid.font(name: .bold, size: 14).textColor(color: .themeBlack).text = "Amount to be Paid"
        self.lblAmountPaidRate.font(name: .bold, size: 14).textColor(color: .themeBlack).text = "Free"
        
        self.vwDetails.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.vwBillingDetails.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.vwButtons.themeShadowBCP()
        
    }
    
    private func setupViewModelObserver() {
        self.labTestListVM.isRemovedFromCart.bind { [weak self] isDone in
            guard let self = self,(isDone ?? false) else { return }
            self.testCardList()
        }
        self.viewModel.isTest.bind { [weak self] isDone in
            guard let self = self else { return }
            self.tblBCPTest.reloadData()
            
            guard let bcpAddressData = self.viewModel.getBCPAddressData() else {
                self.vwPatientDetails.isHidden = true
                return
            }
            self.vwPatientDetails.isHidden = false
            self.lblPatientName.text = UserModel.shared.name
            self.lblEmail.text = UserModel.shared.email
            self.lblMobile.text = UserModel.shared.countryCode + " " + UserModel.shared.contactNo
            self.lblAddress.text = "\(bcpAddressData.address ?? "")\n\(bcpAddressData.street ?? "")\n\(bcpAddressData.pincode ?? 0)"
            self.lblAddress.numberOfLines = 0
            
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                guard let self = self else { return }
                self.tblBCPTest.reloadData()
            }*/
            
        }
        self.viewModel.isCartChanges.bind { [weak self] isDone in
            guard let self = self else { return }
            self.testCardList()
        }
    }
    
    private func testCardList() {
        
        var totalOldAmount = 0
        var totalAmount = 0
        
        var homeOldCollectionCharge = 0
        var homeCollectionCharge = 0
        
        var serviceCharge = 0
        
        var finalPayableAmount = 0
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 11),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        
        func setAmountData() {
            [
                self.lblTotalOldAmount,self.lblCollectionOldAmount
            ].forEach({$0?.isHidden = false})
            
            self.btnPatientDetails.isHidden = true
            self.btnDateTime.isHidden = false
            
            self.lblAmountPaidRate.text = appCurrencySymbol.rawValue + JSON(finalPayableAmount as Any).stringValue
            self.lblTotalOldAmount.text = appCurrencySymbol.rawValue + JSON(totalOldAmount as Any).stringValue
            self.lblTotalOldAmount.attributedText = self.lblTotalOldAmount.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
            self.lblTotalAmountRate.text = appCurrencySymbol.rawValue + JSON(totalAmount as Any).stringValue
            self.lblCollectionOldAmount.text = appCurrencySymbol.rawValue + JSON(homeOldCollectionCharge as Any).stringValue
            self.lblCollectionOldAmount.attributedText = self.lblCollectionOldAmount.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
            self.lblCollectionChargeRate.text = appCurrencySymbol.rawValue + JSON(homeCollectionCharge as Any).stringValue
            self.lblServiceChargeRate.text = serviceCharge == 0 ? KFree : appCurrencySymbol.rawValue + "\(serviceCharge)"
        }
        
        self.viewModel.cartTestListAPI(withLoader: true) { [weak self] isDone, object in
            guard let self = self else {return}
            
            if isDone {
                print(object)
//                self.scrollMain.isHidden = false
                self.object = object
                CartListModel.shared = object
                
                let isBCPAdded = self.object.bcpTestsList.contains(where: { $0.isBcpTestsAdded })
                let isOtherTestAdded = self.object.testsList.filter({$0.type != kBCP}).isEmpty
                
                self.vwBilling.isHidden = !( isBCPAdded || !isOtherTestAdded)
                
                self.lblSubTotal.superview?.isHidden = true
                
                self.btnPatientDetails.isHidden = true
                self.btnDateTime.isHidden = true
                
                guard let orderDetail = object.orderDetail, let homeCharge = object.homeCollectionCharge else { return }
                
                totalOldAmount = JSON(orderDetail.orderTotal as Any).intValue
                totalAmount = JSON(orderDetail.payableAmount as Any).intValue
                homeOldCollectionCharge = homeCharge.ammount
                homeCollectionCharge = homeCharge.payableAmmount
                serviceCharge = JSON(orderDetail.serviceCharge as Any).intValue
                finalPayableAmount = orderDetail.finalPayableAmount
                
                if isBCPAdded && !isOtherTestAdded {
                    var tempOldTotal = 0
                    var tempAmount = 0
                    if let bcpCartData = object.bcpTestsList.first(where: {$0.isBcpTestsAdded}) {
                        bcpCartData.bcpTestsList.forEach({
                            tempOldTotal += $0.price
                            tempAmount += $0.discountPrice
                        })
                    }
                    
                    totalOldAmount -= tempOldTotal
                    totalAmount -= tempAmount
                    finalPayableAmount = (totalAmount+homeCollectionCharge+serviceCharge)
                    
                    setAmountData()
                }
                else if isBCPAdded && isOtherTestAdded {
                    [
                        self.lblTotalOldAmount,self.lblCollectionOldAmount
                    ].forEach({$0?.isHidden = true})
                    
                    self.btnPatientDetails.isHidden = true
                    self.btnDateTime.isHidden = false
                    
                    [
                        self.lblTotalAmountRate,self.lblCollectionChargeRate,self.lblServiceChargeRate,self.lblAmountPaidRate
                    ].forEach({$0?.text = KFree})
                    
                }
                else if !isBCPAdded && !isOtherTestAdded {
                    setAmountData()
                    self.btnPatientDetails.isHidden = false
                    self.btnDateTime.isHidden = true
                }
                
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey] as? CGSize {
                self.tblBCPTestHeightConst.constant = newValue.height
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    func manageActionMethods() {
        self.btnAddTest.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            
            var params              = [String : Any]()
//            params[AnalyticsParameters.plan_id.rawValue]            = self.viewModel.planDetails.planMasterId
//            params[AnalyticsParameters.plan_type.rawValue]          = self.viewModel.planDetails.planType
//            params[AnalyticsParameters.plan_duration.rawValue]      = selectedDuration?.duration ?? 0
//            params[AnalyticsParameters.rentOrBuy.rawValue]          = selectedDuration?.rentBuyType ?? ""
//            params[AnalyticsParameters.plan_value.rawValue]         = self.finalAmount
            
            FIRAnalytics.FIRLogEvent(eventName: .ADD_TEST,
                                     screen: .LabtestCart,
                                     parameter: params)
            
            let vc = AllLabTestListVC.instantiate(fromAppStoryboard: .carePlan)
            vc.labTestType = .all
            vc.viewModel.pateintPlanRefID = self.pateintPlanRefID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnDateTime.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            
            guard let obj = self.viewModel.getBCPAddressData() else { return }
            
            var params1 = [String: Any]()
            params1[AnalyticsParameters.slot_booking_for.rawValue]  = "labTest"
            FIRAnalytics.FIRLogEvent(eventName: .SELECT_DATE_TIME,
                                     screen: .LabtestCart,
                                     parameter: params1)
            
            let vc = SelectTestTimeSlotVC.instantiate(fromAppStoryboard: .bca)
            vc.viewModel.pateintPlanRefID = self.pateintPlanRefID
            vc.cartListModel = self.object
            vc.labAddressListModel = obj
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnPatientDetails.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            let vc = SelectPatientDetailsVC.instantiate(fromAppStoryboard: .carePlan)
            vc.cartListModel = self.object
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = LabTestCartVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.testCardList()
        self.navigationController?.isNavigationBarHidden = false
        WebengageManager.shared.navigateScreenEvent(screen: .LabtestCart)
    }

}

//------------------------------------------------------
//MARK: - UITableViewDelegate&Datasource
extension BCPCartDetailVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let obj = self.viewModel.listOfSec(section)
        return obj.isLabTest && obj.bcpTestsList.count <= 2 ? 0 : self.viewModel.numberOfRows(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestListCell") as! TestListCell
        let isLabTest = self.viewModel.listOfSec(indexPath.section).isLabTest
        let obj = self.viewModel.listOfRow(indexPath)
        
        cell.lblBCPTest.text = self.viewModel.listOfSec(indexPath.section).planName
        cell.btnCheck.isSelected = self.viewModel.listOfSec(indexPath.section).isBcpTestsAdded
        cell.imgCheck.image = UIImage(named: cell.btnCheck.isSelected ? "checkbox_selected" : "checkbox_unselected")
        
        cell.btnDelete.isHidden = !isLabTest
        cell.lblTestName.text = obj.testNames
        cell.vwMainTop.constant = indexPath.row == 0 ? 12 : 0
        cell.vwLineBottomConst.constant = indexPath.row == (self.viewModel.numberOfRows(indexPath.section) - 1) ? 0 : 12
        cell.vwTest.isHidden = true //indexPath.row != 0 || isLabTest
        cell.vwLine.backGroundColor(color: .ThemeBorder)
        cell.vwLine.superview?.isHidden = false //indexPath.row == (self.viewModel.numberOfRows(indexPath.section) - 1)
        
        cell.btnDelete.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    self.labTestListVM.updateCartAPI(isAdd: false,
                                                     code: obj.code,
                                                     labTestId: obj.labTestId,
                                                     screen: .LabtestCart, completion: nil)
                }
            }
        }
        
        cell.btnCheck.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            cell.btnCheck.isSelected = !cell.btnCheck.isSelected
            cell.imgCheck.image = UIImage(named: cell.btnCheck.isSelected ? "checkbox_selected" : "checkbox_unselected")
            self.pendingRequest?.cancel()
            self.pendingRequest = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.viewModel.updateBCPCart(indexPath.section)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: self.pendingRequest!)
        }
        
        DispatchQueue.main.async {
            cell.vwShadow.themeShadowBCP()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestListCell") as! TestListCell
        let obj = self.viewModel.listOfSec(section)
        let isLabTest = obj.isLabTest
        
        cell.lblTestName.font(name: .regular, size: 12).textColor(color: .themeBlack)
        if isLabTest {
            cell.lblTestName.text = self.viewModel.getFirstTest(section)?.testNames.uppercased() ?? ""
        } else {
            cell.lblBCPTest.text = self.viewModel.listOfSec(section).planName
            cell.btnCheck.isSelected = self.viewModel.listOfSec(section).isBcpTestsAdded
            cell.imgCheck.image = UIImage(named: cell.btnCheck.isSelected ? "checkbox_selected" : "checkbox_unselected")
        }
        
        cell.vwTest.isHidden = isLabTest
        cell.vwTestName.isHidden = !isLabTest
        
        if obj.bcpTestsList.count > 1 && obj.isLabTest {
            cell.vwLine.superview?.isHidden = false
            cell.constBottomMain.constant = 0
            cell.constTopMain.constant = 6
            cell.vwLine.backGroundColor(color: .ThemeBorder)
            cell.vwLineBottomConst.constant = 0
        } else {
            cell.vwLine.superview?.isHidden = self.viewModel.numberOfRows(section) > 0 ? true : (!obj.isLabTest && self.viewModel.numberOfRows(section) == 0) ? true : false
            cell.constBottomMain.constant = self.viewModel.numberOfRows(section) > 0 ? 6 : 0
            cell.constTopMain.constant = 6
            cell.vwLine.backGroundColor(color: .clear)
            cell.constBottomMain.constant = self.viewModel.numberOfRows(section) > 0 ? 0 : (!obj.isLabTest && self.viewModel.numberOfRows(section) == 0) ? 0 : 6
            cell.vwLineBottomConst.constant = self.viewModel.numberOfRows(section) > 0 ? 12 : 0
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            cell.vwMain.roundCorners(self.viewModel.numberOfRows(section) > 0 || (!obj.isLabTest && self.viewModel.numberOfRows(section) == 0) ? [.topLeft,.topRight] : [.allCorners], radius: 12.0)
            cell.vwShadow.themeShadowBCP()
            
        }
        
        cell.btnDelete.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    guard let obj = self.viewModel.getLastTest(section) else { return }
                    self.labTestListVM.updateCartAPI(isAdd: false,
                                                     code: obj.code,
                                                     labTestId: obj.labTestId,
                                                     screen: .LabtestCart, completion: nil)
                }
            }
        }
        
        cell.btnCheck.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            cell.btnCheck.isSelected = !cell.btnCheck.isSelected
            cell.imgCheck.image = UIImage(named: cell.btnCheck.isSelected ? "checkbox_selected" : "checkbox_unselected")
            self.pendingRequest?.cancel()
            self.pendingRequest = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.viewModel.updateBCPCart(section)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: self.pendingRequest!)
        }
        return cell.contentView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let obj = self.viewModel.listOfSec(section)
        return obj.bcpTestsList.count > 1 && obj.isLabTest ? 50 : self.viewModel.numberOfRows(section) > 0 || (!obj.isLabTest && self.viewModel.numberOfRows(section) == 0) ? 38 : 61
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let obj = self.viewModel.listOfSec(section)
        guard self.viewModel.numberOfRows(section) > 0 || (!obj.isLabTest && self.viewModel.numberOfRows(section) == 0) else { return nil }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestListCell") as! TestListCell
        let isLabTest = self.viewModel.listOfSec(section).isLabTest
        
        cell.lblTestName.text = self.viewModel.getLastTest(section)?.testNames ?? ""
        cell.vwMainTop.constant = 12
        cell.vwLineBottomConst.constant = 0
        cell.vwTest.isHidden = true
        cell.vwTestName.isHidden = false
        cell.vwLine.isHidden = true
        cell.btnDelete.isHidden = !isLabTest
        cell.constTopMain.constant = 0
        cell.constBottomMain.constant = 6
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            cell.vwMain.roundCorners([.bottomLeft,.bottomRight], radius: 12.0)
            cell.vwShadow.themeShadowBCP()
        }
        
        cell.btnDelete.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.deleteMessage) { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    guard let obj = self.viewModel.getLastTest(section) else { return }
                    self.labTestListVM.updateCartAPI(isAdd: false,
                                                     code: obj.code,
                                                     labTestId: obj.labTestId,
                                                     screen: .LabtestCart, completion: nil)
                }
            }
        }
        
        return cell.contentView
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let obj = self.viewModel.listOfSec(section)
        return self.viewModel.numberOfRows(section) > 0 || (!obj.isLabTest && self.viewModel.numberOfRows(section) == 0) ? 50 : 0 //CGFloat.leastNonzeroMagnitude
    }
    
}
