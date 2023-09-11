//
//  BleManager.swift
//  Elo
//
//  Created by Bhavin on 10/01/23.
//

import UIKit
@_exported import CoreBluetooth
@_exported import Combine
import SwiftUI

class DeviceList {
    
    var deviceName: String
    
    init(deviceName: String) {
        self.deviceName = deviceName
    }
}

enum BleApiStatus: String {
    case GET_UNSTEADY_WEIGHT = "Syncing Data... Do not step down!"
    case DETECTING = "Searching for the device"
    case CONNECTING = "Connecting to the device"
    case CONNECTION_FAILED = "The device has been disconnected. Please reconnect the device and try again."
    case CONNECTED = "Syncing data. Do not step down"
    case DATA_RECEIVED = "Data fetched"
    case DISCONNECTING = "Device disconnecting"
    case DISCONNECTED = "Device disconnected"
    case WRONG_SCALE_DETECTED = "Wrong scale detected"
}

class BleManager: NSObject {
    
    //MARK: Outlet
    
    //ble related data
    var centralManager: CBCentralManager!
    var ringPheripheral: CBPeripheral!
    var myCharacteristic : [CBCharacteristic] = []
    var bleState: Bindable<CBManagerState> = Bindable()
    var connected : Bindable<Bool> = Bindable()
    var softConnect: Bindable<Bool> = Bindable()
    var bleAPIState: Bindable<(BleApiStatus,String?)> = Bindable()
    let lsBleApi = LSBleApi.shared()
    var device: QNBleDevice? = nil
    var isFromSearching = true
    var arryDeviceList = [DeviceList]()
    var totalChunks: Int = 0
    var lastCount: Bindable<Int> = Bindable()
    var chunks:[Data] = []
    var isDownloadingComplete: Bindable<Bool> = Bindable()
    var updateStartTime = 0
    var isDataRecived = false
    var isFromMeasured = false
    var isShowPopup = true
    var isFromScan = false

    static let shared: BleManager = BleManager()
    
    //MARK: Custom Methods
    func setupForBle() {
        //Allocate CBCentralManager
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func stopScan() {
        self.centralManager?.stopScan()
    }
    
    func setPairingScreen() {
        UIApplication.shared.manageLogin()
    }
    
    func disconnectConnection() {
        if ringPheripheral != nil {
            self.centralManager.cancelPeripheralConnection(self.ringPheripheral)
            self.ringPheripheral = nil
            self.myCharacteristic.removeAll()
        }
    }
    
    func scanDevices() {
        self.centralManager.scanForPeripherals(withServices: nil)
    }
    
    func checkBTPermission(_ isShowPopup:Bool = false) {
        self.isShowPopup = isShowPopup
        self.bleState.value = .unknown
        if #available(iOS 13.0, *) {
            if (CBCentralManager.authorization == .allowedAlways) && !isFromScan {
                self.setupForBle()
            }else {
                self.openAppOrSystemSettingsAlert(title: "Bluetooth permission is currently disabled for the application. Enable Bluetooth from the application settings.", message: "")
            }
        } else {
            let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String
            self.openAppOrSystemSettingsAlert(title: "\"\(appName ?? "MyTatva")\" would like to use Bluetooth for measure data", message: "")
        }
    }
    
    func openAppOrSystemSettingsAlert(title: String, message: String) {
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) -> Void in
            if self.isFromScan {
                self.centralManager.delegate = nil
                UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: true)
            }
        }
        alertController.addAction(cancelAction)
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: CBCentralManagerDelegate
extension BleManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        self.bleState.value = central.state
        
        // For logs only
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
            self.setPairingScreen()
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
            
            if isShowPopup {
                Alert.shared.showAlert(Bundle.appName(), actionOkTitle: "Turn On", actionCancelTitle: "Cancel", message: "Your device's bluetooth is off.\nPlease turn it on to continue.") { isDone in
                    if isDone {
                        
                        guard let settingsUrl = URL(string: "App-prefs:Bluetooth") else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                                if self.isFromScan {
                                    self.centralManager.delegate = nil
                                    UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: true)
                                }
                                
                            })
                        }
                        
                        /*if self.isFromScan {
                            let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String
                            self.openAppOrSystemSettingsAlert(title: "\"\(appName ?? "MyTatva")\" would like to use Bluetooth for measure data", message: "")
                        } else {
                            self.checkBTPermission(false)
                        }*/
                    }else {
                        if self.isFromScan {
                            self.centralManager.delegate = nil
                            UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
            }
                                    
        case .poweredOn:
            print("central.state is .poweredOn")
        default:
            print("Default called")
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        print(peripheral.name ?? "-","\n")
        /// Get device based on name prefix
        let possibleNames = ["HOT ROCK", "Elo", "ELO PRO"].map{ $0.lowercased() }
        guard let name = peripheral.name, possibleNames.contains(name.lowercased()) else {
            return
        }
        
//        print(name, advertisementData)
        
        /// stop scan after retriving the hardware
        centralManager.stopScan()
        ringPheripheral = peripheral
        ringPheripheral.delegate = self
        self.centralManager.connect(ringPheripheral, options: [CBConnectPeripheralOptionNotifyOnConnectionKey:true, CBConnectPeripheralOptionNotifyOnDisconnectionKey: true])
         
    }
    

}

