//
//  EasyPostTracker.swift
//  EasyPostApi
//
//  Created by Sachin Vas on 20/04/18.
//

import Foundation

open class EasyPostTracker {
    
    public enum Status: String {
        case unknown
        case pre_transit
        case in_transit
        case out_for_delivery
        case delivered
        case available_for_pickup
        case return_to_sender
        case failure
        case cancelled
        case error
    }
    
    open var id: String?
    open var trackingCode: String?
    open var status: Status?
    open var estDeliveryDate: Date?
    open var publicURL: URL?
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
        
        if let stringValue = jsonDictionary["tracking_code"] as? String {
            trackingCode = stringValue
        }
        
        if let stringValue = jsonDictionary["status"] as? String {
            status = Status(rawValue: stringValue)
        }
        
        if let stringValue = jsonDictionary["est_delivery_date"] as? String {
            estDeliveryDate = dateFormatter.date(from: stringValue)
        }
        
        if let stringValue = jsonDictionary["form_url"] as? String, let urlValue = URL.init(string: stringValue) {
            publicURL = urlValue
        }

        if let stringValue = jsonDictionary["created_at"] as? String {
            createdAt = dateFormatter.date(from: stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.date(from: stringValue)
        }
    }
}
