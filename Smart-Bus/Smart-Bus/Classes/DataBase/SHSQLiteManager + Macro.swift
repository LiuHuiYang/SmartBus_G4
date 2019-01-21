//
//  SHSQLiteManager + Macro.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 宏操作
extension SHSQLiteManager {
    
    // MARK: ==========  Macro Command 操作 =========
    
    /// 增加 macroCommand
    func insertMacroCommand(_ command: SHMacroCommand) -> UInt {
        
        let sql =
            "insert into MacroButtonCommands "          +
            "(MacroID, Remark, SubnetID, DeviceID, "    +
            "CommandTypeID, FirstParameter, "           +
            "SecondParameter, ThirdParameter,"          +
            "DelayMillisecondAfterSend) values "        +
            "(\(command.macroID), "                     +
            "'\(command.remark ?? "Macro Command" )', " +
            "\(command.subnetID), \(command.deviceID)," +
            "\(command.commandTypeID), "                +
            "\(command.firstParameter), "               +
            "\(command.secondParameter), "              +
            "\(command.thirdParameter),  "              +
            "\(command.delayMillisecondAfterSend));"
        
        if executeSql(sql) == false {
            
            return 0
        }
        
        let idSQL =
            "select max(ID) from MacroButtonCommands;"
        
        guard let dict = selectProprty(idSQL).last,
            let resID = dict["max(ID)"] as? String,
            let maxID = UInt(resID) else {
            
            return 0
        }
        
        return maxID
    }
    
    /// 更新 macroCommand
    func updateMacroCommand(_ command: SHMacroCommand) -> Bool {
        
        let sql =
            "update MacroButtonCommands "                  +
            "set Remark = '\(command.remark ?? "Macro Command")', "                              +
            "SubnetID = \(command.subnetID), "             +
            "DeviceID = \(command.deviceID), "             +
            "CommandTypeID = \(command.commandTypeID), "   +
            "FirstParameter = \(command.firstParameter), " +
            "SecondParameter = \(command.secondParameter), "
                                                           +
            "ThirdParameter = \(command.thirdParameter), " +
            "DelayMillisecondAfterSend =                "  +
                "\(command.delayMillisecondAfterSend) "    +
            "where MacroID = \(command.macroID) "          +
            "and ID = \(command.id);"
        
        return executeSql(sql)
    }
    
    /// 删除指定的macroCommand
    func deleteMacroCommand(_ command: SHMacroCommand) -> Bool {
        
        let sql =
            "delete from MacroButtonCommands where " +
            "MacroID = \(command.macroID) and "      +
            "ID = \(command.id);"
        
        return executeSql(sql)
    }
    
    /// 获得macro下的指令集
    func getMacroCommands(_ macro: SHMacro) -> [SHMacroCommand] {
        
        let sql =
            "select ID, MacroID, Remark, SubnetID, "    +
            "DeviceID, CommandTypeID, FirstParameter, " +
            "SecondParameter, ThirdParameter,   "       +
            "DelayMillisecondAfterSend from           " +
            "MacroButtonCommands where "                +
            "MacroID = \(macro.macroID) order by id;"
        
        let array = selectProprty(sql)
        
        var commands = [SHMacroCommand]()
        
        for dict in array {
            
            commands.append(SHMacroCommand(dict: dict))
        }
        
        return commands
    }
    
    
    // MARK: ==========  Macro 操作  ========
    
    /// 更新 macro
    func updateMacro(_ macro: SHMacro) -> Bool {
        
        let sql =
            "update MacroButtons set " +
            "MacroName = '\(macro.macroName ?? "Macro" )',  " +
            "MacroIconName = '\(macro.macroIconName ?? "Macro")' " +
            "where MacroID = \(macro.macroID);"
        
        return executeSql(sql)
    }
    
    /// 删除 Macro
    func deleteMacro(_ macro: SHMacro) -> Bool {
        
        let commndSQL =
            "delete from MacroButtonCommands " +
            "where MacroID = \(macro.macroID);"
        
        if executeSql(commndSQL) == false {
            
            return false
        }
        
        let sql =
            "delete from MacroButtons " +
            "where MacroID = \(macro.macroID);"
        
        return executeSql(sql)
    }
    
    /// 增加Macro
    func insertMacro(_ macro: SHMacro) -> Bool {
        
        let sql =
            "insert into MacroButtons " +
            "(MacroID, MacroName, MacroIconName) " +
            "values(\(macro.macroID), " +
            "'\(macro.macroName ?? "Macro" )', '  " +
            "\(macro.macroIconName ?? "Macro" )');"
        
        return executeSql(sql)
    }
 
    /// 获得最大的 宏ID
    func getMaxMacroID() -> UInt {
        
        let sql = "select max(MacroID) from MacroButtons"
         
        guard let dict = selectProprty(sql).last,
            let macroID = dict["max(MacroID)"] as? UInt else {
                
            return 0
        }
        
        return macroID
    }
    
    /// 获取所有的宏命令按钮
    func getMacros() -> [SHMacro] {
        
        let sql =
            "select id, MacroID, MacroName, MacroIconName " +
            "from MacroButtons order by MacroID;"
        
        let array = selectProprty(sql)
        
        var macros = [SHMacro]()
        
        for dict in array {
            
            macros.append(SHMacro(dict: dict))
        }
        
        return macros
    }
}
