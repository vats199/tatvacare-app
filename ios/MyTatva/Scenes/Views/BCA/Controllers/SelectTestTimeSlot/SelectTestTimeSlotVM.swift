//
//  SelectTestTimeSlotVM.swift
//  MyTatva
//
//  Created by Uttam patel on 09/08/23.
//

//
//  SelectTestSlotVM.swift
//  MyTatva
//
//  Created by Uttam patel on 04/08/23.
//

import Foundation
import UIKit

class SelectTestTimeSlotVM {
    
    //MARK:- Class Variable
    // var arrList                         = [BcaTimeSlotResultModel]()
    var vmResult                        = Bindable<Result<String?, AppError>>()
    var pateintPlanRefID                = ""
    var arrSlotsData                    = [TimeSlot]()
    
    //MARK:- Init
    init() {
        
        
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension SelectTestTimeSlotVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    func isValidView(time_slot: String,
                     forCoach: Bool) -> AppError? {
        
        if time_slot.trim() == "" {
            return AppError.validation(type: .PleaseSelectTimeSlot)
        }
        return nil
    }
    
}



//MARK: ---------------- Update Topic Data ----------------------
extension SelectTestTimeSlotVM {
    
    //MARK: - Data Processing Methods -
    
    func numberOfSection() -> Int {
        return self.arrSlotsData.count
    }
    
    //-----------------------------------------------------------------------------------
    
    func numberofRows(_ section: Int) -> Int {
        return self.arrSlotsData[section].slots.count
    }
    
    //-----------------------------------------------------------------------------------
    
    func valueForHeader(_ section: Int) -> String {
        return self.arrSlotsData[section].title
    }
    
    //-----------------------------------------------------------
    
    
    func valueForCollection(_ row: Int) -> TimeSlot {
        return self.arrSlotsData[row]
    }
    
    func valueForCell(_ section: Int, row: Int) -> String {
        return self.arrSlotsData[section].slots[row]
    }
    
    //-----------------------------------------------------------------------------------
    
    func selctedSection(_ section: Int) -> Bool {
        return self.arrSlotsData[section].isSelected
    }
    
    //-----------------------------------------------------------------------------------
    
    func showSection(_ section: Int) {
        for (i, obj) in self.arrSlotsData.enumerated() {
            if i == section {
                obj.isSelected.toggle()
            } else {
                obj.isSelected = false
            }
        }
    }
    
    //-----------------------------------------------------------------------------------
}

extension SelectTestTimeSlotVM {
    
    func get_appointment_slots(date:Date,
                            pinCode: String,
                            withLoader: Bool,
                            completion: ((Bool) -> Void)?){
        
        var params                      = [String : Any]()
        
        let formatter: DateFormatter    = DateFormatter()
        formatter.timeZone              = .current
        formatter.dateFormat            = DateTimeFormaterEnum.yyyymmdd.rawValue
        let strDate                     = formatter.string(from: date)
        
        params["Pincode"]           = pinCode
        params["Date"]              = strDate
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.get_appointment_slots), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
//                    Alert.shared.showSnackBar(response.message)
                    self.vmResult.value = .failure(.custom(errorDescription: response.message))
                    break
                case .success:
                    returnVal = true
                    self.arrSlotsData = TimeSlot.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.vmResult.value = .success(nil)
                    break
                case .emptyData:
                    self.vmResult.value = .failure(.custom(errorDescription: response.message))
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
                    Alert.shared.showSnackBar(response.message)
                    break
                case .otpVerify:
                    break
                case .emailVerify:
                    break
                case .forceUpdateApp:
                    break
                case .underMaintenance:
                    break
                case .socialIdNotRegister:
                    break
                case .userSessionExpire:
                    break
                case .unknown:
                    break
                default: break
                }
                
                completion?(returnVal)
                break
                
            case .failure(let error):
                completion?(returnVal)
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
                
            }
        }
    }
    
    func update_bcp_hc_details(patient_plan_rel_id: String = "",
                               nutritionist_availability_date: String = "",
                               physiotherapist_availability_date: String = "",
                               physiotherapist_start_time: String = "",
                               physiotherapist_end_time: String = "",
                               nutritionist_start_time: String = "",
                               nutritionist_end_time: String = "",
                               withLoader: Bool,
                               completion: ((Bool, String) -> Void)?){
        
        var params                                     = [String : Any]()
        params["patient_plan_rel_id"]                  = patient_plan_rel_id
        params["nutritionist_availability_date"]       = nutritionist_availability_date
        params["physiotherapist_availability_date"]    = physiotherapist_availability_date
        params["physiotherapist_start_time"]           = physiotherapist_start_time
        params["physiotherapist_end_time"]             = physiotherapist_end_time
        params["nutritionist_start_time"]              = nutritionist_start_time
        params["nutritionist_end_time"]                = nutritionist_end_time
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.doctor(.update_bcp_hc_details), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:
                    
                    /*var params                                          = [String : Any]()
                    params[AnalyticsParameters.slot_booking_for.rawValue] = nutritionist_availability_date.isEmpty ? "physio" : "nutri"
                    FIRAnalytics.FIRLogEvent(eventName: .BOOK_APPOINTMENT_SUCCESSFUL,
                                             screen: .BcpHcServiceSelectTimeSlot,
                                             parameter: params)*/
                    
                    returnVal = true
                    break
                case .emptyData:
                    break
                case .inactiveAccount:
                    
                    UIApplication.shared.forceLogOut()
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .otpVerify:
                    break
                case .emailVerify:
                    break
                case .forceUpdateApp:
                    break
                case .underMaintenance:
                    break
                case .socialIdNotRegister:
                    break
                case .userSessionExpire:
                    break
                case .unknown:
                    break
                default: break
                }
                
                completion?(returnVal, response.message)
                break
                
            case .failure(let error):
                completion?(returnVal, "")
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
                
            }
        }
    }
    
}

