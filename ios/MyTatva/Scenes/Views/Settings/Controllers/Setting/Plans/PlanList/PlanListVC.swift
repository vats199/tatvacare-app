//
//  HelpAndSupportVC.swift
//  MyTatva
//
//  Created by hyperlink on 26/10/21.
//

import UIKit

class PlanListTitleCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 18)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.borderColor(color: UIColor.ThemeBorder, borderWidth: 0)
        }
    }
}

class PlanListCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var vwGradient           : UIView!
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var lblDesc              : UILabel!
    @IBOutlet weak var lblWhatIncluded      : UILabel!
    @IBOutlet weak var lblDesc2             : UILabel!
    
    @IBOutlet weak var lblMore              : UILabel!
    @IBOutlet weak var imgMore              : UIImageView!
    
    @IBOutlet weak var lblStartAt           : UILabel!
    @IBOutlet weak var lblActualPrice       : UILabel!
    @IBOutlet weak var lblPrice             : UILabel!
    @IBOutlet weak var lblPriceRatio        : UILabel!
    @IBOutlet weak var btnCancel            : UIButton!
    @IBOutlet weak var btnBuy               : UIButton!
    
    @IBOutlet weak var vwSepPurchaseDate    : UIView!
    @IBOutlet weak var stackPurchaseDate    : UIStackView!
    @IBOutlet weak var lblPurchaseDate      : UILabel!
    @IBOutlet weak var lblPurchaseDateVal   : UILabel!
    
    @IBOutlet weak var lblNextPurchase      : UILabel!
    @IBOutlet weak var lblNextPurchaseVal   : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblDesc
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
        
        self.lblWhatIncluded
            .font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblDesc2
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblMore
            .font(name: .semibold, size: 12)
            .textColor(color: UIColor.themePurple)
        
        self.lblPurchaseDate
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblPurchaseDateVal
            .font(name: .semibold, size: 12)
            .textColor(color: UIColor.themeBlack)
        
        self.lblNextPurchase
            .font(name: .regular, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblNextPurchaseVal
            .font(name: .semibold, size: 12)
            .textColor(color: UIColor.themeBlack)
        
        self.lblActualPrice
            .font(name: .regular, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblStartAt
            .font(name: .regular, size: 16)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblPrice
            .font(name: .semibold, size: 18)
            .textColor(color: UIColor.themeBlack)
        self.lblPriceRatio
            .font(name: .semibold, size: 13)
            .textColor(color: UIColor.themeBlack)
        
        self.btnCancel
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
            .backGroundColor(color: UIColor.themePurple)
        self.btnBuy
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
            .backGroundColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.borderColor(color: UIColor.ThemeBorder, borderWidth: 0)
            self.vwBg.themeShadow()
            
            self.btnCancel.layoutIfNeeded()
            self.btnBuy.layoutIfNeeded()
            self.btnCancel.cornerRadius(cornerRadius: 5)
            self.btnBuy.cornerRadius(cornerRadius: 5)
            
        }
    }
}

class PlanListVC: ClearNavigationFontBlackBaseVC {
    //MARK: ------------------ UIControl's Outlets ------------------
    @IBOutlet weak var tblView      : UITableView!
    
    //MARK: ------------------ Class Variables ------------------
    let viewModel                   = PlanListVM()
    let refreshControl              = UIRefreshControl()
    var strErrorMessage : String    = ""
    var isMoveToOthers              = false
    
    //MARK: ------------------ Memory management  Methods ------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: ------------------ Custome  Methods ------------------
    
    //Desc:- Centre method to call in View
    func setUpView(){
        
        self.configureUI()
        self.manageActionMethods()
        
    }
    
    @objc func updateAPIData(){
        DispatchQueue.main.async {
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            self.viewModel.apiCallFromStartPlansList(tblView: self.tblView,
                                                    refreshControl: self.refreshControl,
                                                    plan_type: "S",
                                                    withLoader: false)
        }
    }
    
