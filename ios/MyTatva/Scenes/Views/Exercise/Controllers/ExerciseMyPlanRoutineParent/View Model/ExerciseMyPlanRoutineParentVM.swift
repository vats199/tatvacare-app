//
//  ExerciseMyPlanRoutineParentVM.swift
//  MyTatva
//
//  Created by Hlink on 11/04/23.
//

import Foundation
class ExerciseMyPlanRoutineParentVM {
    
    private var arrRoutines = [ExerciseDataModel]()
    
    private(set) var isRoutineChange = Bindable<Bool>()
    
    private(set) var planDetails = Bindable<Result<JSON?, AppError>>()
    
}

//------------------------------------------------------
//MARK: - CallMethods
extension ExerciseMyPlanRoutineParentVM {
    func numberOfRoutines() -> Int { self.arrRoutines.count }
    func listOfRoutine(_ index: Int) -> ExerciseDataModel { self.arrRoutines[index] }
    func didSelectect(_ index: Int) {
        self.arrRoutines.forEach({$0.isSelected = false})
        self.arrRoutines[index].isSelected = true
        self.isRoutineChange.value = true
    }
    func getSelectedIndex() -> Int {
        return self.arrRoutines.firstIndex(where: {$0.isSelected}) ?? 0
    }
}

//------------------------------------------------------
//MARK: - WebMethods
extension ExerciseMyPlanRoutineParentVM {
    func getRoutines(selectedIndex:Int = 0,planDate:Date?=nil,restDayCompletion:((Bool) -> ())? = nil) {
        
        GlobalAPI.shared.getRoutines(planDate: planDate) { [weak self] (message,data,statusCode) in
            guard let self = self else { return }
            
            switch statusCode {
            case .success:
                
                guard let data = data else { return }
                debugPrint(data)
                
                let isRestDay = data["is_rest_day"].boolValue
                
                self.planDetails.value = .success(data["plan_details"])
                
                self.arrRoutines = []
                if !isRestDay {
                    self.arrRoutines = data["exercise_details"].arrayValue.map({ ExerciseDataModel(fromJson: $0) })
                    self.arrRoutines[selectedIndex <= self.arrRoutines.count ? selectedIndex : 0].isSelected = true
                }
                
                self.isRoutineChange.value = !isRestDay
                
                restDayCompletion?(isRestDay)
                
                break
            case .emptyData:
                
                self.arrRoutines.removeAll()
                self.isRoutineChange.value = false
                
                self.planDetails.value = .failure(AppError.custom(errorDescription: message ?? ""))
                
                break
            default: break
            }
            
        }
        
        /*let planDate = planDate ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeFormaterEnum.yyyymmdd.rawValue
                
        let param: [String:Any] = [
            "plan_date": dateFormatter.string(from: planDate)
        ]
        
        ApiManager.shared.makeRequest(method: .content(.exercise_plan_details), parameter: param) { [unowned self] result in
//            guard let self = self else { return }
            switch result{
            case.success(let apiResponse):
                
                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    let data = apiResponse.data
                    let isRestDay = data["is_rest_day"].boolValue
                    
                    self.planDetails.value = .success(data["plan_details"])
                    
                    self.arrRoutines = []
                    if !isRestDay {
                        self.arrRoutines = data["exercise_details"].arrayValue.map({ ExerciseDataModel(fromJson: $0) })
                        self.arrRoutines[0].isSelected = true
                    }
                    
                    self.isRoutineChange.value = !isRestDay
                    
                    restDayCompletion?(isRestDay)
                    
                    break
                    
                case .emptyData:
                    
                    self.arrRoutines.removeAll()
                    self.isRoutineChange.value = false
                    
                    self.planDetails.value = .failure(AppError.custom(errorDescription: apiResponse.message))
                    break
                    
                default:
                    Alert.shared.showSnackBar(apiResponse.message)
                }
                
            case .failure(_):
                debugPrint("Error")
            }
        }*/
        
    }
}
