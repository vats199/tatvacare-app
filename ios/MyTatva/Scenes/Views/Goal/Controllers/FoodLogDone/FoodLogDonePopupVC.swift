//
//  FoodLogDonePopupVC.swift
//  MyTatva
//
//  Created by on 27/10/21.
//

import UIKit

class FoodLogcontentCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var progress             : LinearProgressBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.progress.layoutIfNeeded()
            self.progress.setRound()
        }
        GFunction.shared.setProgress(progressBar: self.progress, color: UIColor.themeRed)
    }
    
}

class FoodLogDonePopupVC: ClearNavigationFontBlackBaseVC{
    
    
    //MARK:- Outlet
    @IBOutlet weak var btnCancel    : UIButton!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblSubTitle  : UILabel!
    @IBOutlet weak var lblCalories  : UILabel!
    @IBOutlet weak var vwBgTable    : UIView!
    @IBOutlet weak var tblView      : UITableView!
    @IBOutlet weak var tblHeight    : NSLayoutConstraint!
    @IBOutlet weak var btnDone      : UIButton!
    
    //MARK:- Class Variable
    let viewModel                       = FoodLogDonePopupVM()
    var object                          = FoodLogAnalysisModel()
    var mealType                        = ""
    var strErrorMessage                 = ""
    
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {

        self.lblTitle.font(name: .medium, size: 18).textColor(color: UIColor.themeBlack)
        self.lblSubTitle.font(name: .medium, size: 20).textColor(color: UIColor.themeBlack)
        self.lblCalories.font(name: .regular, size: 15).textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.btnDone.font(name: .semibold, size: 18)
        self.vwBgTable.backGroundColor(color: UIColor.themeLightPurple.withAlphaComponent(0.06))
        
        self.lblSubTitle.isHidden = true
        
        self.openPopUp()
        self.setData()
        self.configureUI()
        self.manageActionMethods()
        self.setupViewModelObserver()
        self.addObserverOnHeightTbl()
    }
    
    fileprivate func configureUI(){
        DispatchQueue.main.async {
           
            self.tblView.tableFooterView        = UIView.init(frame: CGRect.zero)
            self.tblView.emptyDataSetSource     = self
            self.tblView.emptyDataSetDelegate   = self
            self.tblView.delegate               = self
            self.tblView.dataSource             = self
            self.tblView.rowHeight              = UITableView.automaticDimension
            self.tblView.reloadData()
        }
        
        DispatchQueue.main.async {
            self.vwBgTable.layoutIfNeeded()
            self.vwBgTable.cornerRadius(cornerRadius: 10)
            self.vwBgTable.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            self.btnDone.layoutIfNeeded()
            self.btnDone.cornerRadius(cornerRadius: 5)
        }
    }
    
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : JSON? = nil) {
        
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
        
        self.btnDone.addTapGestureRecognizer {
            var obj         = JSON()
            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: obj)
        }
        
        self.btnCancel.addTapGestureRecognizer {
            var obj         = JSON()
            obj["isDone"]   = true
            self.dismissPopUp(true, objAtIndex: obj)
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .LogFoodSuccess)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension FoodLogDonePopupVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.object.macronutritionAnalysis.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FoodLogcontentCell = tableView.dequeueReusableCell(withClass: FoodLogcontentCell.self, for: indexPath)
        let objc = self.object.macronutritionAnalysis[indexPath.row]
        cell.lblTitle.text = objc.label
       
        cell.progress.progressValue = GFunction.shared.getProgress(value: objc.taken, maxValue: objc.recommended)
        GFunction.shared.setProgress(progressBar: cell.progress, color: UIColor.hexStringToUIColor(hex: objc.colorCode))
//        let object = self.viewModel.getObject(index: indexPath.row)
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                                        
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension FoodLogDonePopupVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblHeight.constant = newvalue.height
        }
   
    }
    
    func addObserverOnHeightTbl() {
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblView else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension FoodLogDonePopupVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------- setData method --------------------
extension FoodLogDonePopupVC {
    
    func setData(){
        
        self.lblTitle.text      = "Well Done On Logging Your Lunch!" //+ self.object.
        
        self.lblCalories.text   = String(format: "%0.f", Double(self.object.totalCaloriesConsume)) + " " + AppMessages.of + " " + String(self.object.totalCaloriesRequired) + " " + AppMessages.CaloriesConsumed
        self.lblTitle.text = AppMessages.logFood + " " + self.mealType + "!"
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension FoodLogDonePopupVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
               
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
    }
}




