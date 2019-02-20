//
//  SHAudioOperatorTools + path.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/19.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 路径
extension SHAudioOperatorTools {
    
    /// 清除本地缓存的音乐数据
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - sourceType: 音乐来源
    static func deletePlist(
        subNetID: UInt8,
        deviceID: UInt8,
        sourceType: UInt8) {
        
        let filePath =
            FileTools.documentPath() + "/" +
            "\(subNetID)_\(deviceID)_\(sourceType)"
        
        guard let enumerator =
            FileManager.default.enumerator(
                atPath: filePath
            )?.allObjects as? [String] else {
                
            return
        }
        
        for fileName in enumerator {
            
            let path = filePath + "/" + fileName
            
            try? FileManager.default.removeItem(
                atPath: path
            )
        }
    }
    
    /// 获得音乐相关的 目录 或者 文件 路径
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - sourceType: 音乐来源类型
    ///   - fileType: 音乐文件分类类型
    ///   - serialNumber: 序号: 只有 fileType 为普通歌曲时才有效。
    /// - Returns: 路径, nil 表示路径不存在
    static func getAudioPath(
        subNetID: UInt8,
        deviceID: UInt8,
        sourceType: UInt8,
        fileType: SHAudioSourceFileType,
        serialNumber: UInt) -> String {
        
        // 获根目录的路径(格式: Document/SubNetID_DeviceID_SourceType)
        
        let rootPath = FileTools.documentPath() + "/" +
            "\(subNetID)_\(deviceID)_\(sourceType)"
        
        switch fileType {
        case .directory:
            return rootPath
            
        case .album:
            return rootPath + "/" + "AlbumList.plist"
            
        case .songs:
            return rootPath + "/" +
                "SongList_\(serialNumber).plist"
        
        case .queueSongs:
            return rootPath + "/" + "QueueList.plist"
        }
        
    }

}
