//

//

import UIKit
import Alamofire

class LabTestListVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var vwSearch             : UIView!
    @IBOutlet weak var txtSearch            : UITextField!
    
    @IBOutlet weak var colBookTest1         : UICollectionView!
    @IBOutlet weak var colBookTest2         : UICollectionView!
    
    @IBOutlet weak var colBookTest1Height   : NSLayoutConstraint!
    @IBOutlet weak var colBookTest2Height   : NSLayoutConstraint!
    
    @IBOutlet weak var lblPopularTest       : UILabel!
    @IBOutlet weak var lblPopularPkg        : UILabel!
    
    @IBOutlet weak var btnViewAllTest       : UIButton!
    @IBOutlet weak var btnViewAllPkg        : UIButton!
    
    @IBOutlet weak var vwEasyBookParent     : UIView!
    @IBOutlet weak var vwEasyBook           : UIView!
    @IBOutlet weak var lblEasyBook          : UILabel!
    @IBOutlet weak var lblEasyBookCall      : UILabel!
    
    @IBOutlet weak var btnCart              : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                           = LabTestListVM()
    var isEdit                              = false
    let refreshControl                      = UIRefreshControl()
    var strErrorTestMessage : String        = ""
    var strErrorPkgMessage : String         = ""
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    //var arrGoal = [GoalListModel]()
//    var arrGoal : [JSON] = [
//        [
//            "img" : "goals_calories",
//            "name" : "Calories",
//            "desc" : "2500  calories per day",
//            "type": GoalType.Calories.rawValue,
//            "isSelected": 0,
//        ],
//        [
//            "img" : "goals_steps",
//            "name" : "Steps",
//            "desc" : "2500 steps per day",
//            "type": GoalType.Steps.rawValue,
//            "isSelected": 0,
//        ],
//        [
//            "img" : "goals_exercise",
//            "name" : "Exercise",
//            "desc" : "30 minutes per day",
//            "type": GoalType.Exercise.rawValue,
//            "isSelected": 0,
//        ]
//    ]
    
    //var arrReading : [ReadingListModel] = []
