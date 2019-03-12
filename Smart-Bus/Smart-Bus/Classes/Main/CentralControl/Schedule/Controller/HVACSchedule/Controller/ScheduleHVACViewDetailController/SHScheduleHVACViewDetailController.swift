//
//  SHSchedualHVACViewController.h
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/9.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

class SHScheduleHVACViewDetailController: SHViewController {

    /// 计划空调
    var schedualHVAC: SHHVAC?
    
    /// 使用摄氏温度
    private var isCelsius = true

    /// 分组视图高度
    @IBOutlet weak var groupViewHeightConstraint: NSLayoutConstraint!
    
    /// 按钮的高度
    @IBOutlet weak var controlButtonHeightConstraint: NSLayoutConstraint!
   
    /// 按钮的宽度
    @IBOutlet weak var controlButtonWidthConstraint: NSLayoutConstraint!

    
    /// 空高开关的按钮
    @IBOutlet weak var turnAcButton: UIButton!
    
    /// 模式温度
    @IBOutlet weak var modelTemperatureLabel: UILabel!

    // MARK: -  风速控制
    
    /// 风速指示
    @IBOutlet weak var fanImageView: UIImageView!
    
    /// 低风速
    @IBOutlet weak var lowFanButton: SHCommandButton!
    
    /// 中风速
    @IBOutlet weak var middleFanButton: SHCommandButton!
    
    /// 高风速
    @IBOutlet weak var highFanButton: SHCommandButton!
    
    /// 自动风速
    @IBOutlet weak var autoFanButton: SHCommandButton!

    // MARk: - 控制方式
    
    /// 工作模式图片
    @IBOutlet weak var modelImageView: UIImageView!
    
    /// 制冷模式
    @IBOutlet weak var coldModelButton: SHCommandButton!
    
    /// 通风模式
    @IBOutlet weak var fanModelButton: SHCommandButton!
    
    /// 制热模式
    @IBOutlet weak var hotModelButton: SHCommandButton!
    
    /// 自动模式
    @IBOutlet weak var autoModelButton: SHCommandButton!
    
    /// 增加温度按钮
    @IBOutlet weak var upTemperatureButton: SHCommandButton!
    
    /// 减小温度按钮
    @IBOutlet weak var lowerTemperatureButton: SHCommandButton!
 

}


// MARK: - 开关空调
extension SHScheduleHVACViewDetailController {
    
    /// 开关空调
    @IBAction func turnOnAndOffHVAC() {
        
        turnAcButton.isSelected = !turnAcButton.isSelected

        schedualHVAC?.schedualIsTurnOn = turnAcButton.isSelected
    }

}


// MARK: - 控制模式温度
extension SHScheduleHVACViewDetailController {
    
    /// 离开页面时设置模式温度
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let hvac = schedualHVAC,
            let string = modelTemperatureLabel.text as NSString?
            else {
                
                return
        }
        
        let range = string.range(of: "°C")
        
        if range.location == NSNotFound {
            return
        }
        
        if let temperature = Int(string.substring(to: range.location)) {
            
            hvac.schedualTemperature = temperature
        }
        
    }
    
    /// 增加温度
    @IBAction func upTemperature() {
        
        changeAirConditionerModelTemperature(true)
    }
    
    /// 降低温度
    @IBAction func lowerTemperature() {
    
        changeAirConditionerModelTemperature(false)
    }
    
    /// 修改模式温度
    ///
    /// - Parameters:
    ///   - temperature: 温度
    private func changeAirConditionerModelTemperature(
        _ increase: Bool) {
        
        guard let hvac = schedualHVAC,
              let string = modelTemperatureLabel.text as NSString? else {
            return
        }
        
        let range = string.range(of: "°")
        
        if range.location == NSNotFound {
            return
        }
        
        string.substring(to: range.location)
        
        var temperature =
            Int(string.substring(to: range.location)) ?? 0
        
        increase ?  (temperature += 1) : (temperature -= 1)
      
        switch hvac.schedualMode {
            
        case .heat:
            
            if temperature < hvac.startHeatTemperatureRange ||
                temperature > hvac.endHeatTemperatureRange {
                
                SVProgressHUD.showInfo(
                    withStatus: "Exceeding the set temperature"
                )
                
                return
            }
            
        case .fan, .cool:
            
            if temperature < hvac.startCoolTemperatureRange ||
                temperature > hvac.endCoolTemperatureRange {
                
                SVProgressHUD.showInfo(
                    withStatus: "Exceeding the set temperature"
                )
                
                return
            }
            
        case .auto:
           
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
            "\(temperature) °C\n" +
            "\(SHHVAC.centigradeConvert(toFahrenheit: temperature)) °F"
    }
}


