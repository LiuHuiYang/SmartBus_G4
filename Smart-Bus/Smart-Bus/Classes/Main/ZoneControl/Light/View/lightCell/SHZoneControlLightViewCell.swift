//
//  SHZoneControlLightViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/7/24.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

class SHZoneControlLightViewCell: UITableViewCell {
    
    /// 灯
    var light: SHLight? {
        
        didSet {
            
            guard let zoneLight = light else {
                return
            }
            
            backgroundColor = UIColor.clear
            nameLabel.text = light?.lightRemark
        
            iconButton.isSelected = light?.brightness != 0
            
            let statusTitle = iconButton.isSelected ? SHLanguageText.on : SHLanguageText.off
            
            statusButton.setTitle(statusTitle, for: .normal)
            
            brightnessSlider.value = Float(zoneLight.brightness)
            brightnessLabel.text = "\(zoneLight.brightness)%"
            
            let imageTypeName = SHLight.lightImageName(
                lightTypeID: zoneLight.lightTypeID
            )
            
            let normalImage =
                UIImage(named: "\(imageTypeName)_normal")
            
            let selectedImage =
                UIImage(named: "\(imageTypeName)_highlighted")
            
            iconButton.setImage(normalImage, for: .normal)
            iconButton.setImage(selectedImage, for: .highlighted)
            iconButton.setImage(selectedImage, for: .selected)
            
            switch zoneLight.canDim {
            
            case .notDimmable:
                brightnessLabel.isHidden = true
                brightnessSlider.isHidden = true
                statusButton.isHidden = false

            case .dimmable:
                brightnessLabel.isHidden = false
                brightnessSlider.isHidden = false
                statusButton.isHidden = true

            case .pushOnReleaseOff:
                
                iconButton.setImage(
                    UIImage(named: "zoneLightReleaseOff"),
                    for: .normal
                )
                
                iconButton.setImage(
                    UIImage(named: "zoneLightPushOn"),
                    for: .highlighted
                )
                
                iconButton.setImage(
                    UIImage(named: "zoneLightPushOn"),
                    for: .selected
                )
                
                brightnessLabel.isHidden = true
                brightnessSlider.isHidden = true
                statusButton.isHidden = false

            case .led:
                
                brightnessSlider.isHidden = true
                brightnessLabel.isHidden = true
                statusButton.isHidden = false

                let isHaveColor = zoneLight.ledHaveColor && (
                    
                    zoneLight.redColorValue   != 0 ||
                    zoneLight.greenColorValue != 0 ||
                    zoneLight.blueColorValue  != 0
                )
                
                if isHaveColor {
                    
                    iconButton.isSelected = true
                    
                    statusButton.setTitle(SHLanguageText.on,
                                          for: .normal
                    )
                    
                    backgroundColor =
                        UIColor(
                            red: CGFloat(zoneLight.redColorValue) / 100.0,
                            green: CGFloat(zoneLight.greenColorValue) / 100.0,
                            blue: CGFloat(zoneLight.blueColorValue) / 100.0,
                            alpha: 1.0
                    )

                    
                } else {
                    
                    backgroundColor = UIColor.clear
                    
                    iconButton.isSelected = false
                    
                    statusButton.setTitle(SHLanguageText.off,
                                          for: .normal
                    )
                }
            }
        }
    }

    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return navigationBarHeight * 2 + statusBarHeight
        }
        
        return navigationBarHeight + statusBarHeight
    }
    
    private lazy var colorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    /// 左边的背景视图
    @IBOutlet weak var leftbackgroundImageView: UIImageView!
    
    /// 右边的背景视图
    @IBOutlet weak var rightbackgroundImageView: UIImageView!
    
    /// 中间的视图背影
    @IBOutlet weak var middlebackgroundImagView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 状态按钮
    @IBOutlet weak var statusButton: UIButton!
    
    /// 按钮
    @IBOutlet weak var iconButton: SHZoneLightButton!
    
    /// 不同的部分
    @IBOutlet weak var differentView: UIView!
    
    /// 调整亮度条
    @IBOutlet weak var brightnessSlider: UISlider!
    
    /// 亮度值
    @IBOutlet weak var brightnessLabel: UILabel!
    
    /// 滑动依靠左边的约束
    @IBOutlet weak var brightnessSliderLeftConstraint: NSLayoutConstraint!
    
    /// 中间图标的宽度约束
    @IBOutlet weak var middleIconViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var middleIconViewHeightConstraint: NSLayoutConstraint!
    
    /// 亮度文字的宽度
    @IBOutlet weak var brignhtnessLabelWidthConstraint: NSLayoutConstraint!
    
    // MARK: - 事件
    
    /// 改变亮度值 [UI变化，但不发送指令]
    @IBAction func brightnessSliderChange() {
    
        let brightness = UInt8(brightnessSlider.value)
        
        brightnessLabel.text = "\(brightness)%"
        
        iconButton.isSelected = brightness != 0
    }
    
    /// 手指离开触发
    @IBAction func beginSlider() {
        
        let brightness = UInt8(brightnessSlider.value)
        
        controlGeneralLight(brightness: brightness)
    }
    
    /// 状态按钮点击
    @IBAction func statusButtonClick() {
    
        guard let zoneLight = light else {
            return
        }
        
        let brightness =
            statusButton.currentTitle == SHLanguageText.on ?
                0 : lightMaxBrightness
        
        switch zoneLight.canDim {
        
        case .notDimmable: // 不能调光的
        
            iconButton.isSelected = brightness != 0
            
            let statusTitle = iconButton.isSelected ? SHLanguageText.on : SHLanguageText.off
            
            statusButton.setTitle(statusTitle, for: .normal)
            
            controlGeneralLight(brightness: brightness)
            
        case .pushOnReleaseOff: // 按开松关
            
            statusButton.setTitle(SHLanguageText.off,
                                  for: .normal
            )
            iconButton.isSelected = false
            controlGeneralLight(brightness: 0)
            
        case .led:
            
            let selectController = SHSelectColorViewController()
            
            if brightness != 0 { // 当前是关闭状态，点击就打开。
                
                selectController.showColor { (red, green, blue, alpha) in
                    
                    self.controlLED(
                        red: UInt8(red),
                        green: UInt8(green),
                        blue: UInt8(blue),
                        white: 0)
                }
                
            } else {
                
                controlLED()
            }
            
        default:
            break
        }
    }

    /// 状态按钮按下
    @IBAction func statusButtonTouchDown() {

        if light?.canDim != .pushOnReleaseOff {
            return
        }
        
        iconButton.isSelected = true
        statusButton.setTitle(SHLanguageText.on, for: .normal)
        
        controlGeneralLight(brightness: lightMaxBrightness)
    }
    
    /// 按钮按下
    @IBAction func iconButtonTouchDown() {
        
        if light?.canDim != .pushOnReleaseOff {
            
            let image = iconButton.image(for: .selected)
            iconButton.setImage(image, for: .highlighted)
            
            return
        }
        
        iconButton.isSelected = true
        
        iconButton.setImage(UIImage(named: "zoneLightPushOn"),
                            for: .highlighted
        )
        
        statusButton.setTitle(SHLanguageText.on, for: .normal)
        
        controlGeneralLight(brightness: lightMaxBrightness)
    }

    /// 按钮图标点击
    @IBAction func iconButtonClick() {
        
        guard let zoneLight = light else {
            return
        }
        
        switch zoneLight.canDim {
        
        case .notDimmable: //  0.不能调光的
        
            iconButton.isSelected = !iconButton.isSelected
            
            let statusTitle = iconButton.isSelected ? SHLanguageText.on : SHLanguageText.off
            
            statusButton.setTitle(statusTitle, for: .normal)
            
            let brightness =
                iconButton.isSelected ? lightMaxBrightness : 0
            
            controlGeneralLight(brightness: brightness)
            
        case .dimmable: // 可以调光的
            
            iconButton.isSelected = !iconButton.isSelected
            
            let brightness =
                iconButton.isSelected ? lightMaxBrightness : 0
            
            controlGeneralLight(brightness: brightness)
            
            brightnessSlider.value = Float(brightness)
            
            brightnessSliderChange()
            
        case .pushOnReleaseOff: // 按住开，松开关
            
            iconButton.isSelected = false
           
            iconButton.setTitle(SHLanguageText.off, for: .normal)
          
            controlGeneralLight(brightness: 0)
            
        case .led: // LED
            
            iconButton.isSelected = !iconButton.isSelected
            
            let statusTitle = iconButton.isSelected ? SHLanguageText.on : SHLanguageText.off
            
            iconButton.setTitle(statusTitle, for: .normal)
            
            let selectController = SHSelectColorViewController()
            
            if iconButton.isSelected {
                
                selectController.showColor { (red, green, blue, alpha) in
                    
                    self.controlLED(
                        red: UInt8(red * CGFloat(lightMaxBrightness)),
                        green: UInt8(green * CGFloat(lightMaxBrightness)),
                        blue: UInt8(blue * CGFloat(lightMaxBrightness)),
                        white: 0)
                }
                
            } else {
                
                 controlLED()
            }
        }
    }
    
    /// 控制普通灯泡
    private func controlGeneralLight(brightness: UInt8 = 0) {
        
        guard let zoneLight = light else {
            return
        }
        
        zoneLight.brightness = brightness
        
        let lightData: [UInt8] = [
        
            zoneLight.channelNo,
            brightness,
            0,
            0
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0031,
            subNetID: zoneLight.subnetID,
            deviceID: zoneLight.deviceID,
            additionalData: lightData
        )
    }
    
    /// 控制LED
    private func controlLED(red:   UInt8 = 0,
                            green: UInt8 = 0,
                            blue:  UInt8 = 0,
                            white: UInt8 = 0
        ) {
        
        guard let led = light else {
            return
        }
        
        let ledData: [UInt8] = [
            
            red,
            green,
            blue,
            white,
            0,
            0
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xF080,
            subNetID: led.subnetID,
            deviceID: led.deviceID,
            additionalData: ledData
        )
    }
}


// MARK: - UI初始化
extension SHZoneControlLightViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.red
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
        colorView.isHidden = true
        
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
            
            middleIconViewWidthConstraint.constant =
                navigationBarHeight * 2
            
            middleIconViewHeightConstraint.constant =
                navigationBarHeight * 2
            
            brignhtnessLabelWidthConstraint.constant =
                navigationBarHeight + statusBarHeight
            
            brightnessSliderLeftConstraint.constant =
                statusBarHeight
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
