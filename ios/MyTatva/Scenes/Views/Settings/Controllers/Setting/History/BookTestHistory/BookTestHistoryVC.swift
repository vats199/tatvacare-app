//
//  RecordsVC.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import UIKit

enum LabStateStatus: String {
    case Pending        = "YET TO ASSIGN"
    case ASSIGNED// Phlebo assigned on order.
    case PERSUASION// Thyrocare customer service Team is trying to reach customer via call to confirm address or any other input from customer’s end necessary for order to be fulfilled.
    case ACCEPTED// Customer agreed on pre-visit call that he/she will be available at given address for Phlebo visit/sample collection.
    case RESCHEDULED// Oder rescheduled as per customer request or due to any issue from Thyrocare service team.
    case SERVICED// Sample collection done, Phlebo visited the customer location of customer    and serviced on the order.
    case DONE// Report shared to customer, order all done.End.
    case CANCELLED// Oder cancelled due to request from custoemr's side or any issue from service team's side.
}

//YET TO ASSIGN
//ACCEPTED
//SERVICED
//DONE

class BookTestHistoryCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var stackType            : UIStackView!
    @IBOutlet weak var vwType               : UIView!
    @IBOutlet weak var lblType              : UILabel!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var lblOldPrice          : UILabel!
    @IBOutlet weak var lblNewPrice          : UILabel!
    
    @IBOutlet weak var lblDate              : UILabel!
    @IBOutlet weak var lblTime              : UILabel!
    
    @IBOutlet weak var stackInProgress      : UIStackView!
    @IBOutlet weak var stackCancelled       : UIStackView!
    @IBOutlet weak var stackCompleted       : UIStackView!
    
    @IBOutlet weak var lblInProgress        : UILabel!
    @IBOutlet weak var lblCancelled         : UILabel!
    @IBOutlet weak var lblCompleted         : UILabel!
    
    @IBOutlet weak var btnCancelOrder       : UIButton!
    @IBOutlet weak var btnDownloadReports   : UIButton!
    
    @IBOutlet weak var lblOrderNo           : UILabel!
    @IBOutlet weak var lblTotalItem         : UILabel!
    
    var object = LabTestHistoryModel() {
        didSet {
            self.setCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblType
            .font(name: .medium, size: 11)
            .textColor(color: UIColor.white)
        
        self.lblTitle
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblDate
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblTime
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.lblCancelled
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themePurple.withAlphaComponent(0.8))
        self.lblCompleted
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themePurple)
        self.lblInProgress
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack)
        
        self.btnCancelOrder
            .font(name: .medium, size: 12)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.btnDownloadReports
            .font(name: .medium, size: 12)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblOldPrice
            .font(name: .regular, size: 10)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        self.lblNewPrice
            .font(name: .regular, size: 18)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        let defaultDicQue : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.customFont(ofType: .semibold, withSize: 10),
            NSAttributedString.Key.foregroundColor : UIColor.themeBlack.withAlphaComponent(0.6) as Any,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue as Any
        ]
        self.lblOldPrice.attributedText = self.lblOldPrice.text!.getAttributedText(defaultDic: defaultDicQue, attributeDic: defaultDicQue, attributedStrings: [""])
     
        self.lblOrderNo
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        self.lblTotalItem
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            self.vwBg.borderColor(color: UIColor.themeBlack.withAlphaComponent(0.09), borderWidth: 0.5)
            
            self.vwType.layoutIfNeeded()
            self.vwType.cornerRadius(cornerRadius: 4)
                .backGroundColor(color: UIColor.themeYellow)
            
            self.btnCancelOrder
                .borderColor(color: UIColor.themePurple.withAlphaComponent(1), borderWidth: 1)
                .cornerRadius(cornerRadius: 5)
            
            self.btnDownloadReports
                .borderColor(color: UIColor.themePurple.withAlphaComponent(1), borderWidth: 1)
                .cornerRadius(cornerRadius: 5)
            
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.cornerRadius(cornerRadius: 5)
        }
    }
    
    func setCellData(){
        
        //self.imgTitle.setCustomImage(with: self.object.profilePicture)
        self.lblTitle.text          = self.object.name
        
        let date = GFunction.shared.convertDateFormate(dt: self.object.appointmentDate,
                                                       inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                       outputFormat: DateTimeFormaterEnum.EEEddMMMM.rawValue,
                                                       status: .NOCONVERSION)
        self.lblDate.text       = date.0
        self.lblTime.text       = self.object.slotTime
        self.lblOldPrice.text   = ""//CurrencySymbol.INR.rawValue + "\(self.object.payableAmount!)"
        self.lblNewPrice.text   = CurrencySymbol.INR.rawValue + "\(self.object.finalPayableAmount!)"
        self.lblOrderNo.text    = AppMessages.OrderNo + " : " + self.object.refOrderId
        self.lblTotalItem.text  = AppMessages.Items + " : " + "\(self.object.totalItems!)"
        
        self.stackInProgress.isHidden   = true
        self.stackCancelled.isHidden    = true
        self.stackCompleted.isHidden    = true
        self.btnCancelOrder.isHidden    = true
        
        if self.object.bcpTestPriceData != nil {
            let finalPrice = JSON(self.object.bcpTestPriceData.bcpFinalAmountToPay as Any).intValue
            self.lblNewPrice.text   = finalPrice == 0 ? KFree : CurrencySymbol.INR.rawValue + "\(finalPrice)"
        }
        
        self.lblType.text               = self.object.orderStatus
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            let type = LabStateStatus.init(rawValue: self.object.orderStatus) ?? .Pending
            self.vwType.backGroundColor(color: UIColor.themeYellow)
            self.lblType.text       = self.object.orderStatus//AppMessages.Upcoming
            switch type {
                
            case .Pending:
                self.vwType.backGroundColor(color: UIColor.themeYellow)
                
                self.stackInProgress.isHidden   = true
                self.stackCancelled.isHidden    = true
                self.stackCompleted.isHidden    = true
                
                break
                
            case .ASSIGNED:
                self.vwType.backGroundColor(color: UIColor.themeYellow)
                
                self.stackInProgress.isHidden   = true
                self.stackCancelled.isHidden    = true
                self.stackCompleted.isHidden    = true
                
                break
                
            case .PERSUASION:
                self.vwType.backGroundColor(color: UIColor.themeYellow)
                
                self.stackInProgress.isHidden   = true
                self.stackCancelled.isHidden    = true
                self.stackCompleted.isHidden    = true
                
                break
           
            case .ACCEPTED:
                //                self.lblType.text       = self.object.status
                self.vwType.backGroundColor(color: UIColor.themeYellow)
                
                self.stackInProgress.isHidden   = true
                self.stackCancelled.isHidden    = true
                self.stackCompleted.isHidden    = true
                
                break
                
            case .RESCHEDULED:
                //                self.lblType.text       = self.object.status
                self.vwType.backGroundColor(color: UIColor.themeYellow)
                
                self.stackInProgress.isHidden   = true
                self.stackCancelled.isHidden    = true
                self.stackCompleted.isHidden    = true
                
                break
                
            case .SERVICED:
                //                self.lblType.text       = AppMessages.completed//self.object.appointmentStatus
                self.vwType.backGroundColor(color: UIColor.themeGreen)
                
                self.stackInProgress.isHidden   = true
                self.stackCancelled.isHidden    = true
                self.stackCompleted.isHidden    = true
                break
                
            case .DONE:
                //                self.lblType.text       = AppMessages.completed//self.object.appointmentStatus
                self.vwType.backGroundColor(color: UIColor.themeGreen)
                
                self.stackInProgress.isHidden   = true
                self.stackCancelled.isHidden    = true
                self.stackCompleted.isHidden    = true
                break
                
            case .CANCELLED:
                //                self.lblType.text       = AppMessages.completed//self.object.appointmentStatus
                self.vwType.backGroundColor(color: UIColor.themeGreen)
                
                self.stackInProgress.isHidden   = true
                self.stackCancelled.isHidden    = true
                self.stackCompleted.isHidden    = true
                break
                
            }
            self.stackCompleted.isHidden    = false
            self.lblCompleted.isHidden      = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            if let tbl = self.superview as? UITableView {

                UIView.performWithoutAnimation {
                    if #available(iOS 15.0, *) {
                        tbl.performBatchUpdates {
                        } completion: { isDone in
                        }
                        tbl.layoutIfNeeded()
                    }
                    else {
                    }
                }
            }
        }
    }
}

