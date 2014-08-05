//
//  JYJFlightTableViewCell.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/11/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class JYJFlightTableViewCell: UITableViewCell {

    @IBOutlet weak var flightLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var airportsLabel : UILabel!
    @IBOutlet weak var departureTimeLabel : UILabel!
    @IBOutlet weak var arrivalTimeLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
