//
//  EasyPostLabel.swift
//  Pods
//
//  Created by William Welbes on 10/6/15.
//
//

import Foundation

open class EasyPostLabel {
    open var id:String?
    
    open var integratedForm:String?
    open var labelDate:Date?
    open var labelResolution:NSNumber?
    open var labelSize:String?
    open var labelType:String?
    open var labelFileType:String?
    open var labelUrl:String?
    open var labelPdfUrl:String?
    open var labelEpl2Url:String?
    open var labelZplUrl:String?
    
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
        
        if let stringValue = jsonDictionary["integrated_form"] as? String {
            integratedForm = stringValue
        }
        
        if let stringValue = jsonDictionary["label_date"] as? String {
            labelDate = dateFormatter.date(from: stringValue)
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
            createdAt = dateFormatter.date(from: stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.date(from: stringValue)
        }
    }
}
