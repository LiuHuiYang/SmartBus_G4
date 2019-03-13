//
//  SHZoneHVACViewController.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/7/24.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

/*
 说明：模式与风速模式中
 1.HVAC控制的指令中，只有193B会显示实际值
 2.其它的操作指令只返回目标值
 
 E0ED中的模式坐标，只是模式/风速列表中的下标索引
 193B中的返回是真实的值和目标值
 
 状态的显示
 快速按钮的状态的匹配
 没有返回时，再读取一次状态
 */

import UIKit

class SHZoneHVACControlViewController: SHViewController {
    
    /// 当前的空调
    var currentHVAC: SHHVAC?
    
    /// 有效的 fanModel
    private var fanSpeedList: [SHAirConditioningFanSpeedType] =
        [.auto, .high, .medial, .low]
    
    /// 有效的 acModel
    private var acModelList: [SHAirConditioningModeType] =
        [.cool, .heat, .fan, .auto]
    
    /// 空调的基本配置信息
    private var hvacSetupInfo: SHHVACSetUpInfo? =
        SHSQLiteManager.shared.getHvacSetUpInfo()
    
    /// 风速图片名称
    private var fanSpeedImageName: [String] = [
        "autofan",
        "highfan",
        "mediumfan",
        "lowfan"
    ]
    
    /// 模式图片名称
    private var acModelImageName: [String] = [
        "coolModel",
        "heatModel",
        "fanModel",
        "autoModel"
    ]

    // MARK: - 约束条件
    
    /// 控制按钮的起始位置
    @IBOutlet weak var controlButtonStartY: NSLayoutConstraint!
    
    /// 空调标志基准高度
    @IBOutlet weak var acflagHeightConstraint: NSLayoutConstraint!
    
    /// 空调标志基准宽度
    @IBOutlet weak var acflagWidthConstraint: NSLayoutConstraint!
    
    /// 中间小图标宽度
    @IBOutlet weak var controlMiddleIconViewHeightConstraint: NSLayoutConstraint!
    
    /// 中间小图标宽度
    @IBOutlet weak var controlMiddleIconViewWidthConstraint: NSLayoutConstraint!
    
    /// 所有的空调按钮父视图的基础高度
    @IBOutlet weak var controlButtonSuperViewBaseHeightConstraint: NSLayoutConstraint!
    
    /// 所有的操作空调的按钮
    @IBOutlet weak var controlButtonHeightConstraint: NSLayoutConstraint!

    
    // MARK: - 中间UI部分

    /// 边框背景
    @IBOutlet weak var actemborderImageView: UIImageView!
    
    /// 空高开关的安钮
    @IBOutlet weak var turnAcButton: UIButton!
    
    /// 控制空调的显示视图
    @IBOutlet weak var controlView: UIView!
    
    // MARK: - 温度

    /// 显示显示占位区域
    @IBOutlet weak var temperatureView: UIView!
    
    /// 当前温度
    @IBOutlet weak var currentTempertureLabel: UILabel!
    
    /// 模式温度
    @IBOutlet weak var modelTemperatureLabel: UILabel!


    // MARK: - 功能控制部分
    
    /// 增加温度按钮
    @IBOutlet weak var addTemperatureButton: UIButton!
    
    /// 降低温度按钮
    @IBOutlet weak var reduceTemperatureButton: UIButton!
    
    /// 风速指示
    @IBOutlet weak var fanImageView: UIImageView!
    
    /// 风速指示按钮数组
    @IBOutlet var fanSpeedButtons: [UIButton]!

    /// 工作模式图片
    @IBOutlet weak var modelImageView: UIImageView!

    /// 模式按钮
    @IBOutlet var acModelButtons: [UIButton]!

    /// 快速制冷
    @IBOutlet weak var coldFastControlButton: UIButton!
    
    /// 快速凉快
    @IBOutlet weak var coolFastControlButton: UIButton!
    
    /// 快速暖和
    @IBOutlet weak var warmFastControlButton: UIButton!
    
    /// 快速制热
    @IBOutlet weak var hotFastControlButton: UIButton!
}


// MARK: - 读取状态与解析
extension SHZoneHVACControlViewController {
    
    // MARK: - 解析状态
    
    /// 解析状态
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        guard let hvac = currentHVAC else {
            return
        }
        
