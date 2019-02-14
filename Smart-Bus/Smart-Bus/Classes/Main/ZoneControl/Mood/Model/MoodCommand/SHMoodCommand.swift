//
//  SHMoodCommand.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMoodCommand: NSObject {

    /// 唯一标示
    var id: UInt = 0
    
    /// 当前区域ID
    var zoneID: UInt = 0
    
    /// 当前区域模式ID
    var moodID: UInt = 0
    
    /// 设备类型
    var deviceType: UInt = 0
    
    /// 子网ID
    var subnetID: UInt8 = 0
    
    /// 设备ID
    var deviceID: UInt8 = 0
    
    /// 设备名称
    var deviceName: String?
    
    /// 可变参数1【灯泡包含LED的设备类型】 【HVAC的开关状态】【Shade的开关状态】【音乐的声音大小】
    var parameter1: UInt = 0
    
    /// 可变参数2【Dimmer的通道】    【LED的 Red】【HVAC的风速】【Shade的开通道】【音乐的来源】
    var parameter2: UInt = 0
    
    /// 可变参数3【Dimmer的亮度】    【LED的 green】 【HVAC的工作温模式】【Shade的关通道】【音乐的专辑号码】
    var parameter3: UInt = 0
    
    /// 可变参数4   【LED的 blue】【HVAC的模式温度】【音乐的歌曲号码】
    var parameter4: UInt = 0
    
    /// 可变参数5   【LED的 white】 【音乐的播放状态】
    var parameter5: UInt = 0
    
    /// 可变参数6 【相当于旧代码中的  commandTypeID 】
    var parameter6: UInt = 0
    
    /// 延时发送(单位是ms)
    var delayMillisecondAfterSend: UInt = 0 {
        
        didSet {
            
            if (delayMillisecondAfterSend < 100) {
                
                delayMillisecondAfterSend = 100
            }
        }
    }

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
