//
//  EasyPostApi.swift
//  Pods
//
//  Created by William Welbes on 10/4/15.
//
//

import Foundation

open class EasyPostApi {
    
    //Define a shared instance method to return a singleton of the API manager
    public static var sharedInstance = EasyPostApi()
    
    let errorDomain = "com.technomagination.EasyPostApi"
    
    var apiToken = ""               //Pass in via setCredentials
    var apiBaseUrl = ""             //Pass in via setCredentials
    
    public var logHTTPRequestAndResponse = false
    
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
    func paramtersFromAddress(_ address:EasyPostAddress, keyStringFormat:String) -> [String : String] {
        var parameters = [String : String]()
        
        if let id = address.id {
            parameters.updateValue(id, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with: "id"))
        }
        if let street1 = address.street1 {
            parameters.updateValue(street1, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"street1"))
        }
        if let street2 = address.street2 {
            parameters.updateValue(street2, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"street2"))
        }
        if let city = address.city {
            parameters.updateValue(city, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"city"))
        }
        if let state = address.state {
            parameters.updateValue(state, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"state"))
        }
        if let zip = address.zip {
            parameters.updateValue(zip, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"zip"))
        }
        if let country = address.country {
            parameters.updateValue(country, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"country"))
        }
        if let name = address.name {
            parameters.updateValue(name, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"name"))
        }
        if let company = address.company {
            parameters.updateValue(company, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"company"))
        }
        if let phone = address.phone {
            parameters.updateValue(phone, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"phone"))
        }
        if let email = address.email {
            parameters.updateValue(email, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"email"))
        }
        if let isResidentatial = address.isResidential {
            parameters.updateValue(isResidentatial ? "true" : "false", forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"residential"))
        }
        
        return parameters
    }
    
    func paramtersFromParcel(_ parcel:EasyPostParcel, keyStringFormat:String) -> [String : String] {
        var parameters = [String : String]()
        
        if let id = parcel.id {
            parameters.updateValue(id, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"id"))
        }
        if let length = parcel.length {
            parameters.updateValue(length.stringValue, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"length"))
        }
        if let width = parcel.width {
            parameters.updateValue(width.stringValue, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"width"))
        }
        if let height = parcel.height {
            parameters.updateValue(height.stringValue, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"height"))
        }
        if let predefinedPackaged = parcel.predefinedPackage {
            parameters.updateValue(predefinedPackaged, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"predefined_package"))
        }
        
        parameters.updateValue(parcel.weight.stringValue, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"weight"))
        
        return parameters
    }
    
    func parametersForCustomsItem(_ customsItem: EasyPostCustomsItem, keyStringFormat:String) -> [String : String] {
        var parameters = [String : String]()
        
        if let id = customsItem.id {
            parameters.updateValue(id, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"id"))
        }
        
        if let description = customsItem.itemDescription {
            parameters.updateValue(description, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"description"))
        }
        
        if let quantity = customsItem.quantity {
            parameters.updateValue(quantity.stringValue, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"quantity"))
        }
        
        if let weight = customsItem.weight {
            parameters.updateValue(weight.stringValue, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"weight"))
        }
        
        if let value = customsItem.value {
            parameters.updateValue(value.stringValue, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"weight"))
        }
        
        if let hs_tariff_number = customsItem.hsTariffNumber {
            parameters.updateValue(hs_tariff_number.stringValue, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"hs_tariff_number"))
        }
        
        if let origin_country = customsItem.originCountry {
            parameters.updateValue(origin_country, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"origin_country"))
        }
                
        return parameters
    }
    
    func parametersForCustomsInfo(_ customsInfo: EasyPostCustomsInfo, keyStringFormat:String) -> [String : String] {
        var parameters = [String : String]()
        
        if let id = customsInfo.id {
            parameters.updateValue(id, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"id"))
        }
        
        if let customsItems = customsInfo.customsItems {
            var index = 0
            for customsItem in customsItems {
                if let customsItemId = customsItem.id {
                    parameters.updateValue(customsItemId, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"custom_items").appending("[\(index)][id]"))
                } else {
                    parameters += parametersForCustomsItem(customsItem, keyStringFormat: "customs_info[customs_items][\(index)][%ELEMENT%]")
                }
                index += 1
            }
        }
        
        if let contentsType = customsInfo.contentsType?.rawValue {
            parameters.updateValue(contentsType, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"contents_type"))
        }
        
        if let contentsExplanation = customsInfo.contentsExplanation {
            parameters.updateValue(contentsExplanation, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"contents_explanation"))
        }
        
        if let restrictionType = customsInfo.restrictionType?.rawValue {
            parameters.updateValue(restrictionType, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"restriction_type"))
        }
        
        if let restrictionComments = customsInfo.restrictionComments {
            parameters.updateValue(restrictionComments, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"restriction_comments"))
        }
        
        if let customsCertify = customsInfo.customsCertify {
            parameters.updateValue(customsCertify.stringValue, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"customs_certify"))
        }
        
        if let customsSigner = customsInfo.customsSigner {
            parameters.updateValue(customsSigner, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"customs_signer"))
        }
        
        parameters.updateValue(customsInfo.nonDeliveryOption.rawValue, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"non_delivery_option"))

        if let eelPfc = customsInfo.eelPfc {
            parameters.updateValue(eelPfc, forKey: keyStringFormat.replacingOccurrences(of: "%ELEMENT%", with:"eel_pfc"))
        }
        
        return parameters
    }
    
    func parametersForShipment(_ toAddress:EasyPostAddress, fromAddress:EasyPostAddress, parcel:EasyPostParcel, customsInfo:EasyPostCustomsInfo?, carrierAccountIds:[String]?, referenecNumber:String?) -> [String : String] {
        var parameters = [String : String]()
        
        if let toAddressId = toAddress.id {
            parameters.updateValue(toAddressId, forKey: "shipment[to_address][id]")
        } else {
            parameters += paramtersFromAddress(toAddress, keyStringFormat: "shipment[to_address][%ELEMENT%]")
        }
        
        if let fromAddressId = fromAddress.id {
            parameters.updateValue(fromAddressId, forKey: "shipment[from_address][id]")
        } else {
            parameters += paramtersFromAddress(fromAddress, keyStringFormat: "shipment[from_address][%ELEMENT%]")
        }
        
        if let parcelId = parcel.id {
            parameters.updateValue(parcelId, forKey: "shipment[parcel][id]")
        } else {
            parameters += paramtersFromParcel(parcel, keyStringFormat: "shipment[parcel][%ELEMENT%]")
        }
        
        if let customs_info = customsInfo {
            if let customs_info_id = customs_info.id {
                parameters.updateValue(customs_info_id, forKey: "shipment[customs_info][id]")
            } else {
                parameters += parametersForCustomsInfo(customs_info, keyStringFormat: "shipment[customs_info][%ELEMENT%]")
            }
        }
        
        if let carriers = carrierAccountIds {
            for index in 0 ..< carriers.count {
                parameters.updateValue(carriers[index], forKey: "shipment[carrier_accounts][\(index)][id]")
            }
        }
        
        if let reference = referenecNumber {
            parameters.updateValue(reference, forKey: "shipment[reference]")
        }
        
        return parameters
    }
    
    //Post an address model and get an address object with id populated back
    open func postAddress(_ address:EasyPostAddress, completion: @escaping (_ result: EasyPostResult<EasyPostAddress>) -> ()) {
        
        let parameters = paramtersFromAddress(address, keyStringFormat:"address[%ELEMENT%]")

        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "addresses", method: .post, parameters: parameters, headers: getAuthHeader()) else {
            return
        }

        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultDict = json as? [String: Any] {
                    let address = EasyPostAddress(jsonDictionary: resultDict)

                    completion(EasyPostResult.success(address))
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
            }
        }
    }
    
    open func verifyAddress(_ addressId:String, completion: @escaping (_ result: EasyPostResult<EasyPostAddress>) -> ()) {

        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "addresses/\(addressId)/verify", method: .get, headers: getAuthHeader()) else {
            return
        }

        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultDict = json as? [String: Any] {
                    if let addressDict = resultDict["address"] as? [String: Any] {
                        let address = EasyPostAddress(jsonDictionary: addressDict)

                        completion(EasyPostResult.success(address))
                    } else {
                        let userInfo = [NSLocalizedDescriptionKey : "address element was not found in results"]
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: userInfo)))
                    }
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
            }
        }
    }
    
    open func postParcel(_ parcel:EasyPostParcel, completion: @escaping (_ result: EasyPostResult<EasyPostParcel>) -> ()) {
        let parameters = paramtersFromParcel(parcel, keyStringFormat: "parcel[%ELEMENT%]")

        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "parcels", method: .post, parameters: parameters, headers: getAuthHeader()) else {
            return
        }

        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultDict = json as? [String: Any] {
                    let parcel = EasyPostParcel(jsonDictionary: resultDict)

                    completion(EasyPostResult.success(parcel))
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
            }
        }
    }
    
    open func postCustomsItem(_ customsItem: EasyPostCustomsItem, completion: @escaping (_ result: EasyPostResult<EasyPostCustomsItem>) -> ()) {
        let parameters = parametersForCustomsItem(customsItem, keyStringFormat: "customs_item[%ELEMENT%]")
        
        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "customs_items", method: .post, parameters: parameters, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultDict = json as? [String: Any] {
                    let customItem = EasyPostCustomsItem(jsonDictionary: resultDict)
                    completion(EasyPostResult.success(customItem))
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
            }
        }
    }
    
    open func postCustomsInfo(_ customsInfo: EasyPostCustomsInfo, completion: @escaping (_ result: EasyPostResult<EasyPostCustomsInfo>) -> ()) {
        let parameters = parametersForCustomsInfo(customsInfo, keyStringFormat: "customs_info[%ELEMENT%]")
        
        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "customs_items", method: .post, parameters: parameters, headers: getAuthHeader()) else {
            return
        }
        
        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultDict = json as? [String: Any] {
                    let customInfo = EasyPostCustomsInfo(jsonDictionary: resultDict)
                    completion(EasyPostResult.success(customInfo))
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
            }
        }
    }
    
    //If the shipment and parcel objects you pass in have id's defined, those will be used and the rest of the parameters will be ignored.  If you pass in objects that don't have id's defined, the parameters will be used to create the objects on the back end
    open func postShipment(_ toAddress:EasyPostAddress, fromAddress:EasyPostAddress, parcel:EasyPostParcel, customsInfo:EasyPostCustomsInfo? = nil, completion: @escaping (_ result: EasyPostResult<EasyPostShipment>) -> ()) {
        postShipment(toAddress, fromAddress: fromAddress, parcel: parcel, carrierAccountIds: nil, referenceNumber: nil, customsInfo: customsInfo, completion: completion)
    }
    
    open func postShipment(_ toAddress:EasyPostAddress, fromAddress:EasyPostAddress, parcel:EasyPostParcel, carrierAccountIds:[String]?, referenceNumber:String?, customsInfo:EasyPostCustomsInfo? = nil, completion: @escaping (_ result: EasyPostResult<EasyPostShipment>) -> ()) {
        
        let parameters = parametersForShipment(toAddress, fromAddress: fromAddress, parcel: parcel, customsInfo: customsInfo, carrierAccountIds: carrierAccountIds, referenecNumber: referenceNumber)

        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "shipments", method: .post, parameters: parameters, headers: getAuthHeader()) else {
            return
        }

        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultDict = json as? [String: Any] {
                    let shipment = EasyPostShipment(jsonDictionary: resultDict)

                    completion(EasyPostResult.success(shipment))
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
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

        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "shipments/\(shipmentId)/buy", method: .post, parameters: parameters, headers: getAuthHeader()) else {
            return
        }

        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultDict = json as? [String: Any] {
                    let buyResponse = EasyPostBuyResponse(jsonDictionary: resultDict)

                    completion(EasyPostResult.success(buyResponse))
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
            }
        }
    }
    
    open func getShipments(onlyPurchased:Bool, pageSize:Int, beforeShipmentId:String?, completion: @escaping (_ result: EasyPostResult<[EasyPostShipment]>) -> ()) {
        
        var parameters:[String : String] = ["purchased" : onlyPurchased ? "true" : "false", "page_size" : String(pageSize)]
        if let beforeId = beforeShipmentId {
            parameters.updateValue(beforeId, forKey: "before_id")
        }

        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "shipments", method: .get, parameters: parameters, headers: getAuthHeader()) else {
            return
        }

        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultDict = json as? [String: Any] {
                    if let shipmentsArray = resultDict["shipments"] as? NSArray {
                        var shipments = [EasyPostShipment]()

                        for shipmentItem in shipmentsArray {
                            if let shipmentDict = shipmentItem as? [String: Any] {
                                let shipment = EasyPostShipment(jsonDictionary: shipmentDict)
                                shipments.append(shipment)
                            }
                        }
                        completion(EasyPostResult.success(shipments))
                    } else {
                        print("getShipments result was successful, but shipments array was not found.")
                        completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 5, userInfo: nil)))
                    }
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
            }
        }
    }
    
    open func labelForShipment(_ shipmentId:String, labelFormat:String, completion: @escaping (_ result: EasyPostResult<EasyPostShipment>) -> ()) {
        let parameters = ["file_format" : labelFormat]

        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "shipments/\(shipmentId)/label", method: .get, parameters: parameters, headers: getAuthHeader()) else {
            return
        }

        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultDict = json as? [String: Any] {
                    let shipment = EasyPostShipment(jsonDictionary: resultDict)

                    completion(EasyPostResult.success(shipment))
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
            }
        }
    }
    
    open func getCarrierAccounts(_ completion: @escaping (_ result: EasyPostResult<[EasyPostCarrierAccount]>) -> ()) {

        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "carrier_accounts", method: .get, headers: getAuthHeader()) else {
            return
        }

        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultArray = json as? [Any] {
                    var carrierAccounts = [EasyPostCarrierAccount]()

                    for carrierItem in resultArray {
                        if let carrierDict = carrierItem as? [String: Any] {
                            let carrierAccount = EasyPostCarrierAccount(jsonDictionary: carrierDict)
                            carrierAccounts.append(carrierAccount)
                        }
                    }
                    completion(EasyPostResult.success(carrierAccounts))
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
            }
        }
    }
    
    open func getCarrierTypes(_ completion: @escaping (_ result: EasyPostResult<[EasyPostCarrierType]>) -> ()) {

        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "carrier_types", method: .get, headers: getAuthHeader()) else {
            return
        }

        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultArray = json as? [Any] {
                    var carrierTypes = [EasyPostCarrierType]()

                    for carrierItem in resultArray {
                        if let carrierDict = carrierItem as? NSDictionary {
                            let carrierType = EasyPostCarrierType(jsonDictionary: carrierDict)
                            carrierTypes.append(carrierType)
                        }
                    }
                    completion(EasyPostResult.success(carrierTypes))
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
            }
        }
    }
    
    open func getUserApiKeys( _ completion: @escaping (_ result: EasyPostResult<EasyPostUserApiKeys>) -> ()) {

        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "api_keys", method: .get, headers: getAuthHeader()) else {
            return
        }

        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultDict = json as? [String: Any] {
                    let userApiKeys = EasyPostUserApiKeys(jsonDictionary: resultDict)
                    completion(EasyPostResult.success(userApiKeys))
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
            }
        }
    }
    
    open func requestRefund(_ shipmentId:String, completion: @escaping (_ result: EasyPostResult<EasyPostRefund>) -> ()) {

        guard let request = URLRequest.newRequest(urlString: apiBaseUrl + "shipments/\(shipmentId)/refund", method: .get, headers: getAuthHeader()) else {
            return
        }

        URLSession.newSession().apiDataTask(with: request, logRequestAndResponse: logHTTPRequestAndResponse) { (result) in
            switch result {
            case .success (let json):
                if let resultDict = json as? [String: Any] {
                    let refund = EasyPostRefund(jsonDictionary: resultDict)
                    completion(EasyPostResult.success(refund))
                } else {
                    print("Result was successful, but blank.")
                    completion(EasyPostResult.failure(NSError(domain: self.errorDomain, code: 2, userInfo: nil)))
                }
                break
            case .failure (let error):
                print(error)
                completion(EasyPostResult.failure(error))
                break
            }
        }
    }
}
