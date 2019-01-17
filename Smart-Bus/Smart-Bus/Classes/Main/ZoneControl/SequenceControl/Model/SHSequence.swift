//
//  SHSequence.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHSequence: NSObject {

    // MARK: - 数据库字段
    
    /// 主键
    var id: UInt = 0
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 序列ID
    var sequenceID: UInt = 0
    
    /// 备注
    var remark = "Sequence"
    
    /// 子网ID
    var subnetID: UInt8 = 0
    
    /// 设备ID
    var deviceID: UInt8 = 0
    
    /// 场景的区域编号
    var areaNo: UInt8 = 0
    
    /// 指定区域中的序列编号 0 表示关闭
    var sequenceNo: UInt8 = 0
    
    // MARK: - 构造
    
    override init() {
        super.init()
    }
    
    init(dictionary: [String: Any]) {
        super.init()
        
        setValuesForKeys(dictionary)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        // ...
    }
}
