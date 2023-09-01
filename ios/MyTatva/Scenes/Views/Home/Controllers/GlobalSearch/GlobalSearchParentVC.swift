

//  Copyright © 2022 Hyperlink. All rights reserved.
//

import UIKit

enum GlobalSearchType: String, CaseIterable {
    case Discover       = "Discover"
    case AskExpert      = "Ask an expert"
    case MyRoutine      = "My Routine"
    case Explore        = "Explore"
    case Payments       = "Payments"
    case Incident       = "Incident"
    case Records        = "Records"
    case Appointments   = "Appointments"
    case Tests          = "Tests"
}

let kPostSearchData = NSNotification.Name(rawValue: "kPostSearchData")

//Engage, ask an expert, Exercise my routine, Exercise explore, history (tab wise), Care plan (records).
class GlobalSearchParentVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var txtSearch        : UITextField!
    @IBOutlet weak var colTitle         : UICollectionView!
    @IBOutlet weak var vwContainer      : UIView!
    @IBOutlet weak var btnFilter        : UIBarButtonItem!
    
    //MARK:- Class Variable
    
    fileprivate lazy var pageViewController : UIPageViewController = UIPageViewController()
    fileprivate lazy var pages: [UIViewController] = []
    var selectedIndex : Int     = 0
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    var arrTitle                    = [JSON]()
    var selectedType: GlobalSearchType?
    var timerSearch                 = Timer()
    var strSearch                   = ""
    private var isSearchOn : Bool   = false
    
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
        
        self.txtSearch.delegate = self
        
        self.setUpPageViewControllerNColView()
        self.manageActionMethods()
        self.setup(collectionView: self.colTitle)
    }
    
    func setUpPageViewControllerNColView() {
        self.pages.removeAll()
        self.arrTitle.removeAll()
        
//        let data                = UserModel.shared
        var isAllowParent       = false
        
        for value in GlobalSearchType.allCases {
            switch value {
                
            case .Discover:
                isAllowParent = true
                Settings().isHidden(setting: .hide_engage_page) { isHidden in
                    if isHidden {
                    }
                    else {
                        var obj                     = JSON()
                        obj["name"].stringValue     = GlobalSearchType.Discover.rawValue
                        obj["type"].stringValue     = GlobalSearchType.Discover.rawValue
                        obj["is_select"]            = 1
                        obj["index"]                = 0
                        self.arrTitle.append(obj)
                    }
                }
                break
            case .AskExpert:
                isAllowParent = true
                Settings().isHidden(setting: .hide_engage_page) { isHidden in
                    if !isHidden {
                        Settings().isHidden(setting: .hide_ask_an_expert_page) { isHidden in
                            if isHidden {
                            }
                            else {
                                var obj                     = JSON()
                                obj["name"].stringValue     = GlobalSearchType.AskExpert.rawValue
                                obj["type"].stringValue     = GlobalSearchType.AskExpert.rawValue
                                obj["is_select"]            = 0
                                obj["index"]                = 0
                                self.arrTitle.append(obj)
                            }
                        }
                    }
                }
                break
            case .MyRoutine:
//                if !data.medicalConditionName[0].medicalConditionName.lowercased()
//                    .contains(kNASH.lowercased()) &&
//                    !data.medicalConditionName[0].medicalConditionName.lowercased()
//                    .contains(kNAFL.lowercased()){
//
//                    isAllowParent           = true
//                    var obj                 = JSON()
//                    obj["name"].stringValue = GlobalSearchType.MyRoutine.rawValue
//                    obj["type"].stringValue = GlobalSearchType.MyRoutine.rawValue
//                    obj["is_select"]        = 1
//                    self.arrTitle.append(obj)
//                }
                
                isAllowParent           = true
                var obj                 = JSON()
                obj["name"].stringValue = GlobalSearchType.MyRoutine.rawValue
                obj["type"].stringValue = GlobalSearchType.MyRoutine.rawValue
                obj["is_select"]        = 1
                self.arrTitle.append(obj)
                
                break
            case .Explore:
                isAllowParent               = true
                var obj                     = JSON()
                obj["name"].stringValue     = GlobalSearchType.Explore.rawValue
                obj["type"].stringValue     = GlobalSearchType.Explore.rawValue
                obj["is_select"]            = 0
                self.arrTitle.append(obj)
                break
            case .Payments:
//                PlanManager.shared.isAllowedByPlan(type: .history_payments,
//                                                   sub_features_id: "",
//                                                   completion: { isAllow in
//                    if isAllow {
//                        isAllowParent           = true
//                        var obj                 = JSON()
//                        obj["name"].stringValue = GlobalSearchType.Payments.rawValue
//                        obj["type"].stringValue = GlobalSearchType.Payments.rawValue
//                        obj["is_select"]        = 1
//                        obj["index"]            = 0
//                        self.arrTitle.append(obj)
//                    }
//                })
                break
            case .Incident:
                
//                if !data.medicalConditionName[0].medicalConditionName.lowercased()
//                    .contains(kNASH.lowercased()) &&
//                    !data.medicalConditionName[0].medicalConditionName.lowercased()
//                    .contains(kNAFL.lowercased()){
//
//                    PlanManager.shared.isAllowedByPlan(type: .incident_records_history,
//                                                       sub_features_id: "",
//                                                       completion: { isAllow in
//                        if isAllow {
//                            isAllowParent           = true
//                            var obj                 = JSON()
//                            obj["name"].stringValue = GlobalSearchType.Incident.rawValue
//                            obj["type"].stringValue = GlobalSearchType.Incident.rawValue
//                            obj["is_select"]        = 0
//                            obj["index"]            = 2
//                            self.arrTitle.append(obj)
//                        }
//                    })
//                }
                break
            case .Records:
                PlanManager.shared.isAllowedByPlan(type: .add_records_history_records,
                                                   sub_features_id: "",
                                                   completion: { isAllow in
                    if isAllow{
                        isAllowParent               = true
                        var obj                     = JSON()
                        obj["name"].stringValue     = GlobalSearchType.Records.rawValue
                        obj["type"].stringValue     = GlobalSearchType.Records.rawValue
                        obj["is_select"]            = 0
                        obj["index"]                = 3
                        self.arrTitle.append(obj)
                    }
                })
                break
            case .Appointments:
                //if UserModel.shared.patientGuid.trim() != "" {
//                    isAllowParent               = true
//                    var obj                     = JSON()
//                    obj["name"].stringValue     = GlobalSearchType.Appointments.rawValue
//                    obj["type"].stringValue     = GlobalSearchType.Appointments.rawValue
//                    obj["is_select"]            = 1
//                    obj["index"]                = 1
//                    self.arrTitle.append(obj)
                //}
                break
            case .Tests:
                isAllowParent                   = true
                Settings().isHidden(setting: .hide_diagnostic_test) { isHidden in
                    if !isHidden {
                        var obj                         = JSON()
                        obj["name"].stringValue         = GlobalSearchType.Tests.rawValue
                        obj["type"].stringValue         = GlobalSearchType.Tests.rawValue
                        obj["is_select"]                = 0
                        obj["index"]                    = 4
                        self.arrTitle.append(obj)
                    }
                }
                break
            }
        }
        
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
            let type = GlobalSearchType.init(rawValue: item["name"].stringValue) ?? .Discover
            
            switch type {
                
            case .Discover:
                let vc = DiscoverEngageListVC.instantiate(fromAppStoryboard: .engage)
                vc.isGloabalSearch      = true
                //vc.isContinueCoachmark = self.isContinueCoachmark
                self.pages.append(vc)
                break
                
            case .AskExpert:
                let vc = AskExpertListVC.instantiate(fromAppStoryboard: .engage)
                vc.isGloabalSearch      = true
                //vc.isContinueCoachmark = self.isContinueCoachmark
                self.pages.append(vc)
                break
                
            case .MyRoutine:
                let vc = ExerciseMyPlanVC.instantiate(fromAppStoryboard: .exercise)
                vc.isGloabalSearch      = true
                //vc.isContinueCoachmark = self.isContinueCoachmark
                self.pages.append(vc)
                break
                
            case .Explore:
                let vc = ExerciseMoreVC.instantiate(fromAppStoryboard: .exercise)
                vc.isGloabalSearch      = true
                //vc.isContinueCoachmark = self.isContinueCoachmark
                self.pages.append(vc)
                break
                
            case .Payments:
                let vc = PaymentHistoryListVC.instantiate(fromAppStoryboard: .setting)
                vc.isGloabalSearch      = true
                self.pages.append(vc)
                break
                
            case .Incident:
                let vc = IncidentHistoryListVC.instantiate(fromAppStoryboard: .setting)
                vc.isGloabalSearch      = true
                self.pages.append(vc)
                break
                
            case .Records:
                let vc = RecordsVC.instantiate(fromAppStoryboard: .setting)
                vc.isGloabalSearch      = true
                self.pages.append(vc)
                break
                
            case .Appointments:
                let vc = AppointmentsHistoryVC.instantiate(fromAppStoryboard: .setting)
                vc.isGloabalSearch      = true
                self.pages.append(vc)
                break
                
            case .Tests:
                let vc = BookTestHistoryVC.instantiate(fromAppStoryboard: .setting)
                vc.isGloabalSearch      = true
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
            self.pageViewController.setViewControllers([self.pages[self.selectedIndex]], direction: self.pageViewAnimationDirection(self.selectedIndex), animated: true, completion: nil)
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
        let vc = DiscoverEngageFilterVC.instantiate(fromAppStoryboard: .engage)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        let nav = UINavigationController(rootViewController: vc)
        UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
    }
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.txtSearch.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if let tabbar = self.parent?.parent as? TabbarVC {
//            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
//        }
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
extension GlobalSearchParentVC : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
extension GlobalSearchParentVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
            cell.lblTitle.font(name: .regular, size: 15)
                .textColor(color: UIColor.themeGray)
            if indexPath.item == self.selectedIndex {//if obj["is_select"].intValue == 1 {
                cell.vwLine.isHidden = false
                cell.lblTitle.font(name: .bold, size: 17)
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
            self.selectedIndex = indexPath.row
            self.colTitle.reloadData()
            
            self.pageViewController.setViewControllers([self.pages[self.selectedIndex]], direction: pageViewAnimationDirection(self.selectedIndex), animated: true, completion: nil )
            
            self.colTitle.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            if let obj = self.getCurrentPageViewController(),
               let vc = obj.0{
                
                if let vc2 = vc as? DiscoverEngageListVC{
                    vc2.strSearch = self.strSearch
                }
                else if let vc2 = vc as? AskExpertListVC{
                    vc2.strSearch = self.strSearch
                }
                if let vc2 = vc as? ExerciseMyPlanVC{
                    vc2.strSearch = self.strSearch
                }
                if let vc2 = vc as? ExerciseMoreVC{
                    vc2.strSearch = self.strSearch
                }
                if let vc2 = vc as? PaymentHistoryListVC{
                    vc2.strSearch = self.strSearch
                }
                if let vc2 = vc as? IncidentHistoryListVC{
                    vc2.strSearch = self.strSearch
                }
                if let vc2 = vc as? RecordsVC{
                    vc2.strSearch = self.strSearch
                }
                if let vc2 = vc as? AppointmentsHistoryVC{
                    vc2.strSearch = self.strSearch
                }
                if let vc2 = vc as? BookTestHistoryVC{
                    vc2.strSearch = self.strSearch
                }
            }
            
            break
        
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colTitle:
            let obj         = self.arrTitle[indexPath.item]
            let width       = obj["name"].stringValue.width(withConstraintedHeight: 18.0, font: UIFont.customFont(ofType: .semibold, withSize: 18.0))
            //let width       = self.colTitle.frame.size.width / 2
            let height      = self.colTitle.frame.size.height
            
            return CGSize(width: width + 20,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
}

//MARK: -------------------- UITextField Delegate --------------------
extension GlobalSearchParentVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        self.isSearchOn = true
   
        self.timerSearch.invalidate()
        self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
         
            self.strSearch              = newText
            let dict:[String: String]   = ["search": newText]
            NotificationCenter.default.post(name: kPostSearchData, object: nil, userInfo: dict)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.txtSearch:
            self.isSearchOn = false
           // self.tblView.reloadData()
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtSearch:
            self.txtSearch.resignFirstResponder()
            self.isSearchOn = false
            //self.tblView.reloadData()
            
            break
        default:
            break
        }
        
        return true
    }
}
