//
//  SHOtherControlViewCell.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/25.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHOtherControlViewCell: UITableViewCell {
    
    /// 其它操作
    var otherControl: SHOtherControl? {
        
        didSet {
            
            nameLabel.text = otherControl?.remark
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return navigationBarHeight * 2 + statusBarHeight
        }
        
        return navigationBarHeight + statusBarHeight
    }
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 开始执行按钮
    @IBOutlet weak var runButton: UIButton!
    
    /// 停止执行按钮
    @IBOutlet weak var stopButton: UIButton!
    
    /// 图片的宽度
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    
    /// 图片的高度
    @IBOutlet weak var iconViewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        runButton.setTitle(SHLanguageText.on,
                           for: .normal
        )
        
        stopButton.setTitle(SHLanguageText.off,
                            for: .normal
        )
        
        runButton.setRoundedRectangleBorder()
        stopButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            nameLabel.font = font
            runButton.titleLabel?.font = font
            stopButton.titleLabel?.font = font
        }
    }
    
    /// 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            iconViewWidthConstraint.constant = navigationBarHeight * 2
            
            iconViewHeightConstraint.constant =
                navigationBarHeight * 2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// 开始执行场景
    @IBAction func runButtonClick() {
        
        executeOtherControl(false)
    }
    
    /// 停止执行场景
    @IBAction func stopButtonClick() {
        
        executeOtherControl(true)
    }
    
    /// 执行其它控制
    func executeOtherControl(_ isStop: Bool = true)  {
        
        guard let other = otherControl else {
            return
        }
        
        switch other.controlType {
        
            // 单通道控制
        case .singleChannelControl:
            
            let value = isStop ? 0 : lightMaxBrightness
            
            SHSocketTools.sendData(
                operatorCode: 0x0031,
                subNetID: other.subnetID,
                deviceID: other.deviceID,
                additionalData:
                    [other.parameter1, value, 0, 0]
            )
            
            
        case .interLockControl:
            
            let channel =
                isStop ? other.parameter2 : other.parameter1
            
            SHSocketTools.sendData(
                operatorCode: 0x0031,
                subNetID: other.subnetID,
                deviceID: other.deviceID,
                additionalData:
                [channel, lightMaxBrightness, 0, 0]
            )
            
        case .logicControl:
            
            let channel =
                isStop ? other.parameter2 : other.parameter1
            
            SHSocketTools.sendData(
                operatorCode: 0xE01c,
                subNetID: other.subnetID,
                deviceID: other.deviceID,
                additionalData: [channel, 0xFF]
            )
            
        }
    }
}
