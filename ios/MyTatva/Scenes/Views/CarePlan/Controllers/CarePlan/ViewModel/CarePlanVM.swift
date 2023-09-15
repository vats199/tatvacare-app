
//

import Foundation


class CarePlanVM {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    private(set) var vmResultPrescription = Bindable<Result<String?, AppError>>()
    
    var pageSummary                     = 1
    var isNextPageSummary               = true
    var arrGoal                         = [GoalListModel]()
    var arrReading                      = [ReadingListModel]()
    var dietDetailsModel                = DietDetailsModel()
    var strErrorMessageGoal : String    = ""
    var strErrorMessageReading : String = ""
    
    var pagePrescription                = 1
    var isNextPagePrescription          = true
    var arrPrescription                 = [PrecriptionListModel]()
    var strErrorMessagePrescription : String = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Goal Data ----------------------
extension CarePlanVM {
    
    func getGoalCount() -> Int {
        return self.arrGoal.count
    }
    
    func getGoalObject(index: Int) -> GoalListModel {
        return self.arrGoal[index]
    }
    
    func manageGoalPagenation(colView1: UICollectionView,
                              colView2: UICollectionView,
                              colView3: UICollectionView,
                              index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrGoal.count - 1 {
                if self.isNextPageSummary {
                    self.pageSummary += 1
                    
                    if self.arrGoal.count > 0 {
                        
                        self.goalReadingAPI(colView1: colView1,
                                            colView2: colView2,
                                            colView3: colView3,
                                            withLoader: false) { [weak self] (isDone) in
                            guard let self = self else {return}
                            self.vmResult.value = .success(nil)
//                            colView1.reloadData()
//                            colView2.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}

//MARK: ---------------- Update Reading Data ----------------------
extension CarePlanVM {
    
    func getReadingCount() -> Int {
        return self.arrReading.count
    }
    
    func getReadingObject(index: Int) -> ReadingListModel {
        return self.arrReading[index]
    }
    
    func manageReadingPagenation(colView1: UICollectionView,
                                 colView2: UICollectionView,
                                 colView3: UICollectionView,
                                 index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrReading.count - 1 {
                if self.isNextPageSummary {
                    self.pageSummary += 1
                    
                    if self.arrReading.count > 0 {
                        
                        self.goalReadingAPI(colView1: colView1,
                                            colView2: colView2,
                                            colView3: colView3,
                                            withLoader: false) { [weak self] (isDone) in
                            guard let self = self else {return}
                            self.vmResult.value = .success(nil)
//                            colView1.reloadData()
//                            colView2.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}

//MARK: ---------------- Update Prescription Data ----------------------
extension CarePlanVM {
    
    func getPrescriptionCount() -> Int {
        return self.arrPrescription.count
    }
    
    func getPrescriptionObject(index: Int) -> PrecriptionListModel {
        return self.arrPrescription[index]
    }
    
    func managePrescriptionPagenation(tblView: UITableView,
                                      index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrPrescription.count - 1 {
                if self.isNextPagePrescription {
                    self.pagePrescription += 1
                    
                    if self.arrPrescription.count > 0 {
                        
                        self.prescriptionListAPI(tblView: tblView,
                                                 withLoader: false) { (isLoaded) in
                            self.vmResultPrescription.value = .success(nil)
                            tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}

//MARK: ---------------- API CALL FOR SUMMARY ----------------------
extension CarePlanVM {
    
    @objc func apiCallFromStartSummary(colView1: UICollectionView,
                                       colView2: UICollectionView,
                                       colView3: UICollectionView,
                                       refreshControl: UIRefreshControl? = nil,
                                       withLoader: Bool = false) {
        
        //        self.arrGoal.removeAll()
        //        self.arrReading.removeAll()
        
        self.pageSummary               = 1
        self.isNextPageSummary         = true
        
        //API Call
        self.goalReadingAPI(colView1: colView1,
                            colView2: colView2,
                            colView3: colView3,
                            withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            
//            colView1.reloadData()
//            colView2.reloadData()
//            colView3.reloadData()
            
            if isLoaded {
                
            }
            else {
                
            }
        }
    }
    
    
    func goalReadingAPI(colView1: UICollectionView,
                        colView2: UICollectionView,
                        colView3: UICollectionView,
                        withLoader: Bool,
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
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.goalReading(.daily_summary), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                var arr1                = [GoalListModel]()
                var arr2                = [ReadingListModel]()
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    
                    self.arrGoal.removeAll()
                    arr1 = GoalListModel.modelsFromDictionaryArray(array: response.data["goals"].arrayValue)
                    self.arrGoal.append(contentsOf: arr1)
                    
                    self.arrReading.removeAll()
                    arr2 = ReadingListModel.modelsFromDictionaryArray(array: response.data["readings"].arrayValue).filter({ !(ReadingType(rawValue: $0.keys)?.isSprirometerVital ?? false) })
                    self.arrReading.append(contentsOf: arr2)
                    
                    self.dietDetailsModel = DietDetailsModel(fromJson: response.data["diet"])
                    returnVal = true
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageSummary = false
                    
                    if self.pageSummary <= 1 {
                        self.strErrorMessageGoal = response.message
                        self.strErrorMessageReading = response.message
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
                print(error.localizedDescription)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

//MARK: ---------------- API CALL FOR Prescription ----------------------
extension CarePlanVM {
    
    @objc func apiCallFromStart_Prescription(tblView: UITableView,
                                       refreshControl: UIRefreshControl? = nil,
                                       withLoader: Bool = false) {
        
        //        self.arrGoal.removeAll()
        //        self.arrReading.removeAll()
        
        self.pagePrescription             = 1
        self.isNextPagePrescription       = true
        
        //API Call
        self.prescriptionListAPI(tblView: tblView,
                                 withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultPrescription.value = .success(nil)
            tblView.reloadData()
            
            if isLoaded {
            }
            else {
                
            }
        }
    }
    
    
    func prescriptionListAPI(tblView: UITableView,
                             withLoader: Bool,
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
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.patient(.prescription_medicine_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                var arr1                = [PrecriptionListModel]()
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    self.arrPrescription.removeAll()
                    arr1 = PrecriptionListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrPrescription.append(contentsOf: arr1)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPagePrescription = false
                    
                    if self.pagePrescription <= 1 {
                        self.strErrorMessagePrescription = response.message
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
                print(error.localizedDescription)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
