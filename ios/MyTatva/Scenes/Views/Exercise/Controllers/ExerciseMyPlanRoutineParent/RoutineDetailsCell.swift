//
//  RoutineDetailsCell.swift
//  MyTatva
//
//  Created by Hlink on 12/04/23.
//

import Foundation

class RoutineDetailsCell: UITableViewCell {
    //MARK: - Outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vwDone: UIView!
    @IBOutlet weak var imgDone: UIImageView!
    @IBOutlet weak var lblDone: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var vwDetail: UIView!
    
    @IBOutlet weak var vwDifficult: UIView!
    @IBOutlet weak var imgDifficult: UIImageView!
    @IBOutlet weak var lblDifficult: UILabel!
    @IBOutlet weak var btnDifficulty: UIButton!
    
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var btnVideo: UIButton!
    
    @IBOutlet var arrTitleValues: [UILabel]!
    @IBOutlet weak var lblExerciseType: UILabel!
    @IBOutlet weak var lblReps: UILabel!
    @IBOutlet weak var lblSets: UILabel!
    @IBOutlet weak var lblRestPostSets: UILabel!
    @IBOutlet weak var lblRestPostExercise: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblReadMore: UILabel!
    
    //MARK: - Class Variables
    
    //MARK: - deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(self) ‼️‼️‼️")
    }
    
    //MARK: - LifeCycleMethods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    //MARK: - Custom Methods
    private func applyStyle() {
        self.backGroundColor(color: .clear)
        self.contentView.backGroundColor(color: .clear)
        
        self.lblTitle.font(name: .semibold, size: 16.0).textColor(color: .themeBlack)
        self.lblDesc.font(name: .regular, size: 14.0).textColor(color: .themeBlack.withAlphaComponent(0.5)).numberOfLines = 2
        
        self.lblReadMore.font(name: .medium, size: 14.0).textColor(color: .themePurple).text = "Read More"
        
        [self.lblExerciseType,self.lblReps,self.lblSets,self.lblRestPostSets,self.lblRestPostExercise].forEach({ $0.font(name: .medium, size: 13.0).textColor(color: .themeBlack) })
        self.arrTitleValues.forEach({ $0.font(name: .medium, size: 13.0).textColor(color: .themeBlack.withAlphaComponent(0.5)) })
        
        self.imgVideo.backGroundColor(color: .white)
        
        self.vwDifficult.cornerRadius(cornerRadius: 6.0)
        self.vwDone.borderColor(color: .ThemeBorder, borderWidth: 1.0).cornerRadius(cornerRadius: 6.0)
        [self.lblDone,self.lblDifficult].forEach({ $0.font(name: .medium, size: 16.0).textColor(color: .themeGray3).text = "Done" })
        
    }
    
    func configure(data: ExerciseDetailModel) {
        self.lblTitle.text = data.title
        self.lblExerciseType.text = data.breathingExercise
        self.lblReps.text = data.reps
        self.lblSets.text = data.sets
        self.lblRestPostSets.text = data.restPostSets + " " + data.restPostSetsUnit
        self.lblRestPostExercise.text = data.restPostExercise + " " + data.restPostExerciseUnit
        self.lblDesc.text = data.descriptionField.htmlToString
        
        self.vwDone.isHidden = GFunction.shared.convertDateFormat(dt: data.date, inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue, outputFormat: DateTimeFormaterEnum.UTCFormat.rawValue, status: .NOCONVERSION).date > Date()
        
        self.imgDone.image = UIImage(named: data.isDone ? "routine_checked" : "routine_un_checked")
        self.vwDifficult.isHidden = !data.isDone
        let difficulty = (data.difficultyLevel ?? "")
        self.lblDifficult.text = AppMessages.difficulty + (difficulty.isEmpty ? "" : (" : " + difficulty))
        self.imgDifficult.image = UIImage(named: difficulty.isEmpty ? "routine_un_checked" : "routine_checked")
//        self.btnDone.isUserInteractionEnabled = !data.isDone
//        self.btnDifficulty.isUserInteractionEnabled = difficulty.isEmpty
        self.imgVideo.setCustomImage(with: data.media.imageUrl)
        self.imgVideo.contentMode = .scaleAspectFill
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwDetail.cornerRadius(cornerRadius: 15)
            self.vwDetail.themeShadow()
            self.imgVideo.roundCorners([.topLeft,.topRight], radius: 15.0)
        }
        
    }
    
}
