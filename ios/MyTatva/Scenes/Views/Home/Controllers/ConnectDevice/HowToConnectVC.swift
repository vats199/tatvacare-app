//
//  HowToConnectVC.swift
//  MyTatva
//
//  Created by 2022M43 on 11/05/23.
//

import Foundation
import UIKit

class ConnectModel {
    
    var stepNum: String
    var stepDesc: String
    
    init(stepNum: String, stepDesc: String) {
        self.stepNum = stepNum
        self.stepDesc = stepDesc
    }
}

class HowToConnectCell: UITableViewCell {
    
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var vwSteps: UIView!
    @IBOutlet weak var lblStepNo: UILabel!
    @IBOutlet weak var lblStepDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.vwSteps.setRound()
        }
        
        self.lblStepDesc.font(name: .regular, size: 13)
            .textColor(color: .themeBlack)
        
        self.lblStepNo.font(name: .medium, size: 12)
            .textColor(color: .themePurple)
        
        self.vwSteps.backGroundColor(color: .ThemePurpleView)
    }
    
    func configCell(data: ConnectModel) {
        self.lblStepNo.text = data.stepNum
        self.lblStepDesc.text = data.stepDesc
    }
}


class HowToConnectVC : UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var tblSteps: UITableView!
    
    @IBOutlet weak var tblConstHeight: NSLayoutConstraint!
    
    //MARK:- Class Variables
    var arrySteps = [ConnectModel]()
    
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
        
        self.arrySteps = [ConnectModel(stepNum: "1", stepDesc: "Insert the batteries into your weighing scale"),
                          ConnectModel(stepNum: "2", stepDesc: "Place the scale on a flat surface"),
                          ConnectModel(stepNum: "3", stepDesc: "Ensure your phone’s Bluetooth is turned on"),
                          ConnectModel(stepNum: "4", stepDesc: "Ensure your phone’s Location is turned on"),
                          ConnectModel(stepNum: "5", stepDesc: "Remove footwear and/or socks")]
        
        self.lblTitle.font(name: .bold, size: 17)
            .textColor(color: UIColor.themeBlack)
            .text = "Let’s Connect Your Smart Scale"

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.topLeft, .topRight], radius: 20)
        }
        
        self.tblSteps.delegate = self
        self.tblSteps.dataSource = self
        self.tblSteps.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblSteps && keyPath == "contentSize", let size = change?[.newKey] as? CGSize {
                self.tblConstHeight.constant = self.tblSteps.contentSize.height
                self.tblSteps.isScrollEnabled = false
            }
        }
    }
    
    func removeObserverOnHeightTbl() {
        guard let tblView = self.tblSteps else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true)
        }
        
        self.btnCancel.addAction(for: .touchUpInside, action: { [weak self] in
            guard let self = self else { return }
            self.dismissPopUp(true)
        })
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
        self.navigationController?.isNavigationBarHidden = true
        WebengageManager.shared.navigateScreenEvent(screen: .LearnToConnectSmartScale)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

extension HowToConnectVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrySteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HowToConnectCell = tableView.dequeueReusableCell(withClass: HowToConnectCell.self, for: indexPath)
        cell.configCell(data: self.arrySteps[indexPath.row])
        return cell
    }
}
