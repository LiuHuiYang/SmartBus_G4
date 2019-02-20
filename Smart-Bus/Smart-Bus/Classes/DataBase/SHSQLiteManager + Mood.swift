//
//  SHSQLiteManager + Mood.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/23.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation




// MARK: - Mood Command 操作
extension SHSQLiteManager {
    
    /// 增加 moodCommand
    func insertMoodCommand(_ command: SHMoodCommand) -> Bool {
        
        let sql =
            "insert into MoodCommands values (         " +
            "\(command.id), \(command.zoneID),         " +
            "\(command.moodID), \(command.deviceType), " +
            "\(command.subnetID), \(command.deviceID), " +
            "'\(command.deviceName ?? "command" )',    " +
            "\(command.parameter1),                    " +
            "\(command.parameter2),                    " +
            "\(command.parameter3),                    " +
            "\(command.parameter4),                    " +
            "\(command.parameter5),                    " +
            "\(command.parameter6),                    " +
            "\(command.delayMillisecondAfterSend));"
        
        return executeSql(sql)
    }
    
    /// 更新 mood Command
    func updateMoodCommand(_ command: SHMoodCommand) -> Bool {
        
        let sql =
            "update MoodCommands set               " +
            "deviceName =                          " +
            "'\(command.deviceName ?? "command")', " +
            "deviceType = \(command.deviceType),   " +
            "SubnetID = \(command.subnetID),       " +
            "DeviceID = \(command.deviceID),       " +
            "Parameter1 = \(command.parameter1),   " +
            "Parameter2 = \(command.parameter2),   " +
            "Parameter3 = \(command.parameter3),   " +
            "Parameter4 = \(command.parameter4),   " +
            "Parameter5 = \(command.parameter5),   " +
            "Parameter6 = \(command.parameter6)    " +
            "Where zoneID = \(command.zoneID) and  " +
            "MoodID = \(command.moodID) and        " +
            "ID = \(command.id);"
        
        return executeSql(sql)
    }
    
    /// 获取模式命令 最大的 ID
    func getMaxIDForMoodCommand() -> UInt {
        
        let sql = "select max(ID) from MoodCommands;"
        
        guard let dict = selectProprty(sql).last,
        let id = dict["max(ID)"] as? UInt else {
            return 0
        }
        
        return id
    }
    
    /// 删除场景命令
    func deleteMoodCommand(_ command: SHMoodCommand) -> Bool {
        
        let sql =
            "delete from MoodCommands where " +
            "ZoneID = \(command.zoneID) and " +
            "MoodID = \(command.moodID) and " +
            "ID = \(command.id);"
        
        return executeSql(sql)
    }
    
    /// 查询 mood 中的命令
    func getMoodCommands(_ mood: SHMood) -> [SHMoodCommand] {
        
        let sql =
            "select ID, ZoneID, MoodID, deviceType, " +
            "SubnetID, DeviceID, deviceName,        " +
            "Parameter1, Parameter2, Parameter3,    " +
            "Parameter4, Parameter5, Parameter6,    " +
            "DelayMillisecondAfterSend from         " +
            "MoodCommands where                     " +
            "ZoneID = \(mood.zoneID) and            " +
            "MoodID = \(mood.moodID) order by id;"
        
        let array = selectProprty(sql)
        var commands = [SHMoodCommand]()
        
        for dict in array {
            
            commands.append(SHMoodCommand(dict: dict))
        }
        
        return commands
    }
}

/// Mood 操作
extension SHSQLiteManager {
    
    /// 增加 mood
    func insertMood(_ mood: SHMood) -> Bool {
        
        let sql =
            "insert into MoodInZone values(             " +
            "\(getMaxIDForMood() + 1),                  " +
            "\(mood.zoneID), \(mood.moodID),            " +
            "'\(mood.moodName ?? "new mood")',          " +
            "'\(mood.moodIconName ?? "mood_romantic")', " +
            "\(mood.isSystemMood));"
        
        return executeSql(sql)
    }
    
    /// 获得 区域中 最大 MoodID
    func getMaxMoodID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(MoodID) from MoodInZone " +
            "where zoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
        let moodID = dict["max(MoodID)"] as? UInt else {
            
            return 0
        }
        
        return moodID
    }
    
    /// 表中的最大 MoodID
    func getMaxIDForMood() -> UInt {
        
        let sql = "select max(ID) from MoodInZone;"
        
        guard let dict = selectProprty(sql).last,
        let moodID = dict["max(ID)"] as? UInt else {
            
            return 0
        }
        
        return moodID
    }
    
    /// 更新 mood
    func updateMood(_ mood: SHMood) -> Bool {
        
        let sql =
            "update MoodInZone set "                     +
            "MoodName = "                                +
            "'\(mood.moodName ?? "new Mood")', "         +
            "MoodIconName = "                            +
            "'\(mood.moodIconName ?? "mood_romantic")' " +
            "Where zoneID = \(mood.zoneID) and "         +
            "MoodID = \(mood.moodID);"
        
        return executeSql(sql)
    }
    
    /// 删除 mood
    func deleteMood(_ mood: SHMood) -> Bool {
        
        /// 删除命令
        let commandSQL =
            "delete from MoodCommands where " +
            "ZoneID = \(mood.zoneID)    and " +
            "MoodID = \(mood.moodID);"
        
        if executeSql(commandSQL) == false {
            
            return false
        }
        
        // 删除场景
        let moodSQL =
            "delete from MoodInZone where " +
            "ZoneID = \(mood.zoneID)  and " +
            "MoodID = \(mood.moodID);"
        
        return executeSql(moodSQL)
    }
    
    /// 删除区域中的 mood
    func deleteMoods(_ zoneID: UInt) -> Bool {
       
        // 删除命令
        let commandSQL =
            "delete from MoodCommands where " +
            "ZoneID = \(zoneID);"
        
        if executeSql(commandSQL) == false {
            
            return false
        }
        
        // 删除场景
        let moodSQL =
            "delete from MoodInZone where " +
            "ZoneID = \(zoneID);"
        
        return executeSql(moodSQL)
    }
    
    /// 查询区域中的场景
    func getMoods(_ zoneID: UInt) -> [SHMood] {
        
        let sql =
            "select ZoneID, MoodID, MoodName, "    +
            "MoodIconName, IsSystemMood from  "    +
            "MoodInZone where ZoneID = \(zoneID) " +
            "order by MoodID;"
        
        let array = selectProprty(sql)
        
        var moods = [SHMood]()
        
        for dict in array {
            
            moods.append(SHMood(dict: dict))
        }
        
        return moods
    }
}

// MARK: - 增加字段
extension SHSQLiteManager {
    
    /// 增加场景命令延时操作
    func addMoodCommandDelaytime() -> Bool {
        
        if isColumnName(
            "DelayMillisecondAfterSend",
            consistinTable: "MoodCommands") == false {
            
            return executeSql(
                "ALTER TABLE MoodCommands ADD DelayMillisecondAfterSend INTEGER NOT NULL DEFAULT 100;"
            )
        }
        
        return true
    }
}
