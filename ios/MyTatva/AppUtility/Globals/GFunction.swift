//
//  GFunction.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation
import MessageUI
import Siren
import SafariServices
import CoreLocation
import Foundation
import WatchConnectivity
import UserNotifications
import KDCircularProgress
import AVKit
import PDFKit

enum ConvertType {
    case LOCAL,UTC,NOCONVERSION
}

@objc class GFunction: UIViewController {
    
    ///Shared instance
    static let shared: GFunction = GFunction()
    var isCheckedin: Bool           = false
    var isOpenTab: Bool             = false
    var datingModeIsOn: Bool        = false
    var menuType: MenuType          = .Food
    var selectedIndex: Int          = 1
    var cartItem: Int               = 0
    
    var videoUrl: URL?
    var player: AVPlayer?
    let avPVC                       = AVPlayerViewController()
    var content_master_id           = ""
    var content_type                = ""
    
    //------------------------------------------------------
    //MARK: - Date
    
    /// Return date after add hours and minute to current date
    ///
    /// - Parameters:
    ///   - hour: Hour for add in current date
    ///   - minute: Minute for add in current date
    ///
    /// - Returns: Return current date after adding given hour and minute
    func setMinMaxDate(hour: Int, minute: Int) -> Date {
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components1 = gregorian.components(NSCalendar.Unit(rawValue: UInt(NSIntegerMax)), from: Date())
        components1.hour = hour
        components1.minute = minute
        return gregorian.date(from: components1)!
    }
    
    //------------------------------------------------------
    
    //------------------------------------------------------
    //MARK: - sharing
    
    /// Open share sheet controller
    ///
    /// - Parameters:
    ///   - vc: View controller
    ///   - link: Any link or string for sharing
    func openShareSheet(this:UIViewController, msg:String) {
        
        let textToShare = [ msg ] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = this.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop , UIActivity.ActivityType.addToReadingList , UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.copyToPasteboard,UIActivity.ActivityType.print,UIActivity.ActivityType.saveToCameraRoll]
        
        // present the view controller
        DispatchQueue.main.async {
            this.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func rateApp() {
        guard let url = URL(string: AppCredential.appStoreLink) else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    //------------------------------------------------------
    //MARK: - Backspace
    
    /// To check if input string is backspace or not
    ///
    /// - Parameters:
    ///   - inputString: String to check is backspace or not
    /// - Returns: Return true if string is backspace else false
    func isBackspace(_ inputString : String) -> Bool {
        let  char = inputString.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            return true
        } else {
            return false
        }
    }
    
    //------------------------------------------------------
    //MARK: App Update Alert
    
    /// To show alert for app update
    ///
    /// - Parameters:
    ///   - update: App update results data
    func appUpdateAvailable(_ update : UpdateResults) {
        debugPrint("Update available")
        
        let text = "A new version of " + Bundle.main.displayName + " is available. Please update to version " + update.model.version + " now."
        let alertControl = UIAlertController(title: "Update Available", message: text, preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "Update", style: .default) { (action) in
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(AppCredential.appStoreID.rawValue)"),
               UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Next Time", style: .default) { (action) in
            
        }
        
        alertControl.addAction(cancelAction)
        alertControl.addAction(updateAction)
        if let topVC = UIApplication.topViewController(){
            topVC.present(alertControl, animated: true, completion: nil)
        }
        
    }
    
    //------------------------------------------------------
    //MARK: Open system call pad
    
    /// Open system call dilog
    /// - Parameter number: Call number string
    func makeCall(_ number: String = "1234567890") {
        var phoneNumber : String = "telprompt://\(number)"
        phoneNumber = self.makeValidNumber(phoneNumber)
        
        if let url = URL(string: phoneNumber), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } else {
            Alert.shared.showSnackBar(AppMessages.carrierNotAvailable)
        }
    }
    
    /// Validate phone number
    /// - Parameter phoneNumber: Call number string
    /// - Returns: Return proper valid number string
    private func makeValidNumber(_ phoneNumber : String) -> String {
        var number : String = phoneNumber
        number = number.replacingOccurrences(of: "+", with: "")
        number = number.replacingOccurrences(of: " ", with: "")
        number = number.trimmingCharacters(in: .whitespacesAndNewlines)
        return number
    }
    
    //------------------------------------------------------
    //MARK: Send mail
    
    /// Open mail app with predefine with given mail id, body and subject
    /// - Parameters:
    ///   - mail: Mail id which is to send
    ///   - body: Mail body
    ///   - subject: Mail subject
    func sendMail(to mail: String, with body: String, subject: String) {
        //Open mail app if avaialbe else open it open in browser.
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients([mail])
            mailController.setMessageBody(body, isHTML: true)
            mailController.setSubject(subject)
            if let topVC = UIApplication.topViewController() {
                topVC.present(mailController, animated: true)
            }
        } else {
            let subject = subject
            let coded = "mailto:\(mail)?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: coded!) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    //------------------------------------------------------
    //MARK: Google map redirection
    
    /// Open google map redirection app
    /// - Parameters:
    ///   - lat: Latitude
    ///   - long: longitude
    func openGoogleMap(_ lat: String, _ long: String) {
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?center=\(lat),\(long)&zoom=18&views=traffic&q=\(lat),\(long)")!, options: [:], completionHandler: nil)
            
        } else {
            let url = URL(string: "https://maps.google.com/?q=@\(lat),\(long)")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
            print("Can't use comgooglemaps://")
        }
    }
    
    func openLink(strLink: String, inApp: Bool){
        guard let url = URL(string: strLink) else { return }
        if inApp {
            let safariVC        = SFSafariViewController(url: url)
            safariVC.delegate   = self
            UIApplication.topViewController()?.present(safariVC, animated: true, completion: nil)
        }
        else {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: ---------------- Apply Gradient ----------------------
    func applyGradient(toView: UIView, colours: [UIColor], locations: [NSNumber]?, startPoint: CGPoint, endPoint: CGPoint) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = toView.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = startPoint//CGPoint(x: 0, y: 1)
        gradient.endPoint = endPoint//CGPoint(x: 1, y: 0)
        toView.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradientColor(startColor: UIColor, endColor: UIColor ,locations: [CGFloat], startPoint: CGPoint, endPoint: CGPoint, gradiantWidth : CGFloat, gradiantHeight : CGFloat) -> UIColor {
        
        var startColorRed:CGFloat   = 0
        var startColorGreen:CGFloat = 0
        var startColorBlue:CGFloat  = 0
        var startAlpha:CGFloat      = 0
        
        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return UIColor()
        }
        
        var endColorRed:CGFloat     = 0
        var endColorGreen:CGFloat   = 0
        var endColorBlue:CGFloat    = 0
        var endAlpha:CGFloat        = 0
        
        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return UIColor()
        }
        
        UIGraphicsBeginImageContext(CGSize(width: gradiantWidth, height: gradiantHeight))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIColor()
        }
        
        UIGraphicsPushContext(context)
        
        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t    = 2
        let locations:[CGFloat]     = locations
        let components:[CGFloat]    = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace               = CGColorSpaceCreateDeviceRGB()
        glossGradient               = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        
        context.drawLinearGradient(glossGradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        UIGraphicsPopContext()
        
        guard let gradientImage     = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return UIColor()
        }
        
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: gradientImage)
    }
    
    func applyGradientColor(colors: [UIColor], locations: [CGFloat], startPoint: CGPoint, endPoint: CGPoint, gradiantWidth : CGFloat, gradiantHeight : CGFloat) -> UIColor {
        
        var components:[CGFloat]!
        for color in colors {
            var startColorRed:CGFloat   = 0
            var startColorGreen:CGFloat = 0
            var startColorBlue:CGFloat  = 0
            var startAlpha:CGFloat      = 0
            
            if !color.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
                return UIColor()
            }
            
            components.append(contentsOf: [startColorRed, startColorGreen, startColorBlue, startAlpha])
        }
        
        UIGraphicsBeginImageContext(CGSize(width: gradiantWidth, height: gradiantHeight))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIColor()
        }
        
        UIGraphicsPushContext(context)
        
        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t    = 2
        let locations:[CGFloat]     = locations
        rgbColorspace               = CGColorSpaceCreateDeviceRGB()
        glossGradient               = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        
        context.drawLinearGradient(glossGradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        UIGraphicsPopContext()
        
        guard let gradientImage     = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return UIColor()
        }
        
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: gradientImage)
    }
}

