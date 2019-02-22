//
//  SHSchduleLightCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/4.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHSchduleLightCell: UITableViewCell {
    
    /// Light设备
    var light: SHLight? {
        
        didSet {
            
            guard let zoneLight = light else {
                return
            }
            
            backgroundColor = UIColor.clear
            enableButton.isSelected = zoneLight.schedualEnable
            
            nameLabel.text = zoneLight.lightRemark
            iconButton.isSelected =
                (zoneLight.schedualBrightness != 0)
            
            // 设置第三部分 == 四种不同的类型
            statusButton.setTitle(
                iconButton.isSelected ? SHLanguageText.on : SHLanguageText.off,
                for: .normal
            )
            
            brightnessSlider.value =
                Float(zoneLight.schedualBrightness)
            
            brightnessLabel.text =
                "\(zoneLight.schedualBrightness)%"
            
            let iconName =
                SHLight.lightImageName(
                    lightTypeID: zoneLight.lightTypeID
            )
            
            iconButton.setImage(
                UIImage(named: iconName + "_normal"),
                for: .normal
            )
            
            iconButton.setImage(
                UIImage(named: iconName + "_highlighted"),
                for: .highlighted
            )
            
            iconButton.setImage(
                UIImage(named: iconName + "_highlighted"),
                for: .selected
            )
            
            switch zoneLight.canDim {
            
            case .notDimmable:
                brightnessLabel.isHidden = true
                brightnessSlider.isHidden = true
                statusButton.isHidden = false

            case .dimmable:
                brightnessLabel.isHidden = false
                brightnessSlider.isHidden = false
                statusButton.isHidden = true

            case .led:
                brightnessSlider.isHidden = true
                brightnessLabel.isHidden = true
                statusButton.isHidden = false

                if zoneLight.schedualRedColor != 0 ||
                   zoneLight.schedualGreenColor != 0 ||
                   zoneLight.schedualBlueColor != 0  {
                    
                    backgroundColor =
                        UIColor(
                            red: CGFloat(zoneLight.schedualRedColor)/255.0,
                            green: CGFloat(zoneLight.schedualGreenColor)/255.0,
                            blue: CGFloat(zoneLight.schedualBlueColor)/255.0,
                            alpha: 1/0
                    )
                    
                    iconButton.isSelected = true
                    
                    statusButton.setTitle(
                        SHLanguageText.on,
                        for: .normal
                    )
                    
                } else {
                    
                    backgroundColor = UIColor.clear
                    iconButton.isSelected = false
                    
                    statusButton.setTitle(
                        SHLanguageText.off,
                        for: .normal
                    )
                }
                
            case .pushOnReleaseOff:
                brightnessLabel.isHidden = true
                brightnessSlider.isHidden = true
                statusButton.isHidden = true

            default:
                break
            }
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return navigationBarHeight + tabBarHeight
        }
        
        return navigationBarHeight
    }
 
    // MARK: - 约束

    /// 亮度宽度
    @IBOutlet weak var brightnessLabelWidthConstraint: NSLayoutConstraint!
    
    /// 按钮高度
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 按钮宽度
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    
    /// 标志高度约束
    @IBOutlet weak var flagViewHeightConstraint: NSLayoutConstraint!
    
    /// 标志高度约束
    @IBOutlet weak var flagViewWidthConstraint: NSLayoutConstraint!
    // MARK: - UI控件

    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 状态按钮
    @IBOutlet weak var statusButton: UIButton!
    
    /// 按钮
    @IBOutlet weak var iconButton: UIButton!
    // MARK: - 不同的部分

    /// 调整亮度条
    @IBOutlet weak var brightnessSlider: UISlider!
    
    /// 亮度值
    @IBOutlet weak var brightnessLabel: UILabel!
    
    /// 开启计划
    @IBOutlet weak var enableButton: UIButton!

    // MARK: - 事件
    
    /// 开启计划
    @IBAction func enableButtonClick() {
    
        enableButton.isSelected = !enableButton.isSelected
        
        light?.schedualEnable = enableButton.isSelected
    }

    /// 改变亮度值 [UI变化，但不发送指令]
    @IBAction func brightnessSliderChange() {
        
        let brightness = UInt8(brightnessSlider.value)
        
        brightnessLabel.text = "\(brightness)%"
        
        iconButton.isSelected = brightness != 0
        
        light?.schedualBrightness = brightness
    }
    
    /// 状态按钮点击
    @IBAction func statusButtonClick() {
        
        guard let zoneLight = light else {
            return
        }
        
        let isTurnOn =
            statusButton.currentTitle == SHLanguageText.on
        
        switch zoneLight.canDim {
        
        case .notDimmable, .dimmable:
            
            iconButton.isSelected = isTurnOn
            zoneLight.schedualBrightness =
                isTurnOn ? 0 : lightMaxBrightness
            
            statusButton.setTitle(
                isTurnOn ? SHLanguageText.off: SHLanguageText.on,
                for: .normal
            )
            
        case .led:
            
            if isTurnOn {
                
                zoneLight.schedualRedColor = 0
                zoneLight.schedualGreenColor = 0
                zoneLight.schedualBlueColor = 0
                zoneLight.schedualWhiteColor = 0
                
                light = zoneLight
            
            } else { // 要进行取色
            
                let selectController =
                    SHSelectColorViewController()
                
                selectController.showColor { (red, green, blue, alpha) in
                    
                    zoneLight.schedualRedColor =
                        UInt8(red * CGFloat(lightMaxBrightness))
                    
                    zoneLight.schedualGreenColor =
                        UInt8(green * CGFloat(lightMaxBrightness))
                    
                    zoneLight.schedualBlueColor =
                        UInt8(blue * CGFloat(lightMaxBrightness))
                    
                    zoneLight.schedualWhiteColor =
                        UInt8(alpha * CGFloat(lightMaxBrightness))
                }
                
            }
            
        case .pushOnReleaseOff:
            break
        
        default:
            break
        }
    }
    
    /// 按钮图标点击
    @IBAction func iconButtonClick() {
        
        guard let zoneLight = light else {
            return
        }
        
        switch zoneLight.canDim {
        
        case .notDimmable:
            
            iconButton.isSelected = !iconButton.isSelected
            
            zoneLight.schedualBrightness =
                iconButton.isSelected ? lightMaxBrightness : 0
            
            statusButton.setTitle(
                iconButton.isSelected ? SHLanguageText.on : SHLanguageText.off,
                for: .normal
            )
            
        case .dimmable:
            
            iconButton.isSelected = !iconButton.isSelected
            
            zoneLight.schedualBrightness =
                iconButton.isSelected ? lightMaxBrightness : 0
            
            brightnessSlider.value = Float(zoneLight.schedualBrightness)
            
            brightnessSliderChange()
            
        case .pushOnReleaseOff:
            iconButton.isSelected = false
            
        case .led:
            
            iconButton.isSelected = !iconButton.isSelected
            
            if iconButton.isSelected {
                
                let selectController =
                    SHSelectColorViewController()
                
                selectController.showColor { (red, green, blue, alpha) in
                    
                    zoneLight.schedualRedColor =
                        UInt8(red * CGFloat(lightMaxBrightness))
                    
                    zoneLight.schedualGreenColor =
                        UInt8(green * CGFloat(lightMaxBrightness))
                    
                    zoneLight.schedualBlueColor =
                        UInt8(blue * CGFloat(lightMaxBrightness))
                    
                    zoneLight.schedualWhiteColor =
                        UInt8(alpha * CGFloat(lightMaxBrightness))
                }
            
            } else {
                
                zoneLight.schedualRedColor = 0
                zoneLight.schedualGreenColor = 0
                zoneLight.schedualBlueColor = 0
                zoneLight.schedualWhiteColor = 0
                
                light = zoneLight
            }
            
        default:
            break
        }
        
    }
}


