//
//  UIAlertViewControllerStyle+Extension.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController.Style{
    
    /**
     To Show the AlertContrller
     
     - Parameter title: Title of the AlertControler
     - Parameter message: Message to display
     - Parameter actions: Actions of the AlertController
     
     */
    func showAlert(title : String , message : String , actions : [UIAlertAction]){
        let _controller = UIAlertController(title: title.localized, message: message.localized, preferredStyle: self)
        actions.forEach { _controller.addAction($0) }
        UIApplication.topViewController()?.present(_controller, animated: true, completion: nil)
    }
}
