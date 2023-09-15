//
//  SelectDocumentTitleVC.swift
//  MyTatva
//
//  Created by hyperlink on 03/11/21.
//

import UIKit

class SelectDocumentTitleVC: WhiteNavigationBaseVC {
    
    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var txtSearch    : UITextField!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var tblView      : UITableView!
    
    @IBOutlet weak var btnSubmit    : UIButton!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = SelectDocumentTitleVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    
    var completionHandler: ((_ obj : Title?) -> Void)?
    
    //var arrDocTitle : [Title] = []
    
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
    
    @objc func updateAPIData(){
        self.strErrorMessage = ""
        self.viewModel.apiCallFromStart(refreshControl: self.refreshControl,
                                        tblView: self.tblView,
                                        withLoader: true)
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
           
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        
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
        self.viewModel.apiCallFromStart(tblView: self.tblView,withLoader: true)
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
extension SelectDocumentTitleVC : UITableViewDataSource, UITableViewDelegate{
    
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
        cell.btnSelect.isHidden = true
        
        DispatchQueue.main.async {
            if object.isCustom {
                cell.lblTitle.text = AppMessages.add + " " + object.title + " " + AppMessages.asDocumentTitle
                
                cell.lblTitle.font(name: .semibold, size: 16)
                    .textColor(color: UIColor.themePurple)
            }
            else {
                cell.lblTitle.text = object.title
                
                cell.lblTitle.font(name: .semibold, size: 16)
                    .textColor(color: UIColor.themeBlack)
                
            }
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object      = self.viewModel.getObject(index: indexPath.row)
//        var obj         = Title()
//        obj["isDone"]   = true
//        if object.isCustom {
//            obj["name"].stringValue = self.txtSearch.text!
//        }
//        else {
//            for item in self.arrDocTitle {
//                if item["isSelected"].intValue == 1 {
//                    obj["name"].stringValue = item["name"].stringValue
//                }
//            }
//        }
        
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
            completionHandler(object)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension SelectDocumentTitleVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension SelectDocumentTitleVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {

            self.viewModel.arrList.removeAll { (object) -> Bool in
                return object.isCustom == true
            }
            self.viewModel.arrFilteredList.removeAll { (object) -> Bool in
                return object.isCustom == true
            }
            
            //self.apiCallFromStart(search: newText, withLoader: false)
            self.viewModel.manageSearch(keyword: newText)
            self.tblView.reloadData()
        }

        return true
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension SelectDocumentTitleVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
