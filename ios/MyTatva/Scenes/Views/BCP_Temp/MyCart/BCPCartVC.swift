//
//  BCPCartVC.swift
//  MyTatva
//
//  Created by 2022M43 on 13/06/23.
//

import Foundation
import UIKit
class BCPCartVC: UIViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var lblNavTitle: SemiBoldBlackTitle!
    
    //----------------- Patient Details -------------------
    @IBOutlet weak var lblPatientName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var imgAddress: UIImageView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var imgMobile: UIImageView!
    @IBOutlet weak var vwPatientDetails: UIView!
    //----------------- test Details -------------------
    @IBOutlet weak var lblTestDetails: UILabel!
    @IBOutlet weak var lblAddTest: UILabel!
    @IBOutlet weak var vwBCPTest: UIView!
    @IBOutlet weak var vwTest: UIView!
    @IBOutlet weak var tblTest: UITableView!
    @IBOutlet weak var tblBCPTest: UITableView!
    @IBOutlet weak var tblTestHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tblBCPTestHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnAddTest: UIButton!
    
    //----------------- Billing -------------------
    @IBOutlet weak var lblBilling: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalAmountRate: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblSubTotalRate: UILabel!
    @IBOutlet weak var lblCollectionCharge: UILabel!
    @IBOutlet weak var lblCollectionChargeRate: UILabel!
    @IBOutlet weak var lblServiceCharge: UILabel!
    @IBOutlet weak var lblServiceChargeRate: UILabel!
    @IBOutlet weak var lblAmountPaid: UILabel!
    @IBOutlet weak var lblAmountPaidRate: UILabel!
        
    //----------------- booking -------------------
    @IBOutlet weak var vwButtons: UIView!
    @IBOutlet weak var btnPatientDetails: ThemePurple16Corner!
    @IBOutlet weak var btnDateTime: ThemePurple16Corner!
    
    //------------------------------------------------------
    //MARK: - Class Variables -
    
    var viewModel           = LabTestCartVM()
    var object: CartListModel!
    let labTestListVM       = LabTestListVM()
    
    //------------------------------------------------------
    //MARK: - UIView Life Cycle Methods -
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.cartTestListAPI(withLoader: true) { [weak self] isDone, object in
            guard let self = self else {return}
            
            if isDone {
                print(object)
//                self.scrollMain.isHidden = false
                self.object = object
                CartListModel.shared = object
                self.setData()
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
        
    //------------------------------------------------------
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    //MARK: - Custome Methods -
    func setUpView() {
        self.applyStyle()
        self.addObserverOnHeightTbl()
        self.setTables(self.tblTest)
        self.setTables(self.tblBCPTest)
        self.manageActionMethods()
        
        self.vwPatientDetails.isHidden = true
        self.btnDateTime.isHidden = true
    }
    
    func applyStyle() {
                
        self.lblNavTitle.text = "Cart"
        
        // ---------- Patient Details ----------
        self.lblPatientName.font(name: .bold, size: 13).textColor(color: .themeBlack).text = "Patient Name"
        self.lblAddress.font(name: .regular, size: 11).textColor(color: .ThemeDarkGray).text = "Address"
        self.lblEmail.font(name: .regular, size: 11).textColor(color: .ThemeDarkGray).text = "abc@email.com"
        self.lblMobile.font(name: .regular, size: 11).textColor(color: .ThemeDarkGray).text = "+91-9990000000"
        
        self.imgAddress.image = UIImage(named: "grayAddress_ic")
        self.imgEmail.image = UIImage(named: "grayMail_ic")
        self.imgMobile.image = UIImage(named: "callGray_ic")
        
        // ---------- Test Details ----------
        self.lblTestDetails.font(name: .bold, size: 17).textColor(color: .themeBlack).text = "Test Details"
        self.lblAddTest.font(name: .medium, size: 13).textColor(color: .themePurple).text = "Add Test"
        
        // ---------- Billing Details ----------
        self.lblBilling.font(name: .bold, size: 19).textColor(color: .themeBlack).text = "Billing"
        self.lblTotalAmount.font(name: .regular, size: 11).textColor(color: .ThemeGray61).text = "Total Amount"
        self.lblSubTotal.font(name: .regular, size: 11).textColor(color: .ThemeGray61).text = "Sub Total"
        self.lblCollectionCharge.font(name: .regular, size: 11).textColor(color: .ThemeGray61).text = "Home Collection Charges"
        self.lblServiceCharge.font(name: .regular, size: 11).textColor(color: .ThemeGray61).text = "Service Charge"
        
        self.lblTotalAmountRate.font(name: .regular, size: 11).textColor(color: .ThemeGray61).text = "Free"
        self.lblSubTotalRate.font(name: .regular, size: 11).textColor(color: .ThemeGray61).text = "Free"
        self.lblCollectionChargeRate.font(name: .regular, size: 11).textColor(color: .ThemeGray61).text = "Free"
        self.lblServiceChargeRate.font(name: .regular, size: 11).textColor(color: .ThemeGray61).text = "Free"
        
        self.lblAmountPaid.font(name: .bold, size: 13).textColor(color: .themeBlack).text = "Amount to be Paid"
        self.lblAmountPaidRate.font(name: .bold, size: 13).textColor(color: .themeBlack).text = "Free"
        
        self.vwButtons.themeShadowBCP()
        
    }
    
    func setTables(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TestDetailCell", bundle: nil), forCellReuseIdentifier: "TestDetailCell")
        tableView.rowHeight                  = UITableView.automaticDimension
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: Double.leastNormalMagnitude))
    }
    
    private func setData() {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tblBCPTest.reloadData()
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.tblTest.reloadData()
        }
        
    }
    
    //MARK: - Button Action Methods -
    func manageActionMethods() {
        self.btnAddTest.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            let vc = AllLabTestListVC.instantiate(fromAppStoryboard: .carePlan)
            vc.labTestType = .test
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: UITableViewDelegate and UITableViewDataSource
extension BCPCartVC : UITableViewDelegate, UITableViewDataSource {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case self.tblTest:
            return self.object == nil ? 0 : self.object.testsList.count
        case self.tblBCPTest:
            return self.object == nil ? 0 : self.object.bcpTestsList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblTest:
            return 1
        case self.tblBCPTest:
            return self.object == nil ? 0 : self.object.bcpTestsList[section].bcpTestsList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestDetailCell") as! TestDetailCell
        switch tableView {
        case self.tblTest:
            let obj = self.object.testsList[indexPath.row]
            cell.btnDelete.isHidden = true
            cell.lblTestName.text = obj.testNames
            cell.consLineBottom.constant = 6
            if indexPath.row == 0 && indexPath.row == (self.object.testsList.count - 1) {
                cell.vwMain.cornerRadius(cornerRadius: 20.0)
                cell.vwLine.isHidden = true
                cell.consImgTop.constant = 12
            }else if indexPath.row == (self.object.testsList.count - 1) {
                DispatchQueue.main.async {
                    cell.vwMain.roundCorners([.bottomLeft,.bottomRight], radius: 20.0)
//                    cell.vwBG.themeShadow()
                    cell.vwLine.isHidden = true
                }
            }else if indexPath.row == 0 {
                DispatchQueue.main.async {
                    cell.vwMain.roundCorners([.topLeft,.topRight], radius: 20.0)
                    cell.consLineBottom.constant = 12
                }
            }else {
                cell.consLineBottom.constant = 12
                cell.vwLine.isHidden = false
            }
            break
        case self.tblBCPTest:
            let obj = self.object.bcpTestsList[indexPath.section].bcpTestsList[indexPath.row]
            cell.btnDelete.isHidden = true
            cell.lblTestName.text = self.object.bcpTestsList[indexPath.section].bcpTestsList[indexPath.row].testNames
            cell.consLineBottom.constant = 6
            if indexPath.row == (self.object.bcpTestsList[indexPath.section].bcpTestsList.count - 1) {
                DispatchQueue.main.async {
                    cell.vwMain.roundCorners([.bottomLeft,.bottomRight], radius: 20.0)
//                    cell.vwBG.themeShadow()
                    cell.vwLine.isHidden = true
                }
            }else {
                cell.consLineBottom.constant = 12
//                cell.vwMain.themeShadow()
                cell.vwLine.isHidden = false
            }       
            
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vw = UINib(nibName: "BCPCartHeaderCell", bundle: nil).instantiate(withOwner: self)[0] as! BCPCartHeaderCell
        vw.vwBottomConst.constant = 0
        vw.vwTopConst.constant = 5
        DispatchQueue.main.async {
            vw.vwMain.roundCorners([.topLeft, .topRight], radius: 16)
        }
        
        return vw
        
        /*if tableView == self.tblBCPTest {
            let vw = UINib(nibName: "BCPCartHeaderCell", bundle: nil).instantiate(withOwner: self)[0] as! BCPCartHeaderCell
            vw.lblTitle.text = self.object.bcpTestsList[section].planName
            vw.btnSelect.addAction(for: .touchUpInside) { [weak self] in
                guard let self = self else { return }
                vw.btnSelect.isSelected = !vw.btnSelect.isSelected
            }
            
            DispatchQueue.main.async {
                vw.vwMain.themeShadow()
                vw.vwMain.roundCorners([.topLeft,.topRight], radius: 20.0)
            }
            
            return vw
        }
        
        return nil*/
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tblBCPTest {
            return 48
        }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5 //CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: -------------------------- Observers Methods --------------------------
extension BCPCartVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblTest, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblTestHeightConst.constant = newvalue.height
            self.tblTest.isScrollEnabled = false
        }
        
        if let obj = object as? UITableView, obj == self.tblBCPTest, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblBCPTestHeightConst.constant = newvalue.height
            self.tblBCPTest.isScrollEnabled = false
        }
    }
    
    func addObserverOnHeightTbl() {
        self.tblTest.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblBCPTest.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblTest else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    
        guard let tblView = self.tblBCPTest else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}


