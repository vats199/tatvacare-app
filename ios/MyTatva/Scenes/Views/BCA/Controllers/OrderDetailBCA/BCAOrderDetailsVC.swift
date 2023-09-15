//
//  BCAOrderDetailsVC.swift
//  MyTatva
//
//  Created by Hyperlink on 31/05/23.
//  Copyright © 2023. All rights reserved.

import UIKit

class BCAOrderDetailsVC: ClearNavigationFontBlackBaseVC {

    //MARK: Outlet
    @IBOutlet weak var vwBg                                 : UIView!
    @IBOutlet weak var svBg                                 : UIStackView!
    @IBOutlet weak var btnHelp                              : UIButton!
    
    // ---------- Plan Details --------------
    @IBOutlet weak var lblPlanDetails                       : UILabel!
    @IBOutlet weak var vwPlanDetails                        : UIView!
    @IBOutlet weak var lblName                              : UILabel!
    @IBOutlet weak var lblAddress                           : UILabel!
    @IBOutlet weak var lblEmail                             : UILabel!
    @IBOutlet weak var lblMobileNumber                      : UILabel!
    @IBOutlet weak var lblOrderId                           : UILabel!
    @IBOutlet weak var lblPurchaseDate                      : UILabel!
    @IBOutlet weak var lblHtmlContent                       : UILabel!
    
    // ---------- Device Details ------------
    @IBOutlet weak var lblDEviceDetails                     : UILabel!
    @IBOutlet weak var vwDeviceDetails                      : UIView!
    @IBOutlet weak var lblDeviceName                        : UILabel!
    @IBOutlet weak var lblPlacedOnDate                      : UILabel!
    @IBOutlet weak var lblStatus                            : UILabel!
    @IBOutlet weak var btnShowHide                          : UIButton!
    @IBOutlet weak var tblOrderTrack                        : UITableView!
    @IBOutlet weak var tblHeightConstantForOrderTracking    : NSLayoutConstraint!
    
    // ---------- Test Details ------------
    @IBOutlet weak var lblTestDetails                       : UILabel!
    @IBOutlet weak var vwTestDetails                        : UIView!
    @IBOutlet weak var tblTestDetails                       : UITableView!
    @IBOutlet weak var tblHeightConstantForTestDetails      : NSLayoutConstraint!
    
    // ---------- Billing ------------
    @IBOutlet weak var lblBilling                           : UILabel!
    @IBOutlet weak var vwBilling                            : UIView!
    @IBOutlet weak var svActualPrice                        : UIStackView!
    @IBOutlet weak var lblActualPrice                       : UILabel!
    @IBOutlet weak var lblActualPriceValue                  : UILabel!
    @IBOutlet weak var svDiscountPrice                      : UIStackView!
    @IBOutlet weak var lblDiscountPrice                     : UILabel!
    @IBOutlet weak var lblDiscountPriceValue                : UILabel!
    @IBOutlet weak var svPurchasePrice                      : UIStackView!
    @IBOutlet weak var lblPurchasePrice                     : UILabel!
    @IBOutlet weak var lblPurchasePriceValue                : UILabel!
    @IBOutlet weak var svGST                                : UIStackView!
    @IBOutlet weak var lblGST                               : UILabel!
    @IBOutlet weak var lblGSTValue                          : UILabel!
    
    @IBOutlet weak var lblAmountPaid                        : UILabel!
    @IBOutlet weak var lblAmoutValue                        : UILabel!
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel: BCAOrderDetailsViewModel!
    var strErrorMessage : String        = ""
    
