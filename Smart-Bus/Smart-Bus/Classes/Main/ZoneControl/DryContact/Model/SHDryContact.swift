//
//  SHDryContact.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/8.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit


// 干节点的类型
@objc enum SHDryContactType: UInt8 {
    
    case normalOpen    // 常开
    case normalClose   // 常闭
    case invalid // 未定义
}

/// 干节点的状态
@objc enum SHDryContactStatus: UInt8 {
    case close
    case open
}


@objcMembers class SHDryContact: NSObject {

    /// 干节点的名称
    var name: String?
    
    /// 干节点的类型
    var type: SHDryContactType = .invalid
    
    /// 干节点的状
    var status: SHDryContactStatus = .close
    
    // MARK: - 数据库信息
    
    /// 主键
    var id: UInt = 0
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 干节点的备注说明
    var remark: String?
    
    /// 子网ID
    var subnetID: UInt8 = 0
    
    ///  设备ID
    var deviceID: UInt8 = 0
    
    ///  通道
    var channelNo: UInt8 = 0
    
    ///  当前区域的第几个干节点
    var contactID: UInt = 0
    
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
