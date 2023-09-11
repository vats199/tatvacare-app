//
//  ScreenSize.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 28/02/21.
//

import Foundation
import UIKit

//MARK:- Screen resolution
struct ScreenSize {
    static var scale: CGFloat {
        return UIScreen.main.scale
    }
    
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static var physicalWidth: CGFloat {
        return UIScreen.main.nativeBounds.width
    }
    
    static var physicalHeight: CGFloat {
        return UIScreen.main.nativeBounds.height
    }
    
    static var heightAspectRatio: CGFloat {
        return UIScreen.main.bounds.size.height / 667
    }
    
    static var widthAspectRatio: CGFloat {
        return UIScreen.main.bounds.size.width / 375
    }
    
    static var fontAspectRatio : CGFloat {
        if UIDevice().userInterfaceIdiom == .pad {
            return UIScreen.main.bounds.size.height / 667
        }
        
        if #available(iOS 13.0, *) {
            if let _ = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isPortrait {//Potrait
                return UIScreen.main.bounds.size.width / 375
                
            } else {//Landscape
                return UIScreen.main.bounds.size.height / 375
            }
        }
        else {
            if UIApplication.shared.statusBarOrientation.isPortrait {//Potrait
                return UIScreen.main.bounds.size.width / 375
                
            } else {//Landscape
                return UIScreen.main.bounds.size.height / 375
            }
        }
        
    }
    
    static var cornerRadious: CGFloat {
        return 10
    }
}
