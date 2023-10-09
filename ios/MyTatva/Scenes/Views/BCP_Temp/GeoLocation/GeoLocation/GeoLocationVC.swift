//
//  GeoLocationVC.swift
//  MyTatva
//
//  Created by 2022M43 on 29/08/23.
//

import Foundation
import UIKit
import MapKit

class GeoLocationVC: LightPurpleNavigationBase {
    
    //MARK: - Outlets -
    @IBOutlet weak var lblNavTitle: SemiBoldBlackTitle!
    
    @IBOutlet weak var vwSearchLocation: UIView!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var txtSearchLocation: UITextField!
    
    @IBOutlet weak var vwMap: GMSMapView!
    
    @IBOutlet weak var vwLocationDetails: UIView!
    @IBOutlet weak var vwCurrentLocation: UIView!
    @IBOutlet weak var imgCurrentLocation: UIImageView!
    @IBOutlet weak var lblCurrentLocation: UILabel!
    
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblLocality: UILabel!
    
    @IBOutlet weak var btnAddAddress: ThemePurple16Corner!
    
    //------------------------------------------------------
    //MARK: - Class Variables -
    var locationManager = CLLocationManager()
    var centerMapCoordinate : CLLocationCoordinate2D!
    var isMoveMap = false
    
    var code : String = ""
    var city : String = ""
    var country : String = ""
    var state : String = ""
    var address: String = ""
    var locality: String = ""
    var locationLatitude = ""
    var locationLongitude = ""
    var fullAddress = ""
    var cLat = CLLocationDegrees()
    var cLong = CLLocationDegrees()
    var isLocationSet: Bool = true
    
    let viewModel = GeoLocationVM()
    var completion:((LabAddressListModel) -> ())?
    var locationStatus              : CLAuthorizationStatus?
    var isFromEdit = false
    var addressData : LabAddressListModel?
    
    //------------------------------------------------------
    //MARK: - UIView Life Cycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        self.manageActionMethod()
        
//        self.cLat = LocationManager.shared.getUserLocation().coordinate.latitude
//        self.cLong = LocationManager.shared.getUserLocation().coordinate.longitude
//
//        let camera = GMSCameraPosition.camera(withLatitude: cLat, longitude: cLong, zoom: 15)
//        self.vwMap.camera = camera
//        self.vwMap.delegate = self
//        self.vwMap.isMyLocationEnabled = true
        
        /*DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setUpLocationManager()
            NotificationCenter.default.addObserver(self, selector: #selector(self.locationUpdated), name: .locationUpdated, object: nil)
        }*/
        
