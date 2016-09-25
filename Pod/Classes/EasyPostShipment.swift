//
//  EasyPostShipment.swift
//  Pods
//
//  Created by William Welbes on 10/5/15.
//
//

import Foundation

public struct EasyPostShipmentMessage {
    public var carrier:String = ""
    public var message:String = ""
}

open class EasyPostShipment {
    open var id:String?
    
    open var mode:String?
    
    open var toAddress:EasyPostAddress?
    open var fromAddress:EasyPostAddress?
    
    open var parcel:EasyPostParcel?
    
    open var rates:[EasyPostRate] = []
    
    open var postageLabel:EasyPostLabel?
    
    open var trackingCode:String?
    open var referenceNumber:String?
    open var refundStatus:String?
    open var batchStatus:String?
    open var batchMessage:String?
    
    open var selectedRate:EasyPostRate?
    
    open var createdAt:Date?
    open var updatedAt:Date?
    
    open var messages:[EasyPostShipmentMessage] = []
    
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
        
        if let postageLabelDict = jsonDictionary["postage_label"] as? NSDictionary {
            postageLabel = EasyPostLabel(jsonDictionary: postageLabelDict)
        }
        
        if let stringValue = jsonDictionary["tracking_code"] as? String {
            trackingCode = stringValue
        }
        
        if let stringValue = jsonDictionary["reference"] as? String {
            referenceNumber = stringValue
        }
        
        if let stringValue = jsonDictionary["refund_status"] as? String {
            refundStatus = stringValue
        }
        
        if let stringValue = jsonDictionary["batch_status"] as? String {
            batchStatus = stringValue
        }
        
        if let stringValue = jsonDictionary["batch_message"] as? String {
            batchMessage = stringValue
        }
        
        if let rateDict = jsonDictionary["selected_rate"] as? NSDictionary {
            selectedRate = EasyPostRate(jsonDictionary: rateDict)
        }
        
        if let messagesArray = jsonDictionary["messages"] as? NSArray {
            for messageElement in messagesArray {
                if let messageDict = messageElement as? NSDictionary {
                    var message = EasyPostShipmentMessage()
                    if let stringValue = messageDict["carrier"] as? String {
                        message.carrier = stringValue
                    }
                    if let stringValue = messageDict["message"] as? String {
                        message.message = stringValue
                    }
                    self.messages.append(message)
                }
            }
        }
        
        if let stringValue = jsonDictionary["created_at"] as? String {
            createdAt = dateFormatter.date(from: stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.date(from: stringValue)
        }
    }
}
