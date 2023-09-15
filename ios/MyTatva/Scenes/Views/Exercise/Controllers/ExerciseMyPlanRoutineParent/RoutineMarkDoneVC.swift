//
//  RoutineMarkDoneVC.swift
//  MyTatva
//
//  Created by Hlink on 13/04/23.
//

import UIKit

class RoutineMarkDoneVC: ClearNavigationFontBlackBaseVC {

    //MARK: Outlet
    
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var vwMain: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet var arrOptions: [UILabel]!
    @IBOutlet var arrRadioOption: [UIImageView]!
    @IBOutlet var arrVWOptions: [UIView]!
    
    @IBOutlet var arrButtonOption: [UIButton]!
    
    @IBOutlet weak var btnSubmit: ThemePurpleButton!
        
    //------------------------------------------------------
    
    //MARK: Class Variable
    var selectedIndex = -1 {
        didSet {
            self.arrRadioOption.forEach({ $0.image = UIImage(named: self.selectedIndex == $0.tag ? "radio_select" : "radio_unselect" ) })
        }
    }
    var tempSelectedIndex = 0
    var headerTitle = ""
    var completion:((String) -> Void)?
//    var viewModel: LoginViewModel!
    var exerciseData : ExerciseDetailModel!
    
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
        self.openPopUp()
    }
    
    private func applyStyle() {
//        self.view.backGroundColor(color: .black)
        self.selectedIndex = self.tempSelectedIndex
        self.vwMain.cornerRadius(cornerRadius: 10.0)
        self.lblTitle.font(name: .bold, size: 15.0).textColor(color: .themeBlack).text = self.headerTitle
        self.lblMessage.font(name: .bold, size: 15.0).textColor(color: .themePurple).text = AppMessages.routineMarkDoneMessage
        
        self.arrOptions.forEach({ $0.font(name: .medium, size: 13.0).textColor(color: .themeBlack).text = $0.tag == 0 ? AppMessages.difficult : AppMessages.easy })
        self.arrVWOptions.forEach({ $0.backGroundColor(color: .ThemeLightGray2).cornerRadius(cornerRadius: 6.0) })
        self.arrRadioOption.forEach({ $0.image = UIImage(named: self.selectedIndex == $0.tag ? "radio_select" : "radio_unselect" ) })
        self.btnSubmit.fontSize(size: 13.0).setTitle(AppMessages.submit, for: UIControl.State())
        self.btnSubmit.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            var params: [String: Any] = [:]
            params[AnalyticsParameters.content_master_id.rawValue] = self.exerciseData.contentMasterId
            params[AnalyticsParameters.content_type.rawValue] = self.exerciseData.contentType
            params[AnalyticsParameters.exercise_name.rawValue] = self.exerciseData.title
            params[AnalyticsParameters.type.rawValue] = self.exerciseData.breathingExercise
            params[AnalyticsParameters.value.rawValue] = self.selectedIndex == 0 ? AppMessages.difficult : AppMessages.easy
            FIRAnalytics.FIRLogEvent(eventName: .USER_SUBMIT_FEEDBACK,
                                     screen: .ExerciseFeedback,
                                     parameter: params)
            self.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.completion?(self.selectedIndex == 0 ? AppMessages.difficult : AppMessages.easy)
            }
        }
    }
    
    private func setupViewModelObserver() {
        
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBG.alpha = kPopupAlpha
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    @IBAction func btnOptionsClicked(_ sender: UIButton) {
        self.selectedIndex = sender.tag
    }
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        viewModel = LoginViewModel()
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
