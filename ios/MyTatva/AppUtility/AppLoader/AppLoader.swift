//
//  AppLoader.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

import UIKit
import Lottie

class AppLoader {
    
    //MARK: Shared Instance
    static let shared: AppLoader = AppLoader()
    
    //MARK: Class Variables
    private let viewBGLoder: UIView = UIView()
    let animation = LottieAnimation.named("mytatva_01")
    var loaderAnimation: LottieAnimationView!
    //MARK: Class Funcation
    
    /**
     Add app loader
     */
    func addLoader() {
        
        self.removeLoader()
        DispatchQueue.main.async {
            
//            self.loaderAnimation = LottieAnimationView(animation: self.animation, configuration: LottieConfiguration(renderingEngine: .automatic))
            self.loaderAnimation = LottieAnimationView(animation: self.animation)
            self.viewBGLoder.frame                  = UIScreen.main.bounds
            self.viewBGLoder.tag                    = 1307966
            self.viewBGLoder.backgroundColor        = UIColor.black.withAlphaComponent(0.4)
            self.loaderAnimation.backgroundColor    = .clear
            self.loaderAnimation.loopMode           = .loop
            self.loaderAnimation.autoresizingMask   = [.flexibleHeight, .flexibleWidth]
            self.loaderAnimation.contentMode        = .scaleAspectFit
            self.loaderAnimation.frame              = CGRect(x: (ScreenSize.width/2)-75, y: (ScreenSize.height/2)-75, width: 150, height: 150)
            self.loaderAnimation.backgroundBehavior = .pauseAndRestore
            self.loaderAnimation.animationSpeed     = 1.5
            self.loaderAnimation.play()
            
            self.viewBGLoder.addSubview(self.loaderAnimation)
            
            sceneDelegate.window?.addSubview(self.viewBGLoder)
            sceneDelegate.window?.isUserInteractionEnabled = false
            
//            UIApplication.shared.windows.first?.addSubview(self.viewBGLoder)
//            UIApplication.shared.windows.first?.isUserInteractionEnabled = false
        }
    }
    
    /**
     Remove app loader
     */
    func removeLoader() {
        DispatchQueue.main.async {
//            UIApplication.shared.windows.first?.isUserInteractionEnabled = true
            sceneDelegate.window?.isUserInteractionEnabled = true

            
            if self.loaderAnimation != nil {
                self.loaderAnimation.stop()
                self.loaderAnimation.removeFromSuperview()
                self.viewBGLoder.removeFromSuperview()
//                UIApplication.shared.windows.first?.viewWithTag(1307966)?.removeFromSuperview()
                sceneDelegate.window?.viewWithTag(1307966)?.removeFromSuperview()
            }
            
        }
    }
}
                                                                    
