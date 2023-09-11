//
//  HealthKitManager.swift
//  MyTatva
//
//  Created by Darshan Joshi on 14/10/21.
//

import Foundation

@_exported import HealthKit
import WatchConnectivity
import UserNotifications

/*
 =====================================================
 Health kit data
 Fetched data

 ReadingType

     •   SPO2
     •   PEF
     •   BloodPressure
     •   HeartRate
     •   BodyWeight
     •   BMI
     •   BloodGlucose
     •   FEV1Lung

 GoalType
     
     •   Calories
     •   Steps
     •   Exercise
     •   Sleep
     •   Water
     
   
 Pending/
 Unable to fetch

 ReadingType

     •   HbA1c (unable)
     •   ACR (unable)
     •   eGFR (unable)

 GoalType

     •   Medication
     •   Pranayam (unable)
 */
enum HKPermission {
    case Granted, NoneGranted, NotAvailable
}

enum HealthkitSetupError: Error {
  case notAvailableOnDevice
  case dataTypeNotAvailable
  case authorizationFailed
}

let kNoHealthKitMsg = "Can't request access to HealthKit when it's not supported on the device."
let kHealthKitAllowedMsg = "Access to HealthKit data has been granted"
let kHealthKitErrorMsg = "Error requesting HealthKit authorization"

class BloodPressureData {
    
    var systolicBP: String = ""
    var diastolicBP: String = ""
    var dateTime = ""
}

class HealthKitManager : NSObject {
    
    ///Shared instance
    static let shared : HealthKitManager = HealthKitManager()
    private let healthStore = HKHealthStore()
    var isWatchAailable = false
    
    func checkHealthKitSupport(completion: ((Bool) -> Void)?){
        if !HKHealthStore.isHealthDataAvailable() {
            debugPrint("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦")
            debugPrint(kNoHealthKitMsg)
            //Alert.shared.showSnackBar(kNoHealthKitMsg)
            completion?(false)
        }
        else {
            completion?(true)
        }
    }
    
    func checkHealthKitPermission(completion: ((Bool) -> Void)?){
        
        self.checkHealthKitSupport { (isAvailable) in
            if !isAvailable {
                completion?(false)
                return
            }
        }
        
        let readDataTypes   = dataTypesToReadWrite().read
    
        ///To help protect the user’s privacy, your app doesn’t know whether the user granted or denied permission to read data from HealthKit.
        ///Check for write permission
        var returnValue = true
        if readDataTypes != nil {
            for index in readDataTypes!.indices {
                let object = readDataTypes![index]
                
                if object != HKObjectType.quantityType(forIdentifier: .appleExerciseTime) {
                    if (self.healthStore.authorizationStatus(for: object) == .sharingAuthorized){
                        print("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦 Permission Granted to \(object)")
                        //self.setUpBackgroundDeliveryForDataTypes(types: readDataTypes!)
                        returnValue = true
                        
                    }else if (self.healthStore.authorizationStatus(for: object) == .notDetermined){
                        returnValue = false
                        break
                    }
                    else {
                        print("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦 Permission Denied to \(object)")
                        returnValue = false
                        break
                    }
                }
            }
        }
        else {
            print("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦 Permission Denied to")
            returnValue = false
        }
        completion?(returnValue)
    }
    
    func openUrl(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func requestAccessWithCompletion(completion: @escaping (Bool, Error?) -> Void) {
        
        self.checkHealthKitSupport { (isAvailable) in
            if !isAvailable {
                completion(false, nil)
                return
            }
        }
        
        let readDataTypes   = dataTypesToReadWrite().read
        let writeDataTypes  = dataTypesToReadWrite().write
        
        self.healthStore.requestAuthorization(toShare: writeDataTypes, read: readDataTypes) { (userWasShownPermissionView, error) in
            
            // Determine if the user saw the permission view
            if userWasShownPermissionView {
                print("User was shown permission view")
                
                self.checkHealthKitPermission { (isAllow) in
                    if isAllow {
                        completion(true, nil)
                    }
                    else {
                        print("Data write permission not allowed")
                        completion(false, nil)
                    }
                }
                
            } else {
                completion(false, error)
                print("User was not shown permission view")
                
                // An error occurred
                if let e = error {
                    print(e)
                }
            }
        }
    }
    
    /// Types of data that this app wishes to read and write from HealthKit.
    ///
    /// - returns: A set of HKObjectType.
    private func dataTypesToReadWrite() -> (read: Set<HKObjectType>?, write: Set<HKSampleType>?) {
        
        //guard let distanceWalkingRunningType = HKQuantityType.quantityType(forIdentifier:.distanceWalkingRunning),
              
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              
               // let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime),
              
                let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
              
                let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater),
              
                //let caloriesType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned),
              
                let oxygen = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation),
              
                let pef = HKQuantityType.quantityType(forIdentifier: .peakExpiratoryFlowRate),
              
                let fev1 = HKQuantityType.quantityType(forIdentifier: .forcedExpiratoryVolume1),
              
