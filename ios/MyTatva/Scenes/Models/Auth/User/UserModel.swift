//
//  File.swift
//  4Horses
//
//

import Foundation
import SwiftyJSON

//User model
class UserModel: NSObject, NSCoding {
    
    var accountRole : String!
    var activeDeactiveId : String!
    var address : String!
    var biometricSetting : String!
    var city : String!
    var contactNo : String!
    var country : String!
    var countryCode : String!
    var createdAt : String!
    var deviceInfo : [DeviceInfo]!
    var dob : String!
    var email : String!
    var emailVerified : String!
    var gender : String!
    var height : String!
    var isAcceptTermsAccept : String!
    var isActive : String!
    var isDeleted : String!
    var languageVersion : String!
    var languagesId : String!
    var lastLoginDate : String!
    var name : String!
    var password : String!
    var patientAge : Int!
    var patientId : String!
    var patientLinkDoctorDetails : [PatientLinkDoctorDetail]!
    var profileCompletion : String!
    var profileCompletionStatus : ProfileCompletionStatu!
    var profilePic : String!
    var state : String!
    var token : String!
    var updatedAt : String!
    var updatedBy : String!
    var weight : String!
    var whatsappOptin : String!
    var languageName: String!
    var doctorSays : DoctorSay!
    var syncAt: String!
    var medicalConditionName : [MedicalConditionName]!
    var unreadNotifications : Int!
    
    var currentStatus : String!
    var lastActiveDate : String!
    
    var loginUser : String!
    var patientGuid : String!
    var patientPlans : [PatientPlan]!
    var severityId : String!
    var severityName : String!
    var restoreId : String!
    var userFrom : String!
    var bmrDetails : BmrDetail!
    
    var unitData : [UnitData]!
    var heightUnit : String!
    var weightUnit : String!
    var hcList : [HcList]!
    var settings : [Settings]!
    
    var medicalConditionGroupId : String!
    var indicationName : String!
    
    var bcaSync : BCASync!
    
    var hcServicesLongestPlan: HCServicesLongestPlan!
    
    var accessCode : String!
    var doctorAccessCode : String!
    var relation : String!
    var step : Int!
    var subRelation : String!
    var tempPatientSignupId : String!
    
    var devices : [DeviceDetailsModel]!
    private var arrDevice = [DeviceDetailsModel]()
    
    static var shared : UserModel = UserModel()
    
