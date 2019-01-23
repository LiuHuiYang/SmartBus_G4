//
//  SHSQLiteManager + Sat.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/23.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - Sat 操作
extension SHSQLiteManager {
    
    
    
    /// 增加控制单元
    func addSatControlItems() {
        
        if isColumnName(
            "SwitchNameforControl1",
            consistinTable: "SATInZone") == false {
            
            // C1
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchNameforControl1 TEXT DEFAULT 'C1';"
            )
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchIDforControl1 INTEGER DEFAULT 0;"
            )
            
            // C2
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchNameforControl2 TEXT DEFAULT 'C2';"
            )
            
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchIDforControl2 INTEGER DEFAULT 0;"
            )
            
            // C3
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchNameforControl3 TEXT DEFAULT 'C3';"
            )
            
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchIDforControl3 INTEGER DEFAULT 0;"
            )
            
            // C4
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchNameforControl4 TEXT DEFAULT 'C4';"
            )
            
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchIDforControl4 INTEGER DEFAULT 0;"
            )
            
            // C5
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchNameforControl5 TEXT DEFAULT 'C5';"
            )
            
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchIDforControl5 INTEGER DEFAULT 0;"
            )
            
            // C6
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchNameforControl6 TEXT DEFAULT 'C6';"
            )
            
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchIDforControl6 INTEGER DEFAULT 0;"
            )
        }
    }
}