                let bloodPressureDiastolic = HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic),
              
                let bloodPressureSystolic = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic),
              
                let heartrate = HKQuantityType.quantityType(forIdentifier: .restingHeartRate),
              
                let bodyWeight = HKQuantityType.quantityType(forIdentifier: .bodyMass),
              
//                let bodyHeight = HKQuantityType.quantityType(forIdentifier: .height),
              
                let bmi = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex),
              
                let bloodGlucose = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)
                
                //let sixMinuteWalkTestDistance = HKQuantityType.quantityType(forIdentifier: .sixMinuteWalkTestDistance)
                // Clinical types are read-only.
                //let medicationsType = HKObjectType.clinicalType(forIdentifier: .medicationRecord)
        else {
            return (read: nil, write: nil)
        }
        
        let read = Set(arrayLiteral: stepsType,
                       sleepType,
                       waterType,
                       oxygen,
                       pef,
                       fev1,
                       bloodPressureDiastolic,
                       bloodPressureSystolic,
                       heartrate,
                       bodyWeight,
                       bmi,
                       bloodGlucose) as Set<HKObjectType>
        
        //Not allowed to write- exerciseType, medicationRecord
        let write = Set(arrayLiteral: stepsType,
                   sleepType,
                   waterType,
                   oxygen,
                   pef,
                   fev1,
                   bloodPressureDiastolic,
                   bloodPressureSystolic,
                   heartrate,
                   bodyWeight,
                   bmi,
                   bloodGlucose) as Set<HKSampleType>
        
        return (read: read, write: write)
    }
    
}

// MARK: - Private
private extension HealthKitManager {
    /// Initiates an `HKAnchoredObjectQuery` for each type of data that the app reads and stores
    /// the result as well as the new anchor.
    func readHealthKitData() {
        // Authorization Successful
        //Fetch All Data
        var today = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        var dateArray = [String]()
        for _ in 1...7{
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
            let date = DateFormatter()
            date.dateFormat = DateTimeFormaterEnum.yyyymmdd.rawValue
            let stringDate : String = date.string(from: today)
            today = tomorrow!
            dateArray.append(stringDate)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            
            let dispatchGroup: DispatchGroup = DispatchGroup()
            
            for (idx, item) in dateArray.enumerated() {
                dispatchGroup.enter()
//                print("Step : \(item)")
//                self.fetchAllDetailForSteps(dayFromToday: 6 - idx) { (success, arr) in
//                    if success {
//                        dispatchGroup.leave()
//                    }
//                }
            }
            
            dispatchGroup.notify(queue: .main) {
                print("All tasks done")
                //var healthDataArr : [HealthDataModel] = [HealthDataModel]()
                
                for (idx, item) in dateArray.enumerated() {
                    
                }
                // print(healthDataArr)
                
                //                if AppDelegate.shared.oneTimeCall {
                //                    AppDelegate.shared.oneTimeCall = false
                //                    GlobalAPI.shared.APICallSetActivityScore(data: healthDataArr) { (success) in
                //                        ANLoader.hide()
                //                        if success {
                //                            print("⚛️ Health data send to server successfully ⚛️")
                //                        }
                //                    }
                //                }
            }
            
        }
    }
    
    func getIndex(of key: String, for value: String, in dictionary : [[String: String]]) -> Int{
        var count = 0
        for dictElement in dictionary{
            if dictElement.keys.contains(key) && dictElement[key]! == value{
                return count
            }
            else{
                count = count + 1
            }
        }
        return -1
    }
    
    /// Sets up the observer queries for background health data delivery.
    ///
    /// - parameter types: Set of `HKObjectType` to observe changes to.
    private func setUpBackgroundDeliveryForDataTypes(types: Set<HKObjectType>) {
        for type in types {
            guard let sampleType = type as? HKSampleType else { print("ERROR: \(type) is not an HKSampleType"); continue }
            let predicate = NSPredicate(format: "metadata.%K != YES", HKMetadataKeyWasUserEntered)
            
            let query = HKObserverQuery(sampleType: sampleType, predicate: predicate) { [weak self] (query, completionHandler, error) in
                
                debugPrint("observer query update handler called for type \(type), error: \(String(describing: error))")
                
                //guard let strongSelf = self else { return }
                
                debugPrint("Unhandled HKObjectType: \(type)")
                completionHandler()
            }
            healthStore.execute(query)
            healthStore.enableBackgroundDelivery(for: type, frequency: .hourly) { (success, error) in
                debugPrint("enableBackgroundDeliveryForType handler called for \(type) - success: \(success), error: \(String(describing: error))")
                // fecth data from health kit & send data to server on background
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    //self.readHealthKitData()
//                    GlobalAPI.shared.update_goal_and_reading_from_healthkitAPI { (isDone) in
//                        if isDone {
//
//                        }
//                    }
                }
            }
        }
    }
}

// MARK:----------- Read Healthkit data -----------
extension HealthKitManager{
    
