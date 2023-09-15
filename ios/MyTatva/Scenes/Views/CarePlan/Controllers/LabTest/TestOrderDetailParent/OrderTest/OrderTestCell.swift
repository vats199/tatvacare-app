

import UIKit

class OrderTestCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var lblOldPrice          : UILabel!
    @IBOutlet weak var lblNewPrice          : UILabel!
    
    @IBOutlet weak var lblOffer             : UILabel!
    @IBOutlet weak var vwOffer              : UIView!
    
    @IBOutlet weak var stackInProgress      : UIStackView!
    @IBOutlet weak var lblInProgress        : UILabel!
    @IBOutlet weak var btnTotalPatient      : UIButton!
    
    @IBOutlet weak var lblStatus            : UILabel!
    @IBOutlet weak var lblStatusValue       : UILabel!
    @IBOutlet weak var btnStatusExpand      : UIButton!
    @IBOutlet weak var tblStatus            : UITableView!
    @IBOutlet weak var tblStatusHeight      : NSLayoutConstraint!
    
    var object = LabItem() {
        didSet {
            self.setCellData()
        }
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
      
        self.lblOffer
            .font(name: .medium, size: 7)
            .textColor(color: UIColor.white.withAlphaComponent(1))
        
        self.lblInProgress
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack)
       
        self.btnTotalPatient
            .font(name: .medium, size: 13)
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
        
        self.lblStatus
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblStatusValue
            .font(name: .semibold, size: 14)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.btnStatusExpand.isSelected = false
        self.updateStatusData()
        
        self.setup(tblView: self.tblStatus)
        self.addObserverOnHeightTbl()
        self.manageActionMethods()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            self.vwBg.borderColor(color: UIColor.themeBlack.withAlphaComponent(0.09), borderWidth: 0.5)
            
            self.btnTotalPatient
                .borderColor(color: UIColor.themePurple.withAlphaComponent(1), borderWidth: 1)
                .cornerRadius(cornerRadius: 5)
            
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.cornerRadius(cornerRadius: 5)
        }
    }
    
    func setCellData(){
        let isBCP = object.type == kBCP
        
        self.lblTitle.text          = self.object.data.name
        
        self.lblNewPrice.text       = isBCP ? KFree : CurrencySymbol.INR.rawValue + "\(self.object.data.discountPrice!)"
        self.lblOffer.text          = "\(self.object.data.discountPercent!)% OFF"
        
        if JSON(self.object.data.discountPercent as Any).intValue > 0 && object.type != kBCP {
            self.vwOffer.isHidden   = false
            self.lblOldPrice.text   = CurrencySymbol.INR.rawValue + "\(self.object.data.price!)"
        }
        else {
            self.vwOffer.isHidden   = true
            self.lblOldPrice.text   = ""
        }
        
        self.lblStatusValue.text    = self.object.orderStatus
        
//        let date = GFunction.shared.convertDateFormate(dt: self.object.appointmentDate,
//                                                           inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
//                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
//                                                           status: .NOCONVERSION)
//        self.lblDate.text       = date.0
//        self.lblTime.text       = self.object.appointmentTime
       
        self.stackInProgress.isHidden   = true
        //self.stackCancelled.isHidden    = true
//        self.stackCompleted.isHidden    = true
        
        self.tblStatus.isHidden = true
        self.tblStatus.reloadData()
        
//
//        DispatchQueue.main.async {
//            let type = AppointmentStatus.init(rawValue: self.object.appointmentStatus) ?? .Scheduled
//            self.vwType.backGroundColor(color: UIColor.themeYellow)
//            switch type {
//
//            case .Scheduled:
//                self.lblType.text       = AppMessages.Upcoming//self.object.appointmentStatus
//                self.vwType.backGroundColor(color: UIColor.themeYellow)
//
//                self.stackInProgress.isHidden   = false
//                self.stackCancelled.isHidden    = true
//                self.stackCompleted.isHidden    = true
//
//                break
//            case .Cancelled:
//                self.lblType.text       = self.object.appointmentStatus
//                self.vwType.backGroundColor(color: UIColor.themeRed)
//
//                self.stackInProgress.isHidden   = true
//                self.stackCancelled.isHidden    = false
//                self.stackCompleted.isHidden    = true
//
//                break
//            case .Complete:
//                self.lblType.text       = AppMessages.completed//self.object.appointmentStatus
//                self.vwType.backGroundColor(color: UIColor.themeGreen)
//
//                self.stackInProgress.isHidden   = true
//                self.stackCancelled.isHidden    = true
//                self.stackCompleted.isHidden    = false
//            }
//        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            if let tbl = self.superview as? UITableView {
                
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
    
    func setup(tblView: UITableView) {
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
    }
    
    //MARK: ------------------------- Action Method -------------------------
    func manageActionMethods(){
        
        self.btnStatusExpand.addTapGestureRecognizer {
            self.btnStatusExpand.isSelected = !self.btnStatusExpand.isSelected
            self.updateStatusData()
        }
    }
    
    func updateStatusData(){
        if self.btnStatusExpand.isSelected {
            self.tblStatus.isHidden = false
        }
        else {
            self.tblStatus.isHidden = true
        }
        
        if let tbl = self.superview as? UITableView {
            
            UIView.performWithoutAnimation {
                if #available(iOS 15.0, *) {
                    tbl.performBatchUpdates {
                    } completion: { isDone in
                    }
                    tbl.layoutIfNeeded()
                }
                else {
                    tbl.performBatchUpdates {
                    } completion: { isDone in
                    }
                    tbl.layoutIfNeeded()
                }
            }
        }
    }
}

