//
//  SHSQLiteManager + CentralClimate.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 中心空调控制
extension SHSQLiteManager {
    
    /// 所有的中心控制的空调
    func getCentralClimates() -> [SHCentralHVAC] {
        
        let sql =
            "select id, FloorID, FloorName, isHaveHot " +
            "from CentralHVAC order by FloorID;"
        
        let array = selectProprty(sql)
        var climates = [SHCentralHVAC]()
        
        for dict in array {
            
            climates.append(SHCentralHVAC(dict: dict))
        }
        
        return climates
    }
    
    /// 中心空调的指令集
    func getCentralClimateCommands(_ climate: SHCentralHVAC) -> [SHCentralHVACCommand] {
        
        let sql =
            "select id, FloorID, CommandID, Remark, " +
            "SubnetID, DeviceID, CommandTypeID, "     +
            "Parameter1, Parameter2, "                +
            "DelayMillisecondAfterSend from "         +
            "CentralHVACCommands where "              +
            "FloorID = \(climate.floorID) order by id;"
        
        let array = selectProprty(sql)
        var commands = [SHCentralHVACCommand]()
        
        for dict in array {
            
            commands.append(SHCentralHVACCommand(dict: dict))
        }
        
        return commands
    }
}
