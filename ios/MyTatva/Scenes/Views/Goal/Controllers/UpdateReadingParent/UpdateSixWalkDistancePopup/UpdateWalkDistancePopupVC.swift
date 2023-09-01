//
//  PheromonePopupVC.swift
//

//

import UIKit

enum WalkDistancePopupStatus {
    case willAppear
    case startConnected
    case stopConnected
    case stopDisconnected
    case startDisconnected
}

class UpdateWalkDistancePopupVC: ClearNavigationFontBlackBaseVC {
    
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var vwImgTitle       : UIView!
    @IBOutlet weak var imgTitle         : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var lblDate          : UILabel!
    @IBOutlet weak var txtDate          : UITextField!
    
    @IBOutlet weak var lblTime          : UILabel!
    @IBOutlet weak var txtTime          : UITextField!
    
    @IBOutlet weak var lblsSummary      : UILabel!
    @IBOutlet weak var vwProgressParent : UIView!
    @IBOutlet weak var vwProgress       : CircularSlider!
    @IBOutlet weak var lblMin           : UILabel!
    @IBOutlet weak var lblMinUnit       : UILabel!
    
    @IBOutlet weak var stackReading     : UIStackView!
    @IBOutlet weak var lblReading       : UILabel!
    @IBOutlet weak var txtReading       : UITextField!
    
    @IBOutlet weak var txtUnit          : UITextField!
    
    @IBOutlet weak var vwStart          : UIView!
    @IBOutlet weak var btnStart         : UIButton!
    
    @IBOutlet weak var vwStop           : UIView!
    @IBOutlet weak var btnStop          : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    
    @IBOutlet weak var vwConnectParent      : UIView!
    @IBOutlet weak var vwHKConnect          : UIView!
    @IBOutlet weak var lblHKConnect         : UILabel!
    @IBOutlet weak var lblHKConnectDesc     : UILabel!
    
    @IBOutlet weak var lblStandardVal   : UILabel!
    
    @IBOutlet weak var vwSubmit         : UIView!
    @IBOutlet weak var btnSubmit        : UIButton!
    
    
    //MARK:- Class Variable
    let viewModel                       = UpdateWalkDistancePopupVM()
    var readingType: ReadingType        = .HeartRate
    var readingListModel                = ReadingListModel()
    var isNext                          = false
    
    var datePicker                      = UIDatePicker()
    var timePicker                      = UIDatePicker()
    var dateFormatter                   = DateFormatter()
//    var dateFormat                      = DateTimeFormaterEnum.ddmm_yyyy.rawValue
//    var timeFormat                      = DateTimeFormaterEnum.hhmma.rawValue
    
    let strNoHealth     = "Since Motion service is disabled, distance will have to be entered manually"
    let strYesHealth    = "We would be using the above service for measuring distance"
    var timer: Timer!
    var totalTime: Int                  = kMaxSixMinWalkDuration
    var progressTime: Int               = 0
    var arrlocations : [CLLocation]     = [CLLocation]()
    var lastlocations : CLLocation!
    var arrFinalLocations : [CLLocation] = [CLLocation]()
    var startDate   = Date()
    var bgDate      = Date()
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {
        
        self.lblTitle.font(name: .bold, size: 18)
            .textColor(color: UIColor.themeBlack)
        
        self.lblDate.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblTime.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblReading.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblStandardVal.font(name: .medium, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.45))
        
        self.txtUnit.font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
            .borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            .cornerRadius(cornerRadius: 5)
        
