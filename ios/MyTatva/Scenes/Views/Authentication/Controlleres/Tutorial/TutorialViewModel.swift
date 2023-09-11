//
//  TutorialViewModel.swift
//  HappyOur
//
//  Created by Malhan on 15/06/21.
//

import Foundation

class TutorialViewModel {
    
    //MARK:- Class Variable
    private(set) var listResult = Bindable<Result<String?, AppError>>()
    var arrTutorial: [TutorialModel] = []
    
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
}

// MARK: Cell methods
extension TutorialViewModel {
    
    /// Get tutorial list count.
    /// - Returns: Return list count.
    func numberOfTutorialRow() -> Int {
        self.arrTutorial.count
    }
    
    /// Get Tune cell row.
    /// - Parameter index: Table row index.
    /// - Returns: Return Searched tutorial object data.
    func tutorialRow(for index: Int) -> TutorialModel {
        self.arrTutorial[index]
    }
}

// MARK: Web Services
extension TutorialViewModel {
    /**
     This API for retrive list data.
     
     ### End point
     user/list
     
     ### Method
     GET
     */
    func apiGetTutorialData() {
        // Make request
        let listData: [TutorialModel] = (0...2).map { (index) -> TutorialModel in
            TutorialModel(img: "TutorialIcon", name: "Happy Our", title: "Discover the Deals", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.")
        }
        
        if listData.isEmpty {
            self.listResult.value = .failure(AppError.dataSource(type: .noDataFound))
        } else {
            self.arrTutorial = listData
            self.listResult.value = .success(nil)
        }
    }
}