// MARK: - UI初始化
extension SHSchduleLightCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        let thumbImage = UIImage.getClearColorImage(CGSize(width: 7, height: 12))
        
        brightnessSlider.setThumbImage(thumbImage,
                                       for: .normal
        )
        
        brightnessSlider.setThumbImage(thumbImage,
                                       for: .highlighted
        )
        
        brightnessSlider.transform =
            CGAffineTransform(scaleX: 1.0, y: 5.0)
        
        statusButton.isHidden = true
        brightnessSlider.isHidden = true
        brightnessLabel.isHidden = true
        
        if UIDevice.is_iPad() {
            
            brightnessSlider.transform =
                CGAffineTransform(scaleX: 1.0, y: 15.0)
            
            let font = UIView.suitFontForPad()
            
            nameLabel.font = font
            brightnessLabel.font = font
            statusButton.titleLabel?.font = font
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            buttonHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
            
            buttonWidthConstraint.constant =
                navigationBarHeight + statusBarHeight

            flagViewWidthConstraint.constant = tabBarHeight
            flagViewHeightConstraint.constant = tabBarHeight
            brightnessLabelWidthConstraint.constant =
                navigationBarHeight

        } else if UIDevice.is3_5inch() || UIDevice.is4_0inch() {
            
            brightnessLabelWidthConstraint.constant = 40
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}
