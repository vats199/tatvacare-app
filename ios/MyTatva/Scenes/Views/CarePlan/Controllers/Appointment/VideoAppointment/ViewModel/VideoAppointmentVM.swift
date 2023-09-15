
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation
import UIKit

class VideoAppointmentVM {

    //MARK:- Class Variable
    
    private(set) var vmResultList       = Bindable<Result<String?, AppError>>()
    var page                            = 1
    var isNextPage                      = true
    var arrList                         = [AppointmentTimeSlotModel]()
    var object                          = AppointmentTimeSlotModel()
    var appointmentListModel            = AppointmentListModel()
    var strErrorMessage : String        = ""
   
    private(set) var vmResult           = Bindable<Result<String?, AppError>>()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

// MARK: Validation Methods
extension VideoAppointmentVM {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(clinic_id: String,
                             doctor_id: String,
                             consulation_type: String,
                             appointment_date: String,
                             time_slot: String) -> AppError? {
        
        if clinic_id.trim() == "" {
            return AppError.validation(type: .PleaseSelectClinic)
        }
        else if doctor_id.trim() == "" {
            return AppError.validation(type: .PleaseSelectDoctor)
        }
        else if consulation_type.trim() == "" {
            return AppError.validation(type: .PleaseSelectAppointmentType)
        }
//        else if appointment_date.trim() == "" {
//            return AppError.validation(type: .PleaseSelectDoctor)
//        }
        else if time_slot.trim() == "" {
            return AppError.validation(type: .PleaseSelectTimeSlot)
        }
        return nil
    }
}

//MARK: ---------------- Update Topic Data ----------------------
extension VideoAppointmentVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> AppointmentTimeSlotModel {
        return self.arrList[index]
    }
    
    func manageSelection(index: Int) {
//       let object = self.arrList[index]
//
//        for item in self.arrList {
//            //item.isSelected = false
//            if item.topicMasterId == object.topicMasterId {
//                //item.isSelected = true
//                if item.isSelected {
//                    item.isSelected = false
//                }
//                else {
//                    item.isSelected = true
//                }
//            }
//        }
    }
    
//    func getSelectedObject() ->  [AppointmentTimeSlotModel]? {
//        let arrTemp = self.arrList.filter { (obj) -> Bool in
//            return obj.isSelected
//        }
//        return arrTemp
//    }
    
    func managePagenation(colView: UICollectionView,
                          clinic_id: String,
                          doctor_id: String,
                          consulation_type: String,
                          appointment_date: String,
                          index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        self.appointment_time_slotAPI(clinic_id: clinic_id,
                                                      doctor_id: doctor_id,
                                                      consulation_type: consulation_type,
                                                      appointment_date: appointment_date,
                                                      colView: colView,
                                                      withLoader: false) { [weak self] (isDone) in
                            guard let self = self else {return}
                            
                            self.vmResultList.value = .success(nil)
                            colView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
//MARK: ---------------- API For TopicList CALL ----------------------
extension VideoAppointmentVM {
    
    func apiCallSubmit(vc: UIViewController,
                       clinic_id: String,
                       doctor_id: String,
                       consulation_type: String,
                       appointment_date: String,
                       time_slot: String) {
        
        // Check validation
        if let error = self.isValidView(clinic_id: clinic_id,
                                        doctor_id: doctor_id,
                                        consulation_type: consulation_type,
                                        appointment_date: appointment_date,
                                        time_slot: time_slot){
            
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        /*
         {
         "clinic_id": "string",
         "doctor_id": "string",
         "consulation_type": "clinic",
         "appointment_date": "string",
         "time_slot": "string"
         }
         */
        
        var params                      = [String : Any]()
        params["clinic_id"]             = clinic_id
        params["doctor_id"]             = doctor_id
        params["consulation_type"]      = consulation_type
        params["appointment_date"]      = appointment_date
        params["time_slot"]             = time_slot
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.doctor(.add_appointment), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in

            switch result {
            case .success(let response):

                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    Alert.shared.showSnackBar(response.message)
                    
                    self.appointmentListModel = AppointmentListModel(fromJson: response.data)
                    self.vmResult.value = .success(nil)
                    break

                case .emptyData:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .inactiveAccount:

                    //self.loginResult.value = .failure(.custom(errorDescription: apiData.message))
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
                default:break
                }
                break

            case .failure(let error):

                Alert.shared.showSnackBar(error.localizedDescription)
                break

            }
        }
    }
    
    @objc func apiCallFromStart(refreshControl: UIRefreshControl? = nil,
                                colView: UICollectionView? = nil,
                                clinic_id: String,
                                doctor_id: String,
                                consulation_type: String,
                                appointment_date: String,
                                withLoader: Bool = false) {
        
        
        
//        self.arrListTopicList.removeAll()
        
        self.object                 = AppointmentTimeSlotModel()
        colView?.reloadData()
        self.page                   = 1
        self.isNextPage             = true
        
        //API Call
        self.appointment_time_slotAPI(clinic_id: clinic_id,
                                      doctor_id: doctor_id,
                                      consulation_type: consulation_type,
                                      appointment_date: appointment_date,
                                      colView: colView,
                                      withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultList.value = .success(nil)
            colView?.reloadData()
            if isLoaded {
                
            }
        }
    }
    
    func appointment_time_slotAPI(clinic_id: String,
                                  doctor_id: String,
                                  consulation_type: String,
                                  appointment_date: String,
                                  colView: UICollectionView? = nil,
                                  withLoader: Bool,
                                  completion: ((Bool) -> Void)?){
        
        /*
         {
           "clinic_id": "string",
           "doctor_id": "string",
           "consulation_type": "clinic",
           "appointment_date": "string"
         }
         */
        
        
        var params                      = [String : Any]()
        params["clinic_id"]             = clinic_id
        params["doctor_id"]             = doctor_id
        params["consulation_type"]      = consulation_type
        params["appointment_date"]      = appointment_date
        
        //params["page"]                  = self.pageTopicList
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.doctor(.appointment_time_slot), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [AppointmentTimeSlotModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
//                    returnVal = true
//                    self.arrList.removeAll()
//                    arr = AppointmentTimeSlotModel.modelsFromDictionaryArray(array: response.data.arrayValue)
//                    self.arrList.append(contentsOf: arr)
                    self.object = AppointmentTimeSlotModel(fromJson: response.data)
                    colView?.reloadData()
                
                    break
                case .emptyData:
                    self.strErrorMessage = response.message
                    //Alert.shared.showSnackBar(response.message)
                    
//                    returnVal = true
//                    self.isNextPage = false
//
//                    if self.page <= 1 {
//                        self.strErrorMessage = response.message
//                        self.arrList.removeAll()
//                        colView?.reloadData()
                        
                        //GFunction.shared.addErrorLabel(view: self.view, errorMessage: response.message)
                        //GFunction.shared.showSnackBar(response.message)
//                    }
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
                
                self.strErrorMessage = error.localizedDescription
                completion?(returnVal)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
