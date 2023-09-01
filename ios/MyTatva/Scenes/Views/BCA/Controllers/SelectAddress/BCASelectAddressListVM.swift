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
        
        var params              = [String : Any]()
        params[AnalyticsParameters.bottom_sheet_name.rawValue]            = "select address"
        params[AnalyticsParameters.address_number.rawValue]               = "\(index + 1)"
        params[AnalyticsParameters.address_type.rawValue]                 = object.addressType
                                
        FIRAnalytics.FIRLogEvent(eventName: .SELECT_ADDRESS,
                                 screen: .SelectAddressBottomSheet,
                                 parameter: params)
        
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
    
}




