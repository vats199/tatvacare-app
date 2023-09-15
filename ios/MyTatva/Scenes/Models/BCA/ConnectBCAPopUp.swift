//
//  ConnectBCAPopUp.swift
//  MyTatva
//
//  Created by Hlink on 28/07/23.
//

import UIKit

class ConnectBCAPopUp: UIViewController {

    //MARK: Outlet
    
    @IBOutlet weak var imgBG: UIImageView!
    
    @IBOutlet weak var vwBG: UIImageView!
    @IBOutlet weak var vwTop: UIImageView!
    
    @IBOutlet weak var imgDevice: UIImageView!
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var vwButtons: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConnect: ThemePurple16Corner!
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    var details: DeviceDetailsModel?
    var isFromHome = false
    var completion:((Bool) -> ())?
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBG.alpha = kPopupAlpha
        }
    }
    
    private func setUpView() {
        self.applyStyle()
    }
    
    private func applyStyle() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.btnCancel.cornerRadius(cornerRadius: 16.0).borderColor(color: .themePurple, borderWidth: 1.0).backGroundColor(color: .white).font(name: .bold, size: 16.0).textColor(color: .themePurple)
            self.imgDevice.setRound().image = UIImage(named: "icon_SmartAnalyser")
            self.btnCancel.setTitle(self.isFromHome ? "No, Purchase" : "Close", for: UIControl.State())
            self.btnConnect.setTitle(self.isFromHome ? "Yes, Connect" : "Connect", for: UIControl.State())
            self.vwButtons.shadow(color: .themeGray, shadowOffset: .zero, shadowOpacity: 0.5)
            self.vwTop.cornerRadius(cornerRadius: 2.0).backGroundColor(color: .themeLightGray)
            self.vwBG.roundCorners([.topLeft,.topRight], radius: 16.0)
            self.imgBG.alpha = kPopupAlpha
            self.view.layoutIfNeeded()
        }
        
        self.lblDeviceName.textColor(color: .themeBlack).font(name: .bold, size: 16).text = self.details?.title ?? "Smart Analyser"
        self.lblDesc.textColor(color: .themeGray5).font(name: .regular, size: 12).text = "The Smart Analyzer helps you safeguard your health with precision. By monitoring your body's vital data, you can take charge of your well-being, and make informed decisions.\n\nDo you have the device to monitor your overall vitals?"
        self.lblDesc.numberOfLines = 0
        
        self.openPopUp()
        
    }
    
    private func setupViewModelObserver() {
        
    }
    
    private func manageActions() {
        
        self.imgBG.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        self.btnConnect.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: false) { [weak self] in
                guard let self = self else { return }
                
                self.addEventInAnalytics(hasDevice: true)
                let vc = ConnectDeviceVC.instantiate(fromAppStoryboard: .home)
                let navi = UINavigationController(rootViewController: vc)
                navi.modalPresentationStyle = .overFullScreen
                navi.modalTransitionStyle = .crossDissolve
                UIApplication.topViewController()?.present(navi, animated: true)
            }
        }
        
        self.btnCancel.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.addEventInAnalytics(hasDevice: false)
            self.completion?(true)
        }
        
    }
    
    private func addEventInAnalytics(hasDevice:Bool) {
        var params = [String:Any]()
        params[AnalyticsParameters.medical_device.rawValue] = kBCA
        params[AnalyticsParameters.Device_availability.rawValue] = hasDevice ? AppMessages.yes : AppMessages.no
        FIRAnalytics.FIRLogEvent(eventName: .MEDICAL_DEVICE_AVAILABILITY,
                                 screen: self.isFromHome ? .DoYouHaveDevice : .ConnectDeviceInfo,
                                 parameter: params)
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
        self.manageActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        WebengageManager.shared.navigateScreenEvent(screen: self.isFromHome ? .DoYouHaveDevice : .ConnectDeviceInfo)
    }

}
