//
//  ApiHelper.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

import UIKit

///Response data
typealias responseData = (JSON,Int,ApiKeys.ApiStatusCode)

///Mappable model protocol
protocol Mappable {
    init(fromJson json : JSON)
}


///Data result model
struct DataResult {
    var data : JSON = JSON.null
    var httpCode : Int = NSNotFound
    var apiCode : ApiKeys.ApiStatusCode = .invalidOrFail
    var message : String = ""
    var response : JSON = JSON.null
}

///Generic data result model
struct DataResultModel<T : Mappable> {
    var data : T = T.init(fromJson: JSON.null)
    var httpCode : Int = NSNotFound
    var apiCode : ApiKeys.ApiStatusCode = .invalidOrFail
    var message : String = ""
    var response : JSON = JSON.null
}

///Generic model list
class ModelList<T : Mappable> : Mappable{
    
    var result : [T] = []
    
    required init(fromJson json: JSON) {
        result = ModelList.createModelArray(model: T.self, json: json.arrayValue)
    }
    
    class func createModelArray<T : Mappable>(model : T.Type , json : [JSON]) -> [T] {
        return json.map{ model.init(fromJson : $0)  }
    }
}

///API Errors
struct ApiCustomError : Error {
    ///Session expire - 401
    static var sessionExpire = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "User Session Expire"]) as Error
    
    ///Invalid data - 401
    static var invalidData = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "Invalid Data"]) as Error
}
