//
//  LocationPermissionPopUpVC.swift
//  MyTatva
//
//  Created by 2022M43 on 31/08/23.
//

import Foundation
import UIKit

struct locationData: Codable {
    var fullAddress = ""
    var pinCode = ""
    var longitude = ""
    var latitude = ""
    var streetName = ""
    var patientAddressRelationId = ""
    var addressType = ""
}

class LocationPermissionPopUpVC: UIViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var imgLocationIcon: UIImageView!
    @IBOutlet weak var lblLocationNotEnable: UILabel!
    @IBOutlet weak var lblPermissionDesc: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnGrant: ThemePurple16Corner!
    
    //------------------------------------------------------
    //MARK: - Class Variables -
    var completion:((LabAddressListModel) -> ())?
    var selectManuallyCompletion:((Bool) -> ())?
    var selectGrantCompletion:((Bool) -> ())?
    var locationStatus              : CLAuthorizationStatus?
    var isFromGrant = false
    
    //------------------------------------------------------
    //MARK: - UIView Life Cycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.clearNavigation()
        self.setupEvents(events: .SHOW_BOTTOM_SHEET)
    }
    
    //------------------------------------------------------
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    //MARK: - Custome Methods -
    func setUpView() {
        self.applyStyle()
        self.manageActionMethods()
        
        LocationManager.shared.delegate = self
    }
    
    func applyStyle() {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.btnSelect.cornerRadius(cornerRadius: 16.0).borderColor(color: .themePurple, borderWidth: 1.0).backGroundColor(color: .white).font(name: .bold, size: 16.0).textColor(color: .themePurple)
            self.imgLocationIcon.setRound().image = UIImage(named: "locationPermission_ic")
            self.btnSelect.setTitle("Select Manually", for: .normal)
            self.btnGrant.setTitle("Grant", for: .normal)
            self.vwBG.roundCorners([.topLeft,.topRight], radius: 20.0)
            self.imgBG.alpha = kPopupAlpha
            self.view.layoutIfNeeded()
        }
        
        self.lblLocationNotEnable.textColor(color: .themeBlack2).font(name: .bold, size: 20).text = "Device location not enabled"
        self.lblPermissionDesc.textColor(color: .ThemeGray61).font(name: .regular, size: 12).text = "Granting location permission will ensure accurate location"
        
        self.openPopUp()
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBG.alpha = kPopupAlpha
        }
    }
    
    private func setupEvents(events: FIREventType) {
        var params              = [String : Any]()
        params[AnalyticsParameters.bottom_sheet_name.rawValue]            = BottomScreenName.grant_location_permission.rawValue
        FIRAnalytics.FIRLogEvent(eventName: events,
                                 screen: .LocationPermission,
                                 parameter: params)
    }
    
    //MARK: - Button Action Methods -
    func manageActionMethods() {
        
        self.imgBG.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        self.btnGrant.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.setupEvents(events: .TAP_GRANT_LOCATION)
            LocationManager.shared.getLocation(isAskForPermission: true)
            self.locationStatus = LocationManager.shared.checkStatus()
            self.isFromGrant = self.locationStatus == .notDetermined || self.locationStatus == .authorizedWhenInUse
            if self.locationStatus == .authorizedAlways {
                self.dismiss(animated: true)
            }
        }
        
        self.btnSelect.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.setupEvents(events: .TAP_SELECT_MANUALLY)
            self.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.selectManuallyCompletion?(true)                
            }
        }
    }
}

extension LocationPermissionPopUpVC: LocationManagerDelegate {
    
    func didChangeAuthorizationStatus(status: CLAuthorizationStatus) {
        print("Location permission chnage")
        if self.locationStatus != status {
            self.locationStatus = status
            if LocationManager.shared.checkStatus() == .authorizedAlways || LocationManager.shared.checkStatus() == .authorizedWhenInUse {
                self.dismiss(animated: true) {
                    self.selectGrantCompletion?(true)
                }
            } else if status == .denied && isFromGrant {
                self.isFromGrant = false
                self.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    self.selectManuallyCompletion?(true)
                }
            }
        } else {
            LocationManager.shared.isLocationServiceEnabled(showAlert: true)
        }
    }
    
}
