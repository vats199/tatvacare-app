//
//  SearchDeviceVC.swift
//  MyTatva
//
//  Created by 2022M43 on 10/05/23.
//

import Foundation
import UIKit

enum SearchScreens: String {
    case Searching
    case NotFound
    case DeviceList
}

class DeviceListCell : UITableViewCell {
    
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var imgDeviceIcon: UIImageView!
    @IBOutlet weak var lblDeviceName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblDeviceName.font(name: .regular, size: 15)
            .textColor(color: .themeBlack)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.borderColor(color: .ThemeDeviceGray, borderWidth: 1)
            self.vwBg.layer.cornerRadius = 12
            
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.ThemeDeviceShadow, shadowOpacity: 0.2)
        }
    }
}

class SearchDeviceVC : UIViewController {
   
    @IBOutlet weak var vwSearching: UIView!
    @IBOutlet weak var lblSearching: UILabel!
    
    @IBOutlet weak var vwNotFound: UIView!
    @IBOutlet weak var lblNotFound: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var btnSearchAgain: ThemePurpleButton!
    
    @IBOutlet weak var vwDeviceListed: UIView!
    @IBOutlet weak var tblDeviceList: UITableView!
    
    @IBOutlet weak var lblNavTittle: SemiBoldBlackTitle!
    
    //MARK:- Class Variables -
    var currentScreen = SearchScreens.Searching {
        didSet {
            switch self.currentScreen {
            case .Searching:
                self.vwSearching.isHidden = false
                self.vwNotFound.isHidden = true
                self.vwDeviceListed.isHidden = true
                self.startScaleScan()
                self.lblNavTittle.text = "Connect Smart Scale Device"
                break
            case .NotFound:
                self.vwSearching.isHidden = true
                self.vwNotFound.isHidden = false
                self.vwDeviceListed.isHidden = true
                self.lblNavTittle.text = "Connect Smart Scale Device"
                break
            case .DeviceList:
                self.vwSearching.isHidden = true
                self.vwNotFound.isHidden = true
                self.vwDeviceListed.isHidden = false
                self.lblNavTittle.text = "Select Smart Scale Device"
                break
            }
        }
    }
    
    var analyticsCount = 1
    var count: Int = 20
    var timer: Timer? = nil
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {
        BleManager.shared.checkBTPermission(true)
        self.currentScreen = SearchScreens.Searching
        self.tblDeviceList.delegate = self
        self.tblDeviceList.dataSource = self
        
        self.applyStyle()
        self.manageActionMethods()        
        self.addSearchEvent()
    }
    
    private func addSearchEvent() {
        var params = [String:Any]()
        params[AnalyticsParameters.attempt.rawValue] = self.analyticsCount
        self.addAnalyticsEvent(params: &params, eventName: .MEDICAL_DEVICE_SEARCH_ACTION)
        self.analyticsCount += 1
    }
    
    private func setupViewModelObserver() {
        BleManager.shared.bleAPIState.bind { [weak self] result in
            guard let self = self,let result = result else { return }
            if result.0 == .CONNECTED {
                self.currentScreen = .DeviceList
                self.timer?.invalidate()
                self.timer = nil
            }
        }
        
        /*BleManager.shared.bleState.bind { [weak self] in
            guard let self = self else { return }
        }*/
        
    }
    
    private func startScaleScan() -> Void {
        self.count = 20
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCountDown), userInfo: nil, repeats: true)
        BleManager.shared.connectToScaleSdk()
    }
    
    private func addAnalyticsEvent(params:inout [String:Any],eventName: FIREventType) {
        params[AnalyticsParameters.medical_device.rawValue] = kBCA
        FIRAnalytics.FIRLogEvent(eventName: eventName,
                                 screen: .SearchSelectSmartScale,
                                 parameter: params)
    }
    
    @objc func updateCountDown() {
        self.count -= 1
        if(self.count <= 0) {
            if(self.timer != nil){
                self.count = -1
                self.timer!.invalidate()
                self.timer = nil
            }
            self.currentScreen = SearchScreens.NotFound
            BleManager.shared.stopSDK()
        }
    }
    
    func applyStyle() {
        
        self.lblSearching.font(name: .regular, size: 15)
            .textColor(color: .ThemeDarkGray)
            .text = "Searching device..."
        
        self.lblNotFound.font(name: .medium, size: 15)
            .textColor(color: .themeBlack)
            .text = "Scale Not Found - Try again !"
        
        self.lblNote.font(name: .regular, size: 15)
            .textColor(color: .ThemeRedLetters)
            .text = "Note : Please stand on the device to Turn it ON before you “Search Scale”."
        
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.btnSearchAgain.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.currentScreen = .Searching
            self.addSearchEvent()
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                // some process
                if vc.isKind(of: HomeVC.self) {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BleManager.shared.isFromScan = true
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        WebengageManager.shared.navigateScreenEvent(screen: .SearchSelectSmartScale)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BleManager.shared.isFromScan = false
    }
    
    
    @IBAction func onGoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchDeviceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DeviceListCell = tableView.dequeueReusableCell(withClass: DeviceListCell.self, for: indexPath)
        cell.lblDeviceName.text = BleManager.shared.arryDeviceList[indexPath.row].deviceName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.currentScreen == .DeviceList {
            
            var params = [String:Any]()
            self.addAnalyticsEvent(params: &params, eventName: .USER_CLICKS_MEASURE)
            
            let vc = BcaDetailVC.instantiate(fromAppStoryboard: .bca)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
