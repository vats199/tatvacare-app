
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation
import UIKit

class DiscoverEngageVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResultTopicList = Bindable<Result<String?, AppError>>()
    var pageTopicList                           = 1
    var isNextPageTopicList                     = true
    var arrListTopicList                        = [TopicListModel]()
    var strErrorMessageTopicList : String       = ""
    
    private(set) var vmResultContentList = Bindable<Result<String?, AppError>>()
    var pageContentList                         = 1
    var isNextPageContentList                   = true
    var arrListContentList                      = [ContentListModel]()
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
extension DiscoverEngageVM {
    
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
extension DiscoverEngageVM {
    
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
        
        
        let params                      = [String : Any]()
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
extension DiscoverEngageVM {
    
    func getCountContentList() -> Int {
        return self.arrListContentList.count
    }
    
    func getObjectContentList(index: Int) -> ContentListModel {
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
                                     genre_ids: [String]? = [],
                                     topic_ids: [String]? = [],
                                     languages_id: [String]? = [],
                                     content_types: [String]? = [],
                                     recommended_health_doctor: Bool,
                                     index: Int){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if index == self.arrListContentList.count - 1 {
                if self.isNextPageContentList {
                    self.pageContentList += 1
                    
                    if self.arrListContentList.count > 0 {
                        
                        if let tbl = tblView {
                            tbl.addBottomIndicator()
                        }
                        
                        self.contentListAPI(tblView: tblView,
                                            withLoader: withLoader,
                                            search: search,
                                            genre_ids: genre_ids,
                                            topic_ids: topic_ids,
                                            languages_id: languages_id,
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
        }
    }
}

//MARK: ---------------- Enage Content List API ----------------------
extension DiscoverEngageVM {
    
    @objc func apiCallFromStart_ContentList(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false,
                                search: String,
                                genre_ids: [String]? = [],
                                topic_ids: [String]? = [],
                                languages_id: [String]? = [],
                                recommended_health_doctor: Bool,
                                content_types: [String]? = []) {
        
        self.pageContentList                = 1
        self.isNextPageContentList          = true
        self.strErrorMessageContentList     = ""
//        self.arrListContentList.removeAll()
//        tblView?.reloadData()
        
        //API Call
        self.contentListAPI(tblView: tblView,
                            withLoader: withLoader,
                            search: search,
                            genre_ids: genre_ids,
                            topic_ids: topic_ids,
                            languages_id: languages_id,
                            content_types: content_types,
                            recommended_health_doctor: recommended_health_doctor) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultContentList.value = .success(nil)
            //tblView?.reloadSections([0], with: .automatic)
            if isLoaded {
            }
        }
    }
    
    
    func contentListAPI(tblView: UITableView? = nil,
                        withLoader: Bool,
                        search: String,
                        genre_ids: [String]? = [],
                        topic_ids: [String]? = [],
                        languages_id: [String]? = [],
                        content_types: [String]? = [],
                        recommended_health_doctor: Bool,
                        completion: ((Bool) -> Void)?){
        
        /*
         
         "page": "string",
         "genre_ids": "string",
         "topic_ids": "string",
         "languages_id": "string",
         "content_types": "string"
       }
         */
        
        var params                      = [String : Any]()
        params["page"]                  = self.pageContentList
        params["search"]                = search
        params["genre_ids"]             = genre_ids
        params["topic_ids"]             = topic_ids
        params["languages_id"]          = languages_id
        params["content_types"]         = content_types
        params["recommended_health_doctor"] = recommended_health_doctor
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.content_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [ContentListModel]()
            
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
                        self.strErrorMessageContentList     = ""
                    }
                    
                    arr = ContentListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
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
