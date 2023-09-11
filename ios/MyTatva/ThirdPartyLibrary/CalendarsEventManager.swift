//
//  CalendarsEventManager.swift
//  MyTatva
//

//

import Foundation
import EventKit

class CalendarsEventManager {
    
    ///Shared instance
    static let shared : CalendarsEventManager = CalendarsEventManager()
    private lazy var eventStore = EKEventStore()
    
    func requestAuth(completion: @escaping((Bool) -> Void)){
        var completionVal = false
        switch EKEventStore.authorizationStatus(for: .event) {
            
        case .authorized:
            completionVal = true
            print("Calendars Event Authorized")
            completion(completionVal)
            break
        case .denied:
            print("Calendars Event Access denied")
            completion(completionVal)
            break
        case .notDetermined:
            self.eventStore.requestAccess(to: .event, completion:
                                        {(granted: Bool, error: Error?) -> Void in
                if granted {
                    completionVal = true
                    print("Calendars Event Access granted")

                } else {
                    print("Calendars Event Access denied")
                }
                completion(completionVal)
            })
            print("Calendars Event Not Determined")
            break
        default:
            print("Case Default")
            completion(completionVal)
            break
        }
    }
    
    func addToCalendars(title: String,
                        startDate: Date,
                        endDate: Date,
                        notes: String,
                        showNoPermission: Bool,
                        completion: @escaping((Bool) -> Void)){
        
        self.requestAuth { [weak self] isDone in
            guard let self = self else {return}
            
            if isDone {
                let event:EKEvent = EKEvent(eventStore: self.eventStore)
                
                event.title             = title
                event.startDate         = startDate
                event.endDate           = endDate
                event.notes             = notes
                event.calendar          = self.eventStore.defaultCalendarForNewEvents
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                    print("Saved Event")
                    completion(true)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                    completion(false)
                }
            }
            else {
                if showNoPermission {
                    DispatchQueue.main.async {
                        //No permission to add event
                        let alertController = UIAlertController(title: "App Permission Denied".localized, message: "To re-enable, please go to Settings and turn on Calendars for ".localized + "\(Bundle.appName())", preferredStyle: .alert)
                        
                        let setting = UIAlertAction(title: "Go to Settings".localized, style: .default, handler: { [weak self] (UIAlertAction) in
                            guard let _ = self else {return}
                            
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
                            } else {
                                // Fallback on earlier versions
                                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)! as URL)
                            }
                        })
                        
                        let close = UIAlertAction(title: "Close".localized, style: .default, handler: { (UIAlertAction) in
                            completion(false)
                        })
                        
                        alertController.addAction(setting)
                        alertController.addAction(close)
                        
                        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func removeEvent(eventId: String, eventStore: EKEventStore) {
        if let eventToDelete = self.eventStore.event(withIdentifier: eventId){
            do {
                try eventStore.remove(eventToDelete, span: .thisEvent)
            } catch let error as NSError {
                print("failed to save event with error : \(error)")
            }
            print("removed Event")
        }
    }
}
                
