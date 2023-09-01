//
//  SomeoneElsePopupVC.swift
//  MyTatva
//
//  Created by 2022M43 on 01/05/23.
//

import Foundation
import UIKit

class SomeoneElsePopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var tblView          : UITableView!
    
    @IBOutlet weak var btnSubmit        : UIButton!
    @IBOutlet weak var btnCancel        : UIButton!
    
    @IBOutlet weak var consTblHeight: NSLayoutConstraint!
    
    //MARK:- Class Variable
    let viewModel                       = SomeoneElsePopupVM()
    let viewmodelAccountFor             = AccountCreationForVM()
    var completionHandler               : ((SomeoneElseDataModel) -> Void)? = nil
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {
        
        self.lblTitle.font(name: .semibold, size: 22)
            .textColor(color: UIColor.themeBlack)
        
        self.btnCancel.font(name: .medium, size: 18)
            .textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 20)
        }
        
        self.tblView.delegate                   = self
        self.tblView.dataSource                 = self
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    
        self.openPopUp()
        self.manageActionMethods()
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : [SomeoneElseDataModel]? = nil) {
        self.dismiss(animated: animated) { [weak self] in
            guard let self = self else { return }
        }
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true)
        }
        
        self.btnSubmit.addTapGestureRecognizer { [weak self] in
            
            guard let self = self else { return }
            guard let obj = self.viewModel.getSelectedObject() else {
                return
            }
            self.completionHandler?(obj)
            self.dismissPopUp(true)
        }
        
        self.btnCancel.addAction(for: .touchUpInside, action: { [weak self] in
            guard let self = self else { return }
            self.dismissPopUp(true)
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblView && keyPath == "contentSize", let size = change?[.newKey] as? CGSize {
                self.consTblHeight.constant = self.tblView.contentSize.height
                self.tblView.isScrollEnabled = false
            }
        }
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblView else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//------------------------------------------------------
//MARK: - UITableViewDelegate,Datasource
extension SomeoneElsePopupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: LanguageTblCell.self)
        cell.lblTitle.text = self.viewModel.arrList[indexPath.row].someoneElseTittle
        cell.btnSelect.isSelected = self.viewModel.arrList[indexPath.row].isSelected
        cell.imgView.isHidden = true
        cell.btnSelect.addTapGestureRecognizer {
            self.viewModel.updateValue(indexPath.row)
            self.tblView.reloadData()
        }
        return cell
    }
}
