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
    
    func paramtersFromAddress(address:EasyPostAddress) -> [String : AnyObject] {
        var parameters = [String : AnyObject]()
        
        if let id = address.id {
            parameters.updateValue(id, forKey: "address[id]")
        }
        if let street1 = address.street1 {
            parameters.updateValue(street1, forKey: "address[street1]")
        }
        if let street2 = address.street2 {
            parameters.updateValue(street2, forKey: "address[street2]")
        }
        if let city = address.city {
            parameters.updateValue(city, forKey: "address[city]")
        }
        if let state = address.state {
            parameters.updateValue(state, forKey: "address[state]")
        }
        if let zip = address.zip {
            parameters.updateValue(zip, forKey: "address[zip]")
        }
        if let country = address.country {
            parameters.updateValue(country, forKey: "address[country]")
        }
        if let name = address.name {
            parameters.updateValue(name, forKey: "address[name]")
        }
        if let company = address.company {
            parameters.updateValue(company, forKey: "address[company]")
        }
        if let phone = address.phone {
            parameters.updateValue(phone, forKey: "address[phone]")
        }
        if let email = address.email {
            parameters.updateValue(email, forKey: "address[email]")
        }
        if let isResidentatial = address.isResidential {
            parameters.updateValue(isResidentatial, forKey: "address[residential]")
        }
        
        return parameters
    }
    
    func paramtersFromParcel(parcel:EasyPostParcel) -> [String : AnyObject] {
        var parameters = [String : AnyObject]()
        
        if let id = parcel.id {
            parameters.updateValue(id, forKey: "parcel[id]")
        }
        if let length = parcel.length {
            parameters.updateValue(length, forKey: "parcel[length]")
        }
        if let width = parcel.width {
            parameters.updateValue(width, forKey: "parcel[width]")
        }
        if let height = parcel.height {
            parameters.updateValue(height, forKey: "parcel[height]")
        }
        if let predefinedPackaged = parcel.predefinedPackage {
            parameters.updateValue(predefinedPackaged, forKey: "parcel[predefined_package]")
        }
        
        parameters.updateValue(parcel.weight, forKey: "parcel[weight]")
        
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
        
        let parameters = paramtersFromAddress(address)
        
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
        let parameters = paramtersFromParcel(parcel)
        
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
}