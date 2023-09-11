

import Foundation

class ExerciseFilterCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var colView          : UICollectionView!
    @IBOutlet weak var colViewHeight    : NSLayoutConstraint!
    
    //MARK:- Class Variable
    var arrData     = [JSON]()
    var object      = ExerciseFilterModel()
    var type: ExerciseFilterType = .exercise_tool
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addObserverOnHeightTbl()
        
        self.lblTitle.font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        self.setup(colView: self.colView)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.backGroundColor(color: .white)
        }
    }
    
    func setup(colView: UICollectionView){
        colView.delegate                   = self
        colView.dataSource                 = self
        colView.reloadData()
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
}

class ExerciseFilterColCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    
    //MARK:- Class Variable
    var arrData = [JSON]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.lblTitle.font(name: .medium, size: 12)
//            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            //    .backGroundColor(color: UIColor.themeLightGray)
        }
    }
}

//MARK: ------------------- UICollectionView Methods -------------------
extension ExerciseFilterCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colView:
            
            switch self.type {
            
            case .exercise_tool:
                if self.object.arrExercise_tools != nil {
                    return self.object.arrExercise_tools.count
                }
                
            case .genre:
                if self.object.filterGenreList != nil {
                    return self.object.filterGenreList.count
                }
                
            case .fitness_level:
                
                if self.object.arrFitnessLevel != nil {
                    return self.object.arrFitnessLevel.count
                }
            case .time:
                if self.object.arrTime != nil {
                    return self.object.arrTime.count
                }
            }
            
        default:
            return 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case self.colView:
            let cell : ExerciseFilterColCell = collectionView.dequeueReusableCell(withClass: ExerciseFilterColCell.self, for: indexPath)
            
            var isSelected = false
            switch self.type {
            
            case .exercise_tool:
                let obj = self.object.arrExercise_tools[indexPath.item]
                cell.lblTitle.text = obj.exerciseTools
                isSelected = obj.isSelected
                break
                
            case .genre:
                let obj = self.object.filterGenreList[indexPath.item]
                cell.lblTitle.text = obj.genre
                isSelected = obj.isSelected
                break
            case .fitness_level:
                let obj = self.object.arrFitnessLevel[indexPath.item]
                cell.lblTitle.text = obj.fitnessLevel
                isSelected = obj.isSelected
                break
                
            case .time:
                let obj = self.object.arrTime[indexPath.item]
                cell.lblTitle.text = obj.showTime
                isSelected = obj.isSelected
                break
                
            }
            
            if isSelected {
                cell.lblTitle.font(name: .medium, size: 12)
                    .textColor(color: UIColor.white)
                cell.vwBg.backGroundColor(color: UIColor.themeLightPurple)
            }
            else {
                cell.lblTitle.font(name: .medium, size: 12)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
                cell.vwBg.backGroundColor(color: UIColor.themeLightGray)
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colView:
            
            switch self.type {
            
            case .exercise_tool:
                let obj = self.object.arrExercise_tools[indexPath.item]
                self.object.arrExercise_tools = self.object.arrExercise_tools.filter({ (object) -> Bool in
                    if obj.exerciseTools == object.exerciseTools {
                        if object.isSelected {
                            object.isSelected = false
                        }
                        else {
                            object.isSelected = true
                        }
                    }
                    return true
                })
                
                break
                
            case .genre:
                let obj = self.object.filterGenreList[indexPath.item]
                self.object.filterGenreList = self.object.filterGenreList.filter({ (object) -> Bool in
                    if obj.genreMasterId == object.genreMasterId {
                        if object.isSelected {
                            object.isSelected = false
                        }
                        else {
                            object.isSelected = true
                        }
                    }
                    return true
                })
                
                break
            case .fitness_level:
                let obj = self.object.arrFitnessLevel[indexPath.item]
                self.object.arrFitnessLevel = self.object.arrFitnessLevel.filter({ (object) -> Bool in
                    if obj.fitnessLevel == object.fitnessLevel {
                        if object.isSelected {
                            object.isSelected = false
                        }
                        else {
                            object.isSelected = true
                        }
                    }
                    return true
                })
                break
                
            case .time:
                let obj = self.object.arrTime[indexPath.item]
                self.object.arrTime = self.object.arrTime.filter({ (object) -> Bool in
                    if obj.showTime == object.showTime {
                        if object.isSelected {
                            object.isSelected = false
                        }
                        else {
                            object.isSelected = true
                        }
                    }
                    return true
                })
                break
                
            //default:break
            }
            break
            
        default: break
        }
        self.colView.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colView:
            var width: CGFloat  = 100
            //let width       = self.colView.frame.size.width
            switch self.type {
            
            case .exercise_tool:
                let obj = self.object.arrExercise_tools[indexPath.item]
                width   = obj.exerciseTools.width(withConstraintedHeight: 30, font: UIFont.customFont(ofType: .medium, withSize: 12.0))
                break
                
            case .genre:
                let obj = self.object.filterGenreList[indexPath.item]
                width   = obj.genre.width(withConstraintedHeight: 30, font: UIFont.customFont(ofType: .medium, withSize: 12.0))
                break
            case .fitness_level:
                let obj = self.object.arrFitnessLevel[indexPath.item]
                width   = obj.fitnessLevel.width(withConstraintedHeight: 30, font: UIFont.customFont(ofType: .medium, withSize: 12.0))
                
            case .time:
                let obj = self.object.arrTime[indexPath.item]
                width   = obj.showTime.width(withConstraintedHeight: 30, font: UIFont.customFont(ofType: .medium, withSize: 12.0))
          
            }
            let height      = 40 * ScreenSize.widthAspectRatio
            
            return CGSize(width: width + 40,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: -------------------------- Observers Methods --------------------------
extension ExerciseFilterCell {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UICollectionView, obj == self.colView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            let oldHeight = self.colViewHeight.constant
            self.colViewHeight.constant = newvalue.height
            
            if let tbl = self.superview as? UITableView {
                if oldHeight != self.colViewHeight.constant {
                    
                    tbl.performBatchUpdates {
                        
                    } completion: { isDone in
                        
                    }
                    tbl.layoutIfNeeded()
                   
//                    tbl.beginUpdates()
//                    tbl.endUpdates()
                }
            }
//            if let tbl = self.superview as? UITableView {
//                if oldHeight != self.colViewHeight.constant {
//                    tbl.reloadData()
//                }
//            }
            
        }
   
    }
    
    func addObserverOnHeightTbl() {
        self.colView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let colView = self.colView else {return}
        if let _ = colView.observationInfo {
            colView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
