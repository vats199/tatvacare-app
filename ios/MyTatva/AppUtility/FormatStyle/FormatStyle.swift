//
//  FormatStyle.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit


//Need Protocol to maintain typecast

protocol FormatStyle { }

protocol ViewStyle { } 

extension UILabel: FormatStyle { }

extension UIButton: FormatStyle { }

extension UITextField: FormatStyle { }

extension UITextView: FormatStyle { }

extension UIBarButtonItem: FormatStyle { }

extension UIView: ViewStyle { }
