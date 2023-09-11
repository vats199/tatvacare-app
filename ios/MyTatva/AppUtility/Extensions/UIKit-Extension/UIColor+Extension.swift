//
//  GExtension.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension UIColor {
//    static var lightGray: UIColor {
//        UIColor(named: "LightGray") ?? .lightText
//    }
//
    static var themeBorder2: UIColor {
        UIColor(named: "ThemeBorder2") ?? .gray
    }
    
    
    static var themePurple: UIColor {
        UIColor(named: "ThemePurple") ?? .red
    }
    
    static var themeLightPurple: UIColor {
        UIColor(named: "ThemeLightPurple") ?? .red
    }
    
    static var themeFb: UIColor {
        UIColor(named: "ColorFb") ?? .red
    }
    
    static var themeGoogle: UIColor {
        UIColor(named: "ColorGoogle") ?? .red
    }
    
    static var themeRed: UIColor {
        UIColor(named: "ThemeRed") ?? .red
    }
    
    static var themeRedHome: UIColor {
        UIColor(named: "ThemeRedHome") ?? .red
    }
    
    static var ThemeBorder: UIColor {
        UIColor(named: "ThemeBorder") ?? .red
    }
   
    static var themeLightGray: UIColor {
        UIColor(named: "ThemeLightGray") ?? .lightGray
    }
    
    static var themeGray: UIColor {
        UIColor(named: "ThemeGray") ?? .gray
    }
    
    static var themePurpleBlack: UIColor {
        UIColor(named: "ThemePurpleBlack") ?? .black
    }
    
    static var themePurpleBlack2: UIColor {
        UIColor(named: "ThemePurpleBlack2") ?? .black
    }
    
    static var themeBlack: UIColor {
        UIColor(named: "ThemeBlack") ?? .black
    }
    
    static var themeBlack2: UIColor {
        UIColor(named: "ThemeBlack2") ?? .black
    }
    
    static var themeBlack3: UIColor {
        UIColor(named: "ThemeBlack3") ?? .black
    }
        
    static var themeBoxShadow: UIColor {
        UIColor(named: "ThemeBoxShadow") ?? .black
    }
    
    static var themeYellow: UIColor {
        UIColor(named: "ThemeYellow") ?? .green
    }
    
    static var themeGreen: UIColor {
        UIColor(named: "ThemeGreen") ?? .green
    }
    
    static var themeOrange: UIColor {
        UIColor(named: "ThemeOrange") ?? .red
    }
    
    //Summary
    static var colorExercise: UIColor {
        UIColor(named: "ColorExercise") ?? .red
    }
    
    static var colorMedication: UIColor {
        UIColor(named: "ColorMedication") ?? .red
    }
   
    static var colorReport: UIColor {
        UIColor(named: "ColorReport") ?? .red
    }
    
    static var colorPranayam: UIColor {
        UIColor(named: "ColorPranayam") ?? .red
    }
    
    static var colorSteps: UIColor {
        UIColor(named: "ColorSteps") ?? .red
    }
    
    //MARK:-------------------- Colors for BCA
    static var themeLow: UIColor {
        UIColor(named: "ThemeLow") ?? .red
    }
    
    static var themeNormal: UIColor {
        UIColor(named: "ThemeNormal") ?? .red
    }
    
    static var themeDanger: UIColor {
        UIColor(named: "ThemeDanger") ?? .red
    }
    
    //MARK:-------------------- Colors for Calories status
    static var colorCalorieExcess: UIColor {
        UIColor(named: "ColorCalorieExcess") ?? .red
    }
    
    static var colorCalorieLess: UIColor {
        UIColor(named: "ColorCalorieLess") ?? .red
    }
    
    static var colorCalorieLimit: UIColor {
        UIColor(named: "ColorCalorieLimit") ?? .red
    }
    
    static var ThemeLightGray2: UIColor {
        UIColor(named: "ThemeLightGray2") ?? .red
    }
    
    static var themeGray3: UIColor {
        UIColor(named: "ThemeGray3") ?? .red
    }
    
    static var themeGray4: UIColor {
        UIColor(named: "ThemeGray4") ?? .red
    }
    
    static var themeGray5: UIColor {
        UIColor(named: "ThemeGray5") ?? .gray
    }
    
    static var ThemeDarkBlack: UIColor {
        UIColor(named: "ThemeDarkBlack") ?? .red
    }
    
    static var colorHealthCoach: UIColor {
        UIColor(named: "ColorHealthCoach") ?? .red
    }
    
    static var themeGreenAlert: UIColor {
        UIColor(named: "ThemeGreenAlert") ?? .green
    }
    
    static var themeRedAlert: UIColor {
        UIColor(named: "ThemeRedAlert") ?? .red
    }
    
    
    static var ThemeDeviceGray: UIColor {
        UIColor(named: "ThemeDevice") ?? .red
    }
    
    static var ThemeDarkGray: UIColor {
        UIColor(named: "ThemeDarkGray") ?? .red
    }

    static var ThemeGrayBG: UIColor {
        UIColor(named: "ThemeGrayBG") ?? .red
    }
    
    static var ThemeDeviceShadow: UIColor {
        UIColor(named: "ThemeDeviceShadow") ?? .red
    }
    
    static var ThemeRedLetters: UIColor {
        UIColor(named: "ThemeRedLetters") ?? .red
    }
    
    static var ThemePurpleView: UIColor {
        UIColor(named: "ThemePurpleView") ?? .red
    }
    
    static var ThemeGray61: UIColor {
        UIColor(named: "ThemeGray61") ?? .red
    }
    
    static var BCPBG: UIColor {
        UIColor(named: "BCPBG") ?? .red
    }
    
    static var ThemeBlack21: UIColor {
        UIColor(named: "ThemeBlack21") ?? .red
    }

    static var ThemeGrayE0: UIColor {
        UIColor(named: "ThemeGrayE0") ?? .red
    }
    
}

extension UIColor {
    class func colorFromHex(hex: Int) -> UIColor { return UIColor(red: (CGFloat((hex & 0xFF0000) >> 16)) / 255.0, green: (CGFloat((hex & 0xFF00) >> 8)) / 255.0, blue: (CGFloat(hex & 0xFF)) / 255.0, alpha: 1.0)
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.themePurple
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
