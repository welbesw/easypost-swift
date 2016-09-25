//
//  EasyPostCarrierAccount.swift
//  Pods
//
//  Created by William Welbes on 10/27/15.
//
//

import Foundation

open class EasyPostCarrierAccount {
    
    open var id:String?
    open var type:String?
    open var accountDescription:String?
    open var readable:String?
    open var logo:String?
    
    open var createdAt:Date?
    open var updatedAt:Date?
    
    public init() {
        
    }
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
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
            createdAt = dateFormatter.date(from: stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.date(from: stringValue)
        }
    }
    
}
