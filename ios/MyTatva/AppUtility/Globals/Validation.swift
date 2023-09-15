//
//  Validation.swift
//  High5
//
//  Created by on 1/11/2012.
//  Copyright © 2016. All rights reserved.
//

import UIKit

class Validation: NSObject {
    
    static func isAlphabaticString(txt: String)         -> Bool {
        
        let RegEx   = "[A-Za-z]*"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    static func isAtleastOneAlphabaticString(txt: String) -> Bool {
        
        let RegEx   = "^.*[a-zA-Z0-9]+.*$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    
    static func isAlphabaticStringWithSpace(txt: String)         -> Bool {
        
        let RegEx   = "[A-Za-z ]*"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    static func isAlphabaticStringNumWithSpace(txt: String)         -> Bool {
        
        let RegEx   = "[A-Za-z0-9 ]*"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    
    static func isAlphaNummericString(txt: String)      -> Bool {
        
        let RegEx   = "^[A-Za-z0-9 _]+$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    
    static func isValidMiddleName(txt: String)          -> Bool {
        let RegEx   = "[A-Za-z]{1}+\\.?"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        debugPrint("str : \(txt) validation : \(result)")
        return result
    }
    
    
    
    static func isValidFirstName(txt: String)           -> Bool {
        let RegEx   = "^[A-Z][a-z]*$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        debugPrint("str : \(txt) validation : \(result)")
        return result
    }
    
    static func isValidAgeRangeName(txt: String)        -> Bool {
        let RegEx   = "^(0?[1-9]|[1-9][0-9])$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        debugPrint("str : \(txt) validation : \(result)")
        return result
    }
    
    static  func isValidEmail(testStr:String)           -> Bool {
        let emailRegEx  = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"//"^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,4})$"
        let emailTest   = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result  = emailTest.evaluate(with: testStr)
        return result
    }
    
    static func isValidNumber(txt: String)              -> Bool {
        
        let RegEx   = "[0-9]+"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    static func isValidPostalCode(txt: String)          -> Bool {
        
        let RegEx   = "^[A-Za-z0-9- ]{1,10}$"
        debugPrint(txt)
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    static func isValidLength(txt: String , minLength: Int = 0 , maxLength: Int = 25) -> Bool{
        return (txt.count >= minLength && txt.count <= maxLength)
    }
    
    static func isPasswordValid(txt: String) -> Bool {
        
        //let RegEx   = ".{\(Validations.Password.Minimum.rawValue),\(Validations.Password.Maximum.rawValue)}$"
        let RegEx   = Validations.RegexType.Password.rawValue
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    static func isPhoneNumber(txt: String) -> Bool {
        
        let first2 = String(txt.prefix(2))
        
        let RegEx   = "^[0-9+][0-9]$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: first2)
        return result
        
    }
    
    static func isValidVPN(txt: String) -> Bool {
        //"^[A-HJ-NPR-Z0-9]{0,50}$"//"^[A-HJ-NPR-Z0-9]*$"
        //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d|$@$!%*?&.]{6,}$"
        
        //let first2 = String(txt.prefix(2))
        
        let RegEx   = "^(?=.*[A-Z])(?=.*\\d)[A-HJ-NPR-ZZ\\d]{17,50}$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result
        
    }
    
    static func isValidFax(txt: String) -> Bool {
        
        let RegEx   = "\\+[0-9]{1,3}-[0-9]{1,3}\\-[0-9]{1,7}"
        
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result
    }
    
    static func isValidWebsite(txt: String) -> Bool {
        
        let RegEx   = "^(https|http?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result
    }
    
}




