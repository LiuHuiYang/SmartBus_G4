//
//  SHSelectIPViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/25.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// cell重用标示符
fileprivate let deviceListCellReusableIdentifier =
    "SHDeviceListCell"

class SHSelectIPViewController: UITableViewController {

    /// 当前选中的行
    private var currentRow: Int = -1
    
    /// 所有的RSIP
    private var deviceLists: [SHDeviceList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "RS/IP"
        
        tableView.rowHeight = SHDeviceListCell.rowHeight
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        
        let filePath = FileTools.documentPath() + "/" + allDeviceMacAddressListPath
        
        deviceLists = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [SHDeviceList] ?? [SHDeviceList]()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let list = deviceLists else {
            return
        }
        
        if list.isEmpty{
            
            SVProgressHUD.showError(withStatus: SHLanguageText.noData)
            
            navigationController?.popViewController(animated: true)
            
            return
        }
        
        // 获取哪一行
        let filePath = FileTools.documentPath() + "/" + selectMacAddress
        
        let selectDevice = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? SHDeviceList
        
        guard let selectRSIP = selectDevice,
              let mac = selectRSIP.macAddress else {
            return
        }
        
        for i in 0 ..< list.count {
            
            guard let selecMacAddr = list[i].macAddress else {
                continue
            }
            
            if selecMacAddr.isEqual(mac) {
                
                currentRow = i
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
        
        // 保存选择的地址
        let filePath = FileTools.documentPath() + "/" + selectMacAddress
        
        let isScuess =
            NSKeyedArchiver.archiveRootObject(
                device,
                toFile: filePath
        )
        
        if isScuess {
            
            let msg =
                SHLanguageTools.share()?.getTextFromPlist(
                    "PUBLIC",
                    withSubTitle: "SAVED"
                ) as! String
            
            SVProgressHUD.showSuccess(withStatus: msg)
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
        
        cell.accessoryView = UIImageView(image: UIImage(named: "check"))
        
        cell.accessoryView?.isHidden = (indexPath.row != self.currentRow)

        return cell
    }
}
