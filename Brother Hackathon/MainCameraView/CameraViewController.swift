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
    var takenPicture: UIImage?
    
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
        captureSession.sessionPreset = .high
        
        // Get device's back camera input
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
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
        
    }
    
    // ---- AVCapturePhotoCaptureDelegate ----
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            takenPicture = UIImage(data: imageData)
            
            let base64String = imageData.base64EncodedString()
            sendPOST(base64String)
            
//            performSegue(withIdentifier: "PreviewPictureSegue", sender: nil)
        }
    }
    
    
    
}
