//
//  Localization.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension String {
    
    var localized: String {
        //  print("NSLocalizedString localized :::::::::::::::: \(self)")
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main.getBundleName(), value: "", comment: "")
    }
    
    /// Fetches a localised String Arguments
    ///
    /// - Parameter arguments: parameters to be added in a string
    /// - Returns: localized string
    public func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized(), locale: nil, arguments: arguments)
    }
    
    func localized(_ value : CVarArg...) -> String{
        let t = StringResourceUtility.Localizer()
        return withVaList(value) { t(self, $0) }
    }
}

extension UITextView {
    
}

extension UIBarItem {
    
    open override func awakeFromNib() {
        if let titleValue = self.title {
            self.title = titleValue.localized
        }
    }
}

extension UINavigationItem {
    open override func awakeFromNib() {
        if let titleValue = self.title {
            self.title = titleValue.localized
        }
    }
}

extension UISearchController {
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension UISearchBar {
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension UISegmentedControl {
    open override func awakeFromNib() {
        for index in 0..<numberOfSegments {
            if let title = titleForSegment(at: index) {
                setTitle(title.localized, forSegmentAt: index)
            }
        }
    }
}
