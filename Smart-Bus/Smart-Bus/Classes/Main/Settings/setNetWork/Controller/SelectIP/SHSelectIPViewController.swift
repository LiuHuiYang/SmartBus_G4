//
//  SHSelectIPViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/25.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// cell重用标示符
private let deviceListCellReusableIdentifier =
    "SHDeviceListCell"

class SHSelectIPViewController: UITableViewController {

    /// 当前选中的行
    private var currentRow: Int = -1
    
    /// 所有的RSIP
    private var deviceLists: [SHDeviceList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "RSIP"
        
        tableView.rowHeight = SHDeviceListCell.rowHeight
        
        tableView.backgroundView =
            UIImageView(image: UIImage(named: "background"))
        
        deviceLists = SHDeviceList.allRemoteDevices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let list = deviceLists else {
            return
        }
        
        if list.isEmpty{
            
            SVProgressHUD.showError(
                withStatus: SHLanguageText.noData
            )
            
            navigationController?.popViewController(animated: true)
            
            return
        }
        
        // 获取哪一行
        guard let selectedRSIP =
            SHDeviceList.selectedRemoteDevice() else {
                    
            return
        }
        
        // 查询所有存储的RSIP
        for index in 0 ..< list.count {
            
            let device = list[index]
            
            if selectedRSIP.macAddress != nil &&
                device.macAddress == selectedRSIP.macAddress {
                
                currentRow = index
                break
            }
        }
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if currentRow < 0 {
            return
        }
        
        guard let device = deviceLists?[currentRow] else {
            return
        }
        
        if device.serverName == nil {
            device.serverName = defaultRemoteServerDoMainName
        }
        
        if SHDeviceList.saveSelectedRemoteDevice(device) {
            
            SVProgressHUD.showSuccess(
                withStatus: SHLanguageText.saved
            )
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentRow = indexPath.row
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deviceLists?.count ?? 0
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: deviceListCellReusableIdentifier, for: indexPath) as! SHDeviceListCell

        cell.deviceList = deviceLists?[indexPath.row]
        
        cell.accessoryView =
            UIImageView(image: UIImage(named: "check"))
        
        cell.accessoryView?.isHidden = (indexPath.row != self.currentRow)

        return cell
    }
}