    func fetchAllRecords(dayFromToday:Int,
                         sampleIdentifier : [HKQuantityTypeIdentifier],
                         completion : @escaping ((goal_data : [[String: Any]],
                                                  reading_data : [[String: Any]])? ,                    String?) -> Void){
        
        var goalResult : [[String: Any]]    = []
        var readingResult : [[String: Any]] = []
        var countQuantityType               = 0
        
        self.fetchAllQuantityTypeRecord(dayFromToday: dayFromToday, sampleIdentifier: sampleIdentifier){ result , error in
            
            countQuantityType = countQuantityType + 1
            
            if let error = error{
                print(error)
            }
            
            if let result = result{
                goalResult.append(result.goal_data)
                readingResult.append(result.reading_data)
                
            }
            
            if countQuantityType >= sampleIdentifier.count {
                
                var countCategoryType               = 0
                
                self.fetchAllCategoryTypeRecord(sampleIdentifier: [.sleepAnalysis],  dayFromToday: dayFromToday){ result, error in
                    
                    countCategoryType += 1
                    
                    if let error = error{
                        print(error)
                        completion(nil,error)
                    }
                    
                    if let result = result{
                        goalResult.append(result)
                    }
                    
                    self.fetchAllDetailForSteps(dayFromToday: dayFromToday) { (success, arr) in
                        if success {
                            goalResult.append(arr)
                        }
                        completion((goal_data : goalResult, reading_data: readingResult) , nil)
                    }
                    
                   
                    return
                  //  self.fetchClinicalTypeRecord(sampleId: .medicationRecord, dayFromToday: 1900)
                }
            }
        }
    }
    
