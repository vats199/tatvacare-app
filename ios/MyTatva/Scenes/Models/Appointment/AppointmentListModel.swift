import Foundation
import SwiftyJSON

class AppointmentListModel {

    var appointmentDate : String!
    var appointmentId : String!
    var appointmentStatus : String!
    var appointmentTime : String!
    var appointmentType : String!
    var clinicAddress : String!
    var clinicId : String!
    var clinicName : String!
    var doctorId : String!
    var doctorName : String!
    var doctorQualification : String!
    var paymentStatus : String!
    var prescriptionPdf : String!
    var roomId : String!
    var roomName : String!
    var roomSid : String!
    var profilePicture : String!
    var action : Bool!
    var appointmentEndTime : String!
    var appointmentStartTime : String!
    var status : String!
    var type : String!
    var healthCoachId: String!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        action = json["action"].boolValue
        appointmentDate = json["appointment_date"].stringValue
        appointmentId = json["appointment_id"].stringValue
        appointmentStatus = json["appointment_status"].stringValue
        appointmentTime = json["appointment_time"].stringValue
        appointmentType = json["appointment_type"].stringValue
        clinicAddress = json["clinic_address"].stringValue
        clinicId = json["clinic_id"].stringValue
        clinicName = json["clinic_name"].stringValue
        doctorId = json["doctor_id"].stringValue
        doctorName = json["doctor_name"].stringValue
        doctorQualification = json["doctor_qualification"].stringValue
        paymentStatus = json["payment_status"].stringValue
        prescriptionPdf = json["prescription_pdf"].stringValue
        roomId = json["room_id"].stringValue
        roomName = json["room_name"].stringValue
        roomSid = json["room_sid"].stringValue
        profilePicture = json["profile_picture"].stringValue
        appointmentEndTime = json["appointment_end_time"].stringValue
        appointmentStartTime = json["appointment_start_time"].stringValue
        status = json["status"].stringValue
        type = json["type"].stringValue
        healthCoachId = json["health_coach_id"].stringValue

    }
}

//MARK: ---------------- Array Model ----------------------
extension AppointmentListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [AppointmentListModel] {
        var models:[AppointmentListModel] = []
        for item in array
        {
            models.append(AppointmentListModel(fromJson: item))
        }
        return models
    }
}
