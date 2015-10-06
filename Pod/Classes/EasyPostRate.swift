//
//  EasyPostRate.swift
//  Pods
//
//  Created by William Welbes on 10/5/15.
//
//

import Foundation

public class EasyPostRate {
    public var id:String?
    
    public var service:String?
    public var carrier:String?
    public var currency:String?
    public var deliveryDays:NSNumber?
    public var deliveryDate:NSDate?
    public var deliveryDateGuaranteed:Bool = false
    public var rate:String?
    
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
        
        if let stringValue = jsonDictionary["service"] as? String {
            service = stringValue
        }
        
        if let stringValue = jsonDictionary["carrier"] as? String {
            carrier = stringValue
        }
        
        if let stringValue = jsonDictionary["currency"] as? String {
            currency = stringValue
        }
        
        if let numberValue = jsonDictionary["delivery_days"] as? NSNumber {
            deliveryDays = numberValue
        }
        
        if let stringValue = jsonDictionary["delivery_date"] as? String {
            deliveryDate = dateFormatter.dateFromString(stringValue)
        }
        
        if let stringValue = jsonDictionary["created_at"] as? String {
            createdAt = dateFormatter.dateFromString(stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.dateFromString(stringValue)
        }
    }
}