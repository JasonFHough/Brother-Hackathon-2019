//
//  SelectPrinterDeviceTableViewController.swift
//  Brother Hackathon
//
//  Created by Jason Hough on 4/27/19.
//  Copyright © 2019 Jason Hough. All rights reserved.
//

import UIKit

class SelectPrinterDeviceTableViewController: UITableViewController, PrinterSelectionDelegate {
    
    var tappedSwitchCell: SelectPrinterDeviceTableViewCell?
    
    var delegate: BRSelectDeviceTableViewControllerDelegate?
    var deviceListByMfi : [BRPtouchDeviceInfo]?
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.BRDeviceDidConnect, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.BRDeviceDidDisconnect, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BRPtouchBluetoothManager.shared()?.registerForBRDeviceNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryDidConnect), name: NSNotification.Name.BRDeviceDidConnect , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryDidDisconnect), name: NSNotification.Name.BRDeviceDidDisconnect, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deviceListByMfi = BRPtouchBluetoothManager.shared()?.pairedDevices() as? [BRPtouchDeviceInfo] ?? []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func accessoryDidConnect( notification : Notification) {
        if let connectedAccessory = notification.userInfo?[BRDeviceKey] {
            print("ConnectDevice : \(String(describing: (connectedAccessory as? BRPtouchDeviceInfo)?.description()))")
        }
        
        deviceListByMfi = BRPtouchBluetoothManager.shared()?.pairedDevices() as? [BRPtouchDeviceInfo] ?? []
        
        self.tableView.reloadData()
    }
    
    @objc func accessoryDidDisconnect( notification : Notification) {
        if let disconnectedAccessory = notification.userInfo?[BRDeviceKey] {
            print("DisconnectDevice : \(String(describing: (disconnectedAccessory as? BRPtouchDeviceInfo)?.description()))")
        }
        
        deviceListByMfi = BRPtouchBluetoothManager.shared()?.pairedDevices()  as? [BRPtouchDeviceInfo] ?? []
        
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceListByMfi?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "selectDeviceTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SelectPrinterDeviceTableViewCell else { fatalError("Could not get cell with type SelectPrinterDeviceTableViewCell") }
        
        cell.printerModelLabel.text = deviceListByMfi?[indexPath.row].strModelName ?? nil
        cell.serialLabel.text = deviceListByMfi?[indexPath.row].strSerialNumber ?? nil
        cell.selectionSwitch.setOn(false, animated: false)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let deviceInfo = deviceListByMfi?[indexPath.row] {
            self.delegate?.setSelected(deviceInfo: deviceInfo)
        }
    }
    
    // MARK: - Printer Selection Delegate
    
    func disableAllOtherSwitches() {
        guard let deviceList = deviceListByMfi else { return }
        for (i, _) in deviceList.enumerated() {
            let indexPath = IndexPath(row: i, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? SelectPrinterDeviceTableViewCell else { return }
            
            if cell != tappedSwitchCell {
                cell.selectionSwitch.setOn(false, animated: true)
            }
        }
    }

}
