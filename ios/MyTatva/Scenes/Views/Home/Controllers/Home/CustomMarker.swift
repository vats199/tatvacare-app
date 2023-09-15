//
//  CustomMarker.swift
//

//

import UIKit

class CustomMarker: UIView {

    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var vwImg            : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwImg.layoutIfNeeded()
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    class func instancefromNib() -> UIView {
        return UINib.init(nibName: "CustomMarker", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
}
