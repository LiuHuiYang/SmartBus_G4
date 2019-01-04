//
//  SHZoneTemperatureSensorViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/19.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

/// 摄氏温度标示
private let unitFlag: UInt8 = 1 // 1代表摄氏 0 代表华氏

/// 温度cell重用标示符
private let zoneTemperatureReuseIdentifier =
    "SHZoneTemperatureViewCell"

class SHZoneTemperatureSensorViewController: SHViewController {

    /// 当前区域
    @objc var currentZone: SHZone?
    
    /// 所有的温度传感器(通道)
    lazy var allTemperatureSensors = [SHTemperatureSensor]()
    
    /// 定时器
    var timer: Timer?
    
    /// 温度显示列表
    @IBOutlet weak var temperatureListView: UITableView!
    
    /// 底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        temperatureListView.rowHeight =
            SHZoneTemperatureViewCell.rowHeight
        
        temperatureListView.register(
            UINib(nibName: zoneTemperatureReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
                zoneTemperatureReuseIdentifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let zoneID = currentZone?.zoneID,
         let sensors = (SHSQLManager.share()?.getTemperatureSensor(forZone: zoneID)) as? [SHTemperatureSensor] else {
            
            SVProgressHUD.showInfo(withStatus: SHLanguageText.noData)
            
            return
        }
        
        allTemperatureSensors = sensors
        
        temperatureListView.reloadData()
        
        timer =
            Timer(timeInterval: 3.0,
                  target: self,
                  selector: #selector(readTemperature),
                  userInfo: nil,
                  repeats: true
        )
        
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        
        timer?.fire()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPhoneX_More() {
        
            listViewBottomConstraint.constant = tabBarHeight_iPhoneX_more
        }
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }
}

//// 数据与解析
extension SHZoneTemperatureSensorViewController {
    
    /// 接收到广播
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        if socketData.operatorCode != 0xE3E8 {
            return
        }
        
        if socketData.additionalData[0] != unitFlag {
            return
        }
        
        for sensor in allTemperatureSensors {
            
            if sensor.subnetID == socketData.subNetID &&
                sensor.deviceID == socketData.deviceID &&
                sensor.channelNo >= 1       &&
                sensor.channelNo <= 8  {
                
                let index = Int(sensor.channelNo)
                
                let temperature = Int(socketData.additionalData[index])
                
                let realTemperature =
                    (socketData.additionalData[index + 8] == 0) ? temperature : (0 - temperature)
                
                sensor.currentValue = realTemperature
            }
        }
        
        temperatureListView.reloadData()
    }
    
    /// 读取温度
    @objc private func readTemperature() {
        
        var subNetID: UInt8 = 0
        var deviceID: UInt8 = 0
        
        for sensor in allTemperatureSensors {
            
            if sensor.subnetID == subNetID &&
                sensor.deviceID == deviceID {
                
                continue
            }
            
            subNetID = sensor.subnetID
            deviceID = sensor.deviceID
            
            let unitData: [UInt8]  = [unitFlag]
         
            SHSocketTools.sendData(
                operatorCode: 0xE3E7,
                subNetID: subNetID,
                deviceID: deviceID,
                additionalData: unitData
            )
        }
    }
}

// MARK: - UITableViewDataSource
extension SHZoneTemperatureSensorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allTemperatureSensors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: zoneTemperatureReuseIdentifier,
                for: indexPath
            ) as! SHZoneTemperatureViewCell
        
        cell.temperatureSensor =
            allTemperatureSensors[indexPath.row]
        
        return cell
    }
    
}
