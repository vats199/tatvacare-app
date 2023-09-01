//
//  UITableView+Class.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

class IntrinsicTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            self.layoutIfNeeded()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        
        self.layoutIfNeeded()
        var size = super.contentSize
        
        if size.height == 0 || size.width == 0 {
            size = self.contentSize
        }
        return size
        //        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
    }
    
    override func reloadData() {
        
        super.reloadData()
        
        setHeaderFooterviewHeight()
        
        self.layoutIfNeeded()
        self.setNeedsLayout()
        self.invalidateIntrinsicContentSize()
        
    }
    
    func setHeaderFooterviewHeight () {
        
        if let headerView = self.tableHeaderView {
            
            headerView.frame.size.height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            self.tableHeaderView = headerView
        }
        
        if let footerView = self.tableFooterView {
            
            footerView.frame.size.height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            self.tableFooterView = footerView
        }
        
        self.layoutIfNeeded()
    }
    
}

class AutomaticHederSizeUpdate: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        setHeaderFooterviewHeight()
    }
    
    func setHeaderFooterviewHeight () {
        
        if let headerView = self.tableHeaderView {
            
            headerView.frame.size.height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            self.tableHeaderView = headerView
        }
        
        if let footerView = self.tableFooterView {
            
            footerView.frame.size.height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            self.tableFooterView = footerView
        }
        
        self.layoutIfNeeded()
    }
    
}

class SelfSizedTableView: UITableView {
    
    @IBInspectable var maxHeight: CGFloat = CGFloat.greatestFiniteMagnitude
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
            //            self.isScrollEnabled = maxHeight < contentSize.height
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        let height = min(contentSize.height + contentInset.top + contentInset.bottom, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
