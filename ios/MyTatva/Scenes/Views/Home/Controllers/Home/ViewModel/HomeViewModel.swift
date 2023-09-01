
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

enum userType {
    case user
    case bussiness
}



class HomeViewModel {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    private(set) var vmResultPollQuiz = Bindable<Result<String?, AppError>>()
    
    var pageSummary                         = 1
    var isNextPageSummary                   = true
    var arrGoal                             = [GoalListModel]()
    var arrReading                          = [ReadingListModel]()
    
    var strErrorMessageGoal : String        = ""
    var strErrorMessageReading : String     = ""
   
    var pagePollQuiz                        = 1
    var isNextPagePollQuiz                  = true
    var arrPollQuiz                         = [PollQuizModel]()
    var strErrorMessagePollQuiz : String    = ""
    
    var arrStayInformed                     = [ContentListModel]()
    var arrRecommended                      = [ContentListModel]()
    var arrBookTestList                     = [BookTestListModel]()
    
    var exercise_done                       = false
    var breathing_done                      = false
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Goal Data ----------------------
extension HomeViewModel {
    
    func getGoalCount() -> Int {
        return self.arrGoal.count
    }
    
    func getGoalObject(index: Int) -> GoalListModel {
        return self.arrGoal[index]
    }
    
    func manageGoalPagenation(tblViewHome: UITableView?,
                              colViewHome: UICollectionView?,
                              colView1CarePlan: UICollectionView?,
                              colView2CarePlan: UICollectionView?,
                              colView3CarePlan: UICollectionView?,
                              index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrGoal.count - 1 {
                if self.isNextPageSummary {
                    self.pageSummary += 1
                    
                    if self.arrGoal.count > 0 {
                        
                        self.goalReadingAPI(tblViewHome: tblViewHome,
                                            colViewHome: colViewHome,
                                            colView1CarePlan: colView1CarePlan,
                                            colView2CarePlan: colView2CarePlan,
                                            colView3CarePlan: colView3CarePlan,
                                            withLoader: false) { [weak self] (isDone) in
                            guard let self = self else {return}
                            
                            self.vmResult.value = .success(nil)
                            colViewHome?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}

//MARK: ---------------- Update Reading Data ----------------------
extension HomeViewModel {
    
    func getReadingCount() -> Int {
        return self.arrReading.count
    }
    
    func getReadingObject(index: Int) -> ReadingListModel {
        return self.arrReading[index]
    }
    
    func manageReadingPagenation(tblViewHome: UITableView?,
                                 colViewHome: UICollectionView?,
                                 colView1CarePlan: UICollectionView?,
                                 colView2CarePlan: UICollectionView?,
                                 colView3CarePlan: UICollectionView?,
                              index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrReading.count - 1 {
                if self.isNextPageSummary {
                    self.pageSummary += 1
                    
                    if self.arrReading.count > 0 {
                        
                        self.goalReadingAPI(tblViewHome: tblViewHome,
                                            colViewHome: colViewHome,
                                            colView1CarePlan: colView1CarePlan,
                                            colView2CarePlan: colView2CarePlan,
                                            colView3CarePlan: colView3CarePlan,
                                            withLoader: false) { [weak self] (isDone) in
                            guard let self = self else {return}
                            self.vmResult.value = .success(nil)
                            colViewHome?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}

//MARK: ---------------- API CALL FOR SUMMARY ----------------------
extension HomeViewModel {
    
    @objc func apiCallFromStartSummary(tblViewHome: UITableView? = nil,
                                       colViewHome: UICollectionView? = nil,
                                       colView1CarePlan: UICollectionView? = nil,
                                       colView2CarePlan: UICollectionView? = nil,
                                       colView3CarePlan: UICollectionView? = nil,
                                refreshControl: UIRefreshControl? = nil,
                                withLoader: Bool = false) {
        
//        self.arrGoal.removeAll()
//        self.arrReading.removeAll()
        
        self.pageSummary               = 1
        self.isNextPageSummary         = true
        
        //API Call
        self.goalReadingAPI(tblViewHome: tblViewHome,
                            colViewHome: colViewHome,
                            colView1CarePlan: colView1CarePlan,
                            colView2CarePlan: colView2CarePlan,
                            colView3CarePlan: colView3CarePlan,
                           withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResult.value = .success(nil)
            
            DispatchQueue.main.async {
                tblViewHome?.reloadData()
                tblViewHome?.layoutIfNeeded()
                
                colViewHome?.reloadData()
                colViewHome?.layoutIfNeeded()
                
                colView1CarePlan?.reloadData()
                colView1CarePlan?.layoutIfNeeded()
                
                colView2CarePlan?.reloadData()
                colView2CarePlan?.layoutIfNeeded()
                
                colView3CarePlan?.reloadData()
                colView3CarePlan?.layoutIfNeeded()
            }
            
            if isLoaded {
            }
            else {
            }
        }
    }
    
    
    func goalReadingAPI(tblViewHome: UITableView?,
                        colViewHome: UICollectionView?,
                        colView1CarePlan: UICollectionView?,
                        colView2CarePlan: UICollectionView?,
                        colView3CarePlan: UICollectionView?,
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
                    
                    returnVal = true
                    self.arrGoal.removeAll()
                    arr1 = GoalListModel.modelsFromDictionaryArray(array: response.data["goals"].arrayValue)
                    self.arrGoal.append(contentsOf: arr1)
                    
                    self.arrReading.removeAll()
                    arr2 = ReadingListModel.modelsFromDictionaryArray(array: response.data["readings"].arrayValue).filter({ !(ReadingType(rawValue: $0.keys)?.isSprirometerVital ?? false) })
                    self.arrReading.append(contentsOf: arr2)
                    
                    let mark_as_today = response.data["mark_as_today"]
                    self.exercise_done = mark_as_today["exercise_done"].stringValue == "Y" ? true : false
                    self.breathing_done = mark_as_today["breathing_done"].stringValue == "Y" ? true : false
                    
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

//MARK: ---------------- API CALL FOR SUMMARY ----------------------
extension HomeViewModel {
}

//MARK: ---------------- Update Reading Data ----------------------

extension HomeViewModel{
    
    func getPollQuizCount() -> Int {
        return self.arrPollQuiz.count
    }
    
    func getPollQuizObject(index: Int) -> PollQuizModel {
        return self.arrPollQuiz[index]
    }
    
    func managePollQuizPagenation(colView: UICollectionView,
                              index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrPollQuiz.count - 1 {
                if self.isNextPagePollQuiz {
                    self.pagePollQuiz += 1
                    
                    if self.arrPollQuiz.count > 0 {
                        
                        self.pollQuizListAPI(colView: colView, withLoader: false){ [weak self] (isDone) in
                            guard let self = self else {return}
                            self.vmResultPollQuiz.value = .success(nil)
                            colView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
    
}

//MARK: ---------------- API CALL FOR POLL & QUIZ ----------------------
extension HomeViewModel{
    
    ///  get_poll_quiz API
    func pollQuizListAPI(colView: UICollectionView,
                         withLoader: Bool = false,completion: ((Bool) -> Void)?){
        
        let params              = [String : Any]()
        
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.survey(.get_poll_quiz), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    self.vmResultPollQuiz.value = .success(nil)
                    
                    self.arrPollQuiz.removeAll()
                    
                    let arr1 = PollQuizModel.modelsFromDictionaryArray(array: response.data["poll_data"].arrayValue)
                    let arr2 = PollQuizModel.modelsFromDictionaryArray(array: response.data["quiz_data"].arrayValue)
                    
                    self.arrPollQuiz.append(contentsOf: arr1)
                    self.arrPollQuiz.append(contentsOf: arr2)
                   
                    break
                case .emptyData:
//                    self.vmResultPollQuiz.value = .success(nil)
//                    returnVal = true
//                    self.isNextPagePollQuiz = false
//
//                    if self.pagePollQuiz <= 1 {
//                        self.strErrorMessagePollQuiz = response.message
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
                
                self.vmResultPollQuiz.value = .failure(AppError.custom(errorDescription: error.localizedDescription))
                break
                
            }
        }
    }
    
    /// add_quiz_answers API
    func add_quiz_answersAPI(quiz_master_id: String,survey_id : String,Score : String,quiz_data : [[String: Any]],
                                 completion: ((Bool, String) -> Void)?){
        
        /*{
          "quiz_master_id": "string",
          "survey_id": "string",
          "score": "string",
          "quiz_data": "string"
        }*/
        
        var params                      = [String : Any]()
        params["quiz_master_id"]        = quiz_master_id
        params["survey_id"]             = survey_id
        params["score"]                 = Score
        params["quiz_data"]             = quiz_data
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.survey(.add_quiz_answers), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            var msg     = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
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
                print(error.localizedDescription)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }

    
    ///  add_poll_answers API
    func add_poll_answersAPI(poll_master_id: String,survey_id : String,poll_data : [[String: Any]],
                                 completion: ((Bool, String) -> Void)?){
        
        /*{
         "quiz_master_id": "string",
           "survey_id": "string",
           "poll_data": "string"
        }*/
        
        var params = [String : Any]()
        params["poll_master_id"] = poll_master_id
        params["survey_id"] = survey_id
        params["poll_data"] = poll_data
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.survey(.add_poll_answers), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
//            {
//              "message" : "Poll result add successfully.",
//              "data" : true,
//              "code" : "1"
//            }
            var msg     = ""
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
                    msg = response.message
                    //Alert.shared.showSnackBar(response.message)
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
                print(error.localizedDescription)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

//MARK: ---------------- Update Stay Informed ----------------------
extension HomeViewModel{
    
    func getStayInformedCount() -> Int {
        return self.arrStayInformed.count
    }
    
    func getStayInformedObject(index: Int) -> ContentListModel {
        return self.arrStayInformed[index]
    }
    
}

//MARK: ---------------- API CALL Stay Informed ----------------------
extension HomeViewModel{
    
    func stay_informedAPI(colView: UICollectionView,
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
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.stay_informed), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal   = false
                var arr         = [ContentListModel]()
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    self.arrStayInformed.removeAll()
                    arr = ContentListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrStayInformed.append(contentsOf: arr)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                        colView.layoutIfNeeded()
                        colView.reloadData()
                        colView.layoutIfNeeded()
                    }
                    
                    break
                case .emptyData:
                    
//                    returnVal = true
//                    self.isNextPageSummary = false
//
//                    if self.pageSummary <= 1 {
//                        self.strErrorMessageGoal = response.message
//                        self.strErrorMessageReading = response.message
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
                
                print(error.localizedDescription)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

//MARK: ---------------- Update recommended content ----------------------
extension HomeViewModel{
    
    func getRecommendedCount() -> Int {
        return self.arrRecommended.count
    }
    
    func getRecommendedObject(index: Int) -> ContentListModel {
        return self.arrRecommended[index]
    }
    
}

//MARK: ---------------- API CALL recommended content ----------------------
extension HomeViewModel{
    
    func recommended_contentAPI(colView: UICollectionView,
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
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.recommended_content), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal   = false
                var arr         = [ContentListModel]()
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    self.arrRecommended.removeAll()
                    arr = ContentListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrRecommended.append(contentsOf: arr)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                        colView.layoutIfNeeded()
                        colView.reloadData()
                        colView.layoutIfNeeded()
                    }
                    break
                case .emptyData:
                    
//                    returnVal = true
//                    self.isNextPageSummary = false
//
//                    if self.pageSummary <= 1 {
//                        self.strErrorMessageGoal = response.message
//                        self.strErrorMessageReading = response.message
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
                print(error.localizedDescription)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

//MARK: ---------------- Update Test Lists ----------------------
extension HomeViewModel{
    
    func getTestListCount() -> Int {
        return self.arrBookTestList.count
    }
    
    func getTestListObject(index: Int) -> BookTestListModel {
        return self.arrBookTestList[index]
    }
}

//MARK: ---------------- API CALL FOR Test Lists ----------------------
extension HomeViewModel{
    
    ///  get_poll_quiz API
    func tests_list_homeAPI(colView: UICollectionView,
                            separate: String,
                            withLoader: Bool = false,
                            completion: ((Bool) -> Void)?){
        
        var params              = [String : Any]()
        params["separate"]      = separate
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.tests(.tests_list_home), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal           = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
//                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    //self.vmResultPollQuiz.value = .success(nil)
                    
                    self.arrBookTestList.removeAll()
                    let arr = BookTestListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrBookTestList.append(contentsOf: arr)
                   
                    break
                case .emptyData:
//                    self.vmResultPollQuiz.value = .success(nil)
//                    returnVal = true
//                    self.isNextPagePollQuiz = false
//
//                    if self.pagePollQuiz <= 1 {
//                        self.strErrorMessagePollQuiz = response.message
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
                print(error.localizedDescription)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

//------------------------------------------------------
//MARK: - PushViewController
extension HomeViewModel {
    func showDeviceConnectPopUp() {
        guard !UserModel.shared.height.isEmpty else {
            Alert.shared.showAlert(Bundle.appName(), actionOkTitle: AppMessages.add, actionCancelTitle: AppMessages.cancel, message: "Enter your height") { [weak self] isDone in
                guard let self = self, isDone else { return }
                let vc = AddWeightHeightVC.instantiate(fromAppStoryboard: .auth)
                vc.isEdit = true
                vc.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        var params = [String:Any]()
        params[AnalyticsParameters.medical_device.rawValue] = kBCA
        FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKS_ON_CONNECT,
                                 screen: .Home,
                                 parameter: params)
        
//        let vc = DeviceAskingPopupVC.instantiate(fromAppStoryboard: .home)
        let vc = ConnectBCAPopUp.instantiate(fromAppStoryboard: .bca)
        vc.completion = { [weak self] isDone in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                let vc = BCPCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        vc.isFromHome = true
        vc.details = UserModel.shared.devices.first(where: {$0.key == "bca"})
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .overFullScreen
        navi.modalTransitionStyle = .crossDissolve
        UIApplication.topViewController()?.present(navi, animated: true)
    }
}
