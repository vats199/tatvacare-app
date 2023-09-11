//
//  PheromonePopupVC.swift
//

//

import UIKit

class IncludedTestsHeaderCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    
    @IBOutlet weak var vwBullet     : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
//            self.vwBg.cornerRadius(cornerRadius: 7)
//            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
            self.vwBullet.layoutIfNeeded()
            self.vwBullet.cornerRadius(cornerRadius: self.vwBullet.frame.size.height / 2)
                .backGroundColor(color: UIColor.themePurple)
        }
    }
}

class IncludedTestsCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    
    @IBOutlet weak var vwBullet     : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
//            self.vwBg.cornerRadius(cornerRadius: 7)
//            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
            self.vwBullet.layoutIfNeeded()
            self.vwBullet.cornerRadius(cornerRadius: self.vwBullet.frame.size.height / 2)
                .backGroundColor(color: UIColor.themePurple)
        }
    }
}

class IncludedTestsVC: ClearNavigationFontBlackBaseVC {
    
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    
    @IBOutlet weak var vwTest           : UIView!
    @IBOutlet weak var lblTest          : UILabel!
    @IBOutlet weak var lblShowAll       : UILabel!
    
    @IBOutlet weak var tblView          : UITableView!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancel        : UIButton!
    
    //MARK:- Class Variable
    let viewModel                       = IncludedTestsVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    var object                          = BookTestListModel()
    
    var completionHandler: ((_ obj : DoseListModel?) -> Void)?
    
    var arrDoseOffline : [DoseListModel] = []
    var arrDays : [JSON] = [
        [
            "name" : "1 time a day",
            "short" : "Sun",
            "isSelected": 0,
        ],[
            "name" : "2 time a day",
            "short" : "Mon",
            "isSelected": 0,
        ],
        [
            "name" : "3 time a day",
            "short" : "Tue",
            "isSelected": 0,
        ],
        [
            "name" : "4 time a day",
            "short" : "Wed",
            "isSelected": 0,
        ],
        [
            "name" : "5 time a day",
            "short" : "Thu",
            "isSelected": 0,
        ],
        [
            "name" : "6 time a day",
            "short" : "Fri",
            "isSelected": 0,
        ]
    ]
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {
        self.setupViewModelObserver()
        
        self.lblTitle.font(name: .semibold, size: 18)
            .textColor(color: UIColor.themeBlack)
        
        self.lblDesc
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblTest
            .font(name: .medium, size: 12)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.lblShowAll
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.btnCancel.font(name: .medium, size: 18)
            .textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 20)
            
            self.vwTest.layoutIfNeeded()
            self.vwTest.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.themeLightPurple.withAlphaComponent(0.1))
        }
        
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
        self.setData()
    }
    
    fileprivate func configureUI(){
    
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.sectionHeaderHeight        = UITableView.automaticDimension
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.sectionFooterHeight        = 0
        self.tblView.reloadData()
//        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
//        self.tblView.addSubview(self.refreshControl)
           
    }
    
    @objc func updateAPIData(){
        self.strErrorMessage = ""
//        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
//                                        tblView: self.tblView,
//                                        withLoader: true)
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : DoseListModel? = nil) {
        
        func sendData() {
            if let obj = objAtIndex {
                if let completionHandler = completionHandler {
                    completionHandler(obj)
                }
            }
        }
        
        self.dismiss(animated: animated) {
            sendData()
        }
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnSubmit.addTapGestureRecognizer {
//            var arrTemp     = [JSON]()
//            for i in 0...self.arrDays.count - 1 {
//                let obj  = self.arrDays[i]
//
//                if obj["isSelected"].intValue == 1 {
//                    arrTemp.append(obj)
//                }
//            }
            self.dismissPopUp(true, objAtIndex: self.viewModel.getSelectedObject())
        }
        
        self.btnCancel.addTapGestureRecognizer {
            //let obj         = [JSON]()
            self.dismissPopUp(true, objAtIndex: nil)
        }
    }
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .AllTestPackageList)
        
//        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
//                                        tblView: self.tblView,
//                                        withLoader: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension IncludedTestsVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.object.childs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0//self.viewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : IncludedTestsHeaderCell = tableView.dequeueReusableCell(withClass: IncludedTestsHeaderCell.self)
        let object = self.object.childs[section]
        cell.lblTitle.text = object.name
        //cell.vwBg.backGroundColor(color: UIColor.red)
        return cell.contentView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : IncludedTestsCell = tableView.dequeueReusableCell(withClass: IncludedTestsCell.self, for: indexPath)

//        let object = self.viewModel.getObject(index: indexPath.row)
//
//        if object.doseType == "1"{
//            cell.lblTitle.text = object.doseType //+ " " + AppMessages.timePerDay
//        }
//        else {
//            cell.lblTitle.text = object.doseType //+ " " + AppMessages.timesPerDay
//        }
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let object  = self.arrDays[indexPath.row]
//
//
//        for i in 0...self.arrDays.count - 1 {
//            var obj  = self.arrDays[i]
//
//            obj["isSelected"].intValue = 0
//            if obj["name"].stringValue == object["name"].stringValue {
//                obj["isSelected"].intValue = 1
//            }
//            self.arrDays[i] = obj
//        }
        
        //self.viewModel.manageSelection(index: indexPath.row)
        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension IncludedTestsVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------- set data methods --------------------
extension IncludedTestsVC {
    
    func setData(){
        self.lblTitle.text              = self.object.name
        self.lblTest.text               = "Includes " + "\(self.object.childs.count)" + " tests"
        self.tblView.reloadData()
        self.tblView.isScrollEnabled = true
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension IncludedTestsVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
