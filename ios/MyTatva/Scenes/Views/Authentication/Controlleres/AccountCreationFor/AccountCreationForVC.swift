//
//  AccountCreationForVC.swift
//  MyTatva
//
//  Created by Hlink on 26/04/23.
//

import UIKit

enum AccountCreationFor : String {
    case Myself = "myself"
    case Someone_Else = "someone_else"
}

class AccountCreationForVC: UIViewController {
    
    //MARK: Outlet
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
        
    @IBOutlet weak var btnMySelf: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel: AccountCreationForVM!
    var isBackShown = false
    var accountCreatedFor = AccountCreationFor.Myself
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.applyStyle()
        self.addActions()
//        self.addHeaderView()
    }
    
    private func applyStyle() {
        
        self.navigationItem.leftBarButtonItem = self.isBackShown ? self.navigationItem.leftBarButtonItem ?? UIBarButtonItem() : nil
//        self.navigationItem.leftBarButtonItem = self.leftBarItem
        
        self.lblTitle.font(name: .semibold, size: 17.0).textColor(color: .themeBlack).numberOfLines = 0
        self.lblTitle.textAlignment = .center
        self.lblTitle.text = "Before we start, let us know..."
        self.lblSubTitle.font(name: .regular, size: 14.0).textColor(color: .themeGray).numberOfLines = 0
        self.lblSubTitle.text = "Are you signing up for yourself or\nsomeone else ?"
        self.lblSubTitle.textAlignment = .center
                
        self.btnMySelf.fontSize(size: 17.0).setTitle("Myself", for: UIControl.State())
        self.btnOther.fontSize(size: 17.0).setTitle("Someone Else", for: UIControl.State())
//        self.self.txtMobileNumber.font(name: .medium, size: 13.0)
        self.btnMySelf.isSelected = true
        self.btnOther.isSelected = false
        self.themePurpleBorderButton(self.btnMySelf)
        self.themePurpleBorderButton(self.btnOther)
    }
    
    private func setupViewModelObserver() {
        self.viewModel.isResult.bind { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                UserDefaultsConfig.kUserStep = 2
                let vc = DoctorAccessCodeVC.instantiate(fromAppStoryboard: .auth)
                vc.isBackShown = true
                self.navigationController?.pushViewController(vc, animated: true)
//                UIApplication.shared.manageLogin()
                break
            case .failure(let error):
                debugPrint("Error", error.localizedDescription)
                Alert.shared.showSnackBar(error.localizedDescription)
                break
            case .none: break
            }
        }
    }
    
    func themePurpleBorderButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.font(name: .medium, size: 20).textColor(color: .white)
                .backGroundColor(color: .themePurple)
            sender.layer.cornerRadius = 5
            sender.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), imageTitlePadding: 0)
        } else {
            sender.font(name: .medium, size: 20).textColor(color: .themePurple).backGroundColor(color: .white)
            sender.layer.cornerRadius = 5
            sender.borderColor(color: UIColor.themePurple, borderWidth: 1)
            sender.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), imageTitlePadding: 0)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method -
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                // some process
                if vc.isKind(of: EnterMobileViewPopUp.self) {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
    }
    
    private func addActions() {
        
        self.btnMySelf.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.btnMySelf.isSelected = true
            self.btnOther.isSelected = false
            self.themePurpleBorderButton(self.btnMySelf)
            self.themePurpleBorderButton(self.btnOther)
            self.accountCreatedFor = AccountCreationFor.Myself
            self.viewModel.apiAccountFor(relation: AccountCreationFor.Myself.rawValue)
        }
        
        self.btnOther.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.btnOther.isSelected = true
            self.btnMySelf.isSelected = false
            self.themePurpleBorderButton(self.btnMySelf)
            self.themePurpleBorderButton(self.btnOther)
            self.accountCreatedFor = AccountCreationFor.Someone_Else
            let vc = SomeoneElsePopupVC.instantiate(fromAppStoryboard: .auth)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandler = { obj in
                self.viewModel.apiAccountFor(relation: AccountCreationFor.Someone_Else.rawValue, sub_relation: obj.someoneElseTittle)
            }
            UIApplication.topViewController()?.present(vc, animated: true)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = AccountCreationForVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.setupViewModelObserver()
        WebengageManager.shared.navigateScreenEvent(screen: .SelectRole)
    }
    
}
