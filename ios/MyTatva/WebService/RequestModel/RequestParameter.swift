//
//  RequestParameter.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

///This class for create HTTP request parameter dictionary and add parameter to dictionary
///This class define all request parameter key and get value at key
class RequestParameter {
    
    ///Parameter dictionary
    private var parameterDict: [String: Any] = [:]
    
    ///Parameter dictionary key
    enum Key: String {
        case user_id
        case email
        case password
        case device_token
        case device_type
        case time_zone
        case signup_type
        case social_id
        case fullName
        case type
        case country_code
        case mobile_number
        case otp
        case name
        case new_password
        case current_password
        case profile_photo
    }
    
    /// Add multiple request parameter key-value.
    /// - Parameter parameters: Multiple request parameters with key- value.
    init(_ parameters: Parameter...) {
        parameters.forEach { (param) in
            switch param {
            case .add(let key, let value):
                self.add(key, value)
            }
        }
    }
    
    /// Add parameter to request dictionary
    /// - Parameters:
    ///   - key: Parameter key
    ///   - value: Parameter value
    /// - Returns: Return self request model
    @discardableResult
    func add(_ key: Key, _ value: Any?) -> Self {
        if let value = value {
            self.parameterDict[key.rawValue] = value
        }
        return self
    }
    
    ///Return parameter dictionary
    var dictionaryValue: [String: Any] {
        self.parameterDict
    }
    
    /// Get value for key
    /// - Parameter key: Parameter key
    /// - Returns: Any value at key
    func getValue(_ key: Key) -> Any? {
        self.parameterDict[key.rawValue]
    }
}

extension RequestParameter {
    /// This enum for adding value to direct Request parameter constructor.
    enum Parameter {
        case add(_ key: Key, _ value: Any?)
    }
}
