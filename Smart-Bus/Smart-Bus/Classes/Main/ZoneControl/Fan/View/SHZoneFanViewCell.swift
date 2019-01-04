//
//  SHZoneFanViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/7/31.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

class SHZoneFanViewCell: UITableViewCell {
    
    /// 当前的风扇
    var fan: SHFan? {
        
        didSet {
            
            nameLabel.text = fan?.fanName
            

            var type = fan?.fanTypeID.rawValue ?? 0
            
            if type <= SHFanType.one.rawValue {
                type = SHFanType.one.rawValue
            }
         
            iconButton.setImage(
                UIImage(named:"Fan\(type)_normal"),
                for: .normal
            )
            
            iconButton.setImage(
                UIImage(named:"Fan\(type)_highlighted"),
                for: .selected
            )
            
            let fanSpeed = fan?.fanSpeed ?? .off
            
            switch fanSpeed {
           
            case .off:
                fanSlider.value = fanSlider.minimumValue
            
            case .low:
                fanSlider.value = fanSlider.maximumValue * 0.25
                
            case .middle:
                 fanSlider.value = fanSlider.maximumValue * 0.5
                
            case .high:
                fanSlider.value = fanSlider.maximumValue * 0.75
                
            case .full:
                fanSlider.value = self.fanSlider.maximumValue
                
            default:
                break
            }
            
            iconButton.isSelected = (fanSpeed != .off)
        }
    }
    
    
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight * 2 + statusBarHeight)
        }
        
        return (navigationBarHeight + statusBarHeight)
    }

    /// 风扇滑块高度
    @IBOutlet weak var fanSliderHeightConstraint: NSLayoutConstraint!
    
    /// 风扇图标的宽度
    @IBOutlet weak var iconButtonWidthConstraint: NSLayoutConstraint!
    
    /// 风扇图标的高度
    @IBOutlet weak var iconButtonHeightConstraint: NSLayoutConstraint!
    
    /// 图片
    @IBOutlet weak var iconButton: UIButton!
    
    /// 风速档位
    @IBOutlet weak var fanSlider: UISlider!
    
    /// 风扇名称
    @IBOutlet weak var nameLabel: UILabel!
    
    //==== 四个档位标签
    @IBOutlet weak var oneLabel: UILabel!
    
    @IBOutlet weak var twoLabel: UILabel!
    
    @IBOutlet weak var threeLabel: UILabel!
    
    @IBOutlet weak var fourLabel: UILabel!
    
    
    /// 调整风速的值的变化
    @IBAction func fanSliderValueChange() {
        
        // 获得值
        let sliderValue = fanSlider?.value ?? 0
        
        if sliderValue > fanSlider.maximumValue * 0.85 {
            
            fanSlider.value = fanSlider.maximumValue
            fan?.fanSpeed = .full
        
        } else if sliderValue > fanSlider.maximumValue * 0.65 &&
            sliderValue <= self.fanSlider.maximumValue * 0.85  {
            
            fanSlider.value = fanSlider.maximumValue * 0.75
            fan?.fanSpeed = .high
       
        } else if sliderValue > fanSlider.maximumValue * 0.35 &&
            sliderValue <= self.fanSlider.maximumValue * 0.65  {
            
            fanSlider.value = fanSlider.maximumValue * 0.5
            fan?.fanSpeed = .middle
        
        } else if sliderValue > fanSlider.maximumValue * 0.15 &&
            sliderValue <= self.fanSlider.maximumValue * 0.35  {
            
            fanSlider.value = fanSlider.maximumValue * 0.25
            fan?.fanSpeed = .low
        
        } else {
        
            fanSlider.value = fanSlider.minimumValue
            fan?.fanSpeed = .off
        }
        
        iconButton.isSelected =
            (fanSlider.value != fanSlider.minimumValue)
    }
    
    // 发送指令
    @IBAction func fanSliderTouchUpInside() {
    
        guard let currentFan = fan else {
            return
        }
        
        let fanData = [
            currentFan.channelNO,
            currentFan.fanSpeed.rawValue,
            0,
            0
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0031,
            subNetID: currentFan.subnetID,
            deviceID: currentFan.deviceID,
            additionalData: fanData
        )
    }
    
    /// 按钮点击
    @IBAction func iconButtonClick() {
    
        iconButton.isSelected = !iconButton.isSelected
        
        fan?.fanSpeed = iconButton.isSelected ? .full : .off
        
        fanSlider.value = Float(fan?.fanSpeed.rawValue ?? 0)
        
        fanSliderValueChange()
        
        fanSliderTouchUpInside()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        fanSlider.maximumValue = Float(SHFanSpeed.full.rawValue)
        
        let icon =
            UIImage.darwNewImage(
                UIImage(named: "fanslider"),
                width: fanSlider.frame_height
        )
        
        fanSlider.setThumbImage(icon, for: .normal)
        fanSlider.setThumbImage(icon, for: .highlighted)
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            nameLabel.font = font
            oneLabel.font = font
            twoLabel.font = font
            threeLabel.font = font
            fourLabel.font = font
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
        
            iconButtonWidthConstraint.constant =
                (navigationBarHeight * 2)
        
            iconButtonHeightConstraint.constant =
                (navigationBarHeight * 2)
        
            fanSliderHeightConstraint.constant = tabBarHeight
        }
        
        let icon =
            UIImage.darwNewImage(
                UIImage(named: "fanslider"),
                width: fanSlider.frame_height
        )
        
        fanSlider.setThumbImage(icon, for: .normal)
        fanSlider.setThumbImage(icon, for: .highlighted)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