        self.setUpLocationManager()
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationUpdated), name: .locationUpdated, object: nil)
        
        LocationManager.shared.delegate = self
    }
    
    func applyStyle() {
        
        self.lblNavTitle.text = "Confirm location"
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.themeGray4,
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 12)
        ]
        
        self.txtSearchLocation.attributedPlaceholder = NSAttributedString(string: "Search for area, street name...", attributes:attributes)
        self.txtSearchLocation.delegate = self
        self.lblCurrentLocation.font(name: .bold, size: 12).textColor(color: .themeBlack2).text = "Use Current Location"
        self.lblAddress.font(name: .bold, size: 20).textColor(color: .ThemeBlack21).text = " "
        self.lblLocality.font(name: .regular, size: 12).textColor(color: .ThemeGray61).text = " "
        
        self.btnAddAddress.setTitle("Add Complete Address", for: .normal)
        
        self.vwSearchLocation.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack2.withAlphaComponent(0.5), shadowOpacity: 0.2, shdowRadious: 4)
        self.vwSearchLocation.cornerRadius(cornerRadius: 12).borderColor(color: .themeBorder2, borderWidth: 1)
        self.vwCurrentLocation.cornerRadius(cornerRadius: 10).borderColor(color: .themeBlack2, borderWidth: 1)
                
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwLocationDetails.roundCorners([.topLeft,.topRight], radius: 20.0)
        }
        
    }
    
    fileprivate func setUpLocationManager() {
        
        if isFromEdit && addressData?.latitude != "" && addressData?.longitude != "" {
            self.cLat = Double(self.addressData?.latitude ?? "") ?? 0.0
            self.cLong = Double(self.addressData?.longitude ?? "") ?? 0.0
        } else {
            self.cLat = LocationManager.shared.getUserLocation().coordinate.latitude
            self.cLong = LocationManager.shared.getUserLocation().coordinate.longitude
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: cLat, longitude: cLong, zoom: 15)
        self.vwMap.camera = camera
        self.vwMap.delegate = self
        self.vwMap.isMyLocationEnabled = true
        
        switch LocationManager.shared.checkStatus() {
        case .notDetermined:
            LocationManager.shared.getLocation()
            break
        case .denied:
            LocationManager.shared.isLocationServiceEnabled(showAlert: true)
            break
        case .authorizedAlways,.authorizedWhenInUse,.restricted:
            
            self.setEvents(event: .MAP_USAGE)
            
            LocationManager.shared.updateLocation()
            if isFromEdit && addressData?.latitude != "" && addressData?.longitude != "" {
                self.cLat = Double(self.addressData?.latitude ?? "") ?? 0.0
                self.cLong = Double(self.addressData?.longitude ?? "") ?? 0.0
            } else {
                self.cLat = LocationManager.shared.getUserLocation().coordinate.latitude
                self.cLong = LocationManager.shared.getUserLocation().coordinate.longitude
            }
            
            locationLatitude = cLat.description
            locationLongitude = cLong.description
//
//            let camera = GMSCameraPosition.camera(withLatitude: cLat, longitude: cLong, zoom: 15)
//            self.vwMap.camera = camera
//            self.vwMap.delegate = self
//            self.vwMap.isMyLocationEnabled = true
//            self.mapView(self.vwMap, didChange: camera)
            LocationManager.shared.getAddressFromLocation(latitude:cLat.description, longitude: cLong.description) { (gmsAddress) in
                if let fullAdd = gmsAddress?.lines?.first {
                    DispatchQueue.main.async {
                        self.lblAddress.text = JSON(fullAdd).stringValue
                        self.fullAddress = JSON(fullAdd).stringValue
                    }
                    guard let country = gmsAddress?.country else { return }
                    self.country = JSON(country).stringValue
                    guard let state = gmsAddress?.administrativeArea else { return }
                    self.state = JSON(state).stringValue
                    guard let city = gmsAddress?.locality else {return}
                    self.city = JSON(city).stringValue
                    self.lblLocality.text = self.city
                    guard let code = gmsAddress?.postalCode else {return}
                    self.code = JSON(code).stringValue
                    guard let address = gmsAddress?.thoroughfare else {return}
                    self.address = JSON(address).stringValue
                    guard let latitude = gmsAddress?.coordinate.latitude else {return}
                    self.locationLatitude = JSON(latitude).stringValue
                    guard let longitude = gmsAddress?.coordinate.longitude else {return}
                    self.locationLongitude = JSON(longitude).stringValue
                    guard let locality = gmsAddress?.locality else { return }
                    self.locality = JSON(locality).stringValue
                    print(fullAdd)
                }
            }
            break
        @unknown default:
            break
        }
    }
    
    private func setEvents(event: FIREventType) {
        var params              = [String : Any]()
        FIRAnalytics.FIRLogEvent(eventName: event,
                                 screen: .ConfirmLocationMap,
                                 parameter: params)
    }
    
    private func getCurrentLocation() {
        
        DispatchQueue.main.async {
            self.cLat = LocationManager.shared.getUserLocation().coordinate.latitude
            self.cLong = LocationManager.shared.getUserLocation().coordinate.longitude
            
            let camera = GMSCameraPosition.camera(withLatitude: self.cLat, longitude: self.cLong, zoom: 15)
            self.vwMap.camera = camera
            self.vwMap.delegate = self
            self.vwMap.isMyLocationEnabled = true
            self.mapView(self.vwMap, didChange: camera)
        }
    }
    
    //MARK: - Button Action Methods -
    func manageActionMethod() {
        
        self.btnAddAddress.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            
            guard !self.code.isEmpty else { return }
            
            self.setEvents(event: .TAP_COMPLETE_ADDRESS)
            
            self.viewModel.pincode_availabilityAPI(pincode: self.code) { [weak self] isDone in
                guard let self = self else { return }
                if isDone {
                    let vc = GeoLocationPopupVC.instantiate(fromAppStoryboard: .BCP_temp)
                    vc.isEdit = self.isFromEdit
                    vc.locationData = locationData(fullAddress: self.fullAddress, pinCode: self.code,longitude: self.locationLongitude, latitude: self.locationLatitude,streetName: self.addressData?.street ?? "",patientAddressRelationId: self.addressData?.patientAddressRelId ?? "",addressType: self.addressData?.addressType ?? "")
                    vc.completion = { [weak self] newAddress in
                        guard let self = self else { return }
                        self.completion?(newAddress)
                        if self.isFromEdit {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    let navController = UINavigationController(rootViewController: vc) //Add navigation controller
                    navController.modalPresentationStyle = .overFullScreen
                    navController.modalTransitionStyle = .crossDissolve
                    self.present(navController, animated: true, completion: nil)
                }
            }
        }
        
        self.vwCurrentLocation.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
//            let cLat = LocationManager.shared.getUserLocation().coordinate.latitude
//            let cLong = LocationManager.shared.getUserLocation().coordinate.longitude
//            let camera = GMSCameraPosition.camera(withLatitude: cLat, longitude: cLong, zoom: 15)
//            self.vwMap.camera = camera
//            self.mapView(self.vwMap, didChange: camera)
            self.getCurrentLocation()
        }
    }
    
    override func popViewController(sender: AnyObject) {
        super.popViewController(sender: sender)
        self.setEvents(event: .BACK_BUTTON_CLICK)
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- MKMapViewDelegate
extension GeoLocationVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //        if isMoveMap {
        //            let latitude = mapView.camera.target.latitude
        //            let longitude = mapView.camera.target.longitude
        //            centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //            locationLatitude = centerMapCoordinate.latitude.description
        //            locationLongitude = centerMapCoordinate.longitude.description
        //            LocationManager.shared.getAddressFromLocation(latitude: centerMapCoordinate.latitude.description, longitude: centerMapCoordinate.longitude.description) { (gmsAddress) in
        //                if let fullAdd = gmsAddress?.lines?.first {
        //                    DispatchQueue.main.async {
        //                        self.lblAddress.text = JSON(fullAdd).stringValue
        //                        self.fullAddress = JSON(fullAdd).stringValue
        //                    }
        //                    guard let country = gmsAddress?.country else { return }
        //                    self.country = JSON(country).stringValue
        //                    guard let state = gmsAddress?.administrativeArea else { return }
        //                    self.state = JSON(state).stringValue
        //                    guard let city = gmsAddress?.locality else {return}
        //                    self.city = JSON(city).stringValue
        //                    self.lblLocality.text = self.city
        //                    guard let code = gmsAddress?.postalCode else {return}
        //                    self.code = JSON(code).stringValue
        //                    guard let address = gmsAddress?.thoroughfare else {return}
        //                    self.address = JSON(address).stringValue
        //                    guard let latitude = gmsAddress?.coordinate.latitude else {return}
        //                    self.locationLatitude = JSON(latitude).stringValue
        //                    guard let longitude = gmsAddress?.coordinate.longitude else {return}
        //                    self.locationLongitude = JSON(longitude).stringValue
        //                    guard let locality = gmsAddress?.locality else { return }
        //                    self.locality = JSON(locality).stringValue
        //                    print(fullAdd)
        //                }
        //            }
        //        } else {
        //            self.isMoveMap = true
        //        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if isMoveMap {
            
            self.setEvents(event: .MAP_USAGE)
            
            let latitude = mapView.camera.target.latitude
            let longitude = mapView.camera.target.longitude
            centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            locationLatitude = centerMapCoordinate.latitude.description
            locationLongitude = centerMapCoordinate.longitude.description
            LocationManager.shared.getAddressFromLocation(latitude: centerMapCoordinate.latitude.description, longitude: centerMapCoordinate.longitude.description) { (gmsAddress) in
                if let fullAdd = gmsAddress?.lines?.first {
                    DispatchQueue.main.async {
                        self.lblAddress.text = JSON(fullAdd).stringValue
                        self.fullAddress = JSON(fullAdd).stringValue
                    }
                    guard let country = gmsAddress?.country else { return }
                    self.country = JSON(country).stringValue
                    guard let state = gmsAddress?.administrativeArea else { return }
                    self.state = JSON(state).stringValue
                    guard let city = gmsAddress?.locality else {return}
                    self.city = JSON(city).stringValue
                    self.lblLocality.text = self.city
                    guard let code = gmsAddress?.postalCode else {return}
                    self.code = JSON(code).stringValue
                    guard let address = gmsAddress?.thoroughfare else {return}
                    self.address = JSON(address).stringValue
                    guard let latitude = gmsAddress?.coordinate.latitude else {return}
                    self.locationLatitude = JSON(latitude).stringValue
                    guard let longitude = gmsAddress?.coordinate.longitude else {return}
                    self.locationLongitude = JSON(longitude).stringValue
                    guard let locality = gmsAddress?.locality else { return }
                    self.locality = JSON(locality).stringValue
                    print(fullAdd)
                }
            }
        } else {
            self.isMoveMap = true
        }
    }
    
}
//MARK: - Extension for TextFieldDelegate -
extension GeoLocationVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtSearchLocation {
            self.setEvents(event: .LOCATION_SEARCH)
            let picker = GMSAutocompleteViewController()
            picker.delegate = self
            if #available(iOS 9.0, *) {
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                UITextField.appearance().tintColor = .black
            } else {
                // Fallback on earlier versions
            }
            present(picker, animated: true, completion: nil)
            self.txtSearchLocation.resignFirstResponder()
        }
        return false
    }
}