    var arrTrack : [JSON] = [
        [
            "id" : 1,
            "title" : "Device Yet To dispatch",
            "date": "Fri, 08 Jan 03:02 Pm",
        ],
        [
            "id" : 2,
            "title" : "Dispatched",
            "date": "Fri, 08 Jan 03:02 Pm",
        ],
    ]
	
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(BCAOrderDetailsVC.self) ‼️‼️‼️")
        self.removeObserverOnHeightTbl()
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.addObserverOnHeightTbl()
        self.applyStyle()
        self.configUI()
        self.setup(tblView: self.tblTestDetails)
        self.setup(tblView: self.tblOrderTrack)
        self.manageAction()
    }
    
    private func applyStyle() {
        self.lblPlanDetails
            .font(name: .bold, size: 15)
            .textColor(color: .themeBlack.withAlphaComponent(1))
            .text = "Plan details"
        self.lblDEviceDetails
            .font(name: .bold, size: 15)
            .textColor(color: .themeBlack.withAlphaComponent(1))
            .text = "Device Detail"
        self.lblTestDetails
            .font(name: .bold, size: 15)
            .textColor(color: .themeBlack.withAlphaComponent(1))
            .text = "Test Details"
        self.lblBilling
            .font(name: .bold, size: 17)
            .textColor(color: .themeBlack.withAlphaComponent(1))
            .text = "Billing"
        
        self.lblName
            .font(name: .bold, size: 13).textColor(color: .themeBlack.withAlphaComponent(1))
            .text = "Name"
        self.lblAddress
            .font(name: .regular, size: 11).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "Address"
        self.lblEmail
            .font(name: .regular, size: 11).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "abc@email.com"
        self.lblMobileNumber
            .font(name: .regular, size: 11).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "+91-9990000000"
        
        self.lblOrderId
            .font(name: .regular, size: 11).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "Order ID: VL39670"
        self.lblPurchaseDate
            .font(name: .regular, size: 11).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "Purchased On: Fri, 08 Jul, 2022"
        
        self.lblDeviceName
            .font(name: .regular, size: 11).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "Device Name : Body Composition Analysis Machine"
        self.lblPlacedOnDate
            .font(name: .regular, size: 11).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "Ordered Placed On : Fri, 18 Mar, 2022"
        
        self.lblStatus
            .font(name: .medium, size: 13).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "Status :  Order Accepted"
        
        self.btnShowHide
            .font(name: .medium, size: 11).textColor(color: .themePurple.withAlphaComponent(1)).isSelected = true
        
        self.lblActualPrice
            .font(name: .regular, size: 11).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "Actual Price (MRP)"
        self.lblActualPriceValue
            .font(name: .medium, size: 13).textColor(color: .themeBlack.withAlphaComponent(1))
            .text = "₹ 1,200"
        
        self.lblDiscountPrice
            .font(name: .regular, size: 11).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "Discount Price"
        self.lblDiscountPriceValue
            .font(name: .medium, size: 13).textColor(color: .themeBlack.withAlphaComponent(1))
            .text = "₹ 1,200"
        
        self.lblPurchasePrice
            .font(name: .regular, size: 11).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "Purchase Price"
        self.lblPurchasePriceValue
            .font(name: .medium, size: 13).textColor(color: .themeBlack.withAlphaComponent(1))
            .text = "₹ 500"
        
        self.lblGST
            .font(name: .regular, size: 11).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "GST%"
        self.lblGSTValue
            .font(name: .medium, size: 13).textColor(color: .themeBlack.withAlphaComponent(1))
            .text = "₹ 300"
        
        self.lblAmountPaid
            .font(name: .bold, size: 13).textColor(color: .themeBlack.withAlphaComponent(1))
            .text = "Amount Paid"
        self.lblAmoutValue
            .font(name: .bold, size: 13).textColor(color: .themeBlack.withAlphaComponent(1))
            .text = "₹ 1,999"
        self.setAttributedLabels()
        self.setHtmlContent()
    }
    
    func setup(tblView: UITableView) {
        
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
//        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
    }
    
    func setAttributedLabels() {
        self.lblOrderId.setAttributesForOrders(str: "VL39670")
        self.lblPurchaseDate.setAttributesForOrders(str: "Fri, 08 Jul, 2022")
        self.lblDeviceName.setAttributesForOrders(str: "Body Composition Analysis Machine")
        self.lblPlacedOnDate.setAttributesForOrders(str: "Fri, 18 Mar, 2022")
        self.lblStatus.setAttributesForOrders(defFont: UIFont.customFont(ofType: .medium, withSize: 13), attrFont: UIFont.customFont(ofType: .bold, withSize: 13), str: "Order Accepted")
    }
    
    func setHtmlContent(str: String = "<h6>MyTatva offers Personalised Care Plans Fatty Liver disease (NASH/ NAFLD). Get dedicated support and comprehensive care tailored to your needs.</h6>") {
        self.lblHtmlContent.text = str.htmlToString
    }
    
    func configUI() {
        DispatchQueue.main.async {
            self.vwPlanDetails
                .cornerRadius(cornerRadius: 12)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
            
            self.vwDeviceDetails
                .cornerRadius(cornerRadius: 12)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
            
            self.vwTestDetails
                .cornerRadius(cornerRadius: 12)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
            
            self.vwBilling
                .cornerRadius(cornerRadius: 12)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
        }
    }
    
    
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    func manageAction() {
        self.btnShowHide.addAction(for: .touchUpInside) {
            self.btnShowHide.isSelected.toggle()
            self.tblOrderTrack.isHidden = !self.btnShowHide.isSelected
            self.btnShowHide.setTitle(self.btnShowHide.isSelected ? "View" : "Hide", for: .normal)
        }
        
        self.btnHelp.addAction(for: .touchUpInside) {
            let vc = OrderTestHelpPopUpVC.instantiate(fromAppStoryboard: .bca)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = BCAOrderDetailsViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension BCAOrderDetailsVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblOrderTrack:
            return self.arrTrack.count
        case self.tblTestDetails:
            return 4
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.tblOrderTrack :
            let cell : BCAOrderTrackDeviceCell = tableView.dequeueReusableCell(withClass: BCAOrderTrackDeviceCell.self, for: indexPath)
            let object = self.arrTrack[indexPath.row]
            cell.lblTitle.text = object["title"].stringValue
            cell.lblDate.text = object["date"].stringValue
            cell.vwTopPoint.isHidden = indexPath.row == 0 ? true : false
            cell.vwBottomPoint.isHidden = self.arrTrack.count - 1 == indexPath.row ? true : false
            return cell
        case self.tblTestDetails :
            let cell : BCAOrderTestDetailsCell = tableView.dequeueReusableCell(withClass: BCAOrderTestDetailsCell.self, for: indexPath)
            if indexPath.row == 3 {
                cell.vwSaperator.isHidden = true
            }
            return cell
        default:
            return UITableViewCell()
        }
       
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension BCAOrderDetailsVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension BCAOrderDetailsVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblOrderTrack, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblHeightConstantForOrderTracking.constant = newvalue.height
        }
        
        if let obj = object as? UITableView, obj == self.tblTestDetails, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblHeightConstantForTestDetails.constant = newvalue.height
        }
        
        UIView.animate(withDuration: kAnimationSpeed) { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblOrderTrack.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblTestDetails.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblOrderTrack else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView = self.tblTestDetails else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