//MARK: CBPeripheralDelegate
extension BleManager: CBPeripheralDelegate {
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected", peripheral.name as Any)
        ringPheripheral.discoverServices([])
        self.softConnect.value = true
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        debugPrint("did failed to connect",error?.localizedDescription as Any)
        
        let deviceName = peripheral.name ?? "BCA"
        
        //"It seems like you need to forget the \(deviceName) device from your Bluetooth setting and here are steps to perform to reconnect with the \(deviceName).\nFind the device \(deviceName) in the list of 'MY DEVICES' -> Tap on ⓘ -> Tap on 'Forgot This Device'. -> Try to connect again with the ELO app."
        let alertController = UIAlertController (title: Bundle.appName(), message: "There is an error to connect \(deviceName), kindly follow below steps:\n1. Go to the \"Settings\" app on your device.\n2. Select \"Bluetooth\" from the list of options.\n3. Locate the BCA device in the list of \"MY DEVICES\".\n4. Tap on the information icon (ⓘ) next to the \(deviceName) device.\n5. Tap on \"Forget This Device\".\n6. Confirm that you want to forget the device.\nThese steps should help you to successfully forget and then reconnect with the \(deviceName) device", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
            
            guard let settingsUrl = URL(string: "App-prefs:Bluetooth") else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        
        connected.value = false
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connected.value = false
        print("Disconnect", peripheral.name ?? "-")
        guard !(self.isDownloadingComplete.value ?? false) else {
            self.isDownloadingComplete.value = false
            return
        }
        self.lastCount.value = 0
        self.updateStartTime = 0
        self.totalChunks = 0
        self.chunks.removeAll()
        self.isDownloadingComplete.value = false
        self.setPairingScreen()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if error != nil {
            debugPrint("didNotDiscoverServices",error?.localizedDescription as Any)
        }
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        
    }
    
}

//MARK: ILSBleApiDelegate
extension BleManager: ILSBleApiDelegate {

    func connectToScaleSdk() -> Void {
        
        let currentUser = UserModel.shared
        let gender = UserModel.shared.gender == "M" ? "male" : "female"
        
        let formtter = DateFormatter()
        formtter.dateFormat = DateTimeFormaterEnum.yyyymmdd.rawValue
        let dob = formtter.date(from: currentUser.dob) ?? Date()
        
        self.lsBleApi.buildUser(userId: "\(currentUser.patientId ?? "")", height: JSON(UserModel.shared.height as Any).intValue, gender: gender, birthday: Date(timeIntervalSince1970: dob.timeIntervalSince1970), completion: { (code, msg) in
            
        })
        
        self.lsBleApi.lsBleApiListener = self
        self.lsBleApi.startLSScanDevice(weightUnit: Int(currentUser.weightUnit) ?? 0) { (code, msg) in
            print("startLSScanDevice code \(code) msg \(msg)")
        }
    }
    
    func onGetUnsteadyWeight(weight: Double) {
        self.bleAPIState.value = (.GET_UNSTEADY_WEIGHT,nil)
    }
    
    func onDetecting() {
        print("------ onDetecting")
        self.bleAPIState.value = (.DETECTING,nil)
    }
    
    func onConnecting() {
        print("------ onConnecting")
        self.bleAPIState.value = (.CONNECTING,nil)
    }
    
    func onConnectionFailed() {
        print("------ onConnectionFailed")
        self.bleAPIState.value = (.CONNECTION_FAILED,nil)
    }
    
    func onConnected(device: QNBleDevice) {
        if isFromSearching {
            self.isFromSearching = false
            self.arryDeviceList = [DeviceList(deviceName: device.name)]
            print(device.name as Any)
            print(device.bluetoothName as Any)
            self.stopSDK()
        }
        self.device = device
        print("------ onConnected")
        self.bleAPIState.value = (.CONNECTED,nil)
    }
    
    func onDataReceived(jsonObj: String, mac: String) {
        print("------ onDataReceived")
        print(jsonObj)
        self.isDataRecived = true
        self.bleAPIState.value = (.DATA_RECEIVED,self.isFromMeasured ? jsonObj : nil)
    }
    
    func onDisconnecting() {
        print("------ onDisconnecting")
    }
    
    func onDisconnected(device: QNBleDevice) {
        if !self.isDataRecived {
            self.bleAPIState.value = (.CONNECTION_FAILED,nil)
        }
    }
    
    func onWrongScaleDetected(modeId: String) {
        print("------ onWrongScaleDetected")
    }
    
    func stopSDK() {
        self.lsBleApi.stopLSScanDevice(device: self.device)
    }
}
