//
//  PlanManager.swift
//  MyTatva
//
//  Created by Darshan Joshi on 05/01/22.
//

import Foundation

enum FeatureType: String {
    case reading_logs               = "reading_logs"//done
    case eGFR                       = "eGFR"
    case HeartRate                  = "Heart Rate"
    case FEV1                       = "FEV1"
    case SpO2                       = "SpO2"
    case BodyWeight                 = "Body weight"
    case BloodGlucose               = "Blood Glucose"
    case HbA1c                      = "HbA1c"
    case PEF                        = "PEF"
    case CAT                        = "CAT"
    case ACR                        = "ACR"
    case BMI                        = "BMI"
    case BloodPressure              = "Blood Pressure"
    
    //cr4
    case fibro_scan                 = "fibro_scan"
    case fib4                       = "fib4"
    case sgot                       = "sgot"
    case sgpt                       = "sgpt"
    case triglycerides              = "triglycerides"
    case total_cholesterol          = "total_cholesterol"
    case ldl_cholesterol            = "ldl_cholesterol"
    case hdl_cholesterol            = "hdl_cholesterol"
    case waist_circumference        = "waist_circumference"
    case platelet                   = "platelet"
    
    case activity_logs              = "activity_logs"//done
    case Diet                       = "Diet"
    case Exercise                   = "Exercise"
    case Sleep                      = "Sleep"
    case Steps                      = "Steps"
    case Water                      = "Water"
    case Breathing                  = "Breathing"
    case Medication                 = "Medication"
//    case food_logs = "food_logs"//done Food logging - detailed insights
//    case food_dairy = "food_dairy"//done
    case bookmarks                  = "bookmarks"//done
    case incident_records_history   = "incident_records_history"//done
    case prescription_book_test     = "prescription_book_test"//done
    case add_medication             = "add_medication"//done
    case diet_plan                  = "diet_plan"//Done
    case book_appointments          = "book_appointments"//done
    case book_appointments_doctor   = "book_appointments_doctor"//on hold
    case book_appointments_hc       = "book_appointments_hc"//on hold
    case add_records_history_records = "add_records_history_records"//done
    //case EngageArticleType – trial, premium = "engage_article_trial_premium"
//    case trial = "trial"
//    case premium = "premium"
//    case Engage article type – each genre = "engage_article_genre"
//    case Lifestyle = "Lifestyle"
//    case Okra = "Okra"
    case engage_article_selection_of_language = "engage_article_selection_of_language"
    case Hindi                      = "Hindi"
    case English                    = "English"
    case commenting_on_articles     = "commenting_on_articles"//done
    case chat_healthcoach           = "chat_healthcoach"//done
    case chat_support               = "chat_support"//on hold/ no such feature
    case exercise_my_routine_breathing = "exercise_my_routine_breathing"//done
    case exercise_my_routine_exercise = "exercise_my_routine_exercise"//done
    //case Exercise - Explore tab – Video by genre = "exercise_explore_by_genre"
//    case Breathing = "Breathing"
//    case Strength and Cardio = "Strength and Cardio"
//    case Yoga = "Yoga"
//    case Exercise – explore tab – video by level = "exercise_explore_video_by_level"
//    case Exercise – explore tab – video by exercise tool = "exercise_explore_by_exercise_tool"
//    case Exercise – explore tab – exercise of the day = "exercise_explore_exercise_of_the_day"
    case history_payments           = "history_payments"//done
    case coach_list                 = "coach_list"//done
    case chatbot                    = "chatbot"//done
    case doctor_says                = "doctor_says"
    case ask_an_expert              = "ask_an_expert"
    
}


class PlanManager: NSObject {

    static let shared : PlanManager     = PlanManager()
    private let vwLockTaG: Int          = 123123123
    
