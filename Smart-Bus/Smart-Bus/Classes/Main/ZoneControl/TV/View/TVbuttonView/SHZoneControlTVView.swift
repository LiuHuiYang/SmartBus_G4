//
//  SHZoneControlTVView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/8/8.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

class SHZoneControlTVView: UIView, loadNibView {
    
    /// TV模型
    var mediaTV: SHMediaTV?
    
    /// 开
    @IBOutlet weak var turnOnButton: UIButton!
    
    /// 关
    @IBOutlet weak var turnOffButton: UIButton!
    
    /// 菜单
    @IBOutlet weak var menuButton: UIButton!
    
    /// 确定
    @IBOutlet weak var sureButton: UIButton!
    
    /// 源
    @IBOutlet weak var sourceButton: UIButton!
    
    /// 静音
    @IBOutlet weak var stopVoiceButton: UIButton!
    
    /// 声音+ 按钮
    @IBOutlet weak var voiceUpButton: UIButton!
    
    /// 声音- 按钮
    @IBOutlet weak var voiceDownButton: UIButton!
    
    /// 频道 + 按钮
    @IBOutlet weak var addChannelButton: UIButton!
    
    /// 频道 - 按钮
    @IBOutlet weak var minusChannelButton: UIButton!
    
    // MARK: - 约束
    
    ///  View高度约束
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    /// View宽度约束
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!
    
    /// 按钮的高度约束
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 按钮的宽度约束
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    
    /// 确定键
    @IBAction func sureButtonClick() {
     
        controlTV(
            controlType: mediaTV?.universalSwitchIDforOK,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 打开电视
    @IBAction func turnOnTV() {
    
        controlTV(
            controlType: mediaTV?.universalSwitchIDforOn,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 关闭电视
    @IBAction func turnOffTV() {
      
        controlTV(
            controlType: mediaTV?.universalSwitchIDforOff,
            controlValue: mediaTV?.universalSwitchStatusforOff
        )
    }
    
    /// 打开菜单
    @IBAction func openMenu() {
      
        controlTV(
            controlType: mediaTV?.universalSwitchIDforMenu,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 静音
    @IBAction func muteClick() {
        
        controlTV(
            controlType: mediaTV?.universalSwitchIDforMute,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 源点击
    @IBAction func sourceClick() {
      
        controlTV(
            controlType: mediaTV?.universalSwitchIDforSource,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 频道加
    @IBAction func addChannel() {
        
        controlTV(
            controlType: mediaTV?.universalSwitchIDforCHAdd,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 频道减
    @IBAction func minusChannel() {
        
        controlTV(
            controlType: mediaTV?.universalSwitchIDforCHMinus,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 降低音量
    @IBAction func voiceDown() {
     
        controlTV(
            controlType: mediaTV?.universalSwitchIDforVOLDown,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 增大音量
    @IBAction func voiceUp() {
        
        controlTV(
            controlType: mediaTV?.universalSwitchIDforVOLUp,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    
    @IBAction func upButtonClick() {
        
        controlTV(
            controlType: mediaTV?.universalSwitchIDforUp,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
   
    /// 向下
    @IBAction func downButtonClick() {
        
        controlTV(
            controlType: mediaTV?.universalSwitchIDforDown,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 向左
    @IBAction func leftButtonClick() {
        
        controlTV(
            controlType: mediaTV?.universalSwitchIDforLeft,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 向右
    @IBAction func rightButtonClick() {
        
        controlTV(
            controlType: mediaTV?.universalSwitchIDforRight,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 返回
    @IBAction func backButtonClick() {
        
        controlTV(
            controlType: mediaTV?.universalSwitchIDforBack,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 其它
    @IBAction func otherButtonClick() {
        
        controlTV(
            controlType: mediaTV?.universalSwitchIDforOther,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    
    /// 主页
    @IBAction func mainPageButtonClick() {
        
        controlTV(
            controlType: mediaTV?.universalSwitchIDforMainPage,
            controlValue: mediaTV?.universalSwitchStatusforOn
        )
    }
    
    /// 发送控制数据
    private func controlTV(controlType: UInt?, controlValue: UInt?) {
        
        guard let tv = mediaTV,
            let type = controlType,
            let value = controlValue else {
                
                return
        }
        
        let controlData = [
            UInt8(type),
            UInt8(value)
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE01C,
            subNetID: tv.subnetID,
            deviceID: tv.deviceID,
            additionalData: controlData
        )
        
        SoundTools.share().playSound(withName: "click.wav")
    }
}

extension SHZoneControlTVView {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        sourceButton.titleLabel?.textAlignment = .center
        sourceButton.titleLabel?.numberOfLines = 0
        
        turnOnButton.setTitle(
            SHLanguageText.on,
            for: .normal
        )
        
        turnOffButton.setTitle(
            SHLanguageText.off,
            for: .normal
        )
        
//        menuButton.setTitle(
//            SHLanguageText.menu,
//            for: .normal
//        )
        
        sureButton.setTitle(
            SHLanguageText.ok,
            for: .normal
        )
        
        sourceButton.setTitle(
            SHLanguageText.source,
            for: .normal
        )
        
        stopVoiceButton.setTitle(
            SHLanguageText.mute,
            for: .normal
        )
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            turnOnButton.titleLabel?.font = font
            turnOffButton.titleLabel?.font = font
            menuButton.titleLabel?.font = font
            sureButton.titleLabel?.font = font
            sourceButton.titleLabel?.font = font
            stopVoiceButton.titleLabel?.font = font
            
            voiceUpButton.titleLabel?.font = font
            voiceDownButton.titleLabel?.font = font
            addChannelButton.titleLabel?.font = font
            minusChannelButton.titleLabel?.font = font
        }
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let scale:CGFloat =
            (frame_width < frame_height) ? 0.5 : 0.6
        
        let baseSize = min(frame_width, frame_height) * scale
        
        viewWidthConstraint.constant = baseSize
        viewHeightConstraint.constant = baseSize
        
        if UIDevice.is3_5inch() || UIDevice.is4_0inch() {
            
            buttonWidthConstraint.constant = tabBarHeight
            buttonHeightConstraint.constant = tabBarHeight
        
        } else if UIDevice.is_iPad() {
            
            buttonWidthConstraint.constant =
                (navigationBarHeight + statusBarHeight)
            
            buttonHeightConstraint.constant =
                (navigationBarHeight + statusBarHeight)
        }
        
    
    }
 
 }
