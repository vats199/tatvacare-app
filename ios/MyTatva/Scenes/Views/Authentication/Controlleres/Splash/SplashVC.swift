//
//  SplashVC.swift
//  MyTatva
//
//  Created by Uttam patel on 06/06/23.
//


import UIKit

class SplashVC: UIViewController {
    
    //MARK:- Outlet
    
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var viewModel: SplashVM!
    
    //------------------------------------------------------
    
    
    //MARK:- Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = SplashVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GlobalAPI.shared.apiWalkthroughList { [weak self] dataResponse in
            guard let self = self else { return }
            let vc = WalkthroughVC.instantiate(fromAppStoryboard: .auth)
            vc.viewModel.arrWalkthroughList = dataResponse
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    
}

