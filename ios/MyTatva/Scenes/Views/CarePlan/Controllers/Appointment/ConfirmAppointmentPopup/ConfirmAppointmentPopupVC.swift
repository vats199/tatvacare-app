//
//  BackToCarePlanPopupVC.swift
//  MyTatva
//
//  Created by hyperlink on 14/10/21.
//

import UIKit

class ConfirmAppointmentPopupVC: ClearNavigationFontBlackBaseVC {
    
    //MARK: --------------------- Outlets ---------------------
    
    @IBOutlet weak var imgBg : UIImageView!
    @IBOutlet weak var vwBg : UIView!
    
    @IBOutlet weak var lblTitleTop          : UILabel!
    @IBOutlet weak var vwParent             : UIView!
    @IBOutlet weak var stackType            : UIStackView!
    @IBOutlet weak var vwType               : UIView!
    @IBOutlet weak var lblType              : UILabel!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblQualification     : UILabel!
    
    @IBOutlet weak var lblDate              : UILabel!
    @IBOutlet weak var lblTime              : UILabel!
    
    @IBOutlet weak var lblAddress           : UILabel!
    
    @IBOutlet weak var btnCancel            : UIButton!
    @IBOutlet weak var btnJoinVideo         : UIButton!
    @IBOutlet weak var btnInClinic          : UIButton!
    
    @IBOutlet weak var stackDischargeSummary : UIStackView!
    @IBOutlet weak var lblDischargeSummary  : UILabel!
    @IBOutlet weak var lblDischargeSummaryCount : UILabel!
    @IBOutlet weak var btnViewDischargeSummary : UIButton!
    
    @IBOutlet weak var stackPrescription    : UIStackView!
    @IBOutlet weak var lblPrescription      : UILabel!
    @IBOutlet weak var lblPrescriptionCount : UILabel!
    @IBOutlet weak var btnViewPrescription  : UIButton!
    
    @IBOutlet weak var btnCancelTop         : UIButton!
    @IBOutlet weak var btnSubmit            : UIButton!
    
    //MARK: --------------------- Class variable ---------------------
    var object      = AppointmentListModel()
    var completionHandler: ((_ obj : JSON?) -> Void)?
    
    //MARK: --------------------- Memory Management Method ---------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: --------------------- Lifecycle method ---------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
        
