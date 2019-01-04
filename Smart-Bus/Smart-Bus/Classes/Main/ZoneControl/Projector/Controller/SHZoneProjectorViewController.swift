//
//  SHZoneProjectorViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/29.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

class SHZoneProjectorViewController: SHViewController {

    /// 投影仪
    var zoneProjector: SHMediaProjector?
    
    // MARK: - 界面文字适配
    
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
    
    // MARK: - 约束
    
    ///  View高度约束
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    /// View宽度约束
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!
    
    /// 按钮的高度约束
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 按钮的宽度约束
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    
    // MARK: - 点击事件
    
    /// 开机
    @IBAction func turnOnButtonClick() {
  
        controlProjector(
            controlType: zoneProjector?.universalSwitchIDforOn,
            controlValue: zoneProjector?.universalSwitchStatusforOn
        )
    }
    
    /// 关机
    @IBAction func turnOffButtonClick() {
        
        controlProjector(
            controlType: zoneProjector?.universalSwitchIDforOff,
            controlValue: zoneProjector?.universalSwitchStatusforOff
        )
    }
    
    /// 菜单
    @IBAction func menuButtonClick() {
    
        controlProjector(
            controlType: zoneProjector?.universalSwitchIDfoMenu,
            controlValue: zoneProjector?.universalSwitchStatusforOn
        )
    }
    
    /// 源
    @IBAction func sourceButtonClick() {
  
        controlProjector(
            controlType: zoneProjector?.universalSwitchIDforSource,
            controlValue: zoneProjector?.universalSwitchStatusforOn
        )
    }
    
    /// 向上
    @IBAction func upButtonClick() {
      
        controlProjector(
            controlType: zoneProjector?.universalSwitchIDfoUp,
            controlValue: zoneProjector?.universalSwitchStatusforOn
        )
    }
    
    /// 向下
    @IBAction func downButtonClick() {
      
        controlProjector(
            controlType: zoneProjector?.universalSwitchIDforDown,
            controlValue: zoneProjector?.universalSwitchStatusforOn
        )
    }
    
    /// 向左
    @IBAction func leftButtonClick() {
  
        controlProjector(
            controlType: zoneProjector?.universalSwitchIDforLeft,
            controlValue: zoneProjector?.universalSwitchStatusforOn
        )
    }
    
    /// 向右
    @IBAction func rightButtonClick() {
  
        controlProjector(
            controlType: zoneProjector?.universalSwitchIDforRight,
            controlValue: zoneProjector?.universalSwitchStatusforOn
        )
    }
    
    /// 确定
    @IBAction func sureButtonClick() {
        
        controlProjector(
            controlType: zoneProjector?.universalSwitchIDforOK,
            controlValue: zoneProjector?.universalSwitchStatusforOn
        )
    }
  
    
    /// 发送控制数据
    private func controlProjector(controlType: UInt?, controlValue: UInt?) {
        
        guard let projector = zoneProjector,
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
            subNetID: projector.subnetID,
            deviceID: projector.deviceID,
            additionalData: controlData
        )
    }
}


// MARK: - UI
extension SHZoneProjectorViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = zoneProjector?.remark
        
        sourceButton.titleLabel?.textAlignment = .center
        sourceButton.titleLabel?.numberOfLines = 0
        
        turnOnButton.setTitle(SHLanguageText.on,
                              for: .normal
        )
        
        turnOffButton.setTitle(SHLanguageText.off,
                               for: .normal
        )
        
        menuButton.setTitle(SHLanguageText.menu,
                            for: .normal
        )
        
        sureButton.setTitle(SHLanguageText.ok,
                            for: .normal
        )
        
        sourceButton.setTitle(SHLanguageText.source,
                              for: .normal
        )
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            turnOnButton.titleLabel?.font = font
            turnOffButton.titleLabel?.font = font
            menuButton.titleLabel?.font = font
            sureButton.titleLabel?.font = font
            sourceButton.titleLabel?.font = font
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
