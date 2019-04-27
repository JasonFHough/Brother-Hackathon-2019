//
//  SelectDetectedImageTableViewCell.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/27/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

class SelectDetectedImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var matchPercentage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
