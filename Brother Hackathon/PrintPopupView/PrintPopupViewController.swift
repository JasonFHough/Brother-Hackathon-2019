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
    
    @IBOutlet weak var subtractLabelButton: UIButton!
    @IBOutlet weak var addLabelButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var currentFoodItem: FoodItem?
    
    var selectedDeviceInfo : BRPtouchDeviceInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodNameLabel.text = currentFoodItem?.name
        foodImage.image = currentFoodItem?.picture
    }
    
    // Decreases label count
    @IBAction func subtractLabelButtonAction(_ sender: UIButton) {
        guard var count = Int(labelCountLabel.text!) else { fatalError("Label count is not an int") }
        count -= 1
        
        if count <= 0 {
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
        guard let img = UIImage(named: "Burger.jpg") else { return }
        guard let modelName = selectedDeviceInfo?.strModelName else { return }
        let venderName = "Brother "
        let dev = venderName + modelName
        guard let num = selectedDeviceInfo?.strSerialNumber else { return }
        
//        self.printImage(image: img, deviceName: dev, serialNumber: num)
    }
    
    // MARK: - Brother Printer SDK
    /*
    func printImage (image: UIImage, deviceName: String, serialNumber: String) {
        
        guard let ptp = BRPtouchPrinter(printerName: deviceName, interface: CONNECTION_TYPE.BLUETOOTH) else {
            print("*** Prepare Print Error ***")
            return
        }
        ptp.setupForBluetoothDevice(withSerialNumber: serialNumber)
        ptp.setPrintInfo(self.settingPrintInfoForRJ())
        
        ptp.setCustomPaperFile(Bundle.main.path(forResource: "bsr16act2", ofType: "bin"))
        
        guard ptp.isPrinterReady() else {
            print("*** Printer is not Ready ***")
            return
        }
        
        if ptp.startCommunication() {
            var result: Int32 = 0
            result = ptp.print(image.cgImage, copy: 1)
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
    */
    func setSelected(deviceInfo: BRPtouchDeviceInfo) {
        selectedDeviceInfo = deviceInfo
    }
    
}
