//
//  SHZoneDmxChannelViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/7.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

class SHZoneDmxChannelViewCell: UITableViewCell {
    
    /// DMX通道
    var dmxChannel: SHDmxChannel? {
        
        didSet {
            
            guard let chanel = dmxChannel else {
                return
            }
            
            nameLabel.text = chanel.remark
            iconButton.isSelected =
                chanel.brightness != 0
            
            brightnessSlider.value = Float(chanel.brightness)
            
            brightnessLabel.text = "\(chanel.brightness)%"
            
        }
    }

    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {

            return navigationBarHeight * 2 + statusBarHeight
        }

        return navigationBarHeight + statusBarHeight

    }
    
    /// 左边的背景视图
    @IBOutlet weak var leftbackgroundImageView: UIImageView!
    
    /// 右边的背景视图
    @IBOutlet weak var rightbackgroundImageView: UIImageView!
    
    /// 中间的视图背影
    @IBOutlet weak var middlebackgroundImagView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 按钮
    @IBOutlet weak var iconButton: UIButton!
    
    // MARK: - 不同的部分

    /// 不同的部分
    @IBOutlet weak var differentView: UIView!
    
    /// 调整亮度条
    @IBOutlet weak var brightnessSlider: UISlider!
    
    /// 亮度值
    @IBOutlet weak var brightnessLabel: UILabel!
    
    /// 滑动依靠左边的约束
    @IBOutlet weak var brightnessSliderLeftConstraint: NSLayoutConstraint!
    
    // MARK: - 约束

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
     
        controlDmx(brightness: brightness)
    }
    
    /// 按钮图标点击
    @IBAction func iconButtonClick() {
        
        iconButton.isSelected = !iconButton.isSelected
        
        let brightness =
            iconButton.isSelected ? lightMaxBrightness : 0
        
        brightnessSlider.value = Float(brightness)
        brightnessSliderChange()
        
        controlDmx(brightness: brightness)
    }

    
    /// 控制DMX
    private func controlDmx(brightness: UInt8 = 0) {
        
        guard let channel = dmxChannel else {
            return
        }
        
        channel.brightness = brightness
        
        let channelData: [UInt8] = [
            
            channel.channelNo,
            brightness,
            0,
            0
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0031,
            subNetID: channel.subnetID,
            deviceID: channel.deviceID,
            additionalData: channelData,
            isDMX: true
        )
    }
}


// MARK: - UI初始化
extension SHZoneDmxChannelViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        
        let thumbImag =
            UIImage.getClearColorImage(
                CGSize(width: 7, height: 12)
        )
        
        brightnessSlider.setThumbImage(thumbImag,
                                       for: .normal
        )
        
        brightnessSlider.setThumbImage(thumbImag,
                                       for: .highlighted
        )
        
        brightnessSlider.transform =
            CGAffineTransform(scaleX: 1.0, y: 5.0)
        
        if UIDevice.is_iPad() {
            
            brightnessSlider.transform =
                CGAffineTransform(scaleX: 1.0, y: 15.0)
            
            let font = UIView.suitFontForPad()
            
            nameLabel.font = font
            brightnessLabel.font = font
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            middleIconViewWidthConstraint.constant = navigationBarHeight * 2
            
            middleIconViewHeightConstraint.constant = navigationBarHeight * 2
            
            brignhtnessLabelWidthConstraint.constant = navigationBarHeight + statusBarHeight
            
            brightnessSliderLeftConstraint.constant = statusBarHeight
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
