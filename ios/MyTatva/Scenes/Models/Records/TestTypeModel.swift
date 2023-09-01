//
//	TestTypeModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class TestTypeModel{

	var testType : [TestType]!
	var title : [Title]!

    init() { }
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		testType = [TestType]()
		let testTypeArray = json["test_type"].arrayValue
		for testTypeJson in testTypeArray{
			let value = TestType(fromJson: testTypeJson)
			testType.append(value)
		}
		title = [Title]()
		let titleArray = json["title"].arrayValue
		for titleJson in titleArray{
			let value = Title(fromJson: titleJson)
			title.append(value)
		}
	}

}
