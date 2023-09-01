//
//  ScheduleAppointmentVC.swift
//  MyTatva
//
//  Created by Uttam patel on 01/06/23.
//

import Foundation
import UIKit

class ScheduleAppointmentVC: LightPurpleNavigationBase {
 
    //MARK:-------------------- Outlet --------------------
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var svMain: UIStackView!
    
    //-------------------------- Nutritionist box
    @IBOutlet weak var vwNutritionist: UIView!
    @IBOutlet weak var lblNutritionist: UILabel!
    @IBOutlet weak var vwNutritionistDate: UIView!
    @IBOutlet weak var txtNutritionistDate: ThemeTextFieldNoBorder!
    
    @IBOutlet weak var vwNutritionistDetails: UIView!
    @IBOutlet weak var lblNutritionstDate: UILabel!
    @IBOutlet weak var lblNutritionstTime: UILabel!
    
    //-------------------------- Physiotherapist box
    @IBOutlet weak var vwPhysiotherapist: UIView!
    @IBOutlet weak var lblPhysiotherapist: UILabel!
    @IBOutlet weak var vwPhysiotherapistDate: UIView!
    @IBOutlet weak var txtPhysiotherapistDate: ThemeTextFieldNoBorder!
    
    @IBOutlet weak var vwPhysiotherapistDetails: UIView!
    @IBOutlet weak var lblPhysiotherapistDate: UILabel!
    @IBOutlet weak var lblPhysiotherapistTime: UILabel!
    
    //-------------------------- Doctor box
    @IBOutlet weak var vwDoctor: UIView!
    @IBOutlet weak var lblDoctor: UILabel!
    @IBOutlet weak var vwDoctorDate: UIView!
    @IBOutlet weak var txtDoctorDate: ThemeTextFieldNoBorder!
    
    @IBOutlet weak var vwDoctorDetails: UIView!
    @IBOutlet weak var lblDoctorDate: UILabel!
    @IBOutlet weak var lblDoctorTime: UILabel!
    
    //-------------------------- Schedule Button
    @IBOutlet weak var vwBtn: UIView!
    @IBOutlet weak var btnSchedule: ThemePurpleButton!
    
    @IBOutlet var imgCalender: [UIImageView]!
    @IBOutlet var imgClock: [UIImageView]!
    
 
    
