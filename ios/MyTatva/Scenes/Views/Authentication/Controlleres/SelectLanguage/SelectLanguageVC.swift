//
//  ForgotPasswordVC.swift
//
//  Created by 2020M03 on 16/06/21.
//

import UIKit

class SelectLanguageVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var lblSelectLanguage    : UILabel!
    @IBOutlet weak var btnSubmit            : UIButton!
    
    @IBOutlet weak var btnCAT               : UIButton!
    @IBOutlet weak var btnIncident          : UIButton!
    @IBOutlet weak var btnQuiz              : UIButton!
    @IBOutlet weak var btnPoll              : UIButton!
    
    @IBOutlet weak var txtLanguage          : UITextField!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel                   = SelectLanguageVM()
    private let listViewModel               = LanguageListVM()
    private var selectedLanguageListModel   = LanguageListModel()
    private var isShowNavigationBarHidden   = true
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
        self.setupListViewModelObserver()
        self.updateAPIData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(self.isShowNavigationBarHidden, animated: true)
        WebengageManager.shared.navigateScreenEvent(screen: .SelectLanguage)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        self.applyStyle()
        
        self.btnCAT.addTapGestureRecognizer {
            SurveySparrowManager.shared.startSurveySparrow(token: "tt-c528cc")
            SurveySparrowManager.shared.completionHandler = { Response in
                print(Response as Any)
            }
        }
        
        self.btnQuiz.addTapGestureRecognizer {
            SurveySparrowManager.shared.startSurveySparrow(token: "tt-f26f74")
            SurveySparrowManager.shared.completionHandler = { Response in
                print(Response as Any)
            }
        }
        
        self.btnPoll.addTapGestureRecognizer {
            SurveySparrowManager.shared.startSurveySparrow(token: "tt-06b207")
            SurveySparrowManager.shared.completionHandler = { Response in
                print(Response as Any)
            }
        }
        
        self.btnIncident.addTapGestureRecognizer {
            SurveySparrowManager.shared.startSurveySparrow(token: "tt-56a1d2")
            SurveySparrowManager.shared.completionHandler = { Response in
                print(Response as Any)
            }
        }
        
        self.btnSubmit.startAnimate()
    }
    
    private func applyStyle() {
        self.txtLanguage.setRightImage(img: UIImage(named: "IconDownArrow"))
        self.txtLanguage.delegate = self
        
        self.lblSelectLanguage.font(name: .bold, size: 22).textColor(color: .themePurple)
    }
    
    @objc func updateAPIData(){
        self.listViewModel.apiCallFromStart(refreshControl: nil,
                                        tblView: nil,
                                        withLoader: true)
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    @IBAction func btnSubmitTapped(_ sender: Any) {
        viewModel.apiSelectLanguage(vc: self,
                                    language: self.txtLanguage)
    }
    
    //------------------------------------------------------
}

//MARK: -------------------- UITextField Delegate --------------------
extension SelectLanguageVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let vc = LanguageListVC.instantiate(fromAppStoryboard: .auth)
        vc.arrDaysOffline = [self.selectedLanguageListModel]
        vc.completionHandler = { obj in
            //Do your task here
            self.selectedLanguageListModel  = obj
            UserDefaultsConfig.languageId   = obj.languagesId
            self.txtLanguage.text           = self.selectedLanguageListModel.languageName
        }
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension SelectLanguageVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                
               // let vc = SignupMobileVC.instantiate(fromAppStoryboard: .auth)
//                let vc = LoginSignupVC.instantiate(fromAppStoryboard: .auth)
                //vc.selectedLanguageListModel = self.selectedLanguageListModel
                
   
                GlobalAPI.shared.apiWalkthroughList { [weak self] dataResponse in
                    guard let self = self else { return }
                    let vc = WalkthroughVC.instantiate(fromAppStoryboard: .auth)
                    vc.viewModel.arrWalkthroughList = dataResponse
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                break
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

//MARK: -------------------- setupListViewModel Observer --------------------
extension SelectLanguageVC {
    
    private func setupListViewModelObserver() {
        // Result binding observer
        self.listViewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                if self.listViewModel.arrList.count > 0 {
                    for item in self.listViewModel.arrList {
                        if item.languageName.lowercased().contains("english".lowercased()) {
                            self.selectedLanguageListModel  = item
                            UserDefaultsConfig.languageId   = item.languagesId
                            self.txtLanguage.text           = self.selectedLanguageListModel.languageName
                        }
                    }
                }
                else {
                    Alert.shared.showAlert(title: "", message: self.listViewModel.strErrorMessage, actionTitles: [AppMessages.retry], actions: [ { [self] (yes) in
                        
                        DispatchQueue.main.async {
                            self.updateAPIData()
                        }
                    }
                    ])
                }
                
                break
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
