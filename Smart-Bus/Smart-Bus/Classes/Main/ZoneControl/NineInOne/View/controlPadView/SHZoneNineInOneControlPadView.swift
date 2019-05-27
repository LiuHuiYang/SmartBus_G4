//
//  SHZoneNineInOneControlPadView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/12/14.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHZoneNineInOneControlPadView: UIView, loadNibView {
    
    /// 9in1模型
    var nineInOne: SHNineInOne? {
        
        didSet {
            
            guard let currentNineInOne  = nineInOne else {
                return
            }
            
            control1Button.setTitle(
                currentNineInOne.switchNameforControl1,
                for: .normal
            )
            
            control2Button.setTitle(
                currentNineInOne.switchNameforControl2,
                for: .normal
            )
            
            control3Button.setTitle(
                currentNineInOne.switchNameforControl3,
                for: .normal
            )
            
            control4Button.setTitle(
                currentNineInOne.switchNameforControl4,
                for: .normal
            )
            
            control5Button.setTitle(
                currentNineInOne.switchNameforControl5,
                for: .normal
            )
            
            control6Button.setTitle(
                currentNineInOne.switchNameforControl6,
                for: .normal
            )
            
            control7Button.setTitle(
                currentNineInOne.switchNameforControl7,
                for: .normal
            )
            
            control8Button.setTitle(
                currentNineInOne.switchNameforControl8,
                for: .normal
            )
        }
    }
    
    /// 确定按钮
    @IBOutlet weak var sureButton: UIButton!
    
    /// control1
    @IBOutlet weak var control1Button: UIButton!
    
    /// control2
    @IBOutlet weak var control2Button: UIButton!
    
    /// control3
    @IBOutlet weak var control3Button: UIButton!
    
    /// control4
    @IBOutlet weak var control4Button: UIButton!
    
    /// control5
    @IBOutlet weak var control5Button: UIButton!
    
    /// control6
    @IBOutlet weak var control6Button: UIButton!
    
    /// control7
    @IBOutlet weak var control7Button: UIButton!
    
    /// control8
    @IBOutlet weak var control8Button: UIButton!
    
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
    
    /// 确认
    @IBAction func sureButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControlSure)
    }
    
    /// 上
    @IBAction func upButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControlUp)
    }
    
    /// 下
    @IBAction func downButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControlDown)
    }
    
    /// 左
    @IBAction func leftButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControlLeft)
    }
    
    /// 右
    @IBAction func rightButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControlRight)
    }
    
    /// C1
    @IBAction func control1ButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControl1)
    }
    
    /// C2
    @IBAction func control2ButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControl2)
    }
    
    /// C3
    @IBAction func control3ButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControl3)
    }
    
    /// C4
    @IBAction func control4ButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControl4)
    }
    
    /// C5
    @IBAction func control5ButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControl5)
    }
    
    /// C6
    @IBAction func control6ButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControl6)
    }
    
    /// C7
    @IBAction func control7ButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControl7)
    }
    
    /// C8
    @IBAction func control8ButtonClick() {
        
        sendControlData(switchNumber: nineInOne?.switchIDforControl8)
    }
    
    private func sendControlData(switchNumber: UInt? = 0) {
        
        guard let currentNineInOne = nineInOne,
            let switchID = switchNumber else {
                return
        }
        
        SoundTools.share().playSound(withName: "click.wav")
        
        SHSocketTools.sendData(
            operatorCode: 0xE01C,
            subNetID: currentNineInOne.subnetID,
            deviceID: currentNineInOne.deviceID,
            additionalData: [UInt8(switchID), 0xFF]
        )
    }
}


// MARK: - UI
extension SHZoneNineInOneControlPadView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sureButton.setTitle(SHLanguageText.ok, for: .normal)
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            control1Button.titleLabel?.font = font
            control2Button.titleLabel?.font = font
            control3Button.titleLabel?.font = font
            control4Button.titleLabel?.font = font
            control5Button.titleLabel?.font = font
            control6Button.titleLabel?.font = font
            control7Button.titleLabel?.font = font
            control8Button.titleLabel?.font = font
            sureButton.titleLabel?.font = font
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let baseSize: CGFloat = min(frame_width, frame_height)
        
        let scale: CGFloat = (frame_width < frame_height) ? 0.55 : 0.6
        
        viewWidthConstraint.constant = baseSize * scale
        viewHeightConstraint.constant = baseSize * scale
        
        if UIDevice.is_iPad() {
            
            buttonWidthConstraint.constant =
                navigationBarHeight + statusBarHeight
            
            buttonHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
    }
}