    @IBOutlet weak var vwDisclaimer: UIView!
    @IBOutlet weak var lblDisclaimer: UILabel!
    
    
    //MARK: - Class Variables -
    let viewModel = ScheduleAppointmentVM()
    
    
    //MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.applyStyle()
    }
    
    //------------------------------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        WebengageManager.shared.navigateScreenEvent(screen: .BcpHcServices)
        self.viewModel.check_bcp_hc_details(withLoader: true) { isDone in
            if isDone {
                self.setData()
            }
        }
    }
    
    //------------------------------------------------------------------------------------------
    
    
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------------------------------------------
    
    //MARK: - Custom Functions -
    
    func setupView() {
        let tapNutritionistDate = UITapGestureRecognizer(target: self, action: #selector(openNutritionistAppointment))
        tapNutritionistDate.numberOfTapsRequired = 1
        self.view.endEditing(true)
        self.txtNutritionistDate.isUserInteractionEnabled = true
        self.txtNutritionistDate.addGestureRecognizer(tapNutritionistDate)
        
        let tapPhysiotherapistDate = UITapGestureRecognizer(target: self, action: #selector(openPhysiotherapistAppointment))
        tapPhysiotherapistDate.numberOfTapsRequired = 1
        self.view.endEditing(true)
        self.txtPhysiotherapistDate.isUserInteractionEnabled = true
        self.txtPhysiotherapistDate.addGestureRecognizer(tapPhysiotherapistDate)
        
        
        let tapDoctorDate = UITapGestureRecognizer(target: self, action: #selector(openDoctorAppointment))
        tapDoctorDate.numberOfTapsRequired = 1
        self.view.endEditing(true)
        self.txtDoctorDate.isUserInteractionEnabled = true
        self.txtDoctorDate.addGestureRecognizer(tapDoctorDate)
        
        self.btnSchedule.backGroundColor(color: .themeGray)
        
        self.vwDoctor.isHidden = UserModel.shared.patientGuid.trim() == ""
        
    }
    
    //------------------------------------------------------------------------------------------
    
    func applyStyle() {
        
        self.vwNutritionist.cornerRadius(cornerRadius: 12).themeShadowBCP()
        self.vwPhysiotherapist.cornerRadius(cornerRadius: 12).themeShadowBCP()
        self.vwDoctor.cornerRadius(cornerRadius: 12).themeShadowBCP()
        
        self.vwNutritionistDate.cornerRadius(cornerRadius: 12).borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
                self.vwPhysiotherapistDate.cornerRadius(cornerRadius: 12).borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
                self.vwDoctorDate.cornerRadius(cornerRadius: 12).borderColor(color: UIColor.ThemeBorder, borderWidth: 1)

        
        self.txtNutritionistDate
            .setRightImage(img: UIImage(named: "arrow_right_tint")?.imageWithSize(size: CGSize(width: 5, height: 10), extraMargin: 20))
        self.txtPhysiotherapistDate
            .setRightImage(img: UIImage(named: "arrow_right_tint")?.imageWithSize(size: CGSize(width: 5, height: 10), extraMargin: 20))
        self.txtDoctorDate
            .setRightImage(img: UIImage(named: "arrow_right_tint")?.imageWithSize(size: CGSize(width: 5, height: 10), extraMargin: 20))
        
        self.vwNutritionistDate.isHidden = false
        self.vwPhysiotherapistDate.isHidden = false
        self.vwDoctorDate.isHidden = false
        
        self.vwNutritionistDetails.isHidden = true
        self.vwPhysiotherapistDetails.isHidden = true
        self.vwDoctorDetails.isHidden = true
        
        self.vwBtn.isHidden = true
        
        self.lblNutritionist
            .font(name: .bold, size: 14)
            .textColor(color: UIColor.themeBlack2).text = "With Nutritionist"
        
        self.lblPhysiotherapist
            .font(name: .bold, size: 14)
            .textColor(color: UIColor.themeBlack2).text = "With Physiotherapist"
        
        self.lblDoctor
            .font(name: .bold, size: 14)
            .textColor(color: UIColor.themeBlack2).text = "With Doctor"
        
        
        self.lblNutritionstDate
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.ThemeBlack21).text = "Tuesday, 23 May, 2023"
        self.lblNutritionstTime
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.ThemeBlack21).text = "Morning, 07:30 - 08:30"
        
        self.lblPhysiotherapistDate
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.ThemeBlack21).text = "Tuesday, 23 May, 2023"
        self.lblPhysiotherapistTime
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.ThemeBlack21).text = "Morning, 07:30 - 08:30"
        
        self.lblDoctorDate
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.ThemeBlack21).text = "Tuesday, 23 May, 2023"
        self.lblDoctorTime
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.ThemeBlack21).text = "Morning, 07:30 - 08:30"
        
        self.imgCalender.forEach({ $0.image = UIImage(named: "icon_Calender")})
        self.imgClock.forEach({ $0.image = UIImage(named: "icon_Clock")})
        
        self.vwDisclaimer.cornerRadius(cornerRadius: 16).borderColor(color: .themeLightGray).isHidden = true
        self.lblDisclaimer.font(name: .medium, size: 12)
            .textColor(color: .themeGray4).text = "Disclaimer: We will book your appointment on your preferred slot within next 24 working hours."
        self.lblDisclaimer.numberOfLines = 0

    }
    
    func getTodayWeekDay(date: Date)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
    
    func setData() {
        
        let isNutriiAdded = (self.viewModel.appointmentModel.nutritionist == nil && self.viewModel.appointmentModel.nutritionistAvailabilityDate != "")
        let isPhysioAdded = (self.viewModel.appointmentModel.physiotherapist == nil && self.viewModel.appointmentModel.physiotherapistAvailabilityDate != "")
        self.vwDisclaimer.isHidden = !(isNutriiAdded || isPhysioAdded)
        
        if isNutriiAdded  {
            
            let data = self.viewModel.appointmentModel
            
            let date = DateFormatter()
            date.dateFormat = DateTimeFormaterEnum.yyyymmdd.rawValue
            guard let dateFormat = date.date(from: data.nutritionistAvailabilityDate) else { return }
            date.dateFormat = DateTimeFormaterEnum.EEEEddMMMyyyy.rawValue
            let updatedDate : String = date.string(from: dateFormat)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "H:mm:ss"
            guard let startTime = timeFormatter.date(from: data.nutritionistStartTime) else { return }
            guard let endTime = timeFormatter.date(from: data.nutritionistEndTime) else { return }
            timeFormatter.dateFormat = DateTimeFormaterEnum.hhmm.rawValue
            let startFormat = timeFormatter.string(from: startTime)
            timeFormatter.dateFormat = DateTimeFormaterEnum.hhmma.rawValue
            let endFormat = timeFormatter.string(from: endTime)
            
            self.lblNutritionstDate.text = updatedDate
            self.lblNutritionstTime.text = data.nutritionistTimeType + "," + " " + startFormat + " - " + endFormat
            self.vwNutritionistDate.isHidden = true
            self.vwNutritionistDetails.isHidden = false
            
        } else {
            self.vwNutritionistDate.isHidden = false
            self.vwNutritionistDetails.isHidden = true
        }
        
        if isPhysioAdded {

            let data = self.viewModel.appointmentModel
            
            let date = DateFormatter()
            date.dateFormat = DateTimeFormaterEnum.yyyymmdd.rawValue
            guard let dateFormat = date.date(from: data.physiotherapistAvailabilityDate) else { return }
            date.dateFormat = DateTimeFormaterEnum.EEEEddMMMyyyy.rawValue
            let updatedDate : String = date.string(from: dateFormat)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "H:mm:ss"
            guard let startTime = timeFormatter.date(from: data.physiotherapistStartTime) else { return }
            guard let endTime = timeFormatter.date(from: data.physiotherapistEndTime) else { return }
            timeFormatter.dateFormat = DateTimeFormaterEnum.hhmm.rawValue
            let startFormat = timeFormatter.string(from: startTime)
            timeFormatter.dateFormat = DateTimeFormaterEnum.hhmma.rawValue
            let endFormat = timeFormatter.string(from: endTime)
            
            self.lblPhysiotherapistDate.text = updatedDate
            self.lblPhysiotherapistTime.text = data.physiotherapistTimeType + "," + " " + startFormat + " - " + endFormat
            self.vwPhysiotherapistDate.isHidden = true
            self.vwPhysiotherapistDetails.isHidden = false
        } else {
            self.vwPhysiotherapistDate.isHidden = false
            self.vwPhysiotherapistDetails.isHidden = true
        }
    }
    
    //------------------------------------------------------------------------------------------
    
    @objc  func openNutritionistAppointment() {
        if self.viewModel.appointmentModel.nutritionist == nil {
            let vc = SelectTestSlotVC.instantiate(fromAppStoryboard: .bca)
            vc.viewModel.pateintPlanRefID = self.viewModel.pateintPlanRefID
            vc.isFromPhysio = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            PlanManager.shared.isAllowedByPlan(type: .book_appointments,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow {
                    let vc = BookAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
        
    }
    
    @objc  func openPhysiotherapistAppointment() {
        if self.viewModel.appointmentModel.physiotherapist == nil {
            let vc = SelectTestSlotVC.instantiate(fromAppStoryboard: .bca)
            vc.viewModel.pateintPlanRefID = self.viewModel.pateintPlanRefID
            vc.isFromPhysio = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            PlanManager.shared.isAllowedByPlan(type: .book_appointments,
                                               sub_features_id: "",
                                               completion: { isAllow in
                if isAllow {
                    let vc = BookAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    PlanManager.shared.alertNoSubscription()
                }
            })
        }
    }
    
    @objc  func openDoctorAppointment() {
        PlanManager.shared.isAllowedByPlan(type: .book_appointments,
                                           sub_features_id: "",
                                           completion: { isAllow in
            if isAllow {
                let vc = BookAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                PlanManager.shared.alertNoSubscription()
            }
        })
    }
    
    
    //MARK: - Button Action Methods -
    @IBAction func btnScheduleTapped(_ sender: UIButton) {
        
    }
    
    //------------------------------------------------------------------------------------------
    
}

