//
//  VehicleParentVC.swift
//  SM
//
//  Created by on 06/12/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class UpdateReadingParentVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var vwContainer      : UIView!
    @IBOutlet weak var btnNext          : UIButton!
    @IBOutlet weak var btnPrevious      : UIButton!
    
    //MARK:- Class Variable
    
    fileprivate lazy var pageViewController : UIPageViewController = UIPageViewController()
    fileprivate lazy var pages: [UIViewController] = []
    var selectedIndex : Int     = 0
    var arrList                 = [ReadingListModel]()
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
    
    fileprivate func setUpView() {
        self.setUpPageViewControllerNColView()
        self.manageActionMethods()
        //self.setupHero()
    }
    
    private func setupHero(){
        self.hero.isEnabled = false
        
        if let obj = self.getCurrentPageViewController(),
           let vc = obj.0{
            
            if let vc2 = vc as? UpdateCommonReadingPopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(x:100)]
            }
            else if let vc2 = vc as? UpdateBpReadingPopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(x:100)]
            }
            else if let vc2 = vc as? UpdateBloodGlucoseReadingPopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(x:100)]
            }
            else if let vc2 = vc as? UpdateBMIReadingPopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(x:100)]
            }
            else if let vc2 = vc as? UpdateWalkDistancePopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(x:100)]
            }
            else if let vc2 = vc as? UpdateFibroScanReadingPopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(x:100)]
            }
            else if let vc2 = vc as? UpdateFib4ScoreReadingPopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(x:100)]
            }
            else if let vc2 = vc as? UpdateTotalCholesterolReadingPopupVC{
                vc2.vwBg.hero.id            = self.arrList[self.selectedIndex].keys
                vc2.vwBg.hero.modifiers     = [.translate(x:100)]
            }
        }
