//
//  UIContol+Extension.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import Foundation


extension UIControl {
    func addAction(for controlEvents: UIControl.Event, action: @escaping () -> ()) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        
    }
}

//------------------------------------------------------

//MARK:- Uicontol + Action class

var AssociatedObjectHandle: UInt8 = 0

class ClosureSleeve {
    let closure: () -> ()
    
    init(attachTo: AnyObject, closure: @escaping () -> ()) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, &AssociatedObjectHandle, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc func invoke() {
        closure()
    }
}
