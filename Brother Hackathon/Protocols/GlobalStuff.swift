//
//  MyProtocols.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/26/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

protocol PrintButtonDelegate {
    var tappedPrintButtonCell: FoodTableViewCell? { get set }
    func presentPopup()
}

protocol PrinterSelectionDelegate {
    var tappedSwitchCell: SelectPrinterDeviceTableViewCell? { get set }
    func disableAllOtherSwitches()
}

@objc protocol BRSelectDeviceTableViewControllerDelegate : NSObjectProtocol {
    func setSelected(deviceInfo: BRPtouchDeviceInfo)
}

struct FoodItem {
    let name: String
    let picture: UIImage
}

struct ResponseObject: Codable {
    let data: [DetectPost]
}

struct DetectPost: Codable {
    let image: String   // Sending the base64String
    
    //Custom Keys
    enum CodingKeys: String, CodingKey {
        case image = "a"
    }
}

struct TrainPost: Codable {
    let image: String
    let label: String
}

extension Date {
    static func getFormattedDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    static func getFormattedTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: currentDate)
    }
}
