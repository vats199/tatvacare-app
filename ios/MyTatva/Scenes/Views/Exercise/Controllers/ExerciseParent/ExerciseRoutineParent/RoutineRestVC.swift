//

//  MyTatva
//
//  Created by on 11/4/23.
//

import UIKit
import AVKit



//MARK: -------------------------  UIViewController -------------------------
class RoutineRestVC : WhiteNavigationBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var lblTitle         : UILabel!
    
    //MARK:- Class Variable
    var strTitle = ""
    
    //MARK: ------------------------- Memory Management Method -------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    func setUpView() {
        
        self.configureUI()
        self.applyStyle()
    }
    
    func configureUI(){
    
    }
    
    func applyStyle(){
        self.lblTitle
            .font(name: .medium, size: 23).textColor(color: .themeBlack)
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        WebengageManager.shared.navigateScreenEvent(screen: .ExerciseViewAll)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}
