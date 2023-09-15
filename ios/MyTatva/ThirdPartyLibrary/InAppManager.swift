//
//  InAppManager.swift
//
//  Created on 14/05/22.
//  Copyright © 2020. All rights reserved.
//

import Foundation
import StoreKit
import SwiftyStoreKit

enum InAppPurchaseEnum : String
{
    case LiveUrl = "https://buy.itunes.apple.com/verifyReceipt"
    case SandboxUrl = "https://sandbox.itunes.apple.com/verifyReceipt"
    case SecreatKey = "38464a7f4189475a96c14226766fcfd2"
    
}

enum Subscription : String{
    case Active = "Active"
    case Inactive  = "Inactive"
}

enum InAppProduct: String {
    case premium    = "com.plan.onetimebuy_1"
}

class InAppManager: NSObject {
    
    static let shared = InAppManager()
    
    var subscriptionProducts : [SKProduct] = []
    
    func purchaseProduct(productID : String, completion :((_ response:JSON?,_ receiptData:String?) -> Void)?)
    {
        AppLoader.shared.addLoader()
        
        SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: true) { result in
            AppLoader.shared.removeLoader()
            switch result {
            case .success(let purchase):
                
                /*self.getPurchaseVerifyReceipt(purchaseProductId: purchase.productId)
                
                FBSDKAppEvents.logPurchase(purchase.product.price.doubleValue, currency: purchase.product.priceLocale.currencySymbol)*/
                print("Purchase Success: \(purchase.productId)")
                AppLoader.shared.addLoader()
                self.getInAppPurhcaseReceipt { (response,receiptData) in
                    AppLoader.shared.removeLoader()
                    if response != nil
                    {
                        let latestTransactionID = self.getOriginalTransectionId(jsonResponse: response!)
                     
                        print("🟦🟦🟦🟦🟦🟦🟦 LatestTransactionID " + latestTransactionID)
                        //print("🟦🟦🟦🟦🟦🟦🟦 ReceiptData " + receiptData!)
                    
                        completion!(response, receiptData)
                        
                        DispatchQueue.main.async {

                        }
                    }
                }
                
                /*GFunction.shared.addLoader()
                AppDelegate.shared.appleReceiptValidator({ (success) in
                    self.stopLoader()
                    if success {
                        GFunction.shared.showSnackBar("Purchase Success")
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        GFunction.shared.showSnackBar("Purchase Success")
                    }
                })*/
               
            case .error(let error):
                
                switch error.code {
                case .unknown:
                    Alert.shared.showSnackBar("Unknown error. Please contact support")
                    break
                case .clientInvalid:
                    Alert.shared.showSnackBar("Not allowed to make the payment")
                    break
                case .paymentCancelled:
                    Alert.shared.showSnackBar("Payment cancelled")
                    break
                case .paymentInvalid:
                    Alert.shared.showSnackBar("The purchase identifier was invalid")
                    break
                case .paymentNotAllowed:
                    Alert.shared.showSnackBar("The device is not allowed to make the payment")
                    break
                case .storeProductNotAvailable:
                    Alert.shared.showSnackBar("The product is not available in the current storefront")
                    break
                case .cloudServicePermissionDenied:
                    Alert.shared.showSnackBar("Access to cloud service information is not allowed")
                    break
                case .cloudServiceNetworkConnectionFailed:
                    Alert.shared.showSnackBar("Could not connect to the network")
                    break
                default:
                    Alert.shared.showSnackBar("Could not connect to the network")
                    break
                }
                completion!(nil, nil)
            }
        }
    }
    
    func getInAppPurhcaseReceipt(completion :((_ response:JSON?,_ receiptData:String?) -> Void)?)
    {
        let receiptPath = Bundle.main.appStoreReceiptURL?.path
        var receiptData:Data?
        
        if FileManager.default.fileExists(atPath: receiptPath!) {
            
            do{
                receiptData = try Data(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
            }
            catch{
                debugPrint("ERROR: " + error.localizedDescription)
            }
        }
        
        let base64encodedReceipt = receiptData?.base64EncodedString()
        print(base64encodedReceipt as Any)
       
        //For SandBox : "https://sandbox.itunes.apple.com/verifyReceipt"
        //For Live    : "https://buy.itunes.apple.com/verifyReceipt"
        
        var strUrl = ""
        switch NetworkManager.environment {
            
        case .live:
            strUrl = InAppPurchaseEnum.LiveUrl.rawValue
            break
        case .uat:
            strUrl = InAppPurchaseEnum.LiveUrl.rawValue
            break
        case .local:
            strUrl = InAppPurchaseEnum.SandboxUrl.rawValue
            break
        case .localhost:
            strUrl = InAppPurchaseEnum.SandboxUrl.rawValue
            break
        }
       
        guard var url = URL(string:strUrl) else { return  }
        
        var dicParam = Dictionary<String,String>()
        dicParam["receipt-data"]    = base64encodedReceipt
        dicParam["password"]        = InAppPurchaseEnum.SecreatKey.rawValue
        print(dicParam)
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dicParam, options: []) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.httpBody = httpBody
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            if error != nil
            {
                print(error!)
                completion!(nil,base64encodedReceipt)
            }
            else
            {
                let jsonResponse = JSON(data as Any)
                print(jsonResponse)
                completion!(jsonResponse, base64encodedReceipt)
            }
        }
        task.resume()
        
    }
    
    func getOriginalTransectionId(jsonResponse: JSON) -> String
    {
        let receiptInfo : [JSON] = jsonResponse["receipt"]["in_app"].arrayValue
        if receiptInfo.count > 0
        {
            let lastReceipt = receiptInfo.last!
           
            print("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦 in_app: \(JSON(lastReceipt)))")
            
            return lastReceipt["transaction_id"].stringValue
        }
        else
        {
            return ""
        }
    }
    
    func getOriginalSubscriptionTransectionId(jsonResponse: JSON) -> String
    {
        let receiptInfo: [JSON] = jsonResponse["latest_receipt_info"].arrayValue
        if receiptInfo.count > 0
        {
            let lastReceipt = receiptInfo.first!
            let origId = lastReceipt["transaction_id"].stringValue
            
            print("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦 latest_receipt_info: \(JSON(lastReceipt)))")
            
            return origId
        }
        else
        {
            return ""
        }
    }
    
    func getProductInfo(productsIDS: [String],
                        completion: @escaping (Bool) -> Void)
    {
        AppLoader.shared.addLoader()
        
        SwiftyStoreKit.retrieveProductsInfo(Set(productsIDS)) { result in
            DispatchQueue.main.async {
                AppLoader.shared.removeLoader()
            }
            var arrProducts : [SKProduct] = []
            if result.retrievedProducts.count > 0 {
                for product in result.retrievedProducts{
                    let objProduct = product
                    let formatter = NumberFormatter()
                    formatter.numberStyle = NumberFormatter.Style.currency
                    formatter.locale = objProduct.priceLocale
                    var currencyString = self.formatPrice(product: objProduct)
                    //"\(formatter.string(from: objProduct.price)!)"
                    
                    /*if product.productIdentifier == ProductIDs.monthlyPlan{
                        currencyString = "$0.99"
                    }
                    else if product.productIdentifier == ProductIDs.quertlyPlan{
                        currencyString = "$4.99"
                    }
                    else if product.productIdentifier == ProductIDs.yearlyPlan{
                        currencyString = "$9.99"
                     }*/
                    print(currencyString)
                    arrProducts.append(product)
                }
                
                self.subscriptionProducts = arrProducts
            
            
            
                completion(true)
                
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("🟦🟦🟦🟦🟦🟦🟦 invalidProductId: " + invalidProductId)
            }
            else {
                print("🟦🟦🟦🟦🟦🟦🟦 Error: ", result.error ?? ":-(")
            }
        }
    }
    
    func formatPrice(product: SKProduct) -> String {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .currency//.currency
        formatter.locale                = product.priceLocale
        //formatter.maximumFractionDigits = 0
        return formatter.string(from: product.price) ?? ""
    }

    func completeTransaction()
    {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                default:break
                }
            }
        }
    }
    
    func cancelPurchase(){
//        UIApplication.shared.open(URL(string: "https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions")!, options: [:]) { (Bool) in
//        }
        
        DispatchQueue.main.async {
            UIApplication.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!, options: [:]) { (Bool) in
            }
        }
    }
    
    func restorePurchase(completion: @escaping (Bool) -> Void) {
        AppLoader.shared.addLoader()
            SwiftyStoreKit.restorePurchases(atomically: true) { results in
                AppLoader.shared.removeLoader()
                if results.restoreFailedPurchases.count > 0 {
                    Alert.shared.showSnackBar("Restore Failed")
                }
                else if results.restoredPurchases.count > 0 {
    //                GFunction.shared.showSnackBar("Restore Success")
                    print("Restore Success: \(results.restoredPurchases)")
    //                UserPurchase.isPremiumUser = true
                    
//                    AppDelegate.shared.appleReceiptValidator({ (success) in
//
//                         GFunction.shared.removeLoader()
//                        if success{
//                            GFunction.shared.showSnackBar("Restore Success")
//                        }
//                        else{
//                            GFunction.shared.showSnackBar("Restore Failed, Either you haven't purchased any in app or you have cancelled in app")
//                        }
//                    })
//
                    
                }
                else {
                    Alert.shared.showSnackBar("Nothing to Restore")
                }
            }
        }
}
