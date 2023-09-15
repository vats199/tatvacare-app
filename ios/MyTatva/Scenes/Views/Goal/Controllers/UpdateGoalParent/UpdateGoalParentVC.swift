//
//  VehicleParentVC.swift
//  SM
//
//  Created by on 06/12/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit



class UpdateGoalParentVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var vwContainer      : UIView!
    @IBOutlet weak var btnNext          : UIButton!
    @IBOutlet weak var btnPrevious      : UIButton!
    
    //MARK:- Class Variable
    
    fileprivate lazy var pageViewController : UIPageViewController = UIPageViewController()
    fileprivate lazy var pages: [UIViewController] = []
    var selectedIndex : Int     = 0
    var arrList                 = [GoalListModel]()
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
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
        //self.setupHero()
    }
    
    private func setupHero(){
        self.hero.isEnabled                       = false
        
        if let obj = self.getCurrentPageViewController(),
           let vc = obj.0{
            
            if let vc2 = vc as? UpdateMedicationPopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(y:100)]
            }
            else if let vc2 = vc as? UpdateStepsPopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(y:100)]
            }
            else if let vc2 = vc as? UpdateExercisePopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(y:100)]
            }
            else if let vc2 = vc as? UpdatePranayamPopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(y:100)]
            }
            else if let vc2 = vc as? UpdateSleepPopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(y:100)]
            }
            else if let vc2 = vc as? UpdateWaterPopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(y:100)]
            }
        }
    }
    
    func setUpPageViewControllerNColView() {
        self.pages.removeAll()
        
        //pageView Controller setup
        for index in 0...self.arrList.count - 1 {
            let item = self.arrList[index]
            let type = GoalType.init(rawValue: item.keys) ?? .Exercise
            
            switch type {
           
            case .Medication:
                let vc = UpdateMedicationPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.goalListModel    = item
                self.pages.append(vc)
                break
            case .Calories:
                break
            case .Steps:
                let vc = UpdateStepsPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.goalListModel    = item
                vc.myIndex          = index
                vc.arrList          = arrList
                
                self.pages.append(vc)
                break
            case .Exercise:
                let vc = UpdateExercisePopupVC.instantiate(fromAppStoryboard: .goal)
                vc.goalListModel    = item
                vc.myIndex          = index
                vc.arrList          = arrList
                self.pages.append(vc)
                break
            case .Pranayam:
                let vc = UpdatePranayamPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.goalListModel    = item
                vc.myIndex          = index
                vc.arrList          = arrList
                self.pages.append(vc)
                break
            case .Sleep:
                let vc = UpdateSleepPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.goalListModel    = item
                vc.myIndex          = index
                vc.arrList          = arrList
                self.pages.append(vc)
                break
            case .Water:
                let vc = UpdateWaterPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.goalListModel    = item
                vc.myIndex          = index
                vc.arrList          = arrList
                self.pages.append(vc)
                break
                
            case .Diet:
                let vc = UpdateWaterPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.goalListModel    = item
                vc.myIndex          = index
                vc.arrList          = arrList
                self.pages.append(vc)
                break
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
        if self.selectedIndex < self.arrList.count - 1 {
            //Allow to go next
            
            self.selectedIndex += 1
            let object = self.arrList[self.selectedIndex]
            let type = GoalType.init(rawValue: object.keys) ?? .Diet
            
            if type == .Diet {
                if let completionHandler = self.completionHandler {
                    let obj = JSON()
                    completionHandler(obj)
                }
                self.dismiss(animated: true, completion: nil)
            }
            else {
                self.pageViewController.setViewControllers([self.pages[self.selectedIndex]], direction: self.pageViewAnimationDirection(self.selectedIndex), animated: true, completion: nil )
            }
        }
        else {
            
            if let completionHandler = self.completionHandler {
                var obj         = JSON()
                obj["isDone"]   = true
                completionHandler(obj)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func goPrevious(){
        if self.selectedIndex > 0 {
            //Allow to go previous
            
            self.selectedIndex -= 1
            let object = self.arrList[self.selectedIndex]
            let type = GoalType.init(rawValue: object.keys) ?? .Diet
            
            if type == .Diet {
                if let completionHandler = self.completionHandler {
                    let obj = JSON()
                    completionHandler(obj)
                }
                self.dismiss(animated: true, completion: nil)
            }
            else {
                self.pageViewController.setViewControllers([self.pages[self.selectedIndex]], direction: self.pageViewAnimationDirection(self.selectedIndex), animated: true, completion: nil )
            }
        }
    }
    
    //MARK: -------------------- Action Method --------------------
    func manageActionMethods() {
        self.btnNext.addTapGestureRecognizer {
            self.goNext()
        }
        
        self.btnPrevious.addTapGestureRecognizer {
            self.goPrevious()
        }
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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

//MARK: -------------------- Manage next/ previous --------------------
extension UpdateGoalParentVC {
    
    func manageNextPrevoius(sender: UIButton){
        switch sender {
        case self.btnNext:
            break
            
        case self.btnPrevious:
            break
            
        default:break
        }
    }
}
//MARK: -------------------- PageView Datasource Delegate --------------------
extension UpdateGoalParentVC : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
//
//           self.colPages.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
//
        }
    }
}