        self.lblHKConnectDesc.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblMin.font(name: .medium, size: 20)
            .textColor(color: UIColor.themeBlack)
        self.lblMinUnit.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblsSummary
            .font(name: .bold, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.lblHKConnect
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
        
        self.btnSubmit.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
        self.btnStart.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
        self.btnStop.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
        
        self.txtUnit.backGroundColor(color: UIColor.themeLightGray)
        self.txtUnit.textAlignment = .center
        
        self.vwProgress.minimumValue = 0
        self.vwProgress.maximumValue = CGFloat(kMaxSixMinWalkDuration)
        GFunction.shared.setHGCircularSliderProgress(progress: self.vwProgress)
        
        self.manageUI(status: .willAppear)
        PedometerManager.shared.pedometerAuthorizationState(showAlert: false, completion: { isAllow in
            if isAllow {
                self.lblHKConnect.text      = "Motion service enabled"
                self.lblHKConnectDesc.text  = self.strYesHealth
            }
            else {
                self.lblHKConnect.text      = "Motion service disabled"
                self.lblHKConnectDesc.text  = self.strNoHealth
            }
        })
        
//        if LocationManager.shared.isLocationServiceEnabled(showAlert: false) {
//            self.lblHKConnect.text      = "Location service enabled"
//            self.lblHKConnectDesc.text  = self.strYesHealth
//
//        }
//        else {
//            self.lblHKConnect.text      = "Location service desabled"
//            self.lblHKConnectDesc.text  = self.strNoHealth
//        }
            
//        GFunction.shared.setUpHealthKitConnectionLabel(vw: self.vwHKConnect, lbl: self.lblHKConnect){ (isDone) in
//            if isDone {
//                self.lblHKConnectDesc.text = self.strYesHealth
//            }
//        }
        
        self.openPopUp()
        self.setData()
        self.configureUI()
        self.manageActionMethods()
        self.initDatePicker()
    }
    
    fileprivate func configureUI(){
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.btnSubmit.layoutIfNeeded()
            self.btnStart.layoutIfNeeded()
            self.btnStop.layoutIfNeeded()
            self.vwHKConnect.layoutIfNeeded()
            self.vwProgress.layoutIfNeeded()
            
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.btnSubmit
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnStart
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnStop
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)
            
            self.vwHKConnect.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            GFunction.shared.setHGCircularSliderProgress(progress: self.vwProgress)
            