        // 温度传感器部分
        if socketData.operatorCode == 0xE3E8 &&
           socketData.subNetID == hvac.temperatureSensorSubNetID &&
           socketData.deviceID == hvac.temperatureSensorDeviceID {
            
            // 返回摄氏温度有效
            if socketData.additionalData[0] == 0 {
                return
            }
            
            let channel = Int(hvac.temperatureSensorChannelNo)
            
            let temperature = socketData.additionalData[channel]
            let flag = socketData.additionalData[channel + 8]
            
            hvac.sensorTemperature =
                Int((flag == 0) ? temperature : (0 - temperature))
            
            // 获得温度 设置空调相关的内容
            setAirConditionerStatus()
        
            // 空调部分 (coolmaster固件修改以后再将注释恢复)
        } else /*if ((subNetID == hvac.subnetID)  &&
             (deviceID == hvac.deviceID)) */ {
         
            switch socketData.operatorCode {
                
                // 配合 9in1 控制空调增加
            case 0xE01D:
                if socketData.subNetID != hvac.subnetID  ||
                    socketData.deviceID != hvac.deviceID {
                    break
                }
                
                let isPowerOn =
                    SHAirConditioningSwitchType.on.rawValue
                
                // 设置成功为1，否则是0
                if socketData.additionalData[1] != isPowerOn {
                    return
                }
                
                hvac.isTurnOn =
                    socketData.additionalData[0] == isPowerOn
                
                setAirConditionerStatus()
                
                // 返回状态
            case 0xE0ED:
                
                // FIXME: - coolmaster修改固件后需要修正
                if hvac.acTypeID == .coolMaster {
                    
                    if socketData.subNetID != hvac.temperatureSensorSubNetID ||
                        socketData.deviceType != hvac.temperatureSensorDeviceID {
                        
                        break
                    }
                    
                } else {
                    
                    if socketData.subNetID != hvac.subnetID ||
                        socketData.deviceID != hvac.deviceID {
                        
                        break
                    }
                }
                
                // HVAC的E0ED返回 只有8 个字节
                // 如果用户配置的是HVAC 直接执行
                // 如果是DDP或者是Relay要判断 可变参数的最后一个是通道号
                
                let whichOne =
                    hvac.acTypeID == .coolMaster ?
                        UInt8(hvac.acNumber - 1) : hvac.channelNo
                
                if socketData.additionalData.count != 8 &&
                    socketData.additionalData[socketData.additionalData.count - 1] != whichOne {
                    
                    break
                }
                
                hvac.isTurnOn =
                    socketData.additionalData[0] != 0
                
                hvac.coolTemperture = SHHVAC.realTemperature(
                    Int(socketData.additionalData[1])
                )
                
                let fanIndex =
                    Int(socketData.additionalData[2] & 0x0F)
                
                if fanIndex < fanSpeedList.count {
                    hvac.fanSpeed = fanSpeedList[fanIndex]
                }
                
                let modelIndex =
                    Int((socketData.additionalData[2] & 0xF0) >> 4)
                
                if modelIndex < acModelList.count {
                    hvac.acMode = acModelList[modelIndex]
                }
                
                
                hvac.indoorTemperature =
                    SHHVAC.realTemperature(
                        Int(socketData.additionalData[4])
                )
                
                hvac.heatTemperture =
                    SHHVAC.realTemperature(
                        Int(socketData.additionalData[5])
                )
                
                hvac.autoTemperture =
                    SHHVAC.realTemperature(
                        Int(socketData.additionalData[7])
                )
                
                setAirConditionerStatus()
                
            // DDP控制面板发出的数据 而HVAC/IR/Relay得到的响应
            case 0x193B :
                return
                if socketData.subNetID != hvac.subnetID ||
                    socketData.deviceID != hvac.deviceID {
                    
                    break
                }
                
                // 在增加单个继电器控制空调的功能前,
                // HVAC中,0X193B的返回长度是13
                // IR 中 0X193B的返回长度是14 且顺序与HVAC保持一致,后面多出来的参数暂时没用上
                // 增加单个继电器控制控制空调的0X193B的返回长度有变化是15。
                
                // 普通HAVC 不需要执行 if 语句
                // 继电器控制空调 需要依据最后一个参数的通道号 && 可变参数的度是15 来判断
                
                if socketData.additionalData.count == 15 &&
                    hvac.channelNo != socketData.additionalData[14] {
                    break
                }
                
                // coolmaster 需要判断是哪个AcNumber && 可变参数
                if hvac.acTypeID == .coolMaster &&
                    socketData.additionalData[0] != hvac.acNumber {
                    
                    break
                }
                
                // 获得温度单位 是否为摄氏温度
                hvac.isCelsius = socketData.additionalData[1] == 0
                  
                hvac.indoorTemperature =
                    SHHVAC.realTemperature(
                        Int(socketData.additionalData[2])
                )
                
                hvac.coolTemperture =
                    SHHVAC.realTemperature(
                        Int(socketData.additionalData[3])
                )
                
                hvac.heatTemperture =
                    SHHVAC.realTemperature(
                        Int(socketData.additionalData[4])
                )
                
                hvac.autoTemperture =
                    SHHVAC.realTemperature(
                        Int(socketData.additionalData[5])
                )
                
                hvac.isTurnOn = socketData.additionalData[8] != 0
                
                hvac.acMode =
                    SHAirConditioningModeType(
                        rawValue: socketData.additionalData[9]
                    ) ?? .cool
                
                hvac.fanSpeed =
                    SHAirConditioningFanSpeedType(
                        rawValue: socketData.additionalData[10]
                    ) ?? .auto
                
                setAirConditionerStatus()
                
            case 0xE3D9:
                
                if socketData.subNetID != hvac.subnetID ||
                    socketData.deviceID != hvac.deviceID {
                    
                    break
                }
                
                switch socketData.additionalData[0] {
                    
                case SHAirConditioningControlType.onAndOff.rawValue:
                    
                    hvac.isTurnOn =
                        socketData.additionalData[1] != 0
                    
                case SHAirConditioningControlType.fanSpeedSet.rawValue:
                    
                    hvac.fanSpeed =
                        SHAirConditioningFanSpeedType(
                            rawValue: socketData.additionalData[1]
                    ) ?? .auto
                    
                case SHAirConditioningControlType.acModeSet.rawValue:
                    
                    hvac.acMode =
                        SHAirConditioningModeType(
                            rawValue: socketData.additionalData[1]
                        ) ?? .cool
                case SHAirConditioningControlType.coolTemperatureSet.rawValue:
                    
                    hvac.coolTemperture =
                        SHHVAC.realTemperature(
                            Int(socketData.additionalData[1])
                    )
                    
                case SHAirConditioningControlType.heatTemperatureSet.rawValue:
                    
                    hvac.heatTemperture =
                        SHHVAC.realTemperature(
                            Int(socketData.additionalData[1])
                    )
                    
                case SHAirConditioningControlType.autoTemperatureSet.rawValue:
                    
                    hvac.autoTemperture =
                        SHHVAC.realTemperature(
                            Int(socketData.additionalData[1])
                    )
                    
                default:
                    break
                }
                
                setAirConditionerStatus()
                
                // 模式
            case 0xE125:
                if socketData.subNetID != hvac.subnetID ||
                    socketData.deviceID != hvac.deviceID {
                    
                    break
                }
                
                // 风速
                fanSpeedList.removeAll()
                
                let speedLength = Int(socketData.additionalData[0])
                
                
                for index in 1 ... speedLength {
                    
                    if let speed = SHAirConditioningFanSpeedType(rawValue: socketData.additionalData[index]) {
                        
                        fanSpeedList.append(speed)
                        
                        let fanSpeedButton =
                            fanSpeedButtons[index]
                        
//                        fanSpeedButton.isEnabled = true
                        
                    }
                }
                
                // 模式
                acModelList.removeAll()
                
                let modelLength = Int(socketData.additionalData[5])
                
                for index in 1 ... modelLength {
                    
                    if let model = SHAirConditioningModeType(rawValue: socketData.additionalData[index + 5]) {
                        
                        acModelList.append(model)
                    }
                }
                
                // 读取状态
                readHVACStatus()
                
                // 获得不同模式的温度范围
            case 0x1901:
                
                if socketData.subNetID != hvac.subnetID ||
                    socketData.deviceID != hvac.deviceID {
                    
                    break
                }
                
                // 说明：由于协议中没有与温度传感器正负，而是使用了补码的方式来表示
                
                // 制冷温度范围
                hvac.startCoolTemperatureRange = SHHVAC.realTemperature(
                        Int(socketData.additionalData[0])
                )
                
                hvac.endCoolTemperatureRange = SHHVAC.realTemperature(
                    Int(socketData.additionalData[1])
                )
                
                // 制热温度范
                hvac.startHeatTemperatureRange = SHHVAC.realTemperature(
                    Int(socketData.additionalData[2])
                )
                
                hvac.endHeatTemperatureRange = SHHVAC.realTemperature(
                    Int(socketData.additionalData[3])
                )
                
                // 自动模式温度范围
                hvac.startAutoTemperatureRange = SHHVAC.realTemperature(
                    Int(socketData.additionalData[4])
                )
                
                hvac.endAutoTemperatureRange = SHHVAC.realTemperature(
                    Int(socketData.additionalData[5])
                )
                
                // 获得温度单位
            case 0xE121:
                if socketData.subNetID != hvac.subnetID ||
                    socketData.deviceID != hvac.deviceID {
                    
                    break
                }
                
                hvac.isCelsius =
                    (hvac.acTypeID == .ir) ?
                        socketData.additionalData[0] != 0 :
                        socketData.additionalData[0] == 0
                
                setAirConditionerStatus()
                
            default:
                break
            }
        }
    }
    
    // MARK: - 读取空调的相关状态
    
    /// 读取HVAC的温度范围
    private func readHVACTemperatureRange() {
        
        guard let hvac = currentHVAC else {
            return
        }
        
        SHSocketTools.sendData(
            operatorCode: 0x1900,
            subNetID: hvac.subnetID,
            deviceID: hvac.deviceID,
            additionalData: []
        )
    }
    
    /// 读取空调的状态
    private func readHVACStatus() {
        
        guard let hvac = currentHVAC else {
            return
        }
        
        var subNetID = hvac.subnetID
        var deviceID = hvac.deviceID
        var additionalData = hvac.channelNo
        
        // coolmaster控制， 由于固件不支持读状态(返回都是8个0)，
        // 所以需要用户指定DDP来间接读取。
        if hvac.acTypeID == .coolMaster {
            
            subNetID = hvac.temperatureSensorSubNetID
            deviceID = hvac.temperatureSensorDeviceID
            additionalData = UInt8(hvac.acNumber - 1)
        }
        
        SHSocketTools.sendData(
            operatorCode: 0xE0EC,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: [additionalData]
        )
    }
}


