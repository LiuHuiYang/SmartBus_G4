//
//  SHSQLiteManager + OtherControl.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 其实控制
extension SHSQLiteManager {
    
    
    /// 删除区域中的所有的 其它控制
    func deleteOtherControls(_ zoneID: UInt) -> Bool {
        
        // 暂时没有实现
        
        return false
    }
    
    /// 增加 其它控件
    func addOtherControl() -> Bool {
     
        let sql =
            "select Distinct SystemID from " +
                "systemDefnition where SystemID = " +
        "\(SHSystemDeviceType.otherControl.rawValue);"
        
        if selectProprty(sql).isEmpty == false {
            
            return true
        }
        
        let addSQL =
            "insert into systemDefnition (SystemID, " +
                "SystemName) values(" +
                "\(SHSystemDeviceType.otherControl.rawValue)," +
        "'Other Control');"
        
        return executeSql(addSQL)
        
    }
    
}
