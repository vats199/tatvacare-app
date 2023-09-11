//
//  GExtension+UIScrollView.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 11, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func addRefreshControl(action: (() -> Void)?){
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.9607843137, alpha: 1)
        refreshControl.addAction(for: .valueChanged) {
            if let refreshAction = action{
                refreshAction()
            }
        }
        self.refreshControl = refreshControl
    }
    
    func endRefreshing(){
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Class Variables
    
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            if let tblView = self as? UITableView {
                if tblView.numberOfRows(inSection: 0) != 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    tblView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
            else {
                let desiredOffset = CGPoint(x: 0, y: -self.contentInset.top)
                self.setContentOffset(desiredOffset, animated: true)
            }
        }
    }
    
    func scrollToBottom(animated: Bool = true) {
        if self.contentSize.height < self.bounds.size.height { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
            self.setContentOffset(bottomOffset, animated: animated)
        }
    }
    
    func scrollToRight(animated: Bool) {
        if Bundle.main.isArabicLanguage {
            self.setContentOffset(.zero, animated: true)
        } else {
            if contentSize.width < bounds.size.width { return }
            let bottomOffset = CGPoint(x: contentSize.width - bounds.size.width, y: .zero)
            self.setContentOffset(bottomOffset, animated: animated)
        }
    }
    
    func scrollToLeft(animated: Bool) {
        if Bundle.main.isArabicLanguage {
            if contentSize.width < bounds.size.width { return }
            let bottomOffset = CGPoint(x: contentSize.width - bounds.size.width, y: .zero)
            self.setContentOffset(bottomOffset, animated: animated)
            
        } else {
            self.setContentOffset(.zero, animated: true)
        }
    }
}