// MARK: - 控制HVAC的
extension SHZoneHVACControlViewController {
    
    // MARK: - 开关控制
    
    /// 开关空调
    @IBAction func turnOnAndOffHVAC() {
        
        guard let hvac = currentHVAC else {
            return
        }
        
        controlView.isHidden = !hvac.isTurnOn
        
        // 因9in1增加 - 发送 0xE01C 1 - 开 2 -关
        let switchNo: UInt8 = !hvac.isTurnOn ? 1 : 2
        SHSocketTools.sendData(
            operatorCode: 0xE01C,
            subNetID: hvac.subnetID,
            deviceID: hvac.deviceID,
            additionalData: [switchNo, 0xFF]
        )
        
        // 普通方式
        controlAirConditioner(
            SHAirConditioningControlType.onAndOff.rawValue,
            value: !hvac.isTurnOn ? 1 : 0)
        
        Thread.sleep(forTimeInterval: 0.12)
        
        // 继电器控制方式 && 通用方式
        controlAirConditioner(
            isPowerOn: !hvac.isTurnOn,
            fanSpeed: hvac.fanSpeed,
            model: hvac.acMode,
            modelTemperature: 0,
            isChangeModelTemperature: false
        )
    }
    
    // MARK: - 温度变化
    
    /// 增加温度
    @IBAction func upTemperature() {
       
         changeAirConditionerTemperature(increase: true)
    }
    
