//
//  ValidationConstant.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 28/02/21.
//

import Foundation

//MARK: Min Max Value for validation
struct ValidationConstant {
    static var maxMobileDigit:      Int { return 10 }
    static var minMobileDigit:      Int { return 10 }
    
    static var maxPin:              Int { return 6 }
    static var minPin:              Int { return 3 }
    
    static var maxPassword:         Int { return 6 }
    static var minPassword:         Int { return 8 }
    
    static var maxCVVDigit:         Int { return 4 }
    static var minCVVDigit:         Int { return 3 }
    
    static var maxCardNumber:       Int { return 16 }
    static var minCardNumber:       Int { return 13 }
    
    static var minRoutingNumber:    Int { return 6 }
    
    static var minSSNNumber:        Int { return 8 }
    static var maxSSNNumber:        Int { return 9 }
    
    static var maxPromoCode:        Int { return 7 }
    static var minPromoCode:        Int { return 7 }
}
