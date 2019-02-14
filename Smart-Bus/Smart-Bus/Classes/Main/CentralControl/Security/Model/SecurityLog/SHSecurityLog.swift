//
//  SHSecurityLog.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/26.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHSecurityLog: NSObject {

    /// 历史记录的序号
    var logNumber: UInt = 0
    
    /// 安防区域的编号
    var areaNumber: UInt8 = 0
    
    /// 子网ID
    var subNetID: UInt8 = 0
    
    /// 设备ID
    var deviceID: UInt8 = 0
    
    /// 通道
    var channelNumber: UInt8 = 0
    
    /// 安防类型编号
    var securityType: UInt8 = 0 {
        
        didSet {
            
            switch securityType {
            case 0:
                securityTypeName = "Disarm"
                
            case 1:
                securityTypeName = "Vacation"
                
            case 2:
                securityTypeName = "Away"
                
            case 3:
                securityTypeName = "Night"
                
            case 4:
                securityTypeName = "Night with visito"
                
            case 5:
                securityTypeName = "Day"
                
            default:
                break
            }
        }
    }
    
    /// 安防类型的名称(方便用于显示)
    var securityTypeName: String?
    
    /// 产生的时间
    var securityTime: String?
    
    /// 标注说明
    var remark: String?
}
