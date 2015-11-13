//
//  EasyPostAddress.swift
//  Pods
//
//  Created by William Welbes on 10/5/15.
//
//

import Foundation

public class EasyPostAddress {
    public var id:String?
    public var street1:String?
    public var street2:String?
    public var city:String?
    public var state:String?
    public var zip:String?
    public var country:String?
    public var name:String?
    public var company:String?
    public var phone:String?
    public var email:String?
    public var isResidential:Bool?
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
        
        if let stringValue = jsonDictionary["street1"] as? String {
            street1 = stringValue
        }
        
        if let stringValue = jsonDictionary["street2"] as? String {
            street2 = stringValue
        }
        
        if let stringValue = jsonDictionary["city"] as? String {
            city = stringValue
        }
        
        if let stringValue = jsonDictionary["state"] as? String {
            state = stringValue
        }
        
        if let stringValue = jsonDictionary["zip"] as? String {
            zip = stringValue
        }
        
        if let stringValue = jsonDictionary["country"] as? String {
            country = stringValue
        }
        
        if let stringValue = jsonDictionary["name"] as? String {
            name = stringValue
        }
        
        if let stringValue = jsonDictionary["company"] as? String {
            company = stringValue
        }
        
        if let stringValue = jsonDictionary["phone"] as? String {
            phone = stringValue
        }
        
        if let stringValue = jsonDictionary["email"] as? String {
            email = stringValue
        }
        
        if let numberValue = jsonDictionary["residential"] as? NSNumber {
            isResidential = numberValue.boolValue
        }
        
        if let stringValue = jsonDictionary["created_at"] as? String {
            createdAt = dateFormatter.dateFromString(stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.dateFromString(stringValue)
        }
    }
    
    public func jsonDict() -> NSDictionary {
        var dict = [String : AnyObject]()
        
        if id != nil {
            dict.updateValue(id!, forKey: "id")
        }
        
        if street1 != nil {
            dict.updateValue(street1!, forKey: "street1")
        }
        
        if street2 != nil {
            dict.updateValue(street2!, forKey: "street2")
        }
        
        if city != nil {
            dict.updateValue(city!, forKey: "city")
        }
        
        if state != nil {
            dict.updateValue(state!, forKey: "state")
        }
        
        if zip != nil {
            dict.updateValue(zip!, forKey: "zip")
        }
        
        if country != nil {
            dict.updateValue(country!, forKey: "country")
        }
        
        if name != nil {
            dict.updateValue(name!, forKey: "name")
        }
        
        if company != nil {
            dict.updateValue(company!, forKey: "company")
        }
        
        if phone != nil {
            dict.updateValue(phone!, forKey: "phone")
        }
        
        if email != nil {
            dict.updateValue(email!, forKey: "email")
        }
        
        if isResidential != nil {
            dict.updateValue(isResidential!, forKey: "residential")
        }
        
        return dict
    }

}