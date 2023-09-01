//
//  CalendarCollectionViewCell.swift
//  HorizontalCalendar
//
//  Created by Raphael Seher on 29/12/15.
//  Copyright © 2015 Raphael Seher. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var reddotImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reddotImageView.layer.cornerRadius = 5
    }
    
    override func configureCalendarCell(_ cell: UICollectionViewCell, date: Date, active: Bool) -> UICollectionViewCell {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        reddotImageView.backgroundColor = UIColor.themePurple
        
        if active {
            dayLabel.font(name: .semibold, size: 15)
                .textColor(color: UIColor.white)
            monthLabel.font(name: .semibold, size: 15)
                .textColor(color: UIColor.white)
            
            reddotImageView.isHidden = false
        } else {
            dayLabel.font(name: .semibold, size: 15)
                .textColor(color: UIColor.themeBlack)
            monthLabel.font(name: .semibold, size: 15)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.4))
            reddotImageView.isHidden = true
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        self.monthLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "E"//"EEE"
        
        if Calendar.current.isDateInToday(date) {
            //monthLabel.text = "Today"
            self.dayLabel.text = dateFormatter.string(from: date)
        } else {
            self.dayLabel.text = dateFormatter.string(from: date)
        }
        
        return cell
    }
}
