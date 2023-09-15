//
//  RoutineExercisePopupVC.swift
//  MyTatva
//
//  Created by 2022M43 on 18/04/23.
//

import Foundation
import UIKit

class Routine {
   var routineTittle: String?
   var routineValue: [String]?
     
   init(routineTittle: String, routineValue: [String]) {
       self.routineTittle = routineTittle
       self.routineValue = routineValue
   }
}

class RoutineExerciseCell : UITableViewCell {
    
    @IBOutlet weak var vwBG                     : UIView!
    @IBOutlet weak var lblExerciseName          : UILabel!
    @IBOutlet weak var btnStatus                : UIButton!
    @IBOutlet weak var lblMins                  : UILabel!
    
    @IBOutlet weak var btnMinus                 : UIButton!
    @IBOutlet weak var btnPlus                  : UIButton!
    
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
        self.lblMins.font(name: .medium, size: 13.0).textColor(color: .themeBlack)
        self.lblExerciseName.font(name: .regular, size: 13.0).textColor(color: .themeGray)
    }
}

class RoutineExercisePopupVC: ClearNavigationFontBlackBaseVC {
    
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg                : UIImageView!
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var lblProgress          : UILabel!
    @IBOutlet weak var linearProgressBar    : LinearProgressBar!
    
    @IBOutlet weak var txtDate              : UITextField!
    
    @IBOutlet weak var txtTime              : UITextField!
    
    @IBOutlet weak var lblLogHere           : UILabel!
    
    @IBOutlet weak var btnAdd               : UIButton!
    @IBOutlet weak var btnAddAndNext        : UIButton!
    @IBOutlet weak var btnCancelTop         : UIButton!
    @IBOutlet weak var btnEditGoal          : UIButton!
    
    @IBOutlet weak var vwHKConnect          : UIView!
    @IBOutlet weak var lblHKConnect         : UILabel!
    
    /*@IBOutlet weak var tblRoutineList          : UITableView!
    
    @IBOutlet weak var constRoutinetblHeight: NSLayoutConstraint!*/
    
    //MARK: - Class Variables
    var routineData = [Routine]()
    var viewModel = ExerciseRoutineVM()
    var datePicker                      = UIDatePicker()
    var timePicker                      = UIDatePicker()
    var dateFormatter                   = DateFormatter()
    var performOtherExersice            : ((Bool) -> Void)?
    var goalListModel                   = GoalListModel()
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
//        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {
        
        self.applyStyle()
//        self.setupViewModelObserver()
        GFunction.shared.setGoalProgressData(goalListModel: self.goalListModel,
                                             lblProgress: self.lblProgress,
                                             linearProgressBar: self.linearProgressBar)
        
        /*routineData.append(Routine.init(routineTittle: "Routine 1", routineValue: ["Push ups","Lungs"]))
        routineData.append(Routine.init(routineTittle: "Routine 2", routineValue: ["Push ups","Lungs"]))
        routineData.append(Routine.init(routineTittle: "Routine 3", routineValue: ["Push ups","Lungs"]))
        routineData.append(Routine.init(routineTittle: "Routine 4", routineValue: ["Push ups","Lungs"]))*/
        
        /*self.tblRoutineList.delegate = self
        self.tblRoutineList.dataSource = self
        
        self.tblRoutineList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)*/
        
