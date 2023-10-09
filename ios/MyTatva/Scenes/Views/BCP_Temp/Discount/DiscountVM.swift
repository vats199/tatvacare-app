//
//  DiscountVM.swift
//  MyTatva
//
//  Created by 2022M43 on 22/08/23.
//

import Foundation

class DiscountVM: NSObject {
    //MARK: Outlet
    
    //MARK: Class Variables
    var arrList                     = [DiscountListModel]()
    var isFromLabTest               = false
    var discountData: DiscountListModel? = nil {
        didSet {
            if self.isFromLabTest {
                kDiscountData = self.discountData
            }
        }
    }
    
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

//MARK: - CallMethods
extension DiscountVM {
    
    func numberOfRows() -> Int { self.arrList.count }
    func listOfRow(_ index: Int) -> DiscountListModel { self.arrList[index] }
    func didSelectect(_ index: Int) {
        self.arrList[index].isSelected = !self.arrList[index].isSelected
    }
}

//MARK:- API Call

extension DiscountVM {
    
    func ApiDiscountList(withLoader: Bool,
                         discount_type: String,
                         price: String,
                         completion: ((Bool, String) -> Void)?) {
        
        
        var params              = [String : Any]()
        params["discount_type"]     = discount_type
        params["price"]             = price
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient_plans(.discount_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [DiscountListModel]()
            var msg                 = ""
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:
                    
                    returnVal = true
                    arr = DiscountListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    returnVal = true
                    msg = response.message
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
                
                completion?(returnVal, msg)
                break
                
            case .failure(let error):
                completion?(returnVal, msg)
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
                
            }
        }
    }
    
    func ApiCheckDiscountList(withLoader: Bool,
                              discounts_master_id: String,
                              price: String,
                              discount_Code: String,
                              completion: ((Bool, Int, Int, String) -> Void)?) {
        
        
        var params              = [String : Any]()
        params["discounts_master_id"]     = discounts_master_id
        params["price"]                   = price
        params["discount_code"]           = discount_Code
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient_plans(.check_discount), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var finalPrice          = 0
            var discountAmount      = 0
            var subHeading          = ""
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message, isError: true, isBCP: true)
                    break
                case .success:
                    returnVal = true
                    subHeading   = response.data["sub_heading_message"].stringValue
                    finalPrice   = response.data["final_price"].intValue
                    discountAmount   = response.data["discount_amount"].intValue
                    self.discountData =  DiscountListModel(fromJson: response.data["discount_code"])
                    break
                case .emptyData:
                    
                    returnVal = true
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
                
                completion?(returnVal, finalPrice, discountAmount, subHeading)
                break
                
            case .failure(let error):
                completion?(returnVal, finalPrice, discountAmount, subHeading)
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
                
            }
        }
    }
}
