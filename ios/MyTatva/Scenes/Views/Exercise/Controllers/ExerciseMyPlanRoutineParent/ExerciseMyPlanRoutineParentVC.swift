//
//  ExerciseMyPlanVC.swift
//  MyTatva
//
//  Created by Hlink on 11/04/23.
//

import UIKit

class ExerciseMyPlanRoutineParentVC: UIViewController {
    //MARK: Outlet
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var vwDate: ThemeTextfieldBorderView!
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var txtSelectDate: UITextField!
    
    @IBOutlet weak var colRoutines: UICollectionView!
        
    @IBOutlet weak var vwContainer: ThemeBgView!
    
    @IBOutlet weak var lblRestDay: UILabel!
    @IBOutlet weak var imgRestDay: UIImageView!
    @IBOutlet weak var svRestDay: UIStackView!
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    let picker = UIDatePicker()
    var viewModel: ExerciseMyPlanRoutineParentVM!
    var arrPages = [UIViewController]()
    var pageViewController = UIPageViewController()
    var oldIndex = 0
    var isPageAnimation = true
    var selectedIndex = 0 {
        didSet {
            
            guard self.oldIndex != self.selectedIndex else { return }
            
            let vc = self.arrPages[self.selectedIndex] as! ExerciseRoutineVC
            vc.viewModel.arrRoutines = self.viewModel.listOfRoutine(self.selectedIndex).exerciseDetails
            vc.isContinueCoachmark = !self.arrPages.contains(where: {!($0 as! ExerciseRoutineVC).isContinueCoachmark})
            self.pageViewController.setViewControllers([vc], direction: self.pageViewAnimationDirection(self.selectedIndex), animated: self.isPageAnimation)
            self.isPageAnimation = true
            self.oldIndex = self.selectedIndex
        }
    }
    
    var isVideoPlayerEnable = false
    
