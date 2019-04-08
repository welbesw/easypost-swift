//
//  EasyPostCustomsItem.swift
//  EasyPostApi
//
//  Created by Sachin Vas on 19/04/18.
//

import UIKit

open class EasyPostCustomsItem {
    open var id: String?
    open var itemDescription: String?
    open var quantity: NSNumber?
    open var weight: NSNumber?
    open var value: NSNumber?
    open var hsTariffNumber: NSNumber?
    open var originCountry: String?
    open var createdAt: Date?
    open var updatedAt: Date?
    
    public init() {
        
    }
    
    public init(jsonDictionary: [String: Any]) {
        //Load the JSON dictionary
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"   //2013-04-22T05:40:57Z
        
        if let stringValue = jsonDictionary["id"] as? String {
            id = stringValue
        }
        
        if let stringValue = jsonDictionary["description"] as? String {
            itemDescription = stringValue
        }
        
        if let intValue = jsonDictionary["quantity"] as? NSNumber {
            quantity = intValue
        }
        
        if let intValue = jsonDictionary["weight"] as? NSNumber {
            weight = intValue
        }
        
        if let intValue = jsonDictionary["value"] as? NSNumber {
            value = intValue
        }
        
        if let intValue = jsonDictionary["hs_tariff_number"] as? NSNumber {
            hsTariffNumber = intValue
        }
        
        if let stringValue = jsonDictionary["origin_country"] as? String {
            originCountry = stringValue
        }
        
        if let stringValue = jsonDictionary["created_at"] as? String {
            createdAt = dateFormatter.date(from: stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.date(from: stringValue)
        }
    }
    
    open func jsonDict() -> [String: Any] {
        var dict = [String: Any]()
        
        if id != nil {
            dict.updateValue(id! as AnyObject, forKey: "id")
        }
        
        if itemDescription != nil {
            dict.updateValue(itemDescription! as AnyObject, forKey: "description")
        }
        
        if quantity != nil {
            dict.updateValue(quantity! as AnyObject, forKey: "quantity")
        }
        
        if weight != nil {
            dict.updateValue(weight! as AnyObject, forKey: "weight")
        }
        
        if value != nil {
            dict.updateValue(value! as AnyObject, forKey: "value")
        }
        
        if hsTariffNumber != nil {
            dict.updateValue(hsTariffNumber! as AnyObject, forKey: "hs_traiff_number")
        }
        
        if originCountry != nil {
            dict.updateValue(originCountry! as AnyObject, forKey: "origin_country")
        }
        
        return dict
    }
}
