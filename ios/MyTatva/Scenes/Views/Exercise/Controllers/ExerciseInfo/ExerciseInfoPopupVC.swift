//
//  ExerciseInfoPopupVC.swift
//  MyTatva
//
//  Created by hyperlink on 02/11/21.
//

import UIKit
import WebKit

class ExerciseInfoPopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var imgBg            : UIImageView!
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var webVwDes         : WKWebView!
    @IBOutlet weak var vwBgHeight       : NSLayoutConstraint!
    @IBOutlet weak var btnOkay          : UIButton!
    @IBOutlet weak var btnCancelTop     : UIButton!
    
    //MARK:- Class Variable
    let viewModel                       = ExerciseInfoPopupVM()
    var infoDesc = String()
    var infoTitle = String()
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK:- UserDefined Methods
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    fileprivate func setUpView() {
        
        self.lblTitle.font(name: .semibold, size: 24).textColor(color: UIColor.themeBlack)
        self.btnOkay.font(name: .medium, size: 14).textColor(color: UIColor.white)
        self.webVwDes.scrollView.isScrollEnabled = false
        
        self.webVwDes.configuration.userContentController.addUserScript(getZoomDisableScript())
        self.webVwDes.navigationDelegate = self
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
            
            self.btnOkay.layoutIfNeeded()
            self.btnOkay.cornerRadius(cornerRadius: 5)
            
            self.btnCancelTop.layoutIfNeeded()
            self.webVwDes.layoutIfNeeded()
            
        }
        self.setData()
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
    }
    
    fileprivate func configureUI(){
        
    }
    
    fileprivate func setData(){
        self.lblTitle.text = self.infoTitle
        self.webVwDes.loadHTMLString(self.infoDesc.replacingOccurrences(of: """
                                                                \"
                                                                """, with: """
                                                                "
                                                                """), baseURL: Bundle.main.bundleURL)
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func dismissPopUp(_ animated : Bool = true, objAtIndex : JSON? = nil) {
        
        func sendData() {
            if let obj = objAtIndex {
                if let completionHandler = completionHandler {
                    completionHandler(obj)
                }
            }
        }
        
        self.dismiss(animated: animated) {
            sendData()
        }
    }
    
    func getZoomDisableScript() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    //MARK:- Action Method
    fileprivate func manageActionMethods(){
        self.btnCancelTop.addTapGestureRecognizer {
            self.dismissPopUp(true)
        }
        
        self.btnOkay.addTapGestureRecognizer {
            var objc = JSON()
            objc["isDone"] = true
            self.dismissPopUp(true, objAtIndex: objc)
        }
        
        self.imgBg.addTapGestureRecognizer {
            self.dismissPopUp(true)
        }
        
    }
    
    //MARK:- Life Cycle Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK: -------------------------  WebView method -------------------------
extension ExerciseInfoPopupVC : WKNavigationDelegate {

func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in

        if complete != nil {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                //self.contentHeights[webView.tag] = height as! CGFloat
                if height as! CGFloat > self.view.bounds.height - (30){
                    self.webVwDes.scrollView.isScrollEnabled = true
                    self.vwBgHeight.constant = self.view.bounds.height - (30)
                }else{
                    self.vwBgHeight.constant += height as! CGFloat
                }
                DispatchQueue.main.async {
                    self.btnCancelTop.layoutIfNeeded()
                    UIView.animate(withDuration: kAnimationSpeed) {
                        self.view.layoutIfNeeded()
                    }
                }
            })
        }
    })
}

func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    print("\(navigation.debugDescription)")
}

}



//MARK: -------------------- setupViewModel Observer --------------------
extension ExerciseInfoPopupVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

