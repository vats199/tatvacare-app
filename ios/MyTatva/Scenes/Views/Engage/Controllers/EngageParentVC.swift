//
//  VehicleParentVC.swift
//  SM
//
//  Created by Hyperlink on 06/12/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

enum EngageType: String {
    case Discover   = "Explore"
    case AskExpert   = "Ask an expert"
}

class EngageTitleCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var vwLine           : UIView!
    
    //MARK:- Class Variable
    
    override func awakeFromNib() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwLine.layoutIfNeeded()
            
            self.vwLine.cornerRadius(cornerRadius: self.vwLine.frame.height / 2)
        }
    }
}

class EngageParentVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var vwTopic          : UIView!
    @IBOutlet weak var colTitle         : UICollectionView!
    @IBOutlet weak var vwContainer      : UIView!
    @IBOutlet weak var btnFilter        : UIBarButtonItem!
    
    //MARK:- Class Variable
    var selectedFilterobject_engage     = ContenFilterListModel()
    var selectedFilterobject_askExpert  = ContenFilterListModel()
    var isContinueCoachmark             = false
    
    fileprivate lazy var pageViewController : UIPageViewController = UIPageViewController()
    lazy var pages: [UIViewController] = []
    var selectedIndex : Int     = 0
    var selectedType: EngageType?
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
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
        self.setUpPageViewControllerNColView()
        self.manageActionMethods()
        self.setup(collectionView: self.colTitle)
    }
    
    func setUpPageViewControllerNColView() {
        self.pages.removeAll()
        self.arrTitle.removeAll()
        
        var obj1                    = JSON()
        obj1["name"].stringValue    = EngageType.Discover.rawValue
        obj1["is_select"]           = 1
        obj1["index"]               = 0
        self.arrTitle.append(obj1)
        
        Settings().isHidden(setting: .hide_ask_an_expert_page) { [weak self] isHidden in
            guard let self = self else {return}
            
            if isHidden {
                self.vwTopic.isHidden = true
            }
            else {
                var obj2                    = JSON()
                obj2["name"].stringValue    = EngageType.AskExpert.rawValue
                obj2["is_select"]           = 0
                obj2["index"]               = 0
                self.arrTitle.append(obj2)
            }
        }
        
        //pageView Controller setup
        for item in self.arrTitle {
           
            if item["name"].stringValue == EngageType.Discover.rawValue {
                let vc = DiscoverEngageListVC.instantiate(fromAppStoryboard: .engage)
                vc.isContinueCoachmark = self.isContinueCoachmark
                self.pages.append(vc)
            }
            if item["name"].stringValue == EngageType.AskExpert.rawValue {
                let vc = AskExpertListVC.instantiate(fromAppStoryboard: .engage)
                vc.isContinueCoachmark = self.isContinueCoachmark
                self.pages.append(vc)
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
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){ [weak self] in
            guard let self = self else {return}
            
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
        if let arr = self.pageViewController.viewControllers, arr.count > 0 {
            if let vcMain = arr[0] as? DiscoverEngageListVC {
                let vc = DiscoverEngageFilterVC.instantiate(fromAppStoryboard: .engage)
                vc.offlineobject = self.selectedFilterobject_engage
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .coverVertical
                vc.completionHandler = { [weak self] obj in
                    guard let self = self else {return}
                    
                    if obj != nil {
                        self.selectedFilterobject_engage.topic         = obj!.topic
                        self.selectedFilterobject_engage.contentType   = obj!.contentType
                        self.selectedFilterobject_engage.genre         = obj!.genre
                        
                        self.selectedFilterobject_engage.language      = vcMain.selectedFilterobject.language
                        vcMain.selectedFilterobject             = self.selectedFilterobject_engage
                        
                        if let arr = obj {
                            if let arrTemp = arr.topic {
                                for item in vcMain.viewModel.arrListTopicList {
                                    item.isSelected = false
                                    for child in arrTemp {
                                        if item.topicMasterId == child.topicMasterId {
                                            item.isSelected = true
                                        }
                                    }
                                }
                                vcMain.colTopic.reloadData()
                            }
                        }
                        vcMain.updateAPIData()
                    }
                }
                
                let nav = UINavigationController(rootViewController: vc)
                UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
            }
            else if let vcMain = arr[0] as? AskExpertListVC {
                let vc = AskExpertFilterVC.instantiate(fromAppStoryboard: .engage)
                vc.offlineobject = self.selectedFilterobject_askExpert
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .coverVertical
                vc.completionHandler = { [weak self] obj in
                    guard let self = self else {return}
                    
                    if obj != nil {
                        self.selectedFilterobject_askExpert.topic           = obj!.topic
                        self.selectedFilterobject_askExpert.contentType     = obj!.contentType
                        self.selectedFilterobject_askExpert.genre           = obj!.genre
                        self.selectedFilterobject_askExpert.questionType    = obj!.questionType
                        
                        self.selectedFilterobject_engage.language           = vcMain.selectedFilterobject.language
                        vcMain.selectedFilterobject                         = self.selectedFilterobject_askExpert
                        
                        if let arr = obj {
                            if let arrTemp = arr.topic {
                                for item in vcMain.viewModel.arrListTopicList {
                                    item.isSelected = false
                                    for child in arrTemp {
                                        if item.topicMasterId == child.topicMasterId {
                                            item.isSelected = true
                                        }
                                    }
                                }
                                vcMain.colTopic.reloadData()
                            }
                        }
                        vcMain.updateAPIData()
                    }
                }
                
                let nav = UINavigationController(rootViewController: vc)
                UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
            }
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
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
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

//MARK: -------------------- PageView Datasource Delegate --------------------
extension EngageParentVC : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
extension EngageParentVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
            
            if indexPath.item == self.selectedIndex {
                cell.vwLine.isHidden = false
                cell.lblTitle.font(name: .semibold, size: 18)
                    .textColor(color: UIColor.themePurple)
            }
            
//            if obj["is_select"].intValue == 1 {
//                cell.vwLine.isHidden = false
//                cell.lblTitle.font(name: .semibold, size: 18)
//                    .textColor(color: UIColor.themePurple)
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
            let width       = self.colTitle.frame.size.width / 2
//            let width       = self.colTitle.frame.size.width
            let height      = self.colTitle.frame.size.height
            
            return CGSize(width: width,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
    func manageSelection(index: Int){
        self.selectedIndex = index
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
        
        func updateSelection(){
            self.colTitle.reloadData()
            self.pageViewController.setViewControllers([self.pages[self.selectedIndex]], direction: pageViewAnimationDirection(self.selectedIndex), animated: true, completion: nil )
        }
        
        if self.arrTitle[self.selectedIndex]["name"].stringValue == EngageType.AskExpert.rawValue {
            PlanManager.shared.isAllowedByPlan(type: .ask_an_expert,
                                               sub_features_id: "",
                                               completion: { [weak self] isAllow in
                guard let _ = self else {return}
                
                if isAllow{
                    updateSelection()
                }
                else {
                    Alert.shared.showAlert(message: AppMessages.SubscribeToContinue) { [weak self] isDone in
                        guard let _ = self else {return}
                        if isDone {
                        }
                    }
                    return
                }
            })
        }
        else {
            updateSelection()
        }
    }
    
    func manageSelection(type: EngageType){
        for i in 0...self.arrTitle.count - 1 {
            if self.arrTitle[i]["name"].stringValue == type.rawValue {
                self.selectedIndex = i
            }
        }
        
        self.manageSelection(index: self.selectedIndex)
    }
    
}
