//
//  SHZoneNineInOneControlViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/20.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHZoneNineInOneControlViewController: SHViewController {

    /// 九合一
    var currentNineInOne: SHNineInOne?
    
    // MARK: -  三个不同的view
    
    /// 控制面板
    var controlPadView: SHZoneNineInOneControlPadView?
    
    /// 数字面板
    var numberPadView: SHZoneNineInOneNumberPadView?
    
    /// 备用面板
    var sparePadView: SHZoneNineInOneSparePadView?
    
    /// 分组按钮控制高度
    @IBOutlet weak var switchButtonHeightConstraint: NSLayoutConstraint!
    
    /// 切换按钮的父视图高度
    @IBOutlet weak var swithButtonViewHeightConstraint: NSLayoutConstraint!

    
    // MARK: - 几个传感器的值
    
    /// lux的值标签
    @IBOutlet weak var luxSensorLabel: UILabel!
    
    /// 4T温度值
    @IBOutlet weak var sensor4TLabel: UILabel!
    
    /// ddp温度值
    @IBOutlet weak var ddpLabel: UILabel!
    
    /// 外部传感器的值
    @IBOutlet weak var externalLabel: UILabel!
    
    /// lux的值标签
    @IBOutlet weak var luxSensorValueLabel: UILabel!
    
    /// 4T温度值
    @IBOutlet weak var sensor4TValueLabel: UILabel!
    
    /// ddp温度值
    @IBOutlet weak var ddpValueLabel: UILabel!
    
    /// 外部传感器的值
    @IBOutlet weak var externalValueLabel: UILabel!
    
    // MARK: - 切换面板
    
    /// 显示控制指令面板
    @IBOutlet weak var commandView: UIView!
    
    /// 控制面板铵钮
    @IBOutlet weak var controlButton: UIButton!
    
    /// 数字面板按钮
    @IBOutlet weak var numPadButton: UIButton!
    
    /// 备用面板按钮
    @IBOutlet weak var spareButton: UIButton!
    
    /// 不同的内容显示方式
    @IBOutlet weak var showPannelView: UIView!
    
    // MARK: - 点击事件
    
    /// 数字键盘
    @IBAction func numberPadButtonClick() {
    
        controlButton.isSelected = false
        spareButton.isSelected = false
        numPadButton.isSelected = true
        
        if numberPadView?.window == nil {
            
            numberPadView = SHZoneNineInOneNumberPadView.loadFromNib()
            showPannelView.addSubview(numberPadView!)
        }
        
        controlPadView?.isHidden = true
        numberPadView?.isHidden = false
        sparePadView?.isHidden = true
        numberPadView?.nineInOne = currentNineInOne
    }
    
    /// 频道
    @IBAction func spareButtonClick() {
    
        controlButton.isSelected = false
        spareButton.isSelected = true
        numPadButton.isSelected = false
        
        if sparePadView?.window == nil {
            
            sparePadView = SHZoneNineInOneSparePadView.loadFromNib()
            showPannelView.addSubview(sparePadView!)
        }
        
        controlPadView?.isHidden = true
        numberPadView?.isHidden = true
        sparePadView?.isHidden = false
        sparePadView?.nineInOne = currentNineInOne
    }
    
    /// 控制
    @IBAction func controlButtonClick() {

        controlButton.isSelected = true
        spareButton.isSelected = false
        numPadButton.isSelected = false
        
        if controlPadView?.window == nil {
            
            controlPadView = SHZoneNineInOneControlPadView.loadFromNib();
            
            showPannelView.addSubview(controlPadView!)
        }
        
        controlPadView?.isHidden = false
        numberPadView?.isHidden = true
        sparePadView?.isHidden = true
        controlPadView?.nineInOne = currentNineInOne
    }
}


// MARK: - 状态与解析
extension SHZoneNineInOneControlViewController {
    
    /// 接收到了数据
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        guard let nineInOne = currentNineInOne else {
            return
        }
        
