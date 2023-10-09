//
//  EnterLocationPopupVC.swift
//  MyTatva
//
//  Created by Uttam patel on 31/08/23.
//

import Foundation
import UIKit

class EnterLocationPopupVC: UIViewController {
    //MARK: - Outlets -
    
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var imgTopLine: UIImageView!
    
    @IBOutlet weak var lblHeader: UILabel!
    
    //----------------- Pincode -------------------
    @IBOutlet weak var vwPincode: UIView!
    @IBOutlet weak var txtPincode: ThemeFloatingTextField!
    @IBOutlet weak var btnApply: UIButton!
    
    //----------------- Current Location -------------------
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var vwUseCurrentLocation: UIView!
    
    @IBOutlet weak var vwValidationMessage: UIView!
    @IBOutlet weak var lblValidationMessage: UILabel!
    
    //MARK: - Class Variables -
    let viewModel = EnterLocationPopUpVM()
    var completion:((LabAddressListModel) -> ())?
    var locationStatus              : CLAuthorizationStatus?
    var pendingRequest: DispatchWorkItem?
    var isFromEdit = false
    var addressData : LabAddressListModel?
    
    //MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setData()
        self.applyStyle()
        
    }
    
    //------------------------------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        self.setupEvents(events: .SHOW_BOTTOM_SHEET)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppCoordinator().setUpIQKeyBoardManager()
    }
    //------------------------------------------------------------------------------------------
    
    
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------------------------------------------
    
    //MARK: - Custom Functions -
    
    func setup() {
        self.manageActionMethod()
        self.setupViewModelObserver()
        self.txtPincode.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmissVC))
        tapGesture.numberOfTapsRequired = 1
        self.imgBg.isUserInteractionEnabled = true
        self.imgBg.addGestureRecognizer(tapGesture)
        
        LocationManager.shared.delegate = self
        self.vwValidationMessage.isHidden = true
        
        self.txtPincode.becomeFirstResponder()
    }
    
    private func setupEvents(events: FIREventType) {
        var params              = [String : Any]()
        params[AnalyticsParameters.bottom_sheet_name.rawValue]    = BottomScreenName.add_pincode.rawValue
        FIRAnalytics.FIRLogEvent(eventName: events,
                                 screen: .EnterLocationPinCode,
                                 parameter: params)
    }
    
    func setData() {
        if self.isFromEdit && self.addressData?.pincode != nil  {
            self.txtPincode.text = String(self.addressData?.pincode ?? 0)
            DispatchQueue.main.async {
                self.btnApply.textColor(color: .themePurple).isUserInteractionEnabled = true
            }
        } else {
            self.txtPincode.text = ""
            DispatchQueue.main.async {
                self.btnApply.textColor(color: .themeLightGaryBorder).isUserInteractionEnabled = false
            }
        }
    }
    
    //------------------------------------------------------------------------------------------
    
    func applyStyle() {
        DispatchQueue.main.async { [weak self]  in
            guard let self = self else {return}
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 20)
            self.imgTopLine.setRound()
        }
        
        self.vwPincode.cornerRadius(cornerRadius: 12.0).borderColor(color: .themeBorder2).themeTextFieldShadow()
        
        self.imgTopLine.backGroundColor(color: .ThemeGrayE0)
        self.lblHeader.font(name: .bold, size: 18).textColor(color: .themeBlack3).text = "Enter Location"
        
        self.btnApply.font(name: .semibold, size: 12).textColor(color: .themeLightGaryBorder).setTitle("Apply", for: .normal)
        self.btnCurrentLocation.font(name: .medium, size: 14).textColor(color: .themeBlack2).setTitle("Use Current Location", for: .normal)
        
        self.txtPincode.keyboardType    = .numberPad
        self.btnApply.isUserInteractionEnabled = false
        
        self.lblValidationMessage.font(name: .regular, size: 12).textColor(color: .themeRedAlert)
    }
    
    //------------------------------------------------------------------------------------------
    
    @objc  func dissmissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Button Action Methods -
    
    func manageActionMethod() {
        
        self.btnCurrentLocation.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.setupEvents(events: .USE_CURRENT_LOCATION)
            LocationManager.shared.getLocation(isAskForPermission: true)
            self.locationStatus = LocationManager.shared.checkStatus()
            if LocationManager.shared.checkStatus() == .authorizedAlways || LocationManager.shared.checkStatus() == .authorizedWhenInUse {
                self.getLocation()
            }
        }
        
        self.btnApply.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.setupEvents(events: .APPLY_CLICK)
            self.viewModel.apiCall(code: self.txtPincode)
        }
    }
    
    private func getLocation() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let lat     = LocationManager.shared.getUserLocation().coordinate.latitude
            let long    = LocationManager.shared.getUserLocation().coordinate.longitude
            
            GoogleNavigationAdddress.getAddressFromLatLong(lat: lat, lng: long) { (response) in
                let response = JSON(response)
                
                if response[StringConstant.PinCode].stringValue != "" {
                    self.txtPincode.text = response[StringConstant.PinCode].stringValue
                    self.btnApply.textColor(color: .themePurple).isUserInteractionEnabled = true
                    self.vwPincode.borderColor(color: .themePurpleBlack)
                }
                else {
                    Alert.shared.showSnackBar((AppError.validation(type: .locationNotFound)).errorDescription ?? "")
                }
            }
        }
        
    }
    
    @IBAction func btnDownSheetTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //------------------------------------------------------------------------------------------
    
}

