//
//    RootClass.swift


import Foundation

enum CoachmarkPage: String {
    case home_reading
    case welcome
    case exercise_explore
    case care_plan_goal
    case home_goal
    case home_careplan
    case care_plan_reading
    case care_plan_appointment
    case care_plan_engage
    case engage_discover
    case engage_expert
    case engage_exercise
    case exercise_my_plan
}

class CoachmarkListModel {

    var coachMarksId : String!
    var createdAt : String!
    var descriptionField : String!
    var page : String!
    var updatedAt : String!
    var updatedBy : String!

    static let shared = CoachmarkListModel()
    static var arrList = [CoachmarkListModel]()
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        coachMarksId = json["coach_marks_id"].stringValue
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        page = json["page"].stringValue
        updatedAt = json["updated_at"].stringValue
        updatedBy = json["updated_by"].stringValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension CoachmarkListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [CoachmarkListModel] {
        var models:[CoachmarkListModel] = []
        for item in array
        {
            models.append(CoachmarkListModel(fromJson: item))
        }
        return models
    }
}

//MARK: ---------------- Update Data ----------------------
extension CoachmarkListModel {
    
    func description(page: CoachmarkPage) -> String {
        let arr = CoachmarkListModel.arrList.filter { obj in
            return obj.page == page.rawValue
        }
        if arr.count > 0 {
            return arr.first!.descriptionField
        }
        else {
            return ""
        }
    }
    
    func initShowcase(showcase: MaterialShowcase){
        // Background
        showcase.backgroundAlpha = 0.5
        showcase.backgroundPromptColor = UIColor.themeBlack
        showcase.backgroundPromptColorAlpha = 0.4
        showcase.backgroundViewType = .circle // default is .circle
        showcase.backgroundRadius = 500
        showcase.isTapRecognizerForTargetView = false
        
          // Target
        showcase.targetTintColor = UIColor.clear
        showcase.targetHolderRadius = 40
        showcase.targetHolderColor = UIColor.clear
          // Text
        showcase.primaryTextColor = UIColor.white
        showcase.secondaryTextColor = UIColor.white
        showcase.primaryTextSize = 20
        showcase.secondaryTextSize = 15
//        self.showcase.primaryTextFont = UIFont.boldSystemFont(ofSize: primaryTextSize)
//        self.showcase.secondaryTextFont = UIFont.systemFont(ofSize: secondaryTextSize)
          //Alignment
        showcase.primaryTextAlignment = .left
        showcase.secondaryTextAlignment = .left
          // Animation
        showcase.aniComeInDuration = 0.5 // unit: second
        showcase.aniGoOutDuration = 0.5 // unit: second
        showcase.aniRippleScale = 1.5
        showcase.aniRippleColor = UIColor.clear
        showcase.aniRippleAlpha = 0.2
          //...
    }
}

