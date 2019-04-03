//
//  DefaultsManager.swift
//  BigcommerceApi
//
//  Created by William Welbes on 7/7/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit

open class DefaultsManager: NSObject {
   
    //Define a shared instance method to return a singleton of the manager
    public static var sharedInstance = DefaultsManager()
   
    let userDefaults = UserDefaults.standard
    
    var orderStatusIdFilter: Int? = nil //Allows the user to filter based on a specific order status
    
    var apiToken: String? {
        get {
            return userDefaults.string(forKey: "ApiToken")
        }
        set(newValue) {
            userDefaults.setValue(newValue, forKey: "ApiToken")
        }
    }
    
    var apiBaseUrl: String? {
        get {
            return userDefaults.string(forKey: "ApiBaseUrl")
        }
        set(newValue) {
            userDefaults.setValue(newValue, forKey: "ApiBaseUrl")
        }
    }
    
    var apiCredentialsAreSet: Bool {
        get {
            return self.apiToken != nil && self.apiBaseUrl != nil
        }
    }

}
