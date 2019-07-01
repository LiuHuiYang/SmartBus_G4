//
//  SHZoneLightViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/7/24.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

/// lightcell重用标示符
private let zoneLightCellIReusabledentifier =
    "SHZoneControlLightViewCell"

class SHZoneLightViewController: SHViewController {

    /// 当前区域
    var currentZone: SHZone?
    
    /// 所有的灯
    private lazy var allLights = [SHLight]()
    
    /// 灯具列表
    @IBOutlet weak var lightListView: UITableView!
    
    /// 底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!
}

// MARK: - 设备状态
extension SHZoneLightViewController {
    
    /// 接收到广播数据
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        switch socketData.operatorCode {
            
        case 0xEFFF:
            
            // 1.获得区域总数
            let zoneCount = Int(socketData.additionalData[0])
            
            // 2.获得模块的总通道数量
            let channelCount = Int(socketData.additionalData[zoneCount + 1])
            
            let bytes =
                channelCount / 8 + (channelCount % 8 == 0 ? 0 : 1)
            
            // 3.获得每个通道的具体状态
            // 所有通道的状态，通道状态的字节数(每个通道的状态用一个bit来表示)
            var statusForChannel =
                [UInt8](repeating: 0, count: Int(channelCount))
            
            var channelIndex = 0; // 所有通道的状态索引
            
            for section in 0 ..< bytes {
                
                // 获得具体的值 -- 代表一个字节
                var channelStatus =
                    socketData.additionalData[zoneCount + 2 + section];
                
                for bit in 0 ..< 8 {
                    
                    let lightBress =
                        ((channelStatus & 0x01) != 0) ? lightMaxBrightness : 0;
                    
                    channelIndex = bit + 8 * section
                    
                    // 超出范围不要赋值
                    if channelIndex >= channelCount {
                        break
                    }
                   
                    statusForChannel[channelIndex] = lightBress;
                    channelStatus >>= 1
                }
            }
            
            // 设置具体的亮度
            for light in allLights {
                
                if !light.isUnwantedEFFF &&
                    light.subnetID == socketData.subNetID &&
                    light.deviceID == socketData.deviceID &&
                    light.channelNo <= channelCount {
                    
                    let brightness =
                        statusForChannel[Int(light.channelNo) - 1]
                    
                    if light.brightness != brightness &&
                        light.brightness == 0 {
                        
                        light.brightness = brightness
                    }
                }
            }
            
        case 0x0032:
            
            if (socketData.additionalData[1] == 0xF8) {
                
                let brightness = socketData.additionalData[2];
                
                let channelNumber = socketData.additionalData[0];
                
                for light in allLights {
                    
                    if light.subnetID == socketData.subNetID &&
                        light.deviceID == socketData.deviceID &&
                        light.channelNo == channelNumber {
                        
                        light.brightness = brightness
                        light.isUnwantedEFFF = true
                    }
                }
            }
            
        case 0xF081:
            
            if 0xF8 != socketData.additionalData[0] {
                break
            }
            
            getLEDstatus(socketData)
            
        case 0x0034:
            
            // LED
            if socketData.deviceType == 0x0382 &&
                socketData.additionalData.count == 5 {
                
                getLEDstatus(socketData)
                
            } else {  // 普通灯泡
                
                let totalChannels = socketData.additionalData[0]
                
                for light in allLights {
                    
                    if light.subnetID == socketData.subNetID &&
                        light.deviceID == socketData.deviceID &&
                        light.channelNo <= totalChannels {
                        
                        light.brightness = socketData.additionalData[Int(light.channelNo)]
                        
                        if light.canDim == .notDimmable {
                            
                            light.brightness =
                                (light.brightness == lightMaxBrightness) ? lightMaxBrightness : 0
                        }
                    }
                }
                
            }
            
        default:
            break
        }
        
        
        
        if (socketData.operatorCode == 0x0034 ||
            socketData.operatorCode == 0x0032 ||
            socketData.operatorCode == 0xF081 ||
            socketData.operatorCode == 0xEFFF) {
            
            lightListView.reloadData()
        }
    }
    
    /// 获得LED的状态
    private func getLEDstatus(_ socketData: SHSocketData) {
        
        // 获得每个通道的值
        let red   = socketData.additionalData[1]
        let green = socketData.additionalData[2]
        let blue  = socketData.additionalData[3]
        let white = socketData.additionalData[4]
        
        for light in allLights {
            
            if light.subnetID == socketData.subNetID &&
                light.deviceID == socketData.deviceID {
                
                // 这是将LED当成一个整体来控制的情况
                light.redColorValue = red
                light.greenColorValue = green
                light.blueColorValue = blue
                light.whiteColorValue = white
                
                light.ledHaveColor =
                    (red != 0)  || (green != 0)  ||
                    (blue != 0) || (white != 0)
                
                // 这是将LED中的每个颜色通道【独立】看成一个灯 (另一种方式)
                
                switch light.channelNo {
                    
                case SHZoneControllightLEDChannel.red.rawValue:
                    light.brightness = red
                    
                case SHZoneControllightLEDChannel.green.rawValue:
                    light.brightness = green
                    
                case SHZoneControllightLEDChannel.blue.rawValue:
                    light.brightness = blue
                    
                case SHZoneControllightLEDChannel.white.rawValue:
                    light.brightness = white
                    
                default:
                    break
                }
            }
        }
    }
    
    
    /// 读取状态
    private func readDevicesStatus() {
        
        var subNetID: UInt8 = 0
        var deviceID: UInt8 = 0
        
        for light in allLights {
            
            if light.subnetID == subNetID &&
                light.deviceID == deviceID {
                
                continue
            }
            
            subNetID = light.subnetID
            deviceID = light.deviceID
            
            SHSocketTools.sendData(
                operatorCode: 0x0033,
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

// MARK: - UI
extension SHZoneLightViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightListView.rowHeight =
            SHZoneControlLightViewCell.rowHeight
        
        lightListView.register(
            UINib(nibName: zoneLightCellIReusabledentifier,
                  bundle: nil),
            forCellReuseIdentifier:
            zoneLightCellIReusabledentifier
        )
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let zoneID = currentZone?.zoneID
            else {
                
            return
        }
        
        allLights = SHSQLiteManager.shared.getLights(zoneID)
        
        if allLights.isEmpty {
            
            SVProgressHUD.showInfo(withStatus:
                SHLanguageText.noData
            )
        }
        
        lightListView.reloadData()
        
        readDevicesStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPhoneX_More() {
            
            listViewBottomConstraint.constant =
            tabBarHeight_iPhoneX_more
        }
    }
}

// MARK: - UITableViewDataSource
extension SHZoneLightViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allLights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: zoneLightCellIReusabledentifier,
                for: indexPath
                ) as! SHZoneControlLightViewCell
        
        cell.light = allLights[indexPath.row]
        
        return cell
    }
    
    
}