//        [
//            [
//                "img" : "reading_lung",
//                "name" : "Lung Function",
//                "desc" : "2500  calories per day",
//                "type": ReadingType.Lung.rawValue,
//                "isSelected": 0,
//            ],
//            [
//                "img" : "reading_pulseOxy",
//                "name" : "Pulse Oxygen",
//                "desc" : "2500 steps per day",
//                "type": ReadingType.PulseOxygen.rawValue,
//                "isSelected": 0,
//            ],
//            [
//                "img" : "reading_bp",
//                "name" : "Blood Pressure",
//                "desc" : "30 minutes per day",
//                "type": ReadingType.BloodPressure.rawValue,
//                "isSelected": 0,
//            ]
//        ]
    
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        self.addObserverOnHeightTbl()
        self.configureUI()
        self.manageActionMethods()
        self.applyStyle()
    }
    
    private func applyStyle() {
        
        self.txtSearch.isUserInteractionEnabled = false
        self.txtSearch
            .font(name: .medium, size: 15).textColor(color: .themeBlack.withAlphaComponent(1))
        
        self.lblPopularTest
            .font(name: .semibold, size: 18).textColor(color: .themeBlack.withAlphaComponent(1))
        self.lblPopularPkg
            .font(name: .semibold, size: 18).textColor(color: .themeBlack.withAlphaComponent(1))
        self.lblEasyBook
            .font(name: .semibold, size: 18).textColor(color: .themeBlack.withAlphaComponent(1))
        self.lblEasyBookCall
            .font(name: .regular, size: 16).textColor(color: .white.withAlphaComponent(1))
        
        self.btnViewAllTest
            .font(name: .semibold, size: 15).textColor(color: .themePurple.withAlphaComponent(1))
        self.btnViewAllPkg
            .font(name: .semibold, size: 15).textColor(color: .themePurple.withAlphaComponent(1))
        
    }
    
    @objc func updateAPIData(){
        self.strErrorTestMessage        = ""
        self.strErrorPkgMessage         = ""
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.viewModel.apiCallFromStart_test(refreshControl: self.refreshControl,
                                                    separate: "Yes",
                                                    withLoader: true)
        }
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        self.setup(collectionView: self.colBookTest1)
        self.setup(collectionView: self.colBookTest2)
        
        DispatchQueue.main.async {
            self.vwEasyBook.layoutIfNeeded()
            self.vwEasyBook.cornerRadius(cornerRadius: 10)
                .backGroundColor(color: UIColor.themeLightPurple)
            
            self.colBookTest1.layoutIfNeeded()
            self.colBookTest2.layoutIfNeeded()
            
            self.colBookTest1.themeShadow()
            self.colBookTest2.themeShadow()
            
            self.vwEasyBook.layoutIfNeeded()
            self.vwEasyBook.themeShadow()
            
            self.vwSearch.layoutIfNeeded()
            self.vwSearch.cornerRadius(cornerRadius: 10)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
        }
    }
    
    func setup(collectionView: UICollectionView){
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }

    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    
    func manageActionMethods(){
        
        self.btnViewAllTest.addTapGestureRecognizer {
            let vc = AllLabTestListVC.instantiate(fromAppStoryboard: .carePlan)
            vc.labTestType = .test
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnViewAllPkg.addTapGestureRecognizer {
            let vc = TestPackageListVC.instantiate(fromAppStoryboard: .carePlan)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.vwSearch.addTapGestureRecognizer {
            let vc = AllLabTestListVC.instantiate(fromAppStoryboard: .carePlan)
            vc.labTestType = .all
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.vwEasyBook.addTapGestureRecognizer {
            
//            var params1 = [String: Any]()
//            params1[AnalyticsParameters.lab_test_id.rawValue]  = object.labTestId
            FIRAnalytics.FIRLogEvent(eventName: .CALL_US_TO_BOOK_TEST_CLICKED,
                                     screen: .LabtestList,
                                     parameter: nil)
            
            if self.viewModel.strCall.trim() != ""{
                GFunction.shared.makeCall(self.viewModel.strCall)
            }
        }
    }
    
    //MARK: -------------------------- View life cycle --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
        self.updateAPIData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //WebengageManager.shared.navigateScreenEvent(screen: .SetUpGoalsReadings)
        if let tabbar = self.parent?.parent as? TabbarVC {
            tabbar.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = .default
        
//        var params1 = [String: Any]()
//        params1[AnalyticsParameters.lab_test_id.rawValue]  = object.labTestId
        FIRAnalytics.FIRLogEvent(eventName: .USER_OPEN_POPULAR_LABTESTS,
                                 screen: .LabtestList,
                                 parameter: nil)
        
        GFunction.shared.updateCartCount(btn: self.btnCart)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .SetUpGoalsReadings, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //FIRAnalytics.manageTimeSpent(on: .SetUpGoalsReadings, when: .Disappear)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension LabTestListVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.colBookTest1:
            return self.viewModel.getTestCount()
            
        case self.colBookTest2:
            return self.viewModel.getPkgCount()
            
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
           
        case self.colBookTest1:
            let cell : HomeBookTestCell = collectionView.dequeueReusableCell(withClass: HomeBookTestCell.self, for: indexPath)
            
            //set style
            cell.lblTitle
                .font(name: .medium, size: 15)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
            cell.lblDesc
                .font(name: .regular, size: 12)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
            cell.lblOffer
                .font(name: .semibold, size: 10)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
            
            cell.lblOldPrice
                .font(name: .regular, size: 16)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
            cell.lblNewPrice
                .font(name: .semibold, size: 22)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
            
            let object              = self.viewModel.getTestObject(index: indexPath.item)
            cell.setData(object: object)
            
            let defaultDicQue : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : UIFont.customFont(ofType: .semibold, withSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
            ]
            cell.lblOldPrice.attributedText = cell.lblOldPrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
            
            return cell
    
        case self.colBookTest2:
            let cell : HomeBookTestCell = collectionView.dequeueReusableCell(withClass: HomeBookTestCell.self, for: indexPath)
            
            //set style
            cell.lblTitle
                .font(name: .medium, size: 15)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
            cell.lblDesc
                .font(name: .regular, size: 12)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
            cell.lblOffer
                .font(name: .semibold, size: 10)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
            
            cell.lblOldPrice
                .font(name: .regular, size: 16)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
            cell.lblNewPrice
                .font(name: .semibold, size: 22)
                .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
            
            let object              = self.viewModel.getPkgObject(index: indexPath.item)
            cell.setData(object: object)
            
            let defaultDicQue : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : UIFont.customFont(ofType: .semibold, withSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
            ]
            cell.lblOldPrice.attributedText = cell.lblOldPrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case self.colBookTest1:
            let object = self.viewModel.getTestObject(index: indexPath.item)
            let vc = LabTestDetailsVC.instantiate(fromAppStoryboard: .carePlan)
            vc.lab_test_id  = object.labTestId
            vc.hidesBottomBarWhenPushed = true
            vc.completionHandler = { obj in
                if obj?.name != nil {
                    self.viewModel.arrTestList[indexPath.item] = obj!
                    self.colBookTest1.reloadData()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case self.colBookTest2:
            let object = self.viewModel.getPkgObject(index: indexPath.item)
            let vc = LabTestDetailsVC.instantiate(fromAppStoryboard: .carePlan)
            vc.lab_test_id  = object.labTestId
            vc.hidesBottomBarWhenPushed = true
            vc.completionHandler = { obj in
                if obj?.name != nil {
                    self.viewModel.arrPkgList[indexPath.item] = obj!
                    self.colBookTest2.reloadData()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colBookTest1:
            
            let width   = self.colBookTest1.frame.size.width / 2
            let height  = width
            
            return CGSize(width: width,
                          height: height + 10)
            
        case self.colBookTest2:
            
            let width   = self.colBookTest2.frame.size.width / 2
            let height  = width
            
            return CGSize(width: width,
                          height: height + 10)
            
        default:
            
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension LabTestListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        if scrollView == self.colBookTest1 {
            let text = self.strErrorTestMessage
            let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
            return NSAttributedString(string: text, attributes: attributes)
        }
        else if scrollView == self.colBookTest2 {
            let text = self.strErrorPkgMessage
            let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
            return NSAttributedString(string: text, attributes: attributes)
        }
        let text = self.strErrorTestMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension LabTestListVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UICollectionView, obj == self.colBookTest1, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.colBookTest1Height.constant = newvalue.height
        }
        if let obj = object as? UICollectionView, obj == self.colBookTest2, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.colBookTest2Height.constant = newvalue.height
        }
        UIView.animate(withDuration: kAnimationSpeed) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addObserverOnHeightTbl() {
        self.colBookTest1.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.colBookTest2.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.colBookTest1 else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView1 = self.colBookTest2 else {return}
        if let _ = tblView1.observationInfo {
            tblView1.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
}

//MARK: -------------------- setupViewModel Observer --------------------
extension LabTestListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmArrayResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                DispatchQueue.main.async {
                    self.strErrorTestMessage        = self.viewModel.strErrorTestMessage
                    self.strErrorPkgMessage         = self.viewModel.strErrorPkgMessage

                    self.colBookTest1.reloadData()
                    self.colBookTest2.reloadData()
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

