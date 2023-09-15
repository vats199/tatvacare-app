//
//  NSLayoutConstraint+Class.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 29/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

class TopStratchConstraient: NSLayoutConstraint {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.constant = -(UIApplication.shared.statusBarFrame.size.height +
            (UINavigationController().navigationBar.frame.height))
    }
}
