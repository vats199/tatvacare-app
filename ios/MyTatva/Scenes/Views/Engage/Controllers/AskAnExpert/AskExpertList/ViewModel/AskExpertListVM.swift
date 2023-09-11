
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation
import UIKit

class AskExpertListVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResultTopicList = Bindable<Result<String?, AppError>>()
    var pageTopicList                           = 1
    var isNextPageTopicList                     = true
    var arrListTopicList                        = [TopicListModel]()
    var strErrorMessageTopicList : String       = ""
    
    private(set) var vmResultContentList = Bindable<Result<String?, AppError>>()
    var pageContentList                         = 1
    var isNextPageContentList                   = true
    var arrListContentList                      = [AskExpertListModel]()
    var strErrorMessageContentList : String     = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Topic Data ----------------------
extension AskExpertListVM {
    
    func getCountTopicList() -> Int {
        return self.arrListTopicList.count
    }
    
    func getObjectTopicList(index: Int) -> TopicListModel {
        return self.arrListTopicList[index]
    }
    
    func manageSelectionTopicList(index: Int) {
       let object = self.arrListTopicList[index]

        for item in self.arrListTopicList {
            //item.isSelected = false
            if item.topicMasterId == object.topicMasterId {
                //item.isSelected = true
                if item.isSelected {
                    item.isSelected = false
                }
                else {
                    item.isSelected = true
                }
            }
        }
    }
    
    func getSelectedObjectTopicList() ->  [TopicListModel]? {
        let arrTemp = self.arrListTopicList.filter { (obj) -> Bool in
            return obj.isSelected
        }
        return arrTemp
    }
    