//MARK:- MFMailComposeViewControllerDelegate Delegate
extension GFunction: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension GFunction{
    
    //MARK: - convert date to local -
    func convertToLocal(sourceDate : NSDate)-> NSDate{
        
        let sourceTimeZone                                      = NSTimeZone(abbreviation: "UTC")
        let destinationTimeZone                                 = NSTimeZone.system
        
        //calc time difference
        let sourceGMTOffset         : NSInteger                 = (sourceTimeZone?.secondsFromGMT(for: sourceDate as Date))!
        let destinationGMTOffset    : NSInteger                 = destinationTimeZone.secondsFromGMT(for:sourceDate as Date)
        let interval                : TimeInterval              = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: NSDate                                        = NSDate(timeInterval: interval, since: sourceDate as Date)
        return date
    }
    
    //MARK: - convert date to utc -
    func convertToUTC(sourceDate : NSDate)-> NSDate{
        
        let sourceTimeZone                                      = NSTimeZone.system
        let destinationTimeZone                                 = NSTimeZone(abbreviation: "UTC")
        
        //calc time difference
        let sourceGMTOffset         : NSInteger                 = (sourceTimeZone.secondsFromGMT(for:sourceDate as Date))
        let destinationGMTOffset    : NSInteger                 = destinationTimeZone!.secondsFromGMT(for: sourceDate as Date)
        let interval                : TimeInterval              = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: NSDate                                        = NSDate(timeInterval: interval, since: sourceDate as Date)
        return date
    }
    
    func convertDateFormat(dt: String, inputFormat: String, outputFormat: String, status: ConvertType) -> (str : String, date : Date) {
        let dateFormatter: DateFormatter = DateFormatter()
        if status == .LOCAL || status == .NOCONVERSION {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        dateFormatter.dateFormat = inputFormat
        
        var date : NSDate!
        if let dt = dateFormatter.date(from: dt) {
            
            if status == .LOCAL {
                date = self.convertToLocal(sourceDate: dt as NSDate)
            } else if status == .UTC {
                date = self.convertToUTC(sourceDate: dt as NSDate)
            } else {
                date = dt as NSDate
            }
            
            dateFormatter.dateFormat = outputFormat
            
            let strDate = dateFormatter.string(from: date as Date)
            return (str : strDate, date : dateFormatter.date(from: strDate) ?? Date())
        } else {
            return (str : "", date : Date())
        }
    }
    
    func relativeDateForChat(dateString: String) -> (display: String, isToday : Bool, isYesterday : Bool) {
        
        if dateString.isEmpty {
            return (display: "", isToday : false, isYesterday : false)
        }
        
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = DateTimeFormaterEnum.yyyymmdd.rawValue
        //            DateTimeFormaterEnum.yyyyMMddHHmmss.rawValue
        
        guard let convertDate = formatter.date(from: dateString) as NSDate? else {
            return (display: "", isToday : false, isYesterday : false)
        }
        
        var returnValue = ""
        let date = self.convertToLocal(sourceDate: convertDate)
        
        let date1 = Date()
        let components: DateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .month, .year, .second], from: date as Date, to: date1)
        
        if components.day! > 0 || components.month! > 0 || components.year! > 0{
            
            if components.day! == 1 && components.month! == 0 && components.year! == 0{
                returnValue = "Yesterday"
                return (display: returnValue, isToday : false,isYesterday : true)
            }else{
                returnValue = GFunction.shared.convertDateFormat(dt: dateString, inputFormat: DateTimeFormaterEnum.ddMMMYYYYhhmma.rawValue, outputFormat: DateTimeFormaterEnum.ddMMyyyy.rawValue, status: .NOCONVERSION).str
            }
        }else {
            returnValue = GFunction.shared.convertDateFormat(dt: dateString, inputFormat: DateTimeFormaterEnum.ddMMMYYYYhhmma.rawValue, outputFormat: DateTimeFormaterEnum.hhmma.rawValue, status: .NOCONVERSION).str
            return (display: returnValue, isToday : true,isYesterday : false)
        }
        
