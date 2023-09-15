
//  Created by apple on 11/09/23.
//  Copyright © 2023 . All rights reserved.
//

import UIKit
import WebKit

enum WebViewType: String {
    case helpFaq                = "Help & FAQ"
    case needHelp               = "Need Help"
    case Terms                  = "Terms & Conditions"
    case Privacy                = "Privacy Policy"
    case AboutUs                = "About Us"
    case SupportUs              = "Contact Us"
    case AppointmentPayment     = "Payment"
    case ThyrocareTerms         = "Terms & Conditionsvv"
}

class WebviewVC: WhiteNavigationBaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet var btnBack           : UIBarButtonItem!
    @IBOutlet var webView           : WKWebView!
    @IBOutlet var lblTitle          : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var webType: WebViewType    = .AboutUs
    var strUrl                  = ""
    var isBack                  = true
    var completionHandler: ((_ obj : JSON?) -> Void)?
    //-----------Ï-------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    func setUpView() {
        
//        self.lblTitle.text = self.webType.rawValue
        
        self.lblTitle.text = ""
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
        if self.isBack {
            self.btnBack.image = UIImage(named: "goal-cross")
        }
        else {
            self.btnBack.image = UIImage(named: "goal-cross")
        }
        
        switch self.webType {
            
        case .helpFaq:
            let url = URL(string: "http://3.108.137.85/cms/user_help_faq")
            let requestObj = URLRequest(url: url! as URL)
            self.webView.load(requestObj)
            
            break
            
        case .Terms:
            let url = URL(string: kTerms /*"http://3.108.137.85/cms/user_terms_privacy_policy"*/)
            let requestObj = URLRequest(url: url! as URL)
            self.webView.load(requestObj)
           
            break
            
        case .Privacy:
            let url = URL(string: kPrivacy /*"http://3.108.137.85/cms/user_terms_privacy_policy"*/)
            let requestObj = URLRequest(url: url! as URL)
            self.webView.load(requestObj)
            
            break
            
        case .AboutUs:
            let url = URL(string: "http://3.108.137.85/cms/user_about_us")
            let requestObj = URLRequest(url: url! as URL)
            self.webView.load(requestObj)
        
            break
            
        case .SupportUs:
            let url = URL(string: "http://3.108.137.85/cms/user_help_fa")
            let requestObj = URLRequest(url: url! as URL)
            self.webView.load(requestObj)
            
            break
       
            
        case .needHelp:
            let url = URL(string: "http://google.co.in")
            let requestObj = URLRequest(url: url! as URL)
            self.webView.load(requestObj)
            break
        case .AppointmentPayment:
            let url = URL(string: self.strUrl)
            let requestObj = URLRequest(url: url! as URL)
            self.webView.load(requestObj)
            break
        case .ThyrocareTerms:
            let url = URL(string: "https://admin.mytatva.in/terms_of_use.html")
            let requestObj = URLRequest(url: url! as URL)
            self.webView.load(requestObj)
            break
        
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    @IBAction func btnBackTapped(sender: UIBarButtonItem){
        self.view.endEditing(true)
        if self.isBack {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.setUpView()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        DispatchQueue.main.async {
            AppLoader.shared.addLoader()
        }
        
    }
}

//MARK: -------------------------  WebView method -------------------------
extension WebviewVC : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url)
        
        DispatchQueue.main.async {
            AppLoader.shared.removeLoader()
        }
        
        if let url = webView.url {
            if url.absoluteString.contains("appointmentpay-success.php") {
                if self.webType == .AppointmentPayment {
                    if let completionHandler = self.completionHandler {
                        var obj = JSON()
                        obj["done"] = true
                        completionHandler(obj)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in

            DispatchQueue.main.async {
            }
            
            if complete != nil {
                
                webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                    
                    
                })
            }
        })
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\(navigation.debugDescription)")
    }
    
}

extension WebviewVC: WKUIDelegate {

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: AppMessages.ok, style: .default, handler: { (action) in
            
            if self.webType == .AppointmentPayment {
                if let completionHandler = self.completionHandler {
                    var obj = JSON()
                    obj["done"] = true
                    completionHandler(obj)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            completionHandler()
        }))

        present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: AppMessages.ok, style: .default, handler: { (action) in
            completionHandler(true)
        }))

        alertController.addAction(UIAlertAction(title: AppMessages.cancel, style: .default, handler: { (action) in
            completionHandler(false)
        }))

        present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .actionSheet)

        alertController.addTextField { (textField) in
            textField.text = defaultText
        }

        alertController.addAction(UIAlertAction(title: AppMessages.ok, style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))

        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button"), style: .default, handler: { (action) in
            completionHandler(nil)
        }))

        present(alertController, animated: true, completion: nil)
    }

}

