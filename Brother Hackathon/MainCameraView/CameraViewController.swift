//
//  TrainCameraViewController.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/6/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var waitLabel: UILabel!
    
    var photoOutput: AVCapturePhotoOutput?
    var cameraSettings: AVCapturePhotoSettings?
    var takenPicture: UIImage?
    
    var globalResponse: [String : String] = [:]
    var globalBase64String: String = ""
    
    @IBAction func unwindToCameraView(segue:UIStoryboardSegue) { }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .left:
                performSegue(withIdentifier: "SeguePrintFoodTableView", sender: self)
            default:
                break
            }
        }
    }
    
    func setupCamera() {
        // Create capture session
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        // Get device's back camera input
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        // Setup camera settings
        cameraSettings = AVCapturePhotoSettings()
        cameraSettings?.flashMode = .auto
        
        // Setup photo output
        photoOutput = AVCapturePhotoOutput()
        let photoCodecFormat: AVVideoCodecType = .jpeg
        photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: photoCodecFormat])], completionHandler: nil)
        captureSession.addOutput(photoOutput!)
        
        DispatchQueue.global().async {
            // Begin the capture session
            captureSession.startRunning()
            
            DispatchQueue.main.async {
                // Setup the camera preview
                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.connection?.videoOrientation = .portrait
                previewLayer.frame = self.view.frame
                self.cameraView.layer.insertSublayer(previewLayer, at: 0)
            }
        }
    }
    
    @IBAction func takePictureButton(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    func resizeImage (image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func sendUploadPOST(_ base64String: String) {
        waitLabel.isEnabled = true
        waitLabel.isHidden = false
        takePictureButton.isEnabled = false
        
        let json: [String: Any] = ["image": base64String]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        //        http://httpbin.org/post
        //        http://192.168.201.185:3000/post
        let url = URL(string: "http://192.168.201.185:3000/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String : String] {
            }
        }
        
        task.resume()
        
        sendClassifyPOST(globalBase64String)
    }
    
    func sendClassifyPOST(_ base64String: String) {
        let json: [String: Any] = ["image": base64String]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
//        http://192.168.201.185:3000/post
        let url = URL(string: "http://192.168.201.185:3000/classify")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String : String] {
                DispatchQueue.main.async {
                    print(responseJSON)
                    self.globalResponse = responseJSON
                    self.waitLabel.isEnabled = false
                    self.waitLabel.isHidden = true
                    self.takePictureButton.isEnabled = true
                    self.performSegue(withIdentifier: "DetectedImagesPopupSegue", sender: self)
                }
            }
        }
        
        task.resume()
        
    }
    
    // ---- AVCapturePhotoCaptureDelegate ----
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            takenPicture = UIImage(data: imageData)
            takenPicture = resizeImage(image: takenPicture!, targetSize: CGSize(width: 224, height: 224))
            
            globalBase64String = imageData.base64EncodedString()
//            sendUploadPOST(globalBase64String)
            performSegue(withIdentifier: "DetectedImagesPopupSegue", sender: self)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SelectDetectedImageViewPopupController {
//            destination.image64String = globalBase64String
//            destination.imageLabel = globalResponse.first?.value
//            destination.foodImage = takenPicture
            destination.image64String = globalBase64String
            destination.imageLabel = "Rhonda and Daron"
            destination.foodImage = takenPicture
        }
    }
}
