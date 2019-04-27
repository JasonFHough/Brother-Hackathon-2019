//
//  PrintPopupViewController.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/26/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

class PrintPopupViewController: UIViewController {
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var labelCountLabel: UILabel!
    
    @IBOutlet weak var foodImage: UIImageView!
    
    @IBOutlet weak var subtractLabelButton: UIButton!
    @IBOutlet weak var addLabelButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var currentFoodItem: FoodItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodNameLabel.text = currentFoodItem?.name
        foodImage.image = currentFoodItem?.picture
    }
    
    // Decreases label count
    @IBAction func subtractLabelButtonAction(_ sender: UIButton) {
        guard var count = Int(labelCountLabel.text!) else { fatalError("Label count is not an int") }
        count -= 1
        
        if count <= 0 {
            subtractLabelButton.isEnabled = false
        }
        
        labelCountLabel.text = String(count)
    }
    
    // Increases label count
    @IBAction func addLabelButtonAction(_ sender: UIButton) {
        guard var count = Int(labelCountLabel.text!) else { fatalError("Label count is not an int") }
        count += 1
        
        labelCountLabel.text = String(count)
        
        if count > 0 {
            subtractLabelButton.isEnabled = true
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        
    }
    
}
