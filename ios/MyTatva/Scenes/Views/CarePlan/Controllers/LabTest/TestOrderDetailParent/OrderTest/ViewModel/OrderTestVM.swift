//
//  RecordsVM.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import Foundation

class OrderTestVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [AppointmentListModel]()
    var strErrorMessage : String    = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Record Data ----------------------
extension OrderTestVM {
    
    func getAppointmentCount() -> Int {
        return self.arrList.count
    }
    
    func getAppointmentObject(index: Int) -> AppointmentListModel {
        return self.arrList[index]
    }
    
    func manageAppointmentPagenation(forToday: Bool,
                                     tblView: UITableView?,
                                     index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        if let tbl = tblView {
                            tbl.addBottomIndicator()
                        }
                        
                        self.AppointmentListAPI(forToday: forToday,
                                                tblView: tblView,
                                                withLoader: false) { [weak self] (isDone) in
                            guard let self = self else {return}
                            self.vmResult.value = .success(nil)
                            
                            if let tbl = tblView {
                                tbl.removeBottomIndicator()
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: ---------------- API CALL FOR SUMMARY ----------------------
extension OrderTestVM {
    
    @objc func apiCallFromStart_Appointment(forToday: Bool,
                                            tblView: UITableView?,
                                      refreshControl: UIRefreshControl? = nil,
                                      withLoader: Bool = false) {
        
        self.arrList.removeAll()
        tblView?.reloadData()
        
        self.page              = 1
        self.isNextPage        = true
        
        //API Call
        self.AppointmentListAPI(forToday: forToday,
                                tblView: tblView,
                                withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            
            
            UIView.animate(withDuration: 1) {
                tblView?.reloadData()
            }
            
            self.vmResult.value = .success(nil)
            if isLoaded {
            }
        }
    }
    
    func AppointmentListAPI(forToday: Bool,
                            tblView: UITableView?,
                            withLoader: Bool,
                            completion: ((Bool) -> Void)?){
        
        var params              = [String : Any]()
        params["page_no"]       = self.page
        
        var api_name = ApiEndPoints.doctor(.get_appointment_list)
        if forToday {
            api_name = ApiEndPoints.doctor(.todays_appointment)
        }
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })

        print(JSON(params))
        ApiManager.shared.makeRequest(method: api_name, methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [AppointmentListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    if forToday {
                        arr = AppointmentListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    }
                    else {
                        arr = AppointmentListModel.modelsFromDictionaryArray(array: response.data["appointment_list"].arrayValue)
                    }
                    
                    self.arrList.append(contentsOf: arr)
                    tblView?.reloadData()
                    break
                case .emptyData:
                    returnVal = true
                    self.isNextPage = false
                    
                    if self.page <= 1 {
                        self.strErrorMessage = response.message
                        self.arrList.removeAll()
                        tblView?.reloadData()
                        
                        //GFunction.shared.addErrorLabel(view: self.view, errorMessage: response.message)
                        //GFunction.shared.showSnackBar(response.message)
                    }
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
    
    //MARK: --------------- cancel Appointment API ----------------------
    func cancelAppointmentAPI(appointment_id: String,
                                          clinic_id: String,
                                          doctor_id: String,
                                          type_consult: String,
                                          appointment_date: String,
                                          appointment_slot: String,
                                          completion: ((Bool, String) -> Void)?){
        
        /*
         {
           "appointment_id": "string",
           "clinic_id": "string",
           "doctor_id": "string",
           "type_consult": "clinic",
           "appointment_date": "string",
           "appointment_slot": "string"
         }
         */
        
        var params                      = [String : Any]()
        params["appointment_id"]        = appointment_id
        params["clinic_id"]             = clinic_id
        params["doctor_id"]             = doctor_id
        params["type_consult"]          = type_consult
        params["appointment_date"]      = appointment_date
        params["appointment_slot"]      = appointment_slot
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.doctor(.cancel_appointment), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var msg     = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    msg = response.message
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    msg = response.message
                    Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    Alert.shared.showSnackBar(response.message)
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
                
                completion?(returnVal, msg)
                break
                
            case .failure(let error):
                msg = error.localizedDescription
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
