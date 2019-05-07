//
//  SHZoneFanViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/19.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// 区域风扇标示符
private let zoneFanCellReuseIdentifier = "SHZoneFanViewCell"

class SHZoneFanViewController: SHViewController {
    
    /// 当前区域
    var currentZone: SHZone?
    
    /// 所有的风扇
    lazy var allFans = [SHFan]()
    
    /// 风扇列表
    @IBOutlet weak var fansListView: UITableView!
    
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        fansListView.rowHeight = SHZoneFanViewCell.rowHeight
        
        fansListView.register(
            UINib(nibName: zoneFanCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier: zoneFanCellReuseIdentifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let zoneID = currentZone?.zoneID else {
            
            return
        }
      
        allFans = SHSQLiteManager.shared.getFans(zoneID)
        
        if allFans.isEmpty {
            
             SVProgressHUD.showInfo(withStatus: SHLanguageText.noData)
        }
        
        fansListView.reloadData()
        
        self.performSelector(
            inBackground: #selector(readDevicesStatus),
            with: nil
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPhoneX_More() {
            
            bottomHeightConstraint.constant = tabBarHeight_iPhoneX_more
        }
    }

}

extension SHZoneFanViewController {
    
    /// 接收到广播
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        DispatchQueue.global().async {
            
            switch socketData.operatorCode {
                
            case 0x0032:
                
                let channelNumber = socketData.additionalData[0]
                
                if 0xF8 == socketData.additionalData[1] {
                    
                    for fan in self.allFans {
                        
                        if fan.subnetID == socketData.subNetID &&
                            fan.deviceID == socketData.deviceID &&
                            fan.channelNO == channelNumber {
                            
                            let fanSpeed = socketData.additionalData[2]
                            fan.fanSpeed =
                                SHFanSpeed(rawValue:fanSpeed) ?? .off
                        }
                    }
                }
                
            case 0x0034:
                
                let totalChannels = socketData.additionalData[0]
                
                for fan in self.allFans {
                    
                    if fan.subnetID == socketData.subNetID &&
                        fan.deviceID == socketData.deviceID &&
                        fan.channelNO <= totalChannels {
                        
                        let index = Int(fan.channelNO)
                        let fanSpeed = SHFanSpeed(rawValue: socketData.additionalData[index]) ?? .off
                        
                        fan.fanSpeed = fanSpeed
                    }
                }
                
            default:
                break
            }
            
            
            if socketData.operatorCode == 0x0034 ||
                socketData.operatorCode == 0x0032 {
                
                DispatchQueue.main.async {
                    
                    self.fansListView.reloadData()
                }
                
            }
        }
    }
    
    /// 读取状态
    @objc private func readDevicesStatus() {
        
        var subNetID: UInt8 = 0
        var deviceID: UInt8 = 0
        
        for fan in allFans {
            
            if fan.subnetID == subNetID &&
               fan.deviceID == deviceID {
                
                continue
            }
            
            subNetID = fan.subnetID
            deviceID = fan.deviceID
          
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
extension SHZoneFanViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allFans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: zoneFanCellReuseIdentifier,
                for: indexPath
                ) as! SHZoneFanViewCell
        
        cell.fan = allFans[indexPath.row]
        
        return cell
    }
}
