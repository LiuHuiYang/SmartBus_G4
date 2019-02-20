//
//  SHSQLiteManager + Schedule.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/24.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

/// Schedule 操作
extension SHSQLiteManager {
    
    /// 增加 schedule
    func insertSchedule(_ schedule: SHSchedual) -> Bool {
        
        let maxID = getMaxSchedualID() + 1
        
        let sql =
            "insert into Schedules values (            " +
            "\(maxID), \(schedule.scheduleID),         " +
            "'\(schedule.scheduleName ?? "schedule")', " +
            "\((schedule.enabledSchedule ? 1 : 0)),    " +
            "\(schedule.controlledItemID.rawValue),    " +
            "\(schedule.zoneID),                       " +
            "\(schedule.frequencyID.rawValue),         " +
            "\(schedule.withSunday),                   " +
            "\(schedule.withMonday),                   " +
            "\(schedule.withTuesday),                  " +
            "\(schedule.withWednesday),                " +
            "\(schedule.withThursday),                 " +
            "\(schedule.withFriday),                   " +
            "\(schedule.withSaturday),                 " +
            "\(schedule.executionHours),               " +
            "\(schedule.executionMins),                " +
            "'\(schedule.executionDate ?? "")',        " +
            "\(schedule.haveSound ? 1 : 0)); "
        
        return executeSql(sql)
    }
    
    /// 获得Schedual中的最大的ID
    func getMaxSchedualID() -> UInt {
        
        let sql = "select max(scheduleID) from Schedules;"
        
        guard let dict = selectProprty(sql).last,
        let id = dict["max(scheduleID)"] as? UInt else {
            return 0
        }
        
        return id
    }
    
    /// 更新 schedule
    func updateSchedule(_ schedule: SHSchedual) -> Bool {
        
        let sql =
            "update Schedules set ScheduleName = " +
            "'\(schedule.scheduleName ?? "schedule")', " +
            "EnabledSchedule = " +
            "\(schedule.enabledSchedule), " +
            "ControlledItemID = " +
            "\(schedule.controlledItemID.rawValue), " +
            "ZoneID = \(schedule.zoneID), " +
            "FrequencyID = " +
            "\(schedule.frequencyID.rawValue), " +
            "WithSunday = \(schedule.withSunday), " +
            "WithMonday = \(schedule.withMonday), " +
            "WithTuesday = \(schedule.withTuesday), " +
            "WithWednesday = \(schedule.withWednesday), " +
            "WithThursday = \(schedule.withThursday), " +
            "WithFriday = \(schedule.withFriday), " +
            "WithSaturday = \(schedule.withSaturday), " +
            "ExecutionHours = \(schedule.executionHours), " +
            "ExecutionMins = \(schedule.executionMins), " +
            "ExecutionDate = " +
            "'\(schedule.executionDate ?? "")', " +
            "HaveSound = \(schedule.haveSound) where " +
            "ScheduleID = \(schedule.scheduleID);"
        
        return executeSql(sql)
    }
    
    /// 删除 schedule (包含命令集)
    func deleteScheduale(_ schedule: SHSchedual) -> Bool {
        
        // 删除命令
        let commandSQL =
            "delete from ScheduleCommands where " +
            "ScheduleID = \(schedule.scheduleID);"
        
        if executeSql(commandSQL) == false {
            return false
        }
        
        // 删除计划
        let scheduleSQL =
            "delete from Schedules where " +
            "ScheduleID = \(schedule.scheduleID);"
        
        return executeSql(scheduleSQL)
    }
    
    func getSchedule(_ schedualID: UInt) -> SHSchedual? {
        
        let schedules = getSchedules()
        
        if schedules.isEmpty {
            
            return nil
        }
        
        for schedule in schedules {
            
            if schedule.scheduleID == schedualID {
                
                return schedule
            }
        }
        
        return nil
    }
    
    /// 获得所有的 schedule
    func getSchedules() -> [SHSchedual] {
        
        let sql =
            "select ID, ScheduleID, ScheduleName,    " +
            "EnabledSchedule, ControlledItemID,      " +
            "ZoneID, FrequencyID, WithSunday,        " +
            "WithMonday, WithTuesday, WithWednesday, " +
            "WithThursday, WithFriday, WithSaturday, " +
            "ExecutionHours, ExecutionMins,          " +
            "ExecutionDate, HaveSound from Schedules;"
        
        let array = selectProprty(sql)
        
        var schedules = [SHSchedual]()
        
        for dict in array {
            
            schedules.append(SHSchedual(dictionary: dict))
        }
        
        return schedules
    }
}


// MARK: - Schedule Command 操作
extension SHSQLiteManager {
    
    /// 增加 Schedule Command
    func insertSchedualeCommand(_ command: SHSchedualCommand) -> Bool {
        
        let maxID = getMaxIDForSchedualCommand() + 1
        
        let sql =
            "insert into ScheduleCommands values(          " +
            "\(maxID), \(command.scheduleID),              " +
            "\(command.typeID), \(command.parameter1),     " +
            "\(command.parameter2), \(command.parameter3), " +
            "\(command.parameter4), \(command.parameter5), " +
            "\(command.parameter6));"
        
        return executeSql(sql)
    }
    
    /// 删除 指定类型的 SHSchedualCommand
    func deleteSchedualeCommand(_ scheduleID: UInt, controlType: SHSchdualControlItemType) -> Bool {
        
        let sql =
            "delete from ScheduleCommands where " +
            "ScheduleID = \(scheduleID) and     " +
            "typeID = \(controlType.rawValue);"
        
        return executeSql(sql)
    }
    
    /// 删除 Schedule 中的 所有command == 这个方法将要删除
    func deleteSchedualeCommands(_ schedule: SHSchedual) -> Bool {
        
        let sql =
            "delete from ScheduleCommands where   " +
            "ScheduleID = \(schedule.scheduleID); "
        
        return executeSql(sql)
    }
    
    /// 获得ScheduleCommands中的最大ID
    func getMaxIDForSchedualCommand() -> UInt {
        
        let sql = "select max(ID) from ScheduleCommands;"
        
        guard let dict = selectProprty(sql).last,
        let id = dict["max(ID)"] as? UInt else {
            return 0
        }
        
        return id
    }
    
    /// 查询指定计划的 命令集合
    func getSchedualCommands(_ schedualID: UInt) -> [SHSchedualCommand] {
        
        let sql =
            "select ID, ScheduleID, typeID, " +
            "parameter1, parameter2, parameter3, " +
            "parameter4, parameter5, parameter6  " +
            "from ScheduleCommands where " +
            "ScheduleID = \(schedualID);"
        
        let array = selectProprty(sql)
        
        var commands = [SHSchedualCommand]()
        
        for dict in array {
            
            commands.append(SHSchedualCommand(dict: dict))
        }
        
        return commands
    }
}