    //Desc:- Set layout desing customize
    func configureUI(){
        
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.emptyDataSetSource         = self
        self.tblView.emptyDataSetDelegate       = self
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.rowHeight                  = UITableView.automaticDimension
        self.tblView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: Double.leastNormalMagnitude))
        self.tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
        
    }
    
    //MARK: ------------------ Action Methods ------------------
    func manageActionMethods(){
    }
    
    //MARK: ------------------ View life cycle Methods ------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .MyTatvaPlans)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.updateAPIData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .HelpSupportFaq, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //FIRAnalytics.manageTimeSpent(on: .HelpSupportFaq, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
}


//MARK: ------------------ UITableView Methods ------------------
extension PlanListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : PlanListTitleCell = tableView.dequeueReusableCell(withClass: PlanListTitleCell.self)

        let obj             = self.viewModel.getObject(index: section)
        
        cell.lblTitle.text  = ""
        if self.viewModel.getPlansCount(index: 0) > 0 {
            cell.lblTitle.text  = obj.title
        }
        return cell.contentView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getObject(index: section).planDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PlanListCell = tableView.dequeueReusableCell(withClass: PlanListCell.self, for: indexPath)
        
        let objTitle    = self.viewModel.getObject(index: indexPath.section)
        let object      = objTitle.planDetails[indexPath.row]
        
        cell.imgTitle.setCustomImage(with: object.imageUrl, placeholder: UIImage(named: "defaultUser"))
        
        let themeColor = UIColor.init(hexString: object.colourScheme)
        cell.lblTitle
            .font(name: .bold, size: 18)
            .textColor(color: themeColor)
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .semibold, withSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        
        func setDesc(){
            cell.lblDesc2.text = ""
            DispatchQueue.global(qos: .background).async {
                if object.descriptionFieldHTML == nil {
                    object.descriptionFieldHTML = object.descriptionField.htmlToMutableAttributedString?.string ?? ""
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    cell.lblDesc2.text      = object.descriptionFieldHTML
                    
                    self.tblView.performBatchUpdates {
                    }
                    let colorBg = GFunction.shared.applyGradientColor(startColor: UIColor.white,
                                                                      endColor: themeColor.withAlphaComponent(0.001),
                                                                      locations: [0.5, 1],
                                                                      startPoint: CGPoint(x: 0, y: cell.vwGradient.frame.maxY),
                                                                      endPoint: CGPoint(x: cell.vwGradient.frame.maxX, y: 0),
                                                                      gradiantWidth: cell.vwGradient.frame.width,
                                                                      gradiantHeight: cell.vwGradient.frame.height)
                    cell.vwGradient.layoutIfNeeded()
                    cell.vwGradient.backGroundColor(color: UIColor.white)
                    cell.vwGradient.backGroundColor(color: colorBg.withAlphaComponent(0.5))
                }
            }
        }
       
        setDesc()
        DispatchQueue.main.async {
            cell.lblTitle.text      = ""
            cell.lblDesc.text       = ""
            
            cell.lblTitle.text      = object.planName
            cell.lblDesc.text       = object.subTitle
            
            self.tblView.performBatchUpdates {
            }
        }
        
