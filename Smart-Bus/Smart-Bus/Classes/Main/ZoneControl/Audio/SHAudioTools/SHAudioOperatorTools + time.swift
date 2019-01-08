//
//  SHAudioOperatorTools + time.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/19.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 时间处理
extension SHAudioOperatorTools {
    
    
    /// 将秒数转换成时间字符串
    ///
    /// - Parameter seconds: 秒数
    /// - Returns: 格式化字符串
    static func showTime(seconds: UInt) -> String {
        
        // 音乐没有小时，所以这里先删除掉
        
//        let hour = seconds / 3600
        let min = (seconds % 3600) / 60
        let sec = seconds % 60
        
//        let time =
//            String(format: "%02d:%02d:%02d",
//                   hour, min, sec
//        )
        
        let time =
            String(format: "%02d:%02d",
                min, sec
        )
        
        return time
    }
}
