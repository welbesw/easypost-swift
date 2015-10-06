//
//  EasyPostShipment.swift
//  Pods
//
//  Created by William Welbes on 10/5/15.
//
//

import Foundation

public class EasyPostShipment {
    public var id:String?
    
    public var mode:String?
    
    public var toAddress:EasyPostAddress?
    public var fromAddress:EasyPostAddress?
    
    public var parcel:EasyPostParcel?
    
    public var rates:[EasyPostRate] = []
    
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
        
        if let stringValue = jsonDictionary["mode"] as? String {
            mode = stringValue
        }
        
        if let addressDict = jsonDictionary["to_address"] as? NSDictionary {
            self.toAddress = EasyPostAddress(jsonDictionary: addressDict)
        }
        
        if let addressDict = jsonDictionary["from_address"] as? NSDictionary {
            self.fromAddress = EasyPostAddress(jsonDictionary: addressDict)
        }
        
        if let parcelDict = jsonDictionary["parcel"] as? NSDictionary {
            self.parcel = EasyPostParcel(jsonDictionary: parcelDict)
        }
        
        if let ratesArray = jsonDictionary["rates"] as? NSArray {
            for rateElement in ratesArray {
                if let rateDict = rateElement as? NSDictionary {
                    let rate = EasyPostRate(jsonDictionary: rateDict)
                    self.rates.append(rate)
                }
            }
        }
        
        if let stringValue = jsonDictionary["created_at"] as? String {
            createdAt = dateFormatter.dateFromString(stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.dateFromString(stringValue)
        }
    }
}
