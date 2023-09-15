//
//  SomeoneElseDataModel.swift
//  MyTatva
//
//  Created by 2022M43 on 01/05/23.
//

import Foundation

class SomeoneElseDataModel {

    var someoneElseTittle : String!
    var isSelected = false

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    
    init(someoneElseTittle:String = String(), isSelected: Bool = false) {
        self.someoneElseTittle = someoneElseTittle
        self.isSelected = isSelected
    }
}
