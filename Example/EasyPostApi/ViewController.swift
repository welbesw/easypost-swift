//
//  ViewController.swift
//  EasyPostApi
//
//  Created by William Welbes on 10/04/2015.
//  Copyright (c) 2015 William Welbes. All rights reserved.
//

import UIKit
import EasyPostApi

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var companyTextField:UITextField!
    @IBOutlet weak var street1TextField:UITextField!
    @IBOutlet weak var street2TextField:UITextField!
    @IBOutlet weak var cityTextField:UITextField!
    @IBOutlet weak var stateTextField:UITextField!
    @IBOutlet weak var zipTextField:UITextField!
    
    @IBOutlet weak var parcelLength:UITextField!
    @IBOutlet weak var parcelWidth:UITextField!
    @IBOutlet weak var parcelHeight:UITextField!
    @IBOutlet weak var parcelWeight:UITextField!
    
    var currentShipment:EasyPostShipment?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Check if the API credentials have been set and present the view controller if they have note been set
        let defaultsManager = DefaultsManager.sharedInstance
        if !defaultsManager.apiCredentialsAreSet {
            self.performSegue(withIdentifier: "ModalCredentialsSegue", sender: nil)
        } else {
            //Set the API credentials
            EasyPostApi.sharedInstance.setCredentials(defaultsManager.apiToken!, baseUrl: defaultsManager.apiBaseUrl!)
            
            EasyPostApi.sharedInstance.getUserApiKeys({ (result) -> () in
                switch(result) {
                case .failure(let error):
                    print("Error getting user api keys: \((error as NSError).localizedDescription)")
                case .success(let keys):
                    print("Got API keys: production:\(keys.productionKey) : test: \(keys.testKey)")
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapVerifyAddress(_ sender:AnyObject?) {
        let address = EasyPostAddress()

        address.name = nameTextField.text
        address.company = companyTextField.text
        address.street1 = street1TextField.text
        address.street2 = street2TextField.text
        address.city = cityTextField.text
        address.state = stateTextField.text
        address.zip = zipTextField.text
        address.country = "US"
        
        EasyPostApi.sharedInstance.postAddress(address) { (result) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                switch(result) {
                case .success(let value):
                    
                    print("Successfully posted address.")
                    
                    if let id = value.id {
                        print("Verifying address: \(id)")
                        EasyPostApi.sharedInstance.verifyAddress(id, completion: { (verifyResult) -> () in
                            DispatchQueue.main.async(execute: { () -> Void in
                                switch(verifyResult) {
                                case .success(let easyPostAddress):
                                    print("Successfully verified address.")
                                    self.loadAddress(easyPostAddress)
                                case .failure(let error):
                                    print("Error verifying address: \((error as NSError).localizedDescription)")
                                
                                }
                            })
                        })
                    }
                    
                case .failure(let error):
                    print("Error posting address: \((error as NSError).localizedDescription)")
                }
            })
        }
    }
    
    func loadAddress(_ address:EasyPostAddress) {
        if let name = address.name {
            self.nameTextField.text = name
        }
        if let company = address.company {
            self.companyTextField.text = company
        }
        if let street1 = address.street1 {
            self.street1TextField.text = street1
        }
        if let street2 = address.street2 {
            self.street2TextField.text = street2
        }
        if let city = address.city {
            self.cityTextField.text = city
        }
        if let state = address.state {
            self.stateTextField.text = state
        }
        if let zip = address.zip {
            self.zipTextField.text = zip
        }
    }
    
    func parcelFromTextFields() -> EasyPostParcel {
        let parcel = EasyPostParcel()
        
        let numberFormatter = NumberFormatter()
        
        if let stringValue = parcelLength.text {
            parcel.length = numberFormatter.number(from: stringValue)
        }
        if let stringValue = parcelWidth.text {
            parcel.width = numberFormatter.number(from: stringValue)
        }
        if let stringValue = parcelHeight.text {
            parcel.height = numberFormatter.number(from: stringValue)
        }
        if let stringValue = parcelWeight.text {
            if let numberValue = numberFormatter.number(from: stringValue) {
                parcel.weight = numberValue
            }
        }
        return parcel
    }
    
    @IBAction func didTapPostParcel(_ sender:AnyObject?) {
        let parcel = parcelFromTextFields()
        
        EasyPostApi.sharedInstance.postParcel(parcel) { (result) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                switch(result) {
                case .success(let value):
                    
                    print("Successfully posted parcel.")
                    
                    if let id = value.id {
                        print("Parcel id: \(id)")
                    }
                    
                case .failure(let error):
                    print("Error posting parcel: \((error as NSError).localizedDescription)")
                }
            })
        }
    }
    
    @IBAction func didTapPostShipment(_ sender:AnyObject?) {
        let toAddress = EasyPostAddress()
        
        toAddress.name = nameTextField.text
        toAddress.company = companyTextField.text
        toAddress.street1 = street1TextField.text
        toAddress.street2 = street2TextField.text
        toAddress.city = cityTextField.text
        toAddress.state = stateTextField.text
        toAddress.zip = zipTextField.text
        toAddress.country = "US"
        
        let fromAddress = toAddress
        
        let parcel = parcelFromTextFields()
        
        EasyPostApi.sharedInstance.postShipment(toAddress, fromAddress: fromAddress, parcel: parcel) { (result) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                switch(result) {
                case .success(let shipment):
                    
                    print("Successfully posted shipment.")
                    
                    if let id = shipment.id {
                        print("Shipment id: \(id)")
                        
                        self.currentShipment = shipment
                        
                        if(shipment.rates.count < 1 && shipment.messages.count > 0) {
                            let alert = UIAlertController(title: "Error Getting Rates", message: shipment.messages[0].message, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            self.performSegue(withIdentifier: "ModalShowRatesSegue", sender: nil)
                        }
                    }
                    
                case .failure(let error):
                    print("Error posting shipment: \((error as NSError).localizedDescription)")
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ModalShowRatesSegue") {
            if let navController = segue.destination as? UINavigationController {
                if let ratesViewController = navController.topViewController as? RatesViewController {
                    if let shipment = self.currentShipment {
                        ratesViewController.shipment = shipment
                    }
                }
            }
        }
    }

}

