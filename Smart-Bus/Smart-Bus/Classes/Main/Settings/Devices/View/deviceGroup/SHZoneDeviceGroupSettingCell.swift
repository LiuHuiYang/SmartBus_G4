//
//  SHZoneDeviceGroupSettingCell.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/6.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// cell重用标示符
let deviceGroupSettingCellReuseIdentifier = "SHZoneDeviceGroupSettingCell"

class SHZoneDeviceGroupSettingCell: UITableViewCell {
    
    /// 设备名称
    var deviceName: String? {
        
        didSet {
            
            nameLabel.text = deviceName ?? "device"
            iconView.image = nil
        }
    }
    
    /// 场景
    var mood: SHMood? {
    
        didSet {
            
            nameLabel.text = mood?.moodName
            iconView.image = UIImage(named: ((mood?.moodIconName ?? "") + "_normal"))
        }
    }
    
    /// 场景命令
    var moodCommand: SHMoodCommand? {
        
        didSet {
            
            guard let command = moodCommand else {
                return
            }
            
            let showString =
            "\(command.moodID)- \(command.deviceName ?? "moodCommand") : \(command.deviceType) - \(command.subnetID) - \(command.deviceID)"
            
            nameLabel.text = showString
            iconView.image = nil
        }
    }
    
    /// dmx分组
    var dmxGroup: SHDmxGroup? {
        
        didSet {
            
            nameLabel.text = dmxGroup?.groupName
            iconView.image = UIImage(named: "showDmx")
        }
    }
    
    /// dmx通道
    var dmxChannel: SHDmxChannel? {
        
        didSet {
            
            guard let channel = dmxChannel else {
                return
            }
            
            nameLabel.text = "\(channel.groupID) - \(channel.remark ?? "dmx channel")"
            
            iconView.image = nil
        }
    }
    
    /// 宏命令
    var macroCommand: SHMacroCommand? {
        
        didSet {
            
            guard let command = macroCommand else {
                return
            }
            
            nameLabel.text = "\(command.macroID) - \(command.remark ?? "macroCommand")"
            
            iconView.image = nil
        }
    }
    
    /// 图标
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 按钮宽度约束
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    
    /// 按钮高度约束
    @IBOutlet weak var iconViewHeightConstraint: NSLayoutConstraint!
    
    /// 名称的左侧约束
    @IBOutlet weak var nameLabelLeftConstraint: NSLayoutConstraint!
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight * 2 + statusBarHeight)
        }
        
        return (navigationBarHeight + statusBarHeight)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            iconViewWidthConstraint.constant =
                (navigationBarHeight * 2)
            
            iconViewHeightConstraint.constant =
                (navigationBarHeight * 2)
        }
        
        if iconView.image == nil {
            
             nameLabelLeftConstraint.constant =
                (0 - iconViewWidthConstraint.constant)
        }

        for subView: UIView in subviews {
            
            if subView.isKind(of: NSClassFromString("UITableViewCellDeleteConfirmationView")!) {
                
                for actionButton in subView.subviews {
                    
                    guard let button = actionButton as? UIButton else {
                        
                        return
                    }
                    
                    if button.isKind(of: UIButton.self) {
                        
                        button.titleLabel?.font =
                            UIDevice.is_iPad() ? UIView.suitFontForPad() : UIFont.systemFont(ofSize: 18)
                    }
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