        switch socketData.operatorCode {
        
        case 0x018D:
            
            if socketData.subNetID == nineInOne.subnetID &&
                socketData.deviceID == nineInOne.deviceID {
                
                nineInOne.ddpTemperatureDisenabled = (socketData.additionalData[3] != 0)

                nineInOne.ddpSubNetID =
                    socketData.additionalData[4]
                
                nineInOne.ddpDeviceID = socketData.additionalData[5]
                
                nineInOne.sensor4TTemperatureDisenabled =
                    (socketData.additionalData[7] != 0)
                
                nineInOne.sensor4TSubNetID =
                    socketData.additionalData[ 8]
                
                nineInOne.sensor4TDeviceID =
                    socketData.additionalData[9]
                
                nineInOne.sensor4TChannelNo = socketData.additionalData[10]
                
                nineInOne.getWayOfTemperature =
                    SHNineInOneGetWayOfTemperatureType(
                        rawValue: socketData.additionalData[11]
                    ) ?? .average
                
                
                // 准备开始读取传感器的值
                
                // 读LUX
                SHSocketTools.sendData(
                    operatorCode: 0xD992,
                    subNetID: nineInOne.subnetID,
                    deviceID: nineInOne.deviceID,
                    additionalData: []
                )
                
                // 读外部温度
                SHSocketTools.sendData(
                    operatorCode: 0xE3E7,
                    subNetID: nineInOne.subnetID,
                    deviceID: nineInOne.deviceID,
                    additionalData: [1]
                )
                
                // 读DDP温度
                SHSocketTools.sendData(
                    operatorCode: 0xE3E7,
                    subNetID: nineInOne.ddpSubNetID,
                    deviceID: nineInOne.ddpDeviceID,
                    additionalData: [1]
                )
                
                // 读4T温度
                SHSocketTools.sendData(
                    operatorCode: 0xE3E7,
                    subNetID: nineInOne.sensor4TSubNetID,
                    deviceID: nineInOne.sensor4TDeviceID,
                    additionalData: [1]
                )
                
                // 读LUX
                SHSocketTools.sendData(
                    operatorCode: 0xD992,
                    subNetID: nineInOne.subnetID,
                    deviceID: nineInOne.deviceID,
                    additionalData: []
                )
            }
            
            // lux
        case 0xD993:
            
            if socketData.subNetID == nineInOne.subnetID &&
                socketData.deviceID == nineInOne.deviceID { 
                
                nineInOne.luxValue =
                    UInt(socketData.additionalData[0]) << 8 +
                    UInt(socketData.additionalData[1])
            }
            
            // 温度传感器
        case 0xE3E8:
           
            // 返回摄氏温度有效
            if socketData.additionalData[0] == 0 ||
               socketData.additionalData.count != 17
                {
                return;
            }
            
            // 4T Temperature
            if (socketData.subNetID == nineInOne.sensor4TSubNetID &&
                socketData.deviceID == nineInOne.sensor4TDeviceID) {
                
                let index = Int(nineInOne.sensor4TChannelNo)
                
                let isNonNegative =
                    socketData.additionalData[index + 8] == 0
                
                let temperature =
                    Int(socketData.additionalData[index])
                
                nineInOne.sensor4TTemperature =
                    isNonNegative ? temperature : (0 - temperature)
                
 
            } else {
                
                
                let isNonNegative =
                    socketData.additionalData[1 + 8] == 0
                
                let temperature = Int(socketData.additionalData[1])
                
                let realTemperature =
                    isNonNegative ? temperature : (0 - temperature)
                
                // external Temperature
                if (socketData.subNetID == nineInOne.subnetID &&
                    socketData.deviceID == nineInOne.deviceID) {
                    
                    nineInOne.externalTemperature = realTemperature
                }
                
                //  DDP Temperature
                if (socketData.subNetID == nineInOne.ddpSubNetID &&
                    socketData.deviceID == nineInOne.ddpDeviceID) {
               
                    nineInOne.ddpTemperature = realTemperature
                }
            }
            
        default:
            break
        }
        
        if socketData.operatorCode == 0xD993 ||
           socketData.operatorCode == 0xE3E8 {
           
            DispatchQueue.main.async {
                 self.setNineInOneStatus(nineInOne)
            }
        }
    }
    
    /// 读取状态
    private func readDevicesStatus() {
        
        if let nineInOne = currentNineInOne {
            
            SHSocketTools.sendData(
                operatorCode: 0x018C,
                subNetID: nineInOne.subnetID,
                deviceID: nineInOne.deviceID,
                additionalData: []
            )
        }
    }
    
    override func becomeFocus() {
        super.becomeFocus()
        
        if isViewLoaded &&
            view.window != nil {
            
            readDevicesStatus()
        }
    }
}


// MARK: - UI
extension SHZoneNineInOneControlViewController {
    
    /// 设置状态
    private func setNineInOneStatus(_ nineInOne: SHNineInOne) {
        
        luxSensorValueLabel.text = "\(nineInOne.luxValue)"
        
        // 模式温度
        let externalTemperatureCen = SHHVAC.centigradeConvert(toFahrenheit: nineInOne.externalTemperature)
        
        externalValueLabel.text = "\(nineInOne.externalTemperature) °C (\(externalTemperatureCen) °F)"
        
        // DDP
        let ddpTemperatureCen = SHHVAC.centigradeConvert(toFahrenheit: nineInOne.ddpTemperature)
        
        ddpValueLabel.text = "\(nineInOne.ddpTemperature) °C (\(ddpTemperatureCen) °F)"
        
        // 4T
        let sensor4TTemperatureCen = SHHVAC.centigradeConvert(toFahrenheit: nineInOne.sensor4TTemperature)
        
        sensor4TValueLabel.text = "\(nineInOne.sensor4TTemperature) °C (\(sensor4TTemperatureCen) °F)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title =
            "\(currentNineInOne?.nineInOneName ?? "9in1")"
        
        controlButton.setTitle(
            SHLanguageText.control,
            for: .normal
        )
        
        numPadButton.setTitle(
            SHLanguageText.numberPad,
            for: .normal
        )
        
        spareButton.setTitle(
            SHLanguageText.add,
            for: .normal
        )
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            externalLabel.font = font
            externalValueLabel.font = font
            ddpLabel.font = font
            ddpValueLabel.font = font
            luxSensorLabel.font = font
            luxSensorValueLabel.font = font
            sensor4TLabel.font = font
            sensor4TValueLabel.font = font
            
            controlButton.titleLabel?.font = font
            spareButton.titleLabel?.font = font
            numPadButton.titleLabel?.font = font
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 默认选择控制面板
        controlButtonClick()
    
        readDevicesStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        controlPadView?.frame = showPannelView.bounds
        numberPadView?.frame = showPannelView.bounds
        sparePadView?.frame = showPannelView.bounds
        
        if UIDevice.is_iPad() {
            
            swithButtonViewHeightConstraint.constant = navigationBarHeight + statusBarHeight
        }
    }
}
