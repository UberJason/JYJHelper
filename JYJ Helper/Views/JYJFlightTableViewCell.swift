//
//  JYJFlightTableViewCell.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/10/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class JYJFlightTableViewCell: UITableViewCell {

    @IBOutlet var flightTitleLabel : UILabel
    @IBOutlet var dateLabel : UILabel
    @IBOutlet var airportsLabel : UILabel
    @IBOutlet var startTimeLabel : UILabel
    @IBOutlet var endTimeLabel : UILabel
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
