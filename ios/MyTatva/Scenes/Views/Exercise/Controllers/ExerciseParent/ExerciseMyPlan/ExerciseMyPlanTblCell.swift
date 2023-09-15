//
//  ExerciseMoreTblCell.swift


import UIKit
class ExerciseMyPlanTblCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var vwTitle              : UIView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var vwTable              : UIView!
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var tblViewHeight        : NSLayoutConstraint!
    
    var arraPlanType : [PlanType] = []
    
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
    
    func configInnerTableCell(object : PlanDataModel){
        
//        if Int(object.breathingCounts) != 0{
//
//        }
//        if Int(object.exerciseCounts) != 0{
//
//        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            self.arraPlanType.removeAll()
            
            
            self.arraPlanType.append(PlanType(title: AppMessages.Breathing,
                                              plantypeCount: object.breathingCounts,
                                              isDone: object.breathingDone,
                                              image: UIImage(named: "breatinhg_plan_temp")))
            self.arraPlanType.append(PlanType(title:AppMessages.Exercise,
                                              plantypeCount: object.exerciseCounts,
                                              isDone: object.exerciseDone,
                                              image: UIImage(named: "exercise_plan_temp")))
            self.tblView.reloadData()
        }
    }
    
    func configInnerTableCell(withPlanDays object : PlanDaysListModel){
//        self.arraPlanType.removeAll()
//        
//        self.arraPlanType.append(PlanType(title: AppMessages.Breathing,
//                                          plantypeCount: JSON(object.breathingCounts!).stringValue,
//                                          isDone: object.breathingDone,
//                                          image: UIImage(named: "breatinhg_plan_temp")))
//        
//        self.arraPlanType.append(PlanType(title: AppMessages.Exercise,
//                                          plantypeCount: JSON(object.exerciseCounts!).stringValue,
//                                          isDone: object.exerciseDone,
//                                          image: UIImage(named: "exercise_plan_temp")))
        
//        if Int(object.breathingCounts) != 0{
//
//        }
//        if Int(object.exerciseCounts) != 0{
//
//        }
        self.tblView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            self.tblView.reloadData()
        }
    }
}

class ExerciseMyPlanChildCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var imgView              : UIImageView!
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var btnSelect            : UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 17)
            .textColor(color: UIColor.themeBlack)
        
        self.lblDesc
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.9))
    
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
        }
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension ExerciseMyPlanTblCell: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arraPlanType.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ExerciseMyPlanChildCell = tableView.dequeueReusableCell(withClass: ExerciseMyPlanChildCell.self, for: indexPath)
        let object          = self.arraPlanType[indexPath.row]
        cell.lblTitle.text  = object.title
        let count = JSON(object.plantypeCount!).intValue
        
        if count > 1 {
            cell.lblDesc.text   = "\(count)" + " " + AppMessages.Exercises
        }
        else {
            cell.lblDesc.text   = "\(count)" + " " + AppMessages.Exercise
        }
        
        //cell.lblDesc.text   = Int(object.plantypeCount) > 1 ?  object.plantypeCount + " " + AppMessages.Exercises : object.plantypeCount + " " + AppMessages.Exercise
        cell.imgView.image  = object.image
        let image = object.isDone == "N" ? UIImage(named: "exercise_uncheck") : UIImage(named: "exercise_check")
        cell.btnSelect.setImage(image, for: .normal)

        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: -------------------------- Observers Methods --------------------------
extension ExerciseMyPlanTblCell {
    
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
