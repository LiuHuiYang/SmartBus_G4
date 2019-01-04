//
//  SHDeviceViewCell.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/2.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHDeviceViewCell: UITableViewCell {
    
    var device: SHDevice? {
        
        didSet {
            
            modelLabel.text = device?.deviceTypeName
            descLabel.text = device?.remark
            addressLabel.text =
                "subNetID: \(device?.subNetID ?? 0)\tdeviceID:\( device?.deviceID ?? 0)"
        }
    }
    
    /// 设备种类
    @IBOutlet weak var modelLabel: UILabel!
    
    /// 描述信息
    @IBOutlet weak var descLabel: UILabel!
    
    /// 地址信息
    @IBOutlet weak var addressLabel: UILabel!
    
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight + navigationBarHeight)
        }
        
        return (navigationBarHeight + statusBarHeight)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle =  .none
        
        let color = UIView.textWhiteColor()
        
        addressLabel.textColor = color
        descLabel.textColor = color
        modelLabel.textColor = color
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            addressLabel.font = font
            descLabel.font = font
            modelLabel.font = font
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
