//
//  RecordsVC.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import UIKit

enum RecordsAddedBy: String {
    case admin = "A"
    case healthCoach = "H"
    case patient = "P"
    case doctor = "D"
    
    var title: String {
        switch self {
        case .admin:
            return "Uploaded by Admin"
        case .healthCoach:
            return "Uploaded by Health coach"
        case .patient:
            return "Uploaded by Me"
        case .doctor:
            return "Uploaded by Doctor"
        }
    }
    
}

class RecordsContentCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblTime      : UILabel!
    @IBOutlet weak var lblDetail    : UILabel!
    
    @IBOutlet weak var vwType       : UIView!
    @IBOutlet weak var lblType      : UILabel!
    
    @IBOutlet weak var lblupdateBy  : UILabel!
    @IBOutlet weak var colMedia     : UICollectionView!
    
    var object = RecordListModel() {
        didSet {
            self.setCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack)
        self.lblDetail
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.71))
        self.lblTime
            .font(name: .medium, size: 10)
            .textColor(color: UIColor.themeBlack)
        self.lblupdateBy
            .font(name: .medium, size: 10)
            .textColor(color: UIColor.themeBlack)
        self.lblType.font(name: .medium, size: 10).textColor(color: UIColor.white)
        self.setup(colView: self.colMedia)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            self.vwBg.borderColor(color: UIColor.themeBlack.withAlphaComponent(0.09), borderWidth: 0.5)
            
            self.vwType.layoutIfNeeded()
            self.vwType.cornerRadius(cornerRadius: 4)
                .backGroundColor(color: UIColor.themeLightPurple)
        }
    }
    
    func setup(colView: UICollectionView){
        colView.delegate                   = self
        colView.dataSource                 = self
        colView.reloadData()
    }
    
    func setCellData(){
        if let doc = self.object.documentUrl, doc.count > 0 {
            self.colMedia.isHidden = false
            self.colMedia.reloadData()
        }
        else {
            self.colMedia.isHidden = true
        }
        self.lblTitle.text      = self.object.title
        self.lblDetail.text     = self.object.descriptionField
        
        self.vwType.isHidden = true
        if self.object.testName.trim() != "" {
            self.vwType.isHidden    = false
            self.lblType.text       = self.object.testName
        }
        
//        let time = GFunction.shared.convertDateFormate(dt: object.updatedAt,
//                                                           inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
//                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
//                                                           status: .LOCAL)
        
        let time = GFunction.shared.convertDateFormate(dt: self.object.updatedAt,
                                                           inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                           status: .NOCONVERSION)
        self.lblTime.text       = time.0
        
        /*if self.object.addedBy == "D" {
            self.lblupdateBy.text   = "Uploaded by Doctor"
        }
        else if self.object.addedBy == "H" {
            self.lblupdateBy.text   = "Uploaded by Health coach"
        }
        else if self.object.addedBy == "p" {
            self.lblupdateBy.text   = "Uploaded by Me"
        }
        else {
            self.lblupdateBy.text   = "Uploaded by Me"
        }*/
        
        self.lblupdateBy.text = RecordsAddedBy(rawValue: self.object.addedBy)?.title
        
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension RecordsContentCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colMedia:
            if self.object.documentUrl != nil {
                return self.object.documentUrl!.count
            }
            else {
                return 0
            }
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case self.colMedia:
            let cell : AskExpertListMediaCell = collectionView.dequeueReusableCell(withClass: AskExpertListMediaCell.self, for: indexPath)
            
            if self.object.documentUrl != nil {
                let media = self.object.documentUrl!
                if media.count > 0 &&
                    indexPath.item < media.count {
                    
                    let strImage = media[indexPath.item]
                    
                    if strImage.contains(".pdf") {
                        cell.imgTitle.isHidden      = true
                        cell.imgDoc.isHidden        = false
                        
                        cell.imgDoc.image           = UIImage(named: "pdf_ic")
                        cell.imgDoc.contentMode     = .center
                        
                        cell.imgDoc.addTapGestureRecognizer {
                            if let url = URL(string: strImage) {
                                GFunction.shared.openPdf(url: url)
                            }
                        }
                    }
                    else {
                        //for photo
                        cell.imgTitle.isHidden      = false
                        cell.imgDoc.isHidden        = true
                        
                        cell.imgTitle.contentMode   = .scaleAspectFill
                        
                        cell.imgTitle.setCustomImage(with: strImage) { img, err, cache, url in
                            if img != nil {
                                if strImage.trim() != "" {
                                    cell.imgTitle.tapToZoom(with: img)
                                }
                            }
                        }
                        
                        //for test purpose
//                        cell.imgTitle.addTapGestureRecognizer {
//                            if let url = URL(string: strImage) {
//                                if let document = PDFDocument(url: url) {
//                                    let readerController = PDFViewController.createNew(with: document)
//                                    UIApplication.topViewController()?.navigationController?.pushViewController(readerController, animated: true)
//                                }
//                                else {
//                                    Downloader.load(URL: url)
//                                }
//                            }
//                        }
                    }
                }
            }
                //cell.imgTitle.tapToZoom(with: cell.imgTitle.image ?? UIImage())
            DispatchQueue.main.async {
                cell.vwBg.layoutIfNeeded()
                cell.vwBg.cornerRadius(cornerRadius: 10)
                    .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
            }
            
            return cell
       
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colMedia:
            
            
            
            break
        
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
            
        case self.colMedia:
            //let obj         = self.arrTitle[indexPath.item]
            //let width       = obj["name"].stringValue.width(withConstraintedHeight: 18.0, font: UIFont.customFont(ofType: .semibold, withSize: 18.0))
            let width       = self.colMedia.frame.size.width / 2.5
            let height      = self.colMedia.frame.size.height
            
            return CGSize(width: width,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
}

class RecordsVC: ClearNavigationFontBlackBaseVC {
    
    //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var vwUploadParent   : UIView!
    @IBOutlet weak var vwUpload         : UIView!
    @IBOutlet weak var lblUpload        : UILabel!
    @IBOutlet weak var imgUpload        : UIImageView!
    @IBOutlet weak var tblView          : UITableView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                       = RecordsVM()
    let refreshControl                  = UIRefreshControl()
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
        
        DispatchQueue.main.async {
            self.vwUpload.layoutIfNeeded()
            self.imgUpload.layoutIfNeeded()
            self.lblUpload.font(name: .medium, size: 16).textColor(color: UIColor.ThemeDarkBlack.withAlphaComponent(0.5))
            self.vwUpload.cornerRadius(cornerRadius: 5)
            self.vwUpload.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            
        }
        
        self.configureUI()
        self.manageActionMethods()
        
        if self.isGloabalSearch {
            self.vwUploadParent.isHidden = true
        }
      
    }
    
    @objc func updateAPIData(){
        DispatchQueue.main.asyncAfter(deadline: .now()){
            let withLoader = false
            self.refreshControl.beginRefreshing()
            self.tblView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.height)
            
            self.strErrorMessage = ""
            self.timerSearch.invalidate()
            self.timerSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.viewModel.apiCallFromStartRecord(tblView: self.tblView,
                                                      refreshControl: self.refreshControl,
                                                      withLoader: withLoader,
                                                      search: self.strSearch)
            }
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
        self.tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
           
        DispatchQueue.main.async {
           
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        self.vwUpload.addTapGestureRecognizer {
            let vc = UploadRecordVC.instantiate(fromAppStoryboard: .setting)
            self.navigationController?.pushViewController(vc, animated: true)
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .HistoryRecord)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.updateAPIData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = self.parent?.parent as? TabbarVC {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension RecordsVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : RecordsContentCell = tableView.dequeueReusableCell(withClass: RecordsContentCell.self, for: indexPath)
    
        let object = self.viewModel.getObject(index: indexPath.row)
        cell.object = object
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var params              = [String : Any]()
        params[AnalyticsParameters.patient_records_id.rawValue]  = self.viewModel.getObject(index: indexPath.row).patientRecordsId
        FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_RECORD,
                                 screen: .HistoryRecord,
                                 parameter: params)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.managePagenation(tblView: self.tblView,
                                                  refreshControl: self.refreshControl,
                                                  index: indexPath.row,
                                                  search: self.strSearch)
        
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension RecordsVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension RecordsVC {
    
    fileprivate func setData(){
        
    }
}

//MARK: -------------------- GlobalSearch Methods --------------------
extension RecordsVC {
    
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
extension RecordsVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.tblView.reloadData()
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
