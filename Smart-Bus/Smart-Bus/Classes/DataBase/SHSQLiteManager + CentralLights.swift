//
//  SHSQLiteManager + CentralLights.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 中心区域的所有灯泡操作
extension SHSQLiteManager {
    
    /// 获取选择light的指令
    func getCentralLightCommands(_ light: SHCentralLight) -> [SHCentralLightCommand] {
        
        let sql =
            "select id, FloorID, CommandID, Remark, " +
            "SubnetID, DeviceID, CommandTypeID, "     +
            "Parameter1, Parameter2, "                +
            "DelayMillisecondAfterSend from  "        +
            "CentralLightsCommands where "            +
            "FloorID = \(light.floorID) order by id;"
        
        let array = selectProprty(sql)
        
        var lightCommands = [SHCentralLightCommand]()
        
        for dict in array {
            
            lightCommands.append(
                SHCentralLightCommand(dict: dict)
            )
        }
        
        return lightCommands
    }
    
    /// 所有的中心控制的灯
    func getCentralLights() -> [SHCentralLight] {
        
        let sql =
            "select id, FloorID, FloorName " +
            "from CentralLights order by FloorID;"
        
        let array = selectProprty(sql)
        var lights = [SHCentralLight]()
        
        for dict in array {
            
            lights.append(SHCentralLight(dict: dict))
        }
        
        return lights
    }
}
