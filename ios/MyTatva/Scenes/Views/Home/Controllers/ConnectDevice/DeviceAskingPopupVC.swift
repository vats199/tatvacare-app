//
//  DeviceAskingPopupVC.swift
//  MyTatva
//
//  Created by 2022M43 on 11/05/23.
//

import Foundation
import UIKit

class DeviceAskingPopupVC: UIViewController {
    
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
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
        
        self.lblTitle.font(name: .bold, size: 17)
            .textColor(color: UIColor.themeBlack)
            .text = "Do you already have a smart scale device?"

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 20)
        }
        
        self.btnYes.font(name: .regular, size: 14)
            .textColor(color: .themeBlack)
            .setTitle("Yes I do have one", for: .normal)
        
        self.btnNo.font(name: .regular, size: 14)
            .textColor(color: .themeBlack)
            .setTitle("No, I want to purchase one", for: .normal)
        
        self.openPopUp()
        self.manageActionMethods()
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
    
    private func addEventInAnalytics(hasDevice:Bool) {
        var params = [String:Any]()
        params[AnalyticsParameters.medical_device.rawValue] = kBCA
        params[AnalyticsParameters.Device_availability.rawValue] = hasDevice ? AppMessages.yes : AppMessages.no
        FIRAnalytics.FIRLogEvent(eventName: .MEDICAL_DEVICE_AVAILABILITY,
                                 screen: .DoYouHaveDevice,
                                 parameter: params)
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true)
        }
        
        self.btnYes.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: false) {
                self.addEventInAnalytics(hasDevice: true)
                let vc = ConnectDeviceVC.instantiate(fromAppStoryboard: .home)
                let navi = UINavigationController(rootViewController: vc)
                navi.modalPresentationStyle = .overFullScreen
                navi.modalTransitionStyle = .crossDissolve
                UIApplication.topViewController()?.present(navi, animated: true)
            }
        }
        
        self.btnNo.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
//            let vc = PlanParentVC.instantiate(fromAppStoryboard: .setting)
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
            self.dismiss(animated: false) {
                self.addEventInAnalytics(hasDevice: false)
                let vc = BCPCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        WebengageManager.shared.navigateScreenEvent(screen: .DoYouHaveDevice)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
