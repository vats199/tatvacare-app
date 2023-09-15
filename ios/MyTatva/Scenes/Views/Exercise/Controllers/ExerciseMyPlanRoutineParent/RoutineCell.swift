//
//  RoutineCell.swift
//  MyTatva
//
//  Created by Hlink on 11/04/23.
//

import Foundation
class RoutineCell: UICollectionViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwSelector: UIView!
    
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
        self.lblTitle.font(name: .bold, size: 15.0)
        self.vwSelector.cornerRadius(cornerRadius: 2.0)
    }
    
    func configure() {
        
    }
    
    func setData(data: ExerciseDataModel) {
        self.lblTitle.textColor(color: data.isSelected ? .themePurple : .themeGray).text = data.title
        self.vwSelector.backGroundColor(color: data.isSelected ? .themePurple : .clear)
    }
    
}
