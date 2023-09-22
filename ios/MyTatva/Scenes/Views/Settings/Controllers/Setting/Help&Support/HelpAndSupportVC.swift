//
//  HelpAndSupportVC.swift
//  MyTatva
//
//  Created by hyperlink on 26/10/21.
//

import UIKit

class HelpAndSupportTitleCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var vwBg         : UIView!
    //@IBOutlet weak var btnArrow     : UIButton!
    @IBOutlet weak var lblSeperator : UILabel!
    @IBOutlet weak var vwBottom     : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeGray)
        self.lblSeperator.isHidden = true
//        self.btnArrow.isUserInteractionEnabled = false
    
        DispatchQueue.main.async {
            self.vwBottom.constant = 0.0
            self.vwBg.layoutIfNeeded()
            self.vwBg.clipsToBounds = true
            self.vwBg.layer.cornerRadius = 7
            self.vwBg.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner]
            self.vwBg.borderColor(color: UIColor.ThemeBorder, borderWidth: 0)
        }
    }
}

class HelpAndSupportContentCell: UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblAns       : UILabel!
    @IBOutlet weak var btnSelection : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .medium, size: 16)
            .textColor(color: UIColor.themeBlack)
        self.lblAns
            .font(name: .medium, size: 14)
            .textColor(color: UIColor.themeBlack)
       
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            //self.vwBg.roundCorners([.bottomLeft, .bottomRight], radius: 7)
            self.vwBg.clipsToBounds = true
            self.vwBg.layer.cornerRadius = 7
//            self.vwBg.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
            self.vwBg.borderColor(color: UIColor.ThemeBorder, borderWidth: 0)
            self.vwBg.themeShadow()
        }
    }
}

class HelpAndSupportVC: ClearNavigationFontBlackBaseVC { //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var btnChat      : UIButton!
    @IBOutlet weak var btnQuery     : UIButton!
    
    @IBOutlet weak var vwChat       : UIView!
    @IBOutlet weak var lblChat      : UILabel!
    
    @IBOutlet weak var vwQuery      : UIView!
    @IBOutlet weak var lblQuery     : UILabel!
    
    @IBOutlet weak var lblReachUs   : UILabel!
    @IBOutlet weak var vwReachus    : UIView!
    @IBOutlet weak var lblEmail     : UILabel!
    @IBOutlet weak var stackPhone   : UIStackView!
    @IBOutlet weak var lblPhone     : UILabel!
    
    @IBOutlet weak var lblFreQue    : UILabel!
    @IBOutlet weak var tblView      : UITableView!
    @IBOutlet weak var tblHeight    : NSLayoutConstraint!
    
    @IBOutlet weak var scrollVw     : UIScrollView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = HelpAndSupportVM()
    let refreshControl              = UIRefreshControl()
    var hiddenSections              = Set<Int>()
    var isLoadingList : Bool        = false
    
    var strErrorMessage : String    = ""
    
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
        
        self.stackPhone.isHidden = true
        
        self.configureUI()
        self.addObserverOnHeightTbl()
        self.manageActionMethods()
        self.applyStyle()
        
        Settings().isHidden(setting: .chat_bot) { isHidden in
            self.btnChat.isHidden = isHidden
        }
        
        Settings().isHidden(setting: .hide_leave_query) { isHidden in
            self.btnQuery.isHidden = isHidden
        }
        
