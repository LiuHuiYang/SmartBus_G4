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
