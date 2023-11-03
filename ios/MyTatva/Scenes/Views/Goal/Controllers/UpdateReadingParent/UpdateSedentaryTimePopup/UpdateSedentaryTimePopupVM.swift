//
//  UpdateSedentaryTimePopupVM.swift
//  MyTatva
//
//  Created by Hlink on 19/09/23.
//
import Foundation
class UpdateSedentaryTimePopupVM {

    //MARK: - Class Variables
    private(set) var vmResult   = Bindable<Result<String?, AppError>>()
    var achieved_datetime       = Date()
    var startTime               = Date()
    var endTime                 = Date()

    //MARK: - init
    init() {

    }

    //---------------------------------------------------------
    //MARK:- Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }

}

extension UpdateSedentaryTimePopupVM {

    private func validateView(vc: UIViewController,/*
                              date: String,
                              time: String,*/
                              sleepStartTime: String,
                              sleepEndTime: String,
                              physicalActivity: String,
                              activityStartTime: String,
//                              activityEndTime: String,
                              readingListModel: ReadingListModel) -> AppError? {

        /*if date.trim().isEmpty {
            return AppError.validation(type: .selectDate)
        } else if time.trim().isEmpty {
            return AppError.validation(type: .selectTime)
        } else*/ if sleepStartTime.trim().isEmpty {
            return AppError.validation(type: .selectSleepStartDateTime)
        } else if sleepEndTime.trim().isEmpty {
            return AppError.validation(type: .selectSleepEndDateTime)
        } else if physicalActivity.trim().isEmpty {
            return AppError.validation(type: .selectPhysicalActivity)
        } else if activityStartTime.trim().isEmpty {
            return AppError.validation(type: .selectActivityStartDateTime)
        }/* else if activityEndTime.trim().isEmpty {
            return AppError.validation(type: .selectActivityEndDateTime)
        }*/

        return nil
    }

    func apiCall(vc: UpdateSedentaryTimePopupVC,/*
                 date: String,
                 time: String,*/
                 sleepStartTime: String,
                 sleepEndTime: String,
                 physicalActivity: String,
                 activityStartTime: String,
                 duration: Int,
                 /*activityEndTime: String,*/
                 readingListModel: ReadingListModel) {

        if let error = self.validateView(vc: vc,/* date: date, time: time,*/ sleepStartTime: sleepStartTime, sleepEndTime: sleepEndTime,physicalActivity: physicalActivity, activityStartTime: activityStartTime, /*activityEndTime: activityEndTime,*/ readingListModel: readingListModel) {
            self.vmResult.value = .failure(error)
            return
        }

        func convertDateFormatter(date: String) -> String {
            return GFunction.shared.convertDateFormat(dt: date, inputFormat: appDateTimeFormat, outputFormat: dateFormatter, status: .NOCONVERSION).0
        }

        let dateFormatter = DateTimeFormaterEnum.UTCFormat.rawValue
//        let formatterEndTime = convertDateFormatter(date: activityEndTime)
        var exerciseEndTime = GFunction.shared.convertDateFormat(dt: activityStartTime, inputFormat: appDateTimeFormat, outputFormat: dateFormatter, status: .NOCONVERSION).1
        exerciseEndTime = Calendar.current.date(byAdding: .minute, value: duration, to: exerciseEndTime) ?? Date()

        var formatter = DateFormatter()
        formatter.dateFormat = dateFormatter

        let start_Time = GFunction.shared.convertDateFormate(dt: sleepStartTime,
                                                           inputFormat:  appDateTimeFormat,
                                                           outputFormat: appDateFormat + appTimeFormat,
                                                           status: .NOCONVERSION)

        let end_Time = GFunction.shared.convertDateFormate(dt: sleepEndTime,
                                                           inputFormat:  appDateTimeFormat,
                                                           outputFormat: appDateFormat + appTimeFormat,
                                                           status: .NOCONVERSION)

        let differenceMinutes = Calendar.current.dateComponents([.minute], from: start_Time.1, to: end_Time.1)
        print(differenceMinutes)
        let hours:Double = Double(differenceMinutes.minute ?? 0 * 1) / 60

        let reading_value_data: [String:Any] = [
            "exercise_end_time" : formatter.string(from: exerciseEndTime),
            "exercise_start_time" : convertDateFormatter(date: activityStartTime),
            "sleep_achieved_value" : "\(hours)",
            "patient_sub_goal_id" : vc.exerciseModel.arrList.first(where: { $0.exerciseName == physicalActivity })?.exerciseValue ?? "0",
            "sleep_start_time" : convertDateFormatter(date: sleepStartTime),
            "sleep_end_time" : convertDateFormatter(date: sleepEndTime)
        ]

        GlobalAPI.shared.update_patient_readingsAPI(reading_id: readingListModel.readingsMasterId,
                                                    reading_datetime: formatter.string(from: exerciseEndTime),
                                                    reading_value_data: reading_value_data) { [weak self] (isDone, date) in
            guard let self = self else {return}
            if isDone {

                let dateFormatters                   = DateFormatter()
                dateFormatters.dateFormat            = "ss"
                dateFormatters.timeZone              = .current
                let secDt                            = dateFormatters.string(from: Date())

                let startTime = GFunction.shared.convertDateFormate(dt: sleepStartTime + secDt,
                                                                    inputFormat:  appDateFormat + appTimeFormat + "ss",
                                                                    outputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                                    status: .NOCONVERSION)

                let endTime = GFunction.shared.convertDateFormate(dt: sleepEndTime + secDt,
                                                                  inputFormat:  appDateFormat + appTimeFormat + "ss",
                                                                  outputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
                                                                  status: .NOCONVERSION)

                self.achieved_datetime  = date
                self.startTime          = startTime.1
                self.endTime            = endTime.1
                self.vmResult.value     = .success(nil)
            }
        }

    }

}
