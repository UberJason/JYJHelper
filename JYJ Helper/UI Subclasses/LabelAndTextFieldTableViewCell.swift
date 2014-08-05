//
//  LabelAndTextFieldTableViewCell.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/15/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class LabelAndTextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var textField : UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
