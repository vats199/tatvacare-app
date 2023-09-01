//
//  ExerciseStartVC.swift
//  MyTatva
//
//  Created by hyperlink on 27/10/21.
//

import UIKit

class ExerciseStartVC: ClearNavigationFontBlackBaseVC {
    
    //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var imgExercise      : UIImageView!
    @IBOutlet weak var vwProgress       : CircularSlider!
    @IBOutlet weak var lblMin           : UILabel!
    @IBOutlet weak var lblMinCons       : UILabel!
    @IBOutlet weak var btnPlay          : UIButton!
    @IBOutlet weak var lblPlay          : UILabel!
    
    @IBOutlet weak var btnBack          : UIBarButtonItem!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    var countdownTimer: Timer!
    var timerTime : Int!
    var achievedTime : Int!
    var maxTime : Int!
    let viewModel                       = ExerciseStartVM()
    var progressTime: Int               = 0
    var strErrorMessage : String        = ""
    var goalMasterId : String!
    
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
       
        self.lblMin.font(name: .medium, size: 24).textColor(color: UIColor.ThemeDarkBlack)
        self.lblMinCons.font(name: .regular, size: 12).textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblPlay.font(name: .medium, size: 16).textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        if timerTime >= 0 {
            self.lblMin.text = "\(self.timeFormatted(self.timerTime))"
        }
        else {
            self.lblMin.text = "00:00"
        }
        
        //GFunction.shared.setCircularProgress(progress: self.vwProgress)
        
        self.vwProgress.minimumValue = 0
        self.vwProgress.maximumValue = CGFloat(self.maxTime)
        GFunction.shared.setHGCircularSliderProgress(progress: self.vwProgress)
        self.progressTime = self.maxTime - self.timerTime
        UIView.animate(withDuration: 1) {
            self.vwProgress.endPointValue = CGFloat(self.progressTime)
        }
        
        self.configureUI()
        self.manageActionMethods()
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        DispatchQueue.main.async {
            self.imgExercise.layoutIfNeeded()
            self.vwProgress.layoutIfNeeded()
            GFunction.shared.setHGCircularSliderProgress(progress: self.vwProgress)
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        self.btnPlay.addTapGestureRecognizer {
            if self.btnPlay.isSelected{
                
                self.pauseTimer()
                
            }else{
//                self.vwProgress.animate(toAngle: 360, duration: TimeInterval(self.totalTime)) { isDone in
//                    if isDone{
//                        //self.vwProgress.stopAnimation()
//                    }
//                }
                
                self.progressTime   = 0
                self.startTimer()
            }
            self.btnPlay.isSelected.toggle()
        }
        
    }
    
    //action back button
    @IBAction func ActionBack(_ sender : UIBarButtonItem){
        self.btnPlay.isSelected = false
        self.pauseTimer()
        
        if (self.maxTime != self.timerTime){
            
            let vc = ExerciseDonePopupVC.instantiate(fromAppStoryboard: .exercise)
            vc.completionHandler = { (objc) in
                
                print(self.achievedTime - self.timerTime)
                let minutes: Double = Double((self.achievedTime - self.timerTime)) / Double(60)
                //let seconds  = ((self.achievedTime - self.timerTime) % 60) / 60
                //minutes = minutes + seconds
                
                let dateFormatter           = DateFormatter()
                dateFormatter.timeZone      = .current
                dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat    = DateTimeFormaterEnum.ddMMyyyyhhmma.rawValue
                let date                    = dateFormatter.string(from: Date())
                
                if self.timerTime > 0 {
                    self.viewModel.update_goal_logsAPI(goal_id: self.goalMasterId, achieved_value: String(minutes.rounded(.up)), patient_sub_goal_id: "", start_time: "", end_time: "", achieved_datetime: date) { [weak self] (isDone, date) in
                        
                        guard let self = self else {return}
                        
                        if isDone{
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true,completion: nil)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .BreathingVideo)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .BreathingVideo, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAnalytics.manageTimeSpent(on: .BreathingVideo, when: .Disappear)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


//MARK: ------------------ setup Methods ------------------
extension ExerciseStartVC {
    
    fileprivate func setData(){
        
    }
}

//MARK: -------------------- Timer Method --------------------
extension ExerciseStartVC {
    
    func startTimer() {
        do{
            let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "breathing", withExtension: "gif")!)
            self.imgExercise.image = UIImage.sd_image(withGIFData: imageData)
            FIRAnalytics.FIRLogEvent(eventName: .USER_PLAYED_GIF_IN_EXERCISE,
                                     screen: .BreathingVideo,
                                     parameter: nil)
        }
        self.lblPlay.text = AppMessages.Pause
        if self.countdownTimer == nil {
            self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }

    @objc func updateTime() {
        //self.lblMin.text = totalTime >= 0 ? "\(self.timeFormatted(self.totalTime))" : "-\(self.timeFormatted(self.totalTime * -1))"
        
        self.progressTime = self.maxTime - self.timerTime
        self.timerTime -= 1
        
        if timerTime >= 0 {
            self.lblMin.text = "\(self.timeFormatted(self.timerTime))"
            UIView.animate(withDuration: 1) {
                self.vwProgress.endPointValue = CGFloat(self.progressTime)
            }
        }
        else {
            self.lblMin.text = "00:00"
            self.pauseTimer()
        }
        
        //if self.totalTime != 0 {
            
        //} else {
        //    self.endTimer()
        //}
    }
    
    func pauseTimer(){
        self.imgExercise.image = UIImage(named: "breathing_image")
        self.lblPlay.text = AppMessages.Play
        if self.countdownTimer != nil {
            self.countdownTimer.invalidate()
            self.countdownTimer = nil
        }
        
//        if self.vwProgress.isAnimating(){
//            self.vwProgress.pauseAnimation()
//        }
    }

    func endTimer() {
        self.imgExercise.image = UIImage(named: "breathing_image")
        self.timerTime          = self.maxTime
        self.btnPlay.isSelected = false

        self.lblPlay.text       = AppMessages.Play
        
        if self.countdownTimer != nil {
            self.countdownTimer.invalidate()
            self.countdownTimer = nil
        }
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

//MARK: ------------
extension ExerciseStartVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

