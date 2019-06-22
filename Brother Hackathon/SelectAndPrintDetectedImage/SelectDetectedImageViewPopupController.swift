//
//  SelectDetectedImageViewController.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/27/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

class SelectDetectedImageViewPopupController: UIViewController {
    
    @IBOutlet weak var tableContainerView: UIView!
    
    var image64String: String?
    var imageLabel: String?
    var foodImage: UIImage?
    var percentMatch: Int?
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var globalResponse: [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func addNewFoodButtonAction(_ sender: UIButton) {
        showAlert()
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) { }
    
    func showAlert() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Food Name", message: "What is the food's name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField()
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.dismiss(animated: true, completion: nil)
            self.getLabelText(tf: textField!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [] (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func getLabelText(tf: UITextField) {
        guard let text = tf.text else { return }
        guard let image = image64String else { return }
        sendTrainingPOST(image64: image, label: text)
    }
    
    func sendTrainingPOST(image64: String, label: String) {
//        let json: [String: Any] = ["image": base64String]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//        // create post request
//        //        http://httpbin.org/post
//        //        http://192.168.201.185:3000/post
//        let url = URL(string: "http://192.168.201.185:3000/training")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        // insert json data to the request
//        request.httpBody = jsonData
//
//        var headers = request.allHTTPHeaderFields ?? [:]
//        headers["Content-Type"] = "application/json"
//        request.allHTTPHeaderFields = headers
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String : String] {
//                DispatchQueue.main.async {
//                    print(responseJSON)
//                    self.globalResponse = responseJSON
//                    self.performSegue(withIdentifier: "DetectedImagesPopupSegue", sender: self)
//                }
//            }
//        }
//
//        task.resume()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SelectDetectedImageTableViewPopupController {
            destination.image64String = self.image64String
            destination.imageLabel = imageLabel
            destination.foodImage = foodImage
            destination.percentMatch = percentMatch
            destination.confirmButton = confirmButton
        } else if let destination = (segue.destination as? PrintPopupViewController) {
            if segue.identifier == "PrintDetectedPopupViewSegue" {
                destination.currentFoodItem = FoodItem(name: imageLabel!, picture: foodImage!)
            }
        }
    }
    
}
