//
//  EasyPostParcel.swift
//  Pods
//
//  Created by William Welbes on 10/5/15.
//
//

import Foundation

public class EasyPostParcel {
    public var id:String?

    public var length:NSNumber?     //Float in inches
    public var width:NSNumber?      //Float in inches
    public var height:NSNumber?     //Float in inches
    
    public var predefinedPackage:String?     //Predefined package types as defined by EasyPost for carriers
    
    public var weight:NSNumber = 0.0    //Float in ounces
    
    public var createdAt:NSDate?
    public var updatedAt:NSDate?
    
    public init() {
        
    }
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"   //2013-04-22T05:40:57Z
        
        if let stringValue = jsonDictionary["id"] as? String {
            id = stringValue
        }
    
        if let numberValue = jsonDictionary["length"] as? NSNumber {
            length = numberValue
        }
        
        if let numberValue = jsonDictionary["width"] as? NSNumber {
            width = numberValue
        }
        
        if let numberValue = jsonDictionary["height"] as? NSNumber {
            height = numberValue
        }
        
        if let stringValue = jsonDictionary["predefined_package"] as? String {
            predefinedPackage = stringValue
        }
        
        if let numberValue = jsonDictionary["weight"] as? NSNumber {
            weight = numberValue
        }
        
        if let stringValue = jsonDictionary["created_at"] as? String {
            createdAt = dateFormatter.dateFromString(stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.dateFromString(stringValue)
        }
    }
    
}