            self.vwImgTitle.layoutIfNeeded()
            self.vwImgTitle.cornerRadius(cornerRadius: 5)
        }
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : JSON? = nil) {
        
        self.stopTimer()
        func sendData() {
            if let obj = objAtIndex {
                if let vc = self.parent?.parent as? UpdateReadingParentVC {
                    if let completionHandler = vc.completionHandler {
                        completionHandler(obj)
                    }
                }
            }
        }
        
        self.dismiss(animated: animated) {
            sendData()
        }
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnCancelTop.addTapGestureRecognizer {
//            var obj         = JSON()
//            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnStart.addTapGestureRecognizer {
            self.progressTime   = 0
            self.totalTime      = kMaxSixMinWalkDuration
            PedometerManager.shared.pedometerAuthorizationState(showAlert: false, completion: { isAllow in
                
                DispatchQueue.main.async {
                    if isAllow {
                        self.manageUI(status: .startConnected)
                        self.startTimer()
                        
                        PedometerManager.shared.pedometerStart()
                        self.startDate = Date()
//                        self.vwProgress.animate(toAngle: 360, duration: TimeInterval(self.totalTime)) { isDone in
//                            if isDone{
//                                //self.vwProgress.stopAnimation()
//                            }
//                        }
                    }
                    else {
                        self.manageUI(status: .startDisconnected)
                        self.startTimer()
//                        self.vwProgress.animate(toAngle: 360, duration: TimeInterval(self.totalTime)) { isDone in
//                            if isDone {
//                                //self.vwProgress.stopAnimation()
//                            }
//                        }
                    }
                }
            })
            
//            if LocationManager.shared.isLocationServiceEnabled(showAlert: false) {
//                self.manageUI(status: .startConnected)
//                self.startTimer()
//
//                self.arrlocations.removeAll()
//                LocationManager.shared.delegate = self
//                LocationManager.shared.getLocation()
//                self.vwProgress.animate(toAngle: 360, duration: TimeInterval(self.totalTime)) { isDone in
//                    if isDone{
//                        //self.vwProgress.stopAnimation()
//                    }
//                }
//            }
//            else {
//                self.manageUI(status: .startDisconnected)
//                self.startTimer()
//                self.vwProgress.animate(toAngle: 360, duration: TimeInterval(self.totalTime)) { isDone in
//                    if isDone{
//                        //self.vwProgress.stopAnimation()
//                    }
//                }
//
//            }
        }
        
        self.btnStop.addTapGestureRecognizer {
            self.completeWalking()
        }
        
        self.btnSubmit.addTapGestureRecognizer {
            self.viewModel.apiCall(vc: self,
                                   date: self.txtDate,
                                   time: self.txtTime,
                                   reading: self.txtReading,
                                   unit: self.txtUnit,
                                   readingType: self.readingType,
                                   duration: (kMaxSixMinWalkDuration - self.totalTime),
                                   readingListModel: self.readingListModel)
        }
        
        self.lblHKConnect.addTapGestureRecognizer {
            PedometerManager.shared.authenticatePedometer { isDone in
                PedometerManager.shared.pedometerAuthorizationState(showAlert: true) { isAllow in
                    self.setUpView()
                }
            }
            
            
            //LocationManager.shared.isLocationServiceEnabled(showAlert: true)
//            HealthKitManager.shared.checkHealthKitPermission { (isSync) in
//                if isSync {
//                    Alert.shared.showAlert(message: AppMessages.healthKitDisconnect, completion: nil)
//                }
//                else {
//                    self.dismiss(animated: true) {
//                        GFunction.shared.navigateToHealthConnect()
//                    }
//                }
//            }
        }
    }
    
    fileprivate func completeWalking(){
        self.totalTime = kMaxSixMinWalkDuration
        self.stopTimer()
        
//        if self.vwProgress.isAnimating(){
//          self.vwProgress.pauseAnimation()
//        }
        PedometerManager.shared.stopUpdating()
        
        PedometerManager.shared.pedometerAuthorizationState(showAlert: false, completion: { isAllow in
            if isAllow {
                self.manageUI(status: .stopConnected)
                PedometerManager.shared.fetchWalkingDistance(startDate: self.startDate) { val in
                    
                    DispatchQueue.main.async {
                        print(val)
                        self.txtReading.text = String(format: "%0.0f", Float(val))
                        if val > 0 {
                           self.txtReading.isUserInteractionEnabled = false
                        }
                    }
                }
            }
            else {
                self.manageUI(status: .stopDisconnected)
            }
        })
        
//        LocationManager.shared.stopUpdatingLocation()
//        if LocationManager.shared.isLocationServiceEnabled(showAlert: false) {
//            self.manageUI(status: .stopConnected)
//            var total: Double = 0.0
//
//            if self.arrFinalLocations.count > 0 {
//                for i in 0...self.arrFinalLocations.count - 1 {
//                    if i < self.arrFinalLocations.count - 1 {
//                        let start       = self.arrFinalLocations[i]
//                        let end         = self.arrFinalLocations[i + 1]
//                        let from        = CLLocation(latitude: start.coordinate.latitude,
//                                              longitude: start.coordinate.longitude)
//                        let to          = CLLocation(latitude: end.coordinate.latitude,
//                                            longitude: end.coordinate.longitude)
//                        let distance    =  from.distance(from: to)
//                        total += distance
//                    }
//                }
//                print(total)
//                self.txtReading.text = String(format: "%0.0f", Float(total))
//                self.txtReading.isUserInteractionEnabled = false
//            }
//            else {
//                //self.txtReading.text = String(format: "%0.0f", Float(0))
//                self.txtReading.isUserInteractionEnabled = true
//            }
//        }
//        else {
//            self.manageUI(status: .stopDisconnected)
////                self.txtReading.text = String(format: "%0.0f", Float(kMaxSixMinWalkDuration - self.totalTime))
////                self.txtReading.isUserInteractionEnabled = false
//        }
    }
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
        self.vwBg.animateBounce()
        
        NotificationCenter.default.setObserver(observer: self, selector: #selector(self.appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.setObserver(observer: self, selector: #selector(self.appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .LogReading, postFix: self.readingListModel.keys)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: -------------------- Date picker methods --------------------
extension UpdateWalkDistancePopupVC {
    
    fileprivate func initDatePicker(){
       
        //For date
        self.txtDate.inputView             = self.datePicker
        self.txtDate.delegate              = self
        self.datePicker.datePickerMode     = .date
        self.datePicker.maximumDate        =  Date()
        //self.datePicker.minimumDate        =  Calendar.current.date(byAdding: .minute, value: 0, to: Date())
        self.datePicker.timeZone           = .current
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
        
        self.dateFormatter.dateFormat       = appDateFormat
        self.dateFormatter.timeZone         = .current
        self.txtDate.text                   = self.dateFormatter.string(from: self.datePicker.date)
        self.txtDate.isUserInteractionEnabled = false
        
        //For time
        self.txtTime.inputView              = self.timePicker
        self.txtTime.delegate               = self
        self.timePicker.datePickerMode      = .time
        self.timePicker.maximumDate         = self.datePicker.maximumDate
        //self.timePicker.minimumDate          =  Calendar.current.date(byAdding: .minute, value: 0, to: Date())
        self.timePicker.timeZone            = .current
        self.timePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
        
        self.dateFormatter.dateFormat       = appTimeFormat
        self.dateFormatter.timeZone         = .current
        self.dateFormatter.locale           = NSLocale(localeIdentifier: "en_US") as Locale
        self.txtTime.text                   = self.dateFormatter.string(from: self.timePicker.date)
        self.txtTime.isUserInteractionEnabled = false
        
        if #available(iOS 14, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
            self.timePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc fileprivate func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.datePicker:
            self.dateFormatter.dateFormat   = appDateFormat
            self.dateFormatter.timeZone     = .current
            self.txtDate.text               = self.dateFormatter.string(from: sender.date)
            
            self.timePicker.date            = self.datePicker.date
            //self.timePicker.minimumDate     = Calendar.current.date(byAdding: .minute, value: 0, to: Date())
            self.txtTime.text               = ""
            break
            
        case self.timePicker:
            self.dateFormatter.dateFormat   = appTimeFormat
            self.dateFormatter.timeZone     = .current
            self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
            self.txtTime.text               = self.dateFormatter.string(from: sender.date)
            break
     
        default:break
        }
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension UpdateWalkDistancePopupVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtDate:
            
            if self.txtDate.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appDateFormat
                self.dateFormatter.timeZone     = .current
                self.txtDate.text               = self.dateFormatter.string(from: self.datePicker.date)
                
                self.timePicker.date            = self.datePicker.date
               //self.timePicker.minimumDate     = Calendar.current.date(byAdding: .day, value: 0, to: Date())
                self.txtTime.text               = ""
            }
            break
            
        case self.txtTime:
            
            if self.txtTime.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appTimeFormat
                self.dateFormatter.timeZone     = .current
                self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
                self.txtTime.text               = self.dateFormatter.string(from: self.timePicker.date)
            }
            break
        
        default:
            break
        }
        
        return true
    }
}

