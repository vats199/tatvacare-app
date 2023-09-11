//
//  BcaVitalsDetailsTypeViewModel.swift
//  MyTatva
//
//  Created Hyperlink on 10/05/23.
//  Copyright © 2023. All rights reserved.

import Foundation


class BcaVitalsDetailsTypeViewModel: NSObject {

    //MARK: Class Variables
    
    var readingModel:BCAVitalsModel!
    private(set) var isResult = Bindable<VitalTrendsAnalyticsModel>()
    
    //MARK: Init
    override init() {
        super.init()
    }
    
    //MARK: Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
    //MARK: Custom Methods
}

//------------------------------------------------------
//MARK: - WS Methods
extension BcaVitalsDetailsTypeViewModel {
    
    func getVitalTrendAnalysis(_ readingTime: String) {
        
        let params:[String:Any] = [
            "reading_id": self.readingModel.readingsMasterId ?? "",
            "reading_time": readingTime
        ]
        
        ApiManager.shared.makeRequest(method: .goalReading(.vitals_trend_analysis), parameter: params) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.success(let apiResponse):
                
                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    self.isResult.value = VitalTrendsAnalyticsModel(fromJson: apiResponse.data)
                    
                default:
                    Alert.shared.showSnackBar(apiResponse.message)
                }
                
                print(apiResponse.data)
            case .failure(_):
                debugPrint("Error")
            }
        }
        
    }
    
}
