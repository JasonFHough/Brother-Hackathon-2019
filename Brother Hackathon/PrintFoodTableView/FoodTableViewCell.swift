//
//  FoodTableViewCell.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/21/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    @IBOutlet weak var printButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func printButton(_ sender: UIButton) {
        
    }
}
