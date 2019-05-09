//
//  SHZoneControlFloorHeatingControlViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/7.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHZoneControlFloorHeatingControlViewController: SHViewController {
    
    /// 选择的地热
    var currentFloorHeating: SHFloorHeating?
    
    /// 选择的按钮
    var selecTimeButton: UIButton?
    
    /// 设置过传感器温度
    var isSetSensorTemperature = false
    
    // MARK: - 约束条件
    
    /// 顶部的距离
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    /// pickerView的顶部距离
    @IBOutlet weak var datePickerViewTopConstraint: NSLayoutConstraint!
    
    /// 分组基准高度
    @IBOutlet weak var groupViewHeightConstraint: NSLayoutConstraint!
    
    /// 控制按钮的高度
    @IBOutlet weak var controlButtonHeightConstraint: NSLayoutConstraint!
    
    /// 控制按钮的宽度
    @IBOutlet weak var controlButtonWidthConstraint: NSLayoutConstraint!
    
    // MARK: - UI属性
    
    /// 显示显示View
    @IBOutlet weak var temperatureView: UIView!
    
    /// 室内温度边框
    @IBOutlet weak var indoorTemperatureBorderView: UIImageView!
    
    /// 室外温度边框
    @IBOutlet weak var outdoorTemperatureBorderView: UIImageView!
    
    /// 开关地热
    @IBOutlet weak var turnFloorHeatingButton: UIButton!
    
    /// 室内温度
    @IBOutlet weak var indoorTemperatureLabel: UILabel!
    
    /// 室外温度
    @IBOutlet weak var outdoorTemperatureLabel: UILabel!
    
    /// 增加温度按钮
    @IBOutlet weak var addTemperatureButton: UIButton!
    
    /// 降低温度按钮
    @IBOutlet weak var reduceTemperatureButton: UIButton!
    
    /// 模式温度
    @IBOutlet weak var modelTemperatureLabel: UILabel!
    
    /// 控制面板
    @IBOutlet weak var controlView: UIView!
    
    /// 手动模式按钮
    @IBOutlet weak var manualButton: SHCommandButton!
    
    /// 白天模式按钮
    @IBOutlet weak var dayButton: SHCommandButton!
    
    /// 夜间模式
    @IBOutlet weak var nightButton: SHCommandButton!
    
    /// 离开模式按钮
    @IBOutlet weak var awayButton: SHCommandButton!
    
    /// 定时器模式按钮
    @IBOutlet weak var timerButton: SHCommandButton!
    
    /// 白天开始时间
    @IBOutlet weak var dayTimeButton: UIButton!
    
    /// 白天结束时间
    @IBOutlet weak var nightTimeButton: UIButton!
    
    /// 日期选择
    @IBOutlet weak var datePicker: UIDatePicker!
    
}



// MARK: - 读取状态与解析
extension SHZoneControlFloorHeatingControlViewController {
    
    /// 接收到广播数据
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        guard let floorHeating = currentFloorHeating else {
            return
        }
        
