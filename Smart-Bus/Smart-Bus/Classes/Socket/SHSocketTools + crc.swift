//
//  SHSocketTools + crc.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017 SmartHome. All rights reserved.
//

import Foundation

// MARK: - 生成crc代码
extension SHSocketTools {
  
    /// 检查CRC
    ///
    /// - Parameters:
    ///   - position: 0xAAAA后的的位置(SN2的地址)
    ///   - length: 长度是固定部分 11 - 2 + additionalContentLength)
    /// - Returns: 数据包是否合法
    func check_crc(
        position: UnsafeMutablePointer<UInt8>?,
        length: Int) -> Bool {
        
        guard let ptr = position else {
            return false
        }
        
        if ptr[0] == 0xFF { // 大数据包直接不校验
            return true
        }
        
        // 1.先根据参数生成对应的crc
        var crc: UInt16 = 0 // 两个字节 用于存储CRC
        var dat: UInt8 = 0  // 临时变量
        
        var len = length
        
        var index = 0    // 开始计算 ptr对应数组的起如位置
     
        while len != 0 {
            
            len -= 1
            
            dat = UInt8(crc >> 8)
            
            crc = crc << 8
            
            let count = Int(dat ^ ptr[index])
            
            crc ^= CRC_TAB[count]
            
            index += 1
        }
        // 2.比较生成的crc与接收的crc是否相同
        
        return (
            ptr[index]     == UInt8(crc >> 8) &&
            ptr[index + 1] == UInt8(crc & 0xFF)
        )
    }
 
    /// 生成CRC
    ///
    /// - Parameters:
    ///   - position: 0xAAAA后的的位置(SN2的地址)
    ///   - length: 长度是固定部分 11 - 2 + additionalContentLength)
    func pack_crc(
        position: UnsafeMutablePointer<UInt8>?,
        length: Int) {
        
        guard let ptr = position else {
            return
        }
        
        var crc: UInt16 = 0 // 两个字节 用于存储CRC
        var dat: UInt8 = 0  // 临时变量
        
        var len = length
        
        var index = 0    // 开始计算 ptr对应数组的起如位置
        
        while len != 0 {
            
            len -= 1
            
            dat = UInt8(crc >> 8)
            
            crc = crc << 8
            
            let count = Int(dat ^ ptr[index])
            
            crc ^= CRC_TAB[count]
            
            index += 1
        }
        
        ptr[index] = UInt8(crc >> 8)
        ptr[index + 1] = UInt8((crc & 0xFF))
    }
}