    /// 降低温度
    @IBAction func lowerTemperature() {
        
         changeAirConditionerTemperature(increase: false)
    }
    
    /// 修改温度
    ///
    /// - Parameter increase: true 增加 false 减少
    private func changeAirConditionerTemperature(increase: Bool) {
        
        guard let hvac = currentHVAC,
            let string = modelTemperatureLabel.text as NSString?
            else {
                
                return
        }
        
        let range = string.range(of: " °") // 注意空格的问题
        
        if range.location == NSNotFound {
            return
        }
        
        var temperature =
            Int(string.substring(to: range.location)) ?? 0
        
        increase ?  (temperature += 1) : (temperature -= 1)
        
        changeAirConditionerModelTemperature(
            hvac.acMode,
            temperature: temperature
        )
    }
    
    /// 修改模式温度
    ///
    /// - Parameters:
    ///   - model: 模式
    ///   - temperature: 温度
    private func changeAirConditionerModelTemperature(
        _ model: SHAirConditioningModeType,
        temperature: Int) {
        
        guard let hvac = currentHVAC else {
            return
        }
        
        var controType: UInt8 = 0
        
        switch model {
        
        case .heat:
            controType =
                SHAirConditioningControlType.heatTemperatureSet.rawValue
            
            if temperature < hvac.startHeatTemperatureRange ||
               temperature > hvac.endHeatTemperatureRange {
                
                SVProgressHUD.showInfo(
                    withStatus: "Exceeding the set temperature"
                )
                return
            }
            
        case .fan, .cool:
            
            controType =
                SHAirConditioningControlType.coolTemperatureSet.rawValue
            
            if temperature < hvac.startCoolTemperatureRange ||
                temperature > hvac.endCoolTemperatureRange {
                
                SVProgressHUD.showInfo(
                    withStatus: "Exceeding the set temperature"
                )
                return
            }
            
        case .auto:
            
            controType =
                SHAirConditioningControlType.autoTemperatureSet.rawValue
            
            if temperature < hvac.startAutoTemperatureRange ||
                temperature > hvac.endAutoTemperatureRange {
                
                SVProgressHUD.showInfo(
                    withStatus: "Exceeding the set temperature"
                )
                return
            }
        
        default:
            break
        }
        
        modelTemperatureLabel.text =
            "\(temperature) " +
            "\((hvac.isCelsius) ? "°C" : "°F")"
        
        controlAirConditioner(
            controType,
            value: UInt8(SHHVAC.realTemperature(temperature))
        )
        
        Thread.sleep(forTimeInterval: 0.12)
        
        controlAirConditioner(
            isPowerOn: hvac.isTurnOn,
            fanSpeed: hvac.fanSpeed,
            model: model,
            modelTemperature: temperature,
            isChangeModelTemperature: true
        )
    }
    
