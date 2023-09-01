
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation
import UIKit

class SelectLabTestAppointmentVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [TimeSlot]()
    var arrFilteredList             = [TimeSlot]()
    var strErrorMessage : String    = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Data ----------------------
extension SelectLabTestAppointmentVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> TimeSlot {
        return self.arrList[index]
    }
    
    func manageSelection(index: Int) {
//        let object = self.arrFilteredList[index]
//        for item in self.arrFilteredList {
//            item.isSelected = false
//            if item.id == object.id {
//                item.isSelected = true
//            }
//        }
    }
    
//    func getSelectedObject() ->  TimeSlot? {
//        let arrTemp = self.arrFilteredList.filter { (obj) -> Bool in
//            return obj.isSelected
//        }
//        return arrTemp.first
//    }
    
    func managePagenation(colView: UICollectionView,
                          pincode: String,
                          date: String,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        self.get_appointment_slotsListAPI(colView: colView,
                                                          pincode: pincode,
                                                          date: date,
                                                          withLoader: false) { [weak self] (isDone) in
                            guard let self = self else {return}
                            self.vmResult.value = .success(nil)
                            colView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
//    func manageSearch(keyword: String,
//                      tblView: UITableView) {
//        if keyword.trim() == "" {
//            self.arrFilteredList = self.arrList
//            tblView.reloadData()
//        }
//        else {
//            self.arrFilteredList = self.arrList.filter({ return $0.slot.lowercased().contains(keyword.lowercased())})
//            tblView.reloadData()
//        }
//    }
}

//MARK: ---------------- API CALL ----------------------
extension SelectLabTestAppointmentVM {
    
    @objc func apiCallFromStart(refreshControl: UIRefreshControl? = nil,
                                colView: UICollectionView? = nil,
                                pincode: String,
                                date: String,
                                withLoader: Bool = false) {
        
        
        
        self.arrList.removeAll()
        colView?.reloadData()
        self.page               = 1
        self.isNextPage         = true
        
        //API Call
        self.get_appointment_slotsListAPI(colView: colView,
                                          pincode: pincode,
                                          date: date,
                                          withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            
            self.arrFilteredList = self.arrList
            colView?.reloadData()
            if isLoaded {
            }
            else {
            }
        }
    }
    
    func get_appointment_slotsListAPI(colView: UICollectionView? = nil,
                                      pincode: String,
                                      date: String,
                                      withLoader: Bool,
                                      completion: ((Bool) -> Void)?){
        
        /*
         {
           "Pincode": 300322,
           "Date": "2022-04-04"
         }
         */
        
        var params                  = [String : Any]()
        params["Pincode"]           = pincode
        params["Date"]              = date
        //params["page"]            = self.page
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.get_appointment_slots), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [TimeSlot]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
//                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    arr = TimeSlot.modelsFromDictionaryArray(array: response.data.arrayValue)
//                    arr = LabTestSlotModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList = arr
                    colView?.reloadData()
                
                    break
                case .emptyData:
                    self.strErrorMessage = response.message
                    
//                    returnVal = true
//                    self.isNextPage = false
//
//                    if self.page <= 1 {
//                        self.strErrorMessage = response.message
//                        self.arrList.removeAll()
//                        colView?.reloadData()
//
//                        //GFunction.shared.addErrorLabel(view: self.view, errorMessage: response.message)
//                        //GFunction.shared.showSnackBar(response.message)
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
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
}

