//
//  BCASelectAddressListVC.swift
//  MyTatva
//
//  Created by Hyperlink on 29/05/23.
//  Copyright © 2023. All rights reserved.

import UIKit

class BCASelectAddressListVC: UIViewController {

    //MARK: Outlet
    @IBOutlet weak var vwTop                : UIView!
    @IBOutlet weak var imgBG                : UIImageView!
    @IBOutlet weak var vwBG                 : UIView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var btnNew               : UIButton!
    
    @IBOutlet weak var vwNoAvailabelAddress : UIView!
    @IBOutlet weak var lblNoAvailabel       : UILabel!
    @IBOutlet weak var btnAddAddress        : ThemePurple16Corner!
    @IBOutlet weak var tblAddresses         : UITableView!
    @IBOutlet weak var tblHeightConstant    : NSLayoutConstraint!
    @IBOutlet weak var vwSave               : UIView!
    @IBOutlet weak var btnSave              : ThemePurple16Corner!
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel   = BCASelectAddressListVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String        = ""
    var completionHandler: ((_ obj : DoseListModel?) -> Void)?
    var selectAddressData: LabAddressListModel?
    var arrDaysOffline : [JSON] = []
    var isDataRefresh = false
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(BCASelectAddressListVC.self) ‼️‼️‼️")
        self.removeObserverOnHeightTbl()
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.addObserverOnHeightTbl()
        self.applyStyle()
        self.setData()
    }
    
    private func applyStyle() {
        
        self.lblTitle
            .font(name: .bold, size: 20.0).textColor(color: .themeBlack.withAlphaComponent(1))
        self.lblNoAvailabel
            .font(name: .regular, size: 14.0).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "No address present.\nPlease add an address to continue."
        
        self.btnNew
            .font(name: .medium, size: 14.0).textColor(color: .themePurple)
        self.btnSave
            .font(name: .bold, size: 16.0).backGroundColor(color: .themePurple).textColor(color: .white)
        self.btnAddAddress
            .font(name: .bold, size: 16.0).backGroundColor(color: .themePurple).textColor(color: .white)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwBG.layoutIfNeeded()
            self.vwBG.roundCorners([.topLeft, .topRight], radius: 20)
            self.vwTop.setRound()
            self.btnSave.superview!.shadow(color: .themeGray, shadowOffset: .zero, shadowOpacity: 0.2)
        }
    
        self.openPopUp()
        self.setup(tblView: self.tblAddresses)
        self.manageActionMethods()
    }
    
    func setup(tblView: UITableView) {
        
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
//        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
    }
    

    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBG.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : DoseListModel? = nil) {
        
        func sendData() {
            if let obj = objAtIndex {
                if let completionHandler = completionHandler {
                    completionHandler(obj)
                }
            }
        }
        
        self.dismiss(animated: animated) {
            sendData()
        }
    }
    
    func pushAddAddress() {
        let vc = BCAAddAddressVC.instantiate(fromAppStoryboard: .bca)
        vc.completion = { [weak self] newAddress in
            guard let self = self else { return }
            self.selectAddressData = newAddress
            self.isDataRefresh = true
//            self.viewModel.getAddressList()
            
//            self.dismiss(animated: true) {
                self.pushToBCPPurchase()
//            }
            
        }
        let navController = UINavigationController(rootViewController: vc) //Add navigation controller
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    private func pushToBCPPurchase() {
        
        self.dismiss(animated: true) {
            let vc = BCPPlanDetailsVC.instantiate(fromAppStoryboard: .BCP_temp)
            vc.cpDetails = self.viewModel.cpDetails
            vc.toView = .SelectAddress
            vc.selectAddData = self.selectAddressData
    //        self.navigationController?.pushViewController(vc, animated: true)
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
        fileprivate func manageActionMethods(){
            
            self.imgBG.addTapGestureRecognizer {[weak self] in
                guard let self = self else { return }
                self.dismissPopUp(true, objAtIndex: nil)
            }
            
            self.btnNew.addAction(for: .touchUpInside) {[weak self] in
                guard let self = self else { return }
                self.pushAddAddress()
                var params              = [String : Any]()
                params[AnalyticsParameters.bottom_sheet_name.rawValue]            = "select address"
//                params[AnalyticsParameters.address_number.rawValue]               = "0"
                                        
                FIRAnalytics.FIRLogEvent(eventName: .TAP_ADD_NEW,
                                         screen: .SelectAddressBottomSheet,
                                         parameter: params)
            }
            
            self.btnAddAddress.addAction(for: .touchUpInside) { [weak self] in
                guard let self = self else { return }
                self.pushAddAddress()
                
                var params              = [String : Any]()
                params[AnalyticsParameters.bottom_sheet_name.rawValue]            = "select address"
//                params[AnalyticsParameters.address_number.rawValue]               = "0"
                
                FIRAnalytics.FIRLogEvent(eventName: .ADD_ADDRESS,
                                         screen: .SelectAddressBottomSheet,
                                         parameter: params)
                
            }
            
            self.btnSave.addAction(for: .touchUpInside) { [weak self] in
                guard let self = self else { return }
                
                if let obj = self.viewModel.getSelectedObject() {
                    /*var params1 = [String: Any]()
                    params1[AnalyticsParameters.address_id.rawValue]  = obj.patientAddressRelId
                    FIRAnalytics.FIRLogEvent(eventName: .LABTEST_ADDRESS_SELECTED,
                                             screen: .SelectAddress,
                                             parameter: params1)*/
                    
                    var params              = [String : Any]()
                    params[AnalyticsParameters.address_number.rawValue]               = "\(self.viewModel.getSelectedInt())"
                    params[AnalyticsParameters.address_type.rawValue]                 = self.viewModel.getSelectedObject()?.addressType ?? ""
                    FIRAnalytics.FIRLogEvent(eventName: .TAP_SAVE_AND_NEXT,
                                             screen: .SelectAddressBottomSheet,
                                             parameter: params)
                    
                    self.pushToBCPPurchase()
                    
                }
                else {
                    Alert.shared.showSnackBar(AppError.validation(type: .selectAddress).errorDescription ?? "")
                }
       
            }
        }
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = BCASelectAddressListVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if self.isDataRefresh {
            self.isDataRefresh = false
            self.tblAddresses.isHidden = true
            self.tblHeightConstant.constant = 0
            self.viewModel.getAddressList()
        }
        WebengageManager.shared.navigateScreenEvent(screen: .SelectAddressBottomSheet)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

}

extension BCASelectAddressListVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblAddresses, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            if newvalue.height >= ScreenSize.height - 200 {
                self.tblHeightConstant.constant = ScreenSize.height - 200// (ScreenSize.height / 2)
            } else {
                self.tblHeightConstant.constant = newvalue.height
            }
                
        }
        /*UIView.animate(withDuration: kAnimationSpeed) { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        }*/
    }
    
    func addObserverOnHeightTbl() {
        self.tblAddresses.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblAddresses else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension BCASelectAddressListVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : BCAAddressListCell = tableView.dequeueReusableCell(withClass: BCAAddressListCell.self, for: indexPath)

        let object = self.viewModel.getObject(index: indexPath.row)
        
        cell.btnRadio.isHidden     = false
        cell.lblTitle.text = "\(object.address ?? ""), \(object.street ?? "") - \(object.pincode ?? 0)"
        
        cell.btnRadio.isSelected = object.isSelected
        
        if object.isSelected {
            self.selectAddressData = object
        }
        

        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.manageSelection(index: indexPath.row)
        self.tblAddresses.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
    
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension BCASelectAddressListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 14.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------- set data methods --------------------
extension BCASelectAddressListVC {
    
    func setData(){
        if self.viewModel.getCount() == 0 {
            self.vwNoAvailabelAddress.isHidden = false
            self.vwSave.isHidden = true
            self.btnNew.isHidden = true
            self.tblAddresses.isHidden = true
        } else  {
            self.vwNoAvailabelAddress.isHidden = true
            self.vwSave.isHidden = false
            self.btnNew.isHidden = false
            self.tblAddresses.isHidden = false
        }
    }
    
}


//MARK: -------------------- setupViewModel Observer --------------------
extension BCASelectAddressListVC {
    
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
        
        self.viewModel.isListChanged.bind { [weak self] isDone in
            guard let self = self,(isDone ?? false) else { return }
            self.tblAddresses.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self = self else { return }
                self.setData()
                self.vwBG.layoutSubviews()
                self.vwBG.layoutIfNeeded()
            }
            
        }
        
    }
}
