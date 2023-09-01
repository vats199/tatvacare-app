//
//  DiscoverEngageFilterTblCell.swift
//  MyTatva
//
//  Created by Darshan Joshi on 13/10/21.
//

import Foundation

class DiscoverEngageFilterTblCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var colView          : UICollectionView!
    @IBOutlet weak var colViewHeight    : NSLayoutConstraint!
    
    //MARK:- Class Variable
    var arrData     = [JSON]()
    var object      = ContenFilterListModel()
    var type: DiscoverEngageFilterType = .ContentTypes
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addObserverOnHeightTbl()
        
        self.lblTitle.font(name: .medium, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        self.setup(colView: self.colView)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.backGroundColor(color: .white)
        }
    }
    
    func setup(colView: UICollectionView){
        colView.delegate                   = self
        colView.dataSource                 = self
        colView.reloadData()
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
}

class DiscoverEngageFilterTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    
    //MARK:- Class Variable
    var arrData = [JSON]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.lblTitle.font(name: .medium, size: 12)
//            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 14).applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.ThemeDeviceShadow, shadowOpacity: 0.5)
            
            //    .backGroundColor(color: UIColor.themeLightGray)
        }
    }
}

//MARK: ------------------- UICollectionView Methods -------------------
extension DiscoverEngageFilterTblCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colView:

            switch self.type {
            
            case .Languages:
                return self.object.language != nil ? self.object.language.count : 0
            case .Genres:
                return self.object.genre != nil ? self.object.genre.count : 0
            case .Topics:
                return self.object.topic != nil ? self.object.topic.count : 0
            case .ContentTypes:
                return self.object.contentType != nil ? self.object.contentType.count : 0
            case .question_type:
                return self.object.questionType != nil ? self.object.questionType.count : 0
            }
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case self.colView:
            let cell : DiscoverEngageFilterTypeCell = collectionView.dequeueReusableCell(withClass: DiscoverEngageFilterTypeCell.self, for: indexPath)
            
            var isSelected = false
            switch self.type {
            
            case .Languages:
                let obj = self.object.language[indexPath.item]
                cell.lblTitle.text = obj.languageName
                isSelected = obj.isSelected
                break
                
            case .Genres:
                let obj = self.object.genre[indexPath.item]
                cell.lblTitle.text = obj.genre
                isSelected = obj.isSelected
                break
            case .Topics:
                let obj = self.object.topic[indexPath.item]
                cell.lblTitle.text = obj.name
                isSelected = obj.isSelected
                break
                
            case .ContentTypes:
                let obj = self.object.contentType[indexPath.item]
                cell.lblTitle.text = obj.contentType
                isSelected = obj.isSelected
                break
            
            case .question_type:
                let obj = self.object.questionType[indexPath.item]
                cell.lblTitle.text = obj.title
                isSelected = obj.isSelected
                break
            }
            
            if isSelected {
                cell.lblTitle.font(name: .medium, size: 12)
                    .textColor(color: UIColor.white)
                cell.vwBg.backGroundColor(color: UIColor.themeLightPurple)
            }
            else {
                cell.lblTitle.font(name: .medium, size: 12)
                    .textColor(color: UIColor.themeBlack.withAlphaComponent(0.5))
                cell.vwBg.backGroundColor(color: UIColor.themeLightGray)
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colView:
            
            switch self.type {
            
            case .Languages:
                let obj = self.object.language[indexPath.item]
                self.object.language = self.object.language.filter({ (object) -> Bool in
                    if obj.languagesId == object.languagesId {
                        if object.isSelected {
                            object.isSelected = false
                        }
                        else {
                            object.isSelected = true
                        }
                    }
                    return true
                })
                
                break
                
            case .Genres:
                let obj = self.object.genre[indexPath.item]
                self.object.genre = self.object.genre.filter({ (object) -> Bool in
                    if obj.genreMasterId == object.genreMasterId {
                        if object.isSelected {
                            object.isSelected = false
                        }
                        else {
                            object.isSelected = true
                        }
                    }
                    return true
                })
                
                break
            case .Topics:
                let obj = self.object.topic[indexPath.item]
                self.object.topic = self.object.topic.filter({ (object) -> Bool in
                    if obj.topicMasterId == object.topicMasterId {
                        if object.isSelected {
                            object.isSelected = false
                        }
                        else {
                            object.isSelected = true
                        }
                    }
                    return true
                })
                break
                
            case .ContentTypes:
                let obj = self.object.contentType[indexPath.item]
                self.object.contentType = self.object.contentType.filter({ (object) -> Bool in
                    if obj.contentTypeId == object.contentTypeId {
                        if object.isSelected {
                            object.isSelected = false
                        }
                        else {
                            object.isSelected = true
                        }
                    }
                    return true
                })
                break
            case .question_type:
                let obj = self.object.questionType[indexPath.item]
                self.object.questionType = self.object.questionType.filter({ (object) -> Bool in
                    if obj.value == object.value {
                        if object.isSelected {
                            object.isSelected = false
                        }
                        else {
                            object.isSelected = true
                        }
                    }
                    return true
                })
                break
            }
            
            break
        
        default:break
        }
        self.colView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colView:
            var width: CGFloat  = 100
            //let width       = self.colView.frame.size.width
            switch self.type {
            
            case .Languages:
                let obj = self.object.language[indexPath.item]
                width   = obj.languageName.width(withConstraintedHeight: 30, font: UIFont.customFont(ofType: .medium, withSize: 12.0))
                break
                
            case .Genres:
                let obj = self.object.genre[indexPath.item]
                width   = obj.genre.width(withConstraintedHeight: 30, font: UIFont.customFont(ofType: .medium, withSize: 12.0))
                break
            case .Topics:
                let obj = self.object.topic[indexPath.item]
                width   = obj.name.width(withConstraintedHeight: 30, font: UIFont.customFont(ofType: .medium, withSize: 12.0))
                break
                
            case .ContentTypes:
                let obj = self.object.contentType[indexPath.item]
                width   = obj.contentType.width(withConstraintedHeight: 30, font: UIFont.customFont(ofType: .medium, withSize: 12.0))
                break
            case .question_type:
                let obj = self.object.questionType[indexPath.item]
                width   = obj.title.width(withConstraintedHeight: 30, font: UIFont.customFont(ofType: .medium, withSize: 12.0))
                break
            }
            let height      = 40 * ScreenSize.widthAspectRatio
            
            return CGSize(width: width + 40,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: -------------------------- Observers Methods --------------------------
extension DiscoverEngageFilterTblCell {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UICollectionView, obj == self.colView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            let oldHeight = self.colViewHeight.constant
            self.colViewHeight.constant = newvalue.height
            
            if let tbl = self.superview as? UITableView {
                if oldHeight != self.colViewHeight.constant {
                    tbl.performBatchUpdates {
                        
                    } completion: { isDone in
                        
                    }
                    tbl.layoutIfNeeded()
                    
//                    tbl.beginUpdates()
//                    tbl.endUpdates()
                }
            }
        }
    }
    
    func addObserverOnHeightTbl() {
        self.colView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let colView = self.colView else {return}
        if let _ = colView.observationInfo {
            colView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
