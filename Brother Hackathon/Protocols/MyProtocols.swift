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
