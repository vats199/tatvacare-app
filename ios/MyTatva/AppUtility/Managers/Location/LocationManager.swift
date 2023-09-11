//
//  LocationManager.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

import UIKit
import CoreLocation

@objc protocol LocationManagerDelegate: AnyObject {
    @objc optional func didUpdateLocation(locations: CLLocation)
    @objc optional func didUpdateLocationOnAppDidBecomeActive(locations: CLLocation)
    @objc optional func didChangeAuthorizationStatus(status: CLAuthorizationStatus)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared : LocationManager = LocationManager()
    
    var location : CLLocation = CLLocation()
    
    private var locationManager : CLLocationManager = CLLocationManager()
    
    weak var delegate: LocationManagerDelegate?
    var isNotifyOnLocationOff: Bool = true
    
    // Use For continues update
    var locationStatus = ""
    
    //---------------------------------------------------------------------
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(LocationManager.didBecomeActiveNotification(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    //MARK: - Current Lat Long
    
    //MARK: To get location permission just call this method
    func getLocation(isAskForPermission: Bool = false) {
        
        guard isAskForPermission else { return }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func getDistance(from: CLLocation, inMeter: Bool) -> CLLocationDistance {
        if inMeter {
            return self.location.distance(from: from)
        }
        else {
            return self.location.distance(from: from) / 1000
        }
        
    }
    
    func stopUpdatingLocation(){
        DispatchQueue.main.async {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func requestLocationAuth() {
        locationManager.requestAlwaysAuthorization()
        
        if #available(iOS 14.0, *) {
            //            locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        } else {
            // Fallback on earlier versions
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationStatus = "authorized always"
            checkLocationAccuracyAllowed()
        case .authorizedWhenInUse:
            locationStatus = "authorized when in use"
            checkLocationAccuracyAllowed()
        case .notDetermined:
            locationStatus = "not determined"
        case .restricted:
            locationStatus = "restricted"
        case .denied:
            locationStatus = "denied"
        default:
            locationStatus = "other"
        }
    }
    
    func checkLocationAccuracyAllowed() {
        if #available(iOS 14.0, *) {
            switch locationManager.accuracyAuthorization {
            case .reducedAccuracy:
                locationStatus = "approximate location"
            case .fullAccuracy:
                locationStatus = "accurate location"
            @unknown default:
                locationStatus = "unknown type"
            }
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
    }
    
    
    //MARK: To get permission is allowed or declined
    func checkStatus() -> CLAuthorizationStatus{
        return self.locationManager.authorizationStatus
    }
    
    //MARK: To get user's current location
    func getUserLocation() -> CLLocation {
        //        if isNotifyOnLocationOff && !self.isLocationServiceEnabled() {
        //            return CLLocation(latitude: 0.0, longitude: 0.0)
        //        }
        //
        //        if location.coordinate.longitude == 0.0 {
        //            return CLLocation(latitude: 0.0, longitude: 0.0)
        //
        //        }
        return location
    }
    
    //MARK: Delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations[0]
        
        if let _ = self.delegate {
            self.delegate?.didUpdateLocation?(locations: location)
            debugPrint(location)
        }
        else {
            self.stopUpdatingLocation()
        }
    }
    
    @discardableResult
    func isLocationServiceEnabled(showAlert: Bool) -> Bool {
        
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            return true
            //break
        case .notDetermined:
            return false
            //break
            
        case .denied, .restricted:
            if showAlert {
                let alertController = UIAlertController(title: "App Permission Denied".localized, message: "To re-enable, please go to Settings and turn on Location Service for ".localized + "\(Bundle.appName())", preferredStyle: .alert)
                
                let setting = UIAlertAction(title: "Go to Settings".localized, style: .default, handler: { (UIAlertAction) in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)! as URL)
                    }
                })
                
                let close = UIAlertAction(title: "Close".localized, style: .default, handler: { (UIAlertAction) in
                })
                
                alertController.addAction(setting)
                alertController.addAction(close)
                
                UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
            }
            
            return false
        default:
            break
        }
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let _ = self.delegate {
            self.delegate?.didChangeAuthorizationStatus?(status: status)
        }
        switch status {
            
        case .denied:
            print("Permission Denied")
            break
        case .notDetermined:
            print("Permission Not Determined G")
            break
            
        default:
            guard let location = manager.location else {
                return
            }
            self.location = location
            print("\(location.coordinate.latitude)")
            print("\(location.coordinate.longitude)")
            break
        }
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if let _ = self.delegate {
            self.delegate?.didChangeAuthorizationStatus?(status: status)
        }
        switch status {
            
        case .denied:
            print("Permission Denied")
            break
        case .notDetermined:
            print("Permission Not Determined")
            break
            
        default:
            print("\(location.coordinate.latitude)")
            print("\(location.coordinate.longitude)")
            break
        }
    }
    
    @objc func didBecomeActiveNotification(_ notification: Notification) {
        self.location = self.getUserLocation()
        if let _ = self.delegate {
            self.delegate?.didUpdateLocationOnAppDidBecomeActive?(locations: location)
        }
    }
}
