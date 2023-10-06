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
    var cartListModel               = CartListModel()
    var isFromBCP = false
    var isEditTapped = false
    var addressData : LabAddressListModel!
    
    var arrSelectionType: [JSON] = [
        [
            "name": "Edit",
            "type": ActionType.edit.rawValue,
            "image" : "home_address",
        ],
        [
            "name": "Delete",
            "type": ActionType.delete.rawValue,
            "image" : "work_address",
        ],
        
    ]
    
    var addressActionType: ActionType = .edit
    
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
        
        self.tblAddresses.register(UINib(nibName: "BCANewAddressListCell", bundle: nil), forCellReuseIdentifier: "BCANewAddressListCell")
        
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
        //        let vc = BCAAddAddressVC.instantiate(fromAppStoryboard: .bca)
        //        vc.completion = { [weak self] newAddress in
        //            guard let self = self else { return }
        //            self.selectAddressData = newAddress
        //            self.isDataRefresh = true
        ////            self.viewModel.getAddressList()
        //
        ////            self.dismiss(animated: true) {
        //                self.pushToBCPPurchase()
        ////            }
        //
        //        }
        //        let navController = UINavigationController(rootViewController: vc) //Add navigation controller
        //        navController.modalPresentationStyle = .fullScreen
        //        self.present(navController, animated: true, completion: nil)
        if LocationManager.shared.checkStatus() == .authorizedAlways || LocationManager.shared.checkStatus() == .authorizedWhenInUse {
            self.pushGeoLocation()
        } else {
            let vc = LocationPermissionPopUpVC.instantiate(fromAppStoryboard: .BCP_temp)
            vc.selectManuallyCompletion = { [weak self] _ in
                guard let self = self else { return }
                let vc = EnterLocationPopupVC.instantiate(fromAppStoryboard: .BCP_temp)
                vc.isFromEdit = self.isEditTapped
                vc.addressData = self.addressData
                vc.completion = { [weak self] newAddress in
                    guard let self = self else { return }
                    self.selectAddressData = newAddress
                    self.isDataRefresh = true
                    if self.isEditTapped {
                        self.getAddresssList()
                    }else if self.isFromBCP {
                        self.pushToBCPPurchase()
                    } else {
                        self.pushToTimeSlot()
                    }
                }
                UIApplication.topViewController()?.present(vc, animated: true)
            }
            vc.selectGrantCompletion = { [weak self] _ in
                guard let self = self else { return }
                
                if (UIApplication.topViewController()?.isKind(of: LocationPermissionPopUpVC.self) ?? false) {
                    UIApplication.topViewController()?.dismiss(animated: true, completion: { [weak self] in
                        guard let self = self else { return }
                        self.pushGeoLocation()
                    })
                    return
                }
                
                self.pushGeoLocation()
            }
            
            let navi = UINavigationController(rootViewController: vc)
            navi.modalPresentationStyle = .overFullScreen
            navi.modalTransitionStyle = .crossDissolve
            UIApplication.topViewController()?.present(navi, animated: true)
        }
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
    
    private func pushToTimeSlot() {
        self.dismiss(animated: true) {
            let vc = SelectTestTimeSlotVC.instantiate(fromAppStoryboard: .bca)
            vc.cartListModel = self.cartListModel
            vc.labAddressListModel = self.selectAddressData ?? LabAddressListModel()
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func pushGeoLocation() {
        let vc = GeoLocationVC.instantiate(fromAppStoryboard: .BCP_temp)
        vc.isFromEdit = self.isEditTapped
        vc.addressData = self.addressData
        vc.completion = { [weak self] newAddress in
            guard let self = self else { return }
            self.selectAddressData = newAddress
            self.isDataRefresh = true
            if self.isEditTapped {
                self.getAddresssList()
            }else if self.isFromBCP {
                self.pushToBCPPurchase()
            } else {
                self.pushToTimeSlot()
            }
        }
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getAddresssList() {
        if self.isDataRefresh {
            self.isDataRefresh = false
            self.tblAddresses.isHidden = !self.isEditTapped
            self.tblHeightConstant.constant = self.isEditTapped ? self.tblHeightConstant.constant : 0
            self.viewModel.getAddressList()
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
                self.isEditTapped = false
                self.pushAddAddress()
                var params              = [String : Any]()
                params[AnalyticsParameters.bottom_sheet_name.rawValue]            = BottomScreenName.select_address.rawValue
//                params[AnalyticsParameters.address_number.rawValue]               = "0"
                                        
                FIRAnalytics.FIRLogEvent(eventName: .TAP_ADD_NEW,
                                         screen: .SelectAddressBottomSheet,
                                         parameter: params)
                isShowAddressList = true
            }
            
            self.btnAddAddress.addAction(for: .touchUpInside) { [weak self] in
                guard let self = self else { return }
                self.isEditTapped = false
                self.pushAddAddress()
                
                var params              = [String : Any]()
                params[AnalyticsParameters.bottom_sheet_name.rawValue]            = BottomScreenName.select_address.rawValue
//                params[AnalyticsParameters.address_number.rawValue]               = "0"
                
                FIRAnalytics.FIRLogEvent(eventName: .ADD_ADDRESS,
                                         screen: .SelectAddressBottomSheet,
                                         parameter: params)
                
                isShowAddressList = true
                
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
                    
                    if self.isFromBCP {
                        self.pushToBCPPurchase()
                    } else {
                        self.pushToTimeSlot()
                    }
                    
                    isShowAddressList = true
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
        self.navigationController?.clearNavigation()
        self.navigationController?.isNavigationBarHidden = true
        self.getAddresssList()
        WebengageManager.shared.navigateScreenEvent(screen: .SelectAddressBottomSheet)
        self.isEditTapped = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

}

extension BCASelectAddressListVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblAddresses, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
//            if newvalue.height >= ScreenSize.height - 200 {
//                self.tblHeightConstant.constant = ScreenSize.height - 200// (ScreenSize.height / 2)
//            } else {
//                self.tblHeightConstant.constant = newvalue.height
//            }
            
            let halfHeight = (ScreenSize.height/2) + 150
            self.tblHeightConstant.constant = newvalue.height > halfHeight ? halfHeight : newvalue.height
            self.tblAddresses.isScrollEnabled = newvalue.height > halfHeight
            
            self.vwBG.layoutSubviews()
            self.vwBG.layoutIfNeeded()
                
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
        
        let cell : BCANewAddressListCell = tableView.dequeueReusableCell(withClass: BCANewAddressListCell.self, for: indexPath)

        let object = self.viewModel.getObject(index: indexPath.row)
        
        //cell.btnRadio.isHidden     = false
        cell.lblAddress.text = "\(object.address ?? ""), \(object.street ?? "") - \(object.pincode ?? 0)"
        cell.lblTitle.text = object.addressType == "Work" ? "Office" : object.addressType
        cell.imgIcon.image = UIImage(named: object.addressType == AddressType1.Home.rawValue ? "homeGray_ic" : "personGray_ic")
    //    cell.btnRadio.isSelected = indexPath.row == selectedAddressIndex //object.isSelected
        
        if object.isSelected {
            self.selectAddressData = object
        }
        
        cell.btnMore.isHidden = object.isBCPAddrees
        cell.vwBtn.isHidden = !object.isShowEdit
        
        cell.btnMore.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            
            /*let dropDown = DropDown()
            DropDown.appearance().textColor                 = UIColor.themeBlack
            DropDown.appearance().selectedTextColor         = UIColor.themeBlack
            DropDown.appearance().textFont                  = UIFont.customFont(ofType: .medium, withSize: 14)
            DropDown.appearance().backgroundColor           = UIColor.white
            DropDown.appearance().selectionBackgroundColor  = UIColor.white
            DropDown.appearance().cellHeight                = 60
            dropDown.anchorView                             = cell.btnMore
            
            let arr: [String] = self.arrSelectionType.map { (obj) -> String in
                return obj["name"].stringValue
            }
            
            dropDown.dataSource = arr
            dropDown.selectionAction = { (index, str) in
                dropDown.hide()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0){
                    let type = ActionType.init(rawValue: self.arrSelectionType[index]["type"].stringValue) ?? .edit
                    
                }
            }
            dropDown.show()*/
//            self.viewModel.manageSelection(index: indexPath.row)
            self.viewModel.updateEditView(index: indexPath.row,isNewEditClick: true)
            self.tblAddresses.reloadData()
            
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                guard let self = self else { return }
                self.tblAddresses.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }*/
            
        }
        
        cell.btnEdit.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.isEditTapped = true
            self.addressData = object
            isShowAddressList = true
            self.pushAddAddress()
            self.viewModel.updateEditView(index: indexPath.row)
            self.tblAddresses.reloadData()
        }
        
        cell.btnDelete.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.viewModel.updateEditView(index: indexPath.row)
            self.tblAddresses.reloadData()
            Alert.shared.showAlert("", actionOkTitle: AppMessages.yes, actionCancelTitle: AppMessages.no, message: AppMessages.deleteMessage) { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    self.viewModel.delete_addressAPI(address_id: object.patientAddressRelId) { [weak self] isDone in
                        guard let self = self else {return}
                        if isDone {
                            self.viewModel.arrList.remove(at: indexPath.row)
                            self.tblAddresses.reloadData()
                            
                            var params1 = [String: Any]()
                            params1[AnalyticsParameters.address_id.rawValue]  = object.patientAddressRelId
                            FIRAnalytics.FIRLogEvent(eventName: .LABTEST_ADDRESS_DELETED,
                                                     screen: .SelectAddress,
                                                     parameter: params1)
                        }
                    }
                }
            }
        }
        
        cell.vwBg.addTapGestureRecognizer { [weak self] in
            guard let self = self, !object.isShowEdit else { return }
            selectedAddressIndex = indexPath.row
            self.selectAddressData = object
//            self.viewModel.updateEditView(index: indexPath.row)
//            self.tblAddresses.reloadData()
            if self.isFromBCP {
                var params              = [String : Any]()
                params[AnalyticsParameters.address_number.rawValue]               = "\(self.viewModel.getSelectedInt())"
                params[AnalyticsParameters.address_type.rawValue]                 = self.viewModel.getSelectedObject()?.addressType ?? ""
                FIRAnalytics.FIRLogEvent(eventName: .SELECT_ADDRESS,
                                         screen: .SelectAddressBottomSheet,
                                         parameter: params)
            }else {
                var params1 = [String: Any]()
                params1[AnalyticsParameters.address_id.rawValue]  = self.viewModel.getObject(index: indexPath.row).patientAddressRelId
                FIRAnalytics.FIRLogEvent(eventName: .LABTEST_ADDRESS_SELECTED,
                                         screen: .SelectAddressBottomSheet,
                                         parameter: params1)
            }
            
            if self.isFromBCP {
                self.pushToBCPPurchase()
            } else {
                self.pushToTimeSlot()
            }
            isShowAddressList = true
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedAddressIndex = indexPath.row
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
            self.vwSave.isHidden = true
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
