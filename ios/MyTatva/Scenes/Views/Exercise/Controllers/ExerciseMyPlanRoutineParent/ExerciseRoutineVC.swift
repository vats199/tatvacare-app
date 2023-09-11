//
//  ExerciseRoutineVC.swift
//  MyTatva
//
//  Created by Hlink on 12/04/23.
//

import UIKit

class ExerciseRoutineVC: UIViewController {

    //MARK: Outlet
    
    @IBOutlet weak var tblRoutines: UITableView!
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel: ExerciseRoutineVM!
    var isContinueCoachmark = false
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.applyStyle()
        self.isContinueCoachmark ? self.startAppTour() : nil
    }
    
    private func applyStyle() {
        self.tblRoutines.delegate = self
        self.tblRoutines.dataSource = self
    }
    
    private func setupViewModelObserver() {
        self.viewModel.isRoutineChanged.bind { [weak self] isDone in
            guard let self = self, (isDone ?? false) else { return }
            self.tblRoutines.reloadData()
            self.isContinueCoachmark ? self.startAppTour() : nil
        }
    }
    
    private func showRoutineDifficultPopUp(_ indexPath: IndexPath) {
        let obj = self.viewModel.listOfRow(indexPath.row)
        let difficulty = obj.difficultyLevel ?? ""
        let vc = RoutineMarkDoneVC.instantiate(fromAppStoryboard: .exercise)
        vc.headerTitle = obj.title
        vc.tempSelectedIndex = difficulty.isEmpty || difficulty == AppMessages.difficult ? 0 : 1
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.completion = { [weak self] difficulty in
            guard let self = self else { return }
            self.viewModel.addDifficulty(index: indexPath.row, difficulty: difficulty)
        }
        vc.exerciseData = obj
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    
    func startAppTour(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isContinueCoachmark = false
            
            if let vc = self.parent?.parent as? ExerciseMyPlanRoutineParentVC {
                vc.isContinueCoachmark = false
            }
            
            self.tblRoutines.scrollToTop(animated: false)
            let vc = CoachmarkExercisePlanVC.instantiate(fromAppStoryboard: .home)
            vc.targetView = self.tblRoutines
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandler = { [weak self]  obj in
                guard let self = self else { return }
                if obj?.count > 0 {
                    if let vc = UIApplication.topViewController() as? ExerciseParentVC {
                        vc.manageSelection(type: .Explore)
                        vc.isContinueCoachmark = true
                    }
                }
            }
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }
    }
    
    private func playExerciseVideo(obj:ExerciseDetailModel) {
        if let vc = self.parent?.parent as? ExerciseMyPlanRoutineParentVC {
            vc.isVideoPlayerEnable = true
        }
        GFunction.shared.openVideoPlayer(strUrl: obj.media.mediaUrl,
                                         content_master_id: obj.contentMasterId,
                                         content_type: obj.contentType)
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = ExerciseRoutineVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

//------------------------------------------------------
//MARK: - UITableViewDelegate,Datasource
extension ExerciseRoutineVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RoutineDetailsCell.self)
        let obj = self.viewModel.listOfRow(indexPath.row)
        cell.configure(data: obj)
        cell.btnDone.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            var params              = [String : Any]()
            params[AnalyticsParameters.content_master_id.rawValue] = obj.contentMasterId
            params[AnalyticsParameters.content_type.rawValue] = obj.contentType
            params[AnalyticsParameters.exercise_name.rawValue] = obj.title
            params[AnalyticsParameters.type.rawValue] = obj.breathingExercise
            let state = self.viewModel.listOfRow(indexPath.row).isDone
            params[AnalyticsParameters.flag.rawValue] = state == true ? "off" : "on"
            FIRAnalytics.FIRLogEvent(eventName: .USER_MARKED_VIDEO_DONE_EXERCISE,
                                     screen: .ExerciseMyRoutine,
                                     parameter: params)
            self.viewModel.markDoneRoutine(indexPath.row) { [weak self] isDone in
                guard let self = self,isDone, self.viewModel.listOfRow(indexPath.row).isDone else { return }
                self.showRoutineDifficultPopUp(indexPath)
            }
            /*DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if self.viewModel.listOfRow(indexPath.row).isDone {
                    self.showRoutineDifficultPopUp(indexPath)
                }
            }*/
            
        }
        cell.btnDifficulty.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.showRoutineDifficultPopUp(indexPath)
        }
        
        cell.lblReadMore.addTapGestureRecognizer { [weak self] in
            guard let _ = self else { return }
            var params: [String: Any] = [:]
            params[AnalyticsParameters.content_master_id.rawValue] = obj.contentMasterId
            params[AnalyticsParameters.content_type.rawValue] = obj.contentType
            params[AnalyticsParameters.exercise_name.rawValue] = obj.title
            params[AnalyticsParameters.type.rawValue] = obj.breathingExercise
            FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_READ_MORE,
                                     screen: .ExerciseMyRoutine,
                                     parameter: params)
            let vc = ExerciseInfoPopupVC.instantiate(fromAppStoryboard: .exercise)
            vc.infoTitle = obj.title
            vc.infoDesc = obj.descriptionField
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            UIApplication.topViewController()?.present(vc, animated: true)            
        }
        
        cell.imgVideo.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.playExerciseVideo(obj: obj)
        }
        
        cell.btnVideo.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            var param = [String : Any]()
            param[AnalyticsParameters.content_master_id.rawValue]   = obj.contentMasterId
            param[AnalyticsParameters.content_type.rawValue]        = obj.contentType
            param[AnalyticsParameters.exercise_name.rawValue]       = obj.title
            param[AnalyticsParameters.type.rawValue]                = obj.breathingExercise
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_PLAN_EXERCISE,
                                     screen: .ExerciseMyRoutine,
                                     parameter: param)
            self.playExerciseVideo(obj: obj)
        }
        
        return cell
    }
        
}