//MARK: -------------------- Timer Method --------------------
extension UpdateWalkDistancePopupVC {
    
    fileprivate func startTimer() {
        
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }

    @objc fileprivate func updateTime() {
        DispatchQueue.main.async {
            self.totalTime -= 1
            self.progressTime = kMaxSixMinWalkDuration - self.totalTime
            
            if self.totalTime >= 0 {
                print("\(self.timeFormatted(self.totalTime))")
                self.lblMin.text = "\(self.timeFormatted(self.totalTime))"
                UIView.animate(withDuration: 1) {
                    self.vwProgress.endPointValue = CGFloat(self.progressTime)
                }
                
                
                if self.arrlocations.count > 0 {
                    if self.totalTime % 1 == 0 {
                        if self.lastlocations == nil {
                            self.lastlocations = self.arrlocations.last!
                        }
                        else {
                            let distance = self.arrlocations.last!.distance(from: self.lastlocations)
                            print("Distance---------------- \(distance)")
                            if distance > 1 &&
                                distance < 5 {
                                self.lastlocations = self.arrlocations.last!
                                self.arrFinalLocations.append(self.arrlocations.last!)
                            }
                            else if distance > 5 &&
                                        distance < 11 {
                                self.lastlocations = self.arrlocations.last!
                            }
                        }
                    }
                }
            }
            else {
                self.lblMin.text = "00:00"
                self.completeWalking()
            }
        }
        
        //if self.totalTime != 0 {
            
        //} else {
        //    self.endTimer()
        //}

    }
 
