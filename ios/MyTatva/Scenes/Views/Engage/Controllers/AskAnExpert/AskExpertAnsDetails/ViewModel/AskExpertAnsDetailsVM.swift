
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation
import UIKit

class AskExpertAnsDetailsVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult                   = Bindable<Result<String?, AppError>>()
    var askExpertAnsModel                       = AskExpertAnsListModel()
    var askExpertListModel                      = AskExpertListModel()
    
    private(set) var vmResultAnsList            = Bindable<Result<String?, AppError>>()
    var page                                    = 1
    var isNextPage                              = true
    var arrList                                 = [AskExpertAnsCommentModel]()
    var strErrorMessage : String                = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Content Data ----------------------
extension AskExpertAnsDetailsVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getObject(index: Int) -> AskExpertAnsCommentModel {
        return self.arrList[index]
    }
    
    func manageSelection(index: Int) {
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
    
    func managePagenation(tblView: UITableView? = nil,
                          withLoader: Bool = false,
                          answer_id: String,
                          index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
            if index == self.arrList.count - 1 {
                if self.isNextPage {
                    self.page += 1
                    
                    if self.arrList.count > 0 {
                        
                        if let tbl = tblView {
                            tbl.addBottomIndicator()
                        }
                        
                        self.answer_commentsAPI(tblView: tblView,
                                                withLoader: withLoader,
                                                answer_id: answer_id) { [weak self] (isDone) in
                            guard let self = self else {return}
                            
                            self.vmResultAnsList.value = .success(nil)
                            //tblView?.reloadData()
                            if let tbl = tblView {
                                tbl.removeBottomIndicator()
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: ---------------- question_detail API ----------------------
extension AskExpertAnsDetailsVM {
    
    func answer_detailAPI(tblView: UITableView? = nil,
                          withLoader: Bool,
                          content_comments_id: String){
        
        /*
         content_master_id: String
          
         }
         */
        
        var params                      = [String : Any]()
        params["content_comments_id"]             =                           content_comments_id
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.answer_detail), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    self.askExpertAnsModel      = AskExpertAnsListModel(fromJson: response.data["answer"])
                    self.askExpertListModel     = AskExpertListModel(fromJson: response.data["question"])
                    self.vmResult.value = .success(nil)
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
                break
                
            case .failure(let error):
               
                Alert.shared.showSnackBar(error.localizedDescription)
                break
            }
        }
    }
    
    //Add comment api
    func update_commentAPI(answer_id: String,
                           content_master_id: String,
                           description: String,
                           isEdit: Bool,
                           content_comments_id: String? = "",
                           completion: ((Bool, AskExpertAnsCommentModel) -> Void)?){
        
        
        /*
         {
           "answer_id": "string",
           "content_master_id": "string",
           "description": "string",
           "content_comments_id": "string"
         }
         */
        
        var params                      = [String : Any]()
        params["answer_id"]             = answer_id
        params["content_master_id"]     = content_master_id
        params["description"]           = description
        
        if isEdit {
            params["content_comments_id"]   = content_comments_id // only for edit
        }
        
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.update_answer_reply), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var obj                 = AskExpertAnsCommentModel()
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
//                    var params = [String: Any]()
//                    params[AnalyticsParameters.content_master_id.rawValue] = content_master_id
//                    params[AnalyticsParameters.content_type.rawValue]      = content_type
//                    FIRAnalytics.FIRLogEvent(eventName: .USER_COMMENTED, parameter: params)
                    
                    obj = AskExpertAnsCommentModel(fromJson: response.data)
                    returnVal = true
                    
                    break
                case .emptyData:
                    returnVal = false
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
                
                completion?(returnVal, obj)
                break
                
            case .failure(let error):
                
                self.strErrorMessage = error.localizedDescription
                completion?(returnVal, obj)
                Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}

//MARK: ---------------- Ans List API ----------------------
extension AskExpertAnsDetailsVM {
    
    @objc func apiCallFromStart_AnswerList(refreshControl: UIRefreshControl? = nil,
                                           tblView: UITableView? = nil,
                                           withLoader: Bool = false,
                                           answer_id: String) {
        
        self.page                    = 1
        self.isNextPage              = true
        self.strErrorMessage         = ""
        self.arrList.removeAll()
        tblView?.reloadData()
        
        //API Call
        self.answer_commentsAPI(tblView: tblView,
                            withLoader: withLoader,
                                answer_id: answer_id) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultAnsList.value = .success(nil)
            tblView?.reloadData()
            if isLoaded {
            }
        }
    }
    
    func answer_commentsAPI(tblView: UITableView? = nil,
                            withLoader: Bool,
                            answer_id: String,
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
        params["page"]                  = self.page
        params["answer_id"]             = answer_id
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.answer_comments), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [AskExpertAnsCommentModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessage = response.message
//                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    if self.page <= 1 {
                        self.arrList.removeAll()
                        tblView?.reloadData()
                        self.strErrorMessage     = ""
                    }
                    
                    arr = AskExpertAnsCommentModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrList.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPage = false
                    
                    if self.page <= 1 {
                        self.strErrorMessage = response.message
                        self.arrList.removeAll()
                        
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
                
                self.strErrorMessage = error.localizedDescription
                completion?(returnVal)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
