//
//  MyDeviceVC.swift
//  MyTatva
//
//  Created by 2022M43 on 12/06/23.
//

import Foundation
import UIKit
class MyDeviceListCell: UITableViewCell {
    
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblLastSync: UILabel!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var vwLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblDeviceName.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack2).text = "Smart Analyser"
        
        self.lblLastSync.font(name: .light, size: 12)
            .textColor(color: UIColor.ThemeDarkGray)
        
        self.btnConnect.font(name: .medium, size: 11)
            .textColor(color: UIColor.themePurple)
            .setTitle("Connect", for: .normal)
        self.imgIcon.image = UIImage(named: "icon_BCA")
        self.btnConnect.contentHorizontalAlignment = .right
        
        self.vwLine.backGroundColor(color: .themeGray4.withAlphaComponent(0.3))
        //self.vwBG.cornerRadius(cornerRadius: 12.0).themeShadow()
    }
    
}

class MyDeviceVC: LightPurpleNavigationBase {
    
    //MARK: - Outlets -
    @IBOutlet weak var lblNavTitle: SemiBoldBlackTitle!
    
    //----------------- Summary -------------------
    @IBOutlet weak var vwSummary: UIView!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbladdress: UILabel!
    @IBOutlet weak var imgAddress: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var imgMobile: UIImageView!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    //----------------- Device Details -------------------
    @IBOutlet weak var vwDeviceDetails: UIView!
    @IBOutlet weak var vwDeviceMain: UIView!
    @IBOutlet weak var lblDeviceDetails: UILabel!
    @IBOutlet weak var tblDeviceList: UITableView!
    @IBOutlet weak var tblDeviceHeightConst: NSLayoutConstraint!
    
    //----------------- What Next -------------------
    @IBOutlet weak var vwWhatNext: UIView!
    @IBOutlet weak var lblWhatNext: UILabel!
    @IBOutlet weak var lblWhatNextDesc: UILabel!
    
    //----------------- Help -------------------
    @IBOutlet weak var vwHelp: UIView!
    @IBOutlet weak var lblHelp: UILabel!
    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet weak var btnHelp: UIButton!
    
    //------------------------------------------------------
    //MARK: - Class Variables -
    let viewModel = MyDeviceVM()
    
    //------------------------------------------------------
    //MARK: - UIView Life Cycle Methods -
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        WebengageManager.shared.navigateScreenEvent(screen: .BcpDeviceDetails)
        self.viewModel.my_devices(patient_plan_rel_id: self.viewModel.pateintPlanRefId, withLoader: true) { isDone in
            if isDone {
                self.setData()
            }
        }
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
        self.manageActionMethods()
        self.addObserverOnHeightTbl()
        
        self.tblDeviceList.delegate = self
        self.tblDeviceList.dataSource = self
    }
    
    func applyStyle() {
        
        self.lblNavTitle.text = "Devices"
        
        self.lblSummary.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Summary"
        self.lblDeviceDetails.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "Device Details"
        self.lblWhatNext.font(name: .bold, size: 16).textColor(color: .themeBlack2).text = "What's Next?"
        
        self.lblName.font(name: .bold, size: 14).textColor(color: .themeBlack2).text = "Name"
        
        self.lbladdress.font(name: .regular, size: 14).textColor(color: .ThemeDarkGray).text = "Address"
        self.lblEmail.font(name: .regular, size: 14).textColor(color: .ThemeDarkGray).text = "abc@email.com"
        self.lblMobile.font(name: .regular, size: 14).textColor(color: .ThemeDarkGray).text = "+91-9990000000"
        
        self.imgAddress.image = UIImage(named: "grayAddress_ic")
        self.imgEmail.image = UIImage(named: "grayMail_ic")
        self.imgMobile.image = UIImage(named: "CallGray_ic")
        
        self.lblOrderID
            .font(name: .regular, size: 14).textColor(color: .themeBlack2)
            .text = "Order ID : "
        
        self.lblStatus
            .font(name: .regular, size: 14).textColor(color: .themeBlack2)
            .text = "Status :  "
        
        self.lblWhatNextDesc
            .font(name: .regular, size: 12).textColor(color: .ThemeDarkGray)
            .text = "1. Once you receive the device(s), connect it with MyTatva.\n2. Use it regularly to measure your health."
        self.lblWhatNextDesc.addLineSpacing(4)
        
        self.lblHelp.font(name: .regular, size: 12).textColor(color: .ThemeBlack21).text = "Need Help with something?"
        self.lblContactUs.font(name: .bold, size: 12).textColor(color: .themePurple).text = "Contact Us"
        
        self.tblDeviceList.cornerRadius(cornerRadius: 12.0)
        self.vwDeviceDetails.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        
        self.vwSummary.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.vwWhatNext.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        self.vwHelp.cornerRadius(cornerRadius: 12.0).themeShadowBCP()
        
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.vwHelp.borderColor(color: .ThemeBorder, borderWidth: 1).setRound()
//        }
        
      //  self.setAttributedLabels()
    }
    
    func setAttributedLabels() {
        self.lblOrderID.setAttributesForOrders(str: "")
        self.lblStatus.setAttributesForOrders(str: "")
    }
    
    //MARK: - Button Action Methods -
    func manageActionMethods() {
        
        self.btnHelp.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            GFunction.shared.openContactUs()
            
            FIRAnalytics.FIRLogEvent(eventName: .TAP_CONTACT_US,
                                     screen: .BcpDeviceDetails,
                                     parameter: nil)
        }
    }
}