// MARK: - 控制空调的模式
extension SHScheduleHVACViewDetailController {
    
    /// 通风模式
    @IBAction func coldModelButtonClick() {
        
        changeAirConditionerModel(
            coldModelButton,
            model: .cool
        )
    }
    
    /// 通风模式
    @IBAction func fanModelButtonClick() {
        
        changeAirConditionerModel(
            fanModelButton,
            model: .fan
        )
    }
    
    /// 制热模式
    @IBAction func hotModelButtonClick() {
        
        changeAirConditionerModel(
            hotModelButton,
            model: .heat
        )
    }
    
    /// 自动控制模式
    @IBAction func autoModelButtonClick() {
        
        changeAirConditionerModel(
            autoModelButton,
            model: .auto
        )
    }

    
    /// 配置空调的模式与温度
    ///
    /// - Parameters:
    ///   - button: 点击按钮
    ///   - model: 选择模式
    ///   - temperature: 配置温度
    private func changeAirConditionerModel(
        _ button: UIButton,
        model: SHAirConditioningModeType) {
        
        guard let hvac = schedualHVAC else {
            return
        }
        
        upTemperatureButton.isEnabled = true
        lowerTemperatureButton.isEnabled = true

        autoModelButton.isSelected = false
        coldModelButton.isSelected = false
        hotModelButton.isSelected = false
        fanModelButton.isSelected = false
        
        button.isSelected = true
        
        hvac.schedualMode = model
        
        switch model {
        
        case .cool:
            
            modelTemperatureLabel.text =
                "\(hvac.coolTemperture) °C\n" +
                "\(SHHVAC.centigradeConvert(toFahrenheit: hvac.coolTemperture))"
            
            modelImageView.image = UIImage(named: "coolModel")
         
        case .heat:
            
            modelTemperatureLabel.text =
                "\(hvac.heatTemperture) °C\n" +
                "\(SHHVAC.centigradeConvert(toFahrenheit: hvac.heatTemperture))"
            
            modelImageView.image = UIImage(named: "heatModel")
            
        case .fan:
            
            modelTemperatureLabel.text =
                "\(hvac.coolTemperture) °C\n" +
                "\(SHHVAC.centigradeConvert(toFahrenheit: hvac.coolTemperture))"
            
            modelImageView.image = UIImage(named: "fanModel")
            
        case .auto:
            
            modelTemperatureLabel.text =
                "\(hvac.autoTemperture) °C\n" +
                "\(SHHVAC.centigradeConvert(toFahrenheit: hvac.autoTemperture))"
            
            modelImageView.image = UIImage(named: "autoModel")
            
        default:
            break
        }

    }
}

// MARK: - 配置风速
extension SHScheduleHVACViewDetailController {
    
    /// 低风速
    @IBAction func lowFanButtonClick() {
        
        changeAirConditionerFanSpeed(
            lowFanButton,
            fanSpeed: .low
        )
    }
    
    /// 中风速
    @IBAction func middleFanButtonClick() {
        
        changeAirConditionerFanSpeed(
            middleFanButton,
            fanSpeed: .medial
        )
    }
    
    /// 高风速
    @IBAction func highFanButtonClick() {
        
        changeAirConditionerFanSpeed(
            highFanButton,
            fanSpeed: .high
        )
    }
    
    /// 自动风速
    @IBAction func autoFanButtonClick() {
        
        changeAirConditionerFanSpeed(
            autoFanButton,
            fanSpeed: .auto
        )
    }

    
    /// 切换空调的风速
    ///
    /// - Parameters:
    ///   - button: 选择按钮
    ///   - fanSpeed: 变换风速
    private func changeAirConditionerFanSpeed(
        _ button: UIButton,
        fanSpeed: SHAirConditioningFanSpeedType) {
        
        guard let hvac = schedualHVAC else {
            return
        }
        
        hvac.schedualFanSpeed = fanSpeed
        
        middleFanButton.isSelected = false
        lowFanButton.isSelected = false
        highFanButton.isSelected = false
        autoFanButton.isSelected = false
        
        button.isSelected = true

        switch fanSpeed {
        case .auto:
            fanImageView.image = UIImage(named: "autofan")
            
        case .high:
            fanImageView.image = UIImage(named: "highfan")
            
        case .medial:
            fanImageView.image = UIImage(named: "mediumfan")
            
        case .low:
            fanImageView.image = UIImage(named: "lowfan")
        }
    }
}