    var selectedDate = Date() {
        didSet {
            self.lblSelectedDate.text = self.formatter.string(from: self.selectedDate)
        }
    }
    var formatter: DateFormatter!
    var isContinueCoachmark = false
    var planDetails = JSON()
    
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
        self.addDatePicker()
    }
    
    private func applyStyle() {
//        self.lblTitle.font(name: .semibold,size: 21).textColor(color: .themeBlack).text = nil
        self.lblTitle.applyTheme(themeStyle: .semiBoldBlackTitle).text = " "
        self.lblSubTitle.font(name: .regular,size: 13).textColor(color: .themeBlack).text = nil
        self.lblRestDay.font(name: .medium,size: 22).textColor(color: .themeBlack).text = "Rest Day"
        self.lblRestDay.numberOfLines = 0
        self.svRestDay.isHidden = true
        self.formatter = DateFormatter()
        self.formatter.dateFormat = DateTimeFormaterEnum.ddMMMyyyy.rawValue
        self.selectedDate = Date()
        
        self.lblSelectedDate.font(name: .medium,size: 12).textColor(color: .themeBlack.withAlphaComponent(0.5))
        
        self.colRoutines.delegate = self
        self.colRoutines.dataSource = self
        self.colRoutines.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.colRoutines.showsHorizontalScrollIndicator = false
        self.colRoutines.showsVerticalScrollIndicator = false
        self.txtSelectDate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.dateChange(_:)))
        
    }
    
    private func setupViewModelObserver() {
        
        self.viewModel.planDetails.bind { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let details):
                guard let details = details else { return }
                self.planDetails = details
                self.lblTitle.text = details["exercise_plan_name"].stringValue
                
                self.lblSubTitle.text = kValidFrom + GFunction.shared.convertDateFormat(dt: details["start_date"].stringValue, inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue, outputFormat: DateTimeFormaterEnum.ddMMMyyyy.rawValue, status: .NOCONVERSION).str + kTo + GFunction.shared.convertDateFormat(dt: details["end_date"].stringValue, inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue, outputFormat: DateTimeFormaterEnum.ddMMMyyyy.rawValue, status: .NOCONVERSION).str
                
                self.svRestDay.isHidden = true
                self.colRoutines.isHidden = false
                break
            case .failure(let error):
//                Alert.shared.showSnackBar(error.localizedDescription)
                debugPrint(error.localizedDescription)
                self.colRoutines.isHidden = true
                self.lblTitle.text = " "
                self.lblSubTitle.text = nil
                self.svRestDay.isHidden = false
                self.imgRestDay.isHidden = true
                self.lblRestDay.font(name: .medium, size: 15.0).textColor(color: .themePurple).text = error.localizedDescription
                break
            case .none: break
            }
        }
        
        self.viewModel.isRoutineChange.bind { [weak self] isDone in
            guard let self = self, let isDone = isDone else {
                return
            }
            
            self.svRestDay.isHidden = isDone
            self.imgRestDay.isHidden = isDone
            self.lblRestDay.font(name: .medium,size: 22).textColor(color: .themeBlack).text = "Rest Day"
            self.colRoutines.isHidden = !isDone
            
            self.colRoutines.reloadData()
            self.arrPages.removeAll()
            if !isDone {
                self.pageViewController.removeFromParent()
                self.pageViewController.view.removeFromSuperview()
            }
            if self.arrPages.isEmpty {
                for _ in 0..<self.viewModel.numberOfRoutines() {
                    let vc = ExerciseRoutineVC.instantiate(fromAppStoryboard: .exercise)
                    vc.viewModel.arrRoutines = self.viewModel.listOfRoutine(self.selectedIndex).exerciseDetails
                    vc.isContinueCoachmark = self.isContinueCoachmark
                    self.arrPages.append(vc)
                }
                
                if let _ = self.arrPages.first {
                    self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                    self.pageViewController.setViewControllers([self.arrPages[0]], direction: self.pageViewAnimationDirection(self.selectedIndex), animated: true)
//                    self.pageViewController.delegate = self
//                    self.pageViewController.dataSource = self
                    self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.vwContainer.frame.size.width, height: self.vwContainer.frame.size.height)
                    self.addChild(self.pageViewController)
                    self.vwContainer.subviews.forEach({$0.removeFromSuperview()})
                    self.vwContainer.addSubview(self.pageViewController.view)
                    self.pageViewController.didMove(toParent: self)
                    self.pageViewController.view.backGroundColor(color: .clear)                    
                }
                                
            }
           
            DispatchQueue.main.async { [weak self] in
                guard let self = self, self.viewModel.numberOfRoutines() > 0, !self.isContinueCoachmark else { return }
                self.selectedIndex = self.viewModel.getSelectedIndex()
                self.colRoutines.scrollToItem(at: IndexPath(row: self.selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
            
        }
    }
    
    private func pageViewAnimationDirection(_ indexPathRow: Int) -> UIPageViewController.NavigationDirection {
        return self.selectedIndex < self.oldIndex ? .reverse : .forward
        /*if let firstVC = self.pageViewController.viewControllers?.first, let index = self.arrPages.firstIndex(of: firstVC) {
            return index < indexPathRow ?  .forward : .reverse
        } else {
            return .forward
        }*/
    }
    
    @objc
    func dateChange(_ sender: UIDatePicker) {
        var params: [String: Any] = [:]
        FIRAnalytics.FIRLogEvent(eventName: .USER_CHANGES_DATE,
                                 screen: .ExerciseMyRoutine,
                                 parameter: params)
        self.selectedDate = self.picker.date
//        self.selectedIndex = 0
        self.viewModel.getRoutines(planDate: self.selectedDate)
    }
    
    private func addDatePicker() {
        picker.datePickerMode = .date
        if #available(iOS 14, *) {
            picker.preferredDatePickerStyle = .wheels
        }
//        picker.addTarget(self, action: #selector(self.dateChange(_:)), for: .valueChanged)
        self.txtSelectDate.inputView = picker
        
//        self.txtSelectDate.delegate = self
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    @IBAction func btnDatePickerClicked(_ sender: UIButton) {
        
    }
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = ExerciseMyPlanRoutineParentVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
        /*self.picker.date = Date()
        self.lblSelectedDate.text = self.formatter.string(from: self.picker.date)
        self.viewModel.getRoutines()*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.isVideoPlayerEnable{
//            self.picker.date = Date()
            self.lblSelectedDate.text = self.formatter.string(from: self.picker.date)
            self.viewModel.getRoutines(selectedIndex: self.selectedIndex, planDate: self.picker.date)
        }
        self.isVideoPlayerEnable = false
    }
}

//------------------------------------------------------
//MARK: - UICollectionViewDelegate,Datasource
extension ExerciseMyPlanRoutineParentVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRoutines()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: RoutineCell.self, for: indexPath)
        cell.setData(data: self.viewModel.listOfRoutine(indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.viewModel.listOfRoutine(indexPath.row).title.widthOfString(usingFont: .customFont(ofType: .bold, withSize: 16.0))+12, height: collectionView.frame.height)
//        CGSize(width: 150, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.didSelectect(indexPath.row)
        self.colRoutines.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.selectedIndex = indexPath.row
    
        var params: [String: Any] = [:]
        params[AnalyticsParameters.routine_no.rawValue] = self.viewModel.listOfRoutine(indexPath.row).routineNo
        params[AnalyticsParameters.patient_exercise_plans_id.rawValue] = self.planDetails["patient_exercise_plans_id"].stringValue
        params[AnalyticsParameters.exercise_plan_name.rawValue] = self.planDetails["exercise_plan_name"].stringValue
        params[AnalyticsParameters.start_date.rawValue] = self.planDetails["start_date"].stringValue
        params[AnalyticsParameters.end_date.rawValue] = self.planDetails["end_date"].stringValue
        FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_ROUTINE,
                                 screen: .ExerciseMyRoutine,
                                 parameter: params)
    }
    
}

//------------------------------------------------------
//MARK: - UIPageViewControllerDelegate,Datasource
extension ExerciseMyPlanRoutineParentVC: UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.arrPages.firstIndex(of: viewController) else {
            return nil
        }
        
        if viewControllerIndex == 0 {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        return self.arrPages[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.arrPages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = self.arrPages.count
        return orderedViewControllersCount == nextIndex ? nil : self.arrPages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        self.arrPages.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = self.pageViewController.viewControllers?.first,
           let index = self.arrPages.firstIndex(of: firstViewController),
           let _ = self.arrPages.firstIndex(of: previousViewControllers.first!) {
            self.colRoutines.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
}