//MARK: UITableViewDelegate and UITableViewDataSource
extension MyDeviceVC : UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MyDeviceListCell.self)
        let data = self.viewModel.getDeviceData(indexPath.row)
        let isSpirometer = (data?.key ?? "") == BTDeviceType.spirometer.rawValue
        cell.lblDeviceName.text = data?.title
        
        cell.imgIcon.image = UIImage(named: data?.icon ?? "")
        cell.imgIcon.alpha = isSpirometer ? 0.5 : 1
        
        cell.lblLastSync.text = isSpirometer ? AppMessages.connectToSpirometer : (data?.lastSyncDate ?? "").trim().isEmpty ? AppMessages.deviceConnectionRequired : "Last synced on " + GFunction.shared.convertDateFormat(dt: data?.lastSyncDate ?? "", inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue, outputFormat: DateTimeFormaterEnum.ddMMMYYYYhhmma.rawValue, status: .NOCONVERSION).str
        cell.lblLastSync.numberOfLines = 0
        
        cell.lblLastSync.textColor(color: isSpirometer ? UIColor.themeDisable : UIColor.ThemeDarkGray)
        cell.lblDeviceName.textColor(color: isSpirometer ? UIColor.themeDisable : UIColor.themeBlack)
        
        cell.btnConnect.isHidden = isSpirometer
        
        cell.vwLine.isHidden = indexPath.row == (self.viewModel.getNumOfRows() - 1)
        
        cell.btnConnect.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            
            if isSpirometer {
                Alert.shared.showAlert(message: AppMessages.connectToSpirometer) { Bool in
                }
                return
            }
            
            self.viewModel.showDeviceConnectPopUp()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = self.viewModel.getDeviceData(indexPath.row)
        let isSpiro = data?.key == BTDeviceType.spirometer.rawValue
        
        var params = [String:Any]()
        params[AnalyticsParameters.sync_status.rawValue] = (data?.lastSyncDate ?? "").trim().isEmpty ? "N" : "Y"
        params[AnalyticsParameters.medical_device.rawValue] = isSpiro ? BTDeviceType.spirometer.rawValue.capitalized : BTDeviceType.bca.rawValue.uppercased()
        FIRAnalytics.FIRLogEvent(eventName: .TAP_DEVICE_CARD,
                                 screen: .BcpDeviceDetails,
                                 parameter: params)

        guard !isSpiro else { return }
        
        guard let device = self.viewModel.getDeviceData(indexPath.row) else { return }
        
        guard !(device.lastSyncDate.trim().isEmpty) else {
            self.viewModel.showDeviceConnectPopUp()
            return
        }
        let vc = BcaDetailVC.instantiate(fromAppStoryboard: .bca)
        vc.isFromHome = true
        vc.isBackToHome = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: -------------------------- Observers Methods --------------------------
extension MyDeviceVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblDeviceList, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            DispatchQueue.main.async {
                self.tblDeviceHeightConst.constant = newvalue.height
                self.tblDeviceList.isScrollEnabled = false
            }
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblDeviceList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblDeviceList else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------- set data func --------------------
extension MyDeviceVC {
    
    func setData() {
        let data = self.viewModel.deviceData
        if data?.addressData != nil {
            self.lbladdress.text = "\(data?.addressData.address ?? "")\n\(data?.addressData.street ?? "")\n\(data?.addressData.pincode ?? 0)"
            self.lbladdress.superview?.isHidden = false
        } else {
            self.lbladdress.superview?.isHidden = true
        }
        self.vwDeviceMain.isHidden = data?.devices.count == 0 ? true : false
        self.lblName.text = UserModel.shared.name
        self.lblEmail.text = UserModel.shared.email
        self.lblMobile.text = UserModel.shared.countryCode + " " + UserModel.shared.contactNo
        self.lblOrderID.text = "Order ID : " + (data?.transactionId ?? "")
        self.lblStatus.text = "Status :  " + (data?.status ?? "")
        self.lblOrderID.setAttributesForOrders(str: data?.transactionId ?? "")
        self.lblStatus.setAttributesForOrders(str: data?.status ?? "")
        
        self.tblDeviceList.reloadData()
    }
}
