//
//  SHSecurityLogCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/26.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHSecurityLogCell: UITableViewCell {
    
    /// 安防日志
    var securityLog: SHSecurityLog? {
        
        didSet {
            
            guard let log = securityLog else {
                return
            }
            
            logNumberLabel.text = "NO. \(log.logNumber)"
            timeLabel.text = log.securityTime
            subNetIDLabel.text = "subNetID: \(log.subNetID)"
            deviceIDLabel.text = "subNetID: \(log.deviceID)"
//            areaLabel.text = "area: \(log.areaNumber)"
            channelNumberLabel.text =
                "channelNo: \(log.channelNumber)"
            securityTypeLabel.text =
                "type: \(log.securityTypeName ?? "N/A")"
        }
    }
    
    /// 记录的序号
    @IBOutlet weak var logNumberLabel: UILabel!
    
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 子网ID
    @IBOutlet weak var subNetIDLabel: UILabel!
    
    /// 设备ID
    @IBOutlet weak var deviceIDLabel: UILabel!
    
    /// 区域
    @IBOutlet weak var areaLabel: UILabel!
    
    /// 通道号
    @IBOutlet weak var channelNumberLabel: UILabel!
    
    /// 类型
    @IBOutlet weak var securityTypeLabel: UILabel!
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight + navigationBarHeight + navigationBarHeight)
        }
        
        return (navigationBarHeight + navigationBarHeight + statusBarHeight)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle =  .none
        backgroundColor = UIColor.clear
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            logNumberLabel.font = font
            timeLabel.font = font
            subNetIDLabel.font = font
            deviceIDLabel.font = font
            areaLabel.font = font
            channelNumberLabel.font = font
            securityTypeLabel.font = font
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
