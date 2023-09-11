

import Foundation

class BookTestListModel {
    
    //For Test
    var aliasName : String!
    var category : String!
    var code : String!
    var createdAt : String!
    var descriptionField : String!
    var diseaseGroup : String!
    var fasting : String!
    var fluoride : String!
    var groupName : String!
    var imageLocation : String!
    var isActive : String!
    var isDeleted : String!
    var lab : LabDetailsModel!
    var labTestId : String!
    var margin : String!
    var name : String!
    var offerRate : Int!
    var payType : String!
    var rateB2B : Int!
    var rateB2C : Int!
    var specimenType : String!
    var testCount : Int!
    var testNames : String!
    var type : String!
    var urine : String!
    var colorCode : String!
    var discountPercent : String!
    var discountPrice : String!
    var price : String!
    var cart : CartTest!
    var available : String!
    var image : String!
    var inCart : String!
    var updatedAt : String!
    
    //For pkgs
    var childs : [ChildTest]!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        aliasName = json["aliasName"].stringValue
        available = json["available"].stringValue
        let cartJson = json["cart"]
        if !cartJson.isEmpty{
            cart = CartTest(fromJson: cartJson)
        }
        category = json["category"].stringValue
        childs = [ChildTest]()
        let childsArray = json["childs"].arrayValue
        for childsJson in childsArray{
            let value = ChildTest(fromJson: childsJson)
            childs.append(value)
        }
        code = json["code"].stringValue
        colorCode = json["color_code"].stringValue
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        discountPercent = json["discount_percent"].stringValue
        discountPrice = json["discount_price"].stringValue
        diseaseGroup = json["diseaseGroup"].stringValue
        fasting = json["fasting"].stringValue
        fluoride = json["fluoride"].stringValue
        groupName = json["groupName"].stringValue
        image = json["image"].stringValue
        imageLocation = json["imageLocation"].stringValue
        inCart = json["in_cart"].stringValue
        isActive = json["is_active"].stringValue
        isDeleted = json["is_deleted"].stringValue
        let labJson = json["lab"]
        if !labJson.isEmpty{
            lab = LabDetailsModel(fromJson: labJson)
        }
        labTestId = json["lab_test_id"].stringValue
        margin = json["margin"].stringValue
        name = json["name"].stringValue
        offerRate = json["offerRate"].intValue
        payType = json["payType"].stringValue
        price = json["price"].stringValue
        rateB2B = json["rate_b2B"].intValue
        rateB2C = json["rate_b2C"].intValue
        specimenType = json["specimenType"].stringValue
        testCount = json["testCount"].intValue
        testNames = json["testNames"].stringValue
        type = json["type"].stringValue
        updatedAt = json["updated_at"].stringValue
        urine = json["urine"].stringValue
    }

}

//MARK: ---------------- Array Model ----------------------
extension BookTestListModel {
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [BookTestListModel] {
        var models:[BookTestListModel] = []
        for item in array
        {
            models.append(BookTestListModel(fromJson: item))
        }
        return models
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class ChildTest{

    var code : String!
    var groupName : String!
    var name : String!
    var parentCode : String!
    var type : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        code = json["code"].stringValue
        groupName = json["groupName"].stringValue
        name = json["name"].stringValue
        parentCode = json["parent_code"].stringValue
        type = json["type"].stringValue
    }

}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦

class CartTest{

    var totalPrice : String!
    var totalTest : Int!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        totalPrice = json["total_price"].stringValue
        totalTest = json["total_test"].intValue
    }

}