    func isAllowedByPlan(type: FeatureType,
                         sub_features_id: String,
                         completion: ((Bool) -> Void)?){
        var isRreturn = false
        
        if type == .reading_logs || type == .activity_logs {
            completion?(true)
            return
        }
        
        if let plans = UserModel.shared.patientPlans {
            for plan in plans {
                print(plan.featuresRes,"feature res====>")
                for feature in plan.featuresRes {
                    if let planType = FeatureType.init(rawValue: feature.featureKeys) {
                        print(planType,"plantype")
                        if type == planType {
                            switch type {
                               
                            case .reading_logs:
                                isRreturn = true
                                
                                //This is for Readings
                                /*if feature.subFeaturesKeys != nil {
                                    if feature.subFeaturesKeys.contains(sub_features_id) {
                                        isRreturn = true
                                    }
                                }*/
//                                if  sub_features_id.contains("fibro_scan") ||
//                                    sub_features_id.contains("fib4") ||
//                                    sub_features_id.contains("sgot") ||
//                                    sub_features_id.contains("sgpt") ||
//                                    sub_features_id.contains("triglycerides") ||
//                                    sub_features_id.contains("total_cholesterol") ||
//                                    sub_features_id.contains("ldl_cholesterol") ||
//                                    sub_features_id.contains("hdl_cholesterol") ||
//                                    sub_features_id.contains("waist_circumference") ||
//                                    sub_features_id.contains("platelet")
//                                {
//                                    
//                                    isRreturn = true
////                                        fibro_scan
////                                        fib4
////                                        sgot
////                                        sgpt
////                                        triglycerides
////                                        total_cholesterol
////                                        ldl_cholesterol
////                                        hdl_cholesterol
////                                        waist_circumference
////                                        platelet
//                                    
//                                }
                                
                                break
                                
                            case .activity_logs:
                                isRreturn = true
                                //This is for Goals
                                /*if feature.subFeaturesKeys != nil {
                                    if feature.subFeaturesKeys.contains(sub_features_id) {
                                        isRreturn = true
                                    }
                                }*/
                                break
                                
                            case .bookmarks:
                                //This is for bookmarks
                                isRreturn = true
                                break
                                
                            case .incident_records_history:
                                //Incident recording + incident history in history page
                                isRreturn = true
                                break
                                
                            case .prescription_book_test:
                                //prescription_book_test
                                isRreturn = true
                                break
                                
                            case .add_records_history_records:
                                //add_records_history_records
                                isRreturn = true
                                break
                                
                            case .commenting_on_articles:
                                //commenting_on_articles
                                isRreturn = true
                                break
                                
                            case .chatbot:
                                //chatbot
                                isRreturn = true
                                break
                                
                            case .chat_healthcoach:
                                isRreturn = true
                                break
                                
                            case .history_payments:
                                isRreturn = true
                                break
                                
                            case .coach_list:
                                isRreturn = true
                                break
                                
//                            case .food_logs:
//                                isRreturn = true
//                                break
//
//                            case .food_dairy:
//                                isRreturn = true
//                                break
                                
                            case .add_medication:
                                isRreturn = true
                                break
                                
                            case .engage_article_selection_of_language:
                                isRreturn = true
                                break
                                
                            case .exercise_my_routine_breathing:
                                isRreturn = true
                                break
                                
                            case .exercise_my_routine_exercise:
                                isRreturn = true
                                break
                                
                            case .book_appointments:
                                if feature.subFeaturesKeys != nil {
                                    if feature.subFeaturesKeys.contains(sub_features_id) {
                                        isRreturn = true
                                        break
                                    }
                                }
                                isRreturn = true
                                break
                                
                            case .book_appointments_doctor:
                                isRreturn = true
                                break
                                
                            case .book_appointments_hc:
                                isRreturn = true
                                break
                                
                            case .doctor_says:
                                isRreturn = true
                                break
                                
                            case .ask_an_expert:
                                isRreturn = true
                                break
                                
                            case .diet_plan:
                                isRreturn = true
                                break
                                
                            default: break
                            }
                        }
                    }
                }
            }
        }
        completion?(isRreturn)
    }
    
    func alertNoSubscription(){
        Alert.shared.showAlert(message: AppMessages.SubscribeToContinue, completion: nil)
    }
    
    //MARK: -------------------------- Lock Setup Methods --------------------------
    func addLock(toView: UIView,
                 eventName : FIREventType,
                 screen: ScreenName? = nil){
        
        self.removeLock(toView: toView)
        DispatchQueue.main.async {
            toView.layoutIfNeeded()
            //            self.removeLock(toView: toView)
            let vwLock: UIView                  = UIView()
            vwLock.frame                        = toView.bounds
            vwLock.tag                          = self.vwLockTaG
            vwLock.backgroundColor              = UIColor.black.withAlphaComponent(0.4)
            let imgLock                         = UIImageView(image: UIImage(named: "plan_lock"))
            imgLock.frame                       = CGRect(x: (toView.frame.width/2)-20,
                                                         y: (toView.frame.height/2)-20,
                                                         width: 40, height: 40)
            
            vwLock.cornerRadius(cornerRadius: toView.layer.cornerRadius)
            vwLock.addSubview(imgLock)
            toView.addSubview(vwLock)
            //            self.vwLock.isUserInteractionEnabled = false
            
//            UIView.animate(withDuration: kAnimationSpeed, delay: 0, options: [.curveEaseIn]) {
//                toView.layoutIfNeeded()
//                vwLock.layoutIfNeeded()
//            } completion: { isDone in
//                toView.layoutIfNeeded()
//                vwLock.layoutIfNeeded()
//            }
            
            vwLock.addTapGestureRecognizer {
                
                var params              = [String : Any]()
                params[AnalyticsParameters.feature_status.rawValue]    = FeatureStatus.inactive.rawValue
//                params[AnalyticsParameters.plan_duration.rawValue]      = selectedDuration[0].durationTitle
                //params[AnalyticsParameters.plan_value.rawValue]         = selectedDuration[0].iosPrice
                
                FIRAnalytics.FIRLogEvent(eventName: eventName,
                                         screen: screen,
                                         parameter: params)
                PlanManager.shared.openLockedFeature()
            }
        }
    }
    
    func openLockedFeature(){
//        let vc = PlanParentVC.instantiate(fromAppStoryboard: .setting)
        let vc = BCPCarePlanVC.instantiate(fromAppStoryboard: .BCP_temp)
        vc.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func removeLock(toView: UIView){
        let vwLock = toView.viewWithTag(self.vwLockTaG)
        if let views = vwLock?.subviews {
            for view in  views{
                view.removeFromSuperview()
            }
        }
        vwLock?.removeFromSuperview()
        toView.layoutIfNeeded()
    }
    
}
