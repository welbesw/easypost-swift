//
//  RateCell.swift
//  EasyPostApi
//
//  Created by William Welbes on 10/6/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {

    @IBOutlet weak var carrierLabel:UILabel!
    @IBOutlet weak var serviceLabel:UILabel!
    @IBOutlet weak var rateLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
