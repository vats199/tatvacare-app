//
//  SearchDeviceVC.swift
//  MyTatva
//
//  Created by 2022M43 on 09/05/23.
//

import Foundation
import UIKit
import CoreBluetooth

class ConnectDeviceVC : UIViewController {
    
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var imgBg: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblBluetooth: UILabel!
    
    @IBOutlet weak var swicth: UISwitch!
    @IBOutlet weak var lblScalePress: UILabel!
    
    @IBOutlet weak var btnSearchDevice: UIButton!
    @IBOutlet weak var btnHowToConnect: UIButton!
    @IBOutlet weak var lblHowToConnect: UILabel!
    
    //MARK:- Class Variables
    
    var isiOSBluetoothOn = false {
        didSet{
            self.swicth.isOn = isiOSBluetoothOn
            self.btnSearchDevice.font(name: .medium, size: 20).textColor(color: .white).cornerRadius(cornerRadius: 5.0).backGroundColor(color: self.isiOSBluetoothOn ? .themePurple : .themePurple.withAlphaComponent(0.5)).isUserInteractionEnabled = self.isiOSBluetoothOn
            //            self.swicth.isUserInteractionEnabled = !isiOSBluetoothOn
        }
    }
    
    var isFromScreen = true
    
    var bCentralManger: CBCentralManager?
    // var peripheral: CBPeripheral?
    
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
        
        DispatchQueue.main.async {
            BleManager.shared.checkBTPermission()
        }
        
        self.lblTitle.font(name: .bold, size: 17)
            .textColor(color: UIColor.themeBlack)
            .text = "Connect Smart Scale Device"
        
        self.lblHowToConnect.font(name: .bold, size: 11)
            .textColor(color: UIColor.themePurple)
            .text = "Learn how to connect"
        
        self.lblBluetooth.font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack)
            .text = "Bluetooth"
        
        self.lblScalePress.font(name: .bold, size: 15)
            .textColor(color: UIColor.themeBlack)
            .text = "Step-up on Scale.\nPress ‘Search’ to discover it."
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 20)
        }
        
        self.swicth.isUserInteractionEnabled = true
        self.swicth.isOn = false
        self.swicth.addTarget(self, action: #selector(self.switchValueDidChange(_:)), for: .valueChanged)
        //        BleManager.shared.setupForBle()
        
        self.openPopUp()
        self.manageActionMethods()
        
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch!) {
        if !self.swicth.isOn{
            self.isiOSBluetoothOn = true
            Alert.shared.showAlert(message: AppMessages.canntTurnOfBluetooth, completion: nil)
        } else {
            BleManager.shared.checkBTPermission()
        }
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : [SomeoneElseDataModel]? = nil) {
        self.dismiss(animated: animated) { [weak self] in
            guard let self = self else { return }
        }
    }
    
    private func addAnalyticsEvent(isToggled:Bool = false) {
        var params = [String:Any]()
        params[AnalyticsParameters.medical_device.rawValue] = kBCA
        params[AnalyticsParameters.toggle.rawValue] = isToggled ? AppMessages.yes : AppMessages.no
        FIRAnalytics.FIRLogEvent(eventName: .USER_TOGGLES_BLUETOOTH,
                                 screen: .ConnectDevice,
                                 parameter: params)
    }
    
    //MARK:- Action Method
    
    private func setupViewModelObserver() {
        
        BleManager.shared.bleState.bind { [weak self] state in
            guard let self = self else { return }
            print("BT status:- ", state == .poweredOn)
            self.isiOSBluetoothOn = state == .poweredOn
            if !self.isFromScreen {
                self.addAnalyticsEvent(isToggled: self.isiOSBluetoothOn)
            }
        }
    }
    
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true)
        }
        
        self.btnCancel.addAction(for: .touchUpInside, action: { [weak self] in
            guard let self = self else { return }
            self.dismissPopUp(true)
        })
        
        self.btnSearchDevice.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: false) {
                let vc = SearchDeviceVC.instantiate(fromAppStoryboard: .home)
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        self.btnHowToConnect.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            
            var params = [String:Any]()
            params[AnalyticsParameters.medical_device.rawValue] = kBCA
            FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_LEARN_TO_CONNECT,
                                     screen: .ConnectDevice,
                                     parameter: params)
            
            let vc = HowToConnectVC.instantiate(fromAppStoryboard: .home)
            self.navigationController?.present(vc, animated: true)
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
        self.navigationController?.isNavigationBarHidden = true
        WebengageManager.shared.navigateScreenEvent(screen: .ConnectDevice)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            guard let self = self else { return }
            self.isFromScreen = false
        }        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//------------------------------------------------------
//MARK: - CBCenteralManagerDelegate
/*extension ConnectDeviceVC: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            isiOSBluetoothOn = true
            break
        case .poweredOff:
            isiOSBluetoothOn = false
            break
        default:
            break
        }
    }
}*/