        return (display: returnValue, isToday : false,isYesterday : false)
    }
    
    //Redirect to google map
    func openGoogleMap(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D){
        
        //"https://www.google.co.th/maps/place/40.7534168,-73.9841088"
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            //            UIApplication.shared.open(NSURL(string:
            //                "comgooglemaps://?saddr=\(origin.latitude),\(origin.longitude)&daddr=\(destination.latitude),\(destination.longitude)&directionsmode=driving")! as URL)
            
            UIApplication.shared.open(NSURL(string:
                                                "comgooglemaps://?center=\(origin.latitude),\(origin.longitude)&zoom=14&q=\(destination.latitude),\(destination.longitude)")! as URL)
            
        }
        else {
            //            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=\(origin.latitude),\(origin.longitude)&daddr=\(destination.latitude),\(destination.longitude)&directionsmode=driving") {
            
            
            
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/?q=\(destination.latitude),\(destination.longitude)&zoom=14") {
                
                //UIApplication.shared.open(urlDestination)
                let safariVC        = SFSafariViewController(url: urlDestination)
                safariVC.delegate   = self
                AppDelegate.shared.window?.rootViewController?.present(safariVC, animated: true, completion: nil)
            }
            NSLog("Can't use com.google.maps://");
        }
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<4:
            return kGM
        case 4..<12:
            return kGM
        case 12..<18:
            return kGA
        case 18..<24:
            return kGE
        default:
            break
        }
        return kGM
    }
    
    func updateNotification(btn: UIButton){
        if let count = UserModel.shared.unreadNotifications {
            GFunction.shared.setBadge(view: btn, value: count)
            if count > 0 {
                //btn.isSelected = true
            }
            else {
                //btn.isSelected = false
            }
        }
    }
    
    func updateCartCount(btn: UIButton,_ isBadges: Bool = true,vm: PurchsedCarePlanVM? = nil, isPlanExpired: Bool = false){
        GlobalAPI.shared.get_cart_infoAPI { isDone, count, isBCPFlag in
            
            if isBadges {
                GFunction.shared.setBadge(view: btn, value: count)
            }
            
            btn.addTapGestureRecognizer {
                
                guard !isPlanExpired else {
                    return
                }
                
                if count > 0 || isBCPFlag {
                    //                    let vc = LabTestCartVC.instantiate(fromAppStoryboard: .carePlan)
                    
                    if let vm = vm {
                        var params              = [String : Any]()
                        params[AnalyticsParameters.plan_id.rawValue]            = vm.planDetails.planMasterId
                        FIRAnalytics.FIRLogEvent(eventName: .TAP_LABTEST_CARD,
                                                 screen: .BcpPurchasedDetails,
                                                 parameter: params)
                    }
                    
                    let vc = BCPCartDetailVC.instantiate(fromAppStoryboard: .BCP_temp)
                    vc.pateintPlanRefID = vm?.planDetails.patientPlanRelId ?? ""
                    vc.hidesBottomBarWhenPushed = true
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    Alert.shared.showSnackBar(AppMessages.YourCartIsEmpty, isError: true, isBCP: true)
                }
            }
        }
    }
    
    //    func chunked(array: [[String: Any]],
    //                 size: Int) -> [[[String: Any]]] {
    //        var arr = [[[String: Any]]]()
    //        var tempChunk = [[String: Any]]()
    //
    //        if array.count <= size {
    //            arr.append(array)
    //        }
    //        else {
    //            for i in 0...array.count - 1 {
    //
    //                tempChunk.append(array[i])
    //                if (i + 1) % size == 0 {
    //                    arr.append(tempChunk)
    //                }
    //            }
    //        }
    //
    //        return arr
    //    }
    
    func chunked(array: [[String: Any]],
                 into size: Int) -> [[[String: Any]]] {
        return stride(from: 0, to: array.count, by: size).map {
            Array(array[$0 ..< Swift.min($0 + size, array.count)])
        }
    }
    
    func convertDateFormate(dt: String, inputFormat: String, outputFormat: String, status: ConvertType) -> (String, Date) {
        let dateFormatter: DateFormatter = DateFormatter()
        if status == .LOCAL || status == .NOCONVERSION {
            if let languageArray = UserDefaults.standard.value(forKey: "AppleLanguages") as? Array<String> {
                dateFormatter.locale = Locale(identifier: languageArray[0])
            }
        }
        dateFormatter.dateFormat = inputFormat
        
        var date : NSDate!
        if let dt = dateFormatter.date(from: dt) {
            
            if status == .LOCAL {
                date = self.convertToLocal(sourceDate: dt as NSDate)
            } else if status == .UTC {
                date = self.convertToUTC(sourceDate: dt as NSDate)
            } else {
                date = dt as NSDate
            }
            
            dateFormatter.dateFormat = outputFormat
            return (dateFormatter.string(from: date as Date), date as Date)
        } else {
            return ("", Date())
        }
    }
    
    func setCircularProgress(progress : KDCircularProgress){
        DispatchQueue.main.async {
            progress.startAngle = -90
            progress.progressThickness = 0.5
            progress.trackThickness = 0.5
            progress.clockwise = true
            progress.gradientRotateSpeed = 0
            progress.roundedCorners = true
            progress.glowMode = .forward
            progress.glowAmount = 0
            progress.trackColor = UIColor.themeLightPurple.withAlphaComponent(0.2)
            progress.set(colors: UIColor.themeLightPurple.withAlphaComponent(0.5),UIColor.themeLightPurple,UIColor.themePurple.withAlphaComponent(0.6),UIColor.themePurple)
        }
    }
    
    func setHGCircularSliderProgress(progress : CircularSlider){
        progress.layoutIfNeeded()
        progress.layoutSubviews()
        
        let color = GFunction.shared.applyGradientColor(startColor: UIColor.themePurple.withAlphaComponent(1),
                                                        endColor: UIColor.themeLightPurple.withAlphaComponent(0.5),
                                                        locations: [0, 1],
                                                        startPoint: CGPoint(x: 0, y: 0),
                                                        endPoint: CGPoint(x: 0, y: progress.frame.maxY),
                                                        gradiantWidth: progress.frame.width,
                                                        gradiantHeight: progress.frame.height)
        
        progress.trackFillColor                 = color
        progress.trackColor                     = UIColor.themeLightPurple.withAlphaComponent(0.2)
        progress.diskColor                      = UIColor.clear
        progress.diskFillColor                  = UIColor.clear
        progress.endThumbTintColor              = UIColor.clear
        progress.endThumbStrokeColor            = UIColor.clear
        progress.endThumbStrokeHighlightedColor = UIColor.clear
        progress.isUserInteractionEnabled       = false
        progress.lineWidth                      = 18
        progress.backtrackLineWidth             = 18
        
        
    }
    
    func setProgress(progressBar: LinearProgressBar, color: UIColor){
        progressBar.trackColor          = UIColor.themeLightGray
        progressBar.trackPadding        = 0
        progressBar.capType             = 1
        
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
    }
    
    func getProgress(value: Float, maxValue: Float) -> CGFloat {
        if value <= maxValue {
            return CGFloat((value * 100) / maxValue)
        }
        else {
            return 100
        }
    }
    
    func openPdf(url: URL, withName: String = ""){
        Downloader.shared.load(url: url, withName: withName)
        //        if let document = PDFDocument(url: url) {
        //            let readerController                = PDFViewController.createNew(with: document)
        //            readerController.backgroundColor    = UIColor.white
        //
        //            UIApplication.topViewController()?.navigationController?.pushViewController(readerController, animated: true)
        //        }
        //        else {
        //            Downloader.shared.load(url: url)
        //        }
    }
    
    func setGoalProgressData(goalListModel: GoalListModel,
                             lblProgress: UILabel,
                             linearProgressBar: LinearProgressBar,
                             lblDuration: UILabel? = nil,
                             valueLog: Float? = 0) {
        
        let value       = Float(goalListModel.todaysAchievedValue) ?? 0
        let maxValue    = Float(goalListModel.goalValue) ?? 0
        let type        = GoalType.init(rawValue: goalListModel.keys) ?? .Exercise
        
        if value < maxValue || value >= maxValue {
            
            var printValue      = "\(goalListModel.todaysAchievedValue!)"
            var printLastValue  = "\(goalListModel.achievedValue!)"
            
            linearProgressBar.progressValue = GFunction.shared.getProgress(
                value: value,
                maxValue: maxValue)
            
            switch type {
                
            case .Medication:
                
                printValue = String(format: "%.f", Float(goalListModel.todaysAchievedValue) ?? 0)
                printLastValue = String(format: "%.f", Float(goalListModel.achievedValue))
                break
            case .Calories:
                
                printValue = String(format: "%.f", Float(goalListModel.todaysAchievedValue) ?? 0)
                printLastValue = String(format: "%.f", Float(goalListModel.achievedValue))
                break
            case .Steps:
                
                printValue = String(format: "%.f", Float(goalListModel.todaysAchievedValue) ?? 0)
                printLastValue = String(format: "%.f", Float(goalListModel.achievedValue))
                break
            case .Exercise:
                
                printValue = String(format: "%.f", Float(goalListModel.todaysAchievedValue) ?? 0)
                printLastValue = String(format: "%.f", Float(goalListModel.achievedValue))
                break
            case .Pranayam:
                
                printValue = String(format: "%.f", Float(goalListModel.todaysAchievedValue) ?? 0)
                printLastValue = String(format: "%.f", Float(goalListModel.achievedValue))
                break
            case .Sleep:
                
                printValue = String(format: "%0.f", Float(goalListModel.todaysAchievedValue) ?? 0)
                printLastValue = String(format: "0.f", Float(goalListModel.achievedValue))
                
                break
            case .Water:
                
                printValue = String(format: "%.f", Float(goalListModel.todaysAchievedValue) ?? 0)
                printLastValue = String(format: "%.f", Float(goalListModel.achievedValue))
                break
                
            case .Diet:
                
                printValue = String(format: "%.f", Float(goalListModel.todaysAchievedValue) ?? 0)
                printLastValue = String(format: "%.f", Float(goalListModel.achievedValue))
                break
            }
            
            if type == .Medication &&
                maxValue == 0 {
                
                lblProgress.text = AppMessages.AddMedicine
            }
            else {
                lblProgress.text = printValue
                + " " + AppMessages.of + " "
                + "\(goalListModel.goalValue!)" + " "
                + goalListModel.goalMeasurement
            }
            
            if let lbl = lblDuration {
                if value > 0 {
                    lbl.text = printLastValue
                }
                else {
                    lbl.text = String(format: "%.f", Float(valueLog ?? 0))
                }
            }
        }
        else {
            lblProgress.text = AppMessages.completed
            linearProgressBar.progressValue = GFunction.shared.getProgress(
                value: value,
                maxValue: maxValue)
            
            switch type {
            case .Medication:
                
                if maxValue == 0 {
                    lblProgress.text = AppMessages.AddMedicine
                }
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
                break
            case .Water:
                break
            case .Diet:
                break
            }
        }
    }
    
    func setReadingData(obj: ReadingListModel,
                        lblReading: UILabel? = nil,
                        lblUpdate: UILabel? = nil,
                        fontDefault: UIFont,
                        fontAttributed: UIFont,
                        completion: ((Bool) -> Void)?){
        
        let type = ReadingType.init(rawValue: obj.keys) ?? .BMI
        let floorReadingValue: String = "\(floor(obj.readingValue ?? 0))"
        var strDesc                 = floorReadingValue + " " +  obj.measurements
        var isReadingAvailable      = true
        
        
        var value1      = JSON(floorReadingValue).doubleValue
        var strValue1   = String(format: "%0.f", value1)
        
        var value2      = JSON(0).doubleValue
        var strValue2   = ""
        
        var measurement = ""
        func commonReadingValue(strValue1: String,
                                measurements: String){
            
            strDesc         = strValue1 + " " + measurements
            measurement     = measurements
        }
        
        //Default Black font
        let DefaultDesc : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : fontDefault,
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack as Any
        ]
        var attributeVal1 : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : fontDefault,
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack as Any
        ]
        var attributeVal2 : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : fontDefault,
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack as Any
        ]
        
        var arrMeasurements = [String]()
        
        let attributeDicDesc : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : fontAttributed,
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack,
        ]
        if let object = obj.inRange {
            if object.inRange == "N" {
                //Red font
                attributeVal1 = [
                    NSAttributedString.Key.font : fontDefault,
                    NSAttributedString.Key.foregroundColor : UIColor.themeRed as Any
                ]
            }
        }
        
        ///------------------------------------------------------------------
        switch type {
            
        case .SPO2:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .PEF:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .BloodPressure:
            
            value1  = JSON(obj.readingValueData.systolic ?? 0).doubleValue
            value2  = JSON(obj.readingValueData.diastolic ?? 0).doubleValue
            
            strValue1 = String(format: "%0.f", value1)
            strValue2 = String(format: "%0.f", value2)
            if value1 != 0 ||
                value2 != 0 {
                //                strDesc = strValue1 + "/" + strValue2 + " " + obj.measurements
                //                arrMeasurements = obj.measurements.components(separatedBy: ",")
                arrMeasurements = [obj.measurements, obj.measurements]
                if arrMeasurements.count > 1 {
                    strDesc = "\(strValue1) \(arrMeasurements[0])/\(strValue2) \(arrMeasurements[1])"
                }
                else {
                    strDesc = strValue1 + "/" + strValue2 + " " //+ obj.measurements
                }
            }
            else {
                strDesc = ""
            }
            
            attributeVal1 = [
                NSAttributedString.Key.font : fontDefault,
                NSAttributedString.Key.foregroundColor : UIColor.themeBlack as Any
            ]
            attributeVal2 = [
                NSAttributedString.Key.font : fontDefault,
                NSAttributedString.Key.foregroundColor : UIColor.themeBlack as Any
            ]
            if let object = obj.inRange {
                if object.systolic == "N" {
                    //Red font
                    attributeVal1 = [
                        NSAttributedString.Key.font : fontDefault,
                        NSAttributedString.Key.foregroundColor : UIColor.themeRed as Any
                    ]
                }
                if object.diastolic == "N" {
                    //Red font
                    attributeVal2 = [
                        NSAttributedString.Key.font : fontDefault,
                        NSAttributedString.Key.foregroundColor : UIColor.themeRed as Any
                    ]
                }
            }
            
            break
        case .HeartRate:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .BodyWeight:
            
            var weightUnit = ""
            var measurements = ""
            if UserModel.shared.unitData != nil {
                UserModel.shared.unitData = UserModel.shared.unitData.map({ data in
                    var appWeightUnit = ""
                    if UserModel.shared.weightUnit.trim() != "" {
                        appWeightUnit = UserModel.shared.weightUnit
                    }
                    else {
                        appWeightUnit = WeightUnit.kg.rawValue
                    }
                    
                    data.isSelected = false
                    if data.unitKey == appWeightUnit {
                        data.isSelected = true
                        weightUnit = data.unitKey
                        measurements = data.unitTitle
                    }
                    return data
                })
            }
            
            let weightUnitVal       = WeightUnit.init(rawValue: weightUnit) ?? .kg
            
            switch weightUnitVal {
                
            case .kg:
                ///No need to convert to kg as data from sever comes in kg only
                let weight = JSON(obj.readingValue!).doubleValue
                //                strValue1 = String(format: "%0.1f", weight)
                strValue1 = "\(weight.floorToPlaces(places: 1))"
                break
            case .lbs:
                let weight = GFunction.shared.convertWeight(toLbs: true, value: JSON(obj.readingValue!).doubleValue)
                //                strValue1 = String(format: "%0.1f", weight)
                strValue1 = "\(weight.floorToPlaces(places: 1))"
                break
            }
            
            commonReadingValue(strValue1: strValue1,
                               measurements: measurements)
            break
        case .BMI:
            value1          = JSON(obj.readingValue!).doubleValue
            strValue1       = String(format: "%0.1f", value1)
            strDesc         = strValue1 + " " + obj.measurements
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .BloodGlucose:
            
            value1  = JSON(obj.readingValueData.fast ?? 0).doubleValue
            value2  = JSON(obj.readingValueData.pp ?? 0).doubleValue
            
            strValue1 = String(format: "%0.f", value1)
            strValue2 = String(format: "%0.f", value2)
            if value1 != 0 ||
                value2 != 0 {
                //                strDesc = strValue1 + "/" + strValue2 + " " + obj.measurements
                
                //                arrMeasurements = obj.measurements.components(separatedBy: ",")
                arrMeasurements = [obj.measurements, obj.measurements]
                if arrMeasurements.count > 1 {
                    strDesc = "\(strValue1) \(arrMeasurements[0])/\(strValue2) \(arrMeasurements[1])"
                }
                else {
                    strDesc = strValue1 + "/" + strValue2 + " " //+ obj.measurements
                }
            }
            else {
                strDesc = ""
            }
            
            attributeVal1 = [
                NSAttributedString.Key.font : fontDefault,
                NSAttributedString.Key.foregroundColor : UIColor.themeBlack as Any
            ]
            attributeVal2 = [
                NSAttributedString.Key.font : fontDefault,
                NSAttributedString.Key.foregroundColor : UIColor.themeBlack as Any
            ]
            if let object = obj.inRange {
                if object.fast == "N" {
                    //Red font
                    attributeVal1 = [
                        NSAttributedString.Key.font : fontDefault,
                        NSAttributedString.Key.foregroundColor : UIColor.themeRed as Any
                    ]
                }
                if object.pp == "N" {
                    //Red font
                    attributeVal2 = [
                        NSAttributedString.Key.font : fontDefault,
                        NSAttributedString.Key.foregroundColor : UIColor.themeRed as Any
                    ]
                }
            }
            
            break
        case .HbA1c,.MuscleMass,.BoneMass,.SubcutaneousFat,.VisceralFat:
            //commonReadingValue()
            value1          = JSON(obj.readingValue!).doubleValue
            strValue1       = String(format: "%0.1f", value1)
            strDesc         = strValue1 + " " + obj.measurements
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .ACR:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .eGFR:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .FEV1Lung:
            value1          = JSON(obj.readingValue!).doubleValue
            strValue1       = "\(value1.floorToPlaces(places: 2))"
            strDesc         = strValue1 + " " + obj.measurements
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
            
        case .cat:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .six_min_walk:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
        case .fibro_scan:
            value1      = JSON(obj.readingValueData.lsm ?? 0).doubleValue
            value2      = JSON(obj.readingValueData.cap ?? 0).doubleValue
            
            strValue1 = String(format: "%0.1f", value1)
            strValue2 = String(format: "%0.f", value2)
            if value1 != 0 ||
                value2 != 0 {
                //                strDesc = strValue1 + "/" + strValue2 + " " //+ obj.measurements
                
                arrMeasurements = obj.measurements.components(separatedBy: ",")
                if arrMeasurements.count > 1 {
                    strDesc = "\(strValue1) \(arrMeasurements[0])/\(strValue2) \(arrMeasurements[1])"
                }
                else {
                    strDesc = strValue1 + "/" + strValue2 + " " //+ obj.measurements
                }
                
                
            }            else {
                strDesc = ""
            }
            
            
            attributeVal1 = [
                NSAttributedString.Key.font : fontDefault,
                NSAttributedString.Key.foregroundColor : UIColor.themeBlack as Any
            ]
            attributeVal2 = [
                NSAttributedString.Key.font : fontDefault,
                NSAttributedString.Key.foregroundColor : UIColor.themeBlack as Any
            ]
            if let object = obj.inRange {
                if object.lsm == "N" {
                    //Red font
                    attributeVal1 = [
                        NSAttributedString.Key.font : fontDefault,
                        NSAttributedString.Key.foregroundColor : UIColor.themeRed as Any
                    ]
                }
                if object.cap == "N" {
                    //Red font
                    attributeVal2 = [
                        NSAttributedString.Key.font : fontDefault,
                        NSAttributedString.Key.foregroundColor : UIColor.themeRed as Any
                    ]
                }
            }
            
            break
        case .fib4:
            value1          = JSON(obj.readingValue!).doubleValue
            strValue1       = String(format: "%0.2f", value1)
            strDesc         = strValue1 + " " + obj.measurements
            break
        case .sgot:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .sgpt:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .triglycerides:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .total_cholesterol:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .ldl_cholesterol:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .hdl_cholesterol:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .waist_circumference:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .platelet:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .serum_creatinine:
            value1          = JSON(obj.readingValue!).doubleValue
            strValue1       = String(format: "%0.1f", value1)
            strDesc         = strValue1 + " " + obj.measurements
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .fatty_liver_ugs_grade:
            let val = GFunction.shared.getFattyLiver(value: JSON(obj.readingValue!).intValue,
                                                     arrFattyLiverGrade: GFunction.shared.setArrFattyLiver())
            strValue1       = val["name"].stringValue
            strDesc         = "Grade " + strValue1
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
            
        case .random_blood_glucose:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .BodyFat,.Hydration,.Protein,.BaselMetabolicRate,.MetabolicAge,.SkeletalMuscle:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .fev1_fvc_ratio,.fvc,.aqi,.humidity,.temperature:
            break
        }
        
        let time = GFunction.shared.convertDateFormate(dt: obj.readingDatetime,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                       status: .NOCONVERSION)
        
        if strDesc.trim() != "" && obj.updatedAt.trim() != ""{
            
            if lblReading != nil {
                //                lblReading!.isHidden        = false
                lblReading!.alpha           = 1
                //                lblReading!.attributedText  = strDesc.getAttributedText(defaultDic: defaultDicDesc1, attributeDic: attributeDicDesc, attributedStrings: [obj.measurements])
                
                //                DispatchQueue.main.async {
                if arrMeasurements.count == 2 {
                    lblReading!.attributedText  = strDesc.getAttributedText(defaultDic: DefaultDesc, attributeDics: [attributeVal1, attributeDicDesc, attributeVal2, attributeDicDesc], attributedStrings: [strValue1, arrMeasurements[0], strValue2, arrMeasurements[1]])
                }
                else {
                    lblReading!.attributedText  = strDesc.getAttributedText(defaultDic: DefaultDesc, attributeDics: [attributeVal1, attributeVal2, attributeDicDesc], attributedStrings: [strValue1, strValue2, measurement])
                }
                //                }
            }
            if lblUpdate != nil {
                lblUpdate!.text             = AppMessages.updated + " " + time.1.timeAgoSince()
            }
            
        }
        else {
            if lblReading != nil {
                //lblReading!.isHidden        = true
                lblReading!.alpha           = 0
            }
            if lblUpdate != nil {
                lblUpdate!.text             = "Tap to update"
                //AppMessages.pleaseUpdateYour + " " + obj.readingName.lowercased()
            }
            isReadingAvailable              = false
        }
        completion?(isReadingAvailable)
    }
    
    func setReadingData(obj: BCAVitalsModel,
                        lblReading: UILabel? = nil){
        
        let type = ReadingType.init(rawValue: obj.keys) ?? .BMI
        let floorReadingValue: String = "\(floor(obj.reading ?? 0))"
        var strDesc                 = floorReadingValue + " " +  obj.measurements
        
        var value1      = JSON(floorReadingValue).doubleValue
        var strValue1   = String(format: "%0.f", value1)
        
        var value2      = JSON(0).doubleValue
        var strValue2   = ""
        
        var measurement = ""
        func commonReadingValue(strValue1: String,
                                measurements: String){
            
            strDesc         = strValue1
            measurement     = measurements
        }
        
        ///------------------------------------------------------------------
        switch type {
            
        case .SPO2:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .PEF:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .BloodPressure:
            
            value1  = JSON(obj.readingValueData.systolic ?? 0).doubleValue
            value2  = JSON(obj.readingValueData.diastolic ?? 0).doubleValue
            
            strValue1 = String(format: "%0.f", value1)
            strValue2 = String(format: "%0.f", value2)
            if value1 != 0 ||
                value2 != 0 {
                //                strDesc = strValue1 + "/" + strValue2 + " " + obj.measurements
                //                arrMeasurements = obj.measurements.components(separatedBy: ",")
                let arrMeasurements = [obj.measurements, obj.measurements]
                if arrMeasurements.count > 1 {
                    strDesc = "\(strValue1) \(arrMeasurements[0])/\(strValue2) \(arrMeasurements[1])"
                }
                else {
                    strDesc = strValue1 + "/" + strValue2 + " " //+ obj.measurements
                }
            }
            else {
                strDesc = ""
            }
            
            break
        case .HeartRate:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .BodyWeight:
            
            var weightUnit = ""
            var measurements = ""
            if UserModel.shared.unitData != nil {
                UserModel.shared.unitData = UserModel.shared.unitData.map({ data in
                    var appWeightUnit = ""
                    if UserModel.shared.weightUnit.trim() != "" {
                        appWeightUnit = UserModel.shared.weightUnit
                    }
                    else {
                        appWeightUnit = WeightUnit.kg.rawValue
                    }
                    
                    data.isSelected = false
                    if data.unitKey == appWeightUnit {
                        data.isSelected = true
                        weightUnit = data.unitKey
                        measurements = data.unitTitle
                    }
                    return data
                })
            }
            
            let weightUnitVal       = WeightUnit.init(rawValue: weightUnit) ?? .kg
            
            switch weightUnitVal {
                
            case .kg:
                ///No need to convert to kg as data from sever comes in kg only
                let weight = JSON(obj.readingValue!).doubleValue
                //                strValue1 = String(format: "%0.1f", weight)
                strValue1 = "\(weight.floorToPlaces(places: 1))"
                break
            case .lbs:
                let weight = GFunction.shared.convertWeight(toLbs: true, value: JSON(obj.readingValue!).doubleValue)
                //                strValue1 = String(format: "%0.1f", weight)
                strValue1 = "\(weight.floorToPlaces(places: 1))"
                break
            }
            
            commonReadingValue(strValue1: strValue1,
                               measurements: measurements)
            break
        case .BMI:
            value1          = JSON(obj.readingValue!).doubleValue
            strValue1       = String(format: "%0.1f", value1)
            strDesc         = strValue1 + " " + obj.measurements
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .BloodGlucose:
            
            value1  = JSON(obj.readingValueData.fast ?? 0).doubleValue
            value2  = JSON(obj.readingValueData.pp ?? 0).doubleValue
            
            strValue1 = String(format: "%0.f", value1)
            strValue2 = String(format: "%0.f", value2)
            if value1 != 0 ||
                value2 != 0 {
                //                strDesc = strValue1 + "/" + strValue2 + " " + obj.measurements
                
                //                arrMeasurements = obj.measurements.components(separatedBy: ",")
                let arrMeasurements = [obj.measurements, obj.measurements]
                if arrMeasurements.count > 1 {
                    strDesc = "\(strValue1) \(arrMeasurements[0])/\(strValue2) \(arrMeasurements[1])"
                }
                else {
                    strDesc = strValue1 + "/" + strValue2 + " " //+ obj.measurements
                }
            }
            else {
                strDesc = ""
            }
            break
        case .HbA1c,.MuscleMass,.BoneMass,.SubcutaneousFat,.VisceralFat:
            //commonReadingValue()
            value1          = JSON(obj.readingValue!).doubleValue
            strValue1       = String(format: "%0.1f", value1)
            strDesc         = strValue1 + " " + obj.measurements
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .ACR:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .eGFR:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .FEV1Lung:
            value1          = JSON(obj.readingValue!).doubleValue
            strValue1       = "\(value1.floorToPlaces(places: 2))"
            strDesc         = strValue1 + " " + obj.measurements
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
            
        case .cat:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .six_min_walk:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
        case .fibro_scan:
            value1      = JSON(obj.readingValueData.lsm ?? 0).doubleValue
            value2      = JSON(obj.readingValueData.cap ?? 0).doubleValue
            
            strValue1 = String(format: "%0.1f", value1)
            strValue2 = String(format: "%0.f", value2)
            if value1 != 0 ||
                value2 != 0 {
                //                strDesc = strValue1 + "/" + strValue2 + " " //+ obj.measurements
                
                let arrMeasurements = obj.measurements.components(separatedBy: ",")
                if arrMeasurements.count > 1 {
                    strDesc = "\(strValue1) \(arrMeasurements[0])/\(strValue2) \(arrMeasurements[1])"
                }
                else {
                    strDesc = strValue1 + "/" + strValue2 + " " //+ obj.measurements
                }
                
            } else {
                strDesc = ""
            }
            break
        case .fib4:
            value1          = JSON(obj.readingValue!).doubleValue
            strValue1       = String(format: "%0.2f", value1)
            strDesc         = strValue1 + " " + obj.measurements
            break
        case .sgot:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .sgpt:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .triglycerides:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .total_cholesterol:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .ldl_cholesterol:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .hdl_cholesterol:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .waist_circumference:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .platelet:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .serum_creatinine:
            value1          = JSON(obj.readingValue!).doubleValue
            strValue1       = String(format: "%0.1f", value1)
            strDesc         = strValue1 + " " + obj.measurements
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .fatty_liver_ugs_grade:
            let val = GFunction.shared.getFattyLiver(value: JSON(obj.readingValue!).intValue,
                                                     arrFattyLiverGrade: GFunction.shared.setArrFattyLiver())
            strValue1       = val["name"].stringValue
            strDesc         = "Grade " + strValue1
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
            
        case .random_blood_glucose:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .BodyFat,.Hydration,.Protein,.BaselMetabolicRate,.MetabolicAge,.SkeletalMuscle:
            commonReadingValue(strValue1: strValue1,
                               measurements: obj.measurements)
            break
        case .fev1_fvc_ratio,.fvc,.aqi,.humidity,.temperature:
            break
        }
        
        lblReading?.text = strDesc
    }
    
    func setReadingChartDesc(readingListModel: ReadingListModel,
                             lbl: UILabel,
                             name: String,
                             chartScale: SelectionType){
        
        let type = ReadingType.init(rawValue: readingListModel.keys) ?? .ACR
        
        switch type {
            
        case .SPO2:
            break
        case .PEF:
            break
        case .BloodPressure:
            break
        case .HeartRate:
            break
        case .BodyWeight:
            break
        case .BMI:
            break
        case .BloodGlucose:
            break
        case .HbA1c:
            break
        case .ACR:
            break
        case .eGFR:
            break
        case .FEV1Lung:
            break
        case .cat:
            break
        case .six_min_walk:
            break
        case .fibro_scan:
            break
        case .fib4:
            break
        case .sgot:
            break
        case .sgpt:
            break
        case .triglycerides:
            break
        case .total_cholesterol:
            break
        case .ldl_cholesterol:
            break
        case .hdl_cholesterol:
            break
        case .waist_circumference:
            break
        case .platelet:
            break
        case .serum_creatinine:
            break
        case .fatty_liver_ugs_grade:
            break
        case .random_blood_glucose:
            break
        case .BodyFat,.Hydration,.MuscleMass,.Protein,.BoneMass,.VisceralFat,.BaselMetabolicRate,.MetabolicAge,.SubcutaneousFat,.SkeletalMuscle:
            break
        case .fev1_fvc_ratio,.fvc,.aqi,.humidity,.temperature:
            break
        }
        switch chartScale {
            
        case .sevenDays:
            lbl.text = "Average" + " " + name + " " + "value in the last" + " " + "\(7)" + " " + "days is"
            break
        case .fifteenDays:
            lbl.text = "Average" + " " + name + " " + "value in the last" + " " + "\(15)" + " " + "days is"
            break
        case .thirtyDays:
            lbl.text = "Average" + " " + name + " " + "value in the last" + " " + "\(30)" + " " + "days is"
            break
        case .nintyDays:
            lbl.text = "Average" + " " + name + " " + "value in the last" + " " + "\(90)" + " " + "days is"
            break
        case .oneYear:
            lbl.text = "Average" + " " + name + " " + "value in the last" + " " + "\(1)" + " " + "year is"
            break
            //        case .allTime:
            //            lbl.text = "Average" + " " + name + " " + "value for all time is" + " " + ""
            //            break
        }
        
    }
    
    func openContactUs() {
        let vc = AddSupportQuestionPopupVC.instantiate(fromAppStoryboard: .setting)
        vc.modalPresentationStyle   = .overFullScreen
        vc.modalTransitionStyle     = .crossDissolve
        vc.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
    
    func formatPoints(from: Int) -> String {
        let number = Double(from)
        let thousand = number / 1000
        let million = number / 1000000
        let billion = number / 1000000000
        
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        } else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        } else if billion >= 1.0 {
            return ("\(round(billion*10/10))B")
        } else {
            return "\(Int(number))"}
    }
    
    func setBadge(view: UIView,
                  value: Int){
        DispatchQueue.main.async {
            view.layoutIfNeeded()
            
            let arrViews = view.subviews
            for vw in arrViews {
                if vw.isKind(of: UILabel.self) ||
                    vw.isKind(of: BadgeView.self){
                    vw.removeFromSuperview()
                }
                
            }
            
            let hub = BadgeHub(view: view)
            //
            //            if let arrViews = hub.hubView?.subviews {
            //                for vw in arrViews {
            //                    if vw.isKind(of: BadgeView.self) {
            //                        vw.isHidden = true
            //                    }
            //                }
            //            }
            
            // if CartManager.shared.cartQuantity > 0 {
            notificHubDiameter = 20
            hub.setCountLabelFont(UIFont.customFont(ofType: .medium, withSize: 9))
            hub.increment(by: value)
            hub.pop()
            hub.setCircleColor(UIColor.themeOrange, label: UIColor.white)
            hub.setCircleBorderColor(UIColor.white, borderWidth: 0)
            //        hub.setCircleAtFrame(CGRect(x: self.vwRefuelRequest.frame.width - 5, y: -5, width: 20, height: 20))
            //hub.moveCircleBy(x: CGFloat, y: CGFloat)
            
            // hub.setView(self.vwRefuelRequest, andCount: 5)
            //        hub.scaleCircleSize(by: 1)
            //hub.hideCount()
            //            }
            //            else {
            //            }
            
        }
    }
    
    func debounce(interval: Int, queue: DispatchQueue, action: @escaping (() -> Void)) -> () -> Void {
        var lastFireTime    = DispatchTime.now()
        let dispatchDelay   = DispatchTimeInterval.milliseconds(interval)
        
        return {
            lastFireTime = DispatchTime.now()
            let dispatchTime: DispatchTime = DispatchTime.now() + dispatchDelay
            
            queue.asyncAfter(deadline: dispatchTime) {
                let when: DispatchTime = lastFireTime + dispatchDelay
                let now = DispatchTime.now()
                if now.rawValue >= when.rawValue {
                    action()
                }
            }
        }
    }
    
}

