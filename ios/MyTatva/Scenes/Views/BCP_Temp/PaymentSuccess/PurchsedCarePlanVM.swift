//
//  PurchsedCarePlanVM.swift
//  MyTatva
//
//  Created by 2022M43 on 08/06/23.
//

import Foundation
enum ServiceType {
    case Time
    case Slot
    case Device
}

class PurchsedCareModel {
    
    var imgService: String!
    var strServiceName: String!
    var strServiceDesc: String!
    var type: ServiceType
    
    init(imgService: String = "", strServiceName: String, strServiceDesc: String, type: ServiceType ) {
        self.imgService = imgService
        self.strServiceName = strServiceName
        self.strServiceDesc = strServiceDesc
        self.type = type
    }
}

class PurchsedCarePlanVM: NSObject {
    
    //MARK: Class Variables
    private var arrServiceData: [PurchsedCareModel] = []
    var planDetails: PlanDetail!
    private(set) var isResult = Bindable<JSON>()
    
    //MARK: Init
    override init() {
        super.init()
    }
    
    //MARK: Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
    //MARK: Custom Methods
}

//------------------------------------------------------
//MARK: - DataMethods
extension PurchsedCarePlanVM {
    
    func numberOfCount() -> Int { self.arrServiceData.count }
    func listOfRows(_ indx: Int) -> PurchsedCareModel { self.arrServiceData[indx] }
    
}

//------------------------------------------------------
//MARK: - WSMethods
extension PurchsedCarePlanVM {
    
    func getCarePlanService() {
        
        ApiManager.shared.makeRequest(method: .patient_plans(.care_plan_services), parameter: ["patient_plan_rel_id":self.planDetails.patientPlanRelId ?? ""]) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.success(let apiResponse):
                
                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    
                    if self.planDetails.planMasterId.isEmpty {
                        self.planDetails = PlanDetail(fromJson: apiResponse.data["plan_details"])
                    }
                    
                    self.arrServiceData = [PurchsedCareModel(imgService: "ic_labtest", strServiceName: "Book Lab Test", strServiceDesc: "Select Date & Time For Sample Collection", type: .Time),
                                           PurchsedCareModel(imgService: "ic_appointment",strServiceName: "Book Appointment", strServiceDesc: "With Nutritionist & Physiotherapist", type: .Slot),
                                           PurchsedCareModel(imgService: "ic_devices",strServiceName: "Devices", strServiceDesc: "View All Health Details", type: .Device)]
                    
                    if !apiResponse.data["my_devices"].boolValue {
                        self.arrServiceData = self.arrServiceData.filter({ $0.type != .Device })
                    }
                    
                    if !apiResponse.data["appointment"].boolValue {
                        self.arrServiceData = self.arrServiceData.filter({ $0.type != .Slot })
                    }
                    
                    if !apiResponse.data["diagnostic_tests"].boolValue {
                        self.arrServiceData = self.arrServiceData.filter({ $0.type != .Time })
                    }
                    
                    self.isResult.value = apiResponse.data
                    
                default:
                    Alert.shared.showSnackBar(apiResponse.message, isError: true, isBCP: true)
                }
                
                print(apiResponse.data)
            case .failure(_):
                debugPrint("Error")
            }
        }
        
    }
    
}