        DispatchQueue.global().async {
            
            switch socketData.operatorCode {
                
            case 0xEFFF:
                break
                
            // 地热操作
            case 0xE3D9:
                
                if socketData.subNetID != floorHeating.subnetID ||
                    
                    socketData.deviceID != floorHeating.deviceID ||
                    
                    socketData.additionalData[2] != floorHeating.channelNo {
                    
                    return
                }
                
                let operatorKind =
                    socketData.additionalData[0]
                
                let operatorResult =
                    socketData.additionalData[1]
                
                switch operatorKind {
                    
                case SHFloorHeatingControlType.onAndOff.rawValue:
                    
                    floorHeating.isTurnOn =
                        operatorResult != 0
                    
                case SHFloorHeatingControlType.modelSet.rawValue:
                    
                    floorHeating.floorHeatingModeType =
                        SHFloorHeatingModeType(
                            rawValue: operatorResult
                        ) ?? .manual
                    
                case SHFloorHeatingControlType.temperatureSet.rawValue:
                    
                    floorHeating.manualTemperature =
                        Int(operatorResult)
                    
                default:
                    break
                }
                
            // 获得开关状态
            case 0xE3DB:
                
                if socketData.subNetID != floorHeating.subnetID ||
                    
                    socketData.deviceID != floorHeating.deviceID ||
                    
                    socketData.additionalData[2] != floorHeating.channelNo {
                    
                    return
                }
                
                let operatorKind =
                    socketData.additionalData[0]
                
                let operatorResult =
                    socketData.additionalData[1]
                
                if operatorKind == SHFloorHeatingControlType.onAndOff.rawValue {
                    
                    floorHeating.isTurnOn =
                        operatorResult != 0
                    
                } else if operatorKind == SHFloorHeatingControlType.modelSet.rawValue {
                    
                    floorHeating.floorHeatingModeType =
                        SHFloorHeatingModeType(
                            rawValue: operatorResult
                        ) ?? .manual
                }
                
            // 模式温度
            case 0x03C8:
                
                if socketData.subNetID != floorHeating.subnetID ||
                    
                    socketData.deviceID != floorHeating.deviceID ||
                    
                    socketData.additionalData[0] != floorHeating.channelNo {
                    
                    return
                }
                
                // 获得每个模式下的温度
                floorHeating.manualTemperature =
                    Int(socketData.additionalData[1])
                
                floorHeating.dayTemperature =
                    Int(socketData.additionalData[3])
                
                floorHeating.nightTemperature =
                    Int(socketData.additionalData[5])
                
                floorHeating.awayTemperature =
                    Int(socketData.additionalData[7])
                
                
                // 传感器的地址
                floorHeating.insideSensorSubNetID =
                    socketData.additionalData[9]
                
                floorHeating.insideSensorDeviceID =
                    socketData.additionalData[10]
                
                floorHeating.insideSensorChannelNo =
                    socketData.additionalData[11]
                
                // 读取温度
                SHSocketTools.sendData(
                    operatorCode: 0xE3E7,
                    subNetID: floorHeating.insideSensorSubNetID,
                    deviceID: floorHeating.insideSensorDeviceID,
                    additionalData: [1]
                )
                
                
                // 0x03CA 设置定时器的时间
            // 0x03CC获得定时器模式下的开始与结束时间
            case 0x03CA, 0x03CC:
                
                if socketData.subNetID != floorHeating.subnetID ||
                    
                    socketData.deviceID != floorHeating.deviceID ||
                    
                    socketData.additionalData[0] != floorHeating.channelNo {
                    
                    return
                }
                
                if socketData.operatorCode == 0x03CA {
                    
                    // 读取定时器模式下的开始与结束时间
                    SHSocketTools.sendData(
                        operatorCode: 0x03CB,
                        subNetID: floorHeating.subnetID,
                        deviceID: floorHeating.deviceID,
                        additionalData: [floorHeating.channelNo]
                    )
                    
                } else {
                    
                    
                    floorHeating.dayTimeHour =
                        socketData.additionalData[1]
                    
                    floorHeating.dayTimeMinute =
                        socketData.additionalData[2]
                    
                    floorHeating.nightTimeHour =
                        socketData.additionalData[3]
                    
                    floorHeating.nightTimeMinute =
                        socketData.additionalData[4]
                    
                    floorHeating.timerEnable =
                        socketData.additionalData[5] != 0
                }
                
            // 温度传感器 与 地热本身没有什么关系
            case 0xE3E8:
                
                if socketData.additionalData[0] == 0 {
                    return
                }
                
                // 室内温度  0:+ / 1:-
                if socketData.subNetID == floorHeating.insideSensorSubNetID &&
                    socketData.deviceID ==
                    floorHeating.insideSensorDeviceID {
                    
                    let index = Int(
                        floorHeating.insideSensorChannelNo
                    )
                    
                    let temperature = Int(socketData.additionalData[index])
                    
                    floorHeating.insideTemperature =
                        (socketData.additionalData[index + 8] == 0) ? temperature : (0 - temperature)
                }
                
                // 室外温度  0:+ / 1:-
                if socketData.subNetID == floorHeating.outsideSensorSubNetID &&
                    socketData.deviceID ==
                    floorHeating.outsideSensorDeviceID {
                    
                    let index = Int(
                        floorHeating.outsideSensorChannelNo
                    )
                    
                    let temperature = Int(socketData.additionalData[index])
                    
                    floorHeating.outsideTemperature =
                        (socketData.additionalData[index + 8] == 0) ? temperature : (0 - temperature)
                }
                
                self.isSetSensorTemperature = true
                
            default:
                break
            }
            
            
            if  socketData.operatorCode == 0xE3D9 ||
                socketData.operatorCode == 0xE3DB ||
                socketData.operatorCode == 0x03CC ||
                socketData.operatorCode == 0x03C8 ||
                socketData.operatorCode == 0xE3E8 {
                
                DispatchQueue.main.async {
                    
                    self.setFloorHeatingStatus()
                }
            }
            
        }
    }
    
    /// 读取状态
    @objc private func readDevicesStatus() {
        
        guard let floorHeating = currentFloorHeating else {
            return
        }
        
        // 读取定时器模式下的开始与结束时间
        SHSocketTools.sendData(
            operatorCode: 0x03CB,
            subNetID: floorHeating.subnetID,
            deviceID: floorHeating.deviceID,
            additionalData: [floorHeating.channelNo]
        )
        
        // 读取模式匹配温度与传感器的地址
        SHSocketTools.sendData(
            operatorCode: 0x03C7,
            subNetID: floorHeating.subnetID,
            deviceID: floorHeating.deviceID,
            additionalData: [floorHeating.channelNo]
        )
        
        // 读取室外温度 (读摄氏温度)
        SHSocketTools.sendData(
            operatorCode: 0xE3E7,
            subNetID: floorHeating.outsideSensorSubNetID,
            deviceID: floorHeating.outsideSensorDeviceID,
            additionalData: [1]
        )
        
        // 读取开关状态
        let onOffStatusData = [
            SHFloorHeatingControlType.onAndOff.rawValue,
            floorHeating.channelNo
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE3DA,
            subNetID: floorHeating.subnetID,
            deviceID: floorHeating.deviceID,
            additionalData: onOffStatusData
        )
        
        // 读取模式状态
        let modelStatusData = [
            SHFloorHeatingControlType.modelSet.rawValue,
            floorHeating.channelNo
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE3DA,
            subNetID: floorHeating.subnetID,
            deviceID: floorHeating.deviceID,
            additionalData: modelStatusData
        )
    }
    
    
    /// 成为焦点主动读取状态
    override func becomeFocus() {
        super.becomeFocus()
        
        readDevicesStatus()
    }
}


