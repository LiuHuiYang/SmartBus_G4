//
//  SHSong.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/6.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHSong: NSObject {

    /// 子网ID
    var subNetID: UInt8 = 0
    
    /// 设备ID
    var deviceID: UInt8 = 0
    
    /// 音乐来源
    var sourceType: UInt8 = 0
    
    /// 音乐专辑号码(是哪一个专辑)
    var albumNumber: UInt8 = 0
    
    /// 音乐号码(专辑中的哪一首)
    var songNumber: UInt = 0
    
    /// 专辑名称
    var songName: String = ""
}
