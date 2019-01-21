//
//  SHDmxChannelViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/4.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

private let zoneDmxChannelViewCellReuseIdentifier =
    "SHZoneDmxChannelViewCell"

@objcMembers class SHDmxChannelViewController: SHViewController {
    
    /// 当前的dmx分组
    var dmxGroup: SHDmxGroup?
    
    /// 所有的通道
    private lazy var groupChannels = [SHDmxChannel]()

    /// 列表
    @IBOutlet weak var channelListView: UITableView!
 
}


// MARK: - 获取状态与解析
extension SHDmxChannelViewController {
    
    /// 接收到广播
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        if socketData.operatorCode == 0x0032 &&
           socketData.additionalData[1] == 0xF8 {
           
            for dmxChannel in groupChannels {
                
                if dmxChannel.subnetID == socketData.subNetID &&
                    dmxChannel.deviceID == socketData.deviceID &&
                    dmxChannel.channelNo == socketData.additionalData[0] {
                    
                    dmxChannel.brightness =
                        socketData.additionalData[2]
                }
            }
            
        } else if socketData.operatorCode == 0x0034 {
            
            let totalChannels = socketData.additionalData[0]
            
            for dmxChannel in groupChannels {
                
                if dmxChannel.subnetID == socketData.subNetID &&
                    dmxChannel.deviceID == socketData.deviceID &&
                    dmxChannel.channelNo <= totalChannels {
                    
                    let index = Int(dmxChannel.channelNo)
                    
                    dmxChannel.brightness =
                        socketData.additionalData[index]
                }
            }
            
        } else {
           
            
            return
        }
    
        
        channelListView.reloadData()
    }
    
    /// 读取状态
    private func readDeviceStatus() {
        
        var subNetID: UInt8 = 0
        var deviceID: UInt8 = 0
        
        for channel in groupChannels {
            
            if channel.subnetID == subNetID &&
               channel.deviceID == deviceID {
                
                continue
            }
            
            subNetID = channel.subnetID
            deviceID = channel.deviceID
            
            SHSocketTools.sendData(
                operatorCode: 0x0033,
                subNetID: subNetID,
                deviceID: deviceID,
                additionalData: [],
                isDMX: true
            )
            
        }
    }
}


// MARK: - UITableViewDataSource
extension SHDmxChannelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier:
                    zoneDmxChannelViewCellReuseIdentifier,
                for: indexPath
            ) as! SHZoneDmxChannelViewCell
        
        cell.dmxChannel = groupChannels[indexPath.row]
        
        return cell
    }
    
    
    
}

// MARK: - UI初始化
extension SHDmxChannelViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelListView.register(
            UINib(
                nibName: zoneDmxChannelViewCellReuseIdentifier,
                bundle: nil
            ),
            forCellReuseIdentifier:
            zoneDmxChannelViewCellReuseIdentifier
        )
        
        channelListView.rowHeight =
            SHZoneDmxChannelViewCell.rowHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let group = dmxGroup else {
            
            return
        }
        groupChannels =
            SHSQLiteManager.shared.getDmxGroupChannels(group)
        
        if groupChannels.isEmpty {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
            
            return
        }
        
        readDeviceStatus()
    }
}
