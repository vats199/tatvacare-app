
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation
import UIKit

class AskExpertQuestionDetailsVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult                   = Bindable<Result<String?, AppError>>()
    var contentDetails                          = AskExpertListModel()
    
    private(set) var vmResultAnsList            = Bindable<Result<String?, AppError>>()
    var pageAnsList                             = 1
    var isNextPageAnsList                       = true
    var arrListAnsList                          = [AskExpertAnsListModel]()
    var strErrorMessageAnsList : String         = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}

//MARK: ---------------- Update Content Data ----------------------
extension AskExpertQuestionDetailsVM {
    
    func getCount() -> Int {
        return self.arrListAnsList.count
    }
    
    func getObject(index: Int) -> AskExpertAnsListModel {
        return self.arrListAnsList[index]
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
                          content_master_id: String,
                          top_answer_id: String,
                          index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
            if index == self.arrListAnsList.count - 1 {
                if self.isNextPageAnsList {
                    self.pageAnsList += 1
                    
                    if self.arrListAnsList.count > 0 {
                        
                        if let tbl = tblView {
                            tbl.addBottomIndicator()
                        }
                        
                        self.answers_listAPI(tblView: tblView,
                                             withLoader: withLoader,
                                             content_master_id: content_master_id,
                                             top_answer_id: top_answer_id) { [weak self] (isDone) in
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
extension AskExpertQuestionDetailsVM {
    
    func question_detailAPI(tblView: UITableView? = nil,
                            withLoader: Bool,
                            content_master_id: String){
        
        /*
         content_master_id: String
          
         }
         */
        
        var params                      = [String : Any]()
        params["content_master_id"]       = content_master_id
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.question_detail), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    self.contentDetails = AskExpertListModel(fromJson: response.data)
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
}

//MARK: ---------------- Ans List API ----------------------
extension AskExpertQuestionDetailsVM {
    
    @objc func apiCallFromStart_AnswerList(refreshControl: UIRefreshControl? = nil,
                                           tblView: UITableView? = nil,
                                           withLoader: Bool = false,
                                           content_master_id: String,
                                           top_answer_id: String) {
        
        self.pageAnsList                    = 1
        self.isNextPageAnsList              = true
        self.strErrorMessageAnsList         = ""
        self.arrListAnsList.removeAll()
        tblView?.reloadData()
        
        //API Call
        self.answers_listAPI(tblView: tblView,
                            withLoader: withLoader,
                             content_master_id: content_master_id,
                             top_answer_id: top_answer_id) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultAnsList.value = .success(nil)
            tblView?.reloadData()
            if isLoaded {
            }
        }
    }
    
    func answers_listAPI(tblView: UITableView? = nil,
                         withLoader: Bool,
                         content_master_id: String,
                         top_answer_id: String,
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
        params["page"]                  = self.pageAnsList
        params["content_master_id"]     = content_master_id
        params["top_answer_id"]         = top_answer_id
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.answers_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [AskExpertAnsListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessageAnsList = response.message
//                    Alert.shared.showSnackBar(response.message)
                    break
                case .success:
                    
                    returnVal = true
                    if self.pageAnsList <= 1 {
                        self.arrListAnsList.removeAll()
                        tblView?.reloadData()
                        self.strErrorMessageAnsList     = ""
                    }
                    
                    arr = AskExpertAnsListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrListAnsList.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageAnsList = false
                    
                    if self.pageAnsList <= 1 {
                        self.strErrorMessageAnsList = response.message
                        self.arrListAnsList.removeAll()
                        
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
                
                self.strErrorMessageAnsList = error.localizedDescription
                completion?(returnVal)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
