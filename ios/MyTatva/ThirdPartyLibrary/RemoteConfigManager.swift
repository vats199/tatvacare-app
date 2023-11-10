//
//  RemoteConfigManager.swift
//  MyTatva
//
//  Created by DJ on 08/07/22.
//

import UIKit


class RemoteConfigManager: NSObject {
    
    static let shared = RemoteConfigManager()
    
    let remoteConfig = RemoteConfig.remoteConfig()
    
    func initiateRemoteConfig(){
        
        ///For Razor Pay ---------------------
        RazorPayTestKey         = ""//"rzp_test_1mVRchh6qQGlTr"
        RazorPayKey             = ""//"rzp_live_TXnspN3YXFlWPW"
        RazorPayLiveKeySecret   = ""//"HJVwj3x4iCyZaKSAXl1dBw4O"
        
        let defaultRazorPayTestKey          = ["razorpay_key_id_test": "Hello world!" as NSObject]
        let defaultRazorPayLiveKey          = ["razorpay_key_id_live": "Hello world!" as NSObject]
        let defaultRazorPayLiveKeySecret    = ["razorpay_secret_live": "Hello world!" as NSObject]
        
        self.remoteConfig.setDefaults(defaultRazorPayTestKey)
        self.remoteConfig.setDefaults(defaultRazorPayLiveKey)
        self.remoteConfig.setDefaults(defaultRazorPayLiveKeySecret)
        
        ///Firebase flags to hide/show ---------------------
        ///Default values
        hide_chatbot                    = false
        hide_language_page              = false
        hide_engage_page                = false
        hide_leave_query                = false
        hide_email_at                   = false
        hide_ask_an_expert_page         = false
        hide_doctor_says                = false
        hide_diagnostic_test            = false
        hide_engage_discover_comments   = false
        hide_incident_survey            = true
        hide_home_chat_bubble           = false
        hide_home_chat_bubble_hc        = false
        hide_home_bca                   = false
        hide_home_my_device             = false
        is_bcp_with_in_app              = true
        is_hide_discount_on_plan        = true
        is_hide_discount_on_labtest     = true
        is_home_from_react_native       = true
        hide_genai_chatbot              = false

        
        let key_hide_chatbot                = ["hide_chatbot" : false as NSObject]
        let key_hide_language_page          = ["hide_language_page" : false as NSObject]
        let key_hide_engage_page            = ["hide_engage_page" : false as NSObject]
        let hide_leave_query                = ["hide_leave_query" : false as NSObject]
        let hide_email_at                   = ["hide_email_at" : false as NSObject]
        let hide_ask_an_expert_page         = ["hide_ask_an_expert_page" : false as NSObject]
        let hide_doctor_says                = ["hide_doctor_says" : false as NSObject]
        let hide_diagnostic_test            = ["hide_diagnostic_test" : false as NSObject]
        let hide_engage_discover_comments   = ["hide_engage_discover_comments" : false as NSObject]
        let hide_incident_survey            = ["hide_incident_survey" : true as NSObject]
        let hide_home_chat_bubble           = ["hide_home_chat_bubble" : false as NSObject]
        let hide_home_chat_bubble_hc        = ["hide_home_chat_bubble_hc" : false as NSObject]
        let key_hide_home_bca               = ["hide_home_bca" : false as NSObject]
        let key_hide_home_my_device         = ["hide_home_my_device" : false as NSObject]
        let key_is_bcp_with_in_app          = ["is_bcp_with_in_app" : true as NSObject]
        let key_hide_home_spirometer        = ["hide_home_spirometer" : true as NSObject]
        let key_hide_discount_on_labtest    = ["hide_discount_on_labtest" : true as NSObject]
        let key_hide_discount_on_plan       = ["hide_discount_on_plan" : true as NSObject]
        let key_home_from_react_native      = ["home_from_react_native" : true as NSObject]
        let key_hide_genai_chatbot      = ["hide_genai_chatbot" : false as NSObject]
        
        self.remoteConfig.setDefaults(key_hide_chatbot)
        self.remoteConfig.setDefaults(key_hide_language_page)
        self.remoteConfig.setDefaults(key_hide_engage_page)
        self.remoteConfig.setDefaults(hide_leave_query)
        self.remoteConfig.setDefaults(hide_email_at)
        self.remoteConfig.setDefaults(hide_ask_an_expert_page)
        self.remoteConfig.setDefaults(hide_doctor_says)
        self.remoteConfig.setDefaults(hide_diagnostic_test)
        self.remoteConfig.setDefaults(hide_engage_discover_comments)
        self.remoteConfig.setDefaults(hide_incident_survey)
        self.remoteConfig.setDefaults(hide_home_chat_bubble)
        self.remoteConfig.setDefaults(hide_home_chat_bubble_hc)
        self.remoteConfig.setDefaults(key_hide_home_bca)
        self.remoteConfig.setDefaults(key_hide_home_my_device)
        self.remoteConfig.setDefaults(key_is_bcp_with_in_app)
        self.remoteConfig.setDefaults(key_hide_home_spirometer)
        self.remoteConfig.setDefaults(key_hide_discount_on_labtest)
        self.remoteConfig.setDefaults(key_hide_discount_on_plan)
        self.remoteConfig.setDefaults(key_home_from_react_native)
        self.remoteConfig.setDefaults(key_hide_genai_chatbot)
        
        ///For Azure Cloud ---------------------
        let azure_access_key_dev    = ["azure_access_key_dev": "Hello world!" as NSObject]
        let azure_account_name_dev  = ["azure_account_name_dev": "Hello world!" as NSObject]
        let AzureBlobContainer_dev  = ["AzureBlobContainer_dev": "Hello world!" as NSObject]
        
        let azure_access_key_live   = ["azure_access_key_live": "Hello world!" as NSObject]
        let azure_account_name_live = ["azure_account_name_live": "Hello world!" as NSObject]
        let AzureBlobContainer_live = ["AzureBlobContainer_live": "Hello world!" as NSObject]
        
        let azure_account_name_prod = ["azure_account_name_prod": "Hello world!" as NSObject]
        let azure_access_key_prod   = ["azure_access_key_prod": "Hello world!" as NSObject]
        let AzureBlobContainer_prod = ["AzureBlobContainer_prod": "Hello world!" as NSObject]
        
        
        self.remoteConfig.setDefaults(azure_access_key_dev)
        self.remoteConfig.setDefaults(azure_account_name_dev)
        self.remoteConfig.setDefaults(AzureBlobContainer_dev)
        
        self.remoteConfig.setDefaults(azure_access_key_live)
        self.remoteConfig.setDefaults(azure_account_name_live)
        self.remoteConfig.setDefaults(AzureBlobContainer_live)
        
        self.remoteConfig.setDefaults(azure_access_key_prod)
        self.remoteConfig.setDefaults(azure_account_name_prod)
        self.remoteConfig.setDefaults(AzureBlobContainer_prod)
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        self.fetchRemoteConfig()
    }
    
