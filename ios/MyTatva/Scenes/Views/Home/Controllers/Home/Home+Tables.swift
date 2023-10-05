import UIKit


class MyDevicesCell : UITableViewCell {
    
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblLastSync: UILabel!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var lblLungDeviceName: UILabel!
    @IBOutlet weak var lblLundDeviceDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblDeviceName.font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack).text = "Smart Analyser"
        
        self.lblLastSync.font(name: .light, size: 12)
            .textColor(color: UIColor.ThemeDarkGray)
       
        self.lblLungDeviceName.font(name: .medium, size: 13)
            .textColor(color: UIColor.lightGray).text = "Smart Analyser"
        
        self.lblLundDeviceDetails.font(name: .light, size: 12)
            .textColor(color: UIColor.lightGray)
        
        self.btnConnect.font(name: .medium, size: 11)
            .textColor(color: UIColor.themePurple)
            .setTitle("Connect", for: .normal)
        self.btnConnect.contentHorizontalAlignment = .right
        
        self.imgIcon.image = UIImage(named: "icon_BCA")
        
        self.vwBG.cornerRadius(cornerRadius: 10, clips: true).borderColor(color: .lightGray, borderWidth: 0.5)
        self.vwBG.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.ThemeDeviceShadow, shadowOpacity: 0.2)
    }
}

class SummaryTblCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var vwTitle          : UIView!
    @IBOutlet weak var vwTitleBg        : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var linearProgressBar: LinearProgressBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .bold, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .medium, size: 11)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            //self.vwBg.applyViewShadow(shadowOffset: CGSize.zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.2, shdowRadious: 5)
            
            self.imgView.layoutIfNeeded()
            self.imgView.cornerRadius(cornerRadius: 5)
            
            self.vwTitle.layoutIfNeeded()
            self.vwTitle.cornerRadius(cornerRadius: 5)
            self.vwTitle.applyViewShadow(shadowOffset: CGSize(width: 2, height: 3), shadowColor: UIColor.themeBlack, shadowOpacity: 0.2, shdowRadious: 0)
            
            self.vwTitleBg.layoutIfNeeded()
            self.vwTitleBg.cornerRadius(cornerRadius: 5)
        }
        self.setProgress(progressBar: self.linearProgressBar, color: UIColor.themeBlack)
    }
    
    func setProgress(progressBar: LinearProgressBar, color: UIColor){
        progressBar.trackColor          = UIColor.themeLightGray
        progressBar.trackPadding        = 0
        progressBar.capType             = 1
        
        switch progressBar {
        
        case self.linearProgressBar:
            progressBar.barThickness        = 10
            progressBar.barColor            = color
            
            progressBar.barColorForValue = { value in
                switch value {
                case 0..<20:
                    return color
                case 20..<60:
                    return color
                case 60..<80:
                    return color
                default:
                    return color
                }
            }
            
            break
       
        default: break
        }
    }
}