    fileprivate func stopTimer() {
        DispatchQueue.main.async {
            
            if self.timer != nil {
                self.timer.invalidate()
                self.timer = nil
            }
        }
    }
    
    fileprivate func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

//MARK: ------------------ UITableView Methods ------------------
extension UpdateWalkDistancePopupVC {
    
    fileprivate func setData(){
        
        self.lblMin.text            = "\(self.timeFormatted(self.totalTime))"
        self.vwImgTitle
            .backGroundColor(color: UIColor.hexStringToUIColor(hex: self.readingListModel.backgroundColor).withAlphaComponent(0.1))
        self.imgTitle.setCustomImage(with: self.readingListModel.imageUrl, renderingMode: .alwaysTemplate)
        self.imgTitle.tintColor     = UIColor.hexStringToUIColor(hex: self.readingListModel.colorCode)
        self.lblTitle.text          = self.readingListModel.readingName
        self.txtUnit.text           = self.readingListModel.measurements
        self.txtUnit.isUserInteractionEnabled = false
        
        //if self.readingListModel.readingValue > 0 {
        self.txtReading.keyboardType    = .numberPad
        self.txtReading.regex           = Validations.RegexType.OnlyNumber.rawValue
        //self.txtReading.text            = "\(self.readingListModel.readingValue!)"
        //}
        
        self.txtReading.maxLength   = kMaxSixMinWalkValue.size
        self.lblStandardVal.text    = self.readingListModel.defaultReading!
    }
    
