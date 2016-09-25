//
//  EasyPostAddress.swift
//  Pods
//
//  Created by William Welbes on 10/5/15.
//
//

import Foundation

open class EasyPostAddress {
    open var id:String?
    open var street1:String?
    open var street2:String?
    open var city:String?
    open var state:String?
    open var zip:String?
    open var country:String?
    open var name:String?
    open var company:String?
    open var phone:String?
    open var email:String?
    open var isResidential:Bool?
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
            createdAt = dateFormatter.date(from: stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.date(from: stringValue)
        }
    }
    
    open func jsonDict() -> NSDictionary {
        var dict = [String : AnyObject]()
        
        if id != nil {
            dict.updateValue(id! as AnyObject, forKey: "id")
        }
        
        if street1 != nil {
            dict.updateValue(street1! as AnyObject, forKey: "street1")
        }
        
        if street2 != nil {
            dict.updateValue(street2! as AnyObject, forKey: "street2")
        }
        
        if city != nil {
            dict.updateValue(city! as AnyObject, forKey: "city")
        }
        
        if state != nil {
            dict.updateValue(state! as AnyObject, forKey: "state")
        }
        
        if zip != nil {
            dict.updateValue(zip! as AnyObject, forKey: "zip")
        }
        
        if country != nil {
            dict.updateValue(country! as AnyObject, forKey: "country")
        }
        
        if name != nil {
            dict.updateValue(name! as AnyObject, forKey: "name")
        }
        
        if company != nil {
            dict.updateValue(company! as AnyObject, forKey: "company")
        }
        
        if phone != nil {
            dict.updateValue(phone! as AnyObject, forKey: "phone")
        }
        
        if email != nil {
            dict.updateValue(email! as AnyObject, forKey: "email")
        }
        
        if isResidential != nil {
            dict.updateValue(isResidential! as AnyObject, forKey: "residential")
        }
        
        return dict as NSDictionary
    }

}
