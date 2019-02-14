//
//  SHNineInOne.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/8.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit
/**
 9in1获得温度的方式
 
 - SHNineInOneGetWayOfTemperatureTypeMax: 最大
 - SHNineInOneGetWayOfTemperatureTypeAverage: 平均
 - SHNineInOneGetWayOfTemperatureTypeMIN: 最小
 */
@objc enum SHNineInOneGetWayOfTemperatureType: UInt8 {
    
    case max = 1
    case average = 2
    case min = 3
}

@objcMembers class SHNineInOne: NSObject {

    // MARK: - 内存中需要使用的一些属性 (可以调整)
    
    /// 4TTemperature
    var sensor4TTemperature: Int = 0
    
    /// DDP Temperature
    var ddpTemperature: Int = 0
    
    /// external Temperature
    var externalTemperature: Int = 0
    
    /// lux的值
    var luxValue: UInt = 0
    
    /// DDP的温度开启
    var ddpTemperatureDisenabled: Bool = false
    
    /// ddp的子网ID
    var ddpSubNetID: UInt8 = 0
    
    /// ddp的设备ID
    var ddpDeviceID: UInt8 = 0
    
    /// 4T的温度开启 (YES - 关闭)
    var sensor4TTemperatureDisenabled: Bool = false
    
    /// 4T的子网ID
    var sensor4TSubNetID: UInt8 = 0
    
    /// 4T的设备ID
    var sensor4TDeviceID: UInt8 = 0
    
    /// 4T的通道号
    var sensor4TChannelNo: UInt8 = 0
    
    /// 获得温度的方式
    var getWayOfTemperature: SHNineInOneGetWayOfTemperatureType = .average
    
    // MARK: - 数据库信息
    
    /// 主键
    var id: UInt = 0
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 9in1备注
    var nineInOneName: String?
    
    /// 9in1子网ID
    var subnetID: UInt8 = 0
    
    /// 9in1设备ID
    var deviceID: UInt8 = 0
    
    /// 9in1当前区域的第几个
    var nineInOneID: UInt = 0
    
    // 控制面板
    
    /// 控制确定 的 指令号码
    var switchIDforControlSure: UInt = 0
    
    /// 控制向 上 的 指令号码
    var switchIDforControlUp: UInt = 0
    
    /// 控制向下 的 指令号码
    var switchIDforControlDown: UInt = 0
    
    /// 控制向左 的 指令号码
    var switchIDforControlLeft: UInt = 0
    
    /// 控制向右 的 指令号码
    var switchIDforControlRight: UInt = 0
    
    /// 控制键1 的名称
    var switchNameforControl1: String?
    
    /// 控制键1 的 指令号码
    var switchIDforControl1: UInt = 0
    
    /// 控制键2 的名称
    var switchNameforControl2: String?
    
    /// 控制键2 的 指令号码
    var switchIDforControl2: UInt = 0
    
    /// 控制键3 的名称
    var switchNameforControl3: String?
    
    /// 控制键3 的 指令号码
    var switchIDforControl3: UInt = 0
    
    /// 控制键4 的名称
    var switchNameforControl4: String?
    
    /// 控制键4 的 指令号码
    var switchIDforControl4: UInt = 0
    
    /// 控制键5 的名称
    var switchNameforControl5: String?
    
    /// 控制键5 的 指令号码
    var switchIDforControl5: UInt = 0
    
    /// 控制键6 的名称
    var switchNameforControl6: String?
    
    /// 控制键6 的 指令号码
    var switchIDforControl6: UInt = 0
    
    /// 控制键7 的名称
    var switchNameforControl7: String?
    
    /// 控制键7 的 指令号码
    var switchIDforControl7: UInt = 0
    
    /// 控制键8 的名称
    var switchNameforControl8: String?
    
    /// 控制键8 的 指令号码
    var switchIDforControl8: UInt = 0
    
    // 数字面板
    
    /// 键盘数字0 指令号码
    var switchIDforNumber0: UInt = 0
    
    /// 键盘数字1 指令号码
    var switchIDforNumber1: UInt = 0
    
    /// 键盘数字2 指令号码
    var switchIDforNumber2: UInt = 0
    
    /// 键盘数字3 指令号码
    var switchIDforNumber3: UInt = 0
    
    /// 键盘数字4 指令号码
    var switchIDforNumber4: UInt = 0
    
    /// 键盘数字5 指令号码
    var switchIDforNumber5: UInt = 0
    
    /// 键盘数字6 指令号码
    var switchIDforNumber6: UInt = 0
    
    /// 键盘数字7 指令号码
    var switchIDforNumber7: UInt = 0
    
    /// 键盘数字8 指令号码
    var switchIDforNumber8: UInt = 0
    
    /// 键盘数字9 指令号码
    var switchIDforNumber9: UInt = 0
    
    /// 键盘数字 * 指令号码
    var switchIDforNumberAsterisk: UInt = 0
    
    /// 键盘数 # 指令号码
    var switchIDforNumberPound: UInt = 0
    
    // 备用面板
    
    /// 备用键1 的名称
    var switchNameforSpare1: String?
    
    /// 备用键1 的 指令号码
    var switchIDforSpare1: UInt = 0
    
    /// 备用键2 的名称
    var switchNameforSpare2: String?
    
    /// 备用键2 的 指令号码
    var switchIDforSpare2: UInt = 0
    
    /// 备用键3 的名称
    var switchNameforSpare3: String?
    
    /// 备用键3 的 指令号码
    var switchIDforSpare3: UInt = 0
    
    /// 备用键4 的名称
    var switchNameforSpare4: String?
    
    /// 备用键4 的 指令号码
    var switchIDforSpare4: UInt = 0
    
    /// 备用键5 的名称
    var switchNameforSpare5: String?
    
    /// 备用键5 的 指令号码
    var switchIDforSpare5: UInt = 0
    
    /// 备用键6 的名称
    var switchNameforSpare6: String?
    
    /// 备用键6 的 指令号码
    var switchIDforSpare6: UInt = 0
    
    /// 备用键7 的名称
    var switchNameforSpare7: String?
    
    /// 备用键7 的 指令号码
    var switchIDforSpare7: UInt = 0
    
    /// 备用键8 的名称
    var switchNameforSpare8: String?
    
    /// 备用键8 的 指令号码
    var switchIDforSpare8: UInt = 0
    
    /// 备用键9 的名称
    var switchNameforSpare9: String?
    
    /// 备用键9 的 指令号码
    var switchIDforSpare9: UInt = 0
    
    /// 备用键10 的名称
    var switchNameforSpare10: String?
    
    /// 备用键10 的 指令号码
    var switchIDforSpare10: UInt = 0
    
    /// 备用键11 的名称
    var switchNameforSpare11: String?
    
    /// 备用键11 的 指令号码
    var switchIDforSpare11: UInt = 0
    
    /// 备用键12 的名称
    var switchNameforSpare12: String?
    
    /// 备用键12 的 指令号码
    var switchIDforSpare12: UInt = 0
    
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