//MARK: -------------------------- TableView Methods --------------------------
extension HomeVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case self.tblDailySummary:
            if self.viewModel.getGoalCount() <= 4 {
                return self.viewModel.getGoalCount()
            }
            else {
                if self.btnViewMoreSummary.isSelected {
                    return self.viewModel.getGoalCount()
                }
                else {
                    return 4
                }
            }
        case self.tblMyDevices:
            return 1
        default:
            break
        }
        return 0
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        switch tableView {
        case self.tblDailySummary:
            
            let cell : SummaryTblCell = tableView.dequeueReusableCell(withClass: SummaryTblCell.self, for: indexPath)
            let object      = self.viewModel.getGoalObject(index: indexPath.row)//self.arrSummary[indexPath.row]
            
    //        cell.imgView.image          = UIImage(named: object["img"].stringValue)
    //        cell.lblTitle.text          = object["name"].stringValue
    //        cell.lblDesc.text           = object["desc"].stringValue
    //        let progress1Value          = CGFloat(object["progress"].doubleValue)
    //        cell.linearProgressBar.progressValue = progress1Value
            
            cell.vwTitleBg.backGroundColor(color: UIColor.hexStringToUIColor(hex: object.colorCode).withAlphaComponent(0.4))
            cell.imgView.image      = nil
            cell.imgView.setCustomImage(with: object.imageUrl,
                                        placeholder: UIImage(),
                                        andLoader: true,
                                        completed: nil)
            cell.lblTitle.text          = object.goalName
            //cell.lblDesc.text           = "2 of 8 doses"//object["desc"].stringValue
            
            cell.lblDesc.text = "\(object.achievedValue!)"
                + " " + AppMessages.of + " "
                + "\(object.goalValue!)" + " "
                + object.goalMeasurement
            
            let value       = Float(object.achievedValue)
            let maxValue    = Float(object.goalValue) ?? 0
            cell.linearProgressBar.progressValue = GFunction.shared.getProgress(
                value: value,
                maxValue: maxValue)
            cell.setProgress(progressBar: cell.linearProgressBar, color: UIColor.hexStringToUIColor(hex: object.colorCode))
            GFunction.shared.setGoalProgressData(goalListModel: object,
                                                 lblProgress: cell.lblDesc,
                                                 linearProgressBar: cell.linearProgressBar,
                                                 lblDuration: nil, valueLog: nil)
            
            return cell
        case self.tblMyDevices:
            let cell : MyDevicesCell = tableView.dequeueReusableCell(withClass: MyDevicesCell.self, for: indexPath)
            let userModel = UserModel.shared
            cell.lblLastSync.text = userModel.bcaSync == nil ? AppMessages.deviceConnectionRequired : userModel.bcaSync.createdAt.isEmpty ? AppMessages.deviceConnectionRequired : "Last synced on " + GFunction.shared.convertDateFormat(dt: UserModel.shared.bcaSync.createdAt, inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue, outputFormat: DateTimeFormaterEnum.ddMMMYYYYhhmma.rawValue, status: .NOCONVERSION).str
            cell.lblDeviceName.text = userModel.devices != nil ? userModel.devices[indexPath.row].title : "Smart Analyser"
            cell.btnConnect.addAction(for: .touchUpInside) { [weak self] in
                guard let self = self else { return }
                self.viewModel.showDeviceConnectPopUp()
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
            
        case self.tblMyDevices:
            
            var params = [String:Any]()
            params[AnalyticsParameters.sync_status.rawValue] = UserModel.shared.bcaSync == nil ? "N" : UserModel.shared.bcaSync.createdAt.isEmpty ? "N" : "Y"
            params[AnalyticsParameters.medical_device.rawValue] = "BCA"
            FIRAnalytics.FIRLogEvent(eventName: .TAP_DEVICE_CARD,
                                     screen: .Home,
                                     parameter: params)
            
            guard let bcaSync = UserModel.shared.bcaSync, !bcaSync.createdAt.isEmpty else {
//                Alert.shared.showSnackBar(AppMessages.deviceConnectionRequired)
                self.viewModel.showDeviceConnectPopUp()
                return
            }
            
            let vc = BcaDetailVC.instantiate(fromAppStoryboard: .bca)
            vc.isFromHome = true
            vc.isBackToHome = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case self.tblDailySummary:
            
            let obj                     = self.viewModel.getGoalObject(index: indexPath.row)
            if let cell = self.tblDailySummary.cellForRow(at: indexPath) as? SummaryTblCell {
                self.selectGoal(obj: obj, cell: cell)
            }
            /*if (GoalType(rawValue: obj.keys) ?? .Exercise) == .Exercise {
                
                GlobalAPI.shared.getRoutines { [weak self] (message,data,statusCode) in
                    guard let self = self else { return }
                    switch statusCode {
                    case .success:
                        guard let data = data else { return }
                        let isRestDay = data["is_rest_day"].boolValue
                        
                        guard isRestDay else {
                            let vc = RoutineExercisePopupVC.instantiate(fromAppStoryboard: .goal)
                            vc.viewModel.arrExersice = data["exercise_details"].arrayValue.map({ ExerciseDataModel(fromJson: $0) })
                            vc.goalListModel = obj
                            vc.modalPresentationStyle = .overFullScreen
                            vc.modalTransitionStyle = .crossDissolve
                            vc.performOtherExersice = { [weak self] isDone in
                                guard let self = self,isDone else { return }
                                if let cell = self.tblDailySummary.cellForRow(at: indexPath) as? SummaryTblCell {
                                    self.selectGoal(obj: obj, cell: cell)
                                }
                            }
                            UIApplication.topViewController()?.present(vc, animated: true)
                            return
                        }
                        
                        if let cell = self.tblDailySummary.cellForRow(at: indexPath) as? SummaryTblCell {
                            self.selectGoal(obj: obj, cell: cell)
                        }
                        
                        break
                    case .emptyData: break
                    default: break
                    }
                }
                
                /*let exersicePlanRoutineVM = ExerciseMyPlanRoutineParentVM()
                exersicePlanRoutineVM.getRoutines { [weak self] isRestDay in
                    guard let self = self else { return }
                    guard isRestDay else {
                        let vc = RoutineExercisePopupVC.instantiate(fromAppStoryboard: .goal)
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        UIApplication.topViewController()?.present(vc, animated: true)
                        return
                    }
                    if let cell = self.tblDailySummary.cellForRow(at: indexPath) as? SummaryTblCell {
                        self.selectGoal(obj: obj, cell: cell)
                    }
                }*/
            } else {
                if let cell = self.tblDailySummary.cellForRow(at: indexPath) as? SummaryTblCell {
                    self.selectGoal(obj: obj, cell: cell)
                }
            }*/
                        
            break
        default:break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension HomeVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension HomeVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblDailySummary || obj == self.tblMyDevices, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            DispatchQueue.main.async {
                if obj == self.tblDailySummary {
                    self.tblDailySummaryHeight.constant = newvalue.height
                    UIView.animate(withDuration: kAnimationSpeed) {
                        self.view.layoutIfNeeded()
                    }
                } else {
                    self.tblMyDeviceConstHeight.constant = newvalue.height
                }
            }
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblDailySummary.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblMyDevices.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
//        guard let tblView = self.tblDailySummary else {return}
//        if let _ = tblView.observationInfo {
//            tblView.removeObserver(self, forKeyPath: "contentSize")
//        }
//
        self.tblDailySummary.removeObserver(self, forKeyPath: "contentSize")
        self.tblMyDevices.removeObserver(self, forKeyPath: "contentSize")
    }
}

