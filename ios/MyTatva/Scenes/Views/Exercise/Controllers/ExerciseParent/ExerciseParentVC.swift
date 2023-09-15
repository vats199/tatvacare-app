//
//  VehicleParentVC.swift
//  SM
//
//  Created by Hyperlink on 06/12/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

enum ExerciseParentType: String, CaseIterable {
    case MyRoutine      = "My Routine"
    case Explore        = "Others"//"Explore"
}

class ExerciseParentVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var vwTop            : UIView!
    @IBOutlet weak var colTitle         : UICollectionView!
    @IBOutlet weak var vwContainer      : UIView!
    @IBOutlet weak var btnFilter        : UIButton!
    
    //MARK:- Class Variable
    var arrOfflineobject                = [ExerciseFilterModel]()
    
    var pageViewController : UIPageViewController = UIPageViewController()
    var pages: [UIViewController] = []
    var selectedIndex : Int     = 0
    var completionHandler: ((_ obj : JSON?) -> Void)?
    var isContinueCoachmark             = false
    
    var arrTitle = [JSON]()
    var selectedType: ExerciseParentType?
    
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
        self.setUpPageViewControllerNColView()
        self.manageActionMethods()
        self.setup(collectionView: self.colTitle)
    }
    
    func setUpPageViewControllerNColView() {
        self.pages.removeAll()
        self.arrTitle.removeAll()

        self.vwTop.isHidden = true
        
        let data                = UserModel.shared
//        if !data.medicalConditionName[0].medicalConditionName.lowercased()
//            .contains(kNASH.lowercased()) &&
//            !data.medicalConditionName[0].medicalConditionName.lowercased()
//            .contains(kNAFL.lowercased()){
//
//            var obj1                    = JSON()
//            obj1["name"].stringValue    = ExerciseParentType.MyRoutine.rawValue
//            obj1["is_select"]           = 1
//            self.arrTitle.append(obj1)
//            self.vwTop.isHidden = false
//
//        }
        
        for value in ExerciseParentType.allCases {
            switch value {
            case .MyRoutine:
                var obj                    = JSON()
                obj["name"].stringValue    = ExerciseParentType.MyRoutine.rawValue
                obj["is_select"]           = 1
                self.arrTitle.append(obj)
                self.vwTop.isHidden = false
                break
            
            case .Explore:
                var obj                    = JSON()
                obj["name"].stringValue    = ExerciseParentType.Explore.rawValue
                obj["is_select"]           = 0
                self.arrTitle.append(obj)
                break
            }
        }
        
        //pageView Controller setup
        for item in self.arrTitle {
            let type = ExerciseParentType.init(rawValue: item["name"].stringValue) ?? .MyRoutine
            
            switch type {
            case .MyRoutine:
                
                let vc = ExerciseMyPlanRoutineParentVC.instantiate(fromAppStoryboard: .exercise)
                vc.isContinueCoachmark = self.isContinueCoachmark
                /*let vc = ExerciseMyPlanVC.instantiate(fromAppStoryboard: .exercise)
                vc.isContinueCoachmark = self.isContinueCoachmark*/
                self.pages.append(vc)
                break
                
            case .Explore:
                let vc = ExerciseMoreVC.instantiate(fromAppStoryboard: .exercise)
                vc.isContinueCoachmark = self.isContinueCoachmark
                self.pages.append(vc)
                break
            }
        }
        
        self.colTitle.reloadData()
        
        
        if let type = self.selectedType {
            for i in 0...self.arrTitle.count - 1 {
                if self.arrTitle[i]["name"].stringValue == type.rawValue {
                    self.selectedIndex = i
                    self.colTitle.scrollToItem(at: IndexPath(item: self.selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
                }
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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            self.colTitle.scrollToItem(at: IndexPath(item: self.selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
            self.colTitle.reloadData()
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
        
    }
    
    @IBAction func btnFilterTapped(sender: UIButton){
        let vc = ExerciseFilterVC.instantiate(fromAppStoryboard: .exercise)
        vc.arrOfflineobject = self.arrOfflineobject
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.completionHandler = { obj in
            if obj != nil {
                self.arrOfflineobject = obj!
                if let vc = self.pages.last as? ExerciseMoreVC {
                    vc.arrSelectedFilterObject = self.arrOfflineobject
                    vc.updateAPIData()
                }
            }
        }

        let nav = UINavigationController(rootViewController: vc)
        UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
    }
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.navigationBar.barStyle = .default
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
extension ExerciseParentVC : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
extension ExerciseParentVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
            
            cell.vwLine.isHidden = true
            cell.lblTitle.font(name: .regular, size: 17)
                .textColor(color: UIColor.themeGray)
            self.btnFilter.isHidden = true
            
            if indexPath.item == self.selectedIndex {
                cell.vwLine.isHidden = false
                cell.lblTitle.font(name: .semibold, size: 18)
                    .textColor(color: UIColor.themePurple)
                
                if obj["name"].stringValue == ExerciseParentType.Explore.rawValue {
                    self.btnFilter.isHidden = false
                }
            }
            
//            if obj["is_select"].intValue == 1 {
//                cell.vwLine.isHidden = false
//                cell.lblTitle.font(name: .semibold, size: 18)
//                    .textColor(color: UIColor.themePurple)
//
//                if obj["name"].stringValue == "More" {
//                    self.btnFilter.isHidden = false
//                }
//            }
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colTitle:
            self.manageSelection(index: indexPath.item)
            break
        
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colTitle:
            //let obj         = self.arrTitle[indexPath.item]
            //let width       = obj["name"].stringValue.width(withConstraintedHeight: 18.0, font: UIFont.customFont(ofType: .semibold, withSize: 18.0))
            
            var width       = self.colTitle.frame.size.width
            if self.arrTitle.count > 1 {
                width       = self.colTitle.frame.size.width / 2
            }
            
            let height      = self.colTitle.frame.size.height
            
            return CGSize(width: width,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
    func manageSelection(index: Int){
        self.selectedIndex = index
        
//        let obj = arrTitle[index]
//        if obj["name"].stringValue == ExerciseParentType.MyRoutine.rawValue {
//            let params: [String: Any] = [:]
//            FIRAnalytics.FIRLogEvent(eventName: .USER_TAPS_ON_ROUTINE,
//                                     screen: .ExercisePlan,
//                                     parameter: params)
//        }
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
        
        self.colTitle.reloadData()
        
        self.pageViewController.setViewControllers([self.pages[self.selectedIndex]], direction: pageViewAnimationDirection(self.selectedIndex), animated: true, completion: nil )
    }
    
    func manageSelection(type: ExerciseParentType){
        for i in 0...self.arrTitle.count - 1 {
            if self.arrTitle[i]["name"].stringValue == type.rawValue {
                self.selectedIndex = i
            }
        }
        
        self.colTitle.reloadData()
        self.pageViewController.setViewControllers([self.pages[self.selectedIndex]], direction: pageViewAnimationDirection(self.selectedIndex), animated: true, completion: nil )
    }
}
