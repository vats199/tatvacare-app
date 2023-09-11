//
//  FoodDiaryDetailVC.swift
//  MyTatva
//
//  Created by on 26/10/21.
//

import UIKit


class MacroAnalysisCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var progress     : LinearProgressBar!
    @IBOutlet weak var lblConsumed  : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblConsumed.font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack)
    
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.progress.layoutIfNeeded()
            self.progress.setRound()
        }
        
    }
}

class MealEnergyDesCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var progress     : LinearProgressBar!
    @IBOutlet weak var lblConsumed  : UILabel!
    @IBOutlet weak var lblProgrssType : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblConsumed.font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack)
        self.lblProgrssType.font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack)
    
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.progress.layoutIfNeeded()
            self.progress.setRound()
        }
        
    }
}


class FoodDiaryDetailVC: ClearNavigationFontBlackBaseVC { //----------------------------------
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var scrollMain       : UIScrollView!
    @IBOutlet weak var lblTitle         : UILabel!
    
    
    @IBOutlet weak var vwMacroAnalysis  : UIView!
    @IBOutlet weak var lblMacroAnalysis : UILabel!
    @IBOutlet weak var lblMacroDetail   : UILabel!
    @IBOutlet weak var lblLearnMore     : UILabel!
    @IBOutlet weak var lblMacroCons     : UILabel!
    @IBOutlet weak var tblMacro         : UITableView!
    @IBOutlet weak var tblMacroHeight   : NSLayoutConstraint!
    
    @IBOutlet weak var vwMealDes        : UIView!
    @IBOutlet weak var lblMealDes       : UILabel!
    @IBOutlet weak var lblMealDetail    : UILabel!
    @IBOutlet weak var lblMealcons      : UILabel!
    @IBOutlet weak var tblMeal          : UITableView!
    @IBOutlet weak var tblMealHeight    : NSLayoutConstraint!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    var insight_date                = ""
    let viewModel                   = FoodDiaryDetailVM()
    let refreshControl              = UIRefreshControl()
    var hiddenSections              = Set<Int>()
    var isEdit                      = false
    var object                      = FoodInsightModel()
    var dateMonth                   = ""
    var strErrorMessage : String    = ""
    var timerSearch                 = Timer()
    
    //Language: English, Hindi, Kannada
    var arrData : [JSON] = [
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
        ],
        [
            "name" : "Kannada",
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
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        
        self.lblTitle.text = self.dateMonth + " " + AppMessages.FoodInsights
        
        let dic = [NSAttributedString.Key.font : UIFont.customFont(ofType: .medium, withSize: 14), NSAttributedString.Key.foregroundColor : UIColor.themePurple,NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue , NSAttributedString.Key.underlineColor : UIColor.themePurple] as [NSAttributedString.Key : Any]
        
        let attrString = NSMutableAttributedString(string: self.lblLearnMore.text ?? "")
        attrString.addAttributes(dic, range:  NSRange(location: 0, length: (self.lblLearnMore.text ?? "").count))
        
        self.lblLearnMore.attributedText = attrString

        
        DispatchQueue.main.async {
            self.vwMacroAnalysis.layoutIfNeeded()
            self.vwMacroAnalysis.cornerRadius(cornerRadius: 7)
            self.vwMacroAnalysis.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
            self.vwMealDes.layoutIfNeeded()
            self.vwMealDes.cornerRadius(cornerRadius: 7)
            self.vwMealDes.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            self.lblLearnMore.layoutIfNeeded()
            
        }
        
        self.lblMacroAnalysis.font(name: .medium, size: 15).textColor(color: UIColor.themeBlack)
        self.lblMacroDetail.font(name: .regular, size: 14).textColor(color: UIColor.themeBlack)
        self.lblMacroCons.font(name: .medium, size: 14).textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        
        self.lblMealDes.font(name: .medium, size: 15).textColor(color: UIColor.themeBlack)
        self.lblMealDetail.font(name: .regular, size: 14).textColor(color: UIColor.themeBlack)
        self.lblMealcons.font(name: .medium, size: 14).textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        
        self.configureUI()
        self.addObserverOnHeightTbl()
        self.manageActionMethods()
        self.setup(tblView: self.tblMeal)
        self.setup(tblView: self.tblMacro)
        
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        
    }
    
