//
//  BcaVitalsDetailsViewModel.swift
//  MyTatva
//
//  Created Hyperlink on 10/05/23.
//  Copyright © 2023. All rights reserved.

import Foundation


class BcaVitalsDetailsViewModel: NSObject {

    //MARK: Class Variables
    var arrBCAList: [BCAVitalsModel] = []
    
    //MARK: Init
    override init() {
        super.init()
    }
    
    //MARK: Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
    //MARK: Custom Methods
    func numberOfRow() -> Int {
        self.arrBCAList.count
    }
    
    func cellForRow(index: Int) -> BCAVitalsModel {
        self.arrBCAList[index]
    }
    
    func changeSelection(row: Int) {
        self.arrBCAList = self.arrBCAList.map ({ model -> BCAVitalsModel in
            let tmp = model
            tmp.isSelected = false
            return tmp
        })
        self.arrBCAList[row].isSelected = true
    }
}
