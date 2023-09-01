//
//  WalkthroughVM.swift
//  MyTatva
//
//  Created by Uttam patel on 05/06/23.
//

import Foundation

class WalkthroughVM {
    
    //MARK: - Varibles -
    
    
    var arrWalkthroughList = [WalkthroughListModel]()
    
    //MARK: - Setup -
    
    

    //MARK: - API -
    
    
    
    //MARK: - Data Processing Methods -
    
    func numOfItem() -> Int {
        return self.arrWalkthroughList.count
    }
    
    //---------------------------------------------------------------------------
    
    func valueForCell(_ row: Int) -> WalkthroughListModel {
        return self.arrWalkthroughList[row]
    }
    
    //---------------------------------------------------------------------------
    
}


