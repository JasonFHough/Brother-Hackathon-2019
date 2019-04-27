//
//  SelectDetectedImageTableViewController.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/27/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

class SelectDetectedImageTableViewPopupController: UITableViewController {
    
    var image64String: String?
    var imageLabel: String?
    var foodImage: UIImage?
    var percentMatch: Int?
    
    var confirmButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton?.isEnabled = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetectedPossibleFoodCell", for: indexPath) as? SelectDetectedImageTableViewCell else { fatalError("Could not get cell as SelectDetectedImageTableViewCell") }

        cell.foodName.text = imageLabel
        cell.foodImage.image = foodImage
        cell.matchPercentage.text = "\(percentMatch ?? 0)% match"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let popupView = parent as? SelectDetectedImageViewPopupController else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectDetectedImageTableViewCell else { return }
        
        confirmButton?.isEnabled = true
        
        let imageData = cell.foodImage.image!.pngData()!
        popupView.image64String = imageData.base64EncodedString()
        
        popupView.foodImage = cell.foodImage.image
        popupView.imageLabel = cell.foodName.text
    }
    
    // MARK: - Navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
