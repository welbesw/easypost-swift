//
//  EasyPostForm.swift
//  EasyPostApi
//
//  Created by Sachin Vas on 20/04/18.
//

import Foundation

open class EasyPostForm {
    
    open var id: String?
    open var type: String?
    open var url: URL?
    
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
        
        if let stringValue = jsonDictionary["form_type"] as? String {
            type = stringValue
        }
        
        if let stringValue = jsonDictionary["form_url"] as? String, let urlValue = URL.init(string: stringValue) {
            url = urlValue
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
        
        if type != nil {
            dict.updateValue(type! as AnyObject, forKey: "form_type")
        }
        
        if url != nil {
            dict.updateValue(url! as AnyObject, forKey: "form_url")
        }
        
        return dict
    }
}
