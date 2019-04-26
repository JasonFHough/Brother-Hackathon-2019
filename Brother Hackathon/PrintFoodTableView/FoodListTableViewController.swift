//
//  FoodListTableViewController.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/21/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

class FoodListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Displays Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as? FoodTableViewCell else { fatalError("Could not load FoodCell as FoodTableViewCell") }

        // Assign image
        cell.foodImageView.image = UIImage(named: "MacNCheese");
        
        // Make ImageView Round
        cell.foodImageView.layer.cornerRadius = (cell.foodImageView.frame.height) / 2
        cell.foodImageView.layer.masksToBounds = true
        cell.foodImageView.clipsToBounds = true
        
        // Change Food Name
        cell.foodTitleLabel.text = "Mac n' Cheese"

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
