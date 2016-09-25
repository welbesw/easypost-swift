//
//  EasyPostApi.swift
//  Pods
//
//  Created by William Welbes on 10/4/15.
//
//

import Foundation
import Alamofire

open class EasyPostApi {
    
    //Define a shared instance method to return a singleton of the API manager
    open static var sharedInstance = EasyPostApi()
    
    let errorDomain = "com.technomagination.EasyPostApi"
    
    var apiToken = ""               //Pass in via setCredentials
    var apiBaseUrl = ""             //Pass in via setCredentials
    
    public init() {
        //Nothing more to do here now
    }
    
    public init(token: String, baseUrl: String) {
        
        setCredentials(token, baseUrl: baseUrl)
    }
    
    //Set the credentials to use with the API
    open func setCredentials(_ token: String, baseUrl: String) {
        self.apiToken = token
        self.apiBaseUrl = baseUrl
    }
    
    func getAuthHeader() -> [String : String] {
        let user = self.apiToken
        
        let credentialData = "\(user):".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        
        return ["Authorization": "Basic \(base64Credentials)", "Accept" : "application/json"]
    }
    
    //Use key string format for how the keys will be formed: "address[id]" should be address[%ELEMENT%]
    func paramtersFromAddress(_ address:EasyPostAddress, keyStringFormat:String) -> [String : AnyObject] {
        var parameters = [String : AnyObject]()
        
        if let id = address.id {
            parameters.updateValue(id as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with: "id"))
        }
        if let street1 = address.street1 {
            parameters.updateValue(street1 as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"street1"))
        }
        if let street2 = address.street2 {
            parameters.updateValue(street2 as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"street2"))
        }
        if let city = address.city {
            parameters.updateValue(city as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"city"))
        }
        if let state = address.state {
            parameters.updateValue(state as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"state"))
        }
        if let zip = address.zip {
            parameters.updateValue(zip as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"zip"))
        }
        if let country = address.country {
            parameters.updateValue(country as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"country"))
        }
        if let name = address.name {
            parameters.updateValue(name as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"name"))
        }
        if let company = address.company {
            parameters.updateValue(company as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"company"))
        }
        if let phone = address.phone {
            parameters.updateValue(phone as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"phone"))
        }
        if let email = address.email {
            parameters.updateValue(email as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"email"))
        }
        if let isResidentatial = address.isResidential {
            parameters.updateValue(isResidentatial as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"residential"))
        }
        
        return parameters
    }
    
    func paramtersFromParcel(_ parcel:EasyPostParcel, keyStringFormat:String) -> [String : AnyObject] {
        var parameters = [String : AnyObject]()
        
        if let id = parcel.id {
            parameters.updateValue(id as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"id"))
        }
        if let length = parcel.length {
            parameters.updateValue(length, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"length"))
        }
        if let width = parcel.width {
            parameters.updateValue(width, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"width"))
        }
        if let height = parcel.height {
            parameters.updateValue(height, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"height"))
        }
        if let predefinedPackaged = parcel.predefinedPackage {
            parameters.updateValue(predefinedPackaged as AnyObject, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"predefined_package"))
        }
        
        parameters.updateValue(parcel.weight, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"weight"))
        
        return parameters
    }
    
    func parametersForShipment(_ toAddress:EasyPostAddress, fromAddress:EasyPostAddress, parcel:EasyPostParcel, carrierAccountIds:[String]?, referenecNumber:String?) -> [String : AnyObject] {
        var parameters = [String : AnyObject]()
        
        if let toAddressId = toAddress.id {
            parameters.updateValue(toAddressId as AnyObject, forKey: "shipment[to_address][id]")
        } else {
            parameters += paramtersFromAddress(toAddress, keyStringFormat: "shipment[to_address][%ELEMENT%]")
        }
        
        if let fromAddressId = fromAddress.id {
            parameters.updateValue(fromAddressId as AnyObject, forKey: "shipment[from_address][id]")
        } else {
            parameters += paramtersFromAddress(fromAddress, keyStringFormat: "shipment[from_address][%ELEMENT%]")
        }
        
        if let parcelId = parcel.id {
            parameters.updateValue(parcelId as AnyObject, forKey: "shipment[parcel][id]")
        } else {
            parameters += paramtersFromParcel(parcel, keyStringFormat: "shipment[parcel][%ELEMENT%]")
        }
        
        if let carriers = carrierAccountIds {
            for index in 0 ..< carriers.count {
                parameters.updateValue(carriers[index] as AnyObject, forKey: "shipment[carrier_accounts][\(index)][id]")
            }
        }
        
        if let reference = referenecNumber {
            parameters.updateValue(reference as AnyObject, forKey: "shipment[reference]")
        }
        
        return parameters
    }
    
    func checkForApiResultError(_ resultDict:NSDictionary) -> NSError? {
        var error:NSError? = nil
        if let errorDict = resultDict["error"] as? NSDictionary {
            var userInfo = [String : AnyObject]()
            if let code = errorDict["code"] as? String {
                userInfo.updateValue(code as AnyObject, forKey: NSLocalizedFailureReasonErrorKey)
            }
            if let message = errorDict["message"] as? String {
                userInfo.updateValue(message as AnyObject, forKey: NSLocalizedDescriptionKey)
            }
            error = NSError(domain: "com.technomagination.EasyPostApi", code: 1, userInfo: userInfo)
        }
        return error
    }
    
    //Post and address model and get an address object with id populated back
    open func postAddress(_ address:EasyPostAddress, completion: @escaping (_ result: EasyPostResult<EasyPostAddress>) -> ()) {
        
        let parameters = paramtersFromAddress(address, keyStringFormat:"address[%ELEMENT%]")
        
        Alamofire.request(apiBaseUrl + "addresses", method: .post, parameters: parameters, headers:getAuthHeader())
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let resultDict = response.result.value as? NSDictionary {
                        
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(EasyPostResult.failure(error))
                        } else {
                            let address = EasyPostAddress(jsonDictionary: resultDict)
                    
                            completion(EasyPostResult.success(address))
                        }
                    } else {
                        print("Result was successful, but blank.")
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(response.result.error)
                    
                    completion(EasyPostResult.failure(response.result.error!))
                }
        }
    }
    
    open func verifyAddress(_ addressId:String, completion: @escaping (_ result: EasyPostResult<EasyPostAddress>) -> ()) {
        
        Alamofire.request(apiBaseUrl + "addresses/\(addressId)/verify", method: .get, headers: getAuthHeader())
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let resultDict = response.result.value as? NSDictionary {
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(EasyPostResult.failure(error))
                        } else {
                            if let addressDict = resultDict["address"] as? NSDictionary {
                                let address = EasyPostAddress(jsonDictionary: addressDict)
                            
                                completion(EasyPostResult.success(address))
                            } else {
                                let userInfo = [NSLocalizedDescriptionKey : "address element was not found in results"]
                                completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: userInfo)))
                            }
                        }
                    } else {
                        print("Result was successful, but blank.")
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(response.result.error)
                    
                    completion(EasyPostResult.failure(response.result.error!))
                }
        }
    }
    
    open func postParcel(_ parcel:EasyPostParcel, completion: @escaping (_ result: EasyPostResult<EasyPostParcel>) -> ()) {
        let parameters = paramtersFromParcel(parcel, keyStringFormat: "parcel[%ELEMENT%]")
        
        Alamofire.request(apiBaseUrl + "parcels", method: .post, parameters: parameters, headers: getAuthHeader())
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let resultDict = response.result.value as? NSDictionary {
                        
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(EasyPostResult.failure(error))
                        } else {
                            let parcel = EasyPostParcel(jsonDictionary: resultDict)
                            
                            completion(EasyPostResult.success(parcel))
                        }
                    } else {
                        print("Result was successful, but blank.")
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(response.result.error)
                    
                    completion(EasyPostResult.failure(response.result.error!))
                }
        }
    }
    
    //If the shipment and parcel objects you pass in have id's defined, those will be used and the rest of the parameters will be ignored.  If you pass in objects that don't have id's defined, the parameters will be used to create the objects on the back end
    open func postShipment(_ toAddress:EasyPostAddress, fromAddress:EasyPostAddress, parcel:EasyPostParcel, completion: @escaping (_ result: EasyPostResult<EasyPostShipment>) -> ()) {
        postShipment(toAddress, fromAddress: fromAddress, parcel: parcel, carrierAccountIds: nil, referenceNumber: nil, completion: completion)
    }
    
    open func postShipment(_ toAddress:EasyPostAddress, fromAddress:EasyPostAddress, parcel:EasyPostParcel, carrierAccountIds:[String]?, referenceNumber:String?, completion: @escaping (_ result: EasyPostResult<EasyPostShipment>) -> ()) {
        
        let parameters = parametersForShipment(toAddress, fromAddress: fromAddress, parcel: parcel, carrierAccountIds: carrierAccountIds, referenecNumber: referenceNumber)
        
        Alamofire.request(apiBaseUrl + "shipments", method: .post, parameters: parameters, headers: getAuthHeader())
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let resultDict = response.result.value as? NSDictionary {
                        
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(EasyPostResult.failure(error))
                        } else {
                            let shipment = EasyPostShipment(jsonDictionary: resultDict)
                            
                            completion(EasyPostResult.success(shipment))
                        }
                    } else {
                        print("Result was successful, but blank.")
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(response.result.error)
                    
                    completion(EasyPostResult.failure(response.result.error!))
                }
        }
    }
    
    open func buyShipment(_ shipmentId:String, rateId:String, completion: @escaping (_ result: EasyPostResult<EasyPostBuyResponse>) -> ()) {
        buyShipment(shipmentId, rateId: rateId, labelFormat: nil, completion: completion)
    }
    
    open func buyShipment(_ shipmentId:String, rateId:String, labelFormat:String?, completion: @escaping (_ result: EasyPostResult<EasyPostBuyResponse>) -> ()) {
    
        var parameters = ["rate[id]" : rateId]

        if let format = labelFormat {
            parameters.updateValue(format, forKey: "label_format")
        }
        
        Alamofire.request(apiBaseUrl + "shipments/\(shipmentId)/buy", method: .post, parameters: parameters, headers: getAuthHeader())
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let resultDict = response.result.value as? NSDictionary {
                        
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(EasyPostResult.failure(error))
                        } else {
                            let buyResponse = EasyPostBuyResponse(jsonDictionary: resultDict)
                            
                            completion(EasyPostResult.success(buyResponse))
                        }
                    } else {
                        print("Result was successful, but blank.")
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(response.result.error)
                    
                    completion(EasyPostResult.failure(response.result.error!))
                }
        }
    }
    
    open func getShipments(onlyPurchased:Bool, pageSize:Int, beforeShipmentId:String?, completion: @escaping (_ result: EasyPostResult<[EasyPostShipment]>) -> ()) {
        
        var parameters:[String : AnyObject] = ["purchased" : NSNumber(value: onlyPurchased as Bool), "page_size" : pageSize as AnyObject]
        if let beforeId = beforeShipmentId {
            parameters.updateValue(beforeId as AnyObject, forKey: "before_id")
        }
        
        Alamofire.request(apiBaseUrl + "shipments", method: .get, parameters:parameters, headers:getAuthHeader())
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let resultDict = response.result.value as? NSDictionary {
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(EasyPostResult.failure(error))
                        } else {
                            if let shipmentsArray = resultDict["shipments"] as? NSArray {
                                var shipments = [EasyPostShipment]()
                                
                                for shipmentItem in shipmentsArray {
                                    if let shipmentDict = shipmentItem as? NSDictionary {
                                        let shipment = EasyPostShipment(jsonDictionary: shipmentDict)
                                        shipments.append(shipment)
                                    }
                                }
                                completion(EasyPostResult.success(shipments))
                            } else {
                                print("getShipments result was successful, but shipments array was not found.")
                                completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 5, userInfo: nil)))
                            }
                        }
                    } else {
                        print("getShipments result was successful, but not as expected.")
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 5, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(response.result.error)
                    
                    completion(EasyPostResult.failure(response.result.error!))
                }
        }
    }
    
    open func labelForShipment(_ shipmentId:String, labelFormat:String, completion: @escaping (_ result: EasyPostResult<EasyPostShipment>) -> ()) {
        let parameters = ["file_format" : labelFormat]
        
        Alamofire.request(apiBaseUrl + "shipments/\(shipmentId)/label", method: .get, parameters: parameters, headers: getAuthHeader())
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let resultDict = response.result.value as? NSDictionary {
                        
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(EasyPostResult.failure(error))
                        } else {
                            let shipment = EasyPostShipment(jsonDictionary: resultDict)
                            
                            completion(EasyPostResult.success(shipment))
                        }
                    } else {
                        print("Result was successful, but blank.")
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(response.result.error)
                    
                    completion(EasyPostResult.failure(response.result.error!))
                }
        }
    }
    
    open func getCarrierAccounts(_ completion: @escaping (_ result: EasyPostResult<[EasyPostCarrierAccount]>) -> ()) {
        
        Alamofire.request(apiBaseUrl + "carrier_accounts", method: .get, headers:getAuthHeader())
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let resultArray = response.result.value as? NSArray {
                        
                        var carrierAccounts = [EasyPostCarrierAccount]()
                    
                        for carrierItem in resultArray {
                            if let carrierDict = carrierItem as? NSDictionary {
                                let carrierAccount = EasyPostCarrierAccount(jsonDictionary: carrierDict)
                                carrierAccounts.append(carrierAccount)
                            }
                        }
                        completion(EasyPostResult.success(carrierAccounts))
                    } else if let resultDict = response.result.value as? NSDictionary {
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(EasyPostResult.failure(error))
                        } else {
                            completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 4, userInfo: nil)))
                        }
                    } else {
                        print("getCarrierAccounts result was successful, but blank.")
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 4, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(response.result.error)
                    
                    completion(EasyPostResult.failure(response.result.error!))
                }
        }
    }
    
    open func getCarrierTypes(_ completion: @escaping (_ result: EasyPostResult<[EasyPostCarrierType]>) -> ()) {
        
        Alamofire.request(apiBaseUrl + "carrier_types", method: .get, headers: getAuthHeader())
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let resultArray = response.result.value as? NSArray {
                        
                        var carrierTypes = [EasyPostCarrierType]()
                        
                        for carrierItem in resultArray {
                            if let carrierDict = carrierItem as? NSDictionary {
                                let carrierType = EasyPostCarrierType(jsonDictionary: carrierDict)
                                carrierTypes.append(carrierType)
                            }
                        }
                        completion(EasyPostResult.success(carrierTypes))
                    } else if let resultDict = response.result.value as? NSDictionary {
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(EasyPostResult.failure(error))
                        } else {
                            completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 3, userInfo: nil)))
                        }
                    } else {
                        print("getCarrierTypes result was successful, but blank.")
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 3, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(response.result.error)
                    
                    completion(EasyPostResult.failure(response.result.error!))
                }
        }
    }
    
    open func getUserApiKeys( _ completion: @escaping (_ result: EasyPostResult<EasyPostUserApiKeys>) -> ()) {
        
        Alamofire.request(apiBaseUrl + "api_keys", method: .get, headers: getAuthHeader())
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let resultDict = response.result.value as? NSDictionary {
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(EasyPostResult.failure(error))
                        } else {
                            
                            let userApiKeys = EasyPostUserApiKeys(jsonDictionary: resultDict)
                            completion(EasyPostResult.success(userApiKeys))
                            
                        }
                    } else {
                        print("getUserApiKeys result was successful, but blank.")
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 6, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(response.result.error)
                    
                    completion(EasyPostResult.failure(response.result.error!))
                }
        }
    }
    
    open func requestRefund(_ shipmentId:String, completion: @escaping (_ result: EasyPostResult<EasyPostRefund>) -> ()) {
        Alamofire.request(apiBaseUrl + "shipments/\(shipmentId)/refund", method: .get, headers: getAuthHeader())
            .responseJSON { response in
                
                if(response.result.isSuccess) {
                    
                    if let resultDict = response.result.value as? NSDictionary {
                        if let error = self.checkForApiResultError(resultDict) {
                            completion(EasyPostResult.failure(error))
                        } else {
                            
                            let refund = EasyPostRefund(jsonDictionary: resultDict)
                            completion(EasyPostResult.success(refund))
                            
                        }
                    } else {
                        print("requestRefund result was successful, but blank.")
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 7, userInfo: nil)))
                    }
                    
                    
                } else {
                    print(response.result.error)
                    
                    completion(EasyPostResult.failure(response.result.error!))
                }
        }
    }
}