//        self.pageViewController.hero.id           = "cell"
//        self.pageViewController.hero.modifiers    = [.translate(y:100)]
    }
    
    fileprivate func setUpPageViewControllerNColView() {
        self.pages.removeAll()
        
        for item in self.arrList{
            let type = ReadingType.init(rawValue: item.keys) ?? .BMI

            switch type {

            case .SPO2:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .SPO2
                vc.readingListModel     = item
                self.pages.append(vc)
                break
                
            case .PEF:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .PEF
                vc.readingListModel     = item
                self.pages.append(vc)
                break
                
            case .BloodPressure:
                let vc = UpdateBpReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .SPO2
                vc.readingListModel     = item
                self.pages.append(vc)
                break
                
            case .HeartRate:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .HeartRate
                vc.readingListModel     = item
                self.pages.append(vc)
                break
                
            case .BodyWeight:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .BodyWeight
                vc.readingListModel     = item
                self.pages.append(vc)
                break
                
            case .BMI:
                let vc = UpdateBMIReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .BMI
                vc.readingListModel     = item
                self.pages.append(vc)
                break
                
            case .BloodGlucose:
                let vc = UpdateBloodGlucoseReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .BloodGlucose
                vc.readingListModel     = item
                self.pages.append(vc)
                break
                
            case .HbA1c:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .HbA1c
                vc.readingListModel     = item
                self.pages.append(vc)
                break
                
            case .ACR:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .ACR
                vc.readingListModel     = item
                self.pages.append(vc)
                break
                
            case .eGFR:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .eGFR
                vc.readingListModel     = item
                self.pages.append(vc)
                break
                
            case .FEV1Lung:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .FEV1Lung
                vc.readingListModel     = item
                self.pages.append(vc)
                break
                
            case .cat:
                //cat pending
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .FEV1Lung
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .six_min_walk:
                let vc = UpdateWalkDistancePopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .six_min_walk
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .fibro_scan:
                let vc = UpdateFibroScanReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .fibro_scan
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .fib4:
                let vc = UpdateFib4ScoreReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .fib4
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .sgot:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .sgot
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .sgpt:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .sgpt
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .triglycerides:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .triglycerides
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .total_cholesterol:
                let vc = UpdateTotalCholesterolReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .total_cholesterol
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .ldl_cholesterol:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .ldl_cholesterol
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .hdl_cholesterol:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .hdl_cholesterol
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .waist_circumference:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .waist_circumference
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .platelet:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .platelet
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .serum_creatinine:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .serum_creatinine
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .fatty_liver_ugs_grade:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .fatty_liver_ugs_grade
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .random_blood_glucose:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = .random_blood_glucose
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            case .BodyFat,.Hydration,.MuscleMass,.Protein,.BoneMass,.VisceralFat,.BaselMetabolicRate,.MetabolicAge,.SubcutaneousFat,.SkeletalMuscle:
                let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                vc.readingType          = type
                vc.readingListModel     = item
                self.pages.append(vc)
                break
            
            case .fev1_fvc_ratio,.fvc,.aqi,.humidity,.temperature:
                break
                
            }
        }
        
/*
 Static entry
         
         //pageView Controller setup
         for i in 0...self.arrList.count - 1 {
             switch i {
             case 0:
                 let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                 vc.readingType = .SPO2
                 //vc.readingListModel                = item
                 self.pages.append(vc)
                 break
             case 1:
                 let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                 vc.readingType = .FEV1Lung
                 self.pages.append(vc)
                 break
             case 2:
                 let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                 vc.readingType = .PEF
                 self.pages.append(vc)
                 break
             case 3:
                 let vc = UpdateBpReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                 self.pages.append(vc)
                 break
             case 4:
                 let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                 vc.readingType = .HeartRate
                 self.pages.append(vc)
                 break
             case 5:
                 let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                 vc.readingType = .BodyWeight
                 self.pages.append(vc)
                 break
             case 6:
                 let vc = UpdateBMIReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                 
                 self.pages.append(vc)
                 break
             case 7:
                 let vc = UpdateBloodGlucoseReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                 
                 self.pages.append(vc)
                 break
             case 8:
                 let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                 vc.readingType = .HbA1c
                 self.pages.append(vc)
                 break
             case 9:
                 let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                 vc.readingType = .ACR
                 self.pages.append(vc)
                 break
             case 10:
                 let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                 vc.readingType = .eGFR
                 self.pages.append(vc)
                 break
             default:
                 let vc = UpdateCommonReadingPopupVC.instantiate(fromAppStoryboard: .goal)
                 vc.readingType = .eGFR
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
    
    fileprivate func pageViewAnimationDirection(_ indexPathRow : Int) -> UIPageViewController.NavigationDirection {
        
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
    
    fileprivate func collectionAnimationDirection(_ previousIndex : Int) -> UICollectionView.ScrollPosition {
        
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
    
    fileprivate func getCurrentPageViewController() -> (UIViewController? , Int?)? {
        
        if let firstVC = self.pageViewController.viewControllers?.first,
        let index = self.pages.firstIndex(of: firstVC) {
            
            return(firstVC,index)
        } else {
            return(nil,nil)
        }
    }
    
    fileprivate func goNext(){
        if self.selectedIndex < self.arrList.count - 1 {
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
    
    fileprivate func goPrevious(){
        if self.selectedIndex > 0 {
            //Allow to go previous
            self.selectedIndex -= 1
            self.pageViewController.setViewControllers([self.pages[self.selectedIndex]], direction: self.pageViewAnimationDirection(self.selectedIndex), animated: true, completion: nil )
        }
    }
    
    //MARK: -------------------- Action Method --------------------
    fileprivate func manageActionMethods() {
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
extension UpdateReadingParentVC {
    
    fileprivate func manageNextPrevoius(sender: UIButton){
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
extension UpdateReadingParentVC : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
        
//        if let firstViewController = self.pageViewController.viewControllers?.first,
//            let index = self.pages.firstIndex(of: firstViewController),
//            let _ = self.pages.firstIndex(of: previousViewControllers.first!) {
//           self.colPages.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
//        }
    }
}

