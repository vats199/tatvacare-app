
//  Created by apple on 11/09/23.
//  Copyright © 2023 . All rights reserved.
//

import UIKit
import WebKit
@_exported import PDFKit

class ViewPDFVC: WhiteNavigationBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet var btnBack           : UIBarButtonItem!
    @IBOutlet var pdfView           : PDFView!
    @IBOutlet var lblTitle          : UILabel!
    @IBOutlet var btnShare          : UIButton!
    
    //MARK: ------------------------- Class Variable -------------------------
    var strUrl                  = ""
    var strTitle                = ""
    var isBack                  = true
    var completionHandler: ((_ obj : JSON?) -> Void)?
    //-----------Ï-------------------------------------------
    
    //MARK: ------------------------- Memory Management Method -------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    func setUpView() {
        
        self.lblTitle.text = self.strTitle
        
        if self.isBack {
            self.btnBack.image = UIImage(named: "back_ic")
        }
        else {
            self.btnBack.image = UIImage(named: "menu")
        }

        self.loadPDF()
        self.manageActionMethods()
    }
    
    func loadPDF(){
        if let url = URL(string: self.strUrl) {
            if let pdfDocument = PDFDocument(url: url) {
                self.pdfView.displayMode        = .singlePageContinuous
                self.pdfView.autoScales         = true
                self.pdfView.displayDirection   = .vertical
                self.pdfView.document           = pdfDocument
            }
        }
    }
    
    //MARK: ------------------------- Action Method -------------------------
    @IBAction func btnBackTapped(sender: UIBarButtonItem){
        self.view.endEditing(true)
        if self.isBack {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
    }
    
    private func manageActionMethods(){
        self.btnShare.addTapGestureRecognizer {
            if let url = URL(string: self.strUrl) {
                let printController             = UIPrintInteractionController.shared
                printController.printingItem    = url
                printController.showsPaperSelectionForLoadedPapers = true
                
                let printInfo                   = UIPrintInfo.printInfo()
                printInfo.jobName               = url.lastPathComponent
                printInfo.outputType            = .photo
                printController.printInfo       = printInfo
                printController.present(from: (UIApplication.topViewController()!.view.frame), in: (UIApplication.topViewController()!.view!), animated: true)
            }
        }
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.setUpView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = self.parent?.parent as? TabbarVC {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}