    ///get all Quantity type of records
    func fetchAllQuantityTypeRecord(dayFromToday:Int ,
                                    sampleIdentifier : [HKQuantityTypeIdentifier],
                                    completion : @escaping ((goal_data : [[String: Any]],
                                                             reading_data : [[String: Any]])?,
                                                            String?) -> Void){
        
        var goalData : [[String: Any]]      = []
        var readingData : [[String: Any]]   = []
//        var arrSystolicBP                   = [String]()
//        var arrDiastolicBP                  = [String]()
        var arrSystolicBP       = [BloodPressureData]()
        var arrDiastolicBP      = [BloodPressureData]()
        
        var sampleIdentifierCount = 0
        //self.lastSevenDaysSteps.removeAll()
        sampleIdentifier.forEach { sampleid in
            
            sampleIdentifierCount += 1
            
            guard let sampleType = HKSampleType.quantityType(forIdentifier: sampleid) else {
                print("Sample Type is no longer available in HealthKit")
                completion(nil,"Sample Type not available")
                return
            }
            
            let endDate     = Date()
            let startDate   = endDate.daysAgo(dayFromToday)
            
            
            //1. Use HKQuery to load the most recent samples.
            //let mostRecentPredica = HKQuery.predicateForObjects(from: HKSource.)
            let mostRecentPredicate = HKQuery.predicateForSamples(withStart: startDate,
                                                                  end: endDate,
                                                                  options: .strictEndDate)
            
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                                  ascending: false)
            
            //let limit = 100000//limit of data to fetch
            
            let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                            predicate: mostRecentPredicate,
                                            limit: HKObjectQueryNoLimit,
                                            sortDescriptors: [sortDescriptor])  { (query, samples, error) in
                
                DispatchQueue.main.async  {
//
//                    guard let samples = samples as? [HKSample] else {
//                        completion(nil,error?.localizedDescription)
//                        return
//                    }
                    var samplesCount = 0
                    
                    guard let samples = samples as? [HKQuantitySample] else {
                        completion(nil,error?.localizedDescription)
                        return
                    }
                    print(sampleid)
                    goalData.removeAll()
                    readingData.removeAll()
                    for sample in samples{
                        let source_name     = sample.sourceRevision.source.name
                        let source_id       = sample.sourceRevision.source.bundleIdentifier
                        print("Name of source       :\(source_name)")
                        print("Name of bundle id    : \(source_id)")
                        
                        samplesCount += 1
                        
                        let date = DateFormatter()
                        date.dateFormat = DateTimeFormaterEnum.UTCFormat.rawValue
                        let stringDate : String = date.string(from: sample.endDate)
                        
                        var goalDict : [String : Any]!
                        var readingDict : [String : Any]!
                        
                        switch sample.quantityType.identifier {
                    
                        ///steps count
                        case HKQuantityTypeIdentifier.stepCount.rawValue:
                            
//                            let startOfDay = Calendar.current.startOfDay(for: sample.startDate)
//
//                            let predicate = HKQuery.predicateForSamples(
//                                withStart: startOfDay,
//                                end: sample.endDate,
//                                options: [.strictEndDate]
//                            )
//
//                            var interval = DateComponents()
//                            interval.day = 1
//
//                            let qry = HKStatisticsCollectionQuery(quantityType: sampleType,
//                                                                    quantitySamplePredicate: predicate,
//                                                                    options: [.cumulativeSum],
//                                                                    anchorDate: sample.endDate, intervalComponents: interval)
//
//                            qry.initialResultsHandler = { query, results, error in
//
//                                if error != nil {
//
//                                    //  Something went Wrong
//                                    return
//                                }
//
//                                if let myResults = results{
//                                    myResults.enumerateStatistics(from: startOfDay, to: sample.endDate) {
//                                        statistics, stop in
//
//                                        if let quantity = statistics.sumQuantity() {
//
//                                            let steps = quantity.doubleValue(for: HKUnit.count())
//
//                                            //let steps = sum.doubleValue(for: HKUnit.count())
//
//                                            goalDict = [
//                                                "goal_key"          : GoalType.Steps.rawValue,
//                                                "achieved_datetime" : stringDate,
//                                                "achieved_value"    : String(format: "%.f", steps),
//                                                "source_name"       : source_name,
//                                                "source_id"         : source_id
//                                                /*,
//                                                 "achieved_unit" : "steps"*/
//                                            ]
//
//                                        }
//                                    }
//                                }
//                            }
//
//                            self.healthStore.execute(qry)
                            
//                                let qry = HKStatisticsQuery(
//                                        quantityType: sampleType,
//                                        quantitySamplePredicate: predicate,
//                                        options: .cumulativeSum
//                                ) { _, response, _ in
//                                    guard let result = response, let sum = result.sumQuantity() else {
//                                        return
//                                    }
//
//                                    let steps = sum.doubleValue(for: HKUnit.count())
//
//                                    goalDict = [
//                                        "goal_key"          : GoalType.Steps.rawValue,
//                                        "achieved_datetime" : stringDate,
//                                        "achieved_value"    : String(format: "%.f", steps),
//                                        "source_name"       : source_name,
//                                        "source_id"         : source_id
//                                        /*,
//                                         "achieved_unit" : "steps"*/
//                                    ]
//                                }
//
//
                            
//                            let steps = sample.quantity.doubleValue(for: HKUnit.count())
//                            goalDict = [
//                                "goal_key"          : GoalType.Steps.rawValue,
//                                "achieved_datetime" : stringDate,
//                                "achieved_value"    : String(format: "%.f", steps),
//                                "source_name"       : source_name,
//                                "source_id"         : source_id
//                                /*,
//                                "achieved_unit" : "steps"*/
//                            ]
                            
                            break
                            
                        /// water count
                        case HKQuantityTypeIdentifier.dietaryWater.rawValue:
                            
                            let water = sample.quantity.doubleValue(for: HKUnit.literUnit(with: .milli))
                            goalDict = [
                                "goal_key"          : GoalType.Water.rawValue,
                                "achieved_datetime" : stringDate,
                                "achieved_value"    : String(format: "%.f", water / Double(kDefaultWaterGlassML)),
                                "source_name"       : source_name,
                                "source_id"         : source_id
                                /*,
                                "achieved_unit" : "glasses"*/
                            ]
                            
                            break
                            
                        ///calories count
//                        case HKQuantityTypeIdentifier.activeEnergyBurned.rawValue:
//
//                            let calories = sample.quantity.doubleValue(for: HKUnit.kilocalorie())
//                            goalDict = [
//                                "goal_key"          : GoalType.Calories.rawValue,
//                                "achieved_datetime" : stringDate,
//                                "achieved_value"    : String(calories),
//                                "source_name"       : source_name,
//                                "source_id"         : source_id
//                                /*,
//                                "achieved_unit" : "kcal"*/
//                            ]
//                            break
                            
                        ///exercise time
                        case HKQuantityTypeIdentifier.appleExerciseTime.rawValue:
                            
                            let exercise = sample.quantity.doubleValue(for: HKUnit.minute())
                            goalDict = [
                                "goal_key"          : GoalType.Exercise.rawValue,
                                "achieved_datetime" : stringDate,
                                "achieved_value"    : String(exercise),
                                "source_name"       : source_name,
                                "source_id"         : source_id
                                /*,
                                "achieved_unit" : "min"*/
                            ]
                            break
                            
                        ///oxygen value
                        case HKQuantityTypeIdentifier.oxygenSaturation.rawValue:
                            
                            let oxygen = sample.quantity.doubleValue(for: HKUnit.percent()) //0.0 to 1.0
                            readingDict = [
                                "reading_key"       : ReadingType.SPO2.rawValue,
                                "reading_datetime"  : stringDate,
                                "reading_value"     : String(oxygen * 100),
                                "source_name"       : source_name,
                                "source_id"         : source_id
                                /*,
                                "reading_unit" : "%"*/
                            ]
                            break
                            
                        ///forcedExpiratoryVolume1
                        case HKQuantityTypeIdentifier.forcedExpiratoryVolume1.rawValue:
                            
                            let fev1 = sample.quantity.doubleValue(for: HKUnit.liter())
                            readingDict = [
                                "reading_key"       : ReadingType.FEV1Lung.rawValue,
                                "reading_datetime"  : stringDate,
                                "reading_value"     : String(fev1),
                                "source_name"       : source_name,
                                "source_id"         : source_id
                                /*,
                                "reading_unit" : "L"*/
                            ]
                            break
                            
                        ///PeakExpiratoryFlowRate
                        case HKQuantityTypeIdentifier.peakExpiratoryFlowRate.rawValue:
                            
                            let pef = sample.quantity.doubleValue(for: HKUnit.liter().unitDivided(by: .minute()))
                            readingDict = [
                                "reading_key"       : ReadingType.PEF.rawValue,
                                "reading_datetime"  : stringDate,
                                "reading_value"     : String(pef),
                                "source_name"       : source_name,
                                "source_id"         : source_id
                                /*,
                                "reading_unit"      : "L/min"*/
                            ]
                            break
                            
                        ///blood pressure
                        case HKQuantityTypeIdentifier.bloodPressureDiastolic.rawValue , HKQuantityTypeIdentifier.bloodPressureSystolic.rawValue:
                            
                            if sample.quantityType.identifier == HKQuantityTypeIdentifier.bloodPressureDiastolic.rawValue{
                                let object = BloodPressureData()
                                object.diastolicBP  = String(sample.quantity.doubleValue(for: HKUnit.millimeterOfMercury()))
                                object.dateTime     = stringDate
                                arrDiastolicBP.append(object)
                               
                            }else{
                                let object = BloodPressureData()
                                object.systolicBP  = String(sample.quantity.doubleValue(for: HKUnit.millimeterOfMercury()))
                                object.dateTime     = stringDate
                                arrSystolicBP.append(object)
                            }
                           
                            if arrDiastolicBP.count ==
                                arrSystolicBP.count {
                                
                                for Systolic in arrSystolicBP {
                                    for Diastolic in arrDiastolicBP {
                                        if Systolic.dateTime == Diastolic.dateTime {
                                            
                                            readingDict = [
                                                "reading_key"       : ReadingType.BloodPressure.rawValue,
                                                "reading_datetime"  : String(Diastolic.dateTime),
                                                "reading_value"     : "",
                                                "reading_value_data":[
                                                    "diastolic"     :String(Diastolic.diastolicBP),
                                                    "systolic"      :String(Systolic.systolicBP)
                                                ],
                                                "source_name"       : source_name,
                                                "source_id"         : source_id
                                                
                                                /*,
                                                "reading_unit" : "mmHg"*/
                                            ]
                                            
                                            if readingDict != nil{
                                                readingData.append(readingDict)
                                                //print(JSON(dict))
                                            }
                                        }
                                    }
                                }
                            }
                            
                            break
                            
                        ///Heart rate
                        case HKQuantityTypeIdentifier.restingHeartRate.rawValue:
                            
                            let heartrate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                            
                            readingDict = [
                                "reading_key"       : ReadingType.HeartRate.rawValue,
                                "reading_datetime"  : stringDate,
                                "reading_value"     : String(heartrate),
                                "source_name"       : source_name,
                                "source_id"         : source_id
                                /*,
                                 "reading_unit"      : "BPM"*/
                            ]
                            break
                            
                        ///bodyWeight
                        case HKQuantityTypeIdentifier.bodyMass.rawValue:
                            
                            let weight      = sample.quantity.doubleValue(for: HKUnit.gram())
                            readingDict     = [
                                "reading_key"       : ReadingType.BodyWeight.rawValue,
                                "reading_datetime"  : stringDate,
                                "reading_value"     : String(format:"%.2f",weight / 1000),
                                "source_name"       : source_name,
                                "source_id"         : source_id
                                /*,
                                "reading_unit" : "Kg"*/
                            ]
                            break
                            
                        ///bmi
                        case HKQuantityTypeIdentifier.bodyMassIndex.rawValue:
                            
                            let bmi     = sample.quantity.doubleValue(for: HKUnit.count())
                            readingDict = [
                                "reading_key"       : ReadingType.BMI.rawValue,
                                "reading_datetime"  : stringDate,
                                "reading_value"     : String(bmi),
                                "source_name"       : source_name,
                                "source_id"         : source_id
                                /*,
                                "reading_unit" : "BMI"*/
                            ]
                            break
                            
                        ///bloodGlucose
                        case HKQuantityTypeIdentifier.bloodGlucose.rawValue:
                            if let mealtime: Int = sample.metadata?[HKMetadataKeyBloodGlucoseMealTime]  as? Int {
                                
                                //let glucose = sample.quantity.doubleValue(for: HKUnit.gram().unitDivided(by: .liter()))
                                
                                let type = HKBloodGlucoseMealTime.init(rawValue: mealtime) ?? .preprandial
                                let glucose = sample.quantity.doubleValue(for: HKUnit(from: "mg/dL"))
                                
                                switch type {
                              
                                case .preprandial:
                                    readingDict = [
                                        "reading_key"           : ReadingType.BloodGlucose.rawValue,
                                        "reading_datetime"      : stringDate,
                                        "reading_value"         : "",
                                        "reading_value_data"    : ["pp" : "",
                                                                   "fast" : String(format:"%0.2f",glucose)],
                                        "source_name"       : source_name,
                                        "source_id"         : source_id
                                        /*,
                                        "reading_unit" : "mg/dL"*/
                                    ]
                                    break
                                case .postprandial:
                                    readingDict = [
                                        "reading_key"           : ReadingType.BloodGlucose.rawValue,
                                        "reading_datetime"      : stringDate,
                                        "reading_value"         : "",
                                        "reading_value_data"    : ["pp" : String(format:"%.2f",glucose),
                                                                   "fast" : ""],
                                        "source_name"       : source_name,
                                        "source_id"         : source_id
                                        /*,
                                        "reading_unit" : "mg/dL"*/
                                    ]
                                    break
                                @unknown default:
                                    readingDict = [
                                        "reading_key"           : ReadingType.BloodGlucose.rawValue,
                                        "reading_datetime"      : stringDate,
                                        "reading_value"         : "",
                                        "reading_value_data"    : ["pp" : String(format:"%.2f",glucose * 100),
                                                                   "fast" : ""],
                                        "source_name"       : source_name,
                                        "source_id"         : source_id
                                        /*,
                                        "reading_unit" : "mg/dL"*/
                                    ]
                                    break
                                }
                                
                            }
                            break
                            
                        default:
                            break
                        }
                        
                        
                        if goalDict != nil{
                            goalData.append(goalDict)
                            //print(JSON(dict))
                        }
                        
                        if readingDict != nil{
                            readingData.append(readingDict)
                            //print(JSON(dict))
                        }
                    }
                    
                    if sampleIdentifierCount >= sampleIdentifier.count {
                        if samplesCount >= samples.count {
                            completion((goal_data : goalData, reading_data : readingData),nil)
                        }
                    }
                   //print("----------",JSON(lastSevenDaysSteps))
                }
                
            }
            self.healthStore.execute(sampleQuery)
        }
    }
    
    ///get all Category type of records - Mainly sleep
    func fetchAllCategoryTypeRecord(sampleIdentifier : [HKCategoryTypeIdentifier] ,
                                    dayFromToday : Int,
                                    completion : @escaping ([[String: Any]]?,String?) -> Void){
        
        var arrSleep : [[String: Any]] = []
        var mainDic : [String : Any] = [:]
        
        var sampleIdentifierCount = 0
        sampleIdentifier.forEach { sampleid in
            
            sampleIdentifierCount += 1
            
            guard let sampleType = HKObjectType.categoryType(forIdentifier: sampleid) else {
                print("\(sampleid) Sample Type is no longer available in HealthKit")
                completion(nil ,"\(sampleid) Type is no longer available" )
                return
            }
            
            let tempStartOfDay  = Calendar.current.startOfDay(for: Date())
            let endDate         = Calendar.current.date(byAdding: DateComponents(day: 1), to: tempStartOfDay)!
            //let endDate     = Date()
            let startDate   = endDate.daysAgo(dayFromToday)
            
            //1. Use HKQuery to load the most recent samples.
            let mostRecentPredicate = HKQuery.predicateForSamples(withStart: startDate,
                                                                  end: endDate,
                                                                  options: .strictStartDate)
            
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                                  ascending: false)
            //let limit = 100000000000//limit of data to fetch
            
            
            let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                            predicate: mostRecentPredicate,
                                            limit: HKObjectQueryNoLimit,
                                            sortDescriptors: [sortDescriptor])  { (query, samples, error) in
                
                guard let samples = samples as? [HKCategorySample] else {
                    
                    if let error = error {
                        print(error)
                        completion(nil ,error.localizedDescription )
                    }
                    return
                }
                
                arrSleep.removeAll()
                for sample in samples{
                    let source_name     = sample.sourceRevision.source.name
                    let source_id       = sample.sourceRevision.source.bundleIdentifier
                    print("Name of source       :\(source_name)")
                    print("Name of bundle id    : \(source_id)")
                    
                    let dateFormatter           = DateFormatter()
                    dateFormatter.dateFormat    = DateTimeFormaterEnum.UTCFormat.rawValue
                    dateFormatter.timeZone      = .current
                    let stringDate : String     = dateFormatter.string(from: sample.endDate)
                    var dict : [String : String] = [:]
                    
                    switch sample.categoryType.identifier {
                    case HKCategoryTypeIdentifier.sleepAnalysis.rawValue:
                        
                        dateFormatter.dateFormat    = DateTimeFormaterEnum.UTCFormat.rawValue
                        let startTime : String      = dateFormatter.string(from: sample.startDate)
                        let endTime : String        = dateFormatter.string(from: sample.endDate)
                        
                        //let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                        dict = [
                            "goal_key"          : GoalType.Sleep.rawValue,
                            "achieved_datetime" : stringDate,
                            "achieved_value"    : String(sample.endDate.minutes(from: sample.startDate).minutesToHoursAndMinutes().hours) + "." + String(sample.endDate.minutes(from: sample.startDate).minutesToHoursAndMinutes().leftMinutes),
                            "source_name"       : source_name,
                            "source_id"         : source_id,
                            "start_time"        : startTime,
                            "end_time"          : endTime
                            
                            /*,
                             "achieved_unit" : "hr"*/
                        ]
                        
                        
                    default:
                        break
                    }
                    
                    arrSleep.append(dict)
                    //print(JSON(dict))
                    
                }
                
                if sampleIdentifierCount >= sampleIdentifier.count {
                    mainDic["goal_value"] = arrSleep
                    completion(arrSleep,nil)
                }
            }
            self.healthStore.execute(sampleQuery)
        }
    }
    
    ///get all Steps of records
    private func fetchAllDetailForSteps(dayFromToday:Int,
                                        completion: @escaping (Bool, [[String: Any]]) -> Void) {
        
        var arrSteps : [[String: Any]] = []
        //self.lastSevenDaysSteps.removeAll()
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now         = Date()
        var interval    = DateComponents()
        interval.day    = 1
        var arrCount    = [Int]()
        
        for i in 0...dayFromToday - 1 {
            let day = Calendar.current.date(byAdding: DateComponents(day: -i), to: now)!
            
            //let startDate   = endDate.daysAgo(1)
            let startOfDay  = Calendar.current.startOfDay(for: day)
            let endDate     = Calendar.current.date(byAdding: DateComponents(day: 1), to: startOfDay)!
//            let date        = DateFormatter()
//            date.dateFormat = DateTimeFormaterEnum.UTCFormat.rawValue
//            let stringDate : String = date.string(from: startOfDay)
            
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay,
                                                        end: endDate,
                                                        options: .strictStartDate)
            
            let query = HKStatisticsCollectionQuery(quantityType: stepsQuantityType,
                                                    quantitySamplePredicate: predicate,
                                                    options: [.cumulativeSum],
                                                    anchorDate: startOfDay,
                                                    intervalComponents: interval)
            
            
            query.initialResultsHandler = { query, result, error in
                
                if (error != nil) {
                    debugPrint("No steps: \(error.debugDescription)")
                }else {
                    result?.enumerateStatistics(from: startOfDay, to: endDate, with: { (statistics, _) in
                        
                        func completition(){
                            if arrCount.count == dayFromToday * 2 {
                                completion(true, arrSteps)
                            }
                        }
                        
                        arrCount.append(1)
                        if let sum = statistics.sumQuantity() {
                            // Get steps (they are of double type)
                            let steps = sum.doubleValue(for: HKUnit.count())
                            
                            let startOfDayt  = Calendar.current.startOfDay(for: statistics.startDate)
                            let date        = DateFormatter()
                            date.dateFormat = DateTimeFormaterEnum.UTCFormat.rawValue
                            let stringDate : String = date.string(from: startOfDayt)
                            
//                            DispatchQueue.main.async {
                                
                                let step = String(format: "%.f", steps)
                                
                                let goalDict: [String: Any] = [
                                    "goal_key"          : GoalType.Steps.rawValue,
                                    "achieved_datetime" : stringDate,
                                    "achieved_value"    : String(format: "%.f",Double(step) ?? 0),
                                    "source_name"       : statistics.sources?.first?.name ?? "",
                                    "source_id"         : statistics.sources?.first?.bundleIdentifier ?? ""
                                    /*,
                                     "achieved_unit" : "steps"*/
                                ]
                                arrSteps.append(goalDict)
//                            }
                        }
                        completition()
                    })
                }
            }
            self.healthStore.execute(query)
        }
    }
    
    ///get all Quantity type of records
    func fetchDistanceWalkingRunningRecord(startDate: Date,
                                    completion: @escaping (Double?) -> Void) {
        
        //var distanceData : Double = 0
        //var sampleIdentifierCount       = 0
        
        guard let type = HKSampleType.quantityType(forIdentifier: .sixMinuteWalkTestDistance) else {
            fatalError("Something went wrong retriebing quantity type distanceWalkingRunning")
        }
//        let date =  Date()
//        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
//        let newDate = cal.startOfDay(for: startDate)

        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.mostRecent]) { (query, statistics, error) in
            var value: Double = 0

            DispatchQueue.main.async {
                //Alert.shared.showAlert(message: "statistics: \(statistics), error: \(error)", completion: nil)
            }
            
            if error != nil {
                print("something went wrong")
            } else if let quantity = statistics?.sumQuantity() {
                value = quantity.doubleValue(for: HKUnit.meter())
            }
            DispatchQueue.main.async {
                print("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦 distanceWalkingRunning: \(value)")
                completion(value)
            }
        }
        healthStore.execute(query)
        
        completion(nil)
    }
    
    
    
    ///get clinical type data
