//
//  SHSocketData.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017 SmartHome. All rights reserved.
//

import Foundation

// FIXME: - 这里为了兼容OC调用，暂时定义为Class 后续代码修改完成后，恢复为struct
/*struct*/ @objcMembers class SHSocketData : NSObject {
    
    var operatorCode: UInt16 = 0
    var subNetID: UInt8 = 0
    var deviceID: UInt8 = 0
    var deviceType: UInt16 = 0 // 在发送数据的时候忽略这个参数
    var additionalData = [UInt8]()
    
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
    
    /// 构造
    init(operatorCode: UInt16,
         subNetID: UInt8,
         deviceID: UInt8,
         additionalData: [UInt8],
         deviceType: UInt16 = 0) {
        
        self.operatorCode = operatorCode
        self.subNetID = subNetID
        self.deviceID = deviceID
        self.additionalData = additionalData
        self.deviceType = deviceType
    }

}
