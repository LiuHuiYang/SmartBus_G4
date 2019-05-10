//
//  SHAudioOperatorTools + asc.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/19.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import Foundation


extension SHAudioOperatorTools {
    
}

// MARK: - ASCII码的转换
extension SHAudioOperatorTools {
    
    /// 十进制整数转换成ASCII码
    ///
    /// - Parameter data: 十进制整数
    /// - Returns: ASCII码
    static func decimalToAscii(data: UInt8) -> UInt8 {
        
        if data >= 0 && data <= 9 {
            return data + 48
        }
        
        return 0
    }
    
    
    /// ASCII码转换为数字
    ///
    /// - Parameter data: ASCII码
    /// - Returns: 十进制整数
    static func asciiToDecimal(data: UInt8) -> UInt8 {
        
        if data >= 48 && data <= 57 {
            return data - 48
        }
        
        return 0
    }
    
}
