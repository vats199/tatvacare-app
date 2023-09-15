//
//  SomeoneElsePopupVM.swift
//  MyTatva
//
//  Created by 2022M43 on 01/05/23.
//

import Foundation

enum AccountForType : String {
    case Parent = "Parent"
    case Sibling = "Sibling"
    case Spouse = "Spouse"
    case Child = "Child"
    case Grandparent = "Grandparent"
    case Other_relative = "Other Relative"
}

class SomeoneElsePopupVM {

    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    
    var page                        = 1
    var isNextPage                  = true
    var arrList                     = [SomeoneElseDataModel]()
    var strErrorMessage : String    = ""
    
    //MARK:- Init
    init() {
        self.arrList = [SomeoneElseDataModel(someoneElseTittle: AccountForType.Parent.rawValue,isSelected: true),
                        SomeoneElseDataModel(someoneElseTittle: AccountForType.Sibling.rawValue),
                        SomeoneElseDataModel(someoneElseTittle: AccountForType.Spouse.rawValue),
                        SomeoneElseDataModel(someoneElseTittle: AccountForType.Child.rawValue),
                        SomeoneElseDataModel(someoneElseTittle: AccountForType.Grandparent.rawValue),
                        SomeoneElseDataModel(someoneElseTittle: AccountForType.Other_relative.rawValue)
        ]
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
    
}

//MARK: ---------------- Update Data ----------------------
extension SomeoneElsePopupVM {
    
    func getCount() -> Int {
        return self.arrList.count
    }
    
    func getSelectedObject() ->  SomeoneElseDataModel? {
        let arrTemp = self.arrList.filter { (obj) -> Bool in
            return obj.isSelected
        }
        return arrTemp.first
    }
    
    func updateValue(_ index: Int) {
        self.arrList.forEach( {
            $0.isSelected = false
        })
        self.arrList[index].isSelected = !self.arrList[index].isSelected
    }
}
