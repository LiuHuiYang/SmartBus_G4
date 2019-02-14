//
//  SHSetSystemViewCellTableViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/15.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHSetSystemViewCell: UITableViewCell {
    
    /// 选择或者改变了某个设备的回调
    var choiceDevice: ((_ hasChoice: Bool) -> Void)?
    
    /// 设置名称
    var deviceName: String? {
        
        didSet {
            
            deviceNameLabel.text = deviceName!
        }
    }
    
    /// 设置设备包含状态
    var hasDevice: Bool = false {
        
        didSet {
            
            changeSwitch .setOn(hasDevice, animated: false)
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight * 2 + statusBarHeight)
        }
        
        return (navigationBarHeight + statusBarHeight)
    }
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    @IBOutlet weak var changeSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        changeSwitch.setOn(false, animated: false)
        
        if UIDevice.is_iPad() {
            
            deviceNameLabel.font = UIView.suitFontForPad()
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    /// 点击开关
    @IBAction func changeSwitchTouch() {
        
        choiceDevice?(changeSwitch.isOn)
    }
}
