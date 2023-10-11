//
//  WalkthroughVC.swift
//  MyTatva
//
//  Created by Uttam patel on 05/06/23.
//

import Foundation
import UIKit
import AdvancedPageControl
import SDWebImage
import React

class WalkthroughVC: UIViewController {
    //MARK: - Outlets -
    
    @IBOutlet weak var vwPageControl: AdvancedPageControlView!
    @IBOutlet weak var colWalkthrough: UICollectionView!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var vwBtnBg: UIView!
    
    //MARK: - Class Variables -
    var pendingRequest:DispatchWorkItem?
    
    var viewModel = WalkthroughVM()
    var timeCount = 0
    var resendTimer = Timer()
    var arrData = [WalkthroughListModel]()
    
    var isManualScroll = false

    //---------------------------------------------------------------------------
    
    //MARK: - View Life Cycle -
    

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.setup()
        self.applyStyle()
        self.startTimer()
        
        let isLogin = UserDefaults.standard.bool(forKey: "isWalk")
        if isLogin {
            self.getStartedTapped()
        }
        
    }
    
    //------------------------------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resendTimer.invalidate()
    }
    
    //------------------------------------------------------------------------------------------
    
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
        self.resendTimer.invalidate()
    }
    
    //------------------------------------------------------------------------------------------
    
    //MARK: - Custom Functions -
    
    func setup() {
        let nib = UINib(nibName: "WalkthroughColCell", bundle: nil)
        self.colWalkthrough.register(nib, forCellWithReuseIdentifier: "WalkthroughColCell")
        
        self.colWalkthrough.delegate = self
        self.colWalkthrough.dataSource = self
        
        self.vwPageControl.drawer = SlideDrawer(height:6, width: 30,space: 5, indicatorColor: .themePurpleBlack)
        self.vwPageControl.drawer.numberOfPages = self.viewModel.numOfItem()
    }
    
    //------------------------------------------------------------------------------------------
    
    func applyStyle() {
        DispatchQueue.main.async { [weak self]  in
            guard let self = self else {return}
            self.vwBg.layoutIfNeeded()
            self.vwBg.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        }
        self.btnGetStarted.cornerRadius(cornerRadius: 16).backGroundColor(color: .themePurple)
        self.btnGetStarted.font(name: .bold, size: 16).textColor(color: UIColor.white)
        
    }
    
    //------------------------------------------------------------------------------------------
    
    private func startTimer() {
        resendTimer.invalidate()
        resendTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        DispatchQueue.main.async { [weak self]  in
            guard let self = self else {return}
            
            let currentItems = Int(round(self.vwPageControl.drawer.currentItem))
            
            if self.viewModel.numOfItem() > 1 {
                if self.viewModel.numOfItem() - 1 != Int(round(self.vwPageControl.drawer.currentItem)) {
                    self.colWalkthrough.scrollToItem(at: IndexPath(item: currentItems + 1, section: 0), at: .centeredHorizontally, animated: true)
                    self.vwPageControl.setPage(currentItems + 1)
                    self.fireLogEvent(changeTo: (currentItems + 1) + 1 , changeFrom: (currentItems + 1))
                } else {
                    self.colWalkthrough.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                    self.vwPageControl.setPage(0)
                    self.fireLogEvent(changeTo: 1, changeFrom: self.viewModel.numOfItem())
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.isManualScroll = false
            }
            
        }
        
    }
    
     //------------------------------------------------------------------------------------------
    
    func fireLogEvent(changeTo: Int, changeFrom: Int) {
        var params = [String: Any]()
        params[AnalyticsParameters.changed_from.rawValue]   = changeFrom
        params[AnalyticsParameters.changes_to.rawValue]   = changeTo
        FIRAnalytics.FIRLogEvent(eventName: .PRE_ONBOARDING_CAROUSEL,
                                 screen: .Walkthrough,
                                 parameter: params)
    }
    
     //------------------------------------------------------------------------------------------
    
    func getStartedTapped() {
        self.resendTimer.invalidate()
        var params = [String: Any]()
        params[AnalyticsParameters.carousel_number.rawValue]  = (Int(round(self.vwPageControl.drawer.currentItem)) + 1)
        
        params[AnalyticsParameters.auto_flag.rawValue]   = isManualScroll ? "off" : "on"
        
        FIRAnalytics.FIRLogEvent(eventName: .NEW_USER_SIGNUP_ATTEMPT,
                                 screen: .Walkthrough,
                                 parameter: params)
        
        let vc = EnterMobileViewPopUp.instantiate(fromAppStoryboard: .auth)
        let navController = UINavigationController(rootViewController: vc) //Add navigation controller
        vc.complition = {
            self.startTimer()
        }
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: true, completion: nil)
        
    }
 
    //MARK: - Button Action Methods -
    
    
    @IBAction func btnGetStaetedTapped(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isWalk")
        UserDefaults.standard.synchronize()
        self.getStartedTapped()
        
    }
    
    //------------------------------------------------------------------------------------------
    
}

//MARK: - UICollectionview DataSource & Delegate -

extension WalkthroughVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //---------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numOfItem()
    }
    
    //---------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkthroughColCell", for: indexPath) as! WalkthroughColCell
        let data = self.viewModel.valueForCell(indexPath.row)
        
        if let imgUrl = data.imageUrl {
          //cell.imgGif.image = UIImage.gifImageWithURL(imgUrl)
            cell.imgGif.sd_setImage(with: URL(string: imgUrl), completed: nil)
        }
    
        cell.lblTitle.text = data.title
        cell.lblDescription.text = data.descriptionField
        
        return cell
    }
    
    //---------------------------------------------------------------------------
    
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.colWalkthrough {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            
            self.isManualScroll = true

            vwPageControl.setPageOffset(offSet/width)
            let index = Int(round(offSet/width))
            self.vwPageControl.setPage(index)
            
            /*DispatchQueue.main.async {
                let currentIndex = Int(scrollView.contentOffset.x / CGFloat((ScreenSize.width / 2)))
                guard currentIndex < self.viewModel.numOfItem() else { return }
                self.vwPageControl.setPage(currentIndex)
            }*/
                        
            if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
                self.fireLogEvent(changeTo: index + 1, changeFrom: (index + 2))
            } else {
                self.fireLogEvent(changeTo: index + 1, changeFrom: index)
            }
            
            self.startTimer()
            
        }
    }
    
     //------------------------------------------------------------------------------------------
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let initialPinchPoint = CGPoint(x: self.colWalkthrough.center.x + self.colWalkthrough.contentOffset.x,
                                        y: self.colWalkthrough.center.y + self.colWalkthrough.contentOffset.y)
        if let row = (self.colWalkthrough.indexPathForItem(at: initialPinchPoint))?.row {
            self.vwPageControl.setPage(row)
            self.pendingRequest?.cancel()
            self.pendingRequest = DispatchWorkItem(block: { [weak self] in
                guard let self = self else { return }
                self.startTimer()
            })
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.25, execute: self.pendingRequest!)
        }
        
    }

}
