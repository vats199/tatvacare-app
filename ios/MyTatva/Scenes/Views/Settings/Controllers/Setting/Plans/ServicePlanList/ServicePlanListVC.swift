//
//  ExerciseMoreVC.swift

import UIKit

class ServicePlanListCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var imgTitle         : UIImageView!
    
    @IBOutlet weak var lblStartAt       : UILabel!
    @IBOutlet weak var lblActualPrice   : UILabel!
    
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var lblPrice         : UILabel!
    @IBOutlet weak var lblPriceRatio    : UILabel!
    @IBOutlet weak var btnBuy           : UIButton!
    @IBOutlet weak var btnCancel        : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.themeBlack)
        
        self.lblStartAt
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeGray)
        self.lblActualPrice
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeGray)
        
        self.lblDesc
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        
        self.lblPrice
            .font(name: .semibold, size: 22)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblPriceRatio
            .font(name: .semibold, size: 12)
            .textColor(color: UIColor.themeBlack)
        self.btnBuy
            .font(name: .medium, size: 11)
            .textColor(color: UIColor.white.withAlphaComponent(1))
            .backGroundColor(color: UIColor.themePurple)
        self.btnCancel
            .font(name: .medium, size: 11)
            .textColor(color: UIColor.white.withAlphaComponent(1))
            .backGroundColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.borderColor(color: UIColor.ThemeBorder, borderWidth: 0)
            
            self.btnBuy.layoutIfNeeded()
            self.btnBuy.cornerRadius(cornerRadius: 5)

            self.btnCancel.layoutIfNeeded()
            self.btnCancel.cornerRadius(cornerRadius: 5)
            
            self.imgTitle.layoutIfNeeded()
            //self.imgTitle.roundCorners([.topLeft, .bottomLeft], radius: 7)
        }
    }
}

//MARK: -------------------------  UIViewController -------------------------
class ServicePlanListVC : ClearNavigationFontBlackBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var tblView          : UITableView!
    @IBOutlet weak var btnMoveTop       : UIButton!

    //MARK:- Class Variable
    let viewModel                       = PlanListVM()
    let refreshControl                  = UIRefreshControl()
    var strErrorMessage : String        = ""
    var lastSyncDate                    = Date()
    var isMoveToOthers                  = false
    
    //MARK: ------------------------- Memory Management Method -------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    func setUpView() {
        self.setup(tblView: tblView)
        self.setData()
        self.configureUI()
        self.setupViewModelObserver()
    }
    
    func configureUI(){
        self.tblView.themeShadow()
    }
    
    func setup(tblView: UITableView){
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: Double.leastNormalMagnitude))
        tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        tblView.addSubview(self.refreshControl)
    }
    
    //MARK: ------------------------- Action Method -------------------------
    @IBAction func btnMoveTopTapped(sender: UIButton){
        self.tblView.scrollToTop()
    }
    
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .MyTatvaIndividualPlan)
        
        self.updateAPIData()
        
//        if Calendar.current.dateComponents([.minute], from: lastSyncDate, to: Date()).minute > kAPI_RELOAD_DELAY_BY {
//            self.lastSyncDate = Date()
//            self.updateAPIData(withLoader: true)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .ExercisePlan, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //FIRAnalytics.manageTimeSpent(on: .ExercisePlan, when: .Disappear)
    }
    
}

//MARK: -------------------------- UITableView Methods --------------------------
extension ServicePlanListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell : PlanListTitleCell = tableView.dequeueReusableCell(withClass: PlanListTitleCell.self)

        let obj             = self.viewModel.getObject(index: section)
        
        cell.lblTitle.text  = ""
        cell.lblTitle.text  = obj.title
//        if self.viewModel.getPlansCount(index: 0) > 0 {
//        }
        return cell.contentView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getObject(index: section).planDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ServicePlanListCell = tableView.dequeueReusableCell(withClass: ServicePlanListCell.self, for: indexPath)
        
        let objTitile   = self.viewModel.getObject(index: indexPath.section)
        let object      = objTitile.planDetails[indexPath.row]
        
        cell.imgTitle.setCustomImage(with: object.imageUrl)
        cell.lblTitle.text  = object.planName
        //let themeColor = UIColor.init(hexString: obj.colourScheme)
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .regular, withSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.themeGray.withAlphaComponent(1) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        
        cell.lblDesc.text = ""
        var desc = ""
        desc = object.descriptionField.htmlToString
        cell.lblDesc.text = desc
