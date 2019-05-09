//
//  SHZoneDryContactViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/24.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

/// cell重用标示
private let dryContactCellReuseIdentifier =
    "SHZoneDryContactViewCell"

class SHZoneDryContactViewController: SHViewController {

    /// 当前区域
    var currentZone: SHZone?
    
    /// 所有的干节点
    lazy var allDryContacts = [SHDryContact]()
    
    /// 干节点列表
    @IBOutlet weak var dryContactListView: UITableView!
    
    /// 底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dryContactListView.rowHeight =
            SHZoneDryContactViewCell.rowHeight
        
        dryContactListView.register(
            UINib(nibName: dryContactCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier: dryContactCellReuseIdentifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let zoneID = currentZone?.zoneID else {
            
            return
        }
        
        allDryContacts = SHSQLiteManager.shared.getDryContact(zoneID)
        
        if allDryContacts.isEmpty {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
        }
        
        dryContactListView.reloadData()
        
        readDevicesStatus()
    }
    
    /// 布局
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPhoneX_More() {
            
            listViewBottomConstraint.constant = tabBarHeight_iPhoneX_more
        }
    }

}


// MARK: - 数据与解析
extension SHZoneDryContactViewController {
    
    /// 接收到广播
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        // 0x012D 主动读取
        // 0xDC22 广播状态
        if  (socketData.operatorCode != 0x012D &&
            socketData.operatorCode != 0xDC22) ||
            
            (socketData.operatorCode == 0x012D &&
                socketData.additionalData[0] != 0xF8){
            
            return
        }
        
        let flagIndex =
            (socketData.operatorCode == 0x012D) ? 1 : 0
        
        let dryContactsCount =
            Int(socketData.additionalData[flagIndex])
        
        for i in 1 ... dryContactsCount {
            
            for drynode in allDryContacts {
                
                if drynode.subnetID == socketData.subNetID &&
                    drynode.deviceID == socketData.deviceID &&
                    i == drynode.channelNo {
                    
                    // 获得类型
                    let type =
                        socketData.additionalData[i + flagIndex]
                    
                    drynode.type =
                        SHDryContactType(rawValue: type) ?? .invalid
                    
                    // 获得状态
                    let status =
                        socketData.additionalData[i + flagIndex + dryContactsCount]
                    
                    drynode.status =
                        SHDryContactStatus(rawValue: status) ?? .close
                    
                }
            }
        }
        
        dryContactListView.reloadData()
    }
    
    
    /// 读取状态
    private func readDevicesStatus() {
        
        var subNetID: UInt8 = 0
        var deviceID: UInt8 = 0
        
        for drynode in allDryContacts {
            
            if drynode.subnetID == subNetID &&
                drynode.deviceID == deviceID {
                continue
            }
            
            subNetID = drynode.subnetID
            deviceID = drynode.deviceID

            SHSocketTools.sendData(
                operatorCode: 0x012C,
                subNetID: subNetID,
                deviceID: deviceID,
                additionalData: []
            )
        }
    }
    
    override func becomeFocus() {
         
        if isVisible() {
            readDevicesStatus()
        }
    }
}


// MARK: - UITableViewDataSource
extension SHZoneDryContactViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allDryContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: dryContactCellReuseIdentifier,
                for: indexPath
            ) as! SHZoneDryContactViewCell
        
        cell.dryContact = allDryContacts[indexPath.row]
        
        return cell
    }
}
