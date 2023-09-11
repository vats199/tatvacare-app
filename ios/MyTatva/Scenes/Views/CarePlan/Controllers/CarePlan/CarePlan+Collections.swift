//
//  AddPrecription+Collection.swift
//  MyTatva
//

//

import Foundation

class ReadingHistoryCarePlanCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var vwBgColor        : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var lblUpdate        : UILabel!
    @IBOutlet weak var lblAutoInsight   : UILabel!
    
    //MARK:- Class Variable
    var object = ReadingListModel(){
        didSet {
            self.setCellData()
        }
    }
    
    private func setCellData(){
        self.vwBgColor.backGroundColor(color: UIColor.hexStringToUIColor(hex: self.object.backgroundColor).withAlphaComponent(0.1))
        
        //self.imgView.image = UIImage()
        if self.object.imageIconUrl.trim() != "" {
            self.imgView.setCustomImage(with: self.object.imageIconUrl,
                                        placeholder: UIImage(),
                                        andLoader: true,
                                        renderingMode: .alwaysTemplate,
                                        completed: nil)
            self.imgView.tintColor = UIColor.hexStringToUIColor(hex: self.object.colorCode)
            self.imgView.layoutIfNeeded()
        }
        
        if self.object.isTopBigCell {
            //UI and Data update for big careplan cell
            
            self.lblTitle.text              = self.object.readingName
            //cell.lblAutoInsight.text      = AppMessages.AverageReadingsOfOthers + " - " + obj.totalReadingAverage + " " + obj.measurements
            
            self.lblAutoInsight.text        = self.object.defaultReading!
            self.lblAutoInsight.isHidden    = true
            
            GFunction.shared.setReadingData(obj: self.object,
                                            lblReading: self.lblDesc,
                                            lblUpdate: self.lblUpdate,
                                            fontDefault: UIFont.customFont(ofType: .medium, withSize: 20),
                                            fontAttributed: UIFont.customFont(ofType: .medium, withSize: 10)){ isReadingAvailable in
                
            }
            
            self.lblTitle.font(name: .semibold, size: 18)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
            self.lblUpdate.font(name: .medium, size: 11)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
            self.lblAutoInsight.font(name: .medium, size: 11)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
        }
        else {
            //UI and Data update for small careplan cell
            
            self.lblTitle.text              = self.object.readingName
//            cell.lblAutoInsight.text      = AppMessages.AverageReadingsOfOthers + " - " + obj.totalReadingAverage + " " + obj.measurements
            self.lblAutoInsight.text        = self.object.defaultReading!
            self.lblAutoInsight.isHidden    = true
            GFunction.shared.setReadingData(obj: self.object,
                                            lblReading: self.lblDesc,
                                            lblUpdate: self.lblUpdate,
                                            fontDefault: UIFont.customFont(ofType: .medium, withSize: 17),
                                            fontAttributed: UIFont.customFont(ofType: .medium, withSize: 9)) { isReadingAvailable in
            }
            
            self.lblTitle.font(name: .semibold, size: 12)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
            self.lblUpdate.font(name: .medium, size: 8)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
            self.lblAutoInsight.font(name: .medium, size: 8)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
        }
    }
    
    override func awakeFromNib() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.vwBg.layoutIfNeeded()
        self.vwBg.cornerRadius(cornerRadius: 10)
    }
}

class CarePlanMedicineCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var imgView              : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblNoData            : UILabel!
    @IBOutlet weak var btnUpdate            : UIButton!
    @IBOutlet weak var tblMedicine          : UITableView!
    @IBOutlet weak var lblAutoInsight       : UILabel!
    @IBOutlet weak var indicatorView        : UIActivityIndicatorView!
    
    var arrData : [JSON] = []
    var arrList = [MedicineHistoryModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        self.lblTitle.font(name: .semibold, size: 14)
        //            .textColor(color: UIColor.colorMedication)
        
        self.lblNoData.font(name: .semibold, size: 14).textColor(color: .themePurple)
        self.btnUpdate.font(name: .medium, size: 9)
            .textColor(color: UIColor.themePurple)
            .borderColor(color: UIColor.themePurple, borderWidth: 1)
            .cornerRadius(cornerRadius: 4)
        self.lblAutoInsight.font(name: .medium, size: 9)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            //self.vwBg.applyViewShadow(shadowOffset: CGSize.zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.2, shdowRadious: 5)
            
            self.imgView.layoutIfNeeded()
            self.imgView.cornerRadius(cornerRadius: 0)
        }
        
        self.indicatorView.style = .medium
        self.setup(tblView: self.tblMedicine)
    }
    
    func setup(tblView: UITableView){
        tblView.layoutIfNeeded()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
    }
}

class RecordsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var imgDoc               : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDate              : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        self.lblTitle.font(name: .semibold, size: 14)
        //            .textColor(color: UIColor.colorMedication)
        
        self.lblTitle.font(name: .semibold, size: 14).textColor(color: UIColor.themeBlack)
        self.lblDate.font(name: .regular, size: 11).textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.cornerRadius(cornerRadius: 6)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
            
            self.imgDoc.layoutIfNeeded()
            self.imgDoc.cornerRadius(cornerRadius: 6)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
        }
        
    }
    
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension CarePlanVC : UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colTopReadingHistory:
            
            return self.arrReading1.count
            
            
        case self.colSecondReadingHistory:
            if self.btnViewMoreReadingHistory.isSelected {
                return self.arrReading2.count
            }
            else {
                if self.arrReading2.count < 3 {
                    return self.arrReading2.count
                }
                else {
                    return 3
                }
            }
            
        case self.colBookTest:
            let arrCount = self.homeVM.getTestListCount()
            self.vwBookTestParent.isHidden = arrCount > 0 ? false : true
            return arrCount
            
        case self.colGoalHistory:
            return self.viewModel.getGoalCount()
            
        case self.colRecords:
            return self.viewModelRecords.getCount()
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Begin asynchronously fetching data for the requested index paths.
        switch collectionView {
        case self.colTopReadingHistory:
            for indexPath in indexPaths {
            let model = self.arrReading1[indexPath.item]
                guard let cell = colTopReadingHistory.cellForItem(at: indexPath) as? ReadingHistoryCarePlanCell else { return }
                model.isTopBigCell  = true
                cell.object         = model
            }
            break
        case self.colSecondReadingHistory:
            for indexPath in indexPaths {
            let model = self.arrReading2[indexPath.item]
                guard let cell = colSecondReadingHistory.cellForItem(at: indexPath) as? ReadingHistoryCarePlanCell else { return }
                model.isTopBigCell  = false
                cell.object         = model
            }
            break
        case self.colBookTest:
            break
        case self.colRecords:
            break
        default:
            break
        }
         
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case self.colTopReadingHistory:
            let cell : ReadingHistoryCarePlanCell = collectionView.dequeueReusableCell(withClass: ReadingHistoryCarePlanCell.self, for: indexPath)
            let obj             = self.arrReading1[indexPath.item]
            obj.isTopBigCell    = true
            cell.object         = obj
            
            return cell
            
        case self.colSecondReadingHistory:
            let cell : ReadingHistoryCarePlanCell = collectionView.dequeueReusableCell(withClass: ReadingHistoryCarePlanCell.self, for: indexPath)
            let obj             = self.arrReading2[indexPath.item]
            obj.isTopBigCell    = false
            cell.object         = obj
            
            return cell
           
        case self.colBookTest:
            let cell : HomeBookTestCell = collectionView.dequeueReusableCell(withClass: HomeBookTestCell.self, for: indexPath)
            let object = self.homeVM.getTestListObject(index: indexPath.item)
            cell.setData(object: object)
            return cell
            
        case self.colGoalHistory:
            let obj                     = self.viewModel.getGoalObject(index: indexPath.row)
//            var xValues                 = [String]()
//            var yValues                 = [String]()
            let color1                  = UIColor.hexStringToUIColor(hex: obj.colorCode)