//MARK: - Extension for GMSAutocompleteViewControllerDelegate -
extension GeoLocationVC :  GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.txtSearchLocation.resignFirstResponder()
        viewController.dismiss(animated: true, completion: nil)
        self.txtSearchLocation.text = place.formattedAddress!
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
        self.vwMap.camera = camera
        mapView(vwMap, didChange: camera)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.txtSearchLocation.resignFirstResponder()
        viewController.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Listner's methods -
extension GeoLocationVC {
    @objc func locationUpdated() {
        if  isLocationSet && !LocationManager.shared.isLocationEmpty() {
            isLocationSet = false
            if LocationManager.shared.checkStatus() == .authorizedAlways ||  LocationManager.shared.checkStatus() == .authorizedWhenInUse {
//                self.cLat = LocationManager.shared.getUserLocation().coordinate.latitude
//                self.cLong = LocationManager.shared.getUserLocation().coordinate.longitude
//                let camera = GMSCameraPosition.camera(withLatitude: cLat, longitude: cLong, zoom: 15)
//                self.vwMap.camera = camera
//                self.vwMap.delegate = self
//                self.vwMap.isMyLocationEnabled = true
                self.getCurrentLocation()
                LocationManager.shared.getAddressFromLocation(latitude:cLat.description, longitude: cLong.description) { (gmsAddress) in
                    if let fullAdd = gmsAddress?.lines?.first {
                        DispatchQueue.main.async {
                            self.lblAddress.text = JSON(fullAdd).stringValue
                            self.fullAddress = JSON(fullAdd).stringValue
                        }
                        guard let country = gmsAddress?.country else { return }
                        self.country = JSON(country).stringValue
                        guard let state = gmsAddress?.administrativeArea else { return }
                        self.state = JSON(state).stringValue
                        guard let city = gmsAddress?.locality else {return}
                        self.city = JSON(city).stringValue
                        self.lblLocality.text = self.city
                        guard let code = gmsAddress?.postalCode else {return}
                        self.code = JSON(code).stringValue
                        guard let address = gmsAddress?.thoroughfare else {return}
                        self.address = JSON(address).stringValue
                        guard let latitude = gmsAddress?.coordinate.latitude else {return}
                        self.locationLatitude = JSON(latitude).stringValue
                        guard let longitude = gmsAddress?.coordinate.longitude else {return}
                        self.locationLongitude = JSON(longitude).stringValue
                        guard let locality = gmsAddress?.locality else { return }
                        self.locality = JSON(locality).stringValue
                        print(fullAdd)
                        
                    }
                }
            }
        }
    }
}

extension GeoLocationVC: LocationManagerDelegate {
    
    func didChangeAuthorizationStatus(status: CLAuthorizationStatus) {
        if self.locationStatus != status {
            self.locationStatus = status
            if LocationManager.shared.checkStatus() == .authorizedAlways || LocationManager.shared.checkStatus() == .authorizedWhenInUse {
            } else {
                if let vc = UIApplication.topViewController() {
                    if vc.isKind(of: GMSAutocompleteViewController.self) {
                        vc.dismiss(animated: true) { [weak self] in
                            guard let self = self else { return }
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
}