//MARK: -------------------------- Select goals --------------------------
extension HomeVC {
    
    func selectGoal(obj: GoalListModel, cell: SummaryTblCell? = nil) {
        var params              = [String: Any]()
        params[AnalyticsParameters.goal_name.rawValue]  = obj.goalName
        params[AnalyticsParameters.goal_id.rawValue]    = obj.goalMasterId
        FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_HOME,
                                 screen: .Home,
                                 parameter: params)
        
        PlanManager.shared.isAllowedByPlan(type: .activity_logs,
                                           sub_features_id: obj.keys,
                                           completion: { isAllow in
            if isAllow {
                let type = GoalType.init(rawValue: obj.keys) ?? .Exercise
                if type == .Diet {
                    self.isPageVisible = false
                    let vc = FoodDiaryParentVC.instantiate(fromAppStoryboard: .goal)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
    //                let vc = FoodLogVC.instantiate(fromAppStoryboard: .goal)
    //                vc.hidesBottomBarWhenPushed = true
    //                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    self.isPageVisible = false
                    let vc = UpdateGoalParentVC.instantiate(fromAppStoryboard: .goal)
                    
                    var selectedIndex = 0
                    if self.viewModel.arrGoal.count > 0 {
                        for i in 0...self.viewModel.arrGoal.count - 1 {
                            let data = self.viewModel.arrGoal[i]
                            if data.keys == obj.keys {
                                selectedIndex = i
                            }
                        }
                    }
                    
                    vc.selectedIndex            = selectedIndex
                    vc.arrList                  = self.viewModel.arrGoal
                    vc.modalPresentationStyle   = .overFullScreen
                    vc.modalTransitionStyle     = .crossDissolve
                    
                    for cell in self.tblDailySummary.visibleCells {
                        cell.hero.id            = nil
                    }
//                    cell?.hero.id                   = obj.keys
                    self.tblDailySummary.hero.id    = obj.keys
                    vc.completionHandler = { obj in
                        cell?.hero.id           = nil
                        if type == .Medication ||
                            type == .Pranayam {
                            
                            if obj?.count > 0 {
                                print(obj ?? "")
                                self.viewModel.apiCallFromStartSummary(tblViewHome: self.tblDailySummary,
                                                                       colViewHome: self.colReading,
                                                                       withLoader: false)
                            }
                        }
                        else {
                            if obj?.count > 0 {
                                print(obj ?? "")
                                //object
                                self.viewModel.apiCallFromStartSummary(tblViewHome: self.tblDailySummary,
                                                                       colViewHome: self.colReading,
                                                                       withLoader: false)
                            }
                        }
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            }
            else {
                PlanManager.shared.alertNoSubscription()
            }
        })
    }
}
                                          
