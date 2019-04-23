//
//  TrainPreviewViewController.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/6/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

class PreviewPictureViewController: UIViewController {

    @IBOutlet weak var takenPictureImageView: UIImageView!
    var takenPicture: UIImage!    // Assigned through TrainCameraVC's prepare
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retake", style: .plain, target: self, action: #selector(cancelTapped(_:)))
        
        takenPictureImageView.image = self.takenPicture
    }
    
    @objc func cancelTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveTapped(_ sender: UIBarButtonItem) {
        
    }
    
}