    // MARK: - 风速变化
    
    /// 风速变化
    @IBAction func fanSpeedChange(_ fanSpeedButton: UIButton) {
        
        guard let index =
                fanSpeedButtons.index(of: fanSpeedButton),
            
            let fanSpeed =
                SHAirConditioningFanSpeedType(
                    rawValue: UInt8(index))
            
            else {
            
            return
        }
        
        changeAirConditionerFanSpeed(fanSpeed)
    }
    
    /// 控制风速
    private func changeAirConditionerFanSpeed(_ fanSpeed: SHAirConditioningFanSpeedType) {
        
        guard let hvac = currentHVAC,
            hvac.fanSpeed != fanSpeed else {
            return
        }
        
        fanSpeedButtons?[Int(hvac.fanSpeed.rawValue)].isSelected
            = false
        
        fanSpeedButtons?[Int(fanSpeed.rawValue)].isSelected
            = true
        
        if hvac.acTypeID == .coolMaster {
            
            controlAirConditioner(
                isPowerOn: hvac.isTurnOn,
                fanSpeed: fanSpeed,
                model: hvac.acMode,
                modelTemperature: 0,
                isChangeModelTemperature: false
            )
            
            return
        }
        
        controlAirConditioner(
            SHAirConditioningControlType.fanSpeedSet.rawValue,
            value: fanSpeed.rawValue
        )
    }

    // MARK: - 模式变化
    
    /// 模式变化
    @IBAction func acModelChange(_ acModelButton: UIButton) {
        
        guard let index =
            acModelButtons.index(of: acModelButton),
            
            let model =
            SHAirConditioningModeType(
                rawValue: UInt8(index))
            
            else {
                
                return
        }
        
        changeAirConditionerModel(model)
    }

    /// 控制空调模式
    private func changeAirConditionerModel(_ model: SHAirConditioningModeType) {
        
        guard let hvac = currentHVAC,
            hvac.acMode != model else {
                return
        }
        
        acModelButtons?[Int(hvac.acMode.rawValue)].isSelected
            = false
        
        acModelButtons?[Int(model.rawValue)].isSelected
            = true
        
        if hvac.acTypeID == .coolMaster {
            
            controlAirConditioner(
                isPowerOn: hvac.isTurnOn,
                fanSpeed: hvac.fanSpeed,
                model: model,
                modelTemperature: 0,
                isChangeModelTemperature: false
            )
            
            return
        }
        
        controlAirConditioner(
            SHAirConditioningControlType.acModeSet.rawValue,
            value: model.rawValue
        )
    }
    
