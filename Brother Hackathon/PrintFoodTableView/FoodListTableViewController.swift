//
//  FoodListTableViewController.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/21/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

class FoodListTableViewController: UITableViewController, PrintButtonDelegate {
    
    var tappedPrintButtonCell: FoodTableViewCell?   // Assigned by FoodTableViewCell PrintTapped function (called when that cell's button is tapped)
    
    var arrOfTestFoods = [FoodItem(name: "Mac n' Cheese", picture: UIImage(named: "MacNCheese")!), FoodItem(name: "Steak", picture: UIImage(named: "Steak")!), FoodItem(name: "Burger", picture: UIImage(named: "Burger")!)]
    
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
        return arrOfTestFoods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as? FoodTableViewCell else { fatalError("Could not load FoodCell as FoodTableViewCell") }
        
        cell.delegate = self
        
        // Assign image
        cell.foodImageView.image = arrOfTestFoods[indexPath.row].picture

        // Make ImageView Round
        roundImage(cell)

        // Change Food Name
        cell.foodTitleLabel.text = arrOfTestFoods[indexPath.row].name

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
            arrOfTestFoods.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: Navigation
    
    // Called from FoodTableViewCell printButton function
    func presentPopup() {
        performSegue(withIdentifier: "PrintPopupSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PrintPopupViewController {
            guard let cell = tappedPrintButtonCell else { return }
            guard let indexPath = self.tableView.indexPath(for: cell) else { return }
            
            destination.currentFoodItem = arrOfTestFoods[indexPath.row]
        }
    }
    
    // MARK: - Custom functions
    
    func roundImage(_ cell: FoodTableViewCell) {
        cell.foodImageView.layer.cornerRadius = (cell.foodImageView.frame.height) / 2
        cell.foodImageView.layer.masksToBounds = true
        cell.foodImageView.clipsToBounds = true
    }
}
