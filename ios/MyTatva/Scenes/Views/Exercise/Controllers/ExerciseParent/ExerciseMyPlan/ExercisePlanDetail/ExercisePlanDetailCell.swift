//
//  ExerciseMoreTblCell.swift


import UIKit
class ExercisePlanDetailCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var vwTitle              : UIView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var vwTable              : UIView!
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var tblViewHeight        : NSLayoutConstraint!
    
    var arraPlanType : [PlanType] = []
    var object = PlanDaysListModel() {
        didSet {
            self.setCellData()
        }
    }
    var plan_type = ""
    var exerciseAddedBy = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addObserverOnHeightTbl()
        
        self.lblTitle
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.white)
    
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.vwTitle.layoutIfNeeded()
            
            let color = GFunction.shared.applyGradientColor(startColor: UIColor.themePurple.withAlphaComponent(1),
                                                            endColor: UIColor.themePurple.withAlphaComponent(0.3),
                                                            locations: [0, 1],
                                                            startPoint: CGPoint(x: 0, y: self.vwTitle.frame.maxY),
                                                            endPoint: CGPoint(x: self.vwTitle.frame.maxX, y: self.vwTitle.frame.maxY),
                                                            gradiantWidth: self.vwTitle.frame.width,
                                                            gradiantHeight: self.vwTitle.frame.height)
            
            self.vwTitle.backgroundColor = color
        }
        self.setup(tblView: self.tblView)
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    func setup(tblView: UITableView){
        tblView.layoutIfNeeded()
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
//        tblView.emptyDataSetSource         = self
//        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
    }
    
    func setCellData(){
        //self.lblTitle.text = object.day + ", " + JSON(object.date!).stringValue + " " + object.month
        
        let time = GFunction.shared.convertDateFormate(dt: object.dayDate,
                                                       inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.EEEEddMMMM.rawValue,
                                                       status: .NOCONVERSION)
                                                       
                                                       
        self.lblTitle.text      = time.0
        
        
        self.tblView.reloadData()
        
    }
    
}

class ExercisePlanDetailChildCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var lblBreathing         : UILabel!
    @IBOutlet weak var lblBreathingVal      : UILabel!
    @IBOutlet weak var btnSelectBreathing   : UIButton!
    
    @IBOutlet weak var lblExercise          : UILabel!
    @IBOutlet weak var lblExerciseVal       : UILabel!
    @IBOutlet weak var btnSelectExercise    : UIButton!
    
    @IBOutlet weak var stackDetails         : UIStackView!
    @IBOutlet weak var stackExpand          : UIStackView!
    @IBOutlet weak var btnExpand            : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.lblBreathing
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblBreathingVal
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.9))
        
        self.lblExercise
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblExerciseVal
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.9))
    
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
        }
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension ExercisePlanDetailCell: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.object.routineData != nil {
            return self.object.routineData.count
        }
        else {
            return 0
        }
        
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ExercisePlanDetailChildCell = tableView.dequeueReusableCell(withClass: ExercisePlanDetailChildCell.self, for: indexPath)
        let object                  = self.object.routineData[indexPath.row]
        cell.lblTitle.text          = object.title
        
        let count1 = JSON(object.exerciseCount!).intValue
        if count1 > 1 {
            cell.lblExerciseVal.text    = "\(object.exerciseCount!)" + " " + AppMessages.Exercises
        }
        else {
            cell.lblExerciseVal.text    = "\(object.exerciseCount!)" + " " + AppMessages.Exercise
        }
        
        let count2 = JSON(object.breathingCount!).intValue
        if count2 > 1 {
            cell.lblBreathingVal.text   = "\(object.breathingCount!)" + " " + AppMessages.Exercises
        }
        else {
            cell.lblBreathingVal.text   = "\(object.breathingCount!)" + " " + AppMessages.Exercise
        }
        
        cell.btnSelectBreathing.isSelected  = object.breathingDone == "N" ? false : true
        cell.btnSelectExercise.isSelected   = object.exerciseDone == "N" ? false : true
        cell.btnExpand.isSelected           = object.isSelected
        
        cell.btnExpand.isHidden = false
        if self.object.routineData.count <= 1 {
            cell.btnExpand.isHidden = true
        }
        
        if object.isSelected ||
            self.object.routineData.count <= 1 {
            
            cell.stackDetails.isHidden = false
        }
        else {
            cell.stackDetails.isHidden = true
        }
        
        cell.stackExpand.addTapGestureRecognizer {
            object.isSelected = !object.isSelected
            self.tblView.reloadData()
        }
        
        cell.stackDetails.addTapGestureRecognizer {
            let obj                     = self.object
            let vc                      = ExerciseDetailsParentVC.instantiate(fromAppStoryboard: .exercise)
            vc.exercise_plan_day_id     = obj.exercisePlanDayId
            vc.routine_id               = "\(object.routine!)"
            vc.plan_type                = self.plan_type
            vc.exerciseAddedBy          = self.exerciseAddedBy
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: -------------------------- Observers Methods --------------------------
extension ExercisePlanDetailCell {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblViewHeight.constant = newvalue.height
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                if let vc = ((UIApplication.topViewController() as? ExerciseParentVC)?.pages[0] as? ExerciseMyPlanVC) {
                    
                    if let tbl = self.superview as? UITableView {
                        
                        if tbl.numberOfRows(inSection: 0) == vc.viewModel.getCount() {
                            if #available(iOS 15.0, *) {
                                UIView.performWithoutAnimation {
                                    tbl.performBatchUpdates {
                                        
                                    } completion: { isDone in
                                    }
                                    tbl.layoutIfNeeded()
                                }
                            }
                            else {
                                UIView.performWithoutAnimation {
                                    tbl.performBatchUpdates {
                                        
                                    } completion: { isDone in
                                    }
                                    tbl.layoutIfNeeded()
                                }
                            }
                        }
                    }
                }
                if let vc = (UIApplication.topViewController() as? ExercisePlanDetailVC) {
                    
                    if let tbl = self.superview as? UITableView {
                        if tbl.numberOfRows(inSection: 0) == vc.viewModel.getCount() {
                            if #available(iOS 15.0, *) {
                                UIView.performWithoutAnimation {
                                    tbl.performBatchUpdates {
                                        
                                    } completion: { isDone in
                                    }
                                    tbl.layoutIfNeeded()
                                }
                            }
                            else {
                                UIView.performWithoutAnimation {
                                    tbl.performBatchUpdates {
                                        
                                    } completion: { isDone in
                                    }
                                    tbl.layoutIfNeeded()
                                }
                                
                            }
                        }
                    }
                }
                 
                //                tbl.beginUpdates()
                //                tbl.endUpdates()
            }
        }
    }

    func addObserverOnHeightTbl() {
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let colView = self.tblView else {return}
        if let _ = colView.observationInfo {
            colView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
