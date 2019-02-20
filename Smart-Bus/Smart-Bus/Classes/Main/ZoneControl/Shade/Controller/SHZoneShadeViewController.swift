//
//  SHZoneShadeViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/7/31.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

/// 区域窗帘标示符
private let zoneShadeCellReuseIdentifier = "SHZoneShadeViewCell"

class SHZoneShadeViewController: SHViewController {

    /// 当前区域
    var currentZone: SHZone?
    
    /// 所有的窗帘
    lazy var allShades = [SHShade]()
    
    /// 窗帘视图
    @IBOutlet weak var shadesListView: UITableView!
    
    /// 底部距离约束
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shadesListView.rowHeight = SHZoneShadeViewCell.rowHeight
        
        shadesListView.register(
            UINib(nibName: zoneShadeCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier: zoneShadeCellReuseIdentifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let zoneID = currentZone?.zoneID else {
            
            return
        }
        
        allShades = SHSQLiteManager.shared.getShades(zoneID)
        
        if allShades.isEmpty {
            
            SVProgressHUD.showInfo(withStatus: SHLanguageText.noData)
        }
        
        shadesListView.reloadData()
        
        readDevicesStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPhoneX_More() {
            
            bottomHeightConstraint.constant = tabBarHeight_iPhoneX_more
        }
    }
}


// MARK: - 状态与解析
extension SHZoneShadeViewController {
    
    /// 接收广播数据
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
    }
    
    /// 读取状态
    private func readDevicesStatus() {
        
        var subNetID: UInt8 = 0
        var deviceID: UInt8 = 0
        
        for shade in allShades {
            
            if shade.subnetID == subNetID &&
               shade.deviceID == deviceID {
                    
                continue
            }
            
            subNetID = shade.subnetID
            deviceID = shade.deviceID
            
            SHSocketTools.sendData(
                operatorCode: 0x0033,
                subNetID: subNetID,
                deviceID: deviceID,
                additionalData: []
            )

        }
        
    }
}

// MARK: - UITableViewDataSource
extension SHZoneShadeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allShades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: zoneShadeCellReuseIdentifier,
                for: indexPath
            ) as! SHZoneShadeViewCell
        
        cell.shade = allShades[indexPath.row]
        
        return cell
    }
     
}
