//
//  QuestionsStartingVC.swift
//  MyTatva
//
//  Created by Uttam patel on 04/07/23.
//

import Foundation
import UIKit

class QuestionsStartingVC: UIViewController {
    //MARK: - Outlets -
    
    @IBOutlet weak var imgGif: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblSubHeader: UILabel!
    @IBOutlet weak var btnLetsBegin: UIButton!
    
    
    //MARK: - Class Variables -
    let viewModel = QuestionsStartingVM()
    var verifyUserModel         = VerifyUserModel()
    
    //MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupViewModelObserver()
        self.applyStyle()
        self.addActions()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //------------------------------------------------------------------------------------------
    
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------------------------------------------
    
    //MARK: - Custom Functions -
    
    func setup() {
        self.imgGif.sd_setImage(with: URL(string: UserDefaultsConfig.kLetBigGIF), completed: nil)
    }
    
    //------------------------------------------------------------------------------------------
    
    func applyStyle() {
        
        self.lblHeader.font(name: .bold, size: 20).textColor(color: .themeBlack2)
        self.lblSubHeader.font(name: .regular, size: 14).textColor(color: .themeGray5)
        
        self.btnLetsBegin.cornerRadius(cornerRadius: 16).backGroundColor(color: .themePurple)
        self.btnLetsBegin.font(name: .bold, size: 16).textColor(color: UIColor.white)
    }
    
    //------------------------------------------------------------------------------------------
    
    private func addActions() {
        self.btnLetsBegin.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.viewModel.apiAccountFor(relation: AccountCreationFor.Myself.rawValue)
        }
    }
    
    
    private func setupViewModelObserver() {
        
        self.viewModel.isResult.bind(observer: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                UserDefaultsConfig.kUserStep = 2
                let vc = SetupProfileVC.instantiate(fromAppStoryboard: .auth)
                vc.isToRoot = true
                vc.isBackShown = true
                vc.verifyUserModel = self.verifyUserModel
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .failure(let error):
//                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true, isBCP: true)
                break
            case .none: break
            }
        })
    }
    
  
    //------------------------------------------------------------------------------------------
    
}

