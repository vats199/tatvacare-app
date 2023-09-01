//
//  Date+Extension.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

enum DateConvertionType {
    case local, utc, noconversion
}

extension Date {
    var firstDayOfWeek: Date {
        var beginningOfWeek = Date()
        var interval = TimeInterval()
        
        _ = Calendar.current.dateInterval(of: .weekOfYear, start: &beginningOfWeek, interval: &interval, for: self)
        return beginningOfWeek
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        let cal = Calendar.current
        var components = DateComponents()
        components.day = 1
        return cal.date(byAdding: components, to: self.startOfDay)!.addingTimeInterval(-1)
    }
    
    var zeroBasedDayOfWeek: Int? {
        let comp = Calendar.current.component(.weekday, from: self)
        return comp - 1
    }
    
    var percentageOfDay: Double {
        let totalSeconds = self.endOfDay.timeIntervalSince(self.startOfDay) + 1
        let seconds = self.timeIntervalSince(self.startOfDay)
        let percentage = seconds / totalSeconds
        return max(min(percentage, 1.0), 0.0)
    }
    
    var numberOfWeeksInMonth: Int {
        let calendar = Calendar.current
        let weekRange = (calendar as NSCalendar).range(of: NSCalendar.Unit.weekOfYear, in: NSCalendar.Unit.month, for: self)
        
        return weekRange.length
    }
    
    func addWeeks(_ numWeeks: Int) -> Date {
        var components = DateComponents()
        components.weekOfYear = numWeeks
        
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func addDays(_ numDays: Int) -> Date {
        var components = DateComponents()
        components.day = numDays
        
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func addMinutes(_ numMinutes: Double) -> Date {
        return self.addingTimeInterval(60 * numMinutes)
    }
    
    func weeksAgo(_ numWeeks: Int) -> Date {
        return addWeeks(-numWeeks)
    }
    
    func daysAgo(_ numDays: Int) -> Date {
        return addDays(-numDays)
    }
    
    func addHours(_ numHours: Int) -> Date {
        var components = DateComponents()
        components.hour = numHours
        
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func hoursAgo(_ numHours: Int) -> Date {
        return addHours(-numHours)
    }
    
    func minutesAgo(_ numMinutes: Double) -> Date {
        return addMinutes(-numMinutes)
    }
    
    func hoursFrom(_ date: Date) -> Double {
        return Double(Calendar.current.dateComponents([.hour], from: date, to: self).hour!)
    }
    
    func daysBetween(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self.startOfDay, to: date.startOfDay)
        
        return components.day!
    }
    
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    public func timeAgoSince() -> String {
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])
        
//        if let year = components.year, year >= 2 {
//            return "\(year)" + " years ago".localized
//        }
//
//        if let year = components.year, year >= 1 {
//            return "\(year)" + " year ago".localized
//        }
//
//        if let month = components.month, month >= 2 {
//            return "\(month)" + " months ago".localized
//        }
//
//        if let month = components.month, month >= 1 {
//            return "\(month)" + " month ago".localized
//        }
//
//        if let week = components.weekOfYear, week >= 2 {
//            return "\(week)" + " weeks ago".localized
//        }
//
//        if let week = components.weekOfYear, week >= 1 {
//            return "\(week)" + " week ago".localized
//        }
//
//        if let day = components.day, day >= 2 {
//            return "\(day)" + " days ago".localized
//        }
        
        if let day = components.day, day >= 2 {
        //            return "\(day)" + " days ago".localized
            
            let dateFormatter               = DateFormatter()
            dateFormatter.dateFormat        = DateTimeFormaterEnum.ddmm_yyyy.rawValue
            dateFormatter.timeZone          = .current
            return dateFormatter.string(from: self)
            
                }
            
        if let day = components.day, day >= 1 {
            //return "\(day)" + " day ago".localized
            return " yesterday".localized
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour)" + " hrs ago".localized
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)" + " hr ago".localized
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute)" + " min ago".localized
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)" + " min ago".localized
        }
        
        if let second = components.second, second < 60 {
            //return "\(second)" + " just now".localized
            return " just now".localized
        }
        
        return "Just now".localized
    }
    
    //MARK: - convert date to local
    func convertToLocal() -> Date {
        
        let sourceTimeZone = TimeZone(abbreviation: "UTC")
        let destinationTimeZone = TimeZone.current
        
        //calculate interval
        let sourceGMTOffset : Int = (sourceTimeZone?.secondsFromGMT(for: self))!
        let destinationGMTOffset : Int = destinationTimeZone.secondsFromGMT(for:self)
        let interval : TimeInterval = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: Date = Date(timeInterval: interval, since: self)
        return date
    }
    
    //MARK: - convert date to utc
    func convertToUTC() -> Date {
        
        let sourceTimeZone = TimeZone.current
        let destinationTimeZone = TimeZone(abbreviation: "UTC")
        
        //calc time difference
        let sourceGMTOffset : Int = (sourceTimeZone.secondsFromGMT(for: self))
        let destinationGMTOffset : Int = destinationTimeZone!.secondsFromGMT(for: self)
        let interval : TimeInterval = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: Date = Date(timeInterval: interval, since: self)
        return date
    }
    
    //MARK: - convert date to another format and string format
    func convertDateFormat(output format: DateFormatter, type: DateConvertionType) -> (String, Date) {
        if type == .utc {
            let convertedDate = self.convertToUTC()
            return (format.string(from: convertedDate), convertedDate)
        } else {
            let convertedDate = self.convertToLocal()
            return (format.string(from: convertedDate), self.convertToLocal())
        }
    }
    
    //MARK: - convert date to string
    func toString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
            var dates: [Date] = []
            var date = fromDate
            
            while date <= toDate {
                dates.append(date)
                guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
                date = newDate
            }
            return dates
        }
}

