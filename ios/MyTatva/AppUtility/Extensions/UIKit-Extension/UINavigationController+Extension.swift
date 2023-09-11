//
//  GExtension+UINavigationController.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension UINavigationController : UIGestureRecognizerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.modalPresentationStyle = .overFullScreen
        
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.navigationItem.setHidesBackButton(true, animated: true)
        clearNavigation()
        setLargeNavigation()
        
        NotificationCenter.default.setObserver(observer: self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.setObserver(observer: self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func clearNavigation(font: UIFont = UIFont.customFont(ofType: .semibold, withSize: 18.0),
                         textColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                         navigationColor: UIColor = .clear,
                         largeTitleColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                         withShadow: Bool = false,
                         isShowSeperator: Bool = false) {
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font : font]
        
        self.navigationBar.backgroundColor = navigationColor
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.isOpaque = true
        self.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setValue(true, forKey: "hidesShadow")
        
        if let statusBarView = UIApplication.shared.statusBarUIView {
            statusBarView.backgroundColor = navigationColor
        }
        
        if withShadow {
            //add shdow
            self.navigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
            self.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 7.0)
            self.navigationBar.layer.shadowRadius = 5.0
            self.navigationBar.layer.shadowOpacity = 0.6
            self.navigationBar.layer.masksToBounds = false
        }
        
        
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: largeTitleColor, NSAttributedString.Key.font : UIFont.customFont(ofType: .bold, withSize: 30.0)]
    }
    
    func setThemeNavigation() {
        clearNavigation(textColor: .white, navigationColor: #colorLiteral(red: 0.2156862745, green: 0.3882352941, blue: 0.9490196078, alpha: 1))
    }
    
    func setLargeNavigation (_ isLarge : Bool = false) {
        if isLarge {
            self.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
            
        } else {
            self.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count <= 1 {
            return false
        }
//        if let topVC = UIApplication.topViewController() {
//            for vc in kDisablePopBackVCS{
//                if topVC.isKind(of: vc as! AnyClass){
//                    return false
//                }
//            }
//        }
//        return true
        
        return false
    }
    
    @objc func appMovedToBackground() {
        if isAppBackgroundForGAOnce {
            isAppBackgroundForGAOnce = false
            if let _ = UIApplication.topViewController() as? HomeVC {
                FIRAnalytics.manageTimeSpent(on: .Home, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? CarePlanVC {
                FIRAnalytics.manageTimeSpent(on: .CarePlan, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? EngageParentVC {
                FIRAnalytics.manageTimeSpent(on: .DiscoverEngage, when: .Disappear)
            }
            
            if let vc = UIApplication.topViewController() as? ExerciseParentVC {
                if vc.selectedIndex == 0 {
                    FIRAnalytics.manageTimeSpent(on: .ExercisePlan, when: .Disappear)
                }
                else {
                    FIRAnalytics.manageTimeSpent(on: .ExerciseMore, when: .Disappear)
                }
            }
            
            if let vc = UIApplication.topViewController() as? ExerciseDetailsParentVC {
                if vc.selectedIndex == 0 {
                    FIRAnalytics.manageTimeSpent(on: .ExercisePlanDayDetailBreathing, when: .Disappear)
                }
                else {
                    FIRAnalytics.manageTimeSpent(on: .ExercisePlanDayDetailExercise, when: .Disappear)
                }
            }
            
            if let _ = UIApplication.topViewController() as? AddPrescriptionVC {
                FIRAnalytics.manageTimeSpent(on: .SetUpDrugs, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? FoodLogVC {
                FIRAnalytics.manageTimeSpent(on: .LogFood, when: .Disappear)
            }
            
            if let vc = UIApplication.topViewController() as? FoodDiaryParentVC {
                if vc.selectedIndex == 0 {
                    FIRAnalytics.manageTimeSpent(on: .FoodDiaryDay, when: .Disappear)
                }
                else {
                    FIRAnalytics.manageTimeSpent(on: .FoodDiaryMonth, when: .Disappear)
                }
            }
            
            if let _ = UIApplication.topViewController() as? FoodDiaryDetailVC {
                FIRAnalytics.manageTimeSpent(on: .FoodDiaryDayInsight, when: .Disappear)
            }
            
            if let vc = UIApplication.topViewController() as? EngageContentDetailVC {
                var screenName:ScreenName = .ContentDetailBlog
                
                if vc.object.contentType != nil {
                    if let type: EngageContentType = EngageContentType.init(rawValue: vc.object.contentType) {
                        
                        switch type {
                        case .BlogArticle:
                            screenName = .ContentDetailBlog
                            break
                        case .Photo:
                            screenName = .ContentDetailPhotoGallery
                            break
                        case .KOLVideo:
                            screenName = .ContentDetailKolVideo
                            break
                        case .Video:
                            screenName = .ContentDetailNormalVideo
                            break
                        case .Webinar:
                            screenName = .ContentDetailWebinar
                            break
                        case .ExerciseVideo:
                            screenName = .ContentDetailNormalVideo
                            break
                        }
                        FIRAnalytics.manageTimeSpent(on: screenName, when: .Disappear)
                    }
                }
            }
            
            if let _ = UIApplication.topViewController() as? ExerciseMyPlanVC {
                FIRAnalytics.manageTimeSpent(on: .ExercisePlan, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? ExercisePlanDetailVC {
                FIRAnalytics.manageTimeSpent(on: .ExercisePlanDetail, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? ExerciseMoreVC {
                FIRAnalytics.manageTimeSpent(on: .ExerciseMore, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? HelpAndSupportVC {
                FIRAnalytics.manageTimeSpent(on: .HelpSupportFaq, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? AddWeightHeightVC {
                FIRAnalytics.manageTimeSpent(on: .SetHeightWeight, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? MyDevicesVC {
                FIRAnalytics.manageTimeSpent(on: .MyDevices, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? SetLocationVC {
                FIRAnalytics.manageTimeSpent(on: .SelectLocation, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? AddGoalsVC {
                FIRAnalytics.manageTimeSpent(on: .SelectGoals, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? AddReadingsVC {
                FIRAnalytics.manageTimeSpent(on: .SelectReadings, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? SetGoalsVC {
                FIRAnalytics.manageTimeSpent(on: .SetUpGoalsReadings, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? MenuVC {
                FIRAnalytics.manageTimeSpent(on: .Menu, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? AccountSettingVC {
                FIRAnalytics.manageTimeSpent(on: .MyAccount, when: .Disappear)
            }
            
            if let _ = UIApplication.topViewController() as? ExerciseStartVC {
                FIRAnalytics.manageTimeSpent(on: .BreathingVideo, when: .Disappear)
            }
            
            if let vc = UIApplication.topViewController() as? HistoryParentVC {
                if vc.selectedIndex == 0 {
                    FIRAnalytics.manageTimeSpent(on: .HistoryIncident, when: .Disappear)
                }
                else {
                    FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Disappear)
                }
            }
        }
        
        print("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦 App moved to background!")
    }
    
    @objc func appBecomeActive() {
        kScreenTimeStart = Date()
        print("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦 App become active")
    }
}

class WhiteNavigationBaseVC : UIViewController {
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.clearNavigation(textColor: UIColor.themeBlack, navigationColor: UIColor.white)
    }
}

class WhiteNavigationBaseShadowVC : UIViewController {
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.clearNavigation(textColor: UIColor.themeBlack, navigationColor: UIColor.white, withShadow: true)
    }
}

class LightPurpleNavigationBase : UIViewController {
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.clearNavigation(textColor: UIColor.themeBlack, navigationColor: .BCPBG, withShadow: false)
    }
}

class ClearNavigationFontBlackBaseVC : UIViewController {
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.clearNavigation(textColor: UIColor.themeBlack)
    }
}

class WhiteGradientNavigationBaseVC : UIViewController {
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let color = GFunction.shared.applyGradientColor(startColor: UIColor.white,
                                                        endColor: UIColor.white.withAlphaComponent(0),
                                                        locations: [0, 1],
                                                        startPoint: CGPoint.zero,
                                                        endPoint: CGPoint(x: 0, y: self.navigationController!.navigationBar.frame.maxY),
                                                        gradiantWidth: self.navigationController!.navigationBar.frame.width,
                                                        gradiantHeight: self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height)
        self.navigationController?.clearNavigation(textColor: UIColor(named: "ThemeBlack")!, navigationColor: color)
    }
}

extension NotificationCenter {
    
    func setObserver(observer: AnyObject, selector: Selector, name: NSNotification.Name, object: AnyObject?) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(observer, name: name, object: object)
        notificationCenter.addObserver(observer, selector: selector, name: name, object: object)
      }
}
