//
//  SHSocketTools + cache.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017 SmartHome. All rights reserved.

import Foundation

// MARK: - 缓存问题
extension SHSocketTools {
    
    /// 数据包是否存在
    ///
    /// - Parameters:
    ///   - socketData: 数据包
    ///   - isReceived: 是否为接收到的数据包
    /// - Returns: true - 数据存在, false 数据不存在
    static func isSocketDataExist(
        socketData: SHSocketData,
        isReceived: Bool = false) -> Bool {
        
        let cacheKey =
            SHSocketTools.cacheKeyforSocketData(
                socketData: socketData,
                isReceived: isReceived
        )
        
        guard let _ =
            SHSocketTools.caches.object(forKey: cacheKey)
                as? SHSocketData
            else {
                
                return false
        }
        
        return true
    }
    
    static func removeSocketData(
        socketData: SHSocketData,
        isReceived: Bool = false
        ) {
        
        let cacheKey =
            SHSocketTools.cacheKeyforSocketData(
                socketData: socketData,
                isReceived: isReceived
        )
        
        SHSocketTools.caches.removeObject(
            forKey: cacheKey
        )
    }
    
    
    /// 向缓存中添加数据包
    ///
    /// - Parameters:
    ///   - socketData: 数据包
    ///   - isReceived: 是否为接收到的数据包
    static func addSocketData(
        socketData: SHSocketData,
        isReceived: Bool = false
        ) {
        
        let cacheKey =
            SHSocketTools.cacheKeyforSocketData(
                socketData: socketData,
                isReceived: isReceived
        )
        
        SHSocketTools.caches.setObject(
            socketData,
            forKey: cacheKey
        )
    }
    
    
    /// 获得socket数据在线程中的key
    ///
    /// - Parameters:
    ///   - socketData: 数据包
    ///   - isReceived: 是否为接收到的数据包
    /// - Returns: 缓存池中的key
    private static func cacheKeyforSocketData(
        socketData: SHSocketData,
        isReceived: Bool = false) -> AnyObject {
        
        let cacheKey =
            String(format: "%#04X : %d - %d",
                   (isReceived ? socketData.operatorCode - 1 : socketData.operatorCode),
                   socketData.subNetID,
                   socketData.deviceID
        ) as AnyObject
        
        return cacheKey
    }
}


