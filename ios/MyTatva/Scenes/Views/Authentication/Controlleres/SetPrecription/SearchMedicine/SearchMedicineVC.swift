//
//  NotificationListVC.swift
//  SM Company
//
//  Created by  on 13/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class SearchMedicineCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var imgView      : UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnSelect    : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.lblTitle.font(name: .semibold, size: 16)
//            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
            self.imgView.layoutIfNeeded()
            self.imgView.cornerRadius(cornerRadius: 5)
        }
    }
}

class SearchMedicineVC: WhiteNavigationBaseVC {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var txtSearch    : UITextField!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var tblView      : UITableView!
    
    @IBOutlet weak var btnSubmit    : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = SearchMedicineVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    var arrDaysOffline : [JSON] = []
    var arrMedicine : [JSON] = [
//        [
//            "name" : "Abacavir.",
//            "isSelected": 1,
//            "type": "default"
//        ],[
//            "name" : "Abacavir / dolutegravir / lamivudine (Triumeq®) ",
//            "isSelected": 0,
//            "type": "default"
//        ],
//        [
//            "name" : "Add Aba as a Drug",
//            "isSelected": 0,
//        ]
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
        self.configureUI()
        self.manageActionMethods()
    }
    
    @objc func updateAPIData(medicine_name: String){
        self.strErrorMessage = ""
        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                        tblView: self.tblView,
                                        medicine_name: medicine_name.trim(),
                                        withLoader: false)
    }
    
    //Desc:- Set layout desing customize
    func configureUI(){
    
        self.txtSearch.delegate = self
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.reloadData()
//        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
//        self.tblView.addSubview(self.refreshControl)
           
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        self.btnSubmit.addTapGestureRecognizer { [weak self] in
            guard let self = self else {return}
            
            var obj         = JSON()
            obj["isDone"]   = true
            for item in self.arrMedicine {
                if item["isSelected"].intValue == 1 {
                    obj["language"].stringValue = item["name"].stringValue
                }
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
        WebengageManager.shared.navigateScreenEvent(screen: .SearchDrugs)
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
extension SearchMedicineVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.txtSearch.text!.trim() != "" {
            return self.viewModel.getCount() + 1
        }
        else {
            return self.viewModel.getCount()
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SearchMedicineCell = tableView.dequeueReusableCell(withClass: SearchMedicineCell.self, for: indexPath)

        if indexPath.row < self.viewModel.getCount() {
            //Data from search list
            let object = self.viewModel.getObject(index: indexPath.row)
            
            DispatchQueue.main.async {
                cell.lblTitle.text = object.medicineName
                
                cell.lblTitle.font(name: .semibold, size: 16)
                    .textColor(color: UIColor.themeBlack)
            }
        }
        else {
            //Data out of search list
            if self.arrMedicine.count > 0 {
                let object = self.arrMedicine[self.arrMedicine.count - 1]
                
                DispatchQueue.main.async {
                    if object["type"].stringValue == "custom" {
                        cell.lblTitle.text = AppMessages.add + " " + object["name"].stringValue + " " + AppMessages.asADrug
                        
                        cell.lblTitle.font(name: .semibold, size: 16)
                            .textColor(color: UIColor.themePurple)
                    }
                    else {
                        cell.lblTitle.text = object["name"].stringValue
                        
                        cell.lblTitle.font(name: .semibold, size: 16)
                            .textColor(color: UIColor.themeBlack)
                    }
                }
            }
            
        }
        
        cell.imgView.isHidden = true
        cell.btnSelect.isHidden = true
        
//        cell.btnSelect.isSelected = false
//        if object["isSelected"].intValue == 1 {
//            cell.btnSelect.isSelected = true
//        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var obj                 = JSON()
        if indexPath.row < self.viewModel.getCount() {
            //Data from search list
            let object              = self.viewModel.getObject(index: indexPath.row)
            obj["isDone"]           = true
            obj["name"].stringValue = object.medicineName
            obj["id"].stringValue   = object.medicineId
        }
        else {
            if self.arrMedicine.count > 0 {
                //Data out of search list
                let object      = self.arrMedicine[self.arrMedicine.count - 1]
                obj["isDone"]   = true
                if object["type"].stringValue == "custom" {
                    obj["name"].stringValue = self.txtSearch.text!
                }
                else {
                    for item in self.arrMedicine {
                        if item["isSelected"].intValue == 1 {
                            obj["name"].stringValue = item["name"].stringValue
                        }
                    }
                }
            }
        }
        
//        for i in 0...self.arrMedicine.count - 1 {
//            var obj  = self.arrMedicine[i]
//            obj["isSelected"].intValue = 0
//            if obj["name"].stringValue == object["name"].stringValue {
//                obj["isSelected"].intValue = 1
//            }
//            self.arrMedicine[i] = obj
//        }
//        self.tblView.reloadData()
        
        if let completionHandler = self.completionHandler {
            completionHandler(obj)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.managePagenation(tblView: self.tblView,
                                        medicine_name: self.txtSearch.text!,
                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension SearchMedicineVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------- UITextField Delegate --------------------
extension SearchMedicineVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            
            if newText.trim() != "" {
                let obj: JSON = [
                    "name" : newText,
                    "isSelected": 1,
                    "type": "custom"
                ]
                
                self.arrMedicine.removeAll { (object) -> Bool in
                    return object["type"] == "custom"
                }
                
                self.arrMedicine.append(obj)
            }
            else {
                self.arrMedicine.removeAll()
            }
            
            if newText.trim() != "" {
                self.updateAPIData(medicine_name: newText)
                //self.updateAPIData(medicine_name: "")
            }
            else {
                self.updateAPIData(medicine_name: "")
            }
            
            self.tblView.reloadData()
        }
        return true
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension SearchMedicineVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.tblView.reloadData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
