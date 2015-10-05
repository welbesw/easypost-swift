//
//  EasyPostApi.swift
//  Pods
//
//  Created by William Welbes on 10/4/15.
//
//

import Foundation

public class EasypostApi {
    
    //Define a shared instance method to return a singleton of the API manager
    public class var sharedInstance : EasypostApi {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : EasypostApi? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = EasypostApi()
        }
        return Static.instance!
    }
}