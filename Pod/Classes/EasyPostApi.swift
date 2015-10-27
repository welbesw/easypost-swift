//
//  EasyPostApi.swift
//  Pods
//
//  Created by William Welbes on 10/4/15.
//
//

import Foundation
import Alamofire

public class EasyPostApi {
    
    let errorDomain = "com.technomagination.EasyPostApi"
    
    var apiToken = ""               //Pass in via setCredentials
    var apiBaseUrl = ""             //Pass in via setCredentials
    
    var alamofireManager: Alamofire.Manager!
    
    //Define a shared instance method to return a singleton of the API manager
    public class var sharedInstance : EasyPostApi {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : EasyPostApi? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = EasyPostApi()
        }
        return Static.instance!
    }
    
    public init() {
        
        initializeAlamofire()
    }
    
    public init(token: String, baseUrl: String) {
        
        setCredentials(token, baseUrl: baseUrl)
        
        initializeAlamofire()
    }
    
    func initializeAlamofire() {
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Accept"] = "application/json"
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
    }
    
    //Set the credentials to use with the API
    public func setCredentials(token: String, baseUrl: String) {
        self.apiToken = token
        self.apiBaseUrl = baseUrl
    }
    
    func getAuthHeader() -> [String : String] {
        let user = self.apiToken
        
        let credentialData = "\(user):".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        return ["Authorization": "Basic \(base64Credentials)"]
    }
    
    //Use key string format for how the keys will be formed: "address[id]" should be address[%ELEMENT%]
    func paramtersFromAddress(address:EasyPostAddress, keyStringFormat:String) -> [String : AnyObject] {
        var parameters = [String : AnyObject]()
        
        if let id = address.id {
            parameters.updateValue(id, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString: "id"))
        }
        if let street1 = address.street1 {
            parameters.updateValue(street1, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"street1"))
        }
        if let street2 = address.street2 {
            parameters.updateValue(street2, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"street2"))
        }
        if let city = address.city {
            parameters.updateValue(city, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"city"))
        }
        if let state = address.state {
            parameters.updateValue(state, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"state"))
        }
        if let zip = address.zip {
            parameters.updateValue(zip, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"zip"))
        }
        if let country = address.country {
            parameters.updateValue(country, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"country"))
        }
        if let name = address.name {
            parameters.updateValue(name, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"name"))
        }
        if let company = address.company {
            parameters.updateValue(company, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"company"))
        }
        if let phone = address.phone {
            parameters.updateValue(phone, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"phone"))
        }
        if let email = address.email {
            parameters.updateValue(email, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"email"))
        }
        if let isResidentatial = address.isResidential {
            parameters.updateValue(isResidentatial, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"residential"))
        }
        
        return parameters
    }
    
    func paramtersFromParcel(parcel:EasyPostParcel, keyStringFormat:String) -> [String : AnyObject] {
        var parameters = [String : AnyObject]()
        
        if let id = parcel.id {
            parameters.updateValue(id, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"id"))
        }
        if let length = parcel.length {
            parameters.updateValue(length, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"length"))
        }
        if let width = parcel.width {
            parameters.updateValue(width, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"width"))
        }
        if let height = parcel.height {
            parameters.updateValue(height, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"height"))
        }
        if let predefinedPackaged = parcel.predefinedPackage {
            parameters.updateValue(predefinedPackaged, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"predefined_package"))
        }
        
        parameters.updateValue(parcel.weight, forKey: keyStringFormat.stringByReplacingOccurrencesOfString("%ELEMENT%", withString:"weight"))
        
        return parameters
    }
    
    func parametersForShipment(toAddress:EasyPostAddress, fromAddress:EasyPostAddress, parcel:EasyPostParcel, carrierTypeIds:[String]?) -> [String : AnyObject] {
        var parameters = [String : AnyObject]()
        
        if let toAddressId = toAddress.id {
            parameters.updateValue(toAddressId, forKey: "shipment[to_address][id]")
        } else {
            parameters += paramtersFromAddress(toAddress, keyStringFormat: "shipment[to_address][%ELEMENT%]")
        }
        
        if let fromAddressId = fromAddress.id {
            parameters.updateValue(fromAddressId, forKey: "shipment[from_address][id]")
        } else {
            parameters += paramtersFromAddress(toAddress, keyStringFormat: "shipment[from_address][%ELEMENT%]")
        }
        
        if let parcelId = parcel.id {
            parameters.updateValue(parcelId, forKey: "shipment[parcel][id]")
        } else {
            parameters += paramtersFromParcel(parcel, keyStringFormat: "shipment[parcel][%ELEMENT%]")
        }
        
        if let carriers = carrierTypeIds {
            for var index = 0; index < carriers.count; ++index {
                parameters.updateValue(carriers[index], forKey: "[carrier_accounts][\(index)][id]")
            }
        }
        
        return parameters
    }
    
    func checkForApiResultError(resultDict:NSDictionary) -> NSError? {
        var error:NSError? = nil
        if let errorDict = resultDict["error"] as? NSDictionary {
            var userInfo = [String : AnyObject]()
            if let code = errorDict["code"] as? String {
                userInfo.updateValue(code, forKey: NSLocalizedFailureReasonErrorKey)
            }
            if let message = errorDict["message"] as? String {
                userInfo.updateValue(message, forKey: NSLocalizedDescriptionKey)
            }
            error = NSError(domain: "com.technomagination.EasyPostApi", code: 1, userInfo: userInfo)
        }
        return error
    }
    
    //Post and address model and get an address object with id populated back
    public func postAddress(address:EasyPostAddress, completion: (result: EasyPostResult<EasyPostAddress>) -> ()) {
        
        let parameters = paramtersFromAddress(address, keyStringFormat:"address[%ELEMENT%]")
        
        alamofireManager.request(.POST, apiBaseUrl + "addresses", parameters:parameters, headers:getAuthHeader())
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let resultDict = result.value as? NSDictionary {
                        
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(result: EasyPostResult.Failure(error))
                        } else {
                            let address = EasyPostAddress(jsonDictionary: resultDict)
                    
                            completion(result: EasyPostResult.Success(address))
                        }
                    } else {
                        print("Result was successful, but blank.")
                        completion(result: EasyPostResult.Failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(result.error)
                    
                    completion(result: EasyPostResult.Failure(result.error!))
                }
        }
    }
    
    public func verifyAddress(addressId:String, completion: (result: EasyPostResult<EasyPostAddress>) -> ()) {
        
        alamofireManager.request(.GET, apiBaseUrl + "addresses/\(addressId)/verify", headers:getAuthHeader())
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let resultDict = result.value as? NSDictionary {
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(result: EasyPostResult.Failure(error))
                        } else {
                            if let addressDict = resultDict["address"] as? NSDictionary {
                                let address = EasyPostAddress(jsonDictionary: addressDict)
                            
                                completion(result: EasyPostResult.Success(address))
                            } else {
                                let userInfo = [NSLocalizedDescriptionKey : "address element was not found in results"]
                                completion(result: EasyPostResult.Failure(NSError(domain: self.errorDomain, code: 2, userInfo: userInfo)))
                            }
                        }
                    } else {
                        print("Result was successful, but blank.")
                        completion(result: EasyPostResult.Failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(result.error)
                    
                    completion(result: EasyPostResult.Failure(result.error!))
                }
        }
    }
    
    public func postParcel(parcel:EasyPostParcel, completion: (result: EasyPostResult<EasyPostParcel>) -> ()) {
        let parameters = paramtersFromParcel(parcel, keyStringFormat: "parcel[%ELEMENT%]")
        
        alamofireManager.request(.POST, apiBaseUrl + "parcels", parameters:parameters, headers:getAuthHeader())
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let resultDict = result.value as? NSDictionary {
                        
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(result: EasyPostResult.Failure(error))
                        } else {
                            let parcel = EasyPostParcel(jsonDictionary: resultDict)
                            
                            completion(result: EasyPostResult.Success(parcel))
                        }
                    } else {
                        print("Result was successful, but blank.")
                        completion(result: EasyPostResult.Failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(result.error)
                    
                    completion(result: EasyPostResult.Failure(result.error!))
                }
        }
    }
    
    //If the shipment and parcel objects you pass in have id's defined, those will be used and the rest of the parameters will be ignored.  If you pass in objects that don't have id's defined, the parameters will be used to create the objects on the back end
    public func postShipment(toAddress:EasyPostAddress, fromAddress:EasyPostAddress, parcel:EasyPostParcel, completion: (result: EasyPostResult<EasyPostShipment>) -> ()) {
        postShipment(toAddress, fromAddress: fromAddress, parcel: parcel, carrierTypeIds: nil, completion: completion)
    }
    
    public func postShipment(toAddress:EasyPostAddress, fromAddress:EasyPostAddress, parcel:EasyPostParcel, carrierTypeIds:[String]?, completion: (result: EasyPostResult<EasyPostShipment>) -> ()) {
        
        let parameters = parametersForShipment(toAddress, fromAddress: fromAddress, parcel: parcel, carrierTypeIds: carrierTypeIds)
        
        alamofireManager.request(.POST, apiBaseUrl + "shipments", parameters:parameters, headers:getAuthHeader())
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let resultDict = result.value as? NSDictionary {
                        
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(result: EasyPostResult.Failure(error))
                        } else {
                            let shipment = EasyPostShipment(jsonDictionary: resultDict)
                            
                            completion(result: EasyPostResult.Success(shipment))
                        }
                    } else {
                        print("Result was successful, but blank.")
                        completion(result: EasyPostResult.Failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(result.error)
                    
                    completion(result: EasyPostResult.Failure(result.error!))
                }
        }
    }
    
    public func buyShipment(shipmentId:String, rateId:String, completion: (result: EasyPostResult<EasyPostBuyResponse>) -> ()) {
        buyShipment(shipmentId, rateId: rateId, labelFormat: nil, completion: completion)
    }
    
    public func buyShipment(shipmentId:String, rateId:String, labelFormat:String?, completion: (result: EasyPostResult<EasyPostBuyResponse>) -> ()) {
    
        var parameters = ["rate[id]" : rateId]

        if let format = labelFormat {
            parameters.updateValue(format, forKey: "label_format")
        }
        
        alamofireManager.request(.POST, apiBaseUrl + "shipments/\(shipmentId)/buy", parameters:parameters, headers:getAuthHeader())
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let resultDict = result.value as? NSDictionary {
                        
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(result: EasyPostResult.Failure(error))
                        } else {
                            let buyResponse = EasyPostBuyResponse(jsonDictionary: resultDict)
                            
                            completion(result: EasyPostResult.Success(buyResponse))
                        }
                    } else {
                        print("Result was successful, but blank.")
                        completion(result: EasyPostResult.Failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(result.error)
                    
                    completion(result: EasyPostResult.Failure(result.error!))
                }
        }
    }
    
    public func labelForShipment(shipmentId:String, labelFormat:String, completion: (result: EasyPostResult<EasyPostShipment>) -> ()) {
        let parameters = ["file_format" : labelFormat]
        
        alamofireManager.request(.GET, apiBaseUrl + "shipments/\(shipmentId)/label", parameters:parameters, headers:getAuthHeader())
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let resultDict = result.value as? NSDictionary {
                        
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(result: EasyPostResult.Failure(error))
                        } else {
                            let shipment = EasyPostShipment(jsonDictionary: resultDict)
                            
                            completion(result: EasyPostResult.Success(shipment))
                        }
                    } else {
                        print("Result was successful, but blank.")
                        completion(result: EasyPostResult.Failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(result.error)
                    
                    completion(result: EasyPostResult.Failure(result.error!))
                }
        }
    }
    
    public func getCarrierTypes(completion: (result: EasyPostResult<[EasyPostCarrierType]>) -> ()) {
        
        alamofireManager.request(.GET, apiBaseUrl + "carrier_types", headers:getAuthHeader())
            .responseJSON { (request, response, result) in
                
                if(result.isSuccess) {
                    
                    if let resultArray = result.value as? NSArray {
                        
                        var carrierTypes = [EasyPostCarrierType]()
                        
                        for carrierItem in resultArray {
                            if let carrierDict = carrierItem as? NSDictionary {
                                let carrierType = EasyPostCarrierType(jsonDictionary: carrierDict)
                                carrierTypes.append(carrierType)
                            }
                        }
                        completion(result: EasyPostResult.Success(carrierTypes))
                    } else {
                        print("getCarrierTypes result was successful, but blank.")
                        completion(result: EasyPostResult.Failure(NSError(domain: self.errorDomain, code: 3, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(result.error)
                    
                    completion(result: EasyPostResult.Failure(result.error!))
                }
        }
    }
}