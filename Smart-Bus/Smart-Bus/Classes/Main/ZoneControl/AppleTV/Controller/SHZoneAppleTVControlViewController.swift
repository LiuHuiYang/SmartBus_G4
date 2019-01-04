//
//  SHZoneAppleTVControlViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2018/11/30.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHZoneAppleTVControlViewController: SHViewController {
    
    /// 苹果电视
    var zoneAppleTV: SHMediaAppleTV?
    
    /// 开
    @IBOutlet weak var turnOnButton: UIButton!
    
    /// 关闭按钮
    @IBOutlet weak var turnOffButton: UIButton!
    
    /// 菜单按钮
    @IBOutlet weak var menuButton: UIButton!
    
    // 宽度约束
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!
    
    /// 高度约束
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    /// 按钮的高度约束
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 按钮的宽度约束
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    
    // MARK: - 点击事件
    
    /// 开机
    @IBAction func turnOnButtonClick() {
     
        controlAppleTV(
            controlType: zoneAppleTV?.universalSwitchIDforOn,
            controlValue: zoneAppleTV?.universalSwitchStatusforOn
        )
    }
    
    /// 关机
    @IBAction func turnOffButtonClick() {
    
        controlAppleTV(
            controlType: zoneAppleTV?.universalSwitchIDforOff,
            controlValue: zoneAppleTV?.universalSwitchStatusforOff
        )
    }
    
    /// 菜单
    @IBAction func menuButtonClick() {
     
        controlAppleTV(
            controlType: zoneAppleTV?.universalSwitchIDforMenu,
            controlValue: zoneAppleTV?.universalSwitchStatusforOn
        )
    }
    
    /// 快进
    @IBAction func pauseButtonClick() {
  
        controlAppleTV(
            controlType: zoneAppleTV?.universalSwitchIDforPlayPause,
            controlValue: zoneAppleTV?.universalSwitchStatusforOn
        )
    }
    
    /// 向上
    @IBAction func upButtonClick() {
        
        controlAppleTV(
            controlType: zoneAppleTV?.universalSwitchIDforUp,
            controlValue: zoneAppleTV?.universalSwitchStatusforOn
        )
    }
    
    /// 向下
    @IBAction func downButtonClick() {
  
        controlAppleTV(
            controlType: zoneAppleTV?.universalSwitchIDforDown,
            controlValue: zoneAppleTV?.universalSwitchStatusforOn
        )
    }
    
    /// 向左
    @IBAction func leftButtonClick() {
        
        controlAppleTV(
            controlType: zoneAppleTV?.universalSwitchIDforLeft,
            controlValue: zoneAppleTV?.universalSwitchStatusforOn
        )
    }
    
    /// 向右
    @IBAction func rightButtonClick() {
      
        controlAppleTV(
            controlType: zoneAppleTV?.universalSwitchIDforRight,
            controlValue: zoneAppleTV?.universalSwitchStatusforOn
        )
    }
    
    /// 确定
    @IBAction func sureButtonClick() {
      
        controlAppleTV(
            controlType: zoneAppleTV?.universalSwitchIDforOK,
            controlValue: zoneAppleTV?.universalSwitchStatusforOn
        )
    }
    
    /// 发送控制数据
    private func controlAppleTV(controlType: UInt?, controlValue: UInt?) {
    
        guard let appleTV = zoneAppleTV,
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
            subNetID: appleTV.subnetID,
            deviceID: appleTV.deviceID,
            additionalData: controlData
        )
    }
}

extension SHZoneAppleTVControlViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = zoneAppleTV?.remark
    
        turnOnButton.setTitle(SHLanguageText.on, for: .normal)
        turnOffButton.setTitle(SHLanguageText.off, for: .normal)
        menuButton.setTitle(SHLanguageText.menu, for: .normal)
        
        // 适配字体
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
          
            turnOnButton.titleLabel?.font = font
            turnOffButton.titleLabel?.font = font
            menuButton.titleLabel?.font = font
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let baseSize: CGFloat =
            min(view.frame_width, view.frame_height) * 0.8
        
        viewWidthConstraint.constant = baseSize
        viewHeightConstraint.constant = baseSize
        
        if UIDevice.is3_5inch() {
            
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
