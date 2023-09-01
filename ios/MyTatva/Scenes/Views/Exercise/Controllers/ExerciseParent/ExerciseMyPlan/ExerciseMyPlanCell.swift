//
//  ExerciseMoreTblCell.swift


import UIKit
class ExerciseMyPlanCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var vwTitle              : UIView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var stackDaysSets        : UIStackView!
    @IBOutlet weak var stackDays            : UIStackView!
    @IBOutlet weak var stackSets            : UIStackView!
    
    @IBOutlet weak var lblDays              : UILabel!
    @IBOutlet weak var lblSets              : UILabel!
    
    @IBOutlet weak var lblBreathing         : UILabel!
    @IBOutlet weak var lblBreathingVal      : UILabel!
    @IBOutlet weak var lblExercise          : UILabel!
    @IBOutlet weak var lblExerciseVal       : UILabel!
    
    @IBOutlet weak var btnSelectExercise    : UIButton?
    @IBOutlet weak var btnSelectBreathing   : UIButton?
    
    var arraPlanType : [PlanType] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.white)
        
        self.lblDays
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.9))
        self.lblSets
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.9))
        
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
        
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    func setCellData(object: PlanDataModel){
        self.lblTitle.text          = object.title
        self.lblDays.text           = "\(object.totalDays!)" + " " + AppMessages.Days
        self.lblSets.text           = "\(object.exerciseSets!)" + " " + AppMessages.sets
        
        let count1 = JSON(object.exerciseCounts!).intValue
        if count1 > 1 {
            self.lblExerciseVal.text    = "\(object.exerciseCounts!)" + " " + AppMessages.Exercises
        }
        else {
            self.lblExerciseVal.text    = "\(object.exerciseCounts!)" + " " + AppMessages.Exercise
        }
        
        let count2 = JSON(object.breathingCounts!).intValue
        if count2 > 1 {
            self.lblBreathingVal.text   = "\(object.breathingCounts!)" + " " + AppMessages.Exercises
        }
        else {
            self.lblBreathingVal.text   = "\(object.breathingCounts!)" + " " + AppMessages.Exercise
        }
        
        self.stackDaysSets.isHidden     = true
        self.stackDays.isHidden         = true
        self.stackSets.isHidden         = true
        if object.totalDays > 0 {
            self.stackDays.isHidden     = false
            self.stackDaysSets.isHidden = false
        }
        if object.exerciseSets > 0 {
            self.stackSets.isHidden     = false
            self.stackDaysSets.isHidden = false
        }
    }
    
    func configureDetailsCell(object: PlanDaysListModel){
//        self.lblDays.text           = "\(object.totalDays!)" + " " + AppMessages.Days
//        self.lblSets.text           = AppMessages.sets + " " + "\(object.exerciseSets!)"
        
//        let time = GFunction.shared.convertDateFormate(dt: object.dayDate,
//                                                       inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
//                                                       outputFormat: DateTimeFormaterEnum.EEEEddMMMM.rawValue,
//                                                       status: .NOCONVERSION)
//
//
//        self.lblTitle.text      = time.0
        self.lblTitle.text      = object.day + ", " + "\(object.date!)" + " " + object.month//time.0
        
        self.stackDaysSets.isHidden     = true
        self.stackDays.isHidden         = true
        self.stackSets.isHidden         = true
        
        let count1 = JSON(object.exerciseCounts!).intValue
        if count1 > 1 {
            self.lblExerciseVal.text    = "\(object.exerciseCounts!)" + " " + AppMessages.Exercises
        }
        else {
            self.lblExerciseVal.text    = "\(object.exerciseCounts!)" + " " + AppMessages.Exercise
        }
        
        let count2 = JSON(object.breathingCounts!).intValue
        if count2 > 1 {
            self.lblBreathingVal.text   = "\(object.breathingCounts!)" + " " + AppMessages.Exercises
        }
        else {
            self.lblBreathingVal.text   = "\(object.breathingCounts!)" + " " + AppMessages.Exercise
        }
        
        self.btnSelectBreathing?.isSelected  = object.breathingDone == "N" ? false : true
        self.btnSelectExercise?.isSelected   = object.exerciseDone == "N" ? false : true
        
    }
    
}
