//
//  LoginHeaderView.swift
//  MyTatva
//
//  Created by Hlink on 24/04/23.
//

import Foundation
import UIKit
class LoginHeaderView: UIView {
    
    //------------------------------------------------------
    //MARK: - Outlets
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    //------------------------------------------------------
    //MARK: - Class Methods
    
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
    //------------------------------------------------------
    //MARK: - Custom Methods
    
    private func applyStyle() {
        self.lblTitle.font(name: .semibold, size: 17.0).textColor(color: .themeBlack).numberOfLines = 0
        self.lblTitle.textAlignment = .center
        self.lblTitle.text = "Login / Sign - Up via Phone Number to start using MyTatva"
        self.lblSubTitle.font(name: .regular, size: 14.0).textColor(color: .themeGray).numberOfLines = 0
        self.lblSubTitle.text = "We’ll send you a One Time Password"
        self.lblSubTitle.textAlignment = .center
    }
    
    func setData(title:String,subTitle: String,imgMain: String? = nil) {
        
        if let imgMain = imgMain {
            self.imgMain.image = UIImage(named: imgMain)
        }
        
        self.lblTitle.text = title
        self.lblSubTitle.text = subTitle
        
    }
    
    func getViewHeight(completion: ((CGFloat) -> ())? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            completion?(self.vwMain.frame.height)
        }
        
    }
    
}
