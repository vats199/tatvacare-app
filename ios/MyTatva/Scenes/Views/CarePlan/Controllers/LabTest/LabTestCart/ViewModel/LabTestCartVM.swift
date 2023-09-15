//
//  NotificationVM.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import Foundation

class LabTestCartVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    private var arrTest = [BcpTestsList]()
    private(set) var isTest = Bindable<Bool>()
    private(set) var isCartChanges = Bindable<Bool>()
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//------------------------------------------------------
//MARK: - CallMethods
extension LabTestCartVM {
    
    func numberOfSections() -> Int { self.arrTest.count }
    func listOfSec(_ sec:Int) -> BcpTestsList { self.arrTest[sec] }
    func numberOfRows(_ sec:Int) -> Int { self.arrTest[sec].bcpTestsList.count - 1 }
    func listOfRow(_ ip:IndexPath) -> BcpTestsList { self.arrTest[ip.section].bcpTestsList[ip.row] }
    func getLastTest(_ sec:Int) -> BcpTestsList? { return self.arrTest[sec].bcpTestsList.last }
    func getFirstTest(_ sec:Int) -> BcpTestsList? { return self.arrTest[sec].bcpTestsList.first }
    func getBCPAddressData() -> LabAddressListModel? { return self.arrTest.first(where: { JSON($0.isBcpTestsAdded as Any).boolValue })?.bcpAddressData }
}

//MARK: ---------------- API CALL FOR SUMMARY ----------------------
extension LabTestCartVM {
    
    func cartTestListAPI(withLoader: Bool,
                         completion: ((Bool, CartListModel) -> Void)?){
        
        /*
         {
         "type": "all", "package", "test"
         "page": 1,
         "search": "string"
         }
         */
        
        var params              = [String : Any]()
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.list_cart), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var object              = CartListModel()
            switch result {
            case .success(let response):
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    CartListModel.shared    = CartListModel(fromJson: response.data)
                    object                  = CartListModel.shared
                    
                    self.vmResult.value     = .success(nil)
                    
                    //                    self.arrTest = object.bcpTestsList + [object.testsList]
                    
                    //                    if !self.arrTest.isEmpty {
                    //                        self.arrTest.removeAll()
                    //                        self.isTest.value = true
                    //                    }
                    //
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    var cartTest = JSON()
                    cartTest["bcp_tests_list"] = response.data["tests_list"]
                    let tempTests = BcpTestsList(fromJson: cartTest)
                    tempTests.isLabTest = true
                    tempTests.bcpTestsList = tempTests.bcpTestsList.filter({ $0.type != kBCP })
                    self.arrTest = object.bcpTestsList
                    
                    if tempTests.bcpTestsList.count >= 1 {
                        self.arrTest.append(tempTests)
                    }
                    self.isTest.value = true
                    //                    }
                    
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
                completion?(returnVal, object)
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.localizedDescription)
                break
            }
        }
    }
    
    func updateBCPCart(_ sec:Int) {
        
        var params = [String:Any]()
        params["bcp_flag"] = "Y"
        params["code"] = self.arrTest[sec].bcpTestsList.map({ JSON($0.code as Any).stringValue }).joined(separator: ",")
        params["patient_plan_rel_id"] = self.arrTest[sec].patientPlanRelId
        ApiManager.shared.makeRequest(method: .tests(JSON(self.arrTest[sec].isBcpTestsAdded as Any).boolValue ? .remove_from_cart : .add_to_cart), parameter: params) { [weak self] result in
            guard let self = self else { return }
            self.isCartChanges.value = true
            switch result{                
            case.success(let apiResponse):
                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                default:
                    Alert.shared.showSnackBar(apiResponse.message)
                }
                
                print(apiResponse.data)
            case .failure(_):
                debugPrint("Error")
            }
        }
        
    }
    
}