//        cell.lblDesc2.text  = obj.descriptionField.htmlToString
//        cell.lblDesc2.attributedText = NSAttributedString(html: obj.descriptionField)

        cell.lblMore
            .font(name: .semibold, size: 12)
            .textColor(color: themeColor)
        cell.imgMore.tintColor = themeColor
        
        cell.btnBuy.backGroundColor(color: themeColor)
        cell.btnCancel.backGroundColor(color: themeColor)
        
        let startDate = GFunction.shared.convertDateFormate(dt: object.planStartDate,
                                                       inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddMMyyyy.rawValue,
                                                       status: .NOCONVERSION)
        let endDate = GFunction.shared.convertDateFormate(dt: object.planEndDate,
                                                       inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.ddMMyyyy.rawValue,
                                                       status: .NOCONVERSION)
       
        cell.vwSepPurchaseDate.isHidden     = true
        cell.stackPurchaseDate.isHidden     = true
        cell.btnCancel.isHidden             = true
        cell.btnBuy.isHidden                = true
        cell.lblPriceRatio.isHidden         = true
        cell.lblStartAt.isHidden            = true
        var actualPrice                     = ""
        if objTitle.title.lowercased().contains("other".lowercased()){
            cell.vwSepPurchaseDate.isHidden     = true
            cell.stackPurchaseDate.isHidden     = true
            cell.btnCancel.isHidden             = true
            cell.btnBuy.isHidden                = false
            cell.lblPriceRatio.isHidden         = false
            cell.lblStartAt.isHidden            = false
            cell.lblPrice.text  = appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(object.startAt!).doubleValue.floorToPlaces(places: 0))
            
            actualPrice = appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(object.actualPrice!).doubleValue.floorToPlaces(places: 0))
            
        }
        else if objTitle.title.lowercased().contains("my".lowercased()){
            cell.vwSepPurchaseDate.isHidden     = false
            cell.stackPurchaseDate.isHidden     = false
            cell.btnCancel.isHidden             = false
            cell.btnBuy.isHidden                = true
            cell.lblPriceRatio.isHidden         = false
            cell.lblStartAt.isHidden            = true
            cell.lblPrice.text = appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(object.iosPerMonthPrice!).doubleValue.floorToPlaces(places: 0))
            
            actualPrice = appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(object.actualPrice!).doubleValue.floorToPlaces(places: 0))
            
            cell.lblPurchaseDateVal.text    = startDate.0
            cell.lblNextPurchaseVal.text    = endDate.0
            
        }
        else if objTitle.title.lowercased().contains("Inactive".lowercased()){
            cell.vwSepPurchaseDate.isHidden     = false
            cell.stackPurchaseDate.isHidden     = false
            cell.btnCancel.isHidden             = false
            cell.btnBuy.isHidden                = true
            cell.lblPriceRatio.isHidden         = false
            cell.lblStartAt.isHidden            = true
            cell.lblPrice.text = appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(object.iosPerMonthPrice!).doubleValue.floorToPlaces(places: 0))
            
            actualPrice = appCurrencySymbol.rawValue + "" + String(format: "%.f", JSON(object.actualPrice!).doubleValue.floorToPlaces(places: 0))
            
            cell.lblPurchaseDateVal.text    = startDate.0
            cell.lblNextPurchaseVal.text    = endDate.0
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
            cell.vwSepPurchaseDate.isHidden     = true
            cell.stackPurchaseDate.isHidden     = true
            cell.btnBuy.isHidden                = true
            cell.btnCancel.isHidden             = true
                                
            cell.lblStartAt.isHidden            = true
            cell.lblPrice.isHidden              = false
            cell.lblPriceRatio.isHidden         = true
            cell.lblActualPrice.isHidden        = true
            cell.lblPrice.text                  = AppMessages.Free
        }
        
        func openDetails(isScrollToBuy: Bool, action: PlanActionParameter){
            var params              = [String : Any]()
            params[AnalyticsParameters.plan_id.rawValue]            = object.planMasterId
            params[AnalyticsParameters.plan_type.rawValue]          = object.planType
            params[AnalyticsParameters.plan_expiry_date.rawValue]   = object.planEndDate
            params[AnalyticsParameters.action.rawValue]             = action.rawValue
            
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_SUBSCRIPTION_PAGE,
                                     screen: .MyTatvaPlans,
                                     parameter: params)
            
            self.viewModel.planDetailsAPI(plan_id: object.planMasterId,
                                          withLoader: true) { [weak self] isDone, object1, msg in
                guard let self = self else {return}
                if isDone {
                    let vc = PlanDetailsVC.instantiate(fromAppStoryboard: .setting)
                    vc.plan_id          = object.planMasterId
                    vc.object           = object1
                    vc.isScrollToBuy    = isScrollToBuy
                    vc.completionHandler = { obj in
                        if obj?.count > 0 {
                            self.isMoveToOthers = true
                        }
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        cell.btnBuy.addTapGestureRecognizer {
            openDetails(isScrollToBuy: true,
                        action: .buy)
        }
        
        cell.lblMore.addTapGestureRecognizer {
            openDetails(isScrollToBuy: false,
                        action: .moreDetails)
        }
        
        cell.vwBg.addTapGestureRecognizer {
            openDetails(isScrollToBuy: false,
                        action: .card)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

//MARK: ------------------ Empty TableView Methods ------------------
extension PlanListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension PlanListVC {
    fileprivate func setData(){
    }
}

//MARK: ------------------ setupViewModel Observer ------------------
extension PlanListVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
              // Success handle
                
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.setData()
                self.tblView.reloadData()
                
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

