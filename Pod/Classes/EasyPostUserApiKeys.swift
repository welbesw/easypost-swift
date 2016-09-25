//
//  EasyPostUserApiKeys.swift
//  Pods
//
//  Created by William Welbes on 11/3/15.
//
//

import Foundation

enum EasyPostUserApiKeyMode : String {
    case Production = "production"
    case Test = "test"
}

open class EasyPostUserApiKeys {
    open var userId:String?
    open var productionKey:String?
    open var testKey:String?
    
    public init() {
        
    }
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary
        
        if let stringValue = jsonDictionary["id"] as? String {
            userId = stringValue
        }
        
        if let keysArray = jsonDictionary["keys"] as? NSArray {
            for keyItem in keysArray {
                if let keyDict = keyItem as? NSDictionary {
                    var keyMode:EasyPostUserApiKeyMode?
                    var key:String?
                    if let stringValue = keyDict["mode"] as? String {
                        if let mode = EasyPostUserApiKeyMode(rawValue: stringValue) {
                            keyMode = mode
                        }
                    }
                    
                    if let stringValue = keyDict["key"] as? String {
                        key = stringValue
                    }
                    
                    if(key != nil && keyMode != nil) {
                        switch(keyMode!) {
                        case .Production:
                            productionKey = key
                        case .Test:
                            testKey = key
                        }
                    }
                }
            }
        }
    }
    
}
