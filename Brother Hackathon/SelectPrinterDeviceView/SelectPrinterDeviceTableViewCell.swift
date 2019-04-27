//
//  SelectPrinterDeviceTableViewCell.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/27/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

class SelectPrinterDeviceTableViewCell: UITableViewCell {
    
    var delegate: PrinterSelectionDelegate?
    
    @IBOutlet weak var printerModelLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var selectionSwitch: UISwitch!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    @IBAction func switchToggleAction(_ sender: UISwitch) {
        self.delegate?.tappedSwitchCell = self
    }
    
}