//MARK: -------------------------- TableView Methods --------------------------
extension OrderTestCell : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.object.orderStatusData != nil {
            return self.object.orderStatusData.count
        }
        return 0
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : OrderSummaryStatusVC = tableView.dequeueReusableCell(withClass: OrderSummaryStatusVC.self, for: indexPath)
        let obj = self.object.orderStatusData[indexPath.row]
        cell.lblNo.text     = "\(obj.index!)"
        cell.lblTitle.text  = obj.status
        cell.lblDate.isHidden = true
        
        cell.vwLineTop?.backGroundColor(color: UIColor.themeLightGray)
        cell.vwLineBottom.backGroundColor(color: UIColor.themeLightGray)
        
        DispatchQueue.main.async {
            if obj.done == "Yes" {
                cell.vwNo.backGroundColor(color: UIColor.themeLightPurple.withAlphaComponent(1))
                cell.vwLineBottom.backGroundColor(color: UIColor.themeLightPurple.withAlphaComponent(1))
                
                cell.lblTitle
                    .font(name: .medium, size: 13)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
                cell.lblDate
                    .font(name: .light, size: 11)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
            }
            else {
                cell.vwNo.backGroundColor(color: UIColor.themeLightGray)
                cell.lblTitle
                    .font(name: .medium, size: 13)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
                cell.lblDate
                    .font(name: .light, size: 11)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
            }
            
            if indexPath.row == 0 {
                cell.vwLineTop?.alpha = 0
                cell.vwLineBottom.alpha = 1
                
            }
            else if indexPath.row == self.object.orderStatusData.count - 1 {
                cell.vwLineTop?.alpha = 1
                cell.vwLineBottom.alpha = 0
            }
            else {
                cell.vwLineTop?.alpha = 1
                cell.vwLineBottom.alpha = 1
            }
        }
    
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension OrderTestCell : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = ""//self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension OrderTestCell {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblStatus, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            
            DispatchQueue.main.async {
                self.tblStatusHeight.constant = newvalue.height
                UIView.animate(withDuration: kAnimationSpeed) {
                   // self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblStatus.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblStatus else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
