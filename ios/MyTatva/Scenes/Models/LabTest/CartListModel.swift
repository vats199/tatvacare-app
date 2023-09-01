

import Foundation

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class CartListModel {
    
    var bcpTestsList : [BcpTestsList]!
    var homeCollectionCharge : HomeCollectionCharge!
    var lab : LabDetailsModel!
    var orderDetail : OrderDetail!
    var testsList : [TestsList]!
    
    static var shared = CartListModel()
    
    init(){}
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bcpTestsList = [BcpTestsList]()
        let bcpTestsListArray = json["bcp_tests_list"].arrayValue
        for bcpTestsListJson in bcpTestsListArray{
            let value = BcpTestsList(fromJson: bcpTestsListJson)
            bcpTestsList.append(value)
        }
        let homeCollectionChargeJson = json["home_collection_charge"]
        if !homeCollectionChargeJson.isEmpty{
            homeCollectionCharge = HomeCollectionCharge(fromJson: homeCollectionChargeJson)
        }
        let labJson = json["lab"]
        if !labJson.isEmpty{
            lab = LabDetailsModel(fromJson: labJson)
        }
        let orderDetailJson = json["order_detail"]
        if !orderDetailJson.isEmpty{
            orderDetail = OrderDetail(fromJson: orderDetailJson)
        }
        testsList = [TestsList]()
        let testsListArray = json["tests_list"].arrayValue
        for testsListJson in testsListArray{
            let value = TestsList(fromJson: testsListJson)
            testsList.append(value)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bcpTestsList != nil{
            var dictionaryElements = [[String:Any]]()
            for bcpTestsListElement in bcpTestsList {
                dictionaryElements.append(bcpTestsListElement.toDictionary())
            }
            dictionary["bcp_tests_list"] = dictionaryElements
        }
        if homeCollectionCharge != nil{
            dictionary["home_collection_charge"] = homeCollectionCharge.toDictionary()
        }
        if lab != nil{
            dictionary["lab"] = lab.toDictionary()
        }
        if orderDetail != nil{
            dictionary["order_detail"] = orderDetail.toDictionary()
        }
        if testsList != nil{
            var dictionaryElements = [[String:Any]]()
            for testsListElement in testsList {
                dictionaryElements.append(testsListElement.toDictionary())
            }
            dictionary["tests_list"] = dictionaryElements
        }
        return dictionary
    }
    
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦

class TestsList{
    
    var code : String!
    var discountPercent : Int!
    var discountPrice : Int!
    var imageLocation : String!
    var labTestId : String!
    var name : String!
    var price : Int!
    var testNames : String!
    var type : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        code = json["code"].stringValue
        discountPercent = json["discount_percent"].intValue
        discountPrice = json["discount_price"].intValue
        imageLocation = json["imageLocation"].stringValue
        labTestId = json["lab_test_id"].stringValue
        name = json["name"].stringValue
        price = json["price"].intValue
        testNames = json["testNames"].stringValue
        type = json["type"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if code != nil{
            dictionary["code"] = code
        }
        if discountPercent != nil{
            dictionary["discount_percent"] = discountPercent
        }
        if discountPrice != nil{
            dictionary["discount_price"] = discountPrice
        }
        if imageLocation != nil{
            dictionary["imageLocation"] = imageLocation
        }
        if labTestId != nil{
            dictionary["lab_test_id"] = labTestId
        }
        if name != nil{
            dictionary["name"] = name
        }
        if price != nil{
            dictionary["price"] = price
        }
        if testNames != nil{
            dictionary["testNames"] = testNames
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }
    
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦

class OrderDetail{
    
    var orderTotal : String!
    var payableAmount : String!
    var totalTest : Int!
    var finalPayableAmount : Int!
    
    var serviceCharge : String!
    
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        orderTotal = json["order_total"].stringValue
        payableAmount = json["payable_amount"].stringValue
        totalTest = json["total_test"].intValue
        finalPayableAmount = json["final_payable_amount"].intValue
        serviceCharge = json["service_charge"].stringValue
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if finalPayableAmount != nil{
            dictionary["final_payable_amount"] = finalPayableAmount
        }
        if orderTotal != nil{
            dictionary["order_total"] = orderTotal
        }
        if payableAmount != nil{
            dictionary["payable_amount"] = payableAmount
        }
        if serviceCharge != nil{
            dictionary["service_charge"] = serviceCharge
        }
        if totalTest != nil{
            dictionary["total_test"] = totalTest
        }
        return dictionary
    }
    
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class LabDetailsModel{
    
    var address : String!
    var image : String!
    var name : String!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        image = json["image"].stringValue
        name = json["name"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if address != nil{
            dictionary["address"] = address
        }
        if image != nil{
            dictionary["image"] = image
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
    
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
class HomeCollectionCharge{
    
    var ammount : Int!
    var payableAmmount : Int!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        ammount = json["ammount"].intValue
        payableAmmount = json["payable_ammount"].intValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if ammount != nil{
            dictionary["ammount"] = ammount
        }
        if payableAmmount != nil{
            dictionary["payable_ammount"] = payableAmmount
        }
        return dictionary
    }
    
}
