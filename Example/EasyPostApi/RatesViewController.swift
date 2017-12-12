//
//  RatesViewController.swift
//  EasyPostApi
//
//  Created by William Welbes on 10/6/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import EasyPostApi

class RatesViewController: UITableViewController {

    var shipment:EasyPostShipment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCancelButton(_ sender:AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return shipment.rates.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath) as! RateCell

        // Configure the cell...
        let rate = self.shipment.rates[(indexPath as NSIndexPath).row]
        
        cell.carrierLabel.text = rate.carrier
        cell.serviceLabel.text = rate.service
        cell.rateLabel.text = rate.rate

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Buy the postage that has been selected
        let rate = self.shipment.rates[(indexPath as NSIndexPath).row]
        
        if let rateId = rate.id {
            let alertController = UIAlertController(title: "Buy Postage", message: "Do you want to buy this postage for \(rate.rate!)", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Buy", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                EasyPostApi.sharedInstance.buyShipment(self.shipment.id!, rateId: rateId, completion: { (result) -> () in
                    //Handle results
                    DispatchQueue.main.async(execute: { () -> Void in
                        if(result.isSuccess) {
                            print("Successfully bought shipment.")
                            if let buyResponse = result.value {
                                if let postageLabel = buyResponse.postageLabel {
                                    if let labelUrl = postageLabel.labelUrl {
                                        print("Label url: \(labelUrl)")
                                    }
                                }
                            }
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            print("Error buying shipment: \(result.error?.localizedDescription ?? "")")
                        }
                    })
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