    func managePagenationTopicList(colView: UICollectionView,
                          index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrListTopicList.count - 1 {
                if self.isNextPageTopicList {
                    self.pageTopicList += 1
                    
                    if self.arrListTopicList.count > 0 {
                        
                        self.TopicListAPI(colView: colView,
                                          withLoader: false) { [weak self] (isDone) in
                            guard let self = self else {return}
                            
                            self.vmResultTopicList.value = .success(nil)
                            colView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
//MARK: ---------------- API For TopicList CALL ----------------------
extension AskExpertListVM {
    
    @objc func apiCallFromStart_TopicList(refreshControl: UIRefreshControl? = nil,
                                colView: UICollectionView? = nil,
                                withLoader: Bool = false) {
        
//        self.arrListTopicList.removeAll()
//        colView?.reloadData()
        self.pageTopicList               = 1
        self.isNextPageTopicList         = true
        
        //API Call
        self.TopicListAPI(colView: colView,
                                 withLoader: withLoader) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultTopicList.value = .success(nil)
            colView?.reloadData()
            if isLoaded {
                
            }
        }
    }
    
    
    func TopicListAPI(colView: UICollectionView? = nil,
                        withLoader: Bool,
                        completion: ((Bool) -> Void)?){
        
        let params          = [String : Any]()
        //params["page"]                  = self.pageTopicList
        
//        params = params.filter({ (obj) -> Bool in
//            if obj.value as? String != "" {
//                return true
//            }
//            else {
//                return false
//            }
//        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.topic_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [TopicListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessageTopicList = response.message
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    self.arrListTopicList.removeAll()
                    arr = TopicListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrListTopicList.append(contentsOf: arr)
                    colView?.reloadData()
                
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageTopicList = false
                    
                    if self.pageTopicList <= 1 {
                        self.strErrorMessageTopicList = response.message
                        self.arrListTopicList.removeAll()
                        colView?.reloadData()
                        
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
                
                self.strErrorMessageTopicList = error.localizedDescription
                completion?(returnVal)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
//MARK: ---------------- Update Content Data ----------------------
extension AskExpertListVM {
    
    func getCountContentList() -> Int {
        return self.arrListContentList.count
    }
    
    func getObjectContentList(index: Int) -> AskExpertListModel {
        return self.arrListContentList[index]
    }
    
    func manageSelectionContentList(index: Int) {
//       let object = self.arrListTopicList[index]
//
//        for item in self.arrListTopicList {
//            if item.topicMasterId == object.topicMasterId {
//                if item.isSelected {
//                    item.isSelected = false
//                }
//                else {
//                    item.isSelected = true
//                }
//            }
//        }
    }
    
    func managePagenationContentList(tblView: UITableView? = nil,
                                     refreshControl: UIRefreshControl? = nil,
                                     withLoader: Bool = false,
                                     search: String,
                                     filter_by_words: String,
                                     topic_ids: [String]? = [],
                                     languages_id: [String]? = [],
                                     question_types: [String]? = [],
                                     content_types: [String]? = [],
                                     recommended_health_doctor: Bool,
                                     index: Int){
        
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        if index == self.arrListContentList.count - 1 {
            if self.isNextPageContentList {
                self.pageContentList += 1
                
                if self.arrListContentList.count > 0 {
                    
                    if let tbl = tblView {
                        //tbl.addBottomIndicator()
                    }
                    
                    self.question_listAPI(tblView: tblView,
                                          withLoader: withLoader,
                                          search: search,
                                          filter_by_words: filter_by_words,
                                          topic_ids: topic_ids,
                                          languages_id: languages_id,
                                          question_types: question_types,
                                          content_types: content_types,
                                          recommended_health_doctor: recommended_health_doctor) { [weak self] (isDone) in
                        guard let self = self else {return}
                        
                        refreshControl?.endRefreshing()
                        self.vmResultContentList.value = .success(nil)
                        //tblView?.reloadData()
                        if let tbl = tblView {
                            tbl.removeBottomIndicator()
                        }
                    }
                }
            }
        }
        //        }
    }
}

//MARK: ---------------- Enage Content List API ----------------------
extension AskExpertListVM {
    
    @objc func apiCallFromStart_ContentList(refreshControl: UIRefreshControl? = nil,
                                            tblView: UITableView? = nil,
                                            withLoader: Bool = false,
                                            search: String,
                                            filter_by_words: String,
                                            topic_ids: [String]? = [],
                                            languages_id: [String]? = [],
                                            question_types: [String]? = [],
                                            recommended_health_doctor: Bool,
                                            content_types: [String]? = []) {
        
        self.pageContentList                = 1
        self.isNextPageContentList          = true
        self.strErrorMessageContentList     = ""
//        self.arrListContentList.removeAll()
//        tblView?.reloadData()
        
        //API Call
        self.question_listAPI(tblView: tblView,
                              withLoader: withLoader,
                              search: search,
                              filter_by_words: filter_by_words,
                              topic_ids: topic_ids,
                              languages_id: languages_id,
                              question_types: question_types,
                              content_types: content_types,
                              recommended_health_doctor: recommended_health_doctor) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultContentList.value = .success(nil)
            tblView?.reloadData()
            if isLoaded {
            }
        }
    }
    
    
    func question_listAPI(tblView: UITableView? = nil,
                          withLoader: Bool,
                          search: String,
                          filter_by_words: String,
                          topic_ids: [String]? = [],
                          languages_id: [String]? = [],
                          question_types: [String]? = [],
                          content_types: [String]? = [],
                          recommended_health_doctor: Bool,
                          completion: ((Bool) -> Void)?){
        
        /*
         
         {
         page*    integer
         topic_ids    [...]
         filter_by_words    string
         ask_by_you    string
         Enum:
         Array [ 2 ]
          
         }
         */
        
        var params                      = [String : Any]()
        params["page"]                  = self.pageContentList
        params["search"]                = search
        params["filter_by_words"]       = filter_by_words
        params["ask_by_you"]            = filter_by_words
        params["topic_ids"]             = topic_ids
        params["question_types"]        = question_types
//        params["languages_id"]          = languages_id
//        params["content_types"]         = content_types
//        params["recommended_health_doctor"] = recommended_health_doctor
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.question_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [AskExpertListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessageContentList = response.message
                    self.isNextPageContentList = false
//                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    if self.pageContentList <= 1 {
                        self.arrListContentList.removeAll()
                        tblView?.reloadData()
                        self.strErrorMessageContentList     = ""
                    }
                    
                    arr = AskExpertListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrListContentList.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageContentList = false
                    
                    if self.pageContentList <= 1 {
                        self.strErrorMessageContentList = response.message
                        self.arrListContentList.removeAll()
                        
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
                
                self.strErrorMessageContentList = error.localizedDescription
                completion?(returnVal)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

//MARK: ---------------- Report API ----------------------
extension AskExpertListVM {
    
    func reportPostAPICall(vc: UIViewController,
                 content_master_id: String,
                 content_type: String,
                 content_comments_id: String,
                 reported: String,
                 description: String,
                 report_type: String,
                           forQuestion: Bool,
                           isReport : Bool,completion : @escaping (Bool) -> Void) {
        
        // Check validation
        //        if let error = self.isValidView(vc: vc,
        //                                        date: date,
        //                                        time: time,
        //                                        quantity: quantity,
        //                                        container: container,
        //                                        goalListModel: goalListModel) {
        //
        //            //Set data for binding
        //            self.vmResult.value = .failure(error)
        //            return
        //        }
        
        /*
         {
         content_master_id*    string
         content_comments_id*    string
         reported*    string
         Y to report N to remove report
         
         Enum:
         Array [ 2 ]
         description    string
         Description of the report
         
         report_type*    string
         S - Spam, I - Inappropriate, F - False information
         
         Enum:
         Array [ 3 ]
         
         }
         */
        
        var api_name = ApiEndPoints.content(.content_report)
        var params                      = [String : Any]()
        
        if forQuestion {
            params["content_master_id"]     = content_master_id
            api_name = ApiEndPoints.content(.content_report)
        }
        else {
            params["content_comments_id"]   = content_comments_id
            api_name = ApiEndPoints.content(.report_answer_comment)
        }
        
        if isReport{
            params["reported"]              = reported
            params["description"]           = description
            params["report_type"]           = report_type
        }
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: api_name, methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                var returnVal = false
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    Alert.shared.showSnackBar(response.message)
                    var params = [String: Any]()
                    
                    if forQuestion {
                    }
                    else {
                    }
                    
                    //Alert.shared.showSnackBar(response.message)
                    break
                case .emptyData:
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
                completion(returnVal)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
            }
        }
    }
    
    //MARK: --------------- update_likes API ----------------------
    func update_likesOfAnswersAPI(content_comments_id: String,
                                  is_active: String,
                                  forComment: Bool,
                                  screen: ScreenName,
                                  completion: ((Bool, String) -> Void)?){
        
        /*
         {
           "content_master_id": "string",
           "is_active": "Y"
         }
         */
        
        if forComment {
            var params = [String: Any]()
            params[AnalyticsParameters.content_comments_id.rawValue] = content_comments_id
            
            if is_active == "Y" {
                FIRAnalytics.FIRLogEvent(eventName: .USER_LIKED_COMMENT,
                                         screen: screen,
                                         parameter: params)
            }
            else {
                FIRAnalytics.FIRLogEvent(eventName: .USER_UNLIKED_COMMENT,
                                         screen: screen,
                                         parameter: params)
            }
        }
        else {
            var params = [String: Any]()
            params[AnalyticsParameters.content_comments_id.rawValue] = content_comments_id
            
            if is_active == "Y" {
                FIRAnalytics.FIRLogEvent(eventName: .USER_LIKED_ANSWER,
                                         screen: screen,
                                         parameter: params)
            }
            else {
                FIRAnalytics.FIRLogEvent(eventName: .USER_UNLIKED_ANSWER,
                                         screen: screen,
                                         parameter: params)
            }
        }
       
        
        var params                      = [String : Any]()
        params["content_comments_id"]   = content_comments_id
        params["is_active"]             = is_active
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.answer_comment_update_like), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            var msg     = ""
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
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
    
    //MARK: --------------- delete related APIs ----------------------
    func deleteQuestionAnswersCommentsAPI(content_master_id: String,
                                          content_comments_id: String,
                                          type: ReportType,
                                          completion: ((Bool, String, AskExpertListModel) -> Void)?){
        
        /*
         {
           "content_master_id": "string",
           "is_active": "Y"
         }
         */
        
        var api_name = ApiEndPoints.content(.question_delete)
        var params                      = [String : Any]()
        switch type {
        
        case .contentComment:
            break
        case .question:
            api_name = ApiEndPoints.content(.question_delete)
            params["content_master_id"]     = content_master_id
            break
        case .answer:
            api_name = ApiEndPoints.content(.answer_delete)
            params["content_comments_id"]   = content_comments_id
            break
        case .answerComment:
            api_name = ApiEndPoints.content(.answer_delete)
            params["content_comments_id"]   = content_comments_id
            break
        }
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        ApiManager.shared.makeRequest(method: api_name, methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            var msg     = ""
            var obj     = AskExpertListModel()
            switch result {
            case .success(let response):
                
                var returnVal = false
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    returnVal = true
                    obj = AskExpertListModel(fromJson: response.data)
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
                
                completion?(returnVal, msg, obj)
                break
                
            case .failure(let error):
                
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

