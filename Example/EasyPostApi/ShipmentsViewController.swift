//
//  ShipmentsViewController.swift
//  EasyPostApi
//
//  Created by William Welbes on 10/28/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import EasyPostApi

class ShipmentsViewController: UITableViewController {

    var shipments:[EasyPostShipment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadShipments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadShipments() {
        EasyPostApi.sharedInstance.getShipments(onlyPurchased:true, pageSize: 50, beforeShipmentId: nil) { (result) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                switch(result) {
                case .success(let resultShipments):
                    self.shipments = resultShipments
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error getting shipments: \((error as NSError).localizedDescription)")
                }
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return shipments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shipmentCell", for: indexPath)

        // Configure the cell...
        let shipment = shipments[(indexPath as NSIndexPath).row]
        
        if let trackingCode = shipment.trackingCode {
            cell.textLabel!.text = trackingCode
        } else {
            cell.textLabel!.text = "[No tracking code for shipment]"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        let shipment = shipments[(indexPath as NSIndexPath).row]
        if let shipmentId = shipment.id {
        
            //Ask to refund
            let alertController = UIAlertController(title: "Request Refund?", message: "Request a refund for this shipment?", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "Request Refund", style: UIAlertActionStyle.destructive, handler: { (action) -> Void in
                //Request the refund
                EasyPostApi.sharedInstance.requestRefund(shipmentId, completion: { (result) -> () in
                    //Check for error
                    switch(result) {
                    case .success(let refund):
                        print("Refund requested: \(refund.id ?? "")")
                    case .failure(let error):
                        print("Error requesting refund: \((error as NSError).localizedDescription)")
                    }
                })
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
