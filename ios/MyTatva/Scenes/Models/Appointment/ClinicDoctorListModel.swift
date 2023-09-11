import Foundation

class ClinicDoctorListModel: NSObject {
    
    
    var responseCode : Int!
    var result : [ClinicDoctorResult]!
    var statusUpdate : String!
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        responseCode = json["ResponseCode"].intValue
        result = [ClinicDoctorResult]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = ClinicDoctorResult(fromJson: resultJson)
            result.append(value)
        }
        statusUpdate = json["status_update"].stringValue
    }
    
}

class ClinicDoctorResult{

    var clinicId : String!
    var clinicName : String!
    var doctorDetails : [DoctorDetailModel]!

    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        clinicId = json["clinic_id"].stringValue
        clinicName = json["clinic_name"].stringValue
        doctorDetails = [DoctorDetailModel]()
        let doctorDetailsArray = json["doctor_details"].arrayValue
        for doctorDetailsJson in doctorDetailsArray{
            let value = DoctorDetailModel(fromJson: doctorDetailsJson)
            doctorDetails.append(value)
        }
    }
}

//MARK: ---------------- Array Model ----------------------
extension ClinicDoctorResult {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [ClinicDoctorResult] {
        var models:[ClinicDoctorResult] = []
        for item in array
        {
            models.append(ClinicDoctorResult(fromJson: item))
        }
        return models
    }
}

//MARK: --------------------------------------
class DoctorDetailModel{

    var doctorName : String!
    var doctorUniqId : String!
    var speciality : String!

    var isSelected = false
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        doctorName = json["doctor_name"].stringValue
        doctorUniqId = json["doctor_uniq_id"].stringValue
        speciality = json["speciality"].stringValue
    }

}