    // MARK: - 快速控制
    
    /// 快速暖和
    @IBAction func coldFastControlButtonClick() {
        
        guard let temperature = hvacSetupInfo?.tempertureOfCold else {
            return
        }
        
        changeAirConditionerModel(.cool)
        
        changeAirConditionerModelTemperature(
            .cool,
            temperature: Int(temperature)
        )
    }
    
    /// 快速暖和
    @IBAction func coolFastControlButtonClick() {
        
        guard let temperature = hvacSetupInfo?.tempertureOfCool else {
            return
        }
        
        changeAirConditionerModel(.cool)
        
        changeAirConditionerModelTemperature(
            .cool,
            temperature: Int(temperature)
        )
    }
    
    /// 快速暖和
    @IBAction func warmFastControlButtonClick() {
        
        guard let temperature = hvacSetupInfo?.tempertureOfWarm else {
            return
        }
        
        changeAirConditionerModel(.heat)
        
        changeAirConditionerModelTemperature(
            .heat,
            temperature: Int(temperature)
        )
    }
    
    /// 快速制热
    @IBAction func hotFastControlButtonClick() {
        
        guard let temperature = hvacSetupInfo?.tempertureOfHot else {
            return
        }
        
        changeAirConditionerModel(.heat)
        
        changeAirConditionerModelTemperature(
            .heat,
            temperature: Int(temperature)
        )
    }

    // MARK: - 控制HVAC的常用指令
    
    /// 控制HVAC的普通指令 0xE3D8
    ///
    /// - Parameters:
    ///   - controlType: 控制类型
    ///   - value: 控制值
    private func controlAirConditioner(_ controlType: UInt8,
                                       value: UInt8) {
        
        guard let hvac = currentHVAC else {
            return
        }
        
        SHSocketTools.sendData(
            operatorCode: 0xE3D8,
            subNetID: hvac.subnetID,
            deviceID: hvac.deviceID,
            additionalData: [controlType, value]
        )
    }
    
    
    /// 控制空调的通用指令 0x193A
    ///
    /// - Parameters:
    ///   - isPowerOn: 开关状态
    ///   - fanSpeed: 风速
    ///   - model: 模式
    ///   - modelTemperature: 模式温度
    ///   - isChangeModelTemperature: 是否修改模式温度
    private func controlAirConditioner(
        isPowerOn: Bool,
        fanSpeed: SHAirConditioningFanSpeedType,
        model: SHAirConditioningModeType,
        modelTemperature: Int,
        isChangeModelTemperature: Bool ) {
        
        guard let hvac = currentHVAC else {
            return
        }
        
        // 一共有14个参数
        var additionalData = [UInt8](repeating: 0, count: 14)
        
        // default value is 1
        additionalData[0] =
            UInt8((hvac.channelNo == 0) ? hvac.acNumber : 1)
        
        additionalData[1] =
            hvac.isCelsius ? 0 : 1
        
        additionalData[2] = UInt8(hvac.indoorTemperature)
        additionalData[3] = UInt8(hvac.coolTemperture)
        additionalData[4] = UInt8(hvac.heatTemperture)
        additionalData[5] = UInt8(hvac.autoTemperture)
        
        if isChangeModelTemperature {
            
            switch model {
                
            case .cool, .fan:
                additionalData[3] = UInt8(modelTemperature)
                
            case .heat:
                additionalData[4] = UInt8(modelTemperature)
                
            case .auto:
                additionalData[5] = UInt8(modelTemperature)
            }
        }
        
        additionalData[7] =
            (hvac.acMode.rawValue << 4) | (hvac.fanSpeed.rawValue)
        
        additionalData[8] = isPowerOn ? 1 : 0
        additionalData[9] = model.rawValue
        additionalData[10] = fanSpeed.rawValue
        additionalData[13] = hvac.channelNo
        
        SHSocketTools.sendData(
            operatorCode: 0x193A,
            subNetID: hvac.subnetID,
            deviceID: hvac.deviceID,
            additionalData: additionalData
        )
    }
    
