//
//  SHSocketData.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017 SmartHome. All rights reserved.
//

import Foundation

@objcMembers class SHSocketData : NSObject {
    
    // MARK: - 属性
    
    /// 操作码
    var operatorCode: UInt16 = 0
    
    /// 子网ID
    var subNetID: UInt8 = 0
    
    /// 设备ID
    var deviceID: UInt8 = 0
    
    /// 设备类型  (发送数据的时候忽略这个参数)
    var deviceType: UInt16 = 0
    
    /// 额外数据
    var additionalData = [UInt8]()
    
    /// 是否DMX设备
    var isDMX: Bool = false
    
    /// 发送的远程设备RSIP对象
    var remoteDevice: SHDeviceList = SHDeviceList()
    
    /// 发送次数
    var reSendCount: UInt8 = 0
    
    /// 打印信息
    override var description: String {
        
        var additional = ""
        for index in 0 ..< additionalData.count {
            
            additional +=
                String(format: "%#02X", additionalData[index])
            
            additional +=
                (
                    (index == (additionalData.count - 1)) ? "" : ", "
            )
        }
        
        return String(format: "%#04X : %d - %d [\(additional)]",
            operatorCode, subNetID, deviceID)
    }
    
    // MARK: - 构造方法
    
    
    /// 构造数据包对象
    ///
    /// - Parameters:
    ///   - operatorCode: 操作码
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - additionalData: 附加参数
    ///   - deviceType: 设备参数
    ///   - remoteDevice: 远程设备标示
    ///   - isDMX: 是否为DMX设备
    init(operatorCode: UInt16,
         subNetID: UInt8,
         deviceID: UInt8,
         additionalData: [UInt8] = [],
         deviceType: UInt16 = 0,
         remoteDevice: SHDeviceList = SHDeviceList(),
         isDMX: Bool = false,
         reSendCount: UInt8 = 0) {
        
        super.init()
        self.operatorCode = operatorCode
        self.subNetID = subNetID
        self.deviceID = deviceID
        self.additionalData = additionalData
        self.deviceType = deviceType
        self.remoteDevice = remoteDevice
        self.isDMX = isDMX
        self.reSendCount = reSendCount
    }
    
    // MARK: - 相等的方法重载
    //    static func == (_ left: SHSocketData, _ right: SHSocketData) -> Bool {
    //
    //        if left.subNetID == right.subNetID &&
    //            left.deviceID == right.deviceID {
    //            print("找到了")
    //            return true
    //        }
    //
    //        return false
    //    }
}
