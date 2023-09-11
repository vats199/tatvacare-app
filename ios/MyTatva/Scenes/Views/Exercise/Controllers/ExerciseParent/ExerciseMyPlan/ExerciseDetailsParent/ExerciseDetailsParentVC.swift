//
//  VehicleParentVC.swift
//  SM
//
//  Created by Hyperlink on 06/12/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

enum ExerciseDetailsType: String {
    case Breathing      = "Breathing"
    case Exercises      = "Exercises"
}

class ExerciseDetailsParentVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var scrollMain           : UIScrollView!
    
    @IBOutlet weak var vwTopParent          : UIView!
    @IBOutlet weak var vwTop                : UIView!
    @IBOutlet weak var lblDate              : UILabel!
    
    @IBOutlet weak var stackRestPostSet     : UIStackView!
    @IBOutlet weak var lblRestPostSet       : UILabel!
    
    @IBOutlet weak var stackRestPostExercise: UIStackView!
    @IBOutlet weak var lblRestPostExercise  : UILabel!
    
    @IBOutlet weak var lblBreathing         : UILabel!
    @IBOutlet weak var lblBreathingCount    : UILabel!
    @IBOutlet weak var lblBreathingDuration : UILabel!
    
    @IBOutlet weak var lblExercise          : UILabel!
    @IBOutlet weak var lblExerciseCount     : UILabel!
    @IBOutlet weak var lblExerciseDuration  : UILabel!
    
    @IBOutlet weak var vwRoutine            : UIView!
    @IBOutlet weak var lblRoutine           : UILabel!
    @IBOutlet weak var btnmarkDone          : UIButton!
    
    @IBOutlet weak var colTitle             : UICollectionView!
    @IBOutlet weak var vwContainer          : UIView!
    @IBOutlet weak var vwContainerHeight    : NSLayoutConstraint!
    
    
    //MARK:- Class Variable
    var arrOfflineobject                = [ExerciseFilterModel]()
    var exercise_plan_day_id            = ""
    var routine_id                      = ""
    var plan_type                       = ""
    var exerciseAddedBy                 = ""
    
    fileprivate lazy var pageViewController : UIPageViewController = UIPageViewController()
    fileprivate lazy var pages: [UIViewController] = []
    var selectedIndex : Int     = 0
    var completionHandler: ((_ obj : JSON?) -> Void)?
    var exerciseDetailsType: ExerciseDetailsType = .Exercises
    
    let viewModel                       = ExerciseDetailsListVM()
    var object                          = ExerciseDetailListModel()
    let vc1 = ExerciseDetailsListVC.instantiate(fromAppStoryboard: .exercise)
    let vc2 = ExerciseDetailsListVC.instantiate(fromAppStoryboard: .exercise)
    
    var arrTitle = [JSON]()
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- Custom Method
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    func setUpView() {
        self.scrollMain.delegate = self
        self.scrollMain.isScrollEnabled = true
        
        self.setUpPageViewControllerNColView()
        self.manageActionMethods()
        self.setup(collectionView: self.colTitle)
        
        self.lblDate
            .font(name: .semibold, size: 17)
            .textColor(color: UIColor.white)
        
        self.lblRestPostSet
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.white)
        self.lblRestPostExercise
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.white)
        
        self.lblBreathing
            .font(name: .semibold, size: 17)
            .textColor(color: UIColor.white)
        self.lblBreathingCount
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.white)
        self.lblBreathingDuration
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.white)
        
        self.lblExercise
            .font(name: .semibold, size: 17)
            .textColor(color: UIColor.white)
        self.lblExerciseCount
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.white)
        self.lblExerciseDuration
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.white)
        
        self.lblRoutine
            .font(name: .semibold, size: 18)
            .textColor(color: UIColor.themeBlack)
        
        self.btnmarkDone
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.vwTop.layoutIfNeeded()
            self.btnmarkDone.layoutIfNeeded()
            self.vwContainer.layoutIfNeeded()
            self.colTitle.layoutIfNeeded()
            
            self.vwContainerHeight.constant -= self.colTitle.frame.height
            
            self.btnmarkDone.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.vwTop.cornerRadius(cornerRadius: 10)
            let color = GFunction.shared.applyGradientColor(startColor: UIColor.themePurple.withAlphaComponent(1),
                                                            endColor: UIColor.themePurple.withAlphaComponent(0.3),
                                                            locations: [0, 1],
                                                            startPoint: CGPoint(x: 0, y: self.vwTop.frame.maxY),
                                                            endPoint: CGPoint(x: self.vwTop.frame.maxX, y: self.vwTop.frame.maxY),
                                                            gradiantWidth: self.vwTop.frame.width,
                                                            gradiantHeight: self.vwTop.frame.height)
            
            self.vwTop.backgroundColor = color
        }
    }
    
    func setUpPageViewControllerNColView() {
        self.pages.removeAll()
        
        var isAllowParent       = false
        
        PlanManager.shared.isAllowedByPlan(type: .exercise_my_routine_breathing,
                                           sub_features_id: "",
                                           completion: { isAllow in
            if isAllow{
                isAllowParent               = true
                var obj1                    = JSON()
                obj1["name"]                = "Breathing"
                obj1["type"].stringValue    = ExerciseDetailsType.Breathing.rawValue
                obj1["is_select"]           = 1
                self.arrTitle.append(obj1)
            }
        })
        
        PlanManager.shared.isAllowedByPlan(type: .exercise_my_routine_exercise,
                                           sub_features_id: "",
                                           completion: { isAllow in
            if isAllow{
                isAllowParent               = true
                var obj2                    = JSON()
                obj2["name"]                = "Exercises"
                obj2["type"].stringValue    = ExerciseDetailsType.Exercises.rawValue
                obj2["is_select"]           = 1
                self.arrTitle.append(obj2)
            }
        })
        
        if !isAllowParent {
            Alert.shared.showAlert(message: AppMessages.SubscribeToContinue) { [weak self] isDone in
                guard let self = self else {return}
                if isDone {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        //pageView Controller setup
        for item in self.arrTitle {
            if item["name"].stringValue.lowercased().contains("Breathing".lowercased()) {
                let vc                      = vc1
                vc.exerciseDetailsType      = .Breathing
                vc.exercise_plan_day_id     = self.exercise_plan_day_id
                vc.routine_id               = self.routine_id
                vc.plan_type                = self.plan_type
                vc.exerciseAddedBy          = self.exerciseAddedBy
                self.pages.append(vc)
            }
            else if item["name"].stringValue.lowercased().contains("Exercises".lowercased()) {
                let vc                      = vc2
                vc.exerciseDetailsType      = .Exercises
                vc.exercise_plan_day_id     = self.exercise_plan_day_id
                vc.routine_id               = self.routine_id
                vc.plan_type                = self.plan_type
                vc.exerciseAddedBy          = self.exerciseAddedBy
                self.pages.append(vc)
            }   
        }
       
        /*
         Static entry
         for i in 0...self.arrList.count - 1 {
             switch i {
             case 0:
                 let vc = UpdateMedicationPopupVC.instantiate(fromAppStoryboard: .goal)
                 self.pages.append(vc)
                 break
             case 1:
                 let vc = UpdateExercisePopupVC.instantiate(fromAppStoryboard: .goal)
                 self.pages.append(vc)
                 break
             case 2:
                 let vc = UpdatePranayamPopupVC.instantiate(fromAppStoryboard: .goal)
                 self.pages.append(vc)
                 break
             case 3:
                 let vc = UpdateStepsPopupVC.instantiate(fromAppStoryboard: .goal)
                 self.pages.append(vc)
                 break
             case 4:
                 let vc = UpdateWaterPopupVC.instantiate(fromAppStoryboard: .goal)
                 self.pages.append(vc)
                 break
             case 5:
                 let vc = UpdateSleepPopupVC.instantiate(fromAppStoryboard: .goal)
                 self.pages.append(vc)
                 break
             default:
                 let vc = UpdateMedicationPopupVC.instantiate(fromAppStoryboard: .goal)
                 self.pages.append(vc)
                 break
             }
         }
         */
        
        
        if let _ = self.pages.first {
            self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            //self.pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
            self.pageViewController.setViewControllers([self.pages[self.selectedIndex]], direction: self.pageViewAnimationDirection(self.selectedIndex), animated: true, completion: nil )
            self.pageViewController.delegate = self
            self.pageViewController.dataSource = self
            self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.vwContainer.frame.size.width, height: self.vwContainer.frame.size.height)
            addChild(self.pageViewController)
            
            for vw in self.vwContainer.subviews {
                vw.removeFromSuperview()
            }
            
            self.vwContainer.addSubview(self.pageViewController.view)
            self.pageViewController.didMove(toParent: self)
            
            for subview in self.vwContainer.subviews[0].subviews {
                if let scrollview = subview as? UIScrollView {
                    scrollview.isScrollEnabled = false
                    break
                }
            }
        }
        
//        self.colPages.dataSource = self
//        self.colPages.delegate = self
//        self.colPages.reloadData()
        
//        if let _ = self.arrayPagesData.first {
//            self.colPages.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
//        }
    }
    
    func pageViewAnimationDirection(_ indexPathRow : Int) -> UIPageViewController.NavigationDirection {
        
        if let firstVC = self.pageViewController.viewControllers?.first,
            let index = self.pages.firstIndex(of: firstVC) {
            
            if index < indexPathRow {
                return .forward
            } else {
                return .reverse
            }
            
        } else {
            return .forward
        }
    }
    
    func collectionAnimationDirection(_ previousIndex : Int) -> UICollectionView.ScrollPosition {
        
        if let firstVC = self.pageViewController.viewControllers?.first,
        let index = self.pages.firstIndex(of: firstVC) {
            
            print("PreviousIndex :\(previousIndex) - Index :\(index)")
            if previousIndex < index {
                return .centeredHorizontally
            } else {
                return .centeredHorizontally
            }
            
        } else {
            return .left
        }
    }
    
    func getCurrentPageViewController() -> (UIViewController? , Int?)? {
        
        if let firstVC = self.pageViewController.viewControllers?.first,
        let index = self.pages.firstIndex(of: firstVC) {
            
            return(firstVC,index)
        } else {
            return(nil,nil)
        }
    }
    
    func goNext(){
        if self.selectedIndex < self.arrTitle.count - 1 {
            //Allow to go next
            self.selectedIndex += 1
            self.pageViewController.setViewControllers([self.pages[self.selectedIndex]], direction: self.pageViewAnimationDirection(self.selectedIndex), animated: true, completion: nil )
        }
        else {
            
            if let completionHandler = self.completionHandler {
                let obj = JSON()
                completionHandler(obj)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func goPrevious(){
        if self.selectedIndex > 0 {
            //Allow to go previous
            self.selectedIndex -= 1
            self.pageViewController.setViewControllers([self.pages[self.selectedIndex]], direction: self.pageViewAnimationDirection(self.selectedIndex), animated: true, completion: nil )
        }
    }
    
    func setup(collectionView: UICollectionView){
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    //MARK: -------------------- Action Method --------------------
    func manageActionMethods() {
        self.btnmarkDone.addTapGestureRecognizer {
            var type = "E"
            if self.exerciseDetailsType == .Breathing{
                type = "B"
            }
            self.viewModel.updateBreathingexerciseLogApi(withLoader: true,
                                                         exercise_plan_day_id: self.object.exercisePlanDayId,
                                                         routine: self.routine_id,
                                                         type: type,
                                                         plan_type: self.plan_type,
                                                         add_type: self.exerciseAddedBy) { [weak self] (isDone) in
                guard let self = self else {return}
                self.vwRoutine.isHidden = true
            }
        }
    }
    
    @IBAction func btnFilterTapped(sender: UIButton){
//        let vc = ExerciseFilterVC.instantiate(fromAppStoryboard: .exercise)
//        vc.arrOfflineobject = self.arrOfflineobject
//        vc.modalPresentationStyle = .overFullScreen
//        vc.completionHandler = { obj in
//            if obj != nil {
//                self.arrOfflineobject = obj!
//                if let vc = self.pages.first as? ExerciseMoreVC {
//                    vc.selectedFilterobject = self.selectedFilterobject
//                    //vc.updateAPIData(withLoader: true)
//                }
//            }
//        }
        
//        let nav = UINavigationController(rootViewController: vc)
//        UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
    }
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpView()
        WebengageManager.shared.navigateScreenEvent(screen: .ExercisePlanDayDetail)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        DispatchQueue.main.async {
        }
    }
    
}

//extension UpdateGoalParentVC : UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        (collectionView.cellForItem(at: indexPath) as? PageCell)?.isSelected = true
//        self.pageViewController.setViewControllers([self.pages[indexPath.row]], direction: pageViewAnimationDirection(indexPath), animated: true, completion: nil )
//    }
//}

//MARK: -------------------- PageView Datasource Delegate --------------------
extension ExerciseDetailsParentVC : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if viewControllerIndex == 0 {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        return self.pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = self.pages.count
        
        if orderedViewControllersCount == nextIndex {
            return nil
        }
        
        return self.pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    //Delegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let firstViewController = self.pageViewController.viewControllers?.first,
            let index = self.pages.firstIndex(of: firstViewController),
            let _ = self.pages.firstIndex(of: previousViewControllers.first!) {

           self.colTitle.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension ExerciseDetailsParentVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colTitle:
            
            return self.arrTitle.count
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case self.colTitle:
            let cell : EngageTitleCell = collectionView.dequeueReusableCell(withClass: EngageTitleCell.self, for: indexPath)
            let obj                     = self.arrTitle[indexPath.item]
            
            cell.lblTitle.text      = obj["name"].stringValue
            self.exerciseDetailsType = ExerciseDetailsType.init(rawValue: obj["type"].stringValue) ?? .Breathing
            
            cell.vwLine.isHidden = true
            cell.lblTitle.font(name: .regular, size: 17)
                .textColor(color: UIColor.themeGray)
            if self.selectedIndex == indexPath.item {
                cell.vwLine.isHidden = false
                cell.lblTitle.font(name: .semibold, size: 18)
                    .textColor(color: UIColor.themePurple)
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colTitle:
//            let obj = arrTitle[indexPath.item]
//
//            for i in 0...self.arrTitle.count - 1 {
//                var object = self.arrTitle[i]
//                object["is_select"].intValue = 0
//
//                if object["name"].stringValue == obj["name"].stringValue {
//                    object["is_select"].intValue = 1
//                }
//                self.arrTitle[i] = object
//            }
            self.selectedIndex = indexPath.item
            self.colTitle.reloadData()
            
            self.pageViewController.setViewControllers([self.pages[self.selectedIndex]], direction: pageViewAnimationDirection(self.selectedIndex), animated: true, completion: nil )
            break
        
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colTitle:
            //let obj         = self.arrTitle[indexPath.item]
            //let width       = obj["name"].stringValue.width(withConstraintedHeight: 18.0, font: UIFont.customFont(ofType: .semibold, withSize: 18.0))
            let width       = self.colTitle.frame.size.width / 2
            let height      = self.colTitle.frame.size.height
            
            return CGSize(width: width,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
}

extension ExerciseDetailsParentVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //self.manageScroll(scrollView: scrollView)
    }
    
    func manageScroll(scrollView: UIScrollView){
        if self.scrollMain == scrollView{
            let topViewHeight = CGFloat(self.vwTopParent.frame.maxY)
            let scrollOffset = CGFloat(self.scrollMain.contentOffset.y)
            
            if topViewHeight <= scrollOffset{
                UIView.animate(withDuration: 0.5) {
                    scrollView.setContentOffset(CGPoint(x: 0, y: topViewHeight), animated: false)
                }
                
                self.vc1.tblView?.isScrollEnabled = true
                self.vc2.tblView?.isScrollEnabled = true
                
                //                self.vc1.tblList?.scrollToBottom()
                //                self.vc2.tblList?.scrollToBottom()
            }else{
                
                //scrollView.setContentOffset(.zero, animated: true)
                
                self.vc1.tblView?.isScrollEnabled = true
                self.vc2.tblView?.isScrollEnabled = true
//                self.vc1.tblView?.isScrollEnabled = false
//                self.vc2.tblView?.isScrollEnabled = false
            }
        }
    }
}

extension ExerciseDetailsParentVC {
    
    func setData(){
        
        if self.plan_type == "custom" {
            self.stackRestPostSet.isHidden          = false
            self.stackRestPostExercise.isHidden     = false
            
            let time = GFunction.shared.convertDateFormate(dt: self.object.dayDate,
                                                           inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.EEEEddMMMM.rawValue,
                                                           status: .NOCONVERSION)
            
            self.lblDate.text = time.0
        }
        else {
            self.stackRestPostSet.isHidden          = true
            self.stackRestPostExercise.isHidden     = true
            
            self.lblDate.text = self.object.day + ", " + "\(self.object.date!)" + " " + self.object.month//time.0
        }
        
        
        self.lblBreathingCount.text     = "\(self.object.breathingCounts!)" + " " + AppMessages.exercise
        self.lblBreathingDuration.text  = "\(self.object.breathingDuration!)" + " " + self.object.breathingDurationUnit
        
        self.lblExerciseCount.text      = "\(self.object.exerciseCounts!)" + " " + AppMessages.exercise
        self.lblExerciseDuration.text   = "\(self.object.exerciseDuration!)" + " " + self.object.exerciseDurationUnit
        
        //Rest (Post Set) : 30 sec
        self.lblRestPostSet.text        = AppMessages.Rest + " (\(AppMessages.PostSet)) : " + "\(self.object.exerciseRestpostSet!) \(self.object.exerciseRestpostSetUnit!)"
        //Rest (Post Exercise) : 1 min
        self.lblRestPostExercise.text   = AppMessages.Rest + " (\(AppMessages.PostExercise)) : " + "\(self.object.exerciseRestPost!) \(self.object.exerciseRestPostUnit!)"
        
        self.vwRoutine.isHidden = true
        switch self.exerciseDetailsType {
        
        case .Breathing:
            if self.object.breathingDone == "N"{
                self.vwRoutine.isHidden = false
            }
            break
        case .Exercises:
            if self.object.exerciseDone == "N"{
                self.vwRoutine.isHidden = false
            }
            break
        }
    }
}