        var params                                          = [String : Any]()
        params[AnalyticsParameters.appointment_id.rawValue] = self.object.appointmentId
        params[AnalyticsParameters.type.rawValue]           = self.object.healthCoachId.isEmpty ? "D" : "H" //self.object.type
        FIRAnalytics.FIRLogEvent(eventName: .BOOK_APPOINTMENT_SUCCESSFUL,
                                 screen: .BookAppointment,
                                 parameter: params)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .AppointmentConfirmed)
    }
    
    //MARK: --------------------- UserDefined Methods ---------------------
    
    /**
     - Returns: Nothing
     Basic setup of the screen
     */
    
    private func setUpView(){
        
        self.lblTitleTop
            .font(name: .semibold, size: 19)
            .textColor(color: UIColor.themeBlack)
        
        self.lblType
            .font(name: .medium, size: 11)
            .textColor(color: UIColor.white)
        
        self.lblTitle
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        self.lblQualification
            .font(name: .regular, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.7))
        
        self.lblDate
            .font(name: .semibold, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.lblTime
            .font(name: .semibold, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblAddress
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.9))
        
        self.btnCancel
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.btnJoinVideo
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.white.withAlphaComponent(1))
        self.btnInClinic
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        
        self.lblDischargeSummaryCount
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.lblDischargeSummary
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.btnViewDischargeSummary
            .font(name: .medium, size: 10)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.lblPrescriptionCount
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        self.lblPrescription
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(1))
        self.btnViewPrescription
            .font(name: .medium, size: 10)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.btnSubmit
            .font(name: .medium, size: 15)
            .textColor(color: UIColor.themePurple.withAlphaComponent(1))
        
        self.stackType.isHidden = true
        self.stackPrescription.isHidden = true
        self.stackDischargeSummary.isHidden = true
        
        self.openPopUp()
        self.configureUI()
        self.manageActionMethods()
        self.setData()
    }
    
    fileprivate func openPopUp() {
        UIView.animate(withDuration: 1) {
            self.imgBg.alpha = kPopupAlpha
        }
    }
    
    fileprivate func configureUI(){
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.vwBg.layoutIfNeeded()
            self.btnCancel.layoutIfNeeded()
            self.vwBg.roundCorners(corners: .allCorners, radius: 7)
            
            self.vwParent.layoutIfNeeded()
            self.vwParent.cornerRadius(cornerRadius: 7)
            self.vwParent.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.0, shdowRadious: 4)
            self.vwParent.borderColor(color: UIColor.themeBlack.withAlphaComponent(0.3), borderWidth: 0.5)
            
            self.vwType.layoutIfNeeded()
            self.vwType.cornerRadius(cornerRadius: 4)
                .backGroundColor(color: UIColor.themeYellow)
            
            self.btnJoinVideo.layoutIfNeeded()
            self.btnJoinVideo.cornerRadius(cornerRadius: 4)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnViewDischargeSummary.layoutIfNeeded()
            self.btnViewDischargeSummary.cornerRadius(cornerRadius: 4)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.btnViewPrescription.layoutIfNeeded()
            self.btnViewPrescription.cornerRadius(cornerRadius: 4)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.cornerRadius(cornerRadius: self.imgTitle.frame.size.height / 2)
            
            self.btnSubmit.layoutIfNeeded()
            self.btnSubmit.cornerRadius(cornerRadius: 5)
                .backGroundColor(color: UIColor.white)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
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
    
    //MARK: --------------------- Action methods ---------------------
    fileprivate func manageActionMethods(){
        self.imgBg.addTapGestureRecognizer {
         //   self.dismissPopUp(true, objAtIndex: nil)
        }
        
        self.btnCancelTop.addTapGestureRecognizer {
            var obj = JSON()
            obj["done"] = true
            self.dismissPopUp(true, objAtIndex: obj)
        }
        
        self.btnSubmit.addTapGestureRecognizer {
            var obj = JSON()
            obj["done"] = true
            self.dismissPopUp(true, objAtIndex: obj)
        }
    }
    
    @IBAction func ActionCarePlan(_ sender : UIButton){
        self.dismissPopUp(true, objAtIndex: nil)
    }
}

//MARK: --------------------- Set data ---------------------
extension ConfirmAppointmentPopupVC {
    
    func setData(){
        
        self.imgTitle.setCustomImage(with: self.object.profilePicture)
        self.lblType.text           = self.object.appointmentStatus
        self.lblTitle.text          = self.object.doctorName
        self.lblQualification.text  = self.object.doctorQualification
       
        let date = GFunction.shared.convertDateFormate(dt: self.object.appointmentDate,
                                                           inputFormat: DateTimeFormaterEnum.yyyymmdd.rawValue,
                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
                                                           status: .NOCONVERSION)
        self.lblDate.text       = date.0
        self.lblTime.text       = self.object.appointmentTime
        self.lblAddress.text    = self.object.clinicAddress
        self.stackDischargeSummary.isHidden     = true
        self.stackPrescription.isHidden         = true
        self.lblPrescriptionCount.isHidden      = true
//        if self.object.prescriptionPdf.trim() != "" {
//            self.stackPrescription.isHidden = false
//
//            self.btnViewPrescription.addTapGestureRecognizer {
//                Downloader.load(URL: URL(string: self.object.prescriptionPdf)!)
//            }
//        }
        
        if self.object.appointmentType == "in clinic" {
            self.btnJoinVideo.isHidden  = true
            self.btnInClinic.isHidden   = false
        }
        else {
            self.btnJoinVideo.isHidden  = true
            self.btnInClinic.isHidden   = true
        }
        self.btnCancel.isHidden = true
    }
}