//    func fetchClinicalTypeRecord(sampleId : HKClinicalTypeIdentifier , dayFromToday : Int){
//        guard let sampleType = HKSampleType.clinicalType(forIdentifier: sampleId) else {
//            print("Sample Type is no longer available in HealthKit")
//            return
//        }
//
//        let endDate     = Date()
//        let startDate   = endDate.daysAgo(dayFromToday)
//
//
//        //1. Use HKQuery to load the most recent samples.
//        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: startDate,
//                                                              end: endDate,
//                                                              options: .strictEndDate)
//
//        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
//                                              ascending: false)
//
//        //let limit = 100000000000//limit of data to fetch
//
//
//        let sampleQuery = HKSampleQuery(sampleType: sampleType,
//                                        predicate: mostRecentPredicate,
//                                        limit: HKObjectQueryNoLimit,
//                                        sortDescriptors: [sortDescriptor])  { (query, samples, error) in
//
//            DispatchQueue.main.async  {
//
////                guard let samples = samples as? [HKSample] else {
////                    return
////                }
//
//                guard let samples = samples as? [HKClinicalRecord] else {
//
//                    if let error = error {
//                        print(error)
//                    }
//
//                    return
//                }
//                for sample in samples{
//                    do {
//                        if let data = sample.fhirResource?.data{
//
//                            print(JSON(data))
////                            {
////                              "status" : "active",
////                              "resourceType" : "MedicationOrder",
////                              "id" : "24",
////                              "dateWritten" : "1985-10-11",
////                              "patient" : {
////                                "reference" : "Patient\/1",
////                                "display" : "Candace Salinas"
////                              },
////                              "dosageInstruction" : [
////                                {
////                                  "text" : "2 puffs every 2-4 hours"
////                                }
////                              ],
////                              "medicationCodeableConcept" : {
////                                "coding" : [
////                                  {
////                                    "code" : "329498",
////                                    "system" : "http:\/\/www.nlm.nih.gov\/research\/umls\/rxnorm\/"
////                                  }
////                                ],
////                                "text" : "Albuterol HFA 90 mcg"
////                              },
////                              "note" : "Please let me know if you need to use this more than three times per day",
////                              "prescriber" : {
////                                "reference" : "Practitioner\/20",
////                                "display" : "Daren Estrada"
////                              }
////                            }
//                        }
//
//                    }catch{
//                        print("\(error.localizedDescription)")
//                    }
//
//                }
//
//
//            }
//        }
//        self.healthStore.execute(sampleQuery)
//    }
    
}
// MARK:🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
// MARK:----------- Write Healthkit data -----------
extension HealthKitManager{

