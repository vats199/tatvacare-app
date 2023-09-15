//
//  FoodQuantityHelpVM.swift
//  MyTatva
//
//  Created by hyperlink on 27/10/21.
//

import Foundation

class FoodQuantityHelpVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                      = 1
    var isNextPage                = true
    var arrData           : [JSON] = [
        [
            "name" : "English",
            "isSelected": 1,
        ],[
            "name" : "Hindi",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ]
    ]
    
    var strErrorMessage : String     = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
}

//MARK: ---------------- Update Quantity Data ----------------------
extension FoodQuantityHelpVM {
    
    func getCount() -> Int {
        return self.arrData.count
    }
    
    func getObject(index: Int) -> JSON {
        return self.arrData[index]
    }
    
    func manageNotificationPagenation(colView: UICollectionView,index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrData.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrData.count > 0 {
                        
                        self.quantityListAPI(colView: colView,
                                            withLoader: false) { (isDone) in
                            self.vmResult.value = .success(nil)
                            colView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}

//MARK: ---------------- API CALL FOR QUANTITY TYPE ----------------------
extension FoodQuantityHelpVM {
    
    @objc func apiCallFromStart(colView: UICollectionView,refreshControl: UIRefreshControl? = nil,
                                withLoader: Bool = false) {
        
//        self.arrGoal.removeAll()
//        self.arrReading.removeAll()
        
        self.page              = 1
        self.isNextPage        = true
        
        //API Call
        self.quantityListAPI(colView:colView,withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            
            UIView.animate(withDuration: 1) {
                colView.reloadData()
            }
            
            if isLoaded {
                
            }
            else {
               
            }
        }
    }
    
    
    func quantityListAPI(colView: UICollectionView,withLoader: Bool,
                        completion: ((Bool) -> Void)?){
        
        let params              = [String : Any]()
        
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
//
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.combine(.contactUs), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                  //  self.arrNotification.removeAll()
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPage = false
                    
                    if self.page <= 1 {
                        self.strErrorMessage = response.message
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
                case .simpleUpdateAlert:
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