    private func setup(tblView: UITableView) {
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.scrollMain.addSubview(self.refreshControl)
    }
    
    @objc func updateAPIData(){
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.refreshControl.beginRefreshing()
            self.scrollMain.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.viewModel.foodDetailAPI(insight_date: self.insight_date,
                                             withLoader: false) { [weak self] (isDone) in
                    guard let self = self else {return}
                    
                    self.refreshControl.endRefreshing()
                    if isDone {
                        self.object = self.viewModel.object
                        self.setData()
                    }
                }
            }
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        self.lblLearnMore.addTapGestureRecognizer {
            print("learn more")
        }
    }
    
    @objc func onTapTermsAndCondition(_ gesture : UITapGestureRecognizer){
       
    }
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .FoodDiaryDayInsight)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.updateAPIData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .FoodDiaryDayInsight, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAnalytics.manageTimeSpent(on: .FoodDiaryDayInsight, when: .Disappear)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension FoodDiaryDetailVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case self.tblMacro:
            
            if self.object.macronutritionAnalysis != nil {
                return self.object.macronutritionAnalysis.count
            }
            return 0
            
        case self.tblMeal:
             
            if self.object.mealEnergyDistribution != nil {
                return self.object.mealEnergyDistribution.count
            }
            return 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.tblMacro:
            
            let cell : MacroAnalysisCell = tableView.dequeueReusableCell(withClass: MacroAnalysisCell.self, for: indexPath)
            let object = self.object.macronutritionAnalysis[indexPath.row]
            GFunction.shared.setProgress(progressBar: cell.progress, color: UIColor(hexString: object.colorCode))
            
            cell.lblTitle.text  = object.label
            cell.progress.progressValue = GFunction.shared.getProgress(value: object.taken, maxValue: object.recommended)
            
            cell.lblConsumed.text = String(format: "%0.0f", object.taken) + " " + AppMessages.of + " " + String(format: "%0.0f", object.recommended) + " \(object.unitName!)"
            return cell
            
        case self.tblMeal:
            
            let cell : MealEnergyDesCell = tableView.dequeueReusableCell(withClass: MealEnergyDesCell.self, for: indexPath)
            let object = self.object.mealEnergyDistribution[indexPath.row]
            GFunction.shared.setProgress(progressBar: cell.progress, color: UIColor(hexString: object.colorCode))
            
            cell.lblTitle.text  = object.mealType
            cell.progress.progressValue = GFunction.shared.getProgress(value: Float(object.caloriesTaken), maxValue: Float(object.recommended))
            
            
            cell.lblConsumed.text = String(format: "%0.0f", Float(object.caloriesTaken)) + " " + AppMessages.of + " " + String(format: "%0.0f", Float(object.recommended)) + " \(object.calUnitName!)"
            cell.lblProgrssType.text = object.limit
            
            return cell
            
            
        default:
            return UITableViewCell(frame: .zero)
        }
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.manageRecordPagenation(tblView: tableView, index: indexPath.row)
    }
    
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension FoodDiaryDetailVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension FoodDiaryDetailVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblMacro, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblMacroHeight.constant = newvalue.height
        }
        else if let obj = object as? UITableView, obj == self.tblMeal, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblMealHeight.constant = newvalue.height
        }
        
        UIView.animate(withDuration: kAnimationSpeed) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblMacro.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblMeal.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblMacro else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView2 = self.tblMeal else {return}
        if let _ = tblView2.observationInfo {
            tblView2.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension FoodDiaryDetailVC {
    
    fileprivate func setData(){
        self.tblMeal.reloadData()
        self.tblMacro.reloadData()
    }
}