// MARK: - 状态控制(点击事件)
extension SHZoneControlFloorHeatingControlViewController {
    
    
    /// 地热的开启与关闭
    @IBAction func turnOnButtonClick() {
        
        guard let floorHeating = currentFloorHeating else {
            return
        }
        
        let status = floorHeating.isTurnOn ? SHFloorHeatingSwitchType.off :
            SHFloorHeatingSwitchType.on
        
        let onOffData = [
            SHFloorHeatingControlType.onAndOff.rawValue,
            status.rawValue,
            floorHeating.channelNo
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE3D8,
            subNetID: floorHeating.subnetID,
            deviceID: floorHeating.deviceID,
            additionalData: onOffData
        )
    }
    
    // MARK: - 模式变换
    
    /// 手动模式
    @IBAction func manualButtonClick() {
        
        changeFloorHeatingModel(model: .manual)
    }
    
    /// 白天模式
    @IBAction func dayButtonClick() {
        
        changeFloorHeatingModel(model: .day)
    }
    
    /// 夜间模式
    @IBAction func nightButtonClick() {
        
        changeFloorHeatingModel(model: .night)
    }
    
    /// 离开模式
    @IBAction func awayButtonClick() {
        
        changeFloorHeatingModel(model: .away)
    }
    
    /// 闹钟(定时器)模式
    @IBAction func alarmButtonClick() {
        
        changeFloorHeatingModel(model: .timer)
    }
    
    
    /// 切换地热的模式
    ///
    /// - Parameter model: 模式值
    private func changeFloorHeatingModel(model: SHFloorHeatingModeType){
        
        guard let floorHeating = currentFloorHeating else {
            return
        }
        
        let modelData = [
            SHFloorHeatingControlType.modelSet.rawValue,
            model.rawValue,
            floorHeating.channelNo
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE3D8,
            subNetID: floorHeating.subnetID,
            deviceID: floorHeating.deviceID,
            additionalData: modelData
        )
    }
    
    
    // MARK: - 温度控制
    
