//
//  WKWebView+Extension.swift
//  MyTatva
//
//  Created by Hlink on 14/06/23.
//

import Foundation
import WebKit
extension WKWebView {
    func getZoomDisableScript(){
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        self.configuration.userContentController.addUserScript(WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
    }
}
