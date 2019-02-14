//
//  SHDmxChannel.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

// 注意： Swift中的枚举要加上 @objc 才能让OC来调用，否则就不一样了。
/// 通道类型
@objc enum SHDmxChannelType: UInt {
    case none
    case red
    case green
    case blue
    case white
}

@objcMembers class SHDmxChannel: NSObject {
    
    /// 亮度值： - 这是为了保存方便【没有存储在数据库当中】
    var brightness: UInt8 = 0
    
    // MARK: - 数据库中的值
    
    /// 唯一ID号
    var id: UInt = 0
    
    /// 组ID
    var groupID: UInt = 0
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 分组标题
    var  groupName: String = "dmx group"
    
    /// 子网ID
    var subnetID: UInt8 = 0
    
    /// 设备ID
    var deviceID: UInt8 = 0
    
    /// 通道号
    var channelNo: UInt8 = 0
    
    /// 通道类型
    var channelType: SHDmxChannelType = .none
    
    /// 通道名称
    var  remark: String = "dmx channel"


    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        // ...
        
        if key == "ID" {
            
            id = value as? UInt ?? 0
        }
    }
}
