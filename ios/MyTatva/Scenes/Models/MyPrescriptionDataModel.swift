//
//  MyPrescriptionDataModel.swift
//  MyTatva
//

import Foundation

class MyPrescriptionDataModel{

    var documentData : [DocumentDataModel]!
    var medicineData : [MedicineData]!


    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        documentData = [DocumentDataModel]()
        let documentDataArray = json["document_data"].arrayValue
        for documentDataJson in documentDataArray{
            let value = DocumentDataModel(fromJson: documentDataJson)
            documentData.append(value)
        }
        medicineData = [MedicineData]()
        let medicineDataArray = json["medicine_data"].arrayValue
        for medicineDataJson in medicineDataArray{
            let value = MedicineData(fromJson: medicineDataJson)
            medicineData.append(value)
        }
    }
}

class MedicineData{

    var createdAt : String!
    var doseDays : String!
    var doseId : String!
    var doseTimeSlot : [String]!
    var endDate : String!
    var isActive : String!
    var isDeleted : String!
    var medecineId : String!
    var medicineName : String!
    var patientDoseRelId : String!
    var patientId : String!
    var startDate : String!
    var updatedAt : String!
    var updatedBy : String!
    var doseType: String!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        doseDays = json["dose_days"].stringValue
        doseId = json["dose_id"].stringValue
        doseType = json["dose_type"].stringValue
        endDate = json["end_date"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        medecineId = json["medecine_id"].stringValue
        medicineName = json["medicine_name"].stringValue
        patientDoseRelId = json["patient_dose_rel_id"].stringValue
        patientId = json["patient_id"].stringValue
        startDate = json["start_date"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue

        doseTimeSlot = [String]()
        let doseTimeSlotJson = json["dose_time_slot"].arrayObject
        if doseTimeSlotJson != nil{
            doseTimeSlot.append(contentsOf: doseTimeSlotJson as? [String] ?? [""])
        }
    }
}

class DocumentDataModel {

    var createdAt : String!
    var documentLabel : String!
    var documentName : String!
    var documentUrl : String!
    var isActive : String!
    var isDeleted : String!
    var patientId : String!
    var prescriptionDocumentRelId : String!
    var updatedAt : String!
    var updatedBy : String!

    var image: UIImage!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        documentLabel = json["document_label"].stringValue
        documentName = json["document_name"].stringValue
        documentUrl = json["document_url"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        patientId = json["patient_id"].stringValue
        prescriptionDocumentRelId = json["prescription_document_rel_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
       
    }

}
