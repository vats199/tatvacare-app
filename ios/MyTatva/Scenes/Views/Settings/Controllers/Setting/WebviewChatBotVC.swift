
//  Created by apple on 11/09/22.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
import WebKit


class WebviewChatBotVC: WhiteNavigationBaseVC {
    
    //MARK:- Outlet
    @IBOutlet var webView           : WKWebView!
    @IBOutlet var lblTitle          : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    func setUpView() {
        self.loadData()
    }
    
    func loadData(){
        AppLoader.shared.addLoader()
        //        let htmlString:String! = """
        //<!DOCTYPE html>
        //<html>
        //<head>
        //<title>Page Title</title>
        //
        //<script>
        //(function (d, w, c) { if(!d.getElementById("spd-busns-spt")) { var n = d.getElementsByTagName('script')[0], s = d.createElement('script'); var loaded = false; s.id = "spd-busns-spt"; s.async = "async"; s.setAttribute("data-self-init", "false"); s.setAttribute("data-init-type", "opt"); s.src = 'https://cdn.in-freshbots.ai/assets/share/js/freshbots.min.js'; s.setAttribute("data-client", "6b90669a23306ad7bf5d45c3c42bc8fa646135fb"); s.setAttribute("data-bot-hash", "790de7e1bc910fbefae73125872489d9a92c2026"); s.setAttribute("data-env", "prod"); s.setAttribute("data-region", "in"); if (c) { s.onreadystatechange = s.onload = function () { if (!loaded) { c(); } loaded = true; }; } n.parentNode.insertBefore(s, n); } }) (document, window, function () { Freshbots.initiateWidget({ autoInitChat: false, getClientParams: function () { return {"cstmr::eml":"","cstmr::nm":""}; } }, function(successResponse) { }, function(errorResponse) { }); });
        //</script>
        //
        //</head>
        //<body>
        //
        //<h1></h1>
        //<p></p>
        //
        //</body>
        //</html>
        //"""
                
        let htmlString:String! = """
        <!DOCTYPE html>
        <html>
        <head>
        <title>Page Title</title>

        <script> (function (d, w, c) { if(!d.getElementById("spd-busns-spt")) { var n = d.getElementsByTagName('script')[0], s = d.createElement('script'); var loaded = false; s.id = "spd-busns-spt"; s.async = "async"; s.setAttribute("data-self-init", "false"); s.setAttribute("data-init-type", "opt"); s.src = 'https://cdn.in-freshbots.ai/assets/share/js/freshbots.min.js'; s.setAttribute("data-client", "6b90669a23306ad7bf5d45c3c42bc8fa646135fb"); s.setAttribute("data-bot-hash", "ff945406026d3b7cf7fc8953628101de492b5e93"); s.setAttribute("data-env", "prod"); s.setAttribute("data-region", "in"); if (c) { s.onreadystatechange = s.onload = function () { if (!loaded) { c(); } loaded = true; }; } n.parentNode.insertBefore(s, n); } }) (document, window, function () { Freshbots.initiateWidget({ autoInitChat: false, getClientParams: function () { return {"sn::cstmr::id":"\(UserModel.shared.patientId!)","cstmr::eml":"\(UserModel.shared.email!)","cstmr::phn":"\(UserModel.shared.countryCode! + UserModel.shared.contactNo!)","cstmr::nm":"\(UserModel.shared.name!)"}; } }, function(successResponse) {
                        
        Freshbots.showWidget(true);
        
        }, function(errorResponse) { }); });
        </script>
        
        </head>
        <body>
                <script>
                                                                
                </script>
        <h1></h1>
        <p></p>

        </body>
        </html>
        """
        
        self.webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
        self.webView.navigationDelegate = self
        
        FIRAnalytics.FIRLogEvent(eventName: .USER_CHAT_SUPPORT,
                                 screen: .ChatBot,
                                 parameter: nil)
    }
    //------------------------------------------------------
    
    //MARK:- Action Method
    
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
        
        WebengageManager.shared.navigateScreenEvent(screen: .ChatBot)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension WebviewChatBotVC: WKUIDelegate {
}

//MARK: ------------------ UIScrollViewDelegate Methods ------------------
extension WebviewChatBotVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
               AppLoader.shared.removeLoader()
//                self.webViewDesc.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
//                    self.webViewDescHeight.constant = height as! CGFloat
//                })
            }
        })
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\(navigation.debugDescription)")
    }
    
}
