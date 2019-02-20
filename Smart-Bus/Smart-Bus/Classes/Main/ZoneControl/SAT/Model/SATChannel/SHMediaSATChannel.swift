//
//  SHMediaSATChannel.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMediaSATChannel: NSObject {

    /// 分类ID
    var categoryID: UInt = 0
    
    /// 通道ID
    var channelID: UInt = 0
    
    /// 通道编号(与通道ID相同)
    var channelNo: UInt = 0
    
    /// 通道名称
    var channelName: String?
    
    /// 通道图片名称
    var iconName: String?
    
    /// 场景号
    var sequenceNo: UInt = 0
    
    /// 区域号(没有什么用，保留旧版本的代码)
    var zoneID: UInt = 0
    
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