    /// 降低地热手动模式温度
    @IBAction func reduceTemperatureButtonClick() {
        
        manualTemperatureChange(isAdd: false)
    }
    
    /// 增加地热手动模式温度
    @IBAction func addTemperatureButtonClick() {
        
        manualTemperatureChange(isAdd: true)
    }
    
    /// 手动温度变化
    private func manualTemperatureChange(isAdd: Bool) {
        
        guard let floorHeating = currentFloorHeating,
            floorHeating.floorHeatingModeType == .manual else {
                return
        }
        
        let temperature = isAdd ? (floorHeating.manualTemperature + 1) :
            (floorHeating.manualTemperature - 1)
        
        if temperature < SHFloorHeatingManualTemperatureRange.centigradeMinimumValue.rawValue ||
            temperature > SHFloorHeatingManualTemperatureRange.centigradeMaximumValue.rawValue {
            
            SVProgressHUD.showInfo(
                withStatus: "Exceeding the set temperature"
            )
            
            return
        }
        
        let temperatureData = [
            SHFloorHeatingControlType.temperatureSet.rawValue,
            UInt8(temperature),
            floorHeating.channelNo
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE3D8,
            subNetID: floorHeating.subnetID,
            deviceID: floorHeating.deviceID,
            additionalData: temperatureData
        )
    }
}


// MARK: - 时间处理
extension SHZoneControlFloorHeatingControlViewController {
    
    /// 选择日期
    @IBAction func selectDate() {
        
        guard let time =
            NSDate.getCurrentDateComponents(
                from: datePicker.date
            ) else {
                
                return
        }
        
        let timeString =
            String(format: "%02d:%02d",
                   time.hour ?? 0,
                   time.minute ?? 0
        )
        
        selecTimeButton?.setTitle(timeString,
                                  for: .normal
        )
    }
    
    /// 选择日期
    @IBAction func dayTimeButtonClick() {
        
        if selecTimeButton != dayTimeButton {
            
            selecTimeButton?.isSelected = false
        }
        
        dayTimeButton.isSelected =
            !dayTimeButton.isSelected
        
        if dayTimeButton.isSelected {
            
            selecTimeButton = dayTimeButton
            showDatePicker()
            
        } else {
            
            hidenDatePicker()
        }
    }
    
    /// 选择日期
    @IBAction func nightTimeButtonClick() {
        
        if selecTimeButton != nightTimeButton {
            
            selecTimeButton?.isSelected = false
        }
        
        nightTimeButton.isSelected =
            !nightTimeButton.isSelected
        
        if nightTimeButton.isSelected {
            
            selecTimeButton = nightTimeButton
            showDatePicker()
            
        } else {
            
            hidenDatePicker()
        }
    }
    
