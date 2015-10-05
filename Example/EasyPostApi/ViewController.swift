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
            
            postAddress()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postAddress() {
        let address = EasyPostAddress()
        address.street1 = "1600 Pennsylvania Avenue"
        address.city = "Washington"
        address.state = "DC"
        
        EasyPostApi.sharedInstance.postAddress(address) { (result) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                switch(result) {
                case .Success(let value):
                    print("Successfully posted address: \(value.id)")
                case .Failure(let error):
                    print("Error posting address: \((error as NSError).localizedDescription)")
                }
            })
        }
    }

}

