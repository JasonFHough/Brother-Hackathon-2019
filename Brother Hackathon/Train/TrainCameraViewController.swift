//
//  TrainCameraViewController.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/6/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit
import AVFoundation

class TrainCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var takePictureButton: UIButton!
    
    var takenPicture: UIImage?
    var photoOutput: AVCapturePhotoOutput?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        takePictureButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PreviewPictureSegue":
            
            // Pass takenPicture
            guard let previewVC = segue.destination as? TrainPreviewViewController else { return }
            previewVC.takenPicture = self.takenPicture
        default:
            return
        }
    }
    
    @IBAction func takePictureButton(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        takePictureButton.isEnabled = false
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
    
    // ---- AVCapturePhotoCaptureDelegate ----
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            takenPicture = UIImage(data: imageData)
            performSegue(withIdentifier: "PreviewPictureSegue", sender: nil)
        }
    }
    
}
