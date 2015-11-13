//
//  EasyPostBuyResponse.swift
//  Pods
//
//  Created by William Welbes on 10/6/15.
//
//

import Foundation

public class EasyPostBuyResponse {
    
    public var postageLabel:EasyPostLabel?
    
    public var trackingCode:String?
    
    public var selectedRate:EasyPostRate?
    
    public init() {
        
    }
    
    public init(jsonDictionary:NSDictionary) {
        //Load the JSON dictionary
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"   //2013-04-22T05:40:57Z
        
        if let postageLabelDict = jsonDictionary["postage_label"] as? NSDictionary {
            postageLabel = EasyPostLabel(jsonDictionary: postageLabelDict)
        }
        
        if let stringValue = jsonDictionary["tracking_code"] as? String {
            trackingCode = stringValue
        }
        
        if let rateDict = jsonDictionary["selected_rate"] as? NSDictionary {
            selectedRate = EasyPostRate(jsonDictionary: rateDict)
        }
        
    }
}