//
//  ScanQRVC.swift
//  MyTatva
//
//  Created by Darshan Joshi on 01/12/21.
//

import Foundation

enum ScanType : String {
    case LinkDoctor
}

class ScanQRVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    @IBOutlet weak var lblOr : UILabel!
    
    @IBOutlet weak var vwEnterVehicleID : UIView!
    @IBOutlet weak var txtEnterVehicleID : UITextField!
    
    
    //MARK:- Class Variable
    var hq_id                   = ""
    var branch_id               = ""
    var subBranch_id            = ""
    var gasStation_id           = ""
    
    var pageType : ScanType     = .LinkDoctor
    
    var completionHandler: ((_ objData : [String: Any]) -> Void)?
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    
    //MARK:- Custom Method
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    func setUpView() {
        
        //self.navigationItem.hidesBackButton = true
        
        switch self.pageType {
        case .LinkDoctor:
            
            break
        }
    }
    
    //MARK:- Life Cycle Method
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
}

//MARK: ---------------------- QRScannerViewDelegate ----------------------
extension ScanQRVC: QRScannerViewDelegate {
    
    func qrScanningDidStop() {
        
    }
    
    func qrScanningDidFail() {
        Alert.shared.showSnackBar("Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        
        if let msg = str {
            DispatchQueue.main.async {
                self.scannerView.stopScanning()
                
                guard let link = URL(string: msg) else {
//                    Alert.shared.showSnackBar(AppMessages.InvalidQRCode)
                    Alert.shared.showSnackBar(AppMessages.InvalidQRCode, isError: true, isBCP: true)
                    return
                }
                let _ = DynamicLinks.dynamicLinks()
                    .handleUniversalLink(link) { dynamiclink, error in
                        
                        if error == nil {
                            //SUCCESS
                            
                            print("dynamiclink: \(dynamiclink)")
                            print("dynamiclink url: \(dynamiclink?.url)")
                            let type = sceneDelegate.fetchDeepLinkData(link: dynamiclink?.url)
                            
                            if type == .signup_link_doctor {
                                if let completion = self.completionHandler {
                                    var obj         = [String: Any]()
                                    obj["code"]     = msg
                                    completion(obj)
                                }
                                
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            else {
                                //FAILED
//                                Alert.shared.showSnackBar(AppMessages.InvalidQRCode)
                                Alert.shared.showSnackBar(AppMessages.InvalidQRCode, isError: true, isBCP: true)
                                self.scannerView.startScanning()
                            }
                        }
                        else {
                            //FAILED
//                            Alert.shared.showSnackBar(AppMessages.InvalidQRCode)
                            Alert.shared.showSnackBar(AppMessages.InvalidQRCode, isError: true, isBCP: true)
                            self.scannerView.startScanning()
                        }
                    }
            }
        }
    }
}