///Setup Health connection
extension GFunction{
    
    func setUpHealthKitConnectionLabel(vw: UIView,
                                       lbl: UILabel,
                                       completion: ((Bool) -> Void)?){
        
        vw.isHidden = false
        
        HealthKitManager.shared.checkHealthKitSupport { [weak self] (isAvailable) in
            guard let _ = self else { return }
            if !isAvailable {
                vw.isHidden = true
                return
            }
        }
        
        lbl.text = ""
        var text = AppMessages.connectHealthKit
        lbl.font(name: .regular, size: 14)
            .textColor(color: UIColor.themePurple)
        
        //        HealthKitManager.shared.requestAccessWithCompletion { status, error in
        //            if status{
        //                text = AppMessages.connected
        //            }
        //            lbl.attributedText = text.addUnderline()
        //        }
        
        HealthKitManager.shared.checkHealthKitPermission { [weak self] (isSync) in
            guard let _ = self else { return }
            if isSync {
                text        = AppMessages.connected
                lbl.text    = text
                completion?(true)
            }
            else {
                lbl.attributedText = text.addUnderline()
                completion?(false)
            }
        }
    }
    
    func navigateToHealthConnect(completion: ((_ obj : JSON?) -> Void)?){
        let vc = SyncDeviceVC.instantiate(fromAppStoryboard: .setting)
        vc.completionHandler = { obj in
            completion?(obj)
        }
        if let nav = UIApplication.topViewController()?.navigationController {
            nav.present(vc, animated: true, completion: nil)
        }
        else if let nav = UIApplication.topViewController()?.presentingViewController as? UINavigationController {
            nav.present(vc, animated: true, completion: nil)
        }
    }
    