    fileprivate func manageUI(status: WalkDistancePopupStatus){
        switch status {
            
        case .willAppear:
            self.lblsSummary.isHidden       = true
            self.stackReading.isHidden      = true
            self.vwConnectParent.isHidden   = false
            self.lblHKConnectDesc.isHidden  = false
            self.vwProgressParent.isHidden  = true
            self.vwStop.isHidden            = true
            self.vwStart.isHidden           = false
            self.lblHKConnectDesc.text      = self.strNoHealth
            self.vwSubmit.isHidden          = true
            self.lblStandardVal.isHidden    = true
            break
        case .startConnected:
            
            self.lblsSummary.isHidden       = true
            self.stackReading.isHidden      = true
            self.vwConnectParent.isHidden   = true
            self.lblHKConnectDesc.isHidden  = true
            self.vwProgressParent.isHidden  = false
            self.vwStop.isHidden            = false
            self.vwStart.isHidden           = true
            self.lblHKConnectDesc.text      = self.strNoHealth
            self.vwSubmit.isHidden          = true
            self.lblStandardVal.isHidden    = true
            break
            
        case .startDisconnected:
            
            self.lblsSummary.isHidden       = true
            self.stackReading.isHidden      = true
            self.vwConnectParent.isHidden   = true
            self.lblHKConnectDesc.isHidden  = true
            self.vwProgressParent.isHidden  = false
            self.vwStop.isHidden            = false
            self.vwStart.isHidden           = true
            self.lblHKConnectDesc.text      = self.strNoHealth
            self.vwSubmit.isHidden          = true
            self.lblStandardVal.isHidden    = true
            
//            self.lblsSummary.isHidden       = false
//            self.stackReading.isHidden      = false
//            self.vwConnectParent.isHidden   = true
//            self.lblHKConnectDesc.isHidden  = true
//            self.vwProgressParent.isHidden  = true
//            self.vwStop.isHidden            = true
//            self.vwStart.isHidden           = true
//            self.lblHKConnectDesc.text      = self.strNoHealth
//            self.vwSubmit.isHidden          = false
            break
            
        case .stopConnected:
            
            self.lblsSummary.isHidden       = false
            self.stackReading.isHidden      = false
            self.vwConnectParent.isHidden   = true
            self.lblHKConnectDesc.isHidden  = true
            self.vwProgressParent.isHidden  = true
            self.vwStop.isHidden            = true
            self.vwStart.isHidden           = true
            self.lblHKConnectDesc.text      = self.strNoHealth
            self.vwSubmit.isHidden          = false
            self.lblStandardVal.isHidden    = false
            break
            
        case .stopDisconnected:
            
            self.lblsSummary.isHidden       = false
            self.stackReading.isHidden      = false
            self.vwConnectParent.isHidden   = true
            self.lblHKConnectDesc.isHidden  = true
            self.vwProgressParent.isHidden  = true
            self.vwStop.isHidden            = true
            self.vwStart.isHidden           = true
            self.lblHKConnectDesc.text      = self.strNoHealth
            self.vwSubmit.isHidden          = false
            self.lblStandardVal.isHidden    = false
            break
        
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension UpdateWalkDistancePopupVC {
    
    fileprivate func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                
                var params = [String: Any]()
                params[AnalyticsParameters.reading_name.rawValue]   = self.readingListModel.readingName
                params[AnalyticsParameters.reading_id.rawValue]     = self.readingListModel.readingsMasterId
//                params[AnalyticsParameters.duration.rawValue]     = kMaxSixMinWalkDuration
                
                FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATED_READING,
                                         screen: .LogReading,
                                         parameter: params)
                
//                let datetime = GFunction.shared.convertDateFormate(dt: self.txtDate.text! + self.txtTime.text!,
//                                                                   inputFormat: appDateFormat + appTimeFormat,
//                                                                   outputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
//                                                                   status: .NOCONVERSION)
                
                if self.isNext {
                    if let vc = self.parent?.parent as? UpdateGoalParentVC {
                        vc.goNext()
                        
                        var obj         = JSON()
                        obj["isDone"]   = true
                        if let completionHandler = vc.completionHandler {
                            completionHandler(obj)
                        }
                    }
                }
                else {
                    var obj         = JSON()
                    obj["isDone"]   = true
                    self.dismissPopUp(true, objAtIndex: obj)
                }
                
                break
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

extension UpdateWalkDistancePopupVC: LocationManagerDelegate {
    
    func didUpdateLocation(locations: CLLocation) {
        self.arrlocations.append(locations)
    }
}

extension UpdateWalkDistancePopupVC {
    @objc fileprivate func appMovedToBackground() {
        print("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦 App moved to background!")
        //self.dismissPopUp(true, objAtIndex: nil)
        self.bgDate = Date()
        self.stopTimer()
//        if self.vwProgress.isAnimating(){
//          self.vwProgress.pauseAnimation()
//        }
    }
    
    @objc fileprivate func appBecomeActive() {
        DispatchQueue.main.async {
            print("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦 App become active")
            let difference = Calendar.current.dateComponents([.second], from: self.bgDate, to: Date())
            self.totalTime -= Int(difference.second ?? 0)
            self.startTimer()
            
//            self.vwProgress.animate(toAngle: 360, duration: TimeInterval(self.totalTime)) { isDone in
//                //self.vwProgress.stopAnimation()
//            }

//            let fromAngle = -Double(self.totalTime * 360 / kMaxSixMinWalkDuration)
//            let toAngle = 360 + fromAngle
//            self.vwProgress.animate(fromAngle: fromAngle,
//                                    toAngle: toAngle,
//                                    duration: TimeInterval(kMaxSixMinWalkDuration), completion: { isDone in
//                //self.vwProgress.stopAnimation()
//            })
        }
        
    }
}
