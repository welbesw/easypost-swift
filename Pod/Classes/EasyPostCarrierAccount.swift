//
//  EasyPostCarrierAccount.swift
//  Pods
//
//  Created by William Welbes on 10/27/15.
//
//

import Foundation

public class EasyPostCarrierAccount {
    
    public var id:String?
    public var type:String?
    public var accountDescription:String?
    public var readable:String?
    public var logo:String?
    
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
        
        if let stringValue = jsonDictionary["type"] as? String {
            type = stringValue
        }
        
        if let stringValue = jsonDictionary["readable"] as? String {
            readable = stringValue
        }
        
        if let stringValue = jsonDictionary["description"] as? String {
            accountDescription = stringValue
        }
        
        if let stringValue = jsonDictionary["logo"] as? String {
            logo = stringValue
        }
        
        if let stringValue = jsonDictionary["created_at"] as? String {
            createdAt = dateFormatter.dateFromString(stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.dateFromString(stringValue)
        }
    }
    
}