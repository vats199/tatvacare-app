//
//  PaymentSuccessVC.swift
//  MyTatva
//
//  Created by 2022M43 on 01/06/23.
//

import Foundation
import UIKit
class PaymentSuccessVC: UIViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var imgPaymentSuccess: UIImageView!
    @IBOutlet weak var lblPaymentDone: UILabel!
    @IBOutlet weak var btnViewPlan: ThemePurple16Corner!
    
    //------------------------------------------------------
    //MARK: - Class Variables -
    
    var planDetails: PlanDetail!
    var patientPlanRefID:String?
    var isPushed = false
    
    //------------------------------------------------------
    //MARK: - UIView Life Cycle Methods -
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.manageActionMethods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.clearNavigation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            if !self.isPushed {
                self.pushTODetailScreen()
            }
        }
        
        WebengageManager.shared.navigateScreenEvent(screen: .BcpPurchaseSuccess)
    }
    
    //------------------------------------------------------
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    //MARK: - Custome Methods -
    func setUpView() {
        
        if let patientPlanRefID = self.patientPlanRefID {
            var tempPlanDetail = JSON()
            tempPlanDetail["patient_plan_rel_id"].stringValue = patientPlanRefID
            self.planDetails = PlanDetail(fromJson: tempPlanDetail)
        }
        
        self.applyStyle()
    }
    
    func applyStyle() {
        self.lblPaymentDone.font(name: .bold, size: 20).textColor(color: .themeBlack).text = "Congratulations!!\nYour payment is successful, and your chronic care plan has been assigned to you"
        self.lblPaymentDone.textAlignment = .center
        self.btnViewPlan.setTitle("Continue", for: UIControl.State())
    }
    
    func manageActionMethods() {
        
        self.btnViewPlan.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.pushTODetailScreen()
        }
    }
    
    private func pushTODetailScreen() {
        self.isPushed = true
        let vc = PurchsedCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
        vc.viewModel.planDetails = self.planDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Button Action Methods -
}

