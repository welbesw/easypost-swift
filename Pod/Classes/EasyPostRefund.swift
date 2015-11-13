//
//  EasyPostRefund.swift
//  Pods
//
//  Created by William Welbes on 11/9/15.
//
//

import Foundation

public class EasyPostRefund {
    
    public var id:String?
    public var trackingCode:String?
    public var confirmationNumber:String?
    public var status:String?
    public var carrier:String?
    public var shipmentId:String?
    
    public var createdAt:NSDate?
    public var updatedAt:NSDate?
    
    public init() {
        
    }
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"   //2013-04-22T05:40:57Z
        
        if let stringValue = jsonDictionary["id"] as? String {
            id = stringValue
        }
        
        if let stringValue = jsonDictionary["tracking_code"] as? String {
            trackingCode = stringValue
        }
        
        if let stringValue = jsonDictionary["confirmation_number"] as? String {
            confirmationNumber = stringValue
        }
        
        if let stringValue = jsonDictionary["confirmation_number"] as? String {
            confirmationNumber = stringValue
        }

        if let stringValue = jsonDictionary["status"] as? String {
            status = stringValue
        }
        
        if let stringValue = jsonDictionary["carrier"] as? String {
            carrier = stringValue
        }
        
        if let stringValue = jsonDictionary["shipment_id"] as? String {
            shipmentId = stringValue
        }
        
        if let stringValue = jsonDictionary["created_at"] as? String {
            createdAt = dateFormatter.dateFromString(stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.dateFromString(stringValue)
        }
    }
    
}