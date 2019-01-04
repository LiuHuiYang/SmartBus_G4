//
//  SHZoneDVDControlViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/29.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

class SHZoneDVDControlViewController: SHViewController {

    /// DVD
    var zoneDVD: SHMediaDVD?
    
    /// 开
    @IBOutlet weak var turnOnButton: UIButton!
    
    /// 关
    @IBOutlet weak var turnOffButton: UIButton!
    
    /// 菜单
    @IBOutlet weak var menuButton: UIButton!
    
    /// 确定
    @IBOutlet weak var sureButton: UIButton!
    
    
    // MARK: - 约束
    
    /// View宽度
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!
    
    /// View高度
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    /// 按钮高度约束
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
   
    /// 按钮宽度约束
    @IBOutlet weak var buttonvWidthConstraint: NSLayoutConstraint!
    
    // MARK: - 点击事件
    
    /// 开机
    @IBAction func turnOn() {
    
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDforOn,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 关机
    @IBAction func turnOff() {
   
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDforOff,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 菜单
    @IBAction func menuButtonClick() {
      
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDfoMenu,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 暂停
    @IBAction func pauseButtonClick() {
        
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDforPlayPause,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 上一章
    @IBAction func prevChapterButtonClick() {
    
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDforPREVChapter,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 下一章
    @IBAction func nextChapterButtonClick() {
        
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDforNextChapter,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 开始录影
    @IBAction func recordButtonClick() {
    
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDforPlayRecord,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 停止录影
    @IBAction func stopRecordButtonClick() {
       
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDforPlayStopRecord,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 确定
    @IBAction func sureButtonClick() {
     
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDforOK,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 向上按钮点击
    @IBAction func upButtonClick() {
      
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDfoUp,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 向下按钮点击
    @IBAction func downButtonClick() {
      
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDforDown,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 快退
    @IBAction func backForwardButtonClick() {
      
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDforBackForward,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 快退
    @IBAction func fastForwardButtonClick() {
       
        controlDVD(
            controlType: zoneDVD?.universalSwitchIDforFastForward,
            controlValue: zoneDVD?.universalSwitchStatusforOn
        )
    }
    
    /// 发送控制数据
    private func controlDVD(controlType: UInt?, controlValue: UInt?) {
        
        guard let dvd = zoneDVD,
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
            subNetID: dvd.subnetID,
            deviceID: dvd.deviceID,
            additionalData: controlData
        )
    }
}

  

// MARK: - UI
extension SHZoneDVDControlViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = zoneDVD?.remark
        
        turnOnButton.setTitle(SHLanguageText.on, for: .normal)
        turnOffButton.setTitle(SHLanguageText.off, for: .normal)
        menuButton.setTitle(SHLanguageText.menu, for: .normal)
        sureButton.setTitle(SHLanguageText.ok, for: .normal)
        
        // 适配字体
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            turnOnButton.titleLabel?.font = font
            turnOffButton.titleLabel?.font = font
            menuButton.titleLabel?.font = font
            sureButton.titleLabel?.font = font
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let baseSize =
            CGFloat.minimum(view.frame_width, view.frame_height)
        
        let scale: CGFloat =
            (view.frame_width > view.frame_height) ? 0.65 : 0.6
        
        let constant = scale * baseSize
        
        viewWidthConstraint.constant = constant
        viewHeightConstraint.constant = constant
        
        if UIDevice.is_iPad() {
            
            buttonvWidthConstraint.constant =
                (navigationBarHeight + statusBarHeight)
            
            buttonHeightConstraint.constant =
                (navigationBarHeight + statusBarHeight)
            
        } else if UIDevice.is3_5inch() || UIDevice.is4_0inch() {
            
            buttonvWidthConstraint.constant = tabBarHeight
            buttonHeightConstraint.constant = tabBarHeight
        }
    }
}
