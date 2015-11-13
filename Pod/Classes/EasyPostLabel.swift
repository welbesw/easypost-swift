//
//  EasyPostLabel.swift
//  Pods
//
//  Created by William Welbes on 10/6/15.
//
//

import Foundation

public class EasyPostLabel {
    public var id:String?
    
    public var integratedForm:String?
    public var labelDate:NSDate?
    public var labelResolution:NSNumber?
    public var labelSize:String?
    public var labelType:String?
    public var labelFileType:String?
    public var labelUrl:String?
    public var labelPdfUrl:String?
    public var labelEpl2Url:String?
    public var labelZplUrl:String?
    
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
        
        if let stringValue = jsonDictionary["integrated_form"] as? String {
            integratedForm = stringValue
        }
        
        if let stringValue = jsonDictionary["label_date"] as? String {
            labelDate = dateFormatter.dateFromString(stringValue)
        }
        
        if let numberValue = jsonDictionary["label_resolution"] as? NSNumber {
            labelResolution = numberValue
        }
        
        if let stringValue = jsonDictionary["label_size"] as? String {
            labelSize = stringValue
        }
        
        if let stringValue = jsonDictionary["label_type"] as? String {
            labelType = stringValue
        }
        
        if let stringValue = jsonDictionary["label_file_type"] as? String {
            labelFileType = stringValue
        }
        
        if let stringValue = jsonDictionary["label_url"] as? String {
            labelUrl = stringValue
        }
        
        if let stringValue = jsonDictionary["label_pdf_url"] as? String {
            labelPdfUrl = stringValue
        }
        
        if let stringValue = jsonDictionary["label_epl2_url"] as? String {
            labelEpl2Url = stringValue
        }
        
        if let stringValue = jsonDictionary["label_zpl_url"] as? String {
            labelZplUrl = stringValue
        }
        
        if let stringValue = jsonDictionary["created_at"] as? String {
            createdAt = dateFormatter.dateFromString(stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.dateFromString(stringValue)
        }
    }
}