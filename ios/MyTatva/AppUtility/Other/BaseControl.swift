//
//  BaseControl.swift
//
//  Created by 2020M03 on 05/07/21.
//

import UIKit

public typealias SDSwitchValueChange  = (_ value: Bool) -> Void
open  class BaseControl: UIControl {

    // MARK: - Property
     open var valueChange: SDSwitchValueChange?
   
     open var isOn: Bool = false
}

