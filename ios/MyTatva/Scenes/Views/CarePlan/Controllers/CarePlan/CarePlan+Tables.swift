
class CarePlanPrecriptionCell: UITableViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblTime          : UILabel!
    @IBOutlet weak var btnOrder         : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .semibold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblTime.font(name: .semibold, size: 12)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        self.btnOrder.font(name: .medium, size: 10)
            .textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.btnOrder.layoutIfNeeded()
            //self.vwBg.cornerRadius(cornerRadius: 7)
            //self.vwBg.applyViewShadow(shadowOffset: CGSize.zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.2, shdowRadious: 5)
            
            self.btnOrder.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.imgView.layoutIfNeeded()
            self.imgView.cornerRadius(cornerRadius: 5)
        }
        
    }
}

//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension CarePlanVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblPrecription:
            return self.viewModel.getPrescriptionCount()
            
        case self.tblAppointment:
            return self.viewModelappointments.getCount()
            
        case self.tblDietPlan:
            return self.dietPlanHistoryListVM.getCount()
            
        default: return 0
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.tblPrecription:
            
            let cell : CarePlanPrecriptionCell = tableView.dequeueReusableCell(withClass: CarePlanPrecriptionCell.self, for: indexPath)

            let object = self.viewModel.getPrescriptionObject(index: indexPath.row)
            cell.imgView.setCustomImage(with: object.imageUrl)
            cell.lblTitle.text  = object.medicineName
            cell.lblTime.text   = object.doseType
            
            cell.btnOrder.addTapGestureRecognizer {
                self.isPageVisible = false
                let vc = RequestCallBackPopupVC.instantiate(fromAppStoryboard: .carePlan)
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.patient_dose_rel_id = object.patientDoseRelId
                vc.completionHandler = { objc in
                        
                    if objc != nil {
                        if objc?.count > 0 {
                            self.dismiss(animated: true) {
                                let profileVC = ProfileVC.instantiate(fromAppStoryboard: .setting)
                                self.navigationController?.pushViewController(profileVC, animated: true)
                            }
                        }
                        else {
                            let backvc = BackToCarePlanPopupVC.instantiate(fromAppStoryboard: .carePlan)
                            backvc.modalPresentationStyle = .overFullScreen
                            backvc.modalTransitionStyle = .crossDissolve
                            self.present(backvc, animated: false, completion: nil)
                        }
                    }
                }
                
                self.present(vc, animated: true, completion: nil)
            }
            
            return cell
            
        case self.tblAppointment:
            let cell : AppointmentsHistoryCell = tableView.dequeueReusableCell(withClass: AppointmentsHistoryCell.self, for: indexPath)

            let object = self.viewModelappointments.getObject(index: indexPath.row)
            cell.object = object
            
            cell.btnCancel.addTapGestureRecognizer {
                Alert.shared.showAlert("", actionOkTitle: AppMessages.ok, actionCancelTitle: AppMessages.cancel, message: AppMessages.cancelAppointmentMessage) { [weak self] (isDone) in
                    guard let self = self else {return}
                    if isDone {
                        
                        var type_consult = "video"
                        if object.appointmentType == "in clinic" {
                            type_consult = "clinic"
                        }
                        
                        self.viewModelappointments.cancelAppointmentAPI(appointment_id: object.appointmentId,
                                                            clinic_id: object.clinicId,
                                                            doctor_id: object.doctorId,
                                                            type_consult: type_consult,
                                                            appointment_date: object.appointmentDate,
                                                                        appointment_slot: object.appointmentTime,
                                                                        type: object.type) { [weak self] isDone, msg in
                            guard let self = self else {return}
                            if isDone {
                                var params              = [String : Any]()
                                params[AnalyticsParameters.appointment_id.rawValue] = object.appointmentId
                                params[AnalyticsParameters.type.rawValue] = object.type
                                FIRAnalytics.FIRLogEvent(eventName: .CAREPLAN_APPOINTMENT_REQ_CANCEL,
                                                         screen: .CarePlan,
                                                         parameter: params)
                                
                                self.viewModelappointments.apiCallFromStart_Appointment(
                                    forToday: true,
                                    type: "",
                                    tblView: self.tblAppointment,
                                    withLoader: true)
                            }
                        }
                    }
                }
            }
            
            
            cell.btnJoinVideo.addTapGestureRecognizer {
                if object.action {
                    var params              = [String : Any]()
                    params[AnalyticsParameters.appointment_id.rawValue] = object.appointmentId
                    params[AnalyticsParameters.type.rawValue] = object.type
                    FIRAnalytics.FIRLogEvent(eventName: .CAREPLAN_APPOINTMENT_JOIN_VIDEO,
                                             screen: .CarePlan,
                                             parameter: params)
                    
                    if PIPKit.isPIP {
                        PIPKit.stopPIPMode()
                    }
                    else {
                        let vc = VideoAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
                        vc.hidesBottomBarWhenPushed = true
                        vc.strRoomSid       = object.roomId
                        vc.strRoomName      = object.roomName
                        vc.strTitle         = object.doctorName
                        vc.type             = object.type
                        vc.appointment_id   = object.appointmentId
    //                    self.navigationController?.pushViewController(vc, animated: true)
    //                    self.present(vc, animated: true)
                        PIPKit.show(with: vc.viewController()){
                            PIPKit.stopPIPMode()
                        }
                    }
                }
            }
            
            cell.btnViewPrescription.addTapGestureRecognizer {
                if let doc = object.prescriptionPdf {
                    if let url = URL(string: doc) {
                        GFunction.shared.openPdf(url: url)
                    }
                }
            }
            
            DispatchQueue.main.async {
                cell.vwBg.layoutIfNeeded()
                cell.vwBg.cornerRadius(cornerRadius: 7)
                cell.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0, shdowRadious: 4)
                cell.vwBg.borderColor(color: UIColor.themeBlack.withAlphaComponent(0.09), borderWidth: 0)
            }
            
            return cell
           
        case self.tblDietPlan:
            let cell : CarePlanDietPlanCell = tableView.dequeueReusableCell(withClass: CarePlanDietPlanCell.self, for: indexPath)
            cell.object = self.dietPlanHistoryListVM.getObject(index: indexPath.row)
            cell.screeName = .CarePlan
            return cell
        default: return UITableViewCell()
        }
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
        case self.tblPrecription:
            break
            
        case self.tblAppointment:
            break
        default:break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension CarePlanVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}