        self.vwBg.animateBounce()
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
    }
    
    func applyStyle() {
        
        self.lblTitle.font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack)
        self.lblProgress.font(name: .bold, size: 11)
            .textColor(color: UIColor.colorFromHex(hex: 0x9F8EAA))
        
        self.txtDate.font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack)
        self.txtTime.font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack)
        
        self.btnEditGoal.font(name: .medium, size: 11)
            .textColor(color: UIColor.themePurple)
        
        self.btnAdd.font(name: .medium, size: 13)
            .textColor(color: UIColor.themePurple)
            .borderColor(color: UIColor.themePurple, borderWidth: 1)
            .cornerRadius(cornerRadius: 7)
            .backGroundColor(color: UIColor.white)
        
        self.btnAddAndNext.font(name: .medium, size: 13)
            .textColor(color: UIColor.white)
        
        self.lblLogHere.font(name: .medium, size: 11)
            .textColor(color: UIColor.themePurple)
        self.lblHKConnect.font(name: .medium, size: 13)
            .textColor(color: UIColor.themePurple)
 
        GFunction.shared.setUpHealthKitConnectionLabel(vw: self.vwHKConnect, lbl: self.lblHKConnect){ [weak self] (isDone) in
            guard let _ = self else {return}
            if isDone {
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwBg.layoutIfNeeded()
            self.btnAdd.layoutIfNeeded()
            self.btnAddAndNext.layoutIfNeeded()
            
            self.vwBg.cornerRadius(cornerRadius: 10)
            self.btnAddAndNext
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnAdd
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.white)
            
            self.btnEditGoal.layoutIfNeeded()
            self.btnEditGoal
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.white)
            self.linearProgressBar.progressValue = 50
            self.setProgress(progressBar: self.linearProgressBar, color: .themeRed)
            self.initDatePicker()
        }
    }
        
    fileprivate func configureUI(){
        
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : JSON? = nil) {
        self.dismiss(animated: animated) { [weak self] in
            guard let self = self else { return }
        }
    }
    
    fileprivate func initDatePicker(){
       
        self.txtDate.inputView             = self.datePicker
        self.txtDate.delegate              = self
        self.datePicker.datePickerMode     = .date
        self.datePicker.maximumDate        =  Date()
        //self.datePicker.minimumDate        =  Calendar.current.date(byAdding: .month, value: -1, to: Date())
        self.datePicker.timeZone           = .current
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
        self.txtDate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.dateChange(_:)))
        
        self.dateFormatter.dateFormat       = appDateFormat
        self.dateFormatter.timeZone         = .current
        self.txtDate.text                   = self.dateFormatter.string(from: self.datePicker.date)
        
        self.txtTime.inputView              = self.timePicker
        self.txtTime.delegate               = self
        self.timePicker.datePickerMode      = .time
        self.timePicker.maximumDate         = self.datePicker.maximumDate
        //self.timePicker.minimumDate          =  Calendar.current.date(byAdding: .minute, value: 0, to: self.datePicker.date)
        self.timePicker.timeZone            = .current
        self.timePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
        
        self.dateFormatter.dateFormat       = appTimeFormat
        self.dateFormatter.timeZone         = .current
        self.dateFormatter.locale           = NSLocale(localeIdentifier: "en_US") as Locale
        self.txtTime.text                   = self.dateFormatter.string(from: self.timePicker.date)
        
        if #available(iOS 14, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
            self.timePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc
    func dateChange(_ sender: UIDatePicker) {
        self.dateFormatter.dateFormat   = appDateFormat
        self.dateFormatter.timeZone     = .current
        self.txtDate.text               = self.dateFormatter.string(from: self.datePicker.date)
        self.viewModel.getRoutines(planDate: self.datePicker.date) { [weak self] isRestDay in
            guard let self = self,isRestDay else { return }
            self.dismiss(animated: false) { [weak self] in
                guard let self = self else { return }
                self.performOtherExersice?(true)
            }
        }
        self.timePicker.date            = self.datePicker.date
        //self.timePicker.minimumDate     = Calendar.current.date(byAdding: .minute, value: 0, to: self.datePicker.date)
        self.txtTime.text               = ""
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.datePicker:
            self.dateFormatter.dateFormat   = appDateFormat
            self.dateFormatter.timeZone     = .current
            self.txtDate.text               = self.dateFormatter.string(from: sender.date)
            
            self.timePicker.date            = self.datePicker.date
            //self.timePicker.minimumDate     = Calendar.current.date(byAdding: .minute, value: 0, to: self.datePicker.date)
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
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        
        self.imgBg.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
//            var obj         = JSON()
//            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: nil)
        }

        self.btnCancelTop.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
