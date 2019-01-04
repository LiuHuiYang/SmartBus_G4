//
//  SHAudioOperatorTools + queueSongs.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/19.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import Foundation

// FIXME: - 如果音乐播放所有的控制器改由Swift实现，则这里的NSMutableArray类型全部修改为Swift对应类型

// MARK: - 队列音乐操作
extension SHAudioOperatorTools {
    
    
    /// 获得当前的队列音乐
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - sourceType: 音源
    /// - Returns: 歌曲数组
    static func getQueueSongs(
        subNetID: UInt8,
        deviceID: UInt8,
        sourceType: UInt8) -> NSMutableArray {
        
//        var queuSongs = [SHSong]()
        let queuSongs = NSMutableArray()
        
        let filePath =
            SHAudioOperatorTools.getAudioPath(
                subNetID: subNetID,
                deviceID: deviceID,
                sourceType: sourceType,
                fileType: .queueSongs,
                serialNumber: 0
        )
        
        guard let songArray =
            NSArray(contentsOfFile: filePath) as? [String] else {
            
            return queuSongs
        }

        for name in songArray {
        
            let queueSong =
                name.components(separatedBy: "_")
            
            let song = SHSong()
            
            song.subNetID    = UInt8(queueSong[0]) ?? 0
            song.deviceID    = UInt8(queueSong[1]) ?? 0
            song.sourceType  = UInt8(queueSong[2]) ?? 0
            song.albumNumber = UInt8(queueSong[3]) ?? 0
            song.songNumber  = UInt(queueSong[4])  ?? 0
        
            song.songName = queueSong.last ?? ""
            
            if !song.songName.isEmpty {
                
//                queuSongs.append(song)
                queuSongs.add(song)
            }
        }
        
        return queuSongs
    }
    
    
    /// 保存队列中的歌曲
    ///
    /// - Parameter songs: 歌曲集合
    static func saveQueueSongs(
        songs: [SHSong],
        subNetID: UInt8,
        deviceID: UInt8,
        sourceType: UInt8) {
        
        let queueSongs =
            NSMutableArray(capacity: songs.count)
        
        for song in songs {
            
            let name =
                "\(song.subNetID)_\(song.deviceID)_" +
                "\(song.sourceType)_\(song.albumNumber)_" +
                "\(song.songNumber)_\(song.songName)"
        
            queueSongs.add(name)
        }
        
        let filePath =
            SHAudioOperatorTools.getAudioPath(
                subNetID: subNetID,
                deviceID: deviceID,
                sourceType: sourceType,
                fileType: .queueSongs,
                serialNumber: 0
        )
        
        // 删除路径直接重新写入
        try? FileManager.default.removeItem(
            atPath: filePath
        )
        
        queueSongs.write(toFile: filePath,
                         atomically: true
        )
    }
}