//        DispatchQueue.global(qos: .background).async {
//            desc = object.descriptionField.htmlToString
//            DispatchQueue.main.async {
//                cell.lblDesc.text = desc
//            }
//        }
        
        //cell.stackPurchaseDate.isHidden     = true
        cell.btnCancel.isHidden             = true
        cell.btnBuy.isHidden                = true
        cell.lblPriceRatio.isHidden         = true
        cell.lblStartAt.isHidden            = true
        var actualPrice                     = ""
        if objTitile.title.lowercased().contains("other".lowercased()){
            //cell.stackPurchaseDate.isHidden     = true
            cell.btnCancel.isHidden             = true
            cell.btnBuy.isHidden                = false
            cell.lblPriceRatio.isHidden         = false
            cell.lblStartAt.isHidden            = false
            cell.lblPrice.text  = appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(object.startAt!).doubleValue.floorToPlaces(places: 0))
            actualPrice = appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(object.actualPrice!).doubleValue.floorToPlaces(places: 0))
            /*
             if obj.offerPerMonthPrice > 0 {
                 cell.lblPrice.text = appCurrencySymbol.rawValue + "" + String(format: "%.0f", obj.offerPerMonthPrice!)
             }
             else {
                 cell.lblPrice.text = appCurrencySymbol.rawValue + "" + String(format: "%.0f", obj.iosPerMonthPrice!)
             }
             */
        }
        if objTitile.title.lowercased().contains("my".lowercased()){
            //cell.stackPurchaseDate.isHidden     = false
            cell.btnCancel.isHidden             = true
            cell.btnBuy.isHidden                = true
            cell.lblPriceRatio.isHidden         = true
            cell.lblStartAt.isHidden            = true
            cell.lblPrice.text = appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(object.iosPerMonthPrice!).doubleValue.floorToPlaces(places: 0))
            actualPrice = appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(object.actualPrice!).doubleValue.floorToPlaces(places: 0))

        }
        
        if object.discountPercentage == 0 {
            //No strike through
            cell.lblStartAt.isHidden        = false
            cell.lblPrice.isHidden          = false
            cell.lblPriceRatio.isHidden     = false
            cell.lblActualPrice.isHidden    = true
            
        }
        else if object.discountPercentage == 100{
            //free
            cell.lblStartAt.isHidden        = true
            cell.lblPrice.isHidden          = false
            cell.lblPriceRatio.isHidden     = true
            cell.lblActualPrice.isHidden    = false
            cell.lblActualPrice.attributedText = actualPrice.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
            cell.lblPrice.text              = AppMessages.Free
        }
        else {
            //strike through will be visible
            cell.lblStartAt.isHidden        = false
            cell.lblPrice.isHidden          = false
            cell.lblPriceRatio.isHidden     = false
            cell.lblActualPrice.isHidden    = false
            cell.lblActualPrice.attributedText = actualPrice.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
        }
        
        if object.planType == "Free" {
            cell.btnBuy.isHidden                = true
            cell.btnCancel.isHidden             = true
            
            cell.lblStartAt.isHidden            = true
            cell.lblPrice.isHidden              = false
            cell.lblPriceRatio.isHidden         = true
            cell.lblActualPrice.isHidden        = true
            cell.lblPrice.text                  = AppMessages.Free
        }
        
        cell.btnBuy.addTapGestureRecognizer {
            self.viewModel.planDetailsAPI(plan_id: object.planMasterId,
                                          withLoader: true) { [weak self] isDone, object1, msg in
                guard let self = self else {return}
                if isDone {
                    let vc = PlanDetailsVC.instantiate(fromAppStoryboard: .setting)
                    vc.plan_id          = object.planMasterId
                    vc.object           = object1
                    vc.isScrollToBuy    = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objTitile   = self.viewModel.getObject(index: indexPath.section)
        let object         = objTitile.planDetails[indexPath.row]
        
        var params              = [String : Any]()
        params[AnalyticsParameters.plan_id.rawValue]            = object.planMasterId
        params[AnalyticsParameters.plan_type.rawValue]          = object.planType
        params[AnalyticsParameters.plan_expiry_date.rawValue]   = object.planEndDate
        
        FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_SUBSCRIPTION_PAGE,
                                 screen: .MyTatvaIndividualPlan,
                                 parameter: params)
        
        self.viewModel.planDetailsAPI(plan_id: object.planMasterId,
                                      withLoader: true) { [weak self] isDone, object1, msg in
            
            guard let self = self else {return}
            
            if isDone {
                let vc = PlanDetailsVC.instantiate(fromAppStoryboard: .setting)
                vc.plan_id = object.planMasterId
                vc.object = object1
                vc.completionHandler = { obj in
                    if obj?.count > 0 {
                        self.isMoveToOthers = true
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = .clear
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension ServicePlanListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Set data Methods --------------------------
extension ServicePlanListVC {
    
    @objc func updateAPIData(){
        DispatchQueue.main.async {
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            self.viewModel.apiCallFromStartPlansList(tblView: self.tblView,
                                                    refreshControl: self.refreshControl,
                                                    plan_type: "I",
                                                    withLoader: false)
        }
    }
    
    func setData(){
        
    }

}

//MARK: -------------------- setupViewModel Observer --------------------
extension ServicePlanListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.setData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if self.isMoveToOthers {
                        self.isMoveToOthers = false
                        
                        if self.tblView.numberOfSections > 0 {
                            let indexPath = IndexPath(item: 0, section: self.tblView.numberOfSections - 1)
                            if let cell = self.tblView.cellForRow(at: indexPath) {
                                self.tblView.scrollToView(view: cell, animated: true)
                            }
                        }
                    }
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
