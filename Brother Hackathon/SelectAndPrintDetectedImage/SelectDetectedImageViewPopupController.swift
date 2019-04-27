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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func addNewFoodButtonAction(_ sender: UIButton) {
        showAlert()
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        
    }
    
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
        sendPOST(image64: image, label: text)
    }
    
    func sendPOST(image64: String, label: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "192.168.201.185"
        urlComponents.port = 3000
        urlComponents.path = "/train"
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        let post = TrainPost(image: "64string", label: "labelString")
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        // Now let's encode out Post struct into JSON data...
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(post)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print("error here")
            print(error.localizedDescription)
        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            // APIs usually respond with the data you just sent in your POST request
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
        }
        
        task.resume()
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
//                if imageLabel == nil {
//                    print("hihioewgiowegwiehgoehwig")
//                }
//                if foodImage == nil {
//                    print("bobobobobobo")
//                }
                destination.currentFoodItem = FoodItem(name: imageLabel!, picture: foodImage!)
            }
        }
    }
    
}
