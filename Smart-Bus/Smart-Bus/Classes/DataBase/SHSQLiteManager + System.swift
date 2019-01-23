//
//  SHSQLiteManager + System.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/23.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

/// 设备类型操作
extension SHSQLiteManager {
    
    /// 获得系统设备名称
    func getSystemNames() -> [String] {
        
        let sql =
            "select SystemName from systemDefnition " +
            "order by SystemID;"
        
        let array = selectProprty(sql)
        
        var names = [String]()
        
        for dict in array {
            
            if let name = dict["SystemName"] as? String {
                
                names.append(name)
            }
        }
        
        return names
    }
    
    /// 查询区域中包含的设备类型
    func getSystemIDs(_ zoneID: UInt) -> [UInt] {
        
        let sql =
            "select ZoneID, SystemID from SystemInZone " +
            "where ZoneID = \(zoneID) order by SystemID;"
        
        let array = selectProprty(sql)
        
        var systemIDs = [UInt]()
        
        for dict in array {
            
            let systemType = SHSystem(dict: dict)
            
            systemIDs.append(systemType.systemID)
        }
        
        return systemIDs
    }
}