    override init(){}
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        indicationName = json["indication_name"].stringValue
        accountRole = json["account_role"].stringValue
        activeDeactiveId = json["active_deactive_id"].stringValue
        address = json["address"].stringValue
        biometricSetting = json["biometric_setting"].stringValue
        city = json["city"].stringValue
        contactNo = json["contact_no"].stringValue
        country = json["country"].stringValue
        countryCode = json["country_code"].stringValue
        createdAt = json["created_at"].stringValue
        deviceInfo = [DeviceInfo]()
        let deviceInfoArray = json["device_info"].arrayValue
        for deviceInfoJson in deviceInfoArray{
            let value = DeviceInfo(fromJson: deviceInfoJson)
            deviceInfo.append(value)
        }
        dob = json["dob"].stringValue
        email = json["email"].stringValue
        emailVerified = json["email_verified"].stringValue
        gender = json["gender"].stringValue
        height = json["height"].stringValue
        isAcceptTermsAccept = json["is_accept_terms_accept"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        languageVersion = json["language_version"].stringValue
        languagesId = json["languages_id"].stringValue
        lastLoginDate = json["last_login_date"].stringValue
        name = json["name"].stringValue
        password = json["password"].stringValue
        patientAge = json["patient_age"].intValue
        patientId = json["patient_id"].stringValue
        patientLinkDoctorDetails = [PatientLinkDoctorDetail]()
        let patientLinkDoctorDetailsArray = json["patient_link_doctor_details"].arrayValue
        for patientLinkDoctorDetailsJson in patientLinkDoctorDetailsArray{
            let value = PatientLinkDoctorDetail(fromJson: patientLinkDoctorDetailsJson)
            patientLinkDoctorDetails.append(value)
        }
        profileCompletion = json["profile_completion"].stringValue
        let profileCompletionStatusJson = json["profile_completion_status"]
        if !profileCompletionStatusJson.isEmpty{
            profileCompletionStatus = ProfileCompletionStatu(fromJson: profileCompletionStatusJson)
        }
        profilePic = json["profile_pic"].stringValue
        state = json["state"].stringValue
        token = json["token"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        weight = json["weight"].stringValue
        whatsappOptin = json["whatsapp_optin"].stringValue
        languageName = json["language_name"].stringValue
        let doctorSaysJson = json["doctor_says"]
        if !doctorSaysJson.isEmpty{
            doctorSays = DoctorSay(fromJson: doctorSaysJson)
        }
        syncAt = json["sync_at"].stringValue
        currentStatus = json["current_status"].stringValue
        lastActiveDate = json["last_active_date"].stringValue
        medicalConditionGroupId = json["medical_condition_group_id"].stringValue
        medicalConditionName = [MedicalConditionName]()
        let medicalConditionNameArray = json["medical_condition_name"].arrayValue
        for medicalConditionNameJson in medicalConditionNameArray{
            let value = MedicalConditionName(fromJson: medicalConditionNameJson)
            medicalConditionName.append(value)
        }
        unreadNotifications = json["unread_notifications"].intValue
        patientGuid = json["patient_guid"].stringValue
        patientPlans = [PatientPlan]()
        let patientPlansArray = json["patient_plans"].arrayValue
        for patientPlansJson in patientPlansArray{
            let value = PatientPlan(fromJson: patientPlansJson)
            patientPlans.append(value)
        }
        
        severityId = json["severity_id"].stringValue
        severityName = json["severity_name"].stringValue
        restoreId = json["restore_id"].stringValue
        userFrom = json["user_from"].stringValue
        let bmrDetailsJson = json["bmr_details"]
        if !bmrDetailsJson.isEmpty{
            bmrDetails = BmrDetail(fromJson: bmrDetailsJson)
        }
        unitData = [UnitData]()
        let unitDataArray = json["unit_data"].arrayValue
        for unitDataJson in unitDataArray{
            let value = UnitData(fromJson: unitDataJson)
            unitData.append(value)
        }
        heightUnit = json["height_unit"].stringValue
        weightUnit = json["weight_unit"].stringValue
        hcList = [HcList]()
        let hcListArray = json["hc_list"].arrayValue
        for hcListJson in hcListArray{
            let value = HcList(fromJson: hcListJson)
            hcList.append(value)
        }
        settings = [Settings]()
        let settingsArray = json["settings"].arrayValue
        for settingsJson in settingsArray{
            let value = Settings(fromJson: settingsJson)
            settings.append(value)
        }
        
        devices = [DeviceDetailsModel]()
        let devicesArray = json["devices"].arrayValue
        for devicesJson in devicesArray{
            let value = DeviceDetailsModel(fromJson: devicesJson)
            devices.append(value)
        }
        
        let isCOPDOrAsthama = medicalConditionName.contains(where: { $0.medicalConditionName.contains("COPD") || $0.medicalConditionName.contains("Asthma") })
        
        self.devices = self.devices.filter({ model in
            if (hide_home_spirometer && model.key == BTDeviceType.spirometer.rawValue && !isCOPDOrAsthama) || (hide_home_bca && model.key == BTDeviceType.bca.rawValue) || (model.key == BTDeviceType.spirometer.rawValue && !isCOPDOrAsthama) {
                return false
            }
            return true
        })
        
        //        devices = devices.filter({ $0.key != "spirometer" })
        
        let bcaSyncJson = json["bca_sync"]
        if !bcaSyncJson.isEmpty{
            bcaSync = BCASync(fromJson: bcaSyncJson)
        }
        
        let hcServiceLongestPlan = json["hc_service_longest_plan"]
        if !hcServiceLongestPlan.isEmpty{
            hcServicesLongestPlan = HCServicesLongestPlan(fromJson: hcServiceLongestPlan)
        }
        
        accessCode = json["access_code"].stringValue
        doctorAccessCode = json["doctor_access_code"].stringValue
        relation = json["relation"].stringValue
        step = json["step"].intValue
        subRelation = json["sub_relation"].stringValue
        tempPatientSignupId = json["temp_patient_signup_id"].stringValue
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        accountRole = aDecoder.decodeObject(forKey: "account_role") as? String
        activeDeactiveId = aDecoder.decodeObject(forKey: "active_deactive_id") as? String
        address = aDecoder.decodeObject(forKey: "address") as? String
        biometricSetting = aDecoder.decodeObject(forKey: "biometric_setting") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        contactNo = aDecoder.decodeObject(forKey: "contact_no") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        countryCode = aDecoder.decodeObject(forKey: "country_code") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        currentStatus = aDecoder.decodeObject(forKey: "current_status") as? String
        deviceInfo = aDecoder.decodeObject(forKey: "device_info") as? [DeviceInfo]
        dob = aDecoder.decodeObject(forKey: "dob") as? String
        doctorSays = aDecoder.decodeObject(forKey: "doctor_says") as? DoctorSay
        email = aDecoder.decodeObject(forKey: "email") as? String
        emailVerified = aDecoder.decodeObject(forKey: "email_verified") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        height = aDecoder.decodeObject(forKey: "height") as? String
        isAcceptTermsAccept = aDecoder.decodeObject(forKey: "is_accept_terms_accept") as? String
        isActive = aDecoder.decodeObject(forKey: "is_active") as? String
        isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? String
        languageName = aDecoder.decodeObject(forKey: "language_name") as? String
        languageVersion = aDecoder.decodeObject(forKey: "language_version") as? String
        languagesId = aDecoder.decodeObject(forKey: "languages_id") as? String
        lastActiveDate = aDecoder.decodeObject(forKey: "last_active_date") as? String
        lastLoginDate = aDecoder.decodeObject(forKey: "last_login_date") as? String
        loginUser = aDecoder.decodeObject(forKey: "login_user") as? String
        medicalConditionName = aDecoder.decodeObject(forKey: "medical_condition_name") as? [MedicalConditionName]
        name = aDecoder.decodeObject(forKey: "name") as? String
        password = aDecoder.decodeObject(forKey: "password") as? String
        patientAge = aDecoder.decodeObject(forKey: "patient_age") as? Int
        patientGuid = aDecoder.decodeObject(forKey: "patient_guid") as? String
        patientId = aDecoder.decodeObject(forKey: "patient_id") as? String
        patientLinkDoctorDetails = aDecoder.decodeObject(forKey: "patient_link_doctor_details") as? [PatientLinkDoctorDetail]
        patientPlans = aDecoder.decodeObject(forKey: "patient_plans") as? [PatientPlan]
        profileCompletion = aDecoder.decodeObject(forKey: "profile_completion") as? String
        profileCompletionStatus = aDecoder.decodeObject(forKey: "profile_completion_status") as? ProfileCompletionStatu
        profilePic = aDecoder.decodeObject(forKey: "profile_pic") as? String
        severityId = aDecoder.decodeObject(forKey: "severity_id") as? String
        severityName = aDecoder.decodeObject(forKey: "severity_name") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String
        syncAt = aDecoder.decodeObject(forKey: "sync_at") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
        unreadNotifications = aDecoder.decodeObject(forKey: "unread_notifications") as? Int
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        updatedBy = aDecoder.decodeObject(forKey: "updated_by") as? String
        weight = aDecoder.decodeObject(forKey: "weight") as? String
        whatsappOptin = aDecoder.decodeObject(forKey: "whatsapp_optin") as? String
        restoreId = aDecoder.decodeObject(forKey: "restore_id") as? String
        userFrom = aDecoder.decodeObject(forKey: "user_from") as? String
        unitData = aDecoder.decodeObject(forKey: "unit_data") as? [UnitData]
        heightUnit = aDecoder.decodeObject(forKey: "height_unit") as? String
        weightUnit = aDecoder.decodeObject(forKey: "weight_unit") as? String
        hcList = aDecoder.decodeObject(forKey: "hc_list") as? [HcList]
        settings = aDecoder.decodeObject(forKey: "settings") as? [Settings]
        indicationName = aDecoder.decodeObject(forKey: "indication_name") as? String
        medicalConditionGroupId = aDecoder.decodeObject(forKey: "medical_condition_group_id") as? String
        accessCode = aDecoder.decodeObject(forKey: "access_code") as? String
        doctorAccessCode = aDecoder.decodeObject(forKey: "doctor_access_code") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if accountRole != nil{
            aCoder.encode(accountRole, forKey: "account_role")
        }
        if activeDeactiveId != nil{
            aCoder.encode(activeDeactiveId, forKey: "active_deactive_id")
        }
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if biometricSetting != nil{
            aCoder.encode(biometricSetting, forKey: "biometric_setting")
        }
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if contactNo != nil{
            aCoder.encode(contactNo, forKey: "contact_no")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if countryCode != nil{
            aCoder.encode(countryCode, forKey: "country_code")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if currentStatus != nil{
            aCoder.encode(currentStatus, forKey: "current_status")
        }
        if deviceInfo != nil{
            aCoder.encode(deviceInfo, forKey: "device_info")
        }
        if dob != nil{
            aCoder.encode(dob, forKey: "dob")
        }
        if doctorSays != nil{
            aCoder.encode(doctorSays, forKey: "doctor_says")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if emailVerified != nil{
            aCoder.encode(emailVerified, forKey: "email_verified")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if height != nil{
            aCoder.encode(height, forKey: "height")
        }
        if isAcceptTermsAccept != nil{
            aCoder.encode(isAcceptTermsAccept, forKey: "is_accept_terms_accept")
        }
        if isActive != nil{
            aCoder.encode(isActive, forKey: "is_active")
        }
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if languageName != nil{
            aCoder.encode(languageName, forKey: "language_name")
        }
        if languageVersion != nil{
            aCoder.encode(languageVersion, forKey: "language_version")
        }
        if languagesId != nil{
            aCoder.encode(languagesId, forKey: "languages_id")
        }
        if lastActiveDate != nil{
            aCoder.encode(lastActiveDate, forKey: "last_active_date")
        }
        if lastLoginDate != nil{
            aCoder.encode(lastLoginDate, forKey: "last_login_date")
        }
        if loginUser != nil{
            aCoder.encode(loginUser, forKey: "login_user")
        }
        if medicalConditionName != nil{
            aCoder.encode(medicalConditionName, forKey: "medical_condition_name")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if password != nil{
            aCoder.encode(password, forKey: "password")
        }
        if patientAge != nil{
            aCoder.encode(patientAge, forKey: "patient_age")
        }
        if patientGuid != nil{
            aCoder.encode(patientGuid, forKey: "patient_guid")
        }
        if patientId != nil{
            aCoder.encode(patientId, forKey: "patient_id")
        }
        if patientLinkDoctorDetails != nil{
            aCoder.encode(patientLinkDoctorDetails, forKey: "patient_link_doctor_details")
        }
        if patientPlans != nil{
            aCoder.encode(patientPlans, forKey: "patient_plans")
        }
        if profileCompletion != nil{
            aCoder.encode(profileCompletion, forKey: "profile_completion")
        }
        if profileCompletionStatus != nil{
            aCoder.encode(profileCompletionStatus, forKey: "profile_completion_status")
        }
        if profilePic != nil{
            aCoder.encode(profilePic, forKey: "profile_pic")
        }
        if severityId != nil{
            aCoder.encode(severityId, forKey: "severity_id")
        }
        if severityName != nil{
            aCoder.encode(severityName, forKey: "severity_name")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if syncAt != nil{
            aCoder.encode(syncAt, forKey: "sync_at")
        }
        if token != nil{
            aCoder.encode(token, forKey: "token")
        }
        if unreadNotifications != nil{
            aCoder.encode(unreadNotifications, forKey: "unread_notifications")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if updatedBy != nil{
            aCoder.encode(updatedBy, forKey: "updated_by")
        }
        if weight != nil{
            aCoder.encode(weight, forKey: "weight")
        }
        if whatsappOptin != nil{
            aCoder.encode(whatsappOptin, forKey: "whatsapp_optin")
        }
        if restoreId != nil{
            aCoder.encode(restoreId, forKey: "restore_id")
        }
        if userFrom != nil{
            aCoder.encode(userFrom, forKey: "user_from")
        }
        if unitData != nil{
            aCoder.encode(unitData, forKey: "unit_data")
        }
        if heightUnit != nil{
            aCoder.encode(heightUnit, forKey: "height_unit")
        }
        
        if weightUnit != nil{
            aCoder.encode(weightUnit, forKey: "weight_unit")
        }
        if hcList != nil{
            aCoder.encode(hcList, forKey: "hc_list")
        }
        if settings != nil{
            aCoder.encode(settings, forKey: "settings")
        }
        if medicalConditionGroupId != nil{
            aCoder.encode(medicalConditionGroupId, forKey: "medical_condition_group_id")
        }
        if indicationName != nil{
            aCoder.encode(indicationName, forKey: "indication_name")
        }
        if accessCode != nil{
            aCoder.encode(accessCode, forKey: "access_code")
        }
        if doctorAccessCode != nil{
            aCoder.encode(doctorAccessCode, forKey: "doctor_access_code")
        }
    }
    
}

extension UserModel {
    
    static var patientGender : String {
        if UserModel.shared.gender != nil {
            if UserModel.shared.gender == "M" {
                return AppMessages.male
            }
            else if UserModel.shared.gender == "F" {
                return AppMessages.female
            }
            else {
                return AppMessages.otherGender
            }
        }
        else {
            return ""
        }
    }
    /**
     Return true if user is gurst user
     */
    static var isGuestUser : Bool {
        return !(UserModel.isUserLoggedIn && UserModel.isVerifiedUser)
    }
    
    /**
     Return true if user loggedin
     */
    static var isUserLoggedIn : Bool {
        return UserDefaults.standard.value(forKey: UserDefaults.Keys.currentUser) != nil
    }
    
    /**
     Return true if verified by OTP
     */
    static var isVerifiedUser : Bool {
        return UserDefaults.standard.value(forKey: UserDefaults.Keys.authorization) != nil
    }
    
    static var isBiometricOn : Bool {
        return UserDefaults.standard.value(forKey: UserDefaults.Keys.isBiometricOn) != nil
    }
    
    /**
     Return and sets login user token for session management
     */
    static var accessToken: String? {
        set{
            guard let unwrappedKey = newValue else{
                return
            }
            UserDefaults.standard.set(unwrappedKey, forKey: UserDefaults.Keys.accessToken)
            UserDefaults.standard.synchronize()
            
        } get {
            return UserDefaults.standard.value(forKey: UserDefaults.Keys.accessToken) as? String
        }
    }
    
    /**
     Remove all current user login data
     */
    class func removeCurrentUser(){
        if UserDefaults.standard.value(forKey: UserDefaults.Keys.currentUser) != nil {
            UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.currentUser)
            UserDefaults.standard.synchronize()
        }
    }
    
    /**
     Get Number of devices
     */
    
    func getDevices() {
        self.arrDevice = self.devices.filter({ model in
            if (hide_home_spirometer && model.key == BTDeviceType.spirometer.rawValue) || (hide_home_bca && model.key == BTDeviceType.bca.rawValue) {
                return false
            }
            return true
        })
    }
    
    func getNumberOfDevice() -> Int {
        return self.devices.count
    }
    
    func getDeviceDetail(_ index: Int) -> DeviceDetailsModel? {
        self.devices[index]
    }
    
    func getAllPlanName() -> String {
        return "\(self.patientPlans.map({$0.planName}).joined(separator: ", "))"
    }
    
    func getAllPlanType() -> String {
        return (self.patientPlans.contains(where: {$0.planType == kIndividual || $0.planType == kSubscription}) ? "Paid - " : patientPlans.contains(where: {$0.planType == KFree || $0.planType == KTrial}) ? "Free - " : "") + "\(patientPlans.map({$0.planType}).joined(separator: ", "))"
    }
    
}

//MARK: ----------------------- saveUserData -----------------------
extension UserModel {
    
    func saveUserData(){
        print("------------------User data saved ------------------------")
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: UserModel.shared, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.Keys.currentUser)
            UserDefaults.standard.synchronize()
            
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func retrieveUserData(){
        print("------------------ User data retrieved ------------------------")
        if let decoded  = UserDefaults.standard.object(forKey: UserDefaults.Keys.currentUser) as? Data {
            do {
                UserModel.shared = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! UserModel
            }
            catch {
                print("ERROR: \(error.localizedDescription)")
            }
            
        }
    }
    
    //MARK:-------- User entry response details handle --------
    func storeUserEntryDetails(withJSON: JSON,_ isLogin: Bool = true) {
        UserModel.shared = UserModel(fromJson: withJSON)
        
        
        //        if UserModel.shared.language.trim() != "" {
        //            USERDEFAULTS.setValue([UserModel.shared.language], forKey: kAppLanguages)
        //        }
        
        if UserModel.shared.token != nil {
            let token = UserModel.shared.token!
            UserModel.accessToken = token
            print("Stored Token: \(token)")
        }
        
        if isLogin {
            UserDefaultsConfig.authorization    = true
            UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.currentUser)
            UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.authorization)
            UserDefaults.standard.synchronize()
            
            //This is to save min and max of all the readings
            UserModel.updateMinMax()
        }
        
        //This is to save user data offline
        UserModel().saveUserData()
        
        //        GlobalAPI.shared.appConfigAPI { (isDone) in
        //        }
    }
    
    class func updateMinMax(){
        
        if UserModel.shared.unitData != nil {
            for item in UserModel.shared.unitData {
                if let reading = ReadingType.init(rawValue: item.readingKey) {
                    switch reading {
                        
                    case .SPO2:
                        kMinSPO2                = JSON(item.min!).intValue
                        kMaxSPO2                = JSON(item.max!).intValue
                        break
                    case .PEF:
                        kMinPEF                 = JSON(item.min!).intValue
                        kMaxPEF                 = JSON(item.max!).intValue
                        break
                    case .BloodPressure:
                        kMinBPDiastolic         = JSON(item.min!).intValue
                        kMaxBPDiastolic         = JSON(item.max!).intValue
                        kMinBPSystolic          = JSON(item.min!).intValue
                        kMaxBPSystolic          = JSON(item.max!).intValue
                        break
                    case .HeartRate:
                        kMinHeartRate           = JSON(item.min!).intValue
                        kMaxHeartRate           = JSON(item.max!).intValue
                        break
                    case .BodyWeight:
                        break
                    case .BMI:
                        kMinBMI                 = JSON(item.min!).intValue
                        kMaxBMI                 = JSON(item.max!).intValue
                        break
                    case .BloodGlucose:
                        kMinFastBlood           = JSON(item.min!).intValue
                        kMaxFastBlood           = JSON(item.max!).intValue
                        kMinPPBlood             = JSON(item.min!).intValue
                        kMaxPPBlood             = JSON(item.max!).intValue
                        break
                    case .HbA1c:
                        kMinHbA1c               = JSON(item.min!).intValue
                        kMaxHbA1c               = JSON(item.max!).intValue
                        break
                    case .ACR:
                        kMinACR                 = JSON(item.min!).intValue
                        kMaxACR                 = JSON(item.max!).intValue
                        break
                    case .eGFR:
                        kMineGFR                = JSON(item.min!).intValue
                        kMaxeGFR                = JSON(item.max!).intValue
                        break
                    case .FEV1Lung:
                        kMinFEV1Lung            = JSON(item.min!).intValue
                        kMaxFEV1Lung            = JSON(item.max!).intValue
                        break
                    case .cat:
                        break
                    case .six_min_walk:
                        kMinSixMinWalkValue     = JSON(item.min!).intValue
                        kMaxSixMinWalkValue     = JSON(item.max!).intValue
                        break
                    case .fibro_scan:
                        if item.subReadingKey == "cap" {
                            kMinimumCAP         = JSON(item.min!).intValue
                            kMaximumCAP         = JSON(item.max!).intValue
                        }
                        if item.subReadingKey == "lsm" {
                            kMinimumLSM         = JSON(item.min!).intValue
                            kMaximumLSM         = JSON(item.max!).intValue
                        }
                        break
                    case .fib4:
                        kMinFIB4Score           = JSON(item.min!).intValue
                        kMaxFIB4Score           = JSON(item.max!).intValue
                        break
                    case .sgot:
                        kMinimumSGOT            = JSON(item.min!).intValue
                        kMaximumSGOT            = JSON(item.max!).intValue
                        break
                    case .sgpt:
                        kMinimumSGPT            = JSON(item.min!).intValue
                        kMaximumSGPT            = JSON(item.max!).intValue
                        break
                    case .triglycerides:
                        kMinimumTriglyceride    = JSON(item.min!).intValue
                        kMaximumTriglyceride    = JSON(item.max!).intValue
                        break
                    case .total_cholesterol:
                        kMinimumTotalCholesterol = JSON(item.min!).intValue
                        kMaximumTotalCholesterol = JSON(item.max!).intValue
                        break
                    case .ldl_cholesterol:
                        kMinimumLDL             = JSON(item.min!).intValue
                        kMaximumLDL             = JSON(item.max!).intValue
                        break
                    case .hdl_cholesterol:
                        kMinimumHDL             = JSON(item.min!).intValue
                        kMaximumHDL             = JSON(item.max!).intValue
                        break
                    case .waist_circumference:
                        kMinWaistCircumference  = JSON(item.min!).intValue
                        kMaxWaistCircumference  = JSON(item.max!).intValue
                        break
                    case .platelet:
                        kMinPlatelet            = JSON(item.min!).intValue
                        kMaxPlatelet            = JSON(item.max!).intValue
                        break
                    case .serum_creatinine:
                        kMinSerumCreatinine     = JSON(item.min!).doubleValue
                        kMaxSerumCreatinine     = JSON(item.max!).doubleValue
                        break
                    case .fatty_liver_ugs_grade:
                        kMinFattyLiver          = JSON(item.min!).intValue
                        kMaxFattyLiver          = JSON(item.max!).intValue
                        break
                    case .random_blood_glucose:
                        kMinRandomBG            = JSON(item.min!).intValue
                        kMaxRandomBG            = JSON(item.max!).intValue
                        break
                    case .BodyFat:
                        kMinBodyFat             = JSON(item.min!).intValue
                        kMaxBodyFat             = JSON(item.max!).intValue
                        break
                    case .Hydration:
                        kMinHydration           = JSON(item.min!).intValue
                        kMaxHydration           = JSON(item.max!).intValue
                        break
                    case .MuscleMass:
                        kMinMuscleMass          = JSON(item.min!).intValue
                        kMaxMuscleMass          = JSON(item.max!).intValue
                        break
                    case .Protein:
                        kMinProtein             = JSON(item.min!).intValue
                        kMaxProtein             = JSON(item.max!).intValue
                        break
                    case .BoneMass:
                        kMinBoneMass            = JSON(item.min!).intValue
                        kMaxBoneMass            = JSON(item.max!).intValue
                        break
                    case .VisceralFat:
                        kMinVisceralFat         = JSON(item.min!).doubleValue
                        kMaxVisceralFat         = JSON(item.max!).doubleValue
                        break
                    case .BaselMetabolicRate:
                        kMinBasalMetabolicRate  = JSON(item.min!).intValue
                        kMaxBasalMetabolicRate  = JSON(item.max!).intValue
                        break
                    case .MetabolicAge:
                        kMinMetabolicAge        = JSON(item.min!).intValue
                        kMaxMetabolicAge        = JSON(item.max!).intValue
                        break
                    case .SubcutaneousFat:
                        kMinSubcutaneousFat     = JSON(item.min!).intValue
                        kMaxSubcutaneousFat     = JSON(item.max!).intValue
                        break
                    case .SkeletalMuscle:
                        kMinSkeletalMuscle      = JSON(item.min!).intValue
                        kMaxSkeletalMuscle      = JSON(item.max!).intValue
                        break
                    case .fev1_fvc_ratio,.fvc,.aqi,.humidity,.temperature,.sedentary_time:
                        break
                    case .calories_burned:
                        kMinCaloriesBurned      = JSON(item.min ?? "").intValue
                        kMaxCaloriesBurned      = JSON(item.max ?? "").intValue
                        break
                    }
                }
                else {
                    ///If no reading key found in case of weight and height
                    if let heightUnit = HeightUnit.init(rawValue: item.unitKey) {
                        switch heightUnit {
                        case .cm:
                            kMinHeightCm        = JSON(item.min!).intValue
                            kMaxHeightCm        = JSON(item.max!).intValue
                            break
                        case .feet_inch:
                            kMinHeightFt        = JSON(item.minFeet!).intValue
                            kMaxHeightFt        = JSON(item.maxFeet!).intValue
                            
                            kMinHeightIn        = JSON(item.minInch!).intValue
                            kMaxHeightIn        = JSON(item.maxInch!).intValue
                            break
                        }
                    }
                    if let weightUnit = WeightUnit.init(rawValue: item.unitKey) {
                        switch weightUnit {
                        case .kg:
                            kMinBodyWeightKg    = JSON(item.min!).intValue
                            kMaxBodyWeightKg    = JSON(item.max!).intValue
                            break
                        case .lbs:
                            kMinBodyWeightLbs   = JSON(item.min!).intValue
                            kMaxBodyWeightLbs   = JSON(item.max!).intValue
                            break
                        }
                    }
                }
            }
        }
    }
}

//Data model for save user login credential for remember me
struct RememberMeData: Codable {
    let email: String!
    let password: String
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦

class LinkResponse : NSObject, NSCoding{
    
    var affectedRows : Int!
    var fieldCount : Int!
    var info : String!
    var insertId : Int!
    var serverStatus : Int!
    var warningStatus : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        affectedRows = json["affectedRows"].intValue
        fieldCount = json["fieldCount"].intValue
        info = json["info"].stringValue
        insertId = json["insertId"].intValue
        serverStatus = json["serverStatus"].intValue
        warningStatus = json["warningStatus"].intValue
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        affectedRows = aDecoder.decodeObject(forKey: "affectedRows") as? Int
        fieldCount = aDecoder.decodeObject(forKey: "fieldCount") as? Int
        info = aDecoder.decodeObject(forKey: "info") as? String
        insertId = aDecoder.decodeObject(forKey: "insertId") as? Int
        serverStatus = aDecoder.decodeObject(forKey: "serverStatus") as? Int
        warningStatus = aDecoder.decodeObject(forKey: "warningStatus") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if affectedRows != nil{
            aCoder.encode(affectedRows, forKey: "affectedRows")
        }
        if fieldCount != nil{
            aCoder.encode(fieldCount, forKey: "fieldCount")
        }
        if info != nil{
            aCoder.encode(info, forKey: "info")
        }
        if insertId != nil{
            aCoder.encode(insertId, forKey: "insertId")
        }
        if serverStatus != nil{
            aCoder.encode(serverStatus, forKey: "serverStatus")
        }
        if warningStatus != nil{
            aCoder.encode(warningStatus, forKey: "warningStatus")
        }
        
    }
    
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦

class PatientLinkDoctorDetail : NSObject, NSCoding{
    
    var about : String!
    var accessCode : String!
    var businessId : String!
    var city : String!
    var clinicId : String!
    var contactNo : String!
    var countryCode: String!
    var country : String!
    var createdAt : String!
    var deepLink : String!
    var division : String!
    var dob : String!
    var doctorId : String!
    var email : String!
    var experience : String!
    var gender : String!
    var isActive : String!
    var isDeleted : String!
    var languageSpoken : String!
    var languagesId : String!
    var name : String!
    var patientDoctorRelId : String!
    var patientId : String!
    var plan : String!
    var profileImage : String!
    var qualification : String!
    var region : String!
    var specialization : String!
    var state : String!
    var updatedAt : String!
    var updatedBy : String!
    var doctorUniqId : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        about = json["about"].stringValue
        accessCode = json["access_code"].stringValue
        businessId = json["business_id"].stringValue
        city = json["city"].stringValue
        clinicId = json["clinic_id"].stringValue
        contactNo = json["contact_no"].stringValue
        country = json["country"].stringValue
        createdAt = json["created_at"].stringValue
        deepLink = json["deep_link"].stringValue
        division = json["division"].stringValue
        dob = json["dob"].stringValue
        doctorId = json["doctor_id"].stringValue
        email = json["email"].stringValue
        experience = json["experience"].stringValue
        gender = json["gender"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        languageSpoken = json["language_spoken"].stringValue
        languagesId = json["languages_id"].stringValue
        name = json["name"].stringValue
        patientDoctorRelId = json["patient_doctor_rel_id"].stringValue
        patientId = json["patient_id"].stringValue
        plan = json["plan"].stringValue
        profileImage = json["profile_image"].stringValue
        qualification = json["qualification"].stringValue
        region = json["region"].stringValue
        specialization = json["specialization"].stringValue
        state = json["state"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        countryCode = json["country_code"].stringValue
        doctorUniqId = json["doctor_uniq_id"].stringValue
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if about != nil{
            dictionary["about"] = about
        }
        if accessCode != nil{
            dictionary["access_code"] = accessCode
        }
        if businessId != nil{
            dictionary["business_id"] = businessId
        }
        if city != nil{
            dictionary["city"] = city
        }
        if clinicId != nil{
            dictionary["clinic_id"] = clinicId
        }
        if contactNo != nil{
            dictionary["contact_no"] = contactNo
        }
        if country != nil{
            dictionary["country"] = country
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if deepLink != nil{
            dictionary["deep_link"] = deepLink
        }
        if division != nil{
            dictionary["division"] = division
        }
        if dob != nil{
            dictionary["dob"] = dob
        }
        if doctorId != nil{
            dictionary["doctor_id"] = doctorId
        }
        if email != nil{
            dictionary["email"] = email
        }
        if experience != nil{
            dictionary["experience"] = experience
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if isActive != nil{
            dictionary["is_active"] = isActive
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if languageSpoken != nil{
            dictionary["language_spoken"] = languageSpoken
        }
        if languagesId != nil{
            dictionary["languages_id"] = languagesId
        }
        if name != nil{
            dictionary["name"] = name
        }
        if patientDoctorRelId != nil{
            dictionary["patient_doctor_rel_id"] = patientDoctorRelId
        }
        if patientId != nil{
            dictionary["patient_id"] = patientId
        }
        if plan != nil{
            dictionary["plan"] = plan
        }
        if profileImage != nil{
            dictionary["profile_image"] = profileImage
        }
        if qualification != nil{
            dictionary["qualification"] = qualification
        }
        if region != nil{
            dictionary["region"] = region
        }
        if specialization != nil{
            dictionary["specialization"] = specialization
        }
        if state != nil{
            dictionary["state"] = state
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if updatedBy != nil{
            dictionary["updated_by"] = updatedBy
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        about = aDecoder.decodeObject(forKey: "about") as? String
        accessCode = aDecoder.decodeObject(forKey: "access_code") as? String
        businessId = aDecoder.decodeObject(forKey: "business_id") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        clinicId = aDecoder.decodeObject(forKey: "clinic_id") as? String
        contactNo = aDecoder.decodeObject(forKey: "contact_no") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        deepLink = aDecoder.decodeObject(forKey: "deep_link") as? String
        division = aDecoder.decodeObject(forKey: "division") as? String
        dob = aDecoder.decodeObject(forKey: "dob") as? String
        doctorId = aDecoder.decodeObject(forKey: "doctor_id") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        experience = aDecoder.decodeObject(forKey: "experience") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        isActive = aDecoder.decodeObject(forKey: "is_active") as? String
        isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? String
        languageSpoken = aDecoder.decodeObject(forKey: "language_spoken") as? String
        languagesId = aDecoder.decodeObject(forKey: "languages_id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        patientDoctorRelId = aDecoder.decodeObject(forKey: "patient_doctor_rel_id") as? String
        patientId = aDecoder.decodeObject(forKey: "patient_id") as? String
        plan = aDecoder.decodeObject(forKey: "plan") as? String
        profileImage = aDecoder.decodeObject(forKey: "profile_image") as? String
        qualification = aDecoder.decodeObject(forKey: "qualification") as? String
        region = aDecoder.decodeObject(forKey: "region") as? String
        specialization = aDecoder.decodeObject(forKey: "specialization") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        updatedBy = aDecoder.decodeObject(forKey: "updated_by") as? String
        countryCode = aDecoder.decodeObject(forKey: "country_code") as? String
        doctorUniqId = aDecoder.decodeObject(forKey: "doctor_uniq_id") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if about != nil{
            aCoder.encode(about, forKey: "about")
        }
        if accessCode != nil{
            aCoder.encode(accessCode, forKey: "access_code")
        }
        if businessId != nil{
            aCoder.encode(businessId, forKey: "business_id")
        }
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if clinicId != nil{
            aCoder.encode(clinicId, forKey: "clinic_id")
        }
        if contactNo != nil{
            aCoder.encode(contactNo, forKey: "contact_no")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if deepLink != nil{
            aCoder.encode(deepLink, forKey: "deep_link")
        }
        if division != nil{
            aCoder.encode(division, forKey: "division")
        }
        if dob != nil{
            aCoder.encode(dob, forKey: "dob")
        }
        if doctorId != nil{
            aCoder.encode(doctorId, forKey: "doctor_id")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if experience != nil{
            aCoder.encode(experience, forKey: "experience")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if isActive != nil{
            aCoder.encode(isActive, forKey: "is_active")
        }
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if languageSpoken != nil{
            aCoder.encode(languageSpoken, forKey: "language_spoken")
        }
        if languagesId != nil{
            aCoder.encode(languagesId, forKey: "languages_id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if patientDoctorRelId != nil{
            aCoder.encode(patientDoctorRelId, forKey: "patient_doctor_rel_id")
        }
        if patientId != nil{
            aCoder.encode(patientId, forKey: "patient_id")
        }
        if plan != nil{
            aCoder.encode(plan, forKey: "plan")
        }
        if profileImage != nil{
            aCoder.encode(profileImage, forKey: "profile_image")
        }
        if qualification != nil{
            aCoder.encode(qualification, forKey: "qualification")
        }
        if region != nil{
            aCoder.encode(region, forKey: "region")
        }
        if specialization != nil{
            aCoder.encode(specialization, forKey: "specialization")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if updatedBy != nil{
            aCoder.encode(updatedBy, forKey: "updated_by")
        }
        if countryCode != nil{
            aCoder.encode(countryCode, forKey: "country_code")
        }
        if doctorUniqId != nil{
            aCoder.encode(doctorUniqId, forKey: "doctor_uniq_id")
        }
    }
    
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦

class DeviceInfo : NSObject, NSCoding{
    
    var apiVersion : String!
    var appVersion : String!
    var buildVersionNumber : String!
    var createdAt : String!
    var deviceName : String!
    var deviceToken : String!
    var deviceType : String!
    var ip : String!
    var modelName : String!
    var osVersion : String!
    var patientId : String!
    var updateDeviceInfoId : String!
    var updatedAt : String!
    var uuid : String!
    var versionNumber : String!
    
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        apiVersion = json["api_version"].stringValue
        appVersion = json["app_version"].stringValue
        buildVersionNumber = json["build_version_number"].stringValue
        createdAt = json["created_at"].stringValue
        deviceName = json["device_name"].stringValue
        deviceToken = json["device_token"].stringValue
        deviceType = json["device_type"].stringValue
        ip = json["ip"].stringValue
        modelName = json["model_name"].stringValue
        osVersion = json["os_version"].stringValue
        patientId = json["patient_id"].stringValue
        updateDeviceInfoId = json["update_device_info_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        uuid = json["uuid"].stringValue
        versionNumber = json["version_number"].stringValue
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        apiVersion = aDecoder.decodeObject(forKey: "api_version") as? String
        appVersion = aDecoder.decodeObject(forKey: "app_version") as? String
        buildVersionNumber = aDecoder.decodeObject(forKey: "build_version_number") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        deviceName = aDecoder.decodeObject(forKey: "device_name") as? String
        deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
        deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
        ip = aDecoder.decodeObject(forKey: "ip") as? String
        modelName = aDecoder.decodeObject(forKey: "model_name") as? String
        osVersion = aDecoder.decodeObject(forKey: "os_version") as? String
        patientId = aDecoder.decodeObject(forKey: "patient_id") as? String
        updateDeviceInfoId = aDecoder.decodeObject(forKey: "update_device_info_id") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        uuid = aDecoder.decodeObject(forKey: "uuid") as? String
        versionNumber = aDecoder.decodeObject(forKey: "version_number") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if apiVersion != nil{
            aCoder.encode(apiVersion, forKey: "api_version")
        }
        if appVersion != nil{
            aCoder.encode(appVersion, forKey: "app_version")
        }
        if buildVersionNumber != nil{
            aCoder.encode(buildVersionNumber, forKey: "build_version_number")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if deviceName != nil{
            aCoder.encode(deviceName, forKey: "device_name")
        }
        if deviceToken != nil{
            aCoder.encode(deviceToken, forKey: "device_token")
        }
        if deviceType != nil{
            aCoder.encode(deviceType, forKey: "device_type")
        }
        if ip != nil{
            aCoder.encode(ip, forKey: "ip")
        }
        if modelName != nil{
            aCoder.encode(modelName, forKey: "model_name")
        }
        if osVersion != nil{
            aCoder.encode(osVersion, forKey: "os_version")
        }
        if patientId != nil{
            aCoder.encode(patientId, forKey: "patient_id")
        }
        if updateDeviceInfoId != nil{
            aCoder.encode(updateDeviceInfoId, forKey: "update_device_info_id")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if uuid != nil{
            aCoder.encode(uuid, forKey: "uuid")
        }
        if versionNumber != nil{
            aCoder.encode(versionNumber, forKey: "version_number")
        }
        
    }
    
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦

class ProfileCompletionStatu : NSObject, NSCoding{
    
    var drugPrescription : String!
    var goalReading : String!
    var location : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        drugPrescription = json["drug_prescription"].stringValue
        goalReading = json["goal_reading"].stringValue
        location = json["location"].stringValue
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        drugPrescription = aDecoder.decodeObject(forKey: "drug_prescription") as? String
        goalReading = aDecoder.decodeObject(forKey: "goal_reading") as? String
        location = aDecoder.decodeObject(forKey: "location") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if drugPrescription != nil{
            aCoder.encode(drugPrescription, forKey: "drug_prescription")
        }
        if goalReading != nil{
            aCoder.encode(goalReading, forKey: "goal_reading")
        }
        if location != nil{
            aCoder.encode(location, forKey: "location")
        }
        
    }
    
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class DoctorSay : NSObject, NSCoding{
    
    var createdAt : String!
    var descriptionField : String!
    var doctorSaysMasterId : String!
    var isActive : String!
    var isDeleted : String!
    var title : String!
    var updatedAt : String!
    var updatedBy : String!
    
    var deepLink: String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        doctorSaysMasterId = json["doctor_says_master_id"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        title = json["title"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
        
        deepLink = json["deep_link"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        doctorSaysMasterId = aDecoder.decodeObject(forKey: "doctor_says_master_id") as? String
        isActive = aDecoder.decodeObject(forKey: "is_active") as? String
        isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        updatedBy = aDecoder.decodeObject(forKey: "updated_by") as? String
        
        deepLink = aDecoder.decodeObject(forKey: "deep_link") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if doctorSaysMasterId != nil{
            aCoder.encode(doctorSaysMasterId, forKey: "doctor_says_master_id")
        }
        if isActive != nil{
            aCoder.encode(isActive, forKey: "is_active")
        }
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if updatedBy != nil{
            aCoder.encode(updatedBy, forKey: "updated_by")
        }
        
        if deepLink != nil{
            aCoder.encode(deepLink, forKey: "deep_link")
        }
    }
    
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class MedicalConditionName : NSObject, NSCoding{
    
    var medicalConditionName : String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        medicalConditionName = json["medical_condition_name"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if medicalConditionName != nil{
            dictionary["medical_condition_name"] = medicalConditionName
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        medicalConditionName = aDecoder.decodeObject(forKey: "medical_condition_name") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if medicalConditionName != nil{
            aCoder.encode(medicalConditionName, forKey: "medical_condition_name")
        }
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class PatientPlan : NSObject, NSCoding{
    
    var androidPerMonthPrice : Float!
    var androidPrice : Float!
    var cardImage : String!
    var colourScheme : String!
    var createdAt : String!
    var descriptionField : String!
    var featuresRes : [FeaturesRe]!
    var imageUrl : String!
    var iosPerMonthPrice : Float!
    var iosPrice : Float!
    var isActive : String!
    var isDeleted : String!
    var offerPerMonthPrice : Float!
    var offerPrice : Float!
    var patientId : String!
    var patientPlanRelId : String!
    var planEndDate : String!
    var planMasterId : String!
    var planName : String!
    var planPurchaseDatetime : String!
    var planStartDate : String!
    var planType : String!
    var renewalReminderDays : Int!
    var subTitle : String!
    var transactionId : String!
    var updatedAt : String!
    var updatedBy : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        androidPerMonthPrice = json["android_per_month_price"].floatValue
        androidPrice = json["android_price"].floatValue
        cardImage = json["card_image"].stringValue
        colourScheme = json["colour_scheme"].stringValue
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        featuresRes = [FeaturesRe]()
        let featuresResArray = json["features_res"].arrayValue
        for featuresResJson in featuresResArray{
            let value = FeaturesRe(fromJson: featuresResJson)
            featuresRes.append(value)
        }
        imageUrl = json["image_url"].stringValue
        iosPerMonthPrice = json["ios_per_month_price"].floatValue
        iosPrice = json["ios_price"].floatValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        offerPerMonthPrice = json["offer_per_month_price"].floatValue
        offerPrice = json["offer_price"].floatValue
        patientId = json["patient_id"].stringValue
        patientPlanRelId = json["patient_plan_rel_id"].stringValue
        planEndDate = json["plan_end_date"].stringValue
        planMasterId = json["plan_master_id"].stringValue
        planName = json["plan_name"].stringValue
        planPurchaseDatetime = json["plan_purchase_datetime"].stringValue
        planStartDate = json["plan_start_date"].stringValue
        planType = json["plan_type"].stringValue
        renewalReminderDays = json["renewal_reminder_days"].intValue
        subTitle = json["sub_title"].stringValue
        transactionId = json["transaction_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if androidPerMonthPrice != nil{
            dictionary["android_per_month_price"] = androidPerMonthPrice
        }
        if androidPrice != nil{
            dictionary["android_price"] = androidPrice
        }
        if cardImage != nil{
            dictionary["card_image"] = cardImage
        }
        if colourScheme != nil{
            dictionary["colour_scheme"] = colourScheme
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if featuresRes != nil{
            var dictionaryElements = [[String:Any]]()
            for featuresResElement in featuresRes {
                dictionaryElements.append(featuresResElement.toDictionary())
            }
            dictionary["features_res"] = dictionaryElements
        }
        if imageUrl != nil{
            dictionary["image_url"] = imageUrl
        }
        if iosPerMonthPrice != nil{
            dictionary["ios_per_month_price"] = iosPerMonthPrice
        }
        if iosPrice != nil{
            dictionary["ios_price"] = iosPrice
        }
        if isActive != nil{
            dictionary["is_active"] = isActive
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if offerPerMonthPrice != nil{
            dictionary["offer_per_month_price"] = offerPerMonthPrice
        }
        if offerPrice != nil{
            dictionary["offer_price"] = offerPrice
        }
        if patientId != nil{
            dictionary["patient_id"] = patientId
        }
        if patientPlanRelId != nil{
            dictionary["patient_plan_rel_id"] = patientPlanRelId
        }
        if planEndDate != nil{
            dictionary["plan_end_date"] = planEndDate
        }
        if planMasterId != nil{
            dictionary["plan_master_id"] = planMasterId
        }
        if planName != nil{
            dictionary["plan_name"] = planName
        }
        if planPurchaseDatetime != nil{
            dictionary["plan_purchase_datetime"] = planPurchaseDatetime
        }
        if planStartDate != nil{
            dictionary["plan_start_date"] = planStartDate
        }
        if planType != nil{
            dictionary["plan_type"] = planType
        }
        if renewalReminderDays != nil{
            dictionary["renewal_reminder_days"] = renewalReminderDays
        }
        if subTitle != nil{
            dictionary["sub_title"] = subTitle
        }
        if transactionId != nil{
            dictionary["transaction_id"] = transactionId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if updatedBy != nil{
            dictionary["updated_by"] = updatedBy
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        androidPerMonthPrice = aDecoder.decodeObject(forKey: "android_per_month_price") as? Float
        androidPrice = aDecoder.decodeObject(forKey: "android_price") as? Float
        cardImage = aDecoder.decodeObject(forKey: "card_image") as? String
        colourScheme = aDecoder.decodeObject(forKey: "colour_scheme") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        featuresRes = aDecoder.decodeObject(forKey: "features_res") as? [FeaturesRe]
        imageUrl = aDecoder.decodeObject(forKey: "image_url") as? String
        iosPerMonthPrice = aDecoder.decodeObject(forKey: "ios_per_month_price") as? Float
        iosPrice = aDecoder.decodeObject(forKey: "ios_price") as? Float
        isActive = aDecoder.decodeObject(forKey: "is_active") as? String
        isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? String
        offerPerMonthPrice = aDecoder.decodeObject(forKey: "offer_per_month_price") as? Float
        offerPrice = aDecoder.decodeObject(forKey: "offer_price") as? Float
        patientId = aDecoder.decodeObject(forKey: "patient_id") as? String
        patientPlanRelId = aDecoder.decodeObject(forKey: "patient_plan_rel_id") as? String
        planEndDate = aDecoder.decodeObject(forKey: "plan_end_date") as? String
        planMasterId = aDecoder.decodeObject(forKey: "plan_master_id") as? String
        planName = aDecoder.decodeObject(forKey: "plan_name") as? String
        planPurchaseDatetime = aDecoder.decodeObject(forKey: "plan_purchase_datetime") as? String
        planStartDate = aDecoder.decodeObject(forKey: "plan_start_date") as? String
        planType = aDecoder.decodeObject(forKey: "plan_type") as? String
        renewalReminderDays = aDecoder.decodeObject(forKey: "renewal_reminder_days") as? Int
        subTitle = aDecoder.decodeObject(forKey: "sub_title") as? String
        transactionId = aDecoder.decodeObject(forKey: "transaction_id") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        updatedBy = aDecoder.decodeObject(forKey: "updated_by") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if androidPerMonthPrice != nil{
            aCoder.encode(androidPerMonthPrice, forKey: "android_per_month_price")
        }
        if androidPrice != nil{
            aCoder.encode(androidPrice, forKey: "android_price")
        }
        if cardImage != nil{
            aCoder.encode(cardImage, forKey: "card_image")
        }
        if colourScheme != nil{
            aCoder.encode(colourScheme, forKey: "colour_scheme")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if featuresRes != nil{
            aCoder.encode(featuresRes, forKey: "features_res")
        }
        if imageUrl != nil{
            aCoder.encode(imageUrl, forKey: "image_url")
        }
        if iosPerMonthPrice != nil{
            aCoder.encode(iosPerMonthPrice, forKey: "ios_per_month_price")
        }
        if iosPrice != nil{
            aCoder.encode(iosPrice, forKey: "ios_price")
        }
        if isActive != nil{
            aCoder.encode(isActive, forKey: "is_active")
        }
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if offerPerMonthPrice != nil{
            aCoder.encode(offerPerMonthPrice, forKey: "offer_per_month_price")
        }
        if offerPrice != nil{
            aCoder.encode(offerPrice, forKey: "offer_price")
        }
        if patientId != nil{
            aCoder.encode(patientId, forKey: "patient_id")
        }
        if patientPlanRelId != nil{
            aCoder.encode(patientPlanRelId, forKey: "patient_plan_rel_id")
        }
        if planEndDate != nil{
            aCoder.encode(planEndDate, forKey: "plan_end_date")
        }
        if planMasterId != nil{
            aCoder.encode(planMasterId, forKey: "plan_master_id")
        }
        if planName != nil{
            aCoder.encode(planName, forKey: "plan_name")
        }
        if planPurchaseDatetime != nil{
            aCoder.encode(planPurchaseDatetime, forKey: "plan_purchase_datetime")
        }
        if planStartDate != nil{
            aCoder.encode(planStartDate, forKey: "plan_start_date")
        }
        if planType != nil{
            aCoder.encode(planType, forKey: "plan_type")
        }
        if renewalReminderDays != nil{
            aCoder.encode(renewalReminderDays, forKey: "renewal_reminder_days")
        }
        if subTitle != nil{
            aCoder.encode(subTitle, forKey: "sub_title")
        }
        if transactionId != nil{
            aCoder.encode(transactionId, forKey: "transaction_id")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if updatedBy != nil{
            aCoder.encode(updatedBy, forKey: "updated_by")
        }
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class BmrDetail : NSObject, NSCoding{
    
    var activityLevel : String!
    var bmr : String!
    var createdAt : String!
    var currentWeight : String!
    var goalWeight : String!
    var height : String!
    var isActive : String!
    var isDeleted : String!
    var months : String!
    var patientGoalWeightRelId : String!
    var patientId : String!
    var rate : String!
    var targetCalories : String!
    var type : String!
    var updatedAt : String!
    var updatedBy : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        activityLevel = json["activity_level"].stringValue
        bmr = json["bmr"].stringValue
        createdAt = json["created_at"].stringValue
        currentWeight = json["current_weight"].stringValue
        goalWeight = json["goal_weight"].stringValue
        height = json["height"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        months = json["months"].stringValue
        patientGoalWeightRelId = json["patient_goal_weight_rel_id"].stringValue
        patientId = json["patient_id"].stringValue
        rate = json["rate"].stringValue
        targetCalories = json["target_calories"].stringValue
        type = json["type"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if activityLevel != nil{
            dictionary["activity_level"] = activityLevel
        }
        if bmr != nil{
            dictionary["bmr"] = bmr
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if currentWeight != nil{
            dictionary["current_weight"] = currentWeight
        }
        if goalWeight != nil{
            dictionary["goal_weight"] = goalWeight
        }
        if height != nil{
            dictionary["height"] = height
        }
        if isActive != nil{
            dictionary["is_active"] = isActive
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if months != nil{
            dictionary["months"] = months
        }
        if patientGoalWeightRelId != nil{
            dictionary["patient_goal_weight_rel_id"] = patientGoalWeightRelId
        }
        if patientId != nil{
            dictionary["patient_id"] = patientId
        }
        if rate != nil{
            dictionary["rate"] = rate
        }
        if targetCalories != nil{
            dictionary["target_calories"] = targetCalories
        }
        if type != nil{
            dictionary["type"] = type
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if updatedBy != nil{
            dictionary["updated_by"] = updatedBy
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        activityLevel = aDecoder.decodeObject(forKey: "activity_level") as? String
        bmr = aDecoder.decodeObject(forKey: "bmr") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        currentWeight = aDecoder.decodeObject(forKey: "current_weight") as? String
        goalWeight = aDecoder.decodeObject(forKey: "goal_weight") as? String
        height = aDecoder.decodeObject(forKey: "height") as? String
        isActive = aDecoder.decodeObject(forKey: "is_active") as? String
        isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? String
        months = aDecoder.decodeObject(forKey: "months") as? String
        patientGoalWeightRelId = aDecoder.decodeObject(forKey: "patient_goal_weight_rel_id") as? String
        patientId = aDecoder.decodeObject(forKey: "patient_id") as? String
        rate = aDecoder.decodeObject(forKey: "rate") as? String
        targetCalories = aDecoder.decodeObject(forKey: "target_calories") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        updatedBy = aDecoder.decodeObject(forKey: "updated_by") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if activityLevel != nil{
            aCoder.encode(activityLevel, forKey: "activity_level")
        }
        if bmr != nil{
            aCoder.encode(bmr, forKey: "bmr")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if currentWeight != nil{
            aCoder.encode(currentWeight, forKey: "current_weight")
        }
        if goalWeight != nil{
            aCoder.encode(goalWeight, forKey: "goal_weight")
        }
        if height != nil{
            aCoder.encode(height, forKey: "height")
        }
        if isActive != nil{
            aCoder.encode(isActive, forKey: "is_active")
        }
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if months != nil{
            aCoder.encode(months, forKey: "months")
        }
        if patientGoalWeightRelId != nil{
            aCoder.encode(patientGoalWeightRelId, forKey: "patient_goal_weight_rel_id")
        }
        if patientId != nil{
            aCoder.encode(patientId, forKey: "patient_id")
        }
        if rate != nil{
            aCoder.encode(rate, forKey: "rate")
        }
        if targetCalories != nil{
            aCoder.encode(targetCalories, forKey: "target_calories")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if updatedBy != nil{
            aCoder.encode(updatedBy, forKey: "updated_by")
        }
        
    }
    
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦

class UnitData : NSObject, NSCoding{
    
    var max : String!
    var maxFeet : String!
    var maxInch : String!
    var min : String!
    var minFeet : String!
    var minInch : String!
    var readingKey : String!
    var subReadingKey : String!
    var unitKey : String!
    var unitTitle : String!
    
    var isSelected = false
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        max = json["max"].stringValue
        maxFeet = json["max_feet"].stringValue
        maxInch = json["max_inch"].stringValue
        min = json["min"].stringValue
        minFeet = json["min_feet"].stringValue
        minInch = json["min_inch"].stringValue
        readingKey = json["reading_key"].stringValue
        subReadingKey = json["sub_reading_key"].stringValue
        unitKey = json["unit_key"].stringValue
        unitTitle = json["unit_title"].stringValue
    }
    
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        max = aDecoder.decodeObject(forKey: "max") as? String
        maxFeet = aDecoder.decodeObject(forKey: "max_feet") as? String
        maxInch = aDecoder.decodeObject(forKey: "max_inch") as? String
        min = aDecoder.decodeObject(forKey: "min") as? String
        minFeet = aDecoder.decodeObject(forKey: "min_feet") as? String
        minInch = aDecoder.decodeObject(forKey: "min_inch") as? String
        readingKey = aDecoder.decodeObject(forKey: "reading_key") as? String
        subReadingKey = aDecoder.decodeObject(forKey: "sub_reading_key") as? String
        unitKey = aDecoder.decodeObject(forKey: "unit_key") as? String
        unitTitle = aDecoder.decodeObject(forKey: "unit_title") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if max != nil{
            aCoder.encode(max, forKey: "max")
        }
        if maxFeet != nil{
            aCoder.encode(maxFeet, forKey: "max_feet")
        }
        if maxInch != nil{
            aCoder.encode(maxInch, forKey: "max_inch")
        }
        if min != nil{
            aCoder.encode(min, forKey: "min")
        }
        if minFeet != nil{
            aCoder.encode(minFeet, forKey: "min_feet")
        }
        if minInch != nil{
            aCoder.encode(minInch, forKey: "min_inch")
        }
        if readingKey != nil{
            aCoder.encode(readingKey, forKey: "reading_key")
        }
        if subReadingKey != nil{
            aCoder.encode(subReadingKey, forKey: "sub_reading_key")
        }
        if unitKey != nil{
            aCoder.encode(unitKey, forKey: "unit_key")
        }
        if unitTitle != nil{
            aCoder.encode(unitTitle, forKey: "unit_title")
        }
        
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦

class HcList : NSObject, NSCoding{
    
    var firstName : String!
    var healthCoachId : String!
    var lastName : String!
    var profilePic : String!
    var role : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        firstName = json["first_name"].stringValue
        healthCoachId = json["health_coach_id"].stringValue
        lastName = json["last_name"].stringValue
        profilePic = json["profile_pic"].stringValue
        role = json["role"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if healthCoachId != nil{
            dictionary["health_coach_id"] = healthCoachId
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if profilePic != nil{
            dictionary["profile_pic"] = profilePic
        }
        if role != nil{
            dictionary["role"] = role
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        healthCoachId = aDecoder.decodeObject(forKey: "health_coach_id") as? String
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        profilePic = aDecoder.decodeObject(forKey: "profile_pic") as? String
        role = aDecoder.decodeObject(forKey: "role") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if healthCoachId != nil{
            aCoder.encode(healthCoachId, forKey: "health_coach_id")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if profilePic != nil{
            aCoder.encode(profilePic, forKey: "profile_pic")
        }
        if role != nil{
            aCoder.encode(role, forKey: "role")
        }
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class Settings : NSObject, NSCoding{
    
    var attributeName : String!
    var attributeValue : String!
    var createdAt : String!
    var settingsMasterId : String!
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        attributeName = json["attribute_name"].stringValue
        attributeValue = json["attribute_value"].stringValue
        createdAt = json["created_at"].stringValue
        settingsMasterId = json["settings_master_id"].stringValue
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        attributeName = aDecoder.decodeObject(forKey: "attribute_name") as? String
        attributeValue = aDecoder.decodeObject(forKey: "attribute_value") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        settingsMasterId = aDecoder.decodeObject(forKey: "settings_master_id") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if attributeName != nil{
            aCoder.encode(attributeName, forKey: "attribute_name")
        }
        if attributeValue != nil{
            aCoder.encode(attributeValue, forKey: "attribute_value")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if settingsMasterId != nil{
            aCoder.encode(settingsMasterId, forKey: "settings_master_id")
        }
        
    }
    
    func isHidden(setting: UserSettingFlag, completion: @escaping ((Bool) -> Void)) {
        func update(){
            if let dic = UserModel.shared.settings {
                for item in dic {
                    if let userSettings = UserSettingFlag.init(rawValue: item.attributeName) {
                        if userSettings == setting {
                            completion(item.attributeValue == "N" ? true : false)
                        }
                    }
                }
            }
        }
        
        switch setting {
        case .hide_engage_page:
            if isUseFirebaseFlag {
                RemoteConfigManager.shared.setNewValues { _ in
                    completion(hide_engage_page)
                }
            }
            else {
                update()
                GlobalAPI.shared.getPatientDetailsAPI { [weak self] isDone in
                    guard let _ = self else {return}
                    update()
                }
            }
            break
        case .chat_bot:
            if isUseFirebaseFlag {
                RemoteConfigManager.shared.setNewValues { [weak self] _ in
                    guard let _ = self else {return}
                    completion(hide_chatbot)
                }
            }
            else {
                update()
                GlobalAPI.shared.getPatientDetailsAPI { [weak self] isDone in
                    guard let _ = self else {return}
                    
                    update()
                }
            }
            
            break
        case .language_page:
            if isUseFirebaseFlag {
                RemoteConfigManager.shared.setNewValues { [weak self] _ in
                    guard let _ = self else {return}
                    completion(hide_language_page)
                }
            }
            else {
                GlobalAPI.shared.get_no_login_setting_flagsAPI { [weak self] isDone in
                    guard let _ = self else {return}
                    
                    completion(UserDefaultsConfig.language_page == "N" ? true : false)
                }
            }
            break
        case .hide_leave_query:
            RemoteConfigManager.shared.setNewValues { [weak self] _ in
                guard let _ = self else {return}
                completion(hide_leave_query)
            }
            break
        case .hide_email_at:
            RemoteConfigManager.shared.setNewValues { [weak self] _ in
                guard let _ = self else {return}
                completion(hide_email_at)
            }
            break
        case .hide_ask_an_expert_page:
            RemoteConfigManager.shared.setNewValues { [weak self] _ in
                guard let _ = self else {return}
                completion(hide_ask_an_expert_page)
            }
            break
        case .hide_doctor_says:
            RemoteConfigManager.shared.setNewValues { [weak self] _ in
                guard let _ = self else {return}
                completion(hide_doctor_says)
            }
            break
        case .hide_diagnostic_test:
            RemoteConfigManager.shared.setNewValues { [weak self] _ in
                guard let _ = self else {return}
                completion(hide_diagnostic_test)
            }
            break
        case .hide_engage_discover_comments:
            RemoteConfigManager.shared.setNewValues { [weak self] _ in
                guard let _ = self else {return}
                completion(hide_engage_discover_comments)
            }
            break
        case .hide_incident_survey:
            RemoteConfigManager.shared.setNewValues { [weak self] _ in
                guard let _ = self else {return}
                completion(hide_incident_survey)
            }
            break
        case .hide_home_chat_bubble:
            RemoteConfigManager.shared.setNewValues { [weak self] _ in
                guard let _ = self else {return}
                completion(hide_home_chat_bubble)
            }
            break
        case .hide_home_chat_bubble_hc:
            RemoteConfigManager.shared.setNewValues { [weak self] _ in
                guard let _ = self else {return}
                completion(hide_home_chat_bubble_hc)
            }
            break
        case .hide_home_bca:
            RemoteConfigManager.shared.setNewValues { [weak self] _ in
                guard let self = self else { return }
                completion(hide_home_bca)
            }
            break
        case .hide_home_my_device:
            RemoteConfigManager.shared.setNewValues { [weak self] _ in
                guard let self = self else { return }
                completion(hide_home_my_device)
            }
            break
        case .is_bcp_with_in_app:
            RemoteConfigManager.shared.setNewValues { [weak self] _ in
                guard let self = self else { return }
                completion(is_bcp_with_in_app)
            }
            break
        case .hide_home_spirometer:
            RemoteConfigManager.shared.setNewValues {  _ in
                completion(hide_home_spirometer)
            }
            break
            
        case .hide_discount_on_plan:
            RemoteConfigManager.shared.setNewValues {  _ in
                completion(is_hide_discount_on_plan)
            }
            break
            
        case .hide_discount_on_labtest:
            RemoteConfigManager.shared.setNewValues {  _ in
                completion(is_hide_discount_on_labtest)
            }
            break
            
        case .home_from_react_native:
            RemoteConfigManager.shared.setNewValues {  _ in
                completion(is_home_from_react_native)
            }
            break
            
        }
    }
}
