//
//  ExerciseRoutineVM.swift
//  MyTatva
//
//  Created by Hlink on 12/04/23.
//

import Foundation
class ExerciseRoutineVM {
    //MARK: - Class Variables
    
    var arrRoutines = [ExerciseDetailModel]()
    var arrExersice = [ExerciseDataModel]()
    
    private(set) var isRoutineChanged = Bindable<Bool>()
    
    //MARK: - init
    init() {
        
    }
    
    //---------------------------------------------------------
    //MARK:- Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
}

//------------------------------------------------------
//MARK: - CallMethods
extension ExerciseRoutineVM {
    
    func numberOfRows() -> Int { self.arrRoutines.count }
    
    func listOfRow(_ index: Int) -> ExerciseDetailModel { self.arrRoutines[index] }
    
    func numberOfSectionInExercise() -> Int { self.arrExersice.count }
    
    func listOfSectionInExercise(_ section: Int) -> ExerciseDataModel { self.arrExersice[section] }
    
    func numberOfRowsInExercise(_ section: Int) -> Int { self.arrExersice[section].exerciseDetails.count }
        
    func listOfRowsInExercise(_ indexPath: IndexPath) -> ExerciseDetailModel { self.arrExersice[indexPath.section].exerciseDetails[indexPath.row] }
    
}

//------------------------------------------------------
//MARK: - WebMethods
extension ExerciseRoutineVM {
    
    func getRoutines(_ isExercise:Bool = false, planDate:Date?=nil,restDayCompletion:((Bool) -> ())? = nil) {
        GlobalAPI.shared.getRoutines(planDate: planDate) { [weak self] (message,data,statusCode) in
            guard let self = self else { return }
            switch statusCode {
            case .success:
                
                guard let data = data else { return }
                debugPrint(data)
                
                let isRestDay = data["is_rest_day"].boolValue
                
                self.arrRoutines = []
                self.arrExersice = []
                
                if !isRestDay || isExercise {
                    self.arrExersice = data["exercise_details"].arrayValue.map({ ExerciseDataModel(fromJson: $0) })
                }
                
                self.isRoutineChanged.value = !isRestDay
                
                restDayCompletion?(isRestDay)
                
                break
            case .emptyData:
                self.isRoutineChanged.value = false
                restDayCompletion?(true)
                break
            default: break
            }
        }
    }
    
    func markDoneRoutine(_ indexPath: IndexPath,time: Date? = nil,completion:((Bool,JSON) -> Void)? = nil) {
        self.markDoneRoutine(obj: self.arrExersice[indexPath.section].exerciseDetails[indexPath.row],time: time) { [weak self] (isDone,data) in
            guard let self = self,isDone else { return }
            self.arrExersice[indexPath.section].exerciseDetails[indexPath.row].isDone = !self.arrExersice[indexPath.section].exerciseDetails[indexPath.row].isDone
            self.isRoutineChanged.value = true
            completion?(true,data)
        }
    }
    
    func markDoneRoutine(_ index: Int,time: Date? = nil,completion:((Bool) -> Void)? = nil) {
        
        self.markDoneRoutine(obj: self.arrRoutines[index],time: time) { [weak self] (isDone,data) in
            guard let self = self, isDone else { return }
            self.arrRoutines[index].isDone = !self.arrRoutines[index].isDone
            self.arrRoutines[index].difficultyLevel = self.arrRoutines[index].isDone ? self.arrRoutines[index].difficultyLevel : ""
            self.isRoutineChanged.value = true
            
            completion?(true)
        }
        
        /*let formatter = DateFormatter()
        formatter.dateFormat = DateTimeFormaterEnum.HHmmss.rawValue
                
        let param: [String:String] = [
            "patient_exercise_plans_list_rel_id" : self.arrRoutines[index].patientExercisePlansListRelId,
            "done" : self.arrRoutines[index].isDone ? "N" : "Y",
            "reading_time" : formatter.string(from: Date())
        ]
        
        ApiManager.shared.makeRequest(method: .content(.exercise_plan_mark_as_done), parameter: param) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.success(let apiResponse):
                
                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    self.arrRoutines[index].isDone = !self.arrRoutines[index].isDone
                    self.isRoutineChanged.value = true
                    
                    completion?(true)
                    
                default:
                    Alert.shared.showSnackBar(apiResponse.message)
                }
                
                print(apiResponse.data)
            case .failure(_):
                debugPrint("Error")
            }
        }*/
    }
 
    private func markDoneRoutine(obj: ExerciseDetailModel,time:Date? = nil,completion:((Bool,JSON) -> ())? = nil) {
        let formatter = DateFormatter()
        formatter.dateFormat = DateTimeFormaterEnum.HHmmss.rawValue
                
        let param: [String:String] = [
            "patient_exercise_plans_list_rel_id" : obj.patientExercisePlansListRelId,
            "done" : obj.isDone ? "N" : "Y",
            "reading_time" : formatter.string(from: time ?? Date())
        ]
        
        ApiManager.shared.makeRequest(method: .content(.exercise_plan_mark_as_done), parameter: param) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.success(let apiResponse):
                
                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    completion?(true,apiResponse.data)
                    
                default:
                    Alert.shared.showSnackBar(apiResponse.message)
                }
                
                print(apiResponse.data)
            case .failure(_):
                debugPrint("Error")
            }
        }
    }
    
    func addDifficulty(index: Int? = nil, indexPath: IndexPath? = nil , difficulty: String) {
        
        let obj = index == nil ? self.arrExersice[indexPath?.section ?? 0 ].exerciseDetails[indexPath?.row ?? 0] : self.arrRoutines[index ?? 0]
        
        let param: [String:String] = [
            "patient_exercise_plans_list_rel_id" : obj.patientExercisePlansListRelId,
            "difficulty": difficulty
        ]
        
        ApiManager.shared.makeRequest(method: .content(.exercise_plan_update_difficulty), parameter: param) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.success(let apiResponse):
                
                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    
                    if index == nil {
                        self.arrExersice[indexPath?.section ?? 0].exerciseDetails[indexPath?.row ?? 0].difficultyLevel = difficulty
                    }else {
                        self.arrRoutines[index ?? 0].difficultyLevel = difficulty
                    }
                    
                    self.isRoutineChanged.value = true
                    
                default:
                    Alert.shared.showSnackBar(apiResponse.message)
                }
                
                print(apiResponse.data)
            case .failure(_):
                debugPrint("Error")
            }
        }
        
    }
    
}
