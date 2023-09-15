//
//  PedometerManager.swift
//  MyTatva
//
//  Created by Darshan Joshi on 25/01/22.
//

import Foundation
@_exported import CoreMotion

class PedometerManager {
    
    static let shared : PedometerManager = PedometerManager()
    
    let pedometer = CMPedometer()
    let activityManager = CMMotionActivityManager()
    var pedometerStartUpdating = false
    
    func authenticatePedometer(completion: ((Bool) -> Void)?) {
        self.activityManager.startActivityUpdates(to: OperationQueue.main) { (data) in
            DispatchQueue.main.async {
                if let activity = data {
                    if activity.running == true {
                        print("Running")
                    }
                    else if activity.walking == true {
                        print("Walking")
                    }
                    else if activity.automotive == true {
                        print("Automative")
                    }
                }
            }
            self.pedometerAuthorizationState(showAlert: false) { [weak self] isDone in
                guard let _ = self else {return}
                completion?(isDone)
            }
        }
        self.pedometerAuthorizationState(showAlert: false) { [weak self] isDone in
            guard let _ = self else {return}
            completion?(isDone)
        }
    }
    
    func pedometerAuthorizationState(showAlert: Bool,
                                     completion: ((Bool) -> Void)?) {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied, .restricted:
            
            self.stopUpdating()
            if showAlert {
                let alertController = UIAlertController(title: "App Permission Denied".localized, message: "To re-enable, please go to Settings and turn on Motion Service for ".localized + "\(Bundle.appName())", preferredStyle: .alert)
                
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
            completion?(false)
        case .notDetermined:
            completion?(false)
        case .authorized:
            completion?(true)
        @unknown default:
            completion?(false)
        }
    }
    
    func didTapStartButton() {
        self.pedometerStart()
    }
    
    func pedometerStart() {
        self.authenticatePedometer { [weak self] isDone in
            guard let _ = self else {return}
            
        }
    }
    
    func pedometerUpdate() {
        if CMMotionActivityManager.isActivityAvailable() {
            //self.startTrackingActivityType()
        } else {
            //     activityTypeLabel.text = "Pedometer available"
        }
        if CMPedometer.isStepCountingAvailable() {
            //     startCountingSteps()
            
            self.pedometer.startUpdates(from: Date()) { Data, error in
            }
            
        } else {
            //     stepsCountLabel.text = "Pedometer available"
        }
    }
    
    func stopUpdating() {
        self.pedometer.stopUpdates()
        self.pedometer.stopEventUpdates()
    }
  
    
    func startTrackingActivityType() {
        self.activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in
            guard let activity = activity else { return }
            
            DispatchQueue.main.async {
                if activity.walking {
                 //   .text = "Pedometer Walking"
                }
            }
        }
    }
    
    func startCountingSteps() {
        
        self.pedometer.startUpdates(from: Date()) {
           [weak self] pedometerData, error in
           guard let pedometerData = pedometerData, error == nil else { return }
     DispatchQueue.main.async {
             //self?.stepsCountLabel.text = pedometerData.numberOfSteps.stringValue
           }
         }
       }
    
    ///get all Quantity type of records
    func fetchWalkingDistance(startDate: Date,
                                    completion: @escaping (Double) -> Void) {

//        self.pedometer.startUpdates(from: startDate, withHandler: {
//                          pData, error in
//            if let e = error{
//                print("Error querying pedometer", e.localizedDescription)
//            }else{
//                if let data = pData{
//                    self.distance += Double(data.distance ?? 0)
//                    print("Walking Distance \(self.distance)")
//                }
//            }
//        })
        
        var distanceVal: Double = 0
        self.pedometer.queryPedometerData(from: startDate, to: Date(), withHandler: {
              pData, error in
              if let e = error{
                  print("Error querying pedometer", e.localizedDescription)
              }else{
                if let data = pData{
                    distanceVal = Double(data.distance ?? 0)
                    print("Walking Distance \(distanceVal)")
                }
              }
            completion(distanceVal)
            })
    }
}
