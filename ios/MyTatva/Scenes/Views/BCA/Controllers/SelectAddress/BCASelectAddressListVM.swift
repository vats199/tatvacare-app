//
//  BCASelectAddressListViewModel.swift
//  MyTatva
//
//  Created Hyperlink on 29/05/23.
//  Copyright © 2023. All rights reserved.


import Foundation
import UIKit

class BCASelectAddressListVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList             = [LabAddressListModel]()
    private(set) var isListChanged      = Bindable<Bool>()
    var strErrorMessage : String    = ""
    var cpDetails: CarePlanDetailsModel!
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Data ----------------------
extension BCASelectAddressListVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> LabAddressListModel {
        return self.arrList[index]
    }
    
    func manageSelection(index: Int) {
        let object = self.arrList[index]
        for item in self.arrList {
            item.isSelected = false
            if item.patientAddressRelId == object.patientAddressRelId {
                item.isSelected = true
            }
        }
    }
    
    func updateEditView(index: Int,isNewEditClick: Bool = false) {
        if isNewEditClick {
            self.arrList.forEach({ $0.isShowEdit = false })
        }        
        self.arrList[index].isShowEdit = !self.arrList[index].isShowEdit
    }
    
    func getSelectedObject() ->  LabAddressListModel? {
        let arrTemp = self.arrList.filter { (obj) -> Bool in
            return obj.isSelected
        }
        return arrTemp.first
    }
    
    func getSelectedInt() -> Int {
        for i in 0..<self.arrList.count {
            if self.arrList[i].isSelected {
                return i+1
            }
        }
        return 0
    }
    
  
}

//------------------------------------------------------
//MARK: - WSMethods
extension BCASelectAddressListVM {
    
    func getAddressList() {
        GlobalAPI.shared.addressListAPI { [weak self] arr in
            guard let self = self else { return }
            self.arrList.removeAll()
            self.arrList = arr
            self.isListChanged.value = true
        }
    }
    
    //MARK: ---------------- delete_address API ----------------------
    func delete_addressAPI(address_id: String,
                           completion: ((Bool) -> Void)?){
        //email
        
        var params              = [String : Any]()
        params["address_id"]    = address_id
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.delete_address), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    
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
                
                completion?(returnVal)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
}




