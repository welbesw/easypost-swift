//
//  CredentialsViewController.swift
//  BigcommerceApi
//
//  Created by William Welbes on 7/7/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import EasyPostApi

class CredentialsViewController: UITableViewController {

    @IBOutlet var apiTokenTextField: UITextField!
    @IBOutlet var apiBaseUrlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCredentials()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCredentials() {
        let defaultsManager = DefaultsManager.sharedInstance
        
        apiBaseUrlTextField.text = defaultsManager.apiBaseUrl
        apiTokenTextField.text = defaultsManager.apiToken
    }
    
    @IBAction func didTapSaveButton() {
        //Store the credentials in NSUserDefaults
        
        dismissKeyboard()
        
        let defaultsManager = DefaultsManager.sharedInstance
        defaultsManager.apiBaseUrl = apiBaseUrlTextField.text
        defaultsManager.apiToken = apiTokenTextField.text
        
        //Set the credentials on the BigcommerceApi instance
        if(defaultsManager.apiCredentialsAreSet) {
            EasyPostApi.sharedInstance.setCredentials(defaultsManager.apiToken!, baseUrl: defaultsManager.apiBaseUrl!)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCancelButton() {
        
        dismissKeyboard()
        
        //Close the view controller
        self.dismiss(animated: true, completion: nil)
    }

    func dismissKeyboard() {
        apiTokenTextField.resignFirstResponder()
        apiBaseUrlTextField.resignFirstResponder()
    }

}