    func navigateToSetGoal(){
        let goal = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
        goal.hidesBottomBarWhenPushed = true
        goal.isEdit = true
        if let nav = UIApplication.topViewController()?.navigationController {
            nav.pushViewController(goal, animated: true)
        }
        else if let nav = UIApplication.topViewController()?.presentingViewController as? UINavigationController {
            nav.pushViewController(goal, animated: true)
        }
    }
}

//MARK: -------------------------- Fatty Liver functions --------------------------
extension GFunction{
    func setArrFattyLiver() -> [JSON] {
        var arr = [JSON]()
        for item in FattyLiverGrade.allCases {
            var obj = JSON()
            obj["name"].stringValue = item.getTitle
            obj["value"].intValue   = item.rawValue
            obj["is_select"]        = 0
            arr.append(obj)
        }
        return arr
    }
    
    func getFattyLiver(value: Int, arrFattyLiverGrade: [JSON]) -> JSON {
        for val in arrFattyLiverGrade {
            if val["value"].intValue == value {
                return val
            }
        }
        return arrFattyLiverGrade[0]
    }
}

//MARK: -------------------------- Height-Weight functions --------------------------
extension GFunction{
    
    func getUnit(from arr: [UnitData]) -> String {
        var unit = ""
        for item in arr {
            if item.isSelected {
                unit = item.unitKey
            }
        }
        return unit
    }
    
