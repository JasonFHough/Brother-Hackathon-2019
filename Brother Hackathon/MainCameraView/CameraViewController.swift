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
    
    var photoOutput: AVCapturePhotoOutput?
    var cameraSettings: AVCapturePhotoSettings?
    var takenPicture: UIImage?
    
    var jsonResponse: Data?
    
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
    }
    
    func setupCamera() {
        // Create capture session
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
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
    
    func sendPOST(_ base64String: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "192.168.201.185"
        urlComponents.port = 3000
        urlComponents.path = "/classify"
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        let post = DetectPost(image: "john")
        
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
                self.jsonResponse = data
            } else {
                print("no readable data received in response")
            }
        }
        
        task.resume()
        
        performSegue(withIdentifier: "DetectedImagesPopupSegue", sender: self)
    }
    
    // ---- AVCapturePhotoCaptureDelegate ----
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            takenPicture = UIImage(data: imageData)
            
            let base64String = imageData.base64EncodedString()
            sendPOST(base64String)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SelectDetectedImageViewPopupController {
    //        guard let jsonData = jsonResponse else { return }
    //
    //        let decoder = JSONDecoder()
    //        let aValue = try! decoder.decode(DetectPost.self, from: jsonData)
    //
    //        print("stuff is here: \(aValue.image)")
            destination.image64String = "ABCDEFGHIJK"
            destination.imageLabel = "Temporary Label"
            destination.foodImage = takenPicture
        }
    }
}