    /// 显示日期选择器
    private func showDatePicker() {
        
        let scale: CGFloat =
            UIDevice.is_iPad() ? 1.8 : 1.3
        
        let moveMarign = pickerViewHeight * scale
        
        if topConstraint.constant >= 0 {
            
            if datePicker.transform == .identity {
                
                datePicker.transform =
                    CGAffineTransform(
                        scaleX: scale,
                        y: scale
                )
            }
            
            topConstraint.constant -= moveMarign
            datePickerViewTopConstraint.constant -= moveMarign
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    /// 显示日期选择器
    private func hidenDatePicker() {
        
        let scale: CGFloat =
            UIDevice.is_iPad() ? 1.8 : 1.3
        
        let moveMarign = pickerViewHeight * scale
        
        if topConstraint.constant < 0 {
            
            selecTimeButton = nil
            datePicker.transform = .identity
            topConstraint.constant += moveMarign
            datePickerViewTopConstraint.constant += moveMarign
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        guard let floorHeating = currentFloorHeating else {
            return
        }
        
        let alertView =
            TYCustomAlertView(
                title: nil,
                message: "is the update time determined ?",
                isCustom: true
        )
        
        // 取消
        let cancelAction =
            TYAlertAction(title: SHLanguageText.no, style: .cancel) { (action) in
                
                // 读取定时器模式下的开始与结束时间
                
                SHSocketTools.sendData(
                    operatorCode: 0x03CB,
                    subNetID: floorHeating.subnetID,
                    deviceID: floorHeating.deviceID,
                    additionalData: [floorHeating.channelNo]
                )
        }
        
        alertView?.add(cancelAction)
        
        // 设置
        let sureAction = TYAlertAction(title: SHLanguageText.yes, style: .default) { (action) in
            
            guard let dayTimes = self.dayTimeButton.currentTitle?.components(separatedBy: ":"),
                
                let nightTimes = self.nightTimeButton.currentTitle?.components(separatedBy: ":"),
                
                let dayHour = UInt8(dayTimes.first ?? "0"),
                
                let dayMinute = UInt8(dayTimes.last ?? "0"),
                
                let nightHour = UInt8(nightTimes.first ?? "0"),
                
                let nightMinute = UInt8(nightTimes.last ?? "0")
                
                else {
                    
                    return
            }
            
            
            let updateTime = [
                floorHeating.channelNo,
                dayHour,
                dayMinute,
                
                nightHour,
                nightMinute,
                
                floorHeating.timerEnable ? 1 : 0
            ]
            
            SHSocketTools.sendData(
                operatorCode: 0x03C9,
                subNetID: floorHeating.subnetID,
                deviceID: floorHeating.deviceID,
                additionalData: updateTime
            )
        }
        
        alertView?.add(sureAction)
        
        
        let alertController =
            TYAlertController(
                alert: alertView,
                preferredStyle: .alert,
                transitionAnimation: .scaleFade
        )
        
        alertController?.backgoundTapDismissEnable = true
        
        present(alertController!,
                animated: true,
                completion: nil
        )
    }
}

// MARK: - 界面初始化
extension SHZoneControlFloorHeatingControlViewController {
    
    /// 设置状态显示
    private func setFloorHeatingStatus() {
        
        guard let floorHeating = currentFloorHeating else {
            return
        }
        
        // 1.设置显示开关
        controlView?.isHidden =
            !floorHeating.isTurnOn
        
        turnFloorHeatingButton.isSelected =
            floorHeating.isTurnOn
        
        let dayTime =
            String(format: "%02d:%02d",
                   floorHeating.dayTimeHour,
                   floorHeating.dayTimeMinute
        )
        
        let nightTime =
            String(format: "%02d:%02d",
                   floorHeating.nightTimeHour,
                   floorHeating.nightTimeMinute
        )
        
        // 2.不同的模式温度
        switch floorHeating.floorHeatingModeType {
            
        case .manual:
            
            modelTemperatureLabel.text =
                temperatureShow(
                    celsiusTemperature:
                    floorHeating.manualTemperature
            )
            
        case .day:
            
            modelTemperatureLabel.text =
                temperatureShow(
                    celsiusTemperature:
                    floorHeating.dayTemperature
            )
            
        case .night:
            
            modelTemperatureLabel.text =
                temperatureShow(
                    celsiusTemperature:
                    floorHeating.nightTemperature
            )
            
        case .away:
            
            modelTemperatureLabel.text =
                temperatureShow(
                    celsiusTemperature:
                    floorHeating.awayTemperature
            )
            
        case .timer:
            
            let isDay =
                NSDate.validateStartTime(
                    dayTime,
                    expireTime: nightTime
            )
            
            if isDay {
                
                modelTemperatureLabel.text =
                    temperatureShow(
                        celsiusTemperature:
                        floorHeating.dayTemperature
                )
            } else {
                
                modelTemperatureLabel.text =
                    temperatureShow(
                        celsiusTemperature:
                        floorHeating.nightTemperature
                )
            }
        }
        
        // 显示控制温度按钮
        reduceTemperatureButton.isHidden =
            floorHeating.floorHeatingModeType
            != .manual
        
        addTemperatureButton.isHidden = floorHeating.floorHeatingModeType
            != .manual
        
        // 显示当前模式
        manualButton.isSelected =
            floorHeating.floorHeatingModeType
            == .manual
        
        dayButton.isSelected =
            floorHeating.floorHeatingModeType
            == .day
        
        nightButton.isSelected =
            floorHeating.floorHeatingModeType
            == .night
        
        awayButton.isSelected =
            floorHeating.floorHeatingModeType
            == .away
        
        timerButton.isSelected =
            floorHeating.floorHeatingModeType
            == .timer
        
        // 4.设置定时器时间
        dayTimeButton.setTitle(dayTime,
                               for: .normal
        )
        
        nightTimeButton.setTitle(nightTime,
                                 for: .normal
        )
        
        // 5.设置温度
        indoorTemperatureLabel.text =
            temperatureShow(
                celsiusTemperature:
                floorHeating.insideTemperature
        )
        
        outdoorTemperatureLabel.text =
            temperatureShow(
                celsiusTemperature:
                floorHeating.outsideTemperature
        )
        
        if floorHeating.insideTemperature <= 0 {
            
            indoorTemperatureLabel.text = "N/A"
        }
        
        if floorHeating.outsideTemperature == 0 &&
            isSetSensorTemperature == false {
            
            outdoorTemperatureLabel.text = "N/A"
        }
    }
    
    /// 模式温度字符串
    private func temperatureShow(celsiusTemperature: Int) -> String {
        
        let fahrenheit =
            SHHVAC.centigradeConvert(
                toFahrenheit: celsiusTemperature
        )
        
        return
            "\(celsiusTemperature) °C\n\(fahrenheit) °F"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setFloorHeatingStatus()
        
        self.performSelector(
            inBackground: #selector(readDevicesStatus),
            with: nil
        )

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title =
            currentFloorHeating?.floorHeatingRemark
        
        controlView?.isHidden = true
        
        datePicker.setValue(
            UIView.textWhiteColor(),
            forKey: "textColor"
        )
        
        addTemperatureButton.setRoundedRectangleBorder()
        
        reduceTemperatureButton.setRoundedRectangleBorder()
        manualButton.setRoundedRectangleBorder()
        dayButton.setRoundedRectangleBorder()
        nightButton.setRoundedRectangleBorder()
        awayButton.setRoundedRectangleBorder()
        timerButton.setRoundedRectangleBorder()
        dayTimeButton.setRoundedRectangleBorder()
        nightTimeButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            outdoorTemperatureLabel.font = font
            indoorTemperatureLabel.font = font
            modelTemperatureLabel.font = font
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is3_5inch() ||
            UIDevice.is4_0inch() {
            
            groupViewHeightConstraint.constant = navigationBarHeight
            
            controlButtonWidthConstraint.constant = tabBarHeight
            
            controlButtonHeightConstraint.constant = tabBarHeight
            
        } else if UIDevice.is_iPad() {
            
            groupViewHeightConstraint.constant =
                isPortrait ?
                    (navigationBarHeight + navigationBarHeight) :
                (tabBarHeight + tabBarHeight)
            
            controlButtonHeightConstraint.constant =
                isPortrait ?
                    (navigationBarHeight + statusBarHeight) :
                (tabBarHeight + statusBarHeight)
            
            controlButtonWidthConstraint.constant =
                isPortrait ?
                    (navigationBarHeight + statusBarHeight) :
                (tabBarHeight + statusBarHeight)
        }
    }
}