    // MARK: - 设置空调的状态
    
    /// 设置空调的状态
    private func setAirConditionerStatus() {
        
        guard let hvac = currentHVAC else {
            return
        }
        
        print("单位状态: \(hvac.isCelsius)")
        
        // 温度单位
        let unit = hvac.isCelsius ? "°C" : "°F"
        
        // 1.设置显示开和关
        controlView.isHidden = !hvac.isTurnOn
        turnAcButton.isSelected = hvac.isTurnOn
        
        // 2.设置环境温度
        var showAmbientTemperature = 0

        // 都有值求平均
        if hvac.indoorTemperature != 0 &&
            hvac.sensorTemperature != 0 {

            if hvac.isCelsius {

                showAmbientTemperature =
                    hvac.indoorTemperature + hvac.sensorTemperature

            } else {

                showAmbientTemperature =
                    hvac.indoorTemperature +
                    SHHVAC.centigradeConvert(toFahrenheit:
                        hvac.sensorTemperature
                )
            }

            showAmbientTemperature =
                Int(CGFloat(showAmbientTemperature) * 0.5)

            // 只有空调本身的值
        } else if hvac.indoorTemperature != 0 {

            showAmbientTemperature = hvac.indoorTemperature

        } else if hvac.sensorTemperature != 0 {

            showAmbientTemperature =
                hvac.isCelsius ?
                    hvac.sensorTemperature :
                SHHVAC.centigradeConvert(toFahrenheit:
                    hvac.sensorTemperature
            )
        }

        currentTempertureLabel.text =
            "\(showAmbientTemperature) \(unit)"
        
        print("当前风速 \(hvac.fanSpeed.rawValue)")
        
        
        // 3.设置风速等级
        let fanIndex = Int(hvac.fanSpeed.rawValue)
        
        for fanSpeedButton in fanSpeedButtons {
            fanSpeedButton.isEnabled = true
            fanSpeedButton.isSelected = false
        }
        
        fanImageView.image = UIImage(named:
            fanSpeedImageName[fanIndex]
        )
        
        fanSpeedButtons[fanIndex].isSelected = true
        
        // 4.模式温度
        let modelIndex = Int(hvac.acMode.rawValue)
        
        for modelButton in acModelButtons {
            modelButton.isEnabled = true
            modelButton.isSelected = false
        }
        
        modelImageView.image = UIImage(named:
            acModelImageName[modelIndex]
        )
        
        acModelButtons[modelIndex].isSelected = true
        
        // 模式温度
        var showModelTemperature = 0
        
        switch hvac.acMode {
            
        case .cool, .fan:
             showModelTemperature = hvac.coolTemperture
            
        case .heat:
            showModelTemperature = hvac.heatTemperture
            
        case .auto:
            showModelTemperature = hvac.autoTemperture
         
        }
        
        modelTemperatureLabel.text =
            "\(showModelTemperature) \(unit)"
        
        // 设置快速设置是否有用
    }
}

// MARK: - UI初始化
extension SHZoneHVACControlViewController {
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let hvac = currentHVAC else {
            return
        }
        
        // 读取温度单位
        SHSocketTools.sendData(
            operatorCode: 0xE120,
            subNetID: hvac.subnetID,
            deviceID: hvac.deviceID,
            additionalData: []
        )
        
        // 读取传感器的温度 内部温度统一使用摄氏
        SHSocketTools.sendData(
            operatorCode: 0xE3E7,
            subNetID: hvac.temperatureSensorSubNetID,
            deviceID: hvac.temperatureSensorDeviceID,
            additionalData: [1]
        )
        
        // 读取空调的工作模式与风速模式(有些固件不支持)
        SHSocketTools.sendData(
            operatorCode: 0xE124,
            subNetID: hvac.subnetID,
            deviceID: hvac.deviceID,
            additionalData: []
        )
        
        Thread.sleep(forTimeInterval: 0.3)
        
        readHVACTemperatureRange()
        
        Thread.sleep(forTimeInterval: 0.3)
        
        readHVACStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = currentHVAC?.acRemark
        turnAcButton.imageView?.contentMode = .scaleAspectFit
        controlView?.isHidden = true

        // DDP/CTP 是不需要通道的
        if currentHVAC?.temperatureSensorChannelNo == 0 {
            
            currentHVAC?.temperatureSensorChannelNo = 1
        }
        
