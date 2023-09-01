//
//  NotificationListVC.swift
//  SM Company
//
//  Created by on 13/12/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit


class LanguageTblCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    
    @IBOutlet weak var vwImgBg      : UIView?
    @IBOutlet weak var imgView      : UIImageView!
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnSelect    : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
            self.imgView.layoutIfNeeded()
            self.imgView.cornerRadius(cornerRadius: 5)
            
            self.vwImgBg?.layoutIfNeeded()
            self.vwImgBg?.cornerRadius(cornerRadius: 5)
        }
    }
}

class LanguageListVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var tblView      : UITableView!
    @IBOutlet weak var searchBar    : UISearchBar!
    @IBOutlet weak var btnSubmit    : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = LanguageListVM()
    let refreshControl              = UIRefreshControl()
    var arrDaysOffline              = [LanguageListModel]()
    var isEdit                      = false
    
    var strErrorMessage : String    = ""
    
    var completionHandler: ((_ obj : LanguageListModel) -> Void)?
    //Language: English, Hindi, Kannada
    var arrLanguage : [JSON] = [
        [
            "name" : "English",
            "isSelected": 1,
        ],[
            "name" : "Hindi",
            "isSelected": 0,
        ],
        [
            "name" : "Kannada",
            "isSelected": 0,
        ]
    ]
    
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        self.searchBar.isHidden = true
        self.configureUI()
        self.manageActionMethods()
    }
    
    @objc func updateAPIData(){
        self.strErrorMessage = ""
        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                        tblView: self.tblView,
                                        withLoader: true)
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
    
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
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        self.btnSubmit.addTapGestureRecognizer {
//            var obj         = JSON()
//            obj["isDone"]   = true
//            for item in self.arrLanguage {
//                if item["isSelected"].intValue == 1 {
//                    obj["language"].stringValue = item["name"].stringValue
//                }
//            }
            
            guard let obj = self.viewModel.getSelectedObject() else {
                return
            }
            
            if let completionHandler = self.completionHandler {
                completionHandler(obj)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.viewModel.apiCallFromStart(tblView: self.tblView,
                                   withLoader: true)
        WebengageManager.shared.navigateScreenEvent(screen: .LanguageList)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension LanguageListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()//self.arrLanguage.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : LanguageTblCell = tableView.dequeueReusableCell(withClass: LanguageTblCell.self, for: indexPath)

        let object = self.viewModel.getObject(index: indexPath.row)//self.arrLanguage[indexPath.row]
        
        cell.imgView.isHidden = true
        cell.lblTitle.text = object.languageName
        
        cell.btnSelect.isSelected = false
        if object.isSelected {
            cell.btnSelect.isSelected = true
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.manageSelection(index: indexPath.row)
        self.tblView.reloadData()
//        let object  = self.arrLanguage[indexPath.row]
//        for i in 0...self.arrLanguage.count - 1 {
//            var obj  = self.arrLanguage[i]
//            obj["isSelected"].intValue = 0
//            if obj["name"].stringValue == object["name"].stringValue {
//                obj["isSelected"].intValue = 1
//            }
//            self.arrLanguage[i] = obj
//        }
//        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension LanguageListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension LanguageListVC {
    
    fileprivate func setData(){
//        if self.arrDaysOffline.count > 0 {
//            for i in 0...self.arrDays.count - 1 {
//                var parent = self.arrDays[i]
//
//                for item in self.arrDaysOffline {
//
//                    parent["isSelected"].intValue = 0
//                    if item["name"].stringValue == parent["name"].stringValue {
//                        parent["isSelected"].intValue = 1
//                        self.arrDays[i] = parent
//                    }
//                }
//            }
//            self.tblView.reloadData()
//        }
        
        if self.arrDaysOffline.count > 0 {
            if self.viewModel.arrList.count > 0 {
                for parent in self.arrDaysOffline {
                    for child in self.viewModel.arrList {
                        
                        if parent.languagesId.lowercased() == child.languagesId.lowercased() {
                            child.isSelected = true
                        }
                    }
                }
            }
            
            self.tblView.reloadData()
        }
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension LanguageListVC {
    
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
