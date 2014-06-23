//
//  DatePickerCell.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/15/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

@objc protocol DatePickerDelegate {
    func cellDidChangeDate(cell: DatePickerCell, datePicker: UIDatePicker);
}

class DatePickerCell: UITableViewCell {

    @IBOutlet var datePicker : UIDatePicker
    weak var delegate: DatePickerDelegate?
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        let calendar = NSCalendar.currentCalendar();
        calendar.timeZone = NSTimeZone.systemTimeZone();
        self.datePicker.calendar = calendar;
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func dateChanged(sender: UIDatePicker) {
        self.delegate?.cellDidChangeDate(self, datePicker: sender);
    }
}
