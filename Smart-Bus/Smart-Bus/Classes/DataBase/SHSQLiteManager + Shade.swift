//
//  SHSQLiteManager +Shade.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 窗帘操作
extension SHSQLiteManager {
    
    /// 增加 shade
    func insertShade(_ shade: SHShade) -> Bool {
        
        let sql =
            "insert into ShadeInZone (ZoneID, ShadeID, " +
            "ShadeName, HasStop, SubnetID, DeviceID,   " +
            "openChannel, openingRatio, closeChannel,  " +
            "closingRatio, Reserved1, Reserved2,       " +
            "remarkForOpen, remarkForClose,            " +
            "remarkForStop, controlType,               " +
            "switchIDforOpen, switchIDStatusforOpen,   " +
            "switchIDforClose, switchIDStatusforClose, " +
            "switchIDforStop, switchIDStatusforStop,   " +
            "stopChannel, stoppingRatio) values(       " +
            "\(shade.zoneID), \(shade.shadeID),        " +
            "'\(shade.shadeName)', \(shade.hasStop),   " +
            "\(shade.subnetID), \(shade.deviceID),     " +
            "\(shade.openChannel),                     " +
            "\(shade.openingRatio),                    " +
            "\(shade.closeChannel),                    " +
            "\(shade.closingRatio),                    " +
            "\(shade.reserved1), \(shade.reserved2),   " +
            "'\(shade.remarkForOpen)',                 " +
            "'\(shade.remarkForClose)',                " +
            "'\(shade.remarkForStop)',                 " +
            "\(shade.controlType.rawValue),            " +
            "\(shade.switchIDforOpen),                 " +
            "\(shade.switchIDStatusforOpen),           " +
            "\(shade.switchIDforClose),                " +
            "\(shade.switchIDStatusforClose),          " +
            "\(shade.switchIDforStop),                 " +
            "\(shade.switchIDStatusforStop),           " +
            "\(shade.stopChannel), \(shade.stoppingRatio));"
        
        
        return executeSql(sql)
    }
    
    /// 获得当前区域的最大shadeID
    func getMaxShadeID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(ShadeID) from ShadeInZone " +
            "where ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
        let shadeID = dict["max(ShadeID)"] as? UInt else {
        
            return 0
        }
        
