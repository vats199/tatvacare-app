//
//  DiscountCell.swift
//  MyTatva
//
//  Created by 2022M43 on 22/08/23.
//

import UIKit

class DiscountCell: UITableViewCell {
    
    //MARK: - Outlets -
    @IBOutlet weak var vwBG: UIView!
    
    @IBOutlet weak var imgDiscount: UIImageView!
    @IBOutlet weak var lblApply: UILabel!
    
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblGetOff: UILabel!
    @IBOutlet weak var lblUpto: UILabel!
    
    @IBOutlet weak var vwViewHideMain: UIView!
    @IBOutlet weak var vwViewHideDetails: UIView!
    @IBOutlet weak var lblViewHideDetails: UILabel!
    @IBOutlet weak var imgViewHideIcon: UIImageView!
    
    @IBOutlet weak var vwDesc: UIView!
    @IBOutlet weak var webDesc: WKWebView!
    @IBOutlet weak var webDescHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnApply: UIButton!
    
    //MARK: - Class Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgDiscount.image = UIImage(named: "discount_ic")
        self.imgViewHideIcon.image = UIImage(named: "downArrow_ic")
        
        self.lblCode.font(name: .medium, size: 14).textColor(color: .themeBlack2)
        self.lblGetOff.font(name: .medium, size: 12).textColor(color: .ThemeGray61)
        self.lblUpto.font(name: .regular, size: 12).textColor(color: .themeGray4)
        
        self.lblViewHideDetails.font(name: .semibold, size: 12).textColor(color: .themePurple)
        self.lblApply.font(name: .semibold, size: 12).textColor(color: .themePurple).text = "Apply"
        
        self.vwBG.cornerRadius(cornerRadius: 12).themeShadowBCP()
        
        func getZoomDisableScript() -> WKUserScript {
            let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
            return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        }
        self.webDesc.configuration.userContentController.addUserScript(getZoomDisableScript())
        
    }
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension DiscountCell: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webDesc.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webDesc.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                    self.webDescHeightConst.constant = height as! CGFloat
                    self.contentView.layoutIfNeeded()
                })
            }
        })
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\(navigation.debugDescription)")
    }
    
}