extension Int{
    var size: Int {
        // Store the total count
        var count = 0
        
        // Store the number
        var num = self
        
        // Checking the number for 0
        // If yes print 1
        if (num == 0){
            return 1
        }
        
        // Check for the positive number
        while (num > 0){
            
            // Divide the num by 10 and store
            // the quotient into the num variable
            num = num / 10
            
            // If the quotient is not zero, then update the
            // count by one. If the quotient is zero,
            // then stop the count
            count += 1
        }
        return count
    }
    
    func minutesToHoursAndMinutes () -> (hours : Int , leftMinutes : Int) {
        return (self / 60, (self % 60))
    }
    
    var roundedWithAbbreviations: String {
        let number      = Double(self)
        let thousand    = number / 1000
        let million     = number / 1000000
        let billion     = number / 1000000000
        
        if billion >= 1.0 {
            return ("\(round(billion*10/10))B")
        }
        else if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(self)"
        }
    }
}


extension DateFormatter {
    // Static date formatter
    enum Format: String {
        case yyyymmdd           = "yyyy-MM-dd"
        case MMM_d_Y            = "MMM d, yyyy"
        case HHmmss             = "HH:mm:ss"
        case hhmma              = "hh:mma"
        case HHmm               = "HH:mm"
        case dmmyyyy            = "d/MM/yyyy"
        case hhmmA              = "hh:mm a"
        case UTCFormat          = "yyyy-MM-dd HH:mm:ss"
        case UTCFormatWith12H   = "yyyy-MM-dd hh:mm a"
        case NodeUTCFormat      = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case ddmm_yyyy          = "dd MMM, yyyy"
        case WeekDayhhmma       = "EEE,hh:mma"
        case dmm_hhmm           = "d MMM, hh:mma"
        case ddmonyyyy          = "dd MMMM, yyyy"
        case ddmm_yyyy_hhmm     = "dd MMM, yyyy. hh:mm a"
        case yyyyddmm           = "yyyy-dd-MM"
        case ddmmyyyyWithoutSpace = "dd-MM-yyyy"
        case nameddmmyyyy       = "EEEE, dd/MM/yyyy"
        case mmmmddyyyy         = "MMMM dd, yyyy"
        case ddmmyyyy           = "dd/MM/yyyy"
        case nameMMMddyyyy      = "EEEE,  MMMM dd,  yyyy"
        case ddMMyyyyHHmmss     = "dd-MM-yyyy HH:mm:ss"
    }
    
    static func `default`(format: Format) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter
    }
}

extension String {
    func toDate(from format: DateFormatter = .default(format: .yyyyddmm)) -> Date? {
        return format.date(from: self)
    }
    
    //MARK: - change string date format
    func changeDateFormat(from format: DateFormatter, to outputFormat: DateFormatter, type: DateConvertionType) -> String? {
        return format.date(from: self)?.convertDateFormat(output: outputFormat, type: type).0
    }
}

extension DateFormatter {
    
    private static var dateFormatter = DateFormatter()
    
    class func initWithSafeLocale(withDateFormat dateFormat: String? = nil) -> DateFormatter {
        
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar.init(identifier: .gregorian)
        if let format = dateFormat {
            dateFormatter.dateFormat = format
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return dateFormatter
    }
}

/*
 Examples
 
 print("Date: ", Date())
 print(Date().toString(style: .short))
 let localDate = Date().convertToLocal()
 print(localDate)
 print(localDate.convertToUTC())
 print(Date().convertDateFormat(output: .default(format: .ddMMMyyyyhhmma), type: .utc))

 let getDate = "2021-03-02T13:00:00.208Z".toDate(from: .default(format: .yyyyMMddTHHmmssSSSZ))
 print(getDate ?? Date())
 print(getDate?.toString(style: .medium) ?? "")

 print("2021-03-02T13:00:00.208Z".changeDateFormat(from: .default(format: .yyyyMMddTHHmmssSSSZ), to: .default(format: .ddMMMyyyy), type: .noconversion) ?? Date().toString(style: .short))
 */