    func addLogToHealthKit(identifier: HKQuantityTypeIdentifier,
                           reading : Double,
                           unit: HKUnit,
                           dateTime: Date,
                           glucoseType: HKBloodGlucoseMealTime? = nil) {
        // 1
        let quantityType = HKQuantityType.quantityType(forIdentifier: identifier)
        
        // string value represents US fluid
        // 2
        let quanitytUnit      = unit
        let quantityAmount    = HKQuantity(unit: quanitytUnit, doubleValue: reading)
        //let now = Date()
        // 3
        var sample = HKQuantitySample(type: quantityType!, quantity: quantityAmount, start: dateTime, end: dateTime)
        var correlationType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.food)
        
        if identifier == .bloodGlucose {
            if let type = glucoseType {
                switch type {
                case .preprandial:
                    
                    //let fastTime = Calendar.current.date(byAdding: .hour, value: -1, to: dateTime) ?? Date()
                    sample = HKQuantitySample(type: quantityType!,
                                              quantity: quantityAmount,
                                              start: dateTime,
                                              end: dateTime,
                                              metadata: [HKMetadataKeyBloodGlucoseMealTime: 1])
                    break
                case .postprandial:
                    sample = HKQuantitySample(type: quantityType!,
                                              quantity: quantityAmount,
                                              start: dateTime,
                                              end: dateTime,
                                              metadata: [HKMetadataKeyBloodGlucoseMealTime: 2])
                    break
                @unknown default:
                    break
                }
            }
        }
        else if identifier == .bloodPressureSystolic ||
                    identifier == .bloodPressureDiastolic {
            
            correlationType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure)
        }
        
        // 4
        let waterCorrelationForWaterAmount = HKCorrelation(type: correlationType!, start: dateTime, end: dateTime, objects: [sample])
        
        self.healthStore.save(waterCorrelationForWaterAmount, withCompletion: { (success, error) in
            if (error != nil) {
                print("error occurred saving water data")
            }
            else {
                print("🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧 \(identifier) LOGGED TO HEALTHKIT")
            }
        })
    }
    
    func addSleepToHealthKit(_ sleepAnalysis: HKCategoryValueSleepAnalysis,
                             startDate: Date,
                             endDate: Date) {
            
        let healthStore = HKHealthStore()
        
        // again, we define the object type we want
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return
        }
        
        // we create our new object we want to push in Health app
        let sample = HKCategorySample(type: sleepType, value: sleepAnalysis.rawValue, start: startDate, end: endDate)
        
        // at the end, we save it
        healthStore.save(sample) { (success, error) in
            guard success && error == nil else {
                // handle error
                return
            }
            
            // success!
            print("🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧🟧 \(sleepAnalysis) LOGGED TO HEALTHKIT")
        }
    }
}
