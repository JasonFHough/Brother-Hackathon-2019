//
//  FoodTableViewCell.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/21/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    
    var delegate: PrintButtonDelegate?
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    @IBOutlet weak var printButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }

    @IBAction func printButton(_ sender: UIButton) {
        self.delegate?.tappedPrintButtonCell = self
        self.delegate?.presentPopup()
    }
}
