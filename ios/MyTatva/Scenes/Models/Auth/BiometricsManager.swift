

import Foundation
import UIKit
import LocalAuthentication

enum BiometricType: String {
    case none
    case touchID
    case faceID
}

extension LAContext {
    
    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                #warning("Handle new Biometric type")
            }
        }
        
        return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }
}

class BiometricsManager: NSObject {
    
    
    var businessId: Int!
    
    var quantity = 1
    
    ///Shared instance
    static let shared : BiometricsManager = BiometricsManager()
    
    
    override init(){}
    
}

//MARK: -------------------- Manage BiometricsManager --------------------
extension BiometricsManager {
    
    func getBiometricType() -> BiometricType {
        return LAContext().biometricType
    }
}

//MARK: -------------------- Biometric Methods --------------------
extension BiometricsManager {
    
    func authenticationWithTouchID(completion: ((Bool) -> Void)?){
        
        var returnVal = false
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"

        var authError: NSError?
        let reasonString = "To access the secure data"

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    returnVal = true
                    print("User authenticated successfully, take appropriate action")
                    UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.isBiometricOn)
                    //TODO: User authenticated successfully, take appropriate action
                    
                    completion?(returnVal)
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code).message)
                    completion?(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code).isAllow)
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code).message)
            completion?(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code).isAllow)
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> (message : String, isAllow : Bool) {
        var message = ""
        var returnVal = false
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
                case LAError.biometryNotAvailable.rawValue:
                    message = "Authentication could not start because the device does not support biometric authentication."
                    returnVal = true
                
                case LAError.biometryLockout.rawValue:
                    message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
                case LAError.biometryNotEnrolled.rawValue:
                    message = "Authentication could not start because the user has not enrolled in biometric authentication."
                    returnVal = true
                default:
                    message = "Did not find error code on LAError object"
                    returnVal = true
            }
        } else {
            switch errorCode {
                case LAError.touchIDLockout.rawValue:
                    message = "Too many failed attempts."
                
                case LAError.touchIDNotAvailable.rawValue:
                    message = "TouchID is not available on the device"
                    returnVal = true
                    
                case LAError.touchIDNotEnrolled.rawValue:
                    message = "TouchID is not enrolled on the device"
                    returnVal = true
                    
                default:
                    message = "Did not find error code on LAError object"
                    returnVal = true
            }
        }
        
        return (message: message, isAllow: returnVal)
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> (message : String, isAllow : Bool) {
        
        var message = ""
        var returnVal = false
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            returnVal = true
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"

        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode).message
            returnVal = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode).isAllow
        }
        
        return (message: message, isAllow: returnVal)
    }
}