        Settings().isHidden(setting: .hide_email_at) { isHidden in
            self.vwReachus.isHidden = isHidden
            self.lblReachUs.isHidden = isHidden
        }
    }
    
    private func applyStyle(){
        self.lblChat.font(name: .medium, size: 16).textColor(color: UIColor.white)
        self.lblQuery.font(name: .medium, size: 16).textColor(color: UIColor.white)
        
        self.btnChat.font(name: .medium, size: 14).textColor(color: UIColor.themePurple)
        self.btnQuery.font(name: .medium, size: 14).textColor(color: UIColor.themePurple)
        
        self.lblReachUs.font(name: .medium, size: 20).textColor(color: UIColor.themeBlack)
        self.lblEmail.font(name: .medium, size: 16).textColor(color: UIColor.themePurple)
        self.lblPhone.font(name: .medium, size: 16).textColor(color: UIColor.themePurple)
        self.lblFreQue.font(name: .medium, size: 20).textColor(color: UIColor.themeBlack)
    }
    
    @objc func updateAPIData(){
        self.strErrorMessage = ""
        self.viewModel.apiCallFromStartQuestion(tblView: self.tblView,
                                                refreshControl: self.refreshControl,
                                                withLoader: false)
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        self.scrollVw.delegate = self
        
        DispatchQueue.main.async {
            self.vwChat.layoutIfNeeded()
            self.vwChat.cornerRadius(cornerRadius: 5)
            self.vwQuery.layoutIfNeeded()
            self.vwQuery.cornerRadius(cornerRadius: 5)
            
            self.vwReachus.layoutIfNeeded()
            self.vwReachus.cornerRadius(cornerRadius: 10)
            self.vwReachus.borderColor(color: UIColor.ThemeBorder, borderWidth: 0.5)
            self.vwReachus.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
            
            self.btnChat.layoutIfNeeded()
            self.btnChat.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.btnQuery.layoutIfNeeded()
            self.btnQuery.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
        }
        
        self.tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        self.tblView.estimatedSectionFooterHeight = 0
        self.tblView.sectionFooterHeight        = 0
        self.tblView.estimatedSectionHeaderHeight = 0
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
        self.lblEmail.addTapGestureRecognizer {
            GFunction.shared.sendMail(to: self.lblEmail.text ?? "", with: "", subject: "")
        }
    
        self.lblPhone.addTapGestureRecognizer {
            GFunction.shared.makeCall(self.lblPhone.text ?? "")
        }
        
        self.btnQuery.addTapGestureRecognizer {
            let vc = AddSupportQuestionPopupVC.instantiate(fromAppStoryboard: .setting)
            vc.completionHandler = { objc in
                self.updateAPIData()
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
        
        self.btnChat.addTapGestureRecognizer {
            PlanManager.shared.isAllowedByPlan(type: .chatbot,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow{
                    let vc1 = WebviewChatBotVC.instantiate(fromAppStoryboard: .setting)
                    vc1.modalPresentationStyle = .overFullScreen
                    vc1.modalTransitionStyle = .coverVertical
                    vc1.hidesBottomBarWhenPushed = true
                    let nav = UINavigationController(rootViewController: vc1)
                    self.present(nav, animated: true, completion: nil)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .HelpSupportFaq)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = .default
        self.viewModel.apiCallFromStartQuestion(tblView: self.tblView, refreshControl: self.refreshControl, withLoader: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .HelpSupportFaq, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAnalytics.manageTimeSpent(on: .HelpSupportFaq, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func onGoBack(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
       }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension HelpAndSupportVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell : HelpAndSupportTitleCell = tableView.dequeueReusableCell(withClass: HelpAndSupportTitleCell.self)
        
        if let objc = self.viewModel.getObject(index: section) {
            cell.lblTitle.text = objc.categoryName
            
            cell.vwBg.addTapGestureRecognizer {
                objc.isSelected = !objc.isSelected
                self.tblView.reloadSections([section], with: .fade)
                UIView.animate(withDuration: kAnimationSpeed, delay: 0, options: [.curveEaseIn]) {
                    self.view.layoutIfNeeded()
                } completion: { isDone in
                }
            }
        }
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let object = self.viewModel.getObject(index: section) {
            if object.isSelected {
                return object.data.count
            }
            else {
                return 0
            }
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : HelpAndSupportContentCell = tableView.dequeueReusableCell(withClass: HelpAndSupportContentCell.self, for: indexPath)
        
        if let obj = self.viewModel.getObject(index: indexPath.section)?.data[indexPath.row]{
            //cell.lblTitle.text      =
            //cell.lblAns.text        =  AppMessages.ans + " " + obj.faqAnswer
            
            let strQue            = AppMessages.Q + " " + obj.faqQuestion
            let defaultDicQue : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : UIFont.customFont(ofType: .medium, withSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.black as Any
            ]
            let attributeDicQue : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : UIFont.customFont(ofType: .medium, withSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.themePurple,
            ]
            
            cell.lblTitle.attributedText = strQue.getAttributedText(defaultDic: defaultDicQue, attributeDic: attributeDicQue, attributedStrings: [AppMessages.Q])
            
//            let strAns            = AppMessages.ans + " " + obj.faqAnswer
            let strAns            = obj.answerPrefix + " " + obj.faqAnswer
//            let defaultDicAns : [NSAttributedString.Key : Any] = [
//                NSAttributedString.Key.font : UIFont.customFont(ofType: .medium, withSize: 14),
//                NSAttributedString.Key.foregroundColor : UIColor.black as Any
//            ]
//            let attributeDicAns : [NSAttributedString.Key : Any] = [
//                NSAttributedString.Key.font : UIFont.customFont(ofType: .medium, withSize: 14),
//                NSAttributedString.Key.foregroundColor : UIColor.themePurple,
//            ]
            
            cell.lblAns.text = ""
            let strAnsFinal = String(format:"<span style=\"font-family: 'SFProDisplay-Medium', 'SFProDisplay-Medium'; font-size: \(14)\">%@</span>", strAns)
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    cell.lblAns.attributedText = strAnsFinal.htmlToMutableAttributedString
                    self.tblView.performBatchUpdates {
                    }
                }
            }
//            cell.lblAns.attributedText = strAns.getAttributedText(defaultDic: defaultDicAns, attributeDic: attributeDicAns, attributedStrings: [AppMessages.ans])
            
            
            if obj.isSelected {
                cell.lblAns.isHidden = false
                cell.btnSelection.isSelected = true
            }
            else {
                cell.lblAns.isHidden = true
                cell.btnSelection.isSelected = false
            }
            
            cell.vwBg.addTapGestureRecognizer {
                obj.isSelected = !obj.isSelected
                self.tblView.reloadRows(at: [indexPath], with: .fade)
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //self.viewModel.manageFaqPagenation(tblView: tableView, index: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = .clear
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let objc = self.viewModel.getObject(index: section) {
            let height = objc.categoryName.height(withConstrainedWidth: self.tblView.frame.width, font: UIFont.customFont(ofType: .regular, withSize: 14))
            return height + 20
        }
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}

//MARK: -------------------------- UIScrollView Methods --------------------------
extension HelpAndSupportVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Pagenation Logic for poslist
        let currentOffsetY : CGFloat = scrollView.contentOffset.y
        let maximumOffsetY : CGFloat = scrollView.contentSize.height - scrollView.frame.size.height + 20
        if maximumOffsetY - currentOffsetY <= 1 {
            
            if !isLoadingList {
                self.isLoadingList = true
                //self.viewModel.manageFaqPagenation(tblView: self.tblView)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
//        if (((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height ) && !isLoadingList){
//            self.isLoadingList = true
//            self.viewModel.manageFaqPagenation(tblView: self.tblView)
//        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.isLoadingList = false
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension HelpAndSupportVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
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
extension HelpAndSupportVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UITableView, obj == self.tblView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblHeight.constant = newvalue.height
            
            UIView.animate(withDuration: kAnimationSpeed) {
                self.view.layoutIfNeeded()
            }
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

//MARK: ------------------ UITableView Methods ------------------
extension HelpAndSupportVC {
    
    fileprivate func setData(){
        
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension HelpAndSupportVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                break
            case .none: break
            }
        })
    }
}

