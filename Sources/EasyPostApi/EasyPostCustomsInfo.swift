//
//  EasyPostCustomsInfo.swift
//  EasyPostApi
//
//  Created by Sachin Vas on 19/04/18.
//

import Foundation

open class EasyPostCustomsInfo {
    
    public enum ContentType: String {
        case other
        case sample
        case gift
        case documents
        case merchandise
        case returned_goods
    }
    
    public enum RestrictionType: String {
        case none
        case other
        case quarantine
        case sanitary_phytosanitary_inspection
    }
    
    public enum NonDeliveryOption: String {
        case `return`
        case abandon
    }
    
    open var id: String?
    open var customsItems: [EasyPostCustomsItem]?
    open var contentsType: ContentType?
    open var contentsExplanation: String?
    open var restrictionType: RestrictionType?
    open var restrictionComments: String?
    open var customsCertify: NSNumber?
    open var customsSigner: String?
    open var nonDeliveryOption: NonDeliveryOption = .return
    open var eelPfc: String?
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
        
        if let arrayValue = jsonDictionary["customs_items"] as? Array<Dictionary<String, Any>> {
            customsItems = []
            for value in arrayValue {
                customsItems?.append(EasyPostCustomsItem(jsonDictionary: value))
            }
        }
        
        if let stringValue = jsonDictionary["contents_type"] as? String {
            contentsType = ContentType(rawValue: stringValue)
        }
        
        if let stringValue = jsonDictionary["contents_explanation"] as? String {
            contentsExplanation = stringValue
        }
        
        if let stringValue = jsonDictionary["restriction_type"] as? String {
            restrictionType = RestrictionType(rawValue: stringValue)
        }
        
        if let stringValue = jsonDictionary["restriction_comments"] as? String {
            restrictionComments = stringValue
        }
        
        if let boolValue = jsonDictionary["customs_certify"] as? NSNumber {
            customsCertify = boolValue
        }
        
        if let stringValue = jsonDictionary["customs_signer"] as? String {
            customsSigner = stringValue
        }
        
        if let stringValue = jsonDictionary["non_delivery_option"] as? String {
            nonDeliveryOption = NonDeliveryOption(rawValue: stringValue) ?? .return
        }
        
        if let stringValue = jsonDictionary["eel_pfc"] as? String {
            eelPfc = stringValue
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
        
        if let custom_items = customsItems  {
            var jsonDict: [[String: Any]] = []
            for custom_item in custom_items {
                jsonDict.append(custom_item.jsonDict())
            }
            dict.updateValue(jsonDict as AnyObject, forKey: "customs_items")
        }
        
        if contentsType != nil {
            dict.updateValue(contentsType!.rawValue as AnyObject, forKey: "contents_type")
        }
        
        if contentsExplanation != nil {
            dict.updateValue(contentsExplanation! as AnyObject, forKey: "contents_explanation")
        }
        
        if restrictionType != nil {
            dict.updateValue(restrictionType!.rawValue as AnyObject, forKey: "restriction_type")
        }
        
        if restrictionComments != nil {
            dict.updateValue(restrictionComments! as AnyObject, forKey: "restriction_comments")
        }
        
        if customsCertify != nil {
            dict.updateValue(customsCertify! as AnyObject, forKey: "customs_certify")
        }
        
        if customsSigner != nil {
            dict.updateValue(customsSigner! as AnyObject, forKey: "customs_signer")
        }
        
        dict.updateValue(nonDeliveryOption.rawValue as AnyObject, forKey: "non_delivery_option")
        
        if eelPfc != nil {
            dict.updateValue(eelPfc! as AnyObject, forKey: "eel_pfc")
        }
        
        return dict
    }
    
}
