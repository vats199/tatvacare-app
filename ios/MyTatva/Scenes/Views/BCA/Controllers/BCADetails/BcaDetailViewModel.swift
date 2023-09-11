//
//  BcaDetailViewModel.swift
//  MyTatva
//
//  Created Hyperlink on 09/05/23.
//  Copyright © 2023. All rights reserved.

import Foundation


class BcaDetailViewModel: NSObject {
    
    //MARK: Class Variables
    private var arrBCAList: [BCAVitalsModel] = [] {
        didSet {
            self.isResult.value = self.lastSync
        }
    }
    private(set) var isResult = Bindable<String>()
    private var lastSync: String?
    
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
    
    func getVitalControllers() -> [UIViewController] {
        return self.arrBCAList.map({ model in
            let vc = BcaVitalsDetailsTypeVC.instantiate(fromAppStoryboard: .bca)
            vc.viewModel.readingModel = model
            return vc
        })
    }
    
    func getSelectedIndex() -> Int {
        return self.arrBCAList.firstIndex(where: { $0.isSelected }) ?? 0
    }
    
}

//------------------------------------------------------
//MARK: - WebMethods
extension BcaDetailViewModel {
    
    func getBCAVitals() {
        
        ApiManager.shared.makeRequest(method: .goalReading(.get_bca_vitals), methodType: .post, parameter: [:], withErrorAlert: true, withLoader: true, withdebugLog: true) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.success(let apiResponse):
                
                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    self.lastSync = apiResponse.data["last_sync_date"].stringValue
                    self.arrBCAList = apiResponse.data["readings"].arrayValue.map({ BCAVitalsModel(fromJson: $0) })
                    
                default:
                    Alert.shared.showSnackBar(apiResponse.message)
                }
                
                print(apiResponse.data)
            case .failure(_):
                debugPrint("Error")
            }
        }
        
    }
    
    func updateBCAReadings(_ reading:String) {
        
        var param = BCAReadingModel(fromJson: JSON(reading.convertToDictionary())).toDictionary()
        
        ApiManager.shared.makeRequest(method: .goalReading(.update_bca_readings), methodType: .post, parameter: param, withErrorAlert: true, withLoader: true, withdebugLog: true) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.success(let apiResponse):
                
                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    self.getBCAVitals()
                    
                    var params = [String:Any]()
                    params[AnalyticsParameters.medical_device.rawValue] = kBCA
                    FIRAnalytics.FIRLogEvent(eventName: .HEALTH_MARKERS_POPULATED,
                                             screen: .MeasureSmartScaleReadings,
                                             parameter: params)
                    
                default:
                    Alert.shared.showSnackBar(apiResponse.message)
                }
                
                print(apiResponse.data)
            case .failure(_):
                debugPrint("Error")
            }
            
        }
        
    }
    
    func downloadBCAPDF() {
        
        ApiManager.shared.makeRequest(method: .goalReading(.generate_bca_report), parameter: [:]) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.success(let apiResponse):
                
                switch apiResponse.apiCode {
                case .success:
                    print(apiResponse.data)
                    
                    var params = [String:Any]()
                    params[AnalyticsParameters.medical_device.rawValue] = kBCA
                    FIRAnalytics.FIRLogEvent(eventName: .USER_DOWNLOADS_REPORT,
                                             screen: .MeasureSmartScaleReadings,
                                             parameter: params)
                    
                    if let url = URL(string: apiResponse.data.stringValue) {
                        let formatter = DateFormatter()
                        formatter.dateFormat = DateTimeFormaterEnum.bcaReport.rawValue
                        let fileName = "\(UserModel.shared.name ?? "")'s Smart Analyser Report - \(formatter.string(from: Date()))"
                        GFunction.shared.openPdf(url: url,
                                                 withName: fileName)
                    }
                    
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