class BookTestHistoryVC: ClearNavigationFontBlackBaseVC {
    
    //----------------------------------
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var tblView              : UITableView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                       = BookTestHistoryVM()
    let refreshControl                  = UIRefreshControl()
    var isShowDoc                       = false
    var timerSearch                     = Timer()
    var strErrorMessage : String        = ""
    var isGloabalSearch                 = false
    var strSearch                       = ""
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
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchDidUpdate(_:)), name: kPostSearchData, object: nil)
//        self.lblSelectClinic
//            .font(name: .semibold, size: 14)
//            .textColor(color: UIColor.themeBlack)
        
        
        self.configureUI()
        self.manageActionMethods()
    }
    
    @objc func updateAPIData(){
        DispatchQueue.main.asyncAfter(deadline: .now()){
            let withLoader = false
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.viewModel.apiCallFromStart_TestHistory(tblView: self.tblView,
                                                            refreshControl: self.refreshControl,
                                                            withLoader: withLoader,
                                                            search: self.strSearch)
            }
        }
    }
    //Desc:- Set layout desing customize
    
    func configureUI(){
    
        DispatchQueue.main.async {
//            self.vwSelectClinic.layoutIfNeeded()
//            self.vwSelectClinic.cornerRadius(cornerRadius: 5)
//            self.vwSelectClinic.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
           
        }
        
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
//        self.btnBookAppointment.addTapGestureRecognizer {
//            let vc = BookAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .HistoryTest)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.updateAPIData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = self.parent?.parent as? TabbarVC {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        //FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension BookTestHistoryVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : BookTestHistoryCell = tableView.dequeueReusableCell(withClass: BookTestHistoryCell.self, for: indexPath)
        let object = self.viewModel.getObject(index: indexPath.row)
        cell.object = object
//        cell.setCellData()

//        cell.btnCancelOrder.addTapGestureRecognizer {
//            Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.cancelAppointmentMessage) { (isDone) in
//                if isDone {
//
//                    var type_consult = "video"
//                    if object.appointmentType == "in clinic" {
//                        type_consult = "clinic"
//                    }
//
////                    self.viewModel.cancelAppointmentAPI(appointment_id: object.appointmentId,
////                                                        clinic_id: object.clinicId,
////                                                        doctor_id: object.doctorId,
////                                                        type_consult: type_consult,
////                                                        appointment_date: object.appointmentDate,
////                                                        appointment_slot: object.appointmentTime) { isDone, msg in
////                        if isDone {
////                            self.updateAPIData(withLoader: false)
////                        }
////                    }
//                }
//            }
//        }
//
//
//
        cell.btnDownloadReports.addTapGestureRecognizer {
            self.viewModel.get_download_reportAPI(order_master_id: object.orderMasterId) { isDone, msg, link in
                if isDone {
                    if let url = URL(string: link) {
                        GFunction.shared.openPdf(url: url)
                    }
                }
            }
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var params              = [String : Any]()
//        params[AnalyticsParameters.patient_records_id.rawValue]  = self.viewModel.getRecordObject(index: indexPath.row).patientRecordsId
        //FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_RECORD, parameter: params)
        
        let object = self.viewModel.getObject(index: indexPath.row)
        
        var params1 = [String: Any]()
        params1[AnalyticsParameters.order_master_id.rawValue]  = object.orderMasterId
        FIRAnalytics.FIRLogEvent(eventName: .LABTEST_HISTORY_CARD_CLICKED,
                                 screen: .HistoryTest,
                                 parameter: params1)
        
        let vc = TestOrderDetailParentVC.instantiate(fromAppStoryboard: .carePlan)
        vc.order_master_id = object.orderMasterId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.managePagenation(tblView: tableView,
                                        index: indexPath.row,
                                        search: self.strSearch)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension BookTestHistoryVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension BookTestHistoryVC {
    
    fileprivate func setData(){
    }
}

//MARK: -------------------- GlobalSearch Methods --------------------
extension BookTestHistoryVC {
    
    @objc func searchDidUpdate(_ notification: NSNotification) {
        if let _ = self.parent {
            if let searchKeyword = notification.userInfo?["search"] as? String {
                self.strSearch = searchKeyword
                self.updateAPIData()
             }
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension BookTestHistoryVC {
    
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