// MARK: - UI
extension SHScheduleHVACViewDetailController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let hvac = schedualHVAC else {
            return
        }
        
        hvac.isUpdateSchedualCommand = false
        
        // 开关状态
        turnAcButton.isSelected = hvac.schedualIsTurnOn
        
        // 风速
        switch hvac.schedualFanSpeed {
        
        case .auto:
            changeAirConditionerFanSpeed(
                autoFanButton,
                fanSpeed: .auto
            )
           
        case .high:
            changeAirConditionerFanSpeed(
                highFanButton,
                fanSpeed: .high
            )
            
        case .medial:
            changeAirConditionerFanSpeed(
                middleFanButton,
                fanSpeed: .medial
            )
            
        case .low:
            changeAirConditionerFanSpeed(
                lowFanButton,
                fanSpeed: .low
            )
        }
        
        // 设置模式
        switch hvac.schedualMode {
        
        case .cool:
            changeAirConditionerModel(
                coldModelButton,
                model: .cool
            )
            
        case .heat:
            changeAirConditionerModel(
                hotModelButton,
                model: .heat
            )
            
        case .fan:
            changeAirConditionerModel(
                fanModelButton,
                model: .fan
            )
            
        case .auto:
            changeAirConditionerModel(
                autoModelButton,
                model: .auto
            )
        }
        
        // 模式温度
        modelTemperatureLabel.text =
            "\(hvac.schedualTemperature) °C\n" +
            "\(SHHVAC.centigradeConvert(toFahrenheit: hvac.schedualTemperature)) °F"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = schedualHVAC?.acRemark
        
        // 设置默认的温度范围
        
        // 风扇
        lowFanButton.setTitle(
            SHHVAC.getFanSpeedName(.low),
            for: .normal
        )
        
        middleFanButton.setTitle(
            SHHVAC.getFanSpeedName(.medial),
            for: .normal
        )
        
        highFanButton.setTitle(
            SHHVAC.getFanSpeedName(.high),
            for: .normal
        )
        
        autoFanButton.setTitle(
            SHHVAC.getFanSpeedName(.auto),
            for: .normal
        )
        
        // 模式控制
        coldModelButton.setTitle(
            SHHVAC.getModeName(.cool),
            for: .normal
        )
        
        hotModelButton.setTitle(
            SHHVAC.getModeName(.heat),
            for: .normal
        )
        
        fanModelButton.setTitle(
            SHHVAC.getModeName(.fan),
            for: .normal
        )
        
        autoModelButton.setTitle(
            SHHVAC.getModeName(.auto),
            for: .normal
        )
        
        upTemperatureButton.isEnabled = false
        lowerTemperatureButton.isEnabled = false
        
        // 设置默认温度范围
        
        
        // 设置圆角
        turnAcButton.setRoundedRectangleBorder()
        
        upTemperatureButton.setRoundedRectangleBorder()
        lowerTemperatureButton.setRoundedRectangleBorder()

        lowFanButton.setRoundedRectangleBorder()
        middleFanButton.setRoundedRectangleBorder()
        highFanButton.setRoundedRectangleBorder()
        autoFanButton.setRoundedRectangleBorder()

        coldModelButton.setRoundedRectangleBorder()
        hotModelButton.setRoundedRectangleBorder()
        fanModelButton.setRoundedRectangleBorder()
        autoModelButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            modelTemperatureLabel.font = UIView.suitFontForPad()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            groupViewHeightConstraint.constant =
                tabBarHeight + tabBarHeight

            controlButtonWidthConstraint.constant =
                navigationBarHeight + statusBarHeight
            
            controlButtonHeightConstraint.constant =
                navigationBarHeight + statusBarHeight

        } else if UIDevice.is3_5inch() || UIDevice.is4_0inch() {
            
            groupViewHeightConstraint.constant =
                navigationBarHeight
            
            controlButtonHeightConstraint.constant =
                tabBarHeight
            
            controlButtonWidthConstraint.constant =
                tabBarHeight
        }
    }
    
}