        let font = UIView.suitLargerFontForPad()
        
        // 设置风速按钮
        let fanSpeedNames =
            SHLanguageTools.share()?.getTextFromPlist(
                "HVAC_IN_ZONE",
                withSubTitle: "FAN_BUTTON_NAMES"
        ) as! [String]
        
        for fanSpeedButton in fanSpeedButtons {
            
            fanSpeedButton.isEnabled = false
            fanSpeedButton.setRoundedRectangleBorder()
            
            if let index =
                fanSpeedButtons.index(of: fanSpeedButton) {
                
                fanSpeedButton.setTitle(
                    fanSpeedNames[index],
                    for: .normal
                )
            }

            if UIDevice.is_iPad() {
                
                fanSpeedButton.titleLabel?.font = font
            }
        }
        
        // 设置模式按钮
        let acModelNames =
            SHLanguageTools.share()?.getTextFromPlist(
                "HVAC_IN_ZONE",
                withSubTitle: "MODE_BUTTON_NAMES"
                ) as! [String]
        
        for acModelButton in acModelButtons {
            
            acModelButton.setRoundedRectangleBorder()
            
            if let index =
                acModelButtons.index(of: acModelButton) {
                
                acModelButton.setTitle(
                    acModelNames[index],
                    for: .normal
                )
            }
            
            if UIDevice.is_iPad() {
                
                acModelButton.titleLabel?.font = font
            }
        }
        
        // 设置快速控制  -- 新版本改成数字显示
        
        let unit = (hvacSetupInfo?.isCelsius ?? true) ? "°C" : "°F"
        
        coldFastControlButton.setTitle(
            "\(hvacSetupInfo?.tempertureOfCold ?? 16) \(unit)",
            for: .normal
        )
        
        coolFastControlButton.setTitle(
            "\(hvacSetupInfo?.tempertureOfCool ?? 22) \(unit)",
            for: .normal
        )
        
        warmFastControlButton.setTitle(
            "\(hvacSetupInfo?.tempertureOfWarm ?? 26) \(unit)",
            for: .normal
        )
        
        hotFastControlButton.setTitle(
            "\(hvacSetupInfo?.tempertureOfHot ?? 30) \(unit)",
            for: .normal
        )
        
        // 设置圆角
        addTemperatureButton.setRoundedRectangleBorder()
        reduceTemperatureButton.setRoundedRectangleBorder()
        coldFastControlButton.setRoundedRectangleBorder()
        coolFastControlButton.setRoundedRectangleBorder()
        warmFastControlButton.setRoundedRectangleBorder()
        hotFastControlButton.setRoundedRectangleBorder()

        // 设置字体
        if UIDevice.is_iPad() {
            
            currentTempertureLabel.font = font
            modelTemperatureLabel.font = font

            reduceTemperatureButton.titleLabel?.font = font
            addTemperatureButton.titleLabel?.font = font
            coldFastControlButton.titleLabel?.font = font
            coolFastControlButton.titleLabel?.font = font
            warmFastControlButton.titleLabel?.font = font
            hotFastControlButton.titleLabel?.font = font
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            acflagWidthConstraint.constant =
                navigationBarHeight
            
            acflagHeightConstraint.constant =
                navigationBarHeight
            
            // 控制空调部分
            controlButtonSuperViewBaseHeightConstraint.constant =
                navigationBarHeight + navigationBarHeight

            controlButtonHeightConstraint.constant =
                navigationBarHeight +
                (isPortrait ? tabBarHeight : statusBarHeight)

 
            // 中心小图标
            controlMiddleIconViewWidthConstraint.constant =
                navigationBarHeight + statusBarHeight
            
            controlMiddleIconViewHeightConstraint.constant =
                navigationBarHeight + statusBarHeight

        } else {
         
            if UIDevice.is3_5inch() {
                
                acflagWidthConstraint.constant = defaultHeight
                acflagHeightConstraint.constant = defaultHeight
                
                controlButtonHeightConstraint.constant =
                    defaultHeight

                controlButtonSuperViewBaseHeightConstraint.constant
                    = navigationBarHeight

                controlButtonStartY.constant = statusBarHeight

            } else {
                
                controlButtonSuperViewBaseHeightConstraint.constant
                    = navigationBarHeight + statusBarHeight

                controlButtonHeightConstraint.constant =
                    navigationBarHeight

            }
        }
    }
}
