//
//  UITableView+Extension.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}

extension UITableView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorStyle = .none
    }
    
    func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        return cell
    }
    
    func addBottomIndicator(){
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(44))
        self.tableFooterView = spinner
        self.tableFooterView?.isHidden = false
        self.reloadData()
    }
    
    func removeBottomIndicator(){
        self.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.width, height: 0))
        self.tableFooterView?.isHidden = false
//        self.reloadData()
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        return cell
    }
    
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }
    
    func registerNib<T: UITableViewCell>(forCellWithClass name: T.Type) {
        register(UINib.init(nibName: String(describing: name), bundle: nil), forCellReuseIdentifier: String(describing: name))
    }
    
    func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard indexPath.section < numberOfSections else { return }
        guard indexPath.row < numberOfRows(inSection: indexPath.section) else { return }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message.localized
        messageLabel.textColor = UIColor.gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.customFont(ofType: .bold, withSize: 18)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restoreEmptyMessage() {
        self.backgroundView = nil
    }
    
    func setTableHeaderMessageWithImage(_ message : String, image : UIImage = UIImage(), isAddInHeader : Bool = true)  {
        
        let size = ScreenSize.width / 2
        let labelHeight = CGFloat(100.0)
        let viewHeader = UIView()
        viewHeader.frame = self.frame
        viewHeader.tag = 120795
        
        // create imageview
        let imgView = UIImageView()
        _ = (ScreenSize.width / 2) - (size / 2)
        let yPositionImage = (self.frame.size.height / 2) - 40
        imgView.frame = CGRect(x: 0, y: yPositionImage, width: self.frame.size.width, height: 30)
        imgView.contentMode = .center
        imgView.image = image
        
        // create dynamic label
        let lbl = UILabel(frame: CGRect(x: 5, y: imgView.frame.origin.y + 90 , width: self.frame.size.width - 10, height: labelHeight))
        lbl.text = message.localized
        lbl.font(name: .regular, size: 18).textColor(color: #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1).withAlphaComponent(0.6))
        lbl.textAlignment = .center
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        
        viewHeader.addSubview(imgView)
        viewHeader.addSubview(lbl)
        if isAddInHeader {
            self.tableHeaderView = viewHeader
        } else {
            self.tableFooterView = viewHeader
        }
        
    }
    
    func tableViewScrollToTop(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let numberOfSections = self.numberOfSections
            if numberOfSections <= 0 { return }
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: 0, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: animated)
            }
        }
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let numberOfSections = self.numberOfSections
            if numberOfSections <= 0 { return }
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows - 1, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
            }
        }
    }
    
    func tableViewScrollToTopForLastIndex(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let numberOfSections = self.numberOfSections
            if numberOfSections <= 0 { return }
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows - 1, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: animated)
            }
        }
    }
    
    func findCurrentPath() -> IndexPath? {
        let p = CGPoint(x: self.frame.width/2, y: self.contentOffset.y + self.frame.width/2)
        return self.indexPathForRow(at: p)
    }
    
    func findCurrentCell(path: IndexPath) -> UITableViewCell {
        return self.cellForRow(at: path)!
    }
    
    func setSafeAreaOffset() {
        let bottomInset = UIApplication.safeArea.bottom
        self.contentInset = UIEdgeInsets(top: self.contentInset.top, left: self.contentInset.left, bottom: bottomInset, right: self.contentInset.right)
    }
    
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }
        
        return lastIndexPath == indexPath
    }
}


extension UITableView {
    
    func animateTable() {
        self.reloadData()
        let cells = self.visibleCells
        let tableHeight: CGFloat = self.bounds.size.height
        for i in cells {
            let cell: UITableViewCell = i
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
    
    func animateTableHorizontally(isFromRight : Bool = false) {
        self.reloadData()
        let cells = self.visibleCells
        let tableWidth: CGFloat = self.bounds.size.width
        for i in cells {
            let cell: UITableViewCell = i
            if isFromRight {
                cell.transform = CGAffineTransform(translationX: tableWidth, y: 0)
            }
            else {
                cell.transform = CGAffineTransform(translationX: -tableWidth, y: 0)
            }
        }
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
    
    func reloadAllDataWithoutScroll() {
        let contentOffset = self.contentOffset
        self.reloadData()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
    }
}
