//
//  PickerCell.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/21/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell {

    @IBOutlet var pickerView: UIPickerView
    
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