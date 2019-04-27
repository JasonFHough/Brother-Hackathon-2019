//
//  PrintPopupViewController.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/26/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

class PrintPopupViewController: UIViewController, BRSelectDeviceTableViewControllerDelegate {
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var labelCountLabel: UILabel!
    
    @IBOutlet weak var foodImage: UIImageView!
    
    @IBOutlet weak var selectedPrinterLabel: UILabel!
    
    @IBOutlet weak var subtractLabelButton: UIButton!
    @IBOutlet weak var addLabelButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var currentFoodItem: FoodItem?
    
    var selectedDeviceInfo : BRPtouchDeviceInfo?
    
    var printImage: UIImage {
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 100)))
        label.numberOfLines = 0
        label.text = "\(foodNameLabel.text!)\n\(Date.getFormattedDate())\n\(Date.getFormattedTime())"
        label.textAlignment = .left
        label.font = label.font.withSize(15)
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        label.drawHierarchy(in: label.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        BRPtouchBluetoothManager.shared()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedDeviceInfo == nil {
            confirmButton.isEnabled = false
        }
        
        foodNameLabel.text = currentFoodItem?.name
        foodImage.image = currentFoodItem?.picture
        subtractLabelButton.isEnabled = false
    }
    
    // Decreases label count
    @IBAction func subtractLabelButtonAction(_ sender: UIButton) {
        guard var count = Int(labelCountLabel.text!) else { fatalError("Label count is not an int") }
        count -= 1
        
        if count <= 1 {
            subtractLabelButton.isEnabled = false
        }
        
        labelCountLabel.text = String(count)
    }
    
    // Increases label count
    @IBAction func addLabelButtonAction(_ sender: UIButton) {
        guard var count = Int(labelCountLabel.text!) else { fatalError("Label count is not an int") }
        count += 1
        
        labelCountLabel.text = String(count)
        
        if count > 0 {
            subtractLabelButton.isEnabled = true
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        guard let modelName = selectedDeviceInfo?.strModelName else { return }
        let venderName = "Brother "
        let dev = venderName + modelName
        guard let num = selectedDeviceInfo?.strSerialNumber else { return }
        
        self.printImage(image: printImage, deviceName: dev, serialNumber: num)
        
        dismiss(animated: true)
        
        performSegue(withIdentifier: "UnwindSegueToCameraView", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SelectPrinterDeviceSegue") {
            guard let navController = segue.destination as? UINavigationController else { fatalError("Destination is not a UINavigationController") }
            guard let selectDeviceTableViewController = navController.topViewController as? SelectPrinterDeviceTableViewController else { fatalError("Could not segue to SelectPrinterDeviceTableViewController") }
            
            selectDeviceTableViewController.delegate = self
        }
    }
    
    // MARK: - Brother Printer SDK
    
    func printImage (image: UIImage, deviceName: String, serialNumber: String) {

        guard let ptp = BRPtouchPrinter(printerName: deviceName, interface: CONNECTION_TYPE.BLUETOOTH) else {
            print("*** Prepare Print Error ***")
            return
        }
        ptp.setupForBluetoothDevice(withSerialNumber: serialNumber)
        ptp.setPrintInfo(self.settingPrintInfoForRJ())

        ptp.setCustomPaperFile(Bundle.main.path(forResource: "rj2150_50mm", ofType: "bin"))

        guard ptp.isPrinterReady() else {
            print("*** Printer is not Ready ***")
            return
        }

        if ptp.startCommunication() {
            var result: Int32 = 0
            guard let numCopies: Int32 = Int32(labelCountLabel.text!) else { fatalError("Label count is not an int") }
            result = ptp.print(image.cgImage, copy: numCopies)
            print(result)
            if result != ERROR_NONE_ {
                print ("*** Printing Error ***")
            }
            ptp.endCommunication()
        }
        else {
            print("Communication Error")
        }
    }
    
    func settingPrintInfoForRJ() -> BRPtouchPrintInfo {

        let printInfo = BRPtouchPrintInfo()

        printInfo.strPaperName = "CUSTOM"
        printInfo.nPrintMode = PRINT_FIT_TO_PAGE
        printInfo.nHalftone = HALFTONE_ERRDIF

        return printInfo
    }
    
    func setSelected(deviceInfo: BRPtouchDeviceInfo) {
        selectedDeviceInfo = deviceInfo
        
        confirmButton.isEnabled = true
        
        selectedPrinterLabel.text = "\(String(selectedDeviceInfo!.strModelName)) Printer Selected"
    }
    
}