    func convertToCm(from feet: Double, inch: Double) -> Double{
        let cm = (feet * 30.48) + (inch * 2.54)
        return cm.rounded()
    }
    
    func convertToFeetInch(from cm: Double) -> (ft: Double, inch: Double){
        let total_inch      = (cm/2.54)
        var feet            = floor(total_inch/12)
        var inch            = total_inch.truncatingRemainder(dividingBy: 12).rounded()
        if inch > 11 {
            feet += 1
            inch = 0
        }
        return (ft: feet, inch: inch)
    }
    
    func convertWeight(toLbs: Bool, value: Double) -> Double {
        if toLbs {
            /*
             Kg to lbs:
             X * 2.205
             */
            print("Weight converted from \(value)Kg to \(value * 2.205)Lbs")
            return (value * 2.205)
        }
        else {
            /*
             lbs to kg: X * 0.454
             */
            print("Weight converted from \(value)Lbs to \(value * 0.454)Kg")
            return (value * 0.454)
        }
    }
    
    func getFinalHeightWeight(heightUnit: String,
                              weightUnit: String,
                              heightCm: String,
                              heightFt: String,
                              heightIn: String,
                              weight: String,
                              goalWeight: String) -> (height: String,
                                                      weight: String,
                                                      setWeight: String){
        
        ///------------------------------ Check for height and convert it to cm for api
        var heightVal       = heightCm
        let heightUnitVal   = HeightUnit.init(rawValue: heightUnit) ?? .cm
        
        switch heightUnitVal {
        case .feet_inch:
            /*
             feet / inches to cm:
             Calculate: feet * 30.48 + inches * 2.54
             */
            if heightFt.trim() != "" &&
                heightIn.trim() != "" {
                //                let feet: Double    = JSON(value).doubleValue
                //                let inch: Double    = JSON(self.txtHeightIn.text!).doubleValue
                //                let cm              = (feet * 30.48) + (inch * 2.54)
                
                let cm = GFunction.shared.convertToCm(from: JSON(heightFt).doubleValue,
                                                      inch: JSON(heightIn).doubleValue)
                
                heightVal = String(format:"%0.f",cm)
            }
            break
        case .cm:
            
            
            break
        }
        
        ///------------------------------ Check for weight and convert it to kg for api
        var weightVal           = weight
        var setWeightVal        = goalWeight
        let weightUnitVal       = WeightUnit.init(rawValue: weightUnit) ?? .kg
        
        switch weightUnitVal {
        case .kg:
            break
        case .lbs:
            let weight = GFunction.shared.convertWeight(toLbs: false,
                                                        value: JSON(weight).doubleValue)
            //            weightVal = String(format:"%0.f",weight)
            weightVal = "\(weight.floorToPlaces(places: 1))"
            
            let setWeight = GFunction.shared.convertWeight(toLbs: false,
                                                           value: JSON(goalWeight).doubleValue)
            //            setWeightVal = String(format:"%0.f",setWeight)
            setWeightVal = "\(setWeight.floorToPlaces(places: 1))"
            break
        }
        
        return (height: heightVal, weight: weightVal, setWeight: setWeightVal)
    }
    
