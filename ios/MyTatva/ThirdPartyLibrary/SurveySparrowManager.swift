//
//  SurveySparrowManager.swift
//  MyTatva
//
//  Created by Darshan Joshi on 14/10/21.
//

import Foundation
import SurveySparrowSdk

class SurveySparrowManager : NSObject {
    
    ///Shared instance
    static let shared : SurveySparrowManager = SurveySparrowManager()
    
    private var ssDummyToken        = "tt-584709"
    private var ssDomain            = "mytatva.surveysparrow.com"
    var ssSurveyViewController : SsSurveyViewController!
    var completionHandler: ((_ obj : [String : AnyObject]?) -> Void)?
    
    func setup(){
        self.ssSurveyViewController = SsSurveyViewController()
        self.ssSurveyViewController.surveyDelegate = self
        self.ssSurveyViewController.domain = ssDomain
        
#if DEBUG
        // This code will be run while installing from Xcode
        ssDomain            = "mytatva.surveysparrow.com"
#else
        // This code will be run from AppStore, Adhoc ...
        ssDomain            = "mytatva.surveysparrow.com"
#endif
        
    }
    
    func startSurveySparrow(token: String){
        self.setup()
        
        self.ssSurveyViewController.token = token
        
        var params                  = [String: String]()
        params["patient_id"]        = UserModel.shared.patientId ?? ""
        params["patient_name"]      = UserModel.shared.name ?? ""
        
        self.ssSurveyViewController.params = params
        self.ssSurveyViewController.thankyouTimeout = 20
        UIApplication.topViewController()?.present(self.ssSurveyViewController, animated: true, completion: nil)
    }
}

extension SurveySparrowManager : SsSurveyDelegate {
    
    func handleSurveyLoaded(response: [String : AnyObject]) {
        print(response)
    }
    func handleSurveyResponse(response: [String : AnyObject]) {
        //print(response)
        
        if let completionHandler = completionHandler {
            completionHandler(response)
        }
        
//        ["type": surveyCompleted, "customParams": {
//        }, "response": <__NSArrayM 0x600002f3c210>(
//        {
//            answer = Evening;
//            id = 2951164;
//            question = "<p>When incident occured?</p>";
//        },
//        {
//            answer = Faint;
//            id = 2951169;
//            question = "<p>Please describe about incident</p>";
//        },
//        {
//            answer = Nothing;
//            id = 2951171;
//            question = "<p>What did you eat before incident</p>";
//        }
//        )
//        ]
        
//
//        ["customParams": {
//        }, "type": surveyCompleted, "response": <__NSArrayM 0x600001fa6700>(
//        {
//            answer = "High blood pressure";
//            id = 2952065;
//            question = "<p>Eating a healthy diet can help reduce the risk of developing health problems, such as:</p>";
//        },
//        {
//            answer = "Decreased interest and pleasure in usual activities";
//            id = 2952152;
//            question = "<p>Depression in older adults can be hard to detect. However the earlier it is detected, the easier it can be to treat. Which of the following are symptoms of depression?</p>";
//        },
//        {
//            answer = "Doing mental exercises like crossword puzzles and other games.";
//            id = 2952153;
//            question = "<p>What are some things you can do to help support your brain health?</p>";
//        },
//        {
//            answer = "deferred vesting strategy";
//            id = 2952170;
//            question = "<p>In controlling health care benefits cost, the strategy in which employees have to pay the cost of medical care and insurance premiums is classified as</p>";
//        }
//        )
//        ]
    }
}
