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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Check if the API credentials have been set and present the view controller if they have note been set
        let defaultsManager = DefaultsManager.sharedInstance
        if !defaultsManager.apiCredentialsAreSet {
            self.performSegueWithIdentifier("ModalCredentialsSegue", sender: nil)
        } else {
            //Set the API credentials
            EasyPostApi.sharedInstance.setCredentials(defaultsManager.apiToken!, baseUrl: defaultsManager.apiBaseUrl!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapVerifyAddress(sender:AnyObject?) {
        let address = EasyPostAddress()

        address.name = nameTextField.text
        address.company = companyTextField.text
        address.street1 = street1TextField.text
        address.street2 = street2TextField.text
        address.city = cityTextField.text
        address.state = stateTextField.text
        address.zip = zipTextField.text
        
        EasyPostApi.sharedInstance.postAddress(address) { (result) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                switch(result) {
                case .Success(let value):
                    
                    print("Successfully posted address.")
                    
                    if let id = value.id {
                        print("Verifying address: \(id)")
                        EasyPostApi.sharedInstance.verifyAddress(id, completion: { (verifyResult) -> () in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                switch(verifyResult) {
                                case .Success(let easyPostAddress):
                                    print("Successfully verified address.")
                                    self.loadAddress(easyPostAddress)
                                case .Failure(let error):
                                    print("Error verifying address: \((error as NSError).localizedDescription)")
                                
                                }
                            })
                        })
                    }
                    
                case .Failure(let error):
                    print("Error posting address: \((error as NSError).localizedDescription)")
                }
            })
        }
    }
    
    func loadAddress(address:EasyPostAddress) {
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

}

