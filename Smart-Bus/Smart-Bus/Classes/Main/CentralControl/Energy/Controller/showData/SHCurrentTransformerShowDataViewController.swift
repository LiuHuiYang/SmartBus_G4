//
//  SHCurrentTransformerShowDataViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2018/11/14.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// CT24 通道总数
private let currentTransformerCount: Int = 24

/// 重用标示
private let currentTransformerChannelDataCellReuseIdentifier = "SHCurrentTransformerChannelDataViewCell"

class SHCurrentTransformerShowDataViewController: SHViewController {

    /// CT24
    var currentTransformer: SHCurrentTransformer?
    
    /// 电流值大小
    private lazy var allChannels: [SHCurrentTransformerChannel] = {

        var array = [SHCurrentTransformerChannel]()

        for i in 0 ..< currentTransformerCount {

            let channel = SHCurrentTransformerChannel()
            channel.name = channelArray[i]
            channel.current = 0
            channel.power = 0.0
            
            array.append(channel)
        }

        return array
    }()
    
    /// 通道数组(横坐标)
    private lazy var channelArray: [String] = [
        currentTransformer?.channel1 ?? "CH1",
        currentTransformer?.channel2 ?? "CH2",
        currentTransformer?.channel3 ?? "CH3",
        currentTransformer?.channel4 ?? "CH4",
        currentTransformer?.channel5 ?? "CH5",
        currentTransformer?.channel6 ?? "CH6",
        currentTransformer?.channel7 ?? "CH7",
        currentTransformer?.channel8 ?? "CH8",
        currentTransformer?.channel9 ?? "CH9",
        currentTransformer?.channel10 ?? "CH10",
        currentTransformer?.channel11 ?? "CH11",
        currentTransformer?.channel12 ?? "CH12",
        currentTransformer?.channel13 ?? "CH13",
        currentTransformer?.channel14 ?? "CH14",
        currentTransformer?.channel15 ?? "CH15",
        currentTransformer?.channel16 ?? "CH16",
        currentTransformer?.channel17 ?? "CH17",
        currentTransformer?.channel18 ?? "CH18",
        currentTransformer?.channel19 ?? "CH19",
        currentTransformer?.channel20 ?? "CH20",
        currentTransformer?.channel21 ?? "CH21",
        currentTransformer?.channel22 ?? "CH22",
        currentTransformer?.channel23 ?? "CH23",
        currentTransformer?.channel24 ?? "CH24"
    ]
    
    /// 通道名称
    @IBOutlet weak var channelsLabel: UILabel!
    
    /// 电压标签 
    @IBOutlet weak var voltageLabel: UILabel!
    
    /// 电流
    @IBOutlet weak var currentLabel: UILabel!
    
    /// 功率
    @IBOutlet weak var powerLabel: UILabel!
    
    /// 显示列表
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = currentTransformer?.remark
        
        voltageLabel.text = "Voltage: \(currentTransformer?.voltage ?? 1) V"

        listView.rowHeight =
            SHCurrentTransformerChannelDataViewCell.rowheight
        
        listView.register(
            UINib(nibName:
                currentTransformerChannelDataCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
                currentTransformerChannelDataCellReuseIdentifier
        )
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            channelsLabel.font = font
            voltageLabel.font = font
            currentLabel.font = font
            powerLabel.font = font
        }
    }
}


// MARK: - 状态与解析
extension SHCurrentTransformerShowDataViewController {
    
    /// 接收广播数据
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        if socketData.operatorCode != 0x0151 ||
            socketData.subNetID != currentTransformer?.subnetID ||
            socketData.deviceID != currentTransformer?.deviceID {
            return
        }
        
        // ======= 解析数据
        for index in 0 ..< currentTransformerCount {
            
            // 每个通道号对应的两个字节的序号
            let highChannel = index * 2
            let lowChannel = index * 2 + 1
            
            // 实时电流的单位是 ma
            let currentValue =
                (
                    UInt(socketData.additionalData[highChannel]) << 8) |
                    UInt(socketData.additionalData[lowChannel]
            )
            
            if currentValue != allChannels[index].current {
                
                // 功率KW = 电压V X 电流A X 0.001
                allChannels[index].current = currentValue
                
                let power = Int(CGFloat((currentTransformer?.voltage ?? 1) * currentValue) * 0.001)
                
                allChannels[index].power = CGFloat(power) * 0.001
                
                listView.reloadRows(
                    at: [IndexPath(row: index, section: 0)],
                    with: .fade
                )
            }
        }
    }
    
    
    /// 读取状态
    private func readDevicestatus() {

        SHSocketTools.sendData(
            operatorCode: 0x0150,
            subNetID: currentTransformer?.subnetID ?? 0,
            deviceID: currentTransformer?.deviceID ?? 0,
            additionalData: []
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readDevicestatus()
    }
}

// MARK: - 数据源
extension SHCurrentTransformerShowDataViewController:UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return currentTransformerCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: currentTransformerChannelDataCellReuseIdentifier, for: indexPath) as! SHCurrentTransformerChannelDataViewCell
        
        cell.channel = allChannels[indexPath.row]
        
        return cell
    }
}
