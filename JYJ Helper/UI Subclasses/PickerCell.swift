//
//  PickerCell.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/21/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell {

    @IBOutlet weak var pickerView: UIPickerView!
    
    required override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported");
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
