
//
//  Created by 2020M03 on 16/06/21.
//

import Foundation

class ExerciseMoreVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResultContentList = Bindable<Result<String?, AppError>>()
    var pageContentList                         = 1
    var isNextPageContentList                   = true
    var arrListContentList                      = [ExerciseMoreListModel]()
    var strErrorMessageContentList : String     = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
}


//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
//MARK: ---------------- Update Content Data ----------------------
extension ExerciseMoreVM {
    
    func getCountContentList() -> Int {
        return self.arrListContentList.count
    }
    
    func getObjectContentList(index: Int) -> ExerciseMoreListModel {
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
                                     exercise_tools: [String]? = [],
                                     fitness_level: [String]? = [],
                                     show_time: [String]? = [],
                                     index: Int){
        
        if index == self.arrListContentList.count - 1 {
            if self.isNextPageContentList {
                self.pageContentList += 1
                
                if self.arrListContentList.count > 0 {
                    
                    self.contentListAPI(tblView: tblView,
                                        withLoader: withLoader,
                                        search: search,
                                        genre_ids: genre_ids,
                                        exercise_tools: exercise_tools,
                                        fitness_level: fitness_level, show_time: show_time) { [weak self] (isDone) in
                        guard let self = self else {return}
                        
                        tblView?.reloadData()
                        refreshControl?.endRefreshing()
                        self.vmResultContentList.value = .success(nil)
                    }
                }
            }
        }
    }
}


//MARK: ---------------- Enage Content List API ----------------------
extension ExerciseMoreVM {
    
    @objc func apiCallFromStart(refreshControl: UIRefreshControl? = nil,
                                tblView: UITableView? = nil,
                                withLoader: Bool = false,
                                search: String,
                                genre_ids: [String]? = [],
                                exercise_tools: [String]? = [],
                                show_time: [String]? = [],
                                fitness_level: [String]? = []) {
        
        self.pageContentList                = 1
        self.isNextPageContentList          = true
        self.strErrorMessageContentList     = ""
        
        //API Call
        self.contentListAPI(tblView: tblView,
                            withLoader: withLoader,
                            search: search,
                            genre_ids: genre_ids,
                            exercise_tools: exercise_tools,
                            fitness_level: fitness_level,
                            show_time: show_time) { (isLoaded) in
            
            refreshControl?.endRefreshing()
            self.vmResultContentList.value = .success(nil)
            //tblView?.reloadData()
            if isLoaded {
            }
        }
    }
    
    
    func contentListAPI(tblView: UITableView? = nil,
                        withLoader: Bool,
                        search: String,
                        genre_ids: [String]? = [],
                        exercise_tools: [String]? = [],
                        fitness_level: [String]? = [],
                        show_time: [String]? = [],
                        completion: ((Bool) -> Void)?){
        
        /*
         {
         {"page":"1","genre_ids":["21c7a54c-36ea-11ec-ae06-4ec4eb4dc0dd"],"exercise_tools":["Equipment"],"fitness_level":["Beginner"],"show_time":"30+"}
         }
         */
        
        var params                      = [String : Any]()
        params["page"]                  = self.pageContentList
        params["search"]                = search
        params["exercise_tools"]        = exercise_tools
        params["fitness_level"]         = fitness_level
        params["genre_ids"]             = genre_ids
        params["show_time"]             = show_time
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" && obj.value as? [String] != [] {
                return true
            }
            else {
                return false
            }
        })
        
        print(JSON(params))
        
        ApiManager.shared.makeRequest(method: ApiEndPoints.content(.exercise_list), methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (result) in
            
            var returnVal           = false
            var arr                 = [ExerciseMoreListModel]()
            
            switch result {
            case .success(let response):
                
                switch response.apiCode {
                case .invalidOrFail:
                    self.strErrorMessageContentList = response.message
                    self.isNextPageContentList = false
                    if self.pageContentList <= 1 {
                        self.arrListContentList.removeAll()
                    }
                    break
                case .success:
                    
                    returnVal = true
                    if self.pageContentList <= 1 {
                        self.arrListContentList.removeAll()
                    }
                    
                    arr = ExerciseMoreListModel.modelsFromDictionaryArray(array: response.data.arrayValue)
                    self.arrListContentList.append(contentsOf: arr)
                    
                    break
                case .emptyData:
                    
                    returnVal = true
                    self.isNextPageContentList = false
                    if self.pageContentList <= 1 {
                        self.strErrorMessageContentList = response.message
                        self.arrListContentList.removeAll()
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
                self.isNextPageContentList = false
                self.strErrorMessageContentList = error.localizedDescription
                completion?(returnVal)
                //Alert.shared.showSnackBar(error.localizedDescription)
                break
                
            }
        }
    }
}
