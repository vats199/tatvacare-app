//
//  NotificationListVC.swift
//  SM Company
//
//  Created by Hyperlink on 13/12/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class IncidentHistoryDetailTblCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblQuestion      : UILabel!
    @IBOutlet weak var lblQuestionValue : UILabel!
    @IBOutlet weak var lblAns           : UILabel!
    @IBOutlet weak var lblAnsValue      : UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblQuestion.font(name: .medium, size: 17)
            .textColor(color: UIColor.themePurple)
        self.lblQuestionValue.font(name: .medium, size: 17)
            .textColor(color: UIColor.themeBlack)
        
        self.lblAns.font(name: .light, size: 15)
            .textColor(color: UIColor.themePurple)
        self.lblAnsValue.font(name: .light, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            
//            self.vwBg.cornerRadius(cornerRadius: 7)
//            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
//
//            self.imgView.layoutIfNeeded()
//            self.imgView.cornerRadius(cornerRadius: 5)
        }
    }
}

class IncidentHistoryDetailVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var lblDuration      : UILabel!
    @IBOutlet weak var lblDurationValue : UILabel!
    
    @IBOutlet weak var lblImprove       : UILabel!
    @IBOutlet weak var lblImproveValue  : UILabel!
    
    @IBOutlet weak var tblView          : UITableView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    var incident_tracking_master_id = ""
    var patient_incident_add_rel_id = ""
    var object = IncidentHistoryDetailModel()
    
    var arrDaysOffline : [JSON] = []
    var arrLanguage : [JSON] = [
        [
            "img": "healthKit",
            "name": "Apple Health Fit",
            "type": enumAccountSetting.profile.rawValue,
            "isSelected": 0
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
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        
        self.lblDuration
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblDurationValue
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.lblImprove
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblImproveValue
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.configureUI()
        self.manageActionMethods()
        
        self.vwBg.isHidden = true
        GlobalAPI.shared.get_incident_list_by_add_rel_idAPI(incident_tracking_master_id: self.incident_tracking_master_id,
                                                            patient_incident_add_rel_id: self.patient_incident_add_rel_id) { [weak self] (isDone, obj, msg) in
            guard let self = self else {return}
            
            if isDone {
                self.vwBg.isHidden = false
                self.object = obj
                self.setData()
                self.tblView.reloadData()
                
                var params              = [String: Any]()
                params[AnalyticsParameters.survey_id.rawValue] = self.object.questionOccurance.surveyId
                params[AnalyticsParameters.occurIncidentTrackingMasterId.rawValue] = self.object.questionOccurance.occurIncidentTrackingMasterId
                
                FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_DETAIL_INCIDENT_PAGE,
                                         screen: .IncidentDetails,
                                         parameter: params)
            }
        }
        
    }
    
    @objc func updateAPIData(){
    }
    
    //Desc:- Set layout desing customize
    func configureUI(){
    
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
//        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
//        self.tblView.addSubview(self.refreshControl)
           
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        
    }
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        
        WebengageManager.shared.navigateScreenEvent(screen: .IncidentDetails)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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

}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension IncidentHistoryDetailVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.object.quesAnsList != nil {
            return self.object.quesAnsList.count
        }
        else {
            return 0
        }
        
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : IncidentHistoryDetailTblCell = tableView.dequeueReusableCell(withClass: IncidentHistoryDetailTblCell.self, for: indexPath)
 
        let object                  = self.object.quesAnsList[indexPath.row]
        cell.lblQuestionValue.text  = object.question.htmlToString
        cell.lblAnsValue.text       = object.answer.htmlToString
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension IncidentHistoryDetailVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themeBlack]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Set data Method --------------------------
extension IncidentHistoryDetailVC {
    
    func setData(){
//        let time = GFunction.shared.convertDateFormate(dt: self.object.questionOccurance.durationUpdatedAt,
//                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
//                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
//                                                       status: .LOCAL)
        
        let time = GFunction.shared.convertDateFormate(dt: self.object.questionOccurance.durationUpdatedAt,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        
        
        self.lblTitle.text          = time.0
        self.lblDuration.text       = self.object.questionOccurance.durationQuestion
        self.lblDurationValue.text  = self.object.questionOccurance.durationAnswer + " " + AppMessages.Min
        self.lblImprove.text        = self.object.questionOccurance.occurQuestion
        self.lblImproveValue.text   = self.object.questionOccurance.occurAnswer
    }
}