        return shadeID
    }
    
    /// 更新 shade
    func updateShade(_ shade: SHShade) -> Bool {
        
        let sql =
            "update ShadeInZone set "                      +
            "SubnetID = \(shade.subnetID), "               +
            "DeviceID = \(shade.deviceID), "               +
            "ShadeName = '\(shade.shadeName)', "           +
            "HasStop = \(shade.hasStop),   "               +
            "openChannel = \(shade.openChannel), "         +
            "openingRatio = \(shade.openingRatio), "       +
            "closeChannel = \(shade.closeChannel), "       +
            "closingRatio = \(shade.closingRatio), "       +
            "Reserved1 = \(shade.reserved1), "             +
            "Reserved2 = \(shade.reserved2) , "            +
            "remarkForOpen = '\(shade.remarkForOpen)', "   +
            "remarkForClose = '\(shade.remarkForClose)', " +
            "remarkForStop = '\(shade.remarkForStop)', "   +
            "controlType = "                               +
                "\(shade.controlType.rawValue), "          +
            "switchIDforOpen = \(shade.switchIDforOpen), " +
            "switchIDStatusforOpen = "                     +
                "\(shade.switchIDStatusforOpen), "         +
            "switchIDforClose = \(shade.switchIDforClose), "
                                                           +
            "switchIDStatusforClose = "                    +
                "\(shade.switchIDStatusforClose), "        +
            "switchIDforStop = \(shade.switchIDforStop),"  +
            "switchIDStatusforStop = "                     +
                "\(shade.switchIDStatusforStop), "         +
            "stopChannel = \(shade.stopChannel), "         +
            "stoppingRatio = \(shade.stoppingRatio) "      +
            "Where zoneID = \(shade.zoneID) and "          +
            "ShadeID = \(shade.shadeID) ; "
        
        return executeSql(sql)
    }
    
    /// 删除区域中的所有窗帘
    func deleteShades(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from ShadeInZone Where " +
            "zoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 删除指定的窗帘
    func deleteShade(_ shade: SHShade) -> Bool {
        
        let sql =
            "delete from ShadeInZone    Where " +
            "zoneID   = \(shade.zoneID)   and " +
            "ShadeID  = \(shade.shadeID)  and " +
            "SubnetID = \(shade.subnetID) and " +
            "DeviceID = \(shade.deviceID);"
        
        return executeSql(sql)
    }
    
    /// 获得指定的窗帘
    func getShade(_ zoneID: UInt, shadeID: UInt) -> SHShade? {
        
        let sql =
            "select id, ZoneID, ShadeID, ShadeName, "    +
            "HasStop, SubnetID, DeviceID, openChannel, " +
            "openingRatio, closeChannel, closingRatio, " +
            "Reserved1, Reserved2, remarkForOpen,      " +
            "remarkForClose, remarkForStop,            " +
            "controlType, switchIDforOpen, "             +
            "switchIDStatusforOpen, switchIDforClose,  " +
            "switchIDStatusforClose, switchIDforStop,  " +
            "switchIDStatusforStop, stopChannel,       " +
            "stoppingRatio from ShadeInZone where      " +
            "ZoneID = \(zoneID) and ShadeID = \(shadeID);"
        
        guard let dict = selectProprty(sql).last else {
            
            return nil
        }
        
        return SHShade(dict: dict)
    }
    
    /// 查询当前区域的所有窗帘
    func getShades(_ zoneID: UInt) -> [SHShade] {
        
        let sql =
            "select id, ZoneID, ShadeID, ShadeName, " +
            "HasStop, SubnetID, DeviceID, openChannel, " +
            "openingRatio, closeChannel, closingRatio, " +
            "Reserved1, Reserved2, remarkForOpen,      " +
            "remarkForClose, remarkForStop, "            +
            "controlType, switchIDforOpen,             " +
            "switchIDStatusforOpen, switchIDforClose,  " +
            "switchIDStatusforClose, switchIDforStop,  " +
            "switchIDStatusforStop, stopChannel,       " +
            "stoppingRatio from ShadeInZone where      " +
            "ZoneID = \(zoneID) order by ShadeID;"
        
        let array = selectProprty(sql)
        var shades = [SHShade]()
        
        for dict in array {
            
            shades.append(SHShade(dict: dict))
        }
        
        return shades
    }
    
    /// 增加窗帘字段
    func addShadeParameter() {
        
        // 增加控制方式
        if isColumnName(
            "controlType",
            consistinTable: "ShadeInZone") == false {
            
            _ = executeSql(
                "ALTER TABLE ShadeInZone ADD controlType INTEGER NOT NULL DEFAULT 0;"
            )
        }
        
        // 增加停止通道(三个继电器控制窗帘的)
        if isColumnName(
            "stopChannel",
            consistinTable: "ShadeInZone"
            ) == false {
            
            _ = executeSql(
                "ALTER TABLE ShadeInZone ADD stopChannel INTEGER NOT NULL DEFAULT 0;"
            )
            
            // 停止比例
            _ = executeSql(
                "ALTER TABLE ShadeInZone ADD stoppingRatio INTEGER NOT NULL DEFAULT 0;"
            )
        }
        
        // 增加三个文字标注
        if isColumnName(
            "remarkForOpen",
            consistinTable: "ShadeInZone"
            ) == false {
            
            _ = executeSql(
                "ALTER TABLE ShadeInZone ADD remarkForOpen TEXT NOT NULL DEFAULT '';"
            )
            
            _ = executeSql(
                "ALTER TABLE ShadeInZone ADD remarkForClose TEXT NOT NULL DEFAULT '';"
            )
            
            _ = executeSql(
                "ALTER TABLE ShadeInZone ADD remarkForStop TEXT NOT NULL DEFAULT '';"
            )
        }
        
        // 增加红外开关状态
        
        if isColumnName(
            "switchIDforOpen",
            consistinTable: "ShadeInZone"
            ) == false {
            
            // 开
            _ = executeSql(
                "ALTER TABLE ShadeInZone ADD switchIDforOpen INTEGER NOT NULL DEFAULT 0;"
            )
            
            // 开状态
            _ = executeSql(
                "ALTER TABLE ShadeInZone ADD switchIDStatusforOpen INTEGER NOT NULL DEFAULT 0;"
            )
            
            // 关
            _ = executeSql(
                "ALTER TABLE ShadeInZone ADD switchIDforClose INTEGER NOT NULL DEFAULT 0;"
            )
            
            // 关状态
            _ = executeSql(
                "ALTER TABLE ShadeInZone ADD switchIDStatusforClose INTEGER NOT NULL DEFAULT 0;"
            )
            
            // 停
            _ = executeSql(
                "ALTER TABLE ShadeInZone ADD switchIDforStop INTEGER NOT NULL DEFAULT 0;"
            )
            
            // 停状态
            _ = executeSql(
                "ALTER TABLE ShadeInZone ADD switchIDStatusforStop INTEGER NOT NULL DEFAULT 0;"
            )
        }
    }
}