    func deinitWithClass(className: Any){
        debugPrint(className , "❗️❕❗️❕❗️❕❗️❕❗️❕❗️❕❗️❕❗️❕❗️❕❗️❕❗️❕❗️❕deinit")
    }
    
}

struct StringConstant {
    
    static let Name                        = "Name"
    static let Lat                         = "Lat"
    static let Long                        = "Long"
    static let City                        = "City"
    static let State                       = "State"
    static let Country                     = "Country"
    static let SubLocality                 = "SubLocality"
    static let Area                        = "Area"
    static let PinCode                     = "PinCode"
    static let Address                     = "Address"
}

class GoogleNavigationAdddress : NSObject {
    
    static func getAddressFromLatLong ( lat : Double ,
                                        lng : Double ,
                                        completionHandler : @escaping ( _ fullAddress : [String:Any] ) -> Void ) {
        
        let geocoder = GMSGeocoder()
        
        var location : CLLocation?
        if lat == 0.0 || lng == 0.0 {
            
        }else{
            location = CLLocation(latitude: lat, longitude: lng)
        }
        
        if let loc = location {
            
            geocoder.reverseGeocodeCoordinate(loc.coordinate, completionHandler: { (response, error) in
                
                if error == nil {
                    
                    if let res = response?.results() {
                        
                        for address in res {
                            
                            if address.locality != nil {
                                
                                print(address)
                                
                                var dict : [String: Any] = [:]
                                
                                dict[StringConstant.Lat] = JSON(lat).doubleValue
                                dict[StringConstant.Long] = JSON(lng).doubleValue
                                
                                if let address = address.lines?.first {
                                    dict[StringConstant.Address] = address
                                }
                                
                                if let city = address.locality {
                                    dict[StringConstant.City] = city
                                }
                                
                                if let subLocality = address.subLocality {
                                    dict[StringConstant.SubLocality] = subLocality
                                }
                                
                                if let state = address.administrativeArea {
                                    dict[StringConstant.State] = state
                                }
                                
                                if let country = address.country {
                                    dict[StringConstant.Country] = country
                                }
                                
                                if let postalcode = address.postalCode {
                                    dict[StringConstant.PinCode] = postalcode
                                }
                                
                                completionHandler(dict)
                                return
                            }
                        }
                    }
                    debugPrint("not found")
                }
                else {
                    Alert.shared.showSnackBar((AppError.validation(type: .locationNotFound)).errorDescription ?? "")
                }
            })
        }
    }
}

