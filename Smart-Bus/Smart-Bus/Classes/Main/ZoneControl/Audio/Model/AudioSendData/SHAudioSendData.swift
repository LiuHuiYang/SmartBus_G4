//
//  SHAudioSendData.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/6.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHAudioSendData: NSObject {

    /// 子网ID
    var subNetID: UInt8 = 0
    
    /// 设备ID
    var deviceID: UInt8 = 0
    
    /// 音乐来源
    var sourceType: UInt8 = 0
    
    /// 操作码
    var operatorCode: UInt16 = 0
    
    /// 可变参数
    var additionalData: [UInt8] =  [UInt8]()
    
    /// 总包数量 请求专辑或者包的总数量 至少是1
    var packageTotal: UInt = 0
    
    /// 当前包的序号从1开始 (请求专辑或者是歌曲的包号)
    var packageNumber: UInt = 0
    
    /// 类别号码(请求专辑与歌曲对应不同的参数) // 专辑号码
    var categoryNumber: UInt = 0

}
