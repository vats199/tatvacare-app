//
//  DoctorAccessCodeVC.swift
//  MyTatva
//
//  Created by Hlink on 26/04/23.
//

import UIKit

class DoctorAccessCodeVC: UIViewController {
    
    //MARK: Outlet
    
    @IBOutlet weak var constProgressTop     : NSLayoutConstraint!
    @IBOutlet weak var linearProgressBar    : LinearProgressBar!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var lblAccessCode: UILabel!
    @IBOutlet weak var txtAccessCode: ThemeTextField!
    
    @IBOutlet weak var lblOr: UILabel!
    
    @IBOutlet weak var vwScaneQR: UIView!
    @IBOutlet weak var lblScanQR: UILabel!
    @IBOutlet weak var btnScanQR: UIButton!
    
    @IBOutlet weak var btnNext: ThemePurpleButton!
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var isBackShown = false
    var isToRoot = false
    var viewModel: DoctorAccessCodeVM!
    
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
    
    private func setUpView() {
        self.applyStyle()
        self.addActions()
//        self.addHeaderView()
    }
    
    private func applyStyle() {
        
        self.navigationItem.leftBarButtonItem = self.isBackShown ? self.navigationItem.leftBarButtonItem ?? UIBarButtonItem() : nil
        
        
        self.constProgressTop.constant = DeviceManager.shared.hasNotch ? 40 : 20
        
        self.linearProgressBar.progressValue = 50
        self.linearProgressBar.cornerRadius(cornerRadius: 3)
        self.setProgress(progressBar: self.linearProgressBar, color: .themePurple)

//        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem
        
        self.lblTitle.font(name: .semibold, size: 17.0).textColor(color: .themeBlack).numberOfLines = 0
        self.lblTitle.textAlignment = .center
        self.lblTitle.text = "Let’s get started!"
        self.lblSubTitle.font(name: .regular, size: 14.0).textColor(color: .themeGray).numberOfLines = 0
        self.lblSubTitle.text = "Stay connected with your doctor by scanning\nthe QR code or entering the Doctor Access\nCode."
        self.lblSubTitle.textAlignment = .center
             
        self.lblAccessCode.font(name: .medium, size: 13.0).textColor(color: .themeGray).text = "Doctor Access Code"
        self.lblOr.font(name: .medium, size: 13.0).textColor(color: .themeBlack).text = "Or"
        self.lblScanQR.font(name: .medium, size: 13.0).textColor(color: .themePurple).text = "Scan QR Code"
        
        self.vwScaneQR.cornerRadius(cornerRadius: 5).backGroundColor(color: .white)
        
        self.btnNext.fontSize(size: 17.0).setTitle("Next", for: UIControl.State())
//        self.self.txtMobileNumber.font(name: .medium, size: 13.0)
        
    }
    
    func setProgress(progressBar: LinearProgressBar, color: UIColor){
        progressBar.trackColor          = UIColor.themeLightGray
        progressBar.trackPadding        = 0
        progressBar.capType             = 1
        
        switch progressBar {
        
        case self.linearProgressBar:
            progressBar.barThickness        = 10
            progressBar.barColor            = color
            
            progressBar.barColorForValue = { value in
                switch value {
                case 0..<20:
                    return color
                case 20..<60:
                    return color
                case 60..<80:
                    return color
                default:
                    return color
                }
            }
            
            break
       
        default: break
        }
    }
    
    private func setupViewModelObserver() {
        self.viewModel.isResult.bind { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                UserDefaultsConfig.kUserStep = 3
//                UIApplication.shared.manageLogin()
                let vc = AddpatientDetailsVC.instantiate(fromAppStoryboard: .auth)
                vc.isBackShown = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .failure(let error):
                debugPrint("Error", error.localizedDescription)
                Alert.shared.showSnackBar(error.localizedDescription)
                break
            case .none: break
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    override func popViewController(sender: AnyObject) {
        if self.isToRoot {
            if let viewControllers = self.navigationController?.viewControllers {
                for vc in viewControllers {
                    // some process
                    if vc.isKind(of: EnterMobileViewPopUp.self) {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func addActions() {
        self.btnNext.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            
            var params = [String:Any]()
            params[AnalyticsParameters.doctor_access_code.rawValue] = self.txtAccessCode.text!
            FIRAnalytics.FIRLogEvent(eventName: .ENTER_DOCTOR_CODE,
                                     screen: .LinkDoctor,
                                     parameter: params)
            
            self.viewModel.apiDoctorAccessCode(access_code: self.txtAccessCode.text!)
        }
        
        self.btnScanQR.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            let vc = ScanQRVC.instantiate(fromAppStoryboard: .auth)
            vc.pageType = .LinkDoctor
            vc.completionHandler = { obj in
                if obj.count > 0 {
                    self.txtAccessCode.isUserInteractionEnabled = false
                    self.txtAccessCode.text = kAccessCode
                    
                    var params = [String:Any]()
                    params[AnalyticsParameters.doctor_access_code.rawValue] = self.txtAccessCode.text!
                    FIRAnalytics.FIRLogEvent(eventName: .SCAN_DOCTOR_QR,
                                             screen: .LinkDoctor,
                                             parameter: params)
                    
                    self.viewModel.apiDoctorAccessCode(access_code: kAccessCode)
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = DoctorAccessCodeVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.clearNavigation()
        WebengageManager.shared.navigateScreenEvent(screen: .LinkDoctor)
    }

}