//MARK: -------------------------- APP LEVEL VALIDATIONS --------------------------
extension GFunction {
    func allowedFileSize(sizeInKb: Int, completion: ((Bool) -> Void)){
        if Int(sizeInKb) > Validations.MaxCharacterLimit.imageKbSize.rawValue {
            Alert.shared.showSnackBar(AppError.validation(type: .invalidFileSize).errorDescription ?? "")
            completion(false)
        }
        else {
            completion(true)
        }
    }
}

//MARK: -------------------------- Video player Methods --------------------------
extension GFunction {
    
    func openVideoPlayer(strUrl: String,
                         parentView: UIView? = nil,
                         content_master_id : String,
                         content_type: String){
        
        self.content_master_id  = content_master_id
        self.content_type       = content_type
        
        var param = [String : Any]()
        param[AnalyticsParameters.content_master_id.rawValue]   = content_master_id
        param[AnalyticsParameters.content_type.rawValue]        = content_type
        FIRAnalytics.FIRLogEvent(eventName: .USER_PLAY_VIDEO,
                                 screen: .VideoPlayer,
                                 parameter: param)
        
        
        // 3. make sure the url your using isn't nil
        //        self.videoUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")
        
        
        //self.videoUrl = URL(string: "http://3.7.8.99/hugs_basket/assets/upload/Pexels%20Videos%204697%20(1).mp4")
        self.videoUrl = URL(string: strUrl)
        
        //        if self.object.media.count > 0 {
        //            self.videoUrl = URL(string: self.object.media[0].mediaUrl)
        //        }
        //        else {
        //            Alert.shared.showSnackBar(AppMessages.noVideoData)
        //            return
        //        }
        
        guard let videoUrl = videoUrl else {
            Alert.shared.showSnackBar(AppMessages.noVideoData)
            return
        }
        
        // 4. init an AVPlayer object with the url then set the class property player with the AVPlayer object
        self.player = AVPlayer(url: videoUrl)
        self.player?.play()
        
        // 5. set the class property player to the AVPlayerViewController's player
        self.avPVC.player = self.player
        
        // 6. set the the parent vc's bounds to the AVPlayerViewController's frame
        if let vw = parentView {
            self.avPVC.view.frame       = vw.bounds
        }
        avPVC.showsPlaybackControls     = true
        
        // 7. the parent vc has a method on it: addChildViewController() that takes the child you want to add to it (in this case the AVPlayerViewController) as an argument
        //self.addChild(self.avPVC)
        
        // 8. add the AVPlayerViewController's view as a subview to the parent vc
        //self.vwImgTitle.addSubview(self.avPVC.view)
        
        // 9. on AVPlayerViewController call didMove(toParentViewController:) and pass the parent vc as an argument to move it inside parent
        //self.avPVC.didMove(toParent: self)
        kScreenTimeStart = Date()
        UIApplication.topViewController()?.present(self.avPVC, animated: true, completion: {
        })
    }
    
    func stopPlayer() {
        if let play = self.player {
            print("stopped")
            play.pause()
            self.player = nil
            print("player deallocated")
            self.avPVC.dismiss(animated: true, completion: nil)
            self.avPVC.removeFromParent()
            self.avPVC.view.removeFromSuperview()
        } else {
            print("player was already deallocated")
        }
    }
    
    @objc func dismissingAVPlayerViewController(){
        
        
    }
}

extension AVPlayerViewController {
    // override 'viewWillDisappear'
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // now, check that this ViewController is dismissing
        if self.isBeingDismissed == false {
            return
        }
        
        let timeSpent = Calendar.current.dateComponents([.second], from: kScreenTimeStart,
                                                        to: Date()).second ?? 0
        
        print(timeSpent)
        
        var param = [String : Any]()
        param[AnalyticsParameters.content_master_id.rawValue]      = GFunction.shared.content_master_id
        param[AnalyticsParameters.content_type.rawValue]           = GFunction.shared.content_type
        param[AnalyticsParameters.duration_second.rawValue]        = timeSpent
        FIRAnalytics.FIRLogEvent(eventName: .USER_DURATION_OF_VIDEO,
                                 screen: .VideoPlayer,
                                 parameter: param)
        
        let dateFormatter                   = DateFormatter()
        dateFormatter.dateFormat            = appDateFormat
        dateFormatter.timeZone              = .current
        let date                            = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat            = appTimeFormat
        dateFormatter.timeZone              = .current
        dateFormatter.locale                = NSLocale(localeIdentifier: "en_US") as Locale
        let time                            = dateFormatter.string(from: Date())
        
        if kGoalMasterId.trim() != "" {
            let minutes = Int(timeSpent / 60)
            
            GlobalAPI.shared.update_goal_logsAPI(goal_id: kGoalMasterId,
                                                 achieved_value: "\(minutes)",
                                                 patient_sub_goal_id: "",
                                                 start_time: "",
                                                 end_time: "",
                                                 achieved_datetime: date + time,
                                                 showAlert: false) { (isDone, date, startTime, endTime) in
                if isDone {
                }
            }
        }
    }
}

extension GFunction {
    static func getConfigKeyForBCP() -> String {
        //Production key will expire on 18/07/2025...
        return "aebeb6bce4dc7ecec7e3083f2a292e494ff8ec2f690c338b576a9827db8e0b0f7474324e1c90ea74b9d552395a14acdba1cad03035b0ae4f01850f60db962d37ebd29f4aa91242dc08febf7d0344077a8175fcaff43e7157f3c02be65df0da5b9497c669cc71d4cbbae9a2db7e701ba9a6e6584e1a8ab9d4372ac728a4bf701309a166ce46e231ddd0bd59c94ca84e4ba843dfccb41129b260f56b34f5a1a6db"
        
    }
}
