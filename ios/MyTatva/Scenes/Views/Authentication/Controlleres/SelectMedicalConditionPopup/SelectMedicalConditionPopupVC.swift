//
//  PheromonePopupVC.swift
//

//

import UIKit

class SelectMedicalConditionPopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var tblView          : UITableView!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancel        : UIButton!
    
    
    //MARK:- Class Variable
    let viewModel                       = SelectMedicalConditionPopupVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    
    var completionHandler: ((_ obj : MedicalConditionListModel) -> Void)?
    
    var arrDaysOffline : [MedicalConditionListModel] = []
    var arrDays : [JSON] = [
        [
            "name" : "Condition 1",
            "short" : "Sun",
            "isSelected": 0,
        ],[
            "name" : "Condition 2",
            "short" : "Mon",
            "isSelected": 0,
        ],
        [
            "name" : "Condition 3",
            "short" : "Tue",
            "isSelected": 0,
        ],
        [
            "name" : "Condition 4",
            "short" : "Wed",
            "isSelected": 0,
        ],
        [
            "name" : "Condition 5",
            "short" : "Thu",
            "isSelected": 0,
        ],
        [
            "name" : "Condition 6",
            "short" : "Fri",
            "isSelected": 0,
        ],
        [
            "name" : "Condition 7",
            "short" : "Sat",
            "isSelected": 0,
        ],
        [
            "name" : "Condition 8",
            "short" : "All days",
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
        
        self.lblTitle.font(name: .semibold, size: 22)
            .textColor(color: UIColor.themeBlack)
        
        self.btnCancel.font(name: .medium, size: 18)
            .textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 20)
        }
        
        self.openPopUp()
        self.setData()
        self.configureUI()
        self.manageActionMethods()
    }
    
    fileprivate func configureUI(){
    
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
           
    }
    
    @objc func updateAPIData(){
        self.strErrorMessage = ""
        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                        tblView: self.tblView,
                                        withLoader: true)
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : MedicalConditionListModel? = nil) {
        
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
            
            guard let obj = self.viewModel.getSelectedObject() else {
                return
            }
          
            self.dismissPopUp(true, objAtIndex: obj)
        }
        
        self.btnCancel.addTapGestureRecognizer {
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
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.apiCallFromStart(tblView: self.tblView,
                                   withLoader: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: ------------------ UITableView Methods ------------------
extension SelectMedicalConditionPopupVC {
    
    fileprivate func setData(){
        if self.arrDaysOffline.count > 0 && self.arrDaysOffline.first?.medicalConditionName != nil {
            if viewModel.arrList.count > 0 {
                
                for parent in self.viewModel.arrList {
                    parent.isSelected = false
                    
                    for child in self.arrDaysOffline {
                        if parent.medicalConditionGroupId == child.medicalConditionGroupId {
                            parent.isSelected = true
                        }
                    }
                }
                self.tblView.reloadData()
            }
        }
        else {
            if viewModel.arrList.count > 0 {
                self.viewModel.arrList.first?.isSelected = true
            }
        }
        
//        if self.arrDataOffline.count > 0 {
//            for i in 0...self.arrData.count - 1 {
//                var parent = self.arrData[i]
//
//                for item in self.arrDataOffline {
//
//                    parent["isSelected"].intValue = 0
//                    if item["name"].stringValue == parent["name"].stringValue {
//                        parent["isSelected"].intValue = 1
//                        self.arrData[i] = parent
//                    }
//                }
//            }
//            self.tblView.reloadData()
//        }
    }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension SelectMedicalConditionPopupVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : LanguageTblCell = tableView.dequeueReusableCell(withClass: LanguageTblCell.self, for: indexPath)

        let object = self.viewModel.getObject(index: indexPath.row)
        
        cell.imgView.isHidden = true
        cell.lblTitle.text = object.medicalConditionName
        
        cell.btnSelect.isSelected = false
        if object.isSelected {
            cell.btnSelect.isSelected = true
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let object  = self.arrDays[indexPath.row]
        
//        for i in 0...self.arrDays.count - 1 {
//            var obj  = self.arrDays[i]
//
//            obj["isSelected"].intValue = 0
//            if obj["name"].stringValue == object["name"].stringValue {
//                obj["isSelected"].intValue = 1
//            }
//            self.arrDays[i] = obj
//        }
        
        self.viewModel.manageSelection(index: indexPath.row)
        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension SelectMedicalConditionPopupVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension SelectMedicalConditionPopupVC {
    
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