//            var obj         = JSON()
//            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: nil)
        }

     /*   self.lblHKConnect.addTapGestureRecognizer {
            HealthKitManager.shared.checkHealthKitPermission { (isSync) in
                if isSync {
                    Alert.shared.showAlert(message: AppMessages.healthKitDisconnect, completion: nil)
                }
                else {
                    self.dismiss(animated: true) {
                        GFunction.shared.navigateToHealthConnect { obj in
                        }
                    }
                }
            }
        }*/

        self.btnEditGoal.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.dismissPopUp(true, objAtIndex: nil)
            GFunction.shared.navigateToSetGoal()
        }
    }
    
    @IBAction func btnAddDifferentExersiceClicked(_ sender: UIButton) {
        self.dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            self.performOtherExersice?(true)
        }
    }
    
    func setProgress(progressBar: LinearProgressBar, color: UIColor){
        progressBar.trackColor          = UIColor.themeLightGray
        progressBar.trackPadding        = 0
        progressBar.capType             = 1
        
        switch progressBar {
        
        case self.linearProgressBar:
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
            
            break
       
        default: break
        }
    }
    
    private func showRoutineDifficultPopUp(_ indexPath: IndexPath) {
        let vc = RoutineMarkDoneVC.instantiate(fromAppStoryboard: .exercise)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.completion = { [weak self] difficulty in
            guard let self = self else { return }
            self.viewModel.addDifficulty(indexPath: indexPath, difficulty: difficulty)
        }
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    
    /*private func setupViewModelObserver() {
        self.viewModel.isRoutineChanged.bind { [weak self] isDone in
            guard let self = self, (isDone ?? false) else { return }
            self.tblRoutineList.reloadData()
        }
    }*/
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    /*override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblRoutineList && keyPath == "contentSize", let size = change?[.newKey] as? CGSize {
                let halfHeight = (ScreenSize.height/2) - 100
                self.constRoutinetblHeight.constant = size.height > halfHeight ? halfHeight : size.height
                self.tblRoutineList.isScrollEnabled = size.height > halfHeight
            }
        }
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblRoutineList else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }*/
    
}

//------------------------------------------------------
//MARK: - UITableViewDelegate,Datasource
extension RoutineExercisePopupVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSectionInExercise()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInExercise(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RoutineExerciseCell.self)
        let obj = self.viewModel.listOfRowsInExercise(indexPath)
        cell.lblExerciseName.text = obj.title
        cell.lblMins.text = JSON(obj.timeDuration as Any).stringValue + " " + obj.durationUnit
        cell.btnStatus.isSelected = obj.isDone
        cell.btnStatus.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            guard !self.txtTime.text!.isEmpty else {
                Alert.shared.showSnackBar(AppError.validation(type: .selectTime).localizedDescription)
                return
            }
            /*self.viewModel.markDoneRoutine(indexPath) { [weak self] isDone in
                guard let self = self, isDone else { return }
                if self.viewModel.listOfRowsInExercise(indexPath).isDone {
                    self.showRoutineDifficultPopUp(indexPath)
                }
            }*/
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 15, height: 40))
        lbl.font(name: .medium, size: 13.0)
        lbl.text = self.viewModel.listOfSectionInExercise(section).title
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension RoutineExercisePopupVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtDate:
            
            if self.txtDate.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appDateFormat
                self.dateFormatter.timeZone     = .current
                self.txtDate.text               = self.dateFormatter.string(from: self.datePicker.date)
                
                self.timePicker.date            = self.datePicker.date
                //self.timePicker.minimumDate     = Calendar.current.date(byAdding: .minute, value: 0, to: self.datePicker.date)
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