//            var goalChartDetailModel    = GoalChartDetailModel()
            
            let type = GoalType.init(rawValue: obj.keys) ?? .Exercise
            if type == .Medication && self.summarySelectionType == .sevenDays {
                //if obj["type"].stringValue == "medicine" {
                let cell : CarePlanMedicineCell = collectionView.dequeueReusableCell(withClass: CarePlanMedicineCell.self, for: indexPath)
                
                cell.imgView.image = UIImage()
                if obj.imageUrl.trim() != "" {
                    cell.imgView.setCustomImage(with: obj.imageUrl)
                }
                
                cell.lblTitle.text      = obj.goalName
                cell.lblTitle
                    .font(name: .semibold, size: 14)
                    .textColor(color: color1)
                 
//                cell.lblAutoInsight.text    = AppMessages.YourAverage + " \(obj.goalName!) " + AppMessages.adherenceInThePastMonth + " \(obj.avgCurrent!) " + obj.goalMeasurement + "; \(AppMessages.average)" + " \(obj.goalName!) " + AppMessages.adherenceOfOtherPatients + " \(obj.avgOther!) " + obj.goalMeasurement
                
                cell.lblAutoInsight.text    = obj.standardValue
                
                //cell.arrData            = obj["medicine_list"].arrayValue
                cell.tblMedicine.reloadData()
                
                cell.btnUpdate.addTapGestureRecognizer {
                    PlanManager.shared.isAllowedByPlan(type: .activity_logs,
                                                       sub_features_id: obj.keys,
                                                       completion: { isAllow in
                        
                        if isAllow {
                            self.isPageVisible = false
                            let type = GoalType.init(rawValue: obj.keys) ?? .Exercise
                            if type == .Diet {
                                let vc = FoodLogVC.instantiate(fromAppStoryboard: .goal)
                                vc.hidesBottomBarWhenPushed = true
                                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                            }
                            else {
                                let vc = UpdateGoalParentVC.instantiate(fromAppStoryboard: .goal)
                                vc.selectedIndex = indexPath.row
                                vc.arrList = self.viewModel.arrGoal
                                vc.modalPresentationStyle = .overFullScreen
                                vc.modalTransitionStyle = .crossDissolve
                                for cell in self.colGoalHistory.visibleCells {
                                    cell.hero.id            = nil
                                }
                                //cell.hero.id                = obj.keys
                                vc.completionHandler = { obj in
                                    cell.hero.id            = nil
                                    if obj?.count > 0 {
                                        print(obj ?? "")
                                        //object
                                        self.viewModel.apiCallFromStartSummary(colView1: self.colTopReadingHistory,
                                                                               colView2: self.colSecondReadingHistory,
                                                                               colView3: self.colGoalHistory)
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
                
                
                cell.lblNoData.text             = ""
                cell.lblNoData.isHidden         = true
                cell.btnUpdate.isHidden         = true
                cell.indicatorView.isHidden     = false
                cell.indicatorView.startAnimating()
                GlobalAPI.shared.last_seven_days_medicationAPI { [weak self] (isDone, arr, msg) in
                    guard let _ = self else {return}
                    
                    cell.indicatorView.isHidden     = true
                    if isDone {
                        cell.arrList                = arr
                        cell.tblMedicine.isHidden   = false
                        cell.btnUpdate.isHidden     = false
                        cell.tblMedicine.reloadData()
                    }
                    else {
                        cell.tblMedicine.isHidden   = true
                        cell.lblNoData.isHidden     = false
                        cell.btnUpdate.isHidden     = false
                        cell.lblNoData.text         = msg
                    }
                }
                
                
                return cell
                //}
            }
            else {
                let cell : GoalSummaryChartCell = collectionView.dequeueReusableCell(withClass: GoalSummaryChartCell.self, for: indexPath)
                
                cell.imgTitle.setCustomImage(with: obj.imageUrl)
                cell.lblTitle.text     = obj.goalName
                cell.lblTitle.font(name: .semibold, size: 14).textColor(color: color1)
                
//                cell.lblAutoInsight.text    = AppMessages.YourAverage + " \(obj.goalName!) " + AppMessages.adherenceInThePastMonth + " \(obj.avgCurrent!) " + obj.goalMeasurement + "; \(AppMessages.average)" + " \(obj.goalName!) " + AppMessages.adherenceOfOtherPatients + " \(obj.avgOther!) " + obj.goalMeasurement
                
                cell.lblAutoInsight.text    = obj.standardValue
                self.updateGoalRecords(cell: cell,
                                       obj: obj,
                                       type: type)
                
                //cell.lblDesc.text = ""
                
                cell.btnUpdate.addTapGestureRecognizer {
                    self.isPageVisible = false
                    PlanManager.shared.isAllowedByPlan(type: .activity_logs,
                                                       sub_features_id: obj.keys,
                                                       completion: { isAllow in
                        if isAllow {
                            let type = GoalType.init(rawValue: obj.keys) ?? .Exercise
                            if type == .Diet {
                                let vc = FoodLogVC.instantiate(fromAppStoryboard: .goal)
                                vc.hidesBottomBarWhenPushed = true
                                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                            }
                            else {
                                let vc = UpdateGoalParentVC.instantiate(fromAppStoryboard: .goal)
                                vc.selectedIndex = indexPath.row
                                vc.arrList = self.viewModel.arrGoal
                                vc.modalPresentationStyle = .overFullScreen
                                vc.modalTransitionStyle = .crossDissolve
                                for cell in self.colGoalHistory.visibleCells {
                                    cell.hero.id            = nil
                                }
                                //cell.hero.id                = obj.keys
                                vc.completionHandler = { obj in
                                    cell.hero.id            = nil
                                    if obj?.count > 0 {
                                        print(obj ?? "")
                                        //object
                                        self.viewModel.apiCallFromStartSummary(colView1: self.colTopReadingHistory,
                                                                               colView2: self.colSecondReadingHistory,
                                                                               colView3: self.colGoalHistory)
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
                
                return cell
            }
        case self.colRecords:
            let cell : RecordsCollectionCell = collectionView.dequeueReusableCell(withClass: RecordsCollectionCell.self, for: indexPath)
            let object = self.viewModelRecords.getObject(index: indexPath.row)
            //cell.imgTitle.setCustomImage(with: object.documentUrl.first ?? "")
            //            let time = GFunction.shared.convertDateFormate(dt: object.updatedAt,
            //                                                               inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
            //                                                               outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
            //                                                               status: .LOCAL)
            
            let time = GFunction.shared.convertDateFormate(dt: object.updatedAt,
                                                           inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                           status: .NOCONVERSION)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                if let doc = object.documentUrl, doc.count > 0 {
                    let strImage = doc.first!
                    
                    if strImage.contains(".pdf") {
                        cell.imgTitle.isHidden      = true
                        cell.imgDoc.isHidden        = false
                        cell.imgDoc.contentMode     = .center
                        cell.imgDoc.image           = UIImage(named: "pdf_ic")
                        
                        cell.imgDoc.addTapGestureRecognizer {
                            if let url = URL(string: strImage) {
                                GFunction.shared.openPdf(url: url)
                            }
                        }
                    }
                    else {
                        cell.imgTitle.isHidden      = false
                        cell.imgDoc.isHidden        = true
                        cell.imgTitle.contentMode   = .scaleAspectFill
                        cell.imgTitle.setCustomImage(with: strImage) { img, err, cache, url in
                            if img != nil {
                                cell.imgTitle.tapToZoom(with: img)
                            }
                        }
                    }
                }
            }
            
            cell.lblDate.text = time.0
            cell.lblTitle.text = object.title
            return cell
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colTopReadingHistory:
            self.isPageVisible = false
            let obj                     = self.arrReading1[indexPath.item]
            var params = [String: Any]()
            params[AnalyticsParameters.reading_id.rawValue]     = obj.readingsMasterId
            params[AnalyticsParameters.reading_name.rawValue]   = obj.readingName
            FIRAnalytics.FIRLogEvent(eventName: .USER_TAP_ON_CAREPLAN_READING,
                                     screen: .CarePlan,
                                     parameter: params)
//            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_WIDGET, parameter: params)
            
            if obj.graph == "Y" {
                if obj.notConfigured.trim() != "" {
                    Alert.shared.showSnackBar(obj.notConfigured)
                }
                else {
                    //Open chat details popup
                    if let cell: ReadingHistoryCarePlanCell = self.colTopReadingHistory.cellForItem(at: indexPath) as? ReadingHistoryCarePlanCell {
                        
                        GFunction.shared.setReadingData(obj: obj,
                                                        lblReading: cell.lblDesc,
                                                        lblUpdate: cell.lblUpdate,
                                                        fontDefault: UIFont.customFont(ofType: .medium, withSize: 20),
                                                        fontAttributed: UIFont.customFont(ofType: .medium, withSize: 10)){ isReadingAvailable in
                            
                            
                            let vc = ReadingChartDetailPopupVC.instantiate(fromAppStoryboard: .carePlan)
                            
                            vc.selectedIndex            = indexPath.row
                            vc.arrReadingList           = self.arrReading1 + self.arrReading2
                            vc.modalPresentationStyle   = .overFullScreen
                            vc.modalTransitionStyle     = .crossDissolve
                            //cell.hero.id                = "cell"
                            vc.completionHandler = { obj in
                                cell.hero.id            = nil
                                
                                self.viewModel.apiCallFromStartSummary(
                                    colView1: self.colTopReadingHistory,
                                    colView2: self.colSecondReadingHistory,
                                    colView3: self.colGoalHistory)
                                
                                if obj?.count > 0 {
                                    print(obj ?? "")
                                    //object
                                }
                            }
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
            else {
                if let cell: ReadingHistoryCarePlanCell = self.colSecondReadingHistory.cellForItem(at: indexPath) as? ReadingHistoryCarePlanCell {
                    self.selectReading(obj: obj, cell: cell)
                }
            }
            
            break
            
        case self.colSecondReadingHistory:
            self.isPageVisible = false
            let obj                     = self.arrReading2[indexPath.item]
            
            var params = [String: Any]()
            params[AnalyticsParameters.reading_name.rawValue] = obj.readingName
            params[AnalyticsParameters.reading_id.rawValue] = obj.readingsMasterId
            FIRAnalytics.FIRLogEvent(eventName: .USER_TAP_ON_CAREPLAN_READING,
                                     screen: .CarePlan,
                                     parameter: params)
            
            if obj.graph == "Y" {
                if obj.notConfigured.trim() != "" {
                    Alert.shared.showSnackBar(obj.notConfigured)
                }
                else {
                    //Open chat details popup
                    if let cell: ReadingHistoryCarePlanCell = self.colSecondReadingHistory.cellForItem(at: indexPath) as? ReadingHistoryCarePlanCell {
                        
                        GFunction.shared.setReadingData(obj: obj,
                                                        lblReading: cell.lblDesc,
                                                        lblUpdate: cell.lblUpdate,
                                                        fontDefault: UIFont.customFont(ofType: .medium, withSize: 17),
                                                        fontAttributed: UIFont.customFont(ofType: .medium, withSize: 9)){ isReadingAvailable in
                            
                            
                            let vc = ReadingChartDetailPopupVC.instantiate(fromAppStoryboard: .carePlan)
                            vc.selectedIndex            = indexPath.row + 2
                            vc.arrReadingList           = self.arrReading1 + self.arrReading2
                            vc.modalPresentationStyle   = .overFullScreen
                            vc.modalTransitionStyle     = .crossDissolve
    //                        cell.hero.id                = "cell"
                            vc.completionHandler = { obj in
                                cell.hero.id            = nil
                                
                                self.viewModel.apiCallFromStartSummary(
                                    colView1: self.colTopReadingHistory,
                                    colView2: self.colSecondReadingHistory,
                                    colView3: self.colGoalHistory)
                                
                                if obj?.count > 0 {
                                    print(obj ?? "")
                                    //object
                                }
                            }
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
            else {
                if let cell: ReadingHistoryCarePlanCell = self.colSecondReadingHistory.cellForItem(at: indexPath) as? ReadingHistoryCarePlanCell {
                    self.selectReading(obj: obj, cell: cell)
                }
            }
            
            break
            
        case self.colBookTest:
            let object = self.homeVM.getTestListObject(index: indexPath.item)
            
            var params1 = [String: Any]()
            params1[AnalyticsParameters.lab_test_id.rawValue]  = object.labTestId
            FIRAnalytics.FIRLogEvent(eventName: .CAREPLAN_LABTEST_CARD_CLICKED,
                                     screen: .CarePlan,
                                     parameter: params1)
            
            let vc = LabTestDetailsVC.instantiate(fromAppStoryboard: .carePlan)
            vc.lab_test_id = object.labTestId
            vc.hidesBottomBarWhenPushed = true
            vc.completionHandler = { obj in
                if obj?.name != nil {
                    self.homeVM.arrBookTestList[indexPath.item] = obj!
                    self.colBookTest.reloadData()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case self.colGoalHistory:
            //
            //            let vc = ChartDetailPopupVC.instantiate(fromAppStoryboard: .carePlan)
            //
            //            //vc.goalType = self.viewModel.arrGoalList
            //            vc.modalPresentationStyle = .overFullScreen
            //            vc.completionHandler = { obj in
            //                if obj?.count > 0 {
            //                    print(obj ?? "")
            //                    //object
            //                    self.colGoalHistory.reloadData()
            //                }
            //            }
            //            self.present(vc, animated: true, completion: nil)
            
            break
        case self.colRecords:
//            let vc = RecordsVC.instantiate(fromAppStoryboard: .setting)
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
            var params              = [String : Any]()
            params[AnalyticsParameters.patient_records_id.rawValue]  = self.viewModelRecords.getObject(index: indexPath.row).patientRecordsId
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_RECORD,
                                     screen: .CarePlan,
                                     parameter: params)
            break
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colTopReadingHistory:
            
            let width   = self.colTopReadingHistory.frame.size.width / 2
            let height  = self.colTopReadingHistory.frame.size.height
            
            return CGSize(width: width,
                          height: height)
            
        case self.colSecondReadingHistory:
            
            let width   = self.colSecondReadingHistory.frame.size.width / 3
            let height  = width //* 1.1
            
            return CGSize(width: width,
                          height: height)
            
        case self.colBookTest:
            
            let width   = self.colBookTest.frame.size.width / 3.2
            let height  = self.colBookTest.frame.size.height
            
            return CGSize(width: width,
                          height: height)
            
        case self.colGoalHistory:
            
            let width   = self.colGoalHistory.frame.size.width / 1.1
            let height  = self.colGoalHistory.frame.size.height
            
            return CGSize(width: width,
                          height: height)
        case self.colRecords:
            let width   = self.colRecords.bounds.width / 2.5
            let height  = self.colRecords.bounds.height
            
            return CGSize(width: width,
                          height: height)
            
        default:
            
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension CarePlanVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
//        self.view.layoutIfNeeded()
        
        if let obj = object as? UICollectionView, obj == self.colSecondReadingHistory, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.colSecondReadingHistoryHeight.constant = newvalue.height
        }
        
        if let obj = object as? UITableView, obj == self.tblPrecription, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblPrecriptionHeight.constant = newvalue.height
        }
        
        if let obj = object as? UITableView, obj == self.tblAppointment, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblAppointmentHeight.constant = newvalue.height
        }
        
        if let obj = object as? UITableView, obj == self.tblDietPlan, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblDietPlanHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.colSecondReadingHistory.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblPrecription.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblAppointment.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblDietPlan.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let colView = self.colSecondReadingHistory else {return}
        if let _ = colView.observationInfo {
            colView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView = self.tblPrecription else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView2 = self.tblAppointment else {return}
        if let _ = tblView2.observationInfo {
            tblView2.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView3 = self.tblDietPlan else {return}
        if let _ = tblView3.observationInfo {
            tblView3.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

extension CarePlanVC {
    
    func selectReading(obj: ReadingListModel, cell: ReadingHistoryCarePlanCell? = nil){
        
//        var params                  = [String: Any]()
//        params[AnalyticsParameters.reading_name.rawValue]   = obj.readingName
//        params[AnalyticsParameters.reading_id.rawValue]     = obj.readingsMasterId
//        FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_HOME, parameter: params)
        
        if obj.notConfigured.trim() != "" {
            Alert.shared.showSnackBar(obj.notConfigured)
        }    
        else {
            PlanManager.shared.isAllowedByPlan(type: .reading_logs,
                                               sub_features_id: obj.keys,
                                               completion: { isAllow in
                if isAllow {
                    if let type = ReadingType.init(rawValue: obj.keys) {
                        if type == .cat {
                            GlobalAPI.shared.get_cat_surveyAPI { [weak self] (isDone, object, id) in
                                guard let self = self else {return}
                                
                                if isDone {
                                    SurveySparrowManager.shared.startSurveySparrow(token: object.surveyId)
                                    SurveySparrowManager.shared.completionHandler = { Response in
                                        print(Response as Any)
                                        
                                        
                                        GlobalAPI.shared.add_cat_surveyAPI(cat_survey_master_id: object.catSurveyMasterId,
                                                                           survey_id: object.surveyId,
                                                                           Score: String(Response!["score"] as? Int ?? 0), response: Response!["response"] as! [[String: Any]]) { (isDone, msg) in
                                            
                                            self.viewModel.apiCallFromStartSummary(
                                                colView1: self.colTopReadingHistory,
                                                colView2: self.colSecondReadingHistory,
                                                colView3: self.colGoalHistory)
                                            
                                            if isDone {
                                                var params = [String: Any]()
                                                params[AnalyticsParameters.reading_name.rawValue]   = obj.readingName
                                                params[AnalyticsParameters.reading_id.rawValue]     = obj.readingsMasterId
                                                
                                                FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATED_READING,
                                                                         screen: .LogReading,
                                                                         parameter: params)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            self.isPageVisible = false
                            let vc          = UpdateReadingParentVC.instantiate(fromAppStoryboard: .goal)
                            var selectedIndex = 0
                            if self.viewModel.arrReading.count > 0 {
                                for i in 0...self.viewModel.arrReading.count - 1 {
                                    let data = self.viewModel.arrReading[i]
                                    if data.keys == obj.keys {
                                        selectedIndex = i
                                    }
                                }
                            }
                            
                            vc.selectedIndex                = selectedIndex
                            vc.arrList                      = self.viewModel.arrReading
                            vc.modalPresentationStyle       = .overFullScreen
                            vc.modalTransitionStyle         = .crossDissolve
                            for cell in self.colTopReadingHistory.visibleCells {
                                if let cell2 = cell as? ReadingHistoryCarePlanCell {
                                    cell2.hero.id   = nil
                                }
                            }
                            for cell in self.colSecondReadingHistory.visibleCells {
                                if let cell2 = cell as? ReadingHistoryCarePlanCell {
                                    cell2.hero.id   = nil
                                }
                            }
                            //cell?.hero.id           = obj.keys
        //                    self.vwReadingHistory.hero.id           = obj.keys
        //                    self.vwSecondReadingHistory.hero.id     = obj.keys
                            vc.completionHandler = { obj in
                                cell?.hero.id       = nil
                                
                                self.viewModel.apiCallFromStartSummary(
                                    colView1: self.colTopReadingHistory,
                                    colView2: self.colSecondReadingHistory,
                                    colView3: self.colGoalHistory)
                                if obj?.count > 0 {
                                    print(obj ?? "")
                                    //object
                                }
                            }
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
    }
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension CarePlanVC: UIScrollViewDelegate {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.colGoalHistory {
            self.colGoalHistory.scrollToCenter()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == self.colGoalHistory {
            self.colGoalHistory.scrollToCenter()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.colGoalHistory {
            //            let pageWidth:CGFloat = scrollView.frame.width
            //            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            //            //Change the indicator
            //            self.pageControl.setPage(Int(currentPage))
            
            if let indexPath = self.colGoalHistory.getVisibleCellIndexPath() {
                self.pageControl.setPage(indexPath.item)
            }
            //self.scrollingFinished(scrollView: scrollView)
        }
        
        if scrollView == self.scrollMain {
            let contentOffset = scrollView.contentOffset
            if contentOffset.y <= 0 {
                
                let scale                   = (-contentOffset.y * 0.001) + 1
                let scaling                 = CGAffineTransform(scaleX: scale, y: scale)
                self.lblTitle.transform     = scaling
                self.lblTitle.applyViewShadow(shadowOffset: CGSize(width: 1, height: 1), shadowColor: UIColor.themePurple, shadowOpacity: Float(scale) - 1, shdowRadious: CGFloat(scale) - 1)
            }
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        print("scrollViewDidEndDecelerating")
        self.scrollingFinished(scrollView: scrollView)
        
        switch scrollView {
        case self.scrollMain:
            if scrollView.isAtBottom {
                FIRAnalytics.FIRLogEvent(eventName: .USER_SCROLL_DEPTH_CARE_PLAN,
                                         screen: .CarePlan,
                                         parameter: nil)
            }
            break
        default:
            break
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            //didEndDecelerating will be called for sure
            return
        }
        print("scrollViewDidEndDragging")
        self.scrollingFinished(scrollView: scrollView)
        
        switch scrollView {
        case self.scrollMain:
            if scrollView.isAtBottom {
                FIRAnalytics.FIRLogEvent(eventName: .USER_SCROLL_DEPTH_CARE_PLAN,
                                         screen: .CarePlan,
                                         parameter: nil)
            }
            break
        default:
            break
        }
    }

    func scrollingFinished(scrollView: UIScrollView) {
       // Your code
        if scrollView == self.colGoalHistory {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.colGoalHistory.layoutIfNeeded()
                //let currentCellOffset = scrollView.contentOffset
                
                if let indexPath = self.colGoalHistory.getVisibleCellIndexPath() {
                    print("---------------------------------scrollingFinished: \(indexPath.item)")
                    
                    let obj                     = self.viewModel.getGoalObject(index: indexPath.item)
                    let type                    = GoalType.init(rawValue: obj.keys) ?? .Exercise
                    
                    func updateChartData(cell: GoalSummaryChartCell){
//                        self.colGoalHistoryCurrentIndex = -1
                        if self.colGoalHistoryCurrentIndex != indexPath.item {
                            self.colGoalHistoryCurrentIndex = indexPath.item
                            
                            if self.colGoalHistoryFullReload {
                                self.colGoalHistoryFullReload = false
                                for item in self.viewModel.arrGoal {
                                    item.goalChartDetailModel   = GoalChartDetailModel()
                                    item.msg                    = ""
                                }
                                self.colGoalHistory.reloadData()
                            }
                            
                            func get_goal_recordsAPI(){
                                self.timerGoalHistory.invalidate()
                                self.timerGoalHistory = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                                    GlobalAPI.shared.get_goal_recordsAPI(goal_id: obj.goalMasterId,
                                                                         reading_time: self.summarySelectionType) { (isDone, object, msg, goalTime) in
                                        
                                        ///Get the actual visible rect and index on api response
                                        if let indexPath = self.colGoalHistory.getVisibleCellIndexPath() {
                                            let obj                     = self.viewModel.getGoalObject(index: indexPath.item)
                                            
                                            // &&
                                            //self.summarySelectionType == SelectionType.init(rawValue: object.goalTime)
                                            
                                            if isDone {
                                                if object.goalData != nil &&
                                                    object.goalData.count > 0 &&
                                                    obj.keys == object.goalData[0].keys  &&
                                                    self.summarySelectionType == goalTime {
                                                    
                                                    obj.goalChartDetailModel    = object
                                                    obj.msg                     = ""
                                                    
                                                    self.updateGoalRecords(cell: cell,
                                                                           obj: obj,
                                                                           type: type)
                                                }
                                                else {
                                                    //Handle for no data
                                                    if obj.keys == object.keys {
                                                        obj.goalChartDetailModel    = GoalChartDetailModel()
                                                        obj.msg                     = msg
                                                        self.updateGoalRecords(cell: cell,
                                                                               obj: obj,
                                                                                   type: type)
                                                    }
                                                }
                                            }
                                            else {
                                                obj.goalChartDetailModel    = GoalChartDetailModel()
                                                obj.msg                     = msg
                                                self.updateGoalRecords(cell: cell,
                                                                       obj: obj,
                                                                           type: type)
                                            }
                                        }
    //                                    self.colGoalHistory.performBatchUpdates {
    //                                    }
                                        self.colGoalHistory.reloadSections([0])
                                        self.colGoalHistory.reloadData()
                                    }
                                }
                            }
                            if obj.goalChartDetailModel.goalData == nil {
                                get_goal_recordsAPI()
                            }
                            else{
                            }
                        }
                    }
                    
                    if let cell = self.colGoalHistory.cellForItem(at: indexPath) as? GoalSummaryChartCell {
                        updateChartData(cell: cell)
                    }
                    else if let _ = self.colGoalHistory.cellForItem(at: indexPath) as? CarePlanMedicineCell {
                        ///Reload colGoalHistory first and update it with new cell data
                        self.colGoalHistoryCurrentIndex = -1
                        self.colGoalHistory.reloadData()
                        self.colGoalHistory.performBatchUpdates {
                            ///Get the actual visible rect and index on api response
                            if let indexPath = self.colGoalHistory.getVisibleCellIndexPath() {
                                if let cell = self.colGoalHistory.cellForItem(at: indexPath) as? GoalSummaryChartCell {
                                    updateChartData(cell: cell)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateGoalRecords(cell: GoalSummaryChartCell,
                           obj: GoalListModel,
                           type: GoalType){
        
        if type == .Medication && self.summarySelectionType == .sevenDays {
        }
        else {
            var xValues                 = [String]()
            var yValues                 = [String]()
            let color1                  = UIColor.hexStringToUIColor(hex: obj.colorCode)
            
            func resetComponents(){
                cell.vwLineChart.isHidden       = true
                cell.vwBarChart.isHidden        = true
                
                cell.lblDailyGoal.text          = ""
                cell.lblDailyGoalValue.text     = ""
                cell.lblNoData.text             = ""
                cell.lblDesc.text               = ""
                
                cell.lblDailyGoal.isHidden      = true
                cell.lblDailyGoalValue.isHidden = true
                cell.lblNoData.isHidden         = true
                cell.lblDesc.isHidden           = true
                cell.indicatorView.isHidden     = false
                cell.indicatorView.startAnimating()
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0, execute: {
                resetComponents()
                
                func setChart() {
                    cell.vwLineChart.isHidden   = true
                    cell.vwBarChart.isHidden    = true
                    CarePlanPopupChartManager.shared.readingListModel = ReadingListModel()
                    CarePlanPopupChartManager.shared.readingChartDetailModel = ReadingChartDetailModel()
                    switch self.summarySelectionType {
                    case .sevenDays:
                        CarePlanPopupChartManager.shared.setBarChart(vwBarChart: cell.vwBarChart,
                                                                     xValues: xValues,
                                                                     yValues: yValues,
                                                                     color: color1,
                                                                     xCount: 7)
                        //                        cell.setBarChart(vwBarChart: cell.vwBarChart,
                        //                                         xValues: xValues,
                        //                                         yValues: yValues,
                        //                                         color: color1)
                        break
                    case .fifteenDays:
                        CarePlanPopupChartManager.shared.setBarChart(vwBarChart: cell.vwBarChart,
                                                                     xValues: xValues,
                                                                     yValues: yValues,
                                                                     color: color1,
                                                                     xCount: 15)
                        break
                    case .fifteenDays:
                        break
                    case .thirtyDays:
                        CarePlanPopupChartManager.shared.setBarChart(vwBarChart: cell.vwBarChart,
                                                                     xValues: xValues,
                                                                     yValues: yValues,
                                                                     color: color1,
                                                                     xCount: 30)
                        
//                        CarePlanPopupChartManager.shared.setLineChart(vwLineChart: cell.vwLineChart,
//                                          xValues: xValues,
//                                          yValues: yValues,
//                                          yValues2: yValues,
//                                          color1: color1,
//                                          color2: color1,
//                                          isMultiLineChart: false)
//                        cell.setLineChart(vwLineChart: cell.vwLineChart,
//                                          xValues: xValues,
//                                          yValues: yValues,
//                                          yValues2: yValues,
//                                          color1: color1,
//                                          color2: color1,
//                                          isMultiLineChart: false)
                        break
                    case .nintyDays:
                        CarePlanPopupChartManager.shared.setBarChart(vwBarChart: cell.vwBarChart,
                                                                     xValues: xValues,
                                                                     yValues: yValues,
                                                                     color: color1,
                                                                     xCount: 90)
                        
//                        CarePlanPopupChartManager.shared.setLineChart(vwLineChart: cell.vwLineChart,
//                                          xValues: xValues,
//                                          yValues: yValues,
//                                          yValues2: yValues,
//                                          color1: color1,
//                                          color2: color1,
//                                          isMultiLineChart: false)
//                        cell.setLineChart(vwLineChart: cell.vwLineChart,
//                                          xValues: xValues,
//                                          yValues: yValues,
//                                          yValues2: yValues,
//                                          color1: color1,
//                                          color2: color1,
//                                          isMultiLineChart: false)
                        break
                    case .oneYear:
                        CarePlanPopupChartManager.shared.setBarChart(vwBarChart: cell.vwBarChart,
                                                                     xValues: xValues,
                                                                     yValues: yValues,
                                                                     color: color1,
                                                                     xCount: 1)
                        
//                        CarePlanPopupChartManager.shared.setLineChart(vwLineChart: cell.vwLineChart,
//                                          xValues: xValues,
//                                          yValues: yValues,
//                                          yValues2: yValues,
//                                          color1: color1,
//                                          color2: color1,
//                                          isMultiLineChart: false)
//                        cell.setLineChart(vwLineChart: cell.vwLineChart,
//                                          xValues: xValues,
//                                          yValues: yValues,
//                                          yValues2: yValues,
//                                          color1: color1,
//                                          color2: color1,
//                                          isMultiLineChart: false)
                        break
                        //                    case .allTime:
                        //                        cell.setLineChart(vwLineChart: cell.vwLineChart,
                        //                                          xValues: xValues,
                        //                                          yValues: yValues,
                        //                                          yValues2: yValues,
                        //                                          color1: color1,
                        //                                          color2: color1,
                        //                                          isMultiLineChart: false)
                        //                            break
                    }
                }
                
                let goalName = obj.goalName!
                
                resetComponents()
                
                var strGoalValue = String(format: "%.f", Float(obj.goalValue) ?? 0) + " " + obj.goalMeasurement
                
                cell.lblDailyGoal.isHidden = false
                cell.lblDailyGoal.text = AppMessages.DailyGoal
                cell.lblDailyGoalValue.isHidden = false
                cell.lblDailyGoalValue.text = strGoalValue//obj["desc"].stringValue
                
                if obj.goalChartDetailModel.goalData != nil &&
                    obj.goalChartDetailModel.goalData.count > 0 {
                    
                    cell.indicatorView.isHidden = true
                    
                    if obj.keys == obj.goalChartDetailModel.keys {
                        
                        for item in obj.goalChartDetailModel.goalData {
                            xValues.append(item.xValue)
                            yValues.append("\(item.achievedValue!)")
                        }
                        setChart()
                        
                        let goalType = GoalType.init(rawValue: obj.keys) ?? .Sleep
                        
                        var strDescValue = String(format: "%.f", Float(obj.goalChartDetailModel.average.goalValue)) + " " + obj.goalMeasurement
                        
                        var strDesc = "\(AppMessages.overTheLast) 7 \(AppMessages.kDays), \(AppMessages.youHaveDoneAnAverageOf) \(strDescValue) \(AppMessages.of) \(goalName)."
                        
                        switch self.summarySelectionType {
                            
                        case .sevenDays:
                            strDesc = "\(AppMessages.overTheLast) 7 \(AppMessages.kDays), \(AppMessages.youHaveDoneAnAverageOf) \(strDescValue) \(AppMessages.of) \(goalName)."
                            
                            if goalType == .Diet {
                                strDesc = "\(AppMessages.overTheLast) 7 \(AppMessages.kDays), \(AppMessages.youHaveEatenAnAverageOf) \(strDescValue) \(AppMessages.of) \(AppMessages.meals)."
                            }
                            break
                        case .fifteenDays:
                            strDesc = "\(AppMessages.overTheLast) 15 \(AppMessages.kDays), \(AppMessages.youHaveDoneAnAverageOf) \(strDescValue) \(AppMessages.of) \(goalName)."
                            
                            if goalType == .Diet {
                                strDesc = "\(AppMessages.overTheLast) 15 \(AppMessages.kDays), \(AppMessages.youHaveEatenAnAverageOf) \(strDescValue) \(AppMessages.of) \(AppMessages.meals)."
                            }
                            break
                        case .thirtyDays:
                            strDesc = "\(AppMessages.overTheLast) 30 \(AppMessages.kDays), \(AppMessages.youHaveDoneAnAverageOf) \(strDescValue) \(AppMessages.of) \(goalName)."
                            
                            if goalType == .Diet {
                                strDesc = "\(AppMessages.overTheLast) 30 \(AppMessages.kDays), \(AppMessages.youHaveEatenAnAverageOf) \(strDescValue) \(AppMessages.of) \(AppMessages.meals)."
                            }
                            break
                        case .nintyDays:
                            strDesc = "\(AppMessages.overTheLast) 90 \(AppMessages.kDays), \(AppMessages.youHaveDoneAnAverageOf) \(strDescValue) \(AppMessages.of) \(goalName)."
                            
                            if goalType == .Diet {
                                strDesc = "\(AppMessages.overTheLast) 90 \(AppMessages.kDays), \(AppMessages.youHaveEatenAnAverageOf) \(strDescValue) \(AppMessages.of) \(AppMessages.meals)."
                            }
                            break
                        case .oneYear:
                            strDesc = "\(AppMessages.overTheLast) 1 \(AppMessages.year), \(AppMessages.youHaveDoneAnAverageOf) \(strDescValue) \(AppMessages.of) \(goalName)."
                            
                            if goalType == .Diet {
                                strDesc = "\(AppMessages.overTheLast) 1 \(AppMessages.year), \(AppMessages.youHaveEatenAnAverageOf) \(strDescValue) \(AppMessages.of) \(AppMessages.meals)."
                            }
                            
                            break
                            //                            case .allTime:
                            //                                strDesc = "\(AppMessages.OverTheAllTimeAvgOf) \(strDescValue) of \(goalName)."
                            //
                            //                                if goalType == .Diet {
                            //                                    strDesc = "\(AppMessages.OverTheAllTimeAvgOf) \(strDescValue) of \(AppMessages.meals)."
                            //                                }
                            //                                break
                        }
                        
                        switch type {
                            
                        case .Medication:
                            break
                        case .Calories:
                            break
                        case .Steps:
                            break
                        case .Exercise:
                            break
                        case .Pranayam:
                            break
                        case .Sleep:
                            strGoalValue = String(format: "%0.0f", Float(obj.goalValue) ?? 0) + " " + obj.goalMeasurement
                            
                            strDescValue = String(format: "%0.1f", Float(obj.goalChartDetailModel.average.goalValue)) + " " + obj.goalMeasurement
                            break
                        case .Water:
                            break
                            
                        case .Diet:
                            break
                        }
                        cell.lblDailyGoal.isHidden = false
                        cell.lblDailyGoal.text = AppMessages.DailyGoal
                        cell.lblDailyGoalValue.isHidden = false
                        cell.lblDailyGoalValue.text = strGoalValue//obj["desc"].stringValue
                        cell.lblDesc.isHidden = false
                        cell.lblDesc.text = strDesc//obj["desc"].stringValue
                        cell.layoutIfNeeded()
                        
//                        cell.indicatorView.stopAnimating()
//                        cell.indicatorView.isHidden     = true
                    }
                }
                else {
                    if let indexPath = self.colGoalHistory.getVisibleCellIndexPath() {
                        let object                      = self.viewModel.getGoalObject(index: indexPath.item)
                        
                        if object.keys == obj.keys {
                            if obj.msg.trim() != "" {
                                cell.lblNoData.isHidden         = false
                                cell.lblNoData.text             = obj.msg
                                cell.indicatorView.isHidden     = true
                            }
                        }
                    }
//                    cell.indicatorView.stopAnimating()
//                    cell.indicatorView.isHidden     = true
                }
            })
        }
    }
}
