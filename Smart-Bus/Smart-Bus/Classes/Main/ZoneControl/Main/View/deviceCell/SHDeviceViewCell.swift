//
//  SHDeviceViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/2.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHDeviceViewCell: UITableViewCell {
    
    var device: SHDevice? {
        
        didSet {
            
            modelLabel.text =
                "Model: " + (device?.deviceTypeName ?? "N/A")
            
            deviceTypeLabel.text =
                "DeviceType: \(device?.deviceType ?? 0)"
            
            addressLabel.text =
                "SubNetID: \(device?.subNetID ?? 0)" +
                " \t\t " +
                "DeviceID:\( device?.deviceID ?? 0)"
            
            firmwareVersionLabel.text =
                "Version:" + (device?.firmWareVersion ?? "N/A")
            
            descLabel.text =
                "Remark:" + (device?.remark ?? "N/A")
        }
    }
    
    
    /// 设备模型
    @IBOutlet weak var modelLabel: UILabel!
    
    /// 设备种类
    @IBOutlet weak var deviceTypeLabel: UILabel!
    
    /// 地址信息
    @IBOutlet weak var addressLabel: UILabel!
    
    /// 固件版本信息
    @IBOutlet weak var firmwareVersionLabel: UILabel!
    
    /// 描述信息
    @IBOutlet weak var descLabel: UILabel!
    
     
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight +
                    navigationBarHeight +
                    tabBarHeight
            )
        }
        
        return (navigationBarHeight + navigationBarHeight)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle =  .none
        
        let color = UIView.textWhiteColor()
        
        modelLabel.textColor = color
        deviceTypeLabel.textColor = color
        addressLabel.textColor = color
        firmwareVersionLabel.textColor = color
        descLabel.textColor = color
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            modelLabel.font = font
            deviceTypeLabel.font = font
            addressLabel.font = font
            firmwareVersionLabel.font = font
            descLabel.font = font
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