//MARK: -------------------- setupViewModel Observer --------------------
extension EnterLocationPopupVC {
    
    private func setupViewModelObserver() {
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                self.vwValidationMessage.isHidden = true
                self.dismiss(animated: true) {
                    let vc = GeoLocationPopupVC.instantiate(fromAppStoryboard: .BCP_temp)
                    vc.isEdit = self.isFromEdit
                    vc.locationData = locationData(fullAddress: self.addressData?.address ?? "",
                                                   pinCode: self.txtPincode.text ?? "" ,
                                                   longitude: self.addressData?.longitude ?? "",
                                                   latitude: self.addressData?.latitude ?? "",
                                                   streetName: self.addressData?.street ?? "",
                                                   patientAddressRelationId: self.addressData?.patientAddressRelId ?? "",
                                                   addressType: self.addressData?.addressType ?? "")
                    vc.completion = { [weak self] newAddress in
                        guard let self = self else { return }
                        self.completion?(newAddress)
                        if self.isFromEdit {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    UIApplication.topViewController()?.present(vc, animated: false)
                }
                break
            case .failure(let error):
                self.vwValidationMessage.isHidden = false
                self.lblValidationMessage.text = error.errorDescription
                self.vwValidationMessage.layoutSubviews()
                self.vwValidationMessage.layoutIfNeeded()
                break
            case .none: break
            }
        })
    }
}


//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension EnterLocationPopupVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

           if textField == txtPincode {

               self.pendingRequest?.cancel()
               self.pendingRequest = DispatchWorkItem { [weak self] in
                   guard let self = self else { return }
                   if textField.text!.count >= 6 {
                       self.btnApply.textColor(color: .themePurple).isUserInteractionEnabled = true
                       self.setupEvents(events: .PINCODE_ENTERED)
                   }
               }
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: self.pendingRequest!)

               if range.location >= 6 {
                   return false
               } else {
                   self.vwValidationMessage.isHidden = true
                   self.btnApply.textColor(color: .themeLightGaryBorder).isUserInteractionEnabled = false
                   let allowedCharacters = "1234567890"
                   let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                   let typedCharacterSet = CharacterSet(charactersIn: string)
                   let number = allowedCharacterSet.isSuperset(of: typedCharacterSet)
                   return number
               }
           }
           return true

       }
    
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.isBackspace() {
            return true
        }
        
        self.pendingRequest?.cancel()
        self.pendingRequest = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            let isPincodeAdded = self.txtPincode.text!.count >= 6
            self.btnApply.textColor(color: isPincodeAdded ? .themePurple : .themeLightGaryBorder).isUserInteractionEnabled = isPincodeAdded
            
            if isPincodeAdded {
                self.setupEvents(events: .PINCODE_ENTERED)
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: self.pendingRequest!)
        self.vwValidationMessage.isHidden = true
        let allowedCharacters = "1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let number = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        return number && (self.txtPincode.text! + string).count <= 6
    }*/
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case self.txtPincode :
            self.vwPincode.borderColor(color: .themePurpleBlack)
            break
        default:
            break
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case self.txtPincode :
            self.vwPincode.borderColor(color: self.txtPincode.text!.isEmpty ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
            break
        default:
            break
        }
        
    }
}

extension EnterLocationPopupVC: LocationManagerDelegate {
    
    func didChangeAuthorizationStatus(status: CLAuthorizationStatus) {
        if self.locationStatus != status {
            self.locationStatus = status
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                self.getLocation()
            }
        } else {
            LocationManager.shared.isLocationServiceEnabled(showAlert: true)
        }
    }
    
}
