//
//  SHSchedualFloorHeatingController.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/10.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHSchedualFloorHeatingController: SHViewController {

    /// 地热
    var schedualFloorHeating: SHFloorHeating?
    

    // MARK: - 约束条件
    
    /// 分组基准高度
    @IBOutlet weak var groupViewHeightConstraint: NSLayoutConstraint!
    
    /// 控制按钮的高度
    @IBOutlet weak var controlButtonHeightConstraint: NSLayoutConstraint!
    
    /// 控制按钮的宽度
    @IBOutlet weak var controlButtonWidthConstraint: NSLayoutConstraint!
    
    // MARK: - UI控件
    
    /// 开关地热
    @IBOutlet weak var turnFloorHeatingButton: UIButton!
    
    /// 增加温度按钮
    @IBOutlet weak var addTemperatureButton: UIButton!
    
    /// 降低温度按钮
    @IBOutlet weak var reduceTemperatureButton: UIButton!
    
    /// 模式温度
    @IBOutlet weak var modelTemperatureLabel: UILabel!
    
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
}


// MARK: - 保存数据
extension SHSchedualFloorHeatingController {
    
    /// 关闭控制器
    @objc private func close() {
     
        if let floorHeating = schedualFloorHeating {
            
            print(floorHeating.schedualIsTurnOn)
            print(floorHeating.schedualModeType)
            print(floorHeating.schedualTemperature)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - 点击
extension SHSchedualFloorHeatingController {
    
    /// 地热的开启与关闭
    @IBAction func turnOnButtonClick() {
        
        turnFloorHeatingButton.isSelected =
            !turnFloorHeatingButton.isSelected
        
        schedualFloorHeating?.schedualIsTurnOn = turnFloorHeatingButton.isSelected
    }
}


// MARK: - 设置手动温度
extension SHSchedualFloorHeatingController {
    
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
        
        guard let floorHeating = schedualFloorHeating,
            floorHeating.schedualModeType == .manual else {
                return
        }
        
        let temperature = isAdd ? (floorHeating.schedualTemperature + 1) :
            (floorHeating.schedualTemperature - 1)
        
        if temperature < SHFloorHeatingManualTemperatureRange.centigradeMinimumValue.rawValue ||
            temperature > SHFloorHeatingManualTemperatureRange.centigradeMaximumValue.rawValue {
            
            SVProgressHUD.showInfo(
                withStatus: "Exceeding the set temperature"
            )
            
            return
        }
        
        modelTemperatureLabel.text =
            temperatureShow(
                celsiusTemperature: temperature
        )
        
        floorHeating.schedualTemperature = temperature
    }
    
    /// 模式温度字符串
    private func temperatureShow(celsiusTemperature: Int) -> String {
        
        let fahrenheit =
            SHHVAC.centigradeConvert(
                toFahrenheit: celsiusTemperature
        )
        
        let string =
            "\(celsiusTemperature) °C\n\(fahrenheit) °F"
        
        return string
    }
}

// MARK: - 切换模式
extension SHSchedualFloorHeatingController {
    
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
    
    /// 切换模式
    ///
    /// - Parameter model: 模式
    private func changeFloorHeatingModel(model: SHFloorHeatingModeType){
 
        // 显示控制温度按钮
        reduceTemperatureButton.isHidden =
            model != .manual
        
        addTemperatureButton.isHidden =
            model != .manual
        
        // 显示当前模式
        manualButton.isSelected =
            model == .manual
        
        dayButton.isSelected =
            model == .day
        
        nightButton.isSelected =
            model == .night
        
        awayButton.isSelected =
            model == .away
        
        timerButton.isSelected =
            model == .timer
        
        schedualFloorHeating?.schedualModeType = model
    }
    
}


// MARK: - UI初始化
extension SHSchedualFloorHeatingController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Schedule floorHeating"
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                imageName: "close",
                hightlightedImageName: "close",
                addTarget: self,
                action: #selector(close),
                isLeft: true
        )
        
        addTemperatureButton.setRoundedRectangleBorder()
        
        reduceTemperatureButton.setRoundedRectangleBorder()
        manualButton.setRoundedRectangleBorder()
        dayButton.setRoundedRectangleBorder()
        nightButton.setRoundedRectangleBorder()
        awayButton.setRoundedRectangleBorder()
        timerButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            modelTemperatureLabel.font = font
        }
        
        // 临时设置模式温度为固定值
        let celsiusTemperature = 20
        
        modelTemperatureLabel.text =
            temperatureShow(
                celsiusTemperature: celsiusTemperature
        )
        schedualFloorHeating?.schedualTemperature =
            celsiusTemperature
        
        addTemperatureButton.isHidden = true
        reduceTemperatureButton.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is3_5inch() ||
            UIDevice.is4_0inch() {
            
            groupViewHeightConstraint.constant = navigationBarHeight
            
            controlButtonWidthConstraint.constant = tabBarHeight
            
            controlButtonHeightConstraint.constant = tabBarHeight
            
        } else
            
            if UIDevice.is_iPad() {
            
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
