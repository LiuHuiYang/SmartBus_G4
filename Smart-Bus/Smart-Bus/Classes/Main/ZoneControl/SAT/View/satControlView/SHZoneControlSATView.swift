//
//  SHZoneControlSATView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/8/7.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

class SHZoneControlSATView: UIView, loadNibView {
    
    /// 卫星电视
    var mediaSAT: SHMediaSAT? {
        
        didSet {
            
            guard let sat = mediaSAT else {
                return
            }
            
            controlButton1.setTitle(sat.switchNameforControl1,
                                    for: .normal
            )
            
            controlButton2.setTitle(sat.switchNameforControl2,
                                    for: .normal
            )
            
            controlButton3.setTitle(sat.switchNameforControl3,
                                    for: .normal
            )
            
            controlButton4.setTitle(sat.switchNameforControl4,
                                    for: .normal
            )
            
            controlButton5.setTitle(sat.switchNameforControl5,
                                    for: .normal
            )
            
            controlButton6.setTitle(sat.switchNameforControl6,
                                    for: .normal
            )
            
        }
    }
    
    /// 开
    @IBOutlet weak var turnOnButton: UIButton!
    
    /// 关
    @IBOutlet weak var turnOffButton: UIButton!
    
    /// 菜单
    @IBOutlet weak var menuButton: UIButton!
    
    /// FAV
    @IBOutlet weak var favButton: UIButton!
    
    /// 确定
    @IBOutlet weak var sureButton: UIButton!
    
    @IBOutlet weak var controlButton1: UIButton!
    @IBOutlet weak var controlButton2: UIButton!
    @IBOutlet weak var controlButton3: UIButton!
    @IBOutlet weak var controlButton4: UIButton!
    @IBOutlet weak var controlButton5: UIButton!
    @IBOutlet weak var controlButton6: UIButton!
    
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
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDforOn,
            controlValue: mediaSAT?.universalSwitchStatusforOn
        )
    }
    
    /// 关机
    @IBAction func turnOffButtonClick() {
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDforOff,
            controlValue: mediaSAT?.universalSwitchStatusforOff
        )
    }
    
    /// fav
    @IBAction func favButtonClick() {
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDforFAV,
            controlValue: 0xFF
        )
    }
    
    /// 菜单
    @IBAction func menuButtonClick() {
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDfoMenu,
            controlValue: 0xFF
        )
    }
    
    /// 上一章
    @IBAction func prevButtonClick() {
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDforPREVChapter,
            controlValue: 0xFF
        )
    }
    
    /// 下一章
    @IBAction func nextButtonClick() {
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDforNextChapter,
            controlValue: 0xFF
        )
    }
    
    /// 录影
    @IBAction func recordButtonClick() {
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDforPlayRecord,
            controlValue: 0xFF
        )
    }
    
    /// 停止录影
    @IBAction func stopRecordButtonClick() {
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDforPlayStopRecord,
            controlValue: 0xFF
        )
    }
    
    /// 确定
    @IBAction func sureButtonClick() {
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDforOK,
            controlValue: 0xFF
        )
    }
    
    /// 向下
    @IBAction func upButtonClick() {
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDforUp,
            controlValue: 0xFF
        )
    }
    
    /// 向下
    @IBAction func downButtonClick() {
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDforDown,
            controlValue: 0xFF
        )
    }
    
    /// 向左
    @IBAction func leftButtonClick() {
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDforLeft,
            controlValue: 0xFF
        )
    }
    
    /// 向右
    @IBAction func rightButtonClick() {
        
        controlSAT(
            controlType: mediaSAT?.universalSwitchIDforRight,
            controlValue: 0xFF
        )
    }
    
    @IBAction func controlButton1Click() {
        
        controlSAT(
            controlType: mediaSAT?.switchIDforControl1,
            controlValue: 0xFF
        )
    }
    
    @IBAction func controlButton2Click() {
        
        controlSAT(
            controlType: mediaSAT?.switchIDforControl2,
            controlValue: 0xFF
        )
    }
    
    @IBAction func controlButton3Click() {
        
        controlSAT(
            controlType: mediaSAT?.switchIDforControl3,
            controlValue: 0xFF
        )
    }
    
    @IBAction func controlButton4Click() {
        
        controlSAT(
            controlType: mediaSAT?.switchIDforControl4,
            controlValue: 0xFF
        )
    }
    
    @IBAction func controlButton5Click() {
        
        controlSAT(
            controlType: mediaSAT?.switchIDforControl5,
            controlValue: 0xFF
        )
    }
    
    @IBAction func controlButton6Click() {
        
        controlSAT(
            controlType: mediaSAT?.switchIDforControl6,
            controlValue: 0xFF
        )
    }
    
    /// 发送控制数据
    private func controlSAT(controlType: UInt?, controlValue: UInt?) {
        
        guard let sat = mediaSAT,
            let type = controlType,
            let value = controlValue else {
                
                return
        }
        
        let controlData = [
            UInt8(type),
            UInt8(value)
        ]
        
        SoundTools.share().playSound(withName: "click.wav")
        
        SHSocketTools.sendData(
            operatorCode: 0xE01C,
            subNetID: sat.subnetID,
            deviceID: sat.deviceID,
            additionalData: controlData
        )
    }
}


// MARK: - UI
extension SHZoneControlSATView {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        turnOnButton.setTitle(SHLanguageText.on, for: .normal)
        turnOffButton.setTitle(SHLanguageText.off, for: .normal)
        menuButton.setTitle(SHLanguageText.menu, for: .normal)
        sureButton.setTitle(SHLanguageText.ok, for: .normal)
        
        let fav =
            SHLanguageTools.share()?.getTextFromPlist(
                "MEDIA_IN_ZONE",
                withSubTitle: "FAV"
                ) as! String
        
        favButton.setTitle(fav, for: .normal)
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            turnOnButton.titleLabel?.font = font
            turnOffButton.titleLabel?.font = font
            menuButton.titleLabel?.font = font
            sureButton.titleLabel?.font = font
            favButton.titleLabel?.font = font
            controlButton1.titleLabel?.font = font
            controlButton2.titleLabel?.font = font
            controlButton3.titleLabel?.font = font
            controlButton4.titleLabel?.font = font
            controlButton5.titleLabel?.font = font
            controlButton6.titleLabel?.font = font
            
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let scale:CGFloat =
            (frame_width < frame_height) ? 0.5 : 0.6
        
        let baseSize = min(frame_width, frame_height) * scale
        
        viewWidthConstraint.constant = baseSize
        viewHeightConstraint.constant = baseSize
        
        if UIDevice.is3_5inch() {
            
            buttonWidthConstraint.constant = defaultHeight
            buttonHeightConstraint.constant = defaultHeight
            
        } else if UIDevice.is4_0inch() {
            
            buttonWidthConstraint.constant = tabBarHeight
            buttonHeightConstraint.constant = tabBarHeight
            
        } else if UIDevice.is_iPad() {
            
            buttonWidthConstraint.constant =
                navigationBarHeight + statusBarHeight
            
            buttonHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
    }
}
