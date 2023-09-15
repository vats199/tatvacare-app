//
//  ViewAllBookmarkVC.swift
//  MyTatva
//
//  Created by hyperlink on 14/10/21.
//

import UIKit

class ViewAllBookmarkVC: WhiteNavigationBaseVC {

    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var tblView      : UITableView!
    
    //----------------------------------------------------------------------------
    
    //MARK:- Class Variables
    
    let viewModel                   = ViewAllBoormarkVM()
    let refreshControl              = UIRefreshControl()
    var type                        = ""
    var strErrorMessage : String    = ""
    var timerSearch                 = Timer()
    
    var currentBookmarkType = ""
    var arrData : [JSON] = [
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
    
    //----------------------------------------------------------------------------
    
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    
    //MARK: - Life cycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
        self.setupViewModelObserver()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .AllBookmark)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = .default
        self.updateAPIData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //----------------------------------------------------------------------------
    
    //MARK:- Custome Methods
    
    func setUpView(){
        
        self.lblTitle.text = self.currentBookmarkType
        
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
      
    }
    
    @objc func updateAPIData(){
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.viewModel.apiCallFromStart_ContentList(refreshControl: self.refreshControl,
                                                            tblView: self.tblView,
                                                            withLoader: false,
                                                            type: self.type)
            }
        }
    }
    
    //----------------------------------------------------------------------------
    
}


//MARK:- UITableView delegate and datasource Methods

extension ViewAllBookmarkVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCountContentList()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : BookmarkContentCell = tableView.dequeueReusableCell(withClass: BookmarkContentCell.self, for: indexPath)
        
        let object = self.viewModel.getObjectContentList(index: indexPath.row)
        
        cell.imgTitle.alpha = 0
        if object.media.count > 0 {
            cell.imgTitle.alpha = 1
            cell.imgTitle.setCustomImage(with: object.media[0].imageUrl)
        }
        
        cell.lblTitle.text = object.title
        let start_Time = GFunction.shared.convertDateFormate(dt: object.updatedAt,
                                                           inputFormat:  DateTimeFormaterEnum.UTCFormat.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                           status: .NOCONVERSION)
        cell.lblTime.text = start_Time.0
        
        if object.contentType == "AskAnExpert" {
            cell.imgTitle.isHidden = true
        }
        else {
            cell.imgTitle.isHidden = false
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.viewModel.getObjectContentList(index: indexPath.row)
        if object.contentType == "ExerciseVideo" {
            if object.media.count > 0 {
                kGoalMasterId = ""
                GFunction.shared.openVideoPlayer(strUrl: object.media[0].mediaUrl,
                                                 content_master_id: object.contentMasterId,
                                                 content_type: object.contentType)
                
                var param = [String : Any]()
                param[AnalyticsParameters.content_master_id.rawValue]   = object.contentMasterId
                param[AnalyticsParameters.content_type.rawValue]        = object.contentType
                FIRAnalytics.FIRLogEvent(eventName: .USER_PLAY_VIDEO_EXERCISE,
                                         screen: .VideoPlayer,
                                         parameter: nil)
            }
        }
        else if object.contentType == "AskAnExpert" {
            let vc = AskExpertQuestionDetailsVC.instantiate(fromAppStoryboard: .engage)
            vc.contentMasterId = object.contentMasterId
            vc.completionHandler = { obj in
                if obj != nil {
                    if obj!.contentMasterId != nil {
                        
                        //self.viewModel.arrListContentList[index] = obj!
                        self.tblView.reloadData()
                    }
                    else {
                        //self.updateAPIData(withLoader: true)
                    }
                }
                else {
                    //self.updateAPIData(withLoader: true)
                }
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = EngageContentDetailVC.instantiate(fromAppStoryboard: .engage)
            vc.contentMasterId = object.contentMasterId
            vc.completionHandler = { obj in
                if obj != nil {
                    if vc.object.contentMasterId != nil {
                        self.viewModel.arrListContentList[indexPath.row] = vc.object
                        self.tblView.reloadData()
                    }
                }
            }
            //vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.managePagenationContentList(refreshControl: self.refreshControl,
                                                   tblView: self.tblView,
                                                   withLoader: false,
                                                   type: self.type,
                                                   index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension ViewAllBookmarkVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension ViewAllBookmarkVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResultContentList.bind(observer: { (result) in
            switch result {
            case .success(_):
                
                self.strErrorMessage = self.viewModel.strErrorMessageContentList
                self.tblView.reloadData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