    func fetchRemoteConfig(){
        self.remoteConfig.fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
            guard error == nil else { return }
            print("Got the value from Remote Config!")
            self.remoteConfig.activate()
            self.setNewValues { _ in
                isRemoteConfigFetchDone = true
//                UIApplication.shared.manageLogin()
            }
        }
    }
    
    func setNewValues(completion: ((Bool) -> Void)){
        //Common flag
        //For firebase hide/show flag
        hide_chatbot            = self.remoteConfig.configValue(forKey: "hide_chatbot").boolValue
        hide_language_page      = self.remoteConfig.configValue(forKey: "hide_language_page").boolValue
        hide_engage_page        = self.remoteConfig.configValue(forKey: "hide_engage_page").boolValue
        hide_leave_query        = self.remoteConfig.configValue(forKey: "hide_leave_query").boolValue
        hide_email_at           = self.remoteConfig.configValue(forKey: "hide_email_at").boolValue
        
        hide_ask_an_expert_page         = self.remoteConfig.configValue(forKey: "hide_ask_an_expert_page").boolValue
        hide_doctor_says                = self.remoteConfig.configValue(forKey: "hide_doctor_says").boolValue
        hide_diagnostic_test            = self.remoteConfig.configValue(forKey: "hide_diagnostic_test").boolValue
        hide_engage_discover_comments   = self.remoteConfig.configValue(forKey: "hide_engage_discover_comments").boolValue
        hide_incident_survey            = self.remoteConfig.configValue(forKey: "hide_incident_survey").boolValue
        hide_home_chat_bubble           = self.remoteConfig.configValue(forKey: "hide_home_chat_bubble").boolValue
        hide_home_chat_bubble_hc           = self.remoteConfig.configValue(forKey: "hide_home_chat_bubble_hc").boolValue
        
        hide_home_bca                   = self.remoteConfig.configValue(forKey: "hide_home_bca").boolValue
        hide_home_my_device             = self.remoteConfig.configValue(forKey: "hide_home_my_device").boolValue
        
        is_bcp_with_in_app              = self.remoteConfig.configValue(forKey: "is_bcp_with_in_app").boolValue
        hide_home_spirometer            = self.remoteConfig.configValue(forKey: "hide_home_spirometer").boolValue
        is_hide_discount_on_plan        = self.remoteConfig.configValue(forKey: "hide_discount_on_plan").boolValue
        is_hide_discount_on_labtest     = self.remoteConfig.configValue(forKey: "hide_discount_on_labtest").boolValue
        is_home_from_react_native       = self.remoteConfig.configValue(forKey: "home_from_react_native").boolValue
        hide_genai_chatbot              = self.remoteConfig.configValue(forKey: "hide_genai_chatbot").boolValue
        
        switch NetworkManager.environment {
        case .live:
            ///---------------For production server-------------------
            ///For Razor Pay
            RazorPayKey = remoteConfig.configValue(forKey: "razorpay_key_id_live").stringValue ?? ""
            RazorPayLiveKeySecret = remoteConfig.configValue(forKey: "razorpay_secret_live").stringValue ?? ""
            
            ///For Azure Cloud
            AzureCredentials.kAccessSecretKey = remoteConfig.configValue(forKey: "azure_access_key_live").stringValue ?? ""
            AzureCredentials.kAccountName = remoteConfig.configValue(forKey: "azure_account_name_live").stringValue ?? ""
            BlobContainer.kAppContainer = remoteConfig.configValue(forKey: "AzureBlobContainer_live").stringValue ?? ""
            completion(true)
            
            break
        case .uat:
            ///---------------For UAT server-------------------
            ///For Razor Pay
//            RazorPayKey = remoteConfig.configValue(forKey: "razorpay_key_id_live").stringValue ?? ""
//            RazorPayLiveKeySecret = remoteConfig.configValue(forKey: "razorpay_secret_live").stringValue ?? ""
            RazorPayKey = remoteConfig.configValue(forKey: "razorpay_key_id_test").stringValue ?? ""
            RazorPayLiveKeySecret = remoteConfig.configValue(forKey: "razorpay_secret_live").stringValue ?? ""
            
            ///For Azure Cloud
            AzureCredentials.kAccessSecretKey = remoteConfig.configValue(forKey: "azure_access_key_prod").stringValue ?? ""
            AzureCredentials.kAccountName = remoteConfig.configValue(forKey: "azure_account_name_prod").stringValue ?? ""
            BlobContainer.kAppContainer = remoteConfig.configValue(forKey: "AzureBlobContainer_prod").stringValue ?? ""
            completion(true)
            break
        case .local:
            ///---------------For local server-------------------
            RazorPayKey = remoteConfig.configValue(forKey: "razorpay_key_id_test").stringValue ?? ""
            RazorPayLiveKeySecret = remoteConfig.configValue(forKey: "razorpay_secret_live").stringValue ?? ""
            
            ///For Azure Cloud
            AzureCredentials.kAccessSecretKey = remoteConfig.configValue(forKey: "azure_access_key_dev").stringValue ?? ""
            AzureCredentials.kAccountName = remoteConfig.configValue(forKey: "azure_account_name_dev").stringValue ?? ""
            BlobContainer.kAppContainer = remoteConfig.configValue(forKey: "AzureBlobContainer_dev").stringValue ?? ""
            
            completion(true)
            break
        case .localhost:
            ///---------------For local server-------------------
            RazorPayKey = remoteConfig.configValue(forKey: "razorpay_key_id_test").stringValue ?? ""
            RazorPayLiveKeySecret = remoteConfig.configValue(forKey: "razorpay_secret_live").stringValue ?? ""
            
            ///For Azure Cloud
            AzureCredentials.kAccessSecretKey = remoteConfig.configValue(forKey: "azure_access_key_dev").stringValue ?? ""
            AzureCredentials.kAccountName = remoteConfig.configValue(forKey: "azure_account_name_dev").stringValue ?? ""
            BlobContainer.kAppContainer = remoteConfig.configValue(forKey: "AzureBlobContainer_dev").stringValue ?? ""
            
            completion(true)
            break
        }
    }
}

