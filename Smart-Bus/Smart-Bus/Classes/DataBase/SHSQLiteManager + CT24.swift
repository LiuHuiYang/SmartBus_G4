//
//  SHSQLiteManager + CT24.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - CT24的操作
extension SHSQLiteManager {
    
    /// 增加新的CurrentTransformer 返回 id
    func insertCurrentTransformer(_ currentTransformer: SHCurrentTransformer) -> UInt {
        
        let sql =
            "insert into CurrentTransformer " +
            "(CurrentTransformerID) values ( " +
            "\(currentTransformer.currentTransformerID));"
        
        _ = executeSql(sql)
        
        let idSQL = "select max(ID) from CurrentTransformer;"
        
        guard let dict = selectProprty(idSQL).last,
        let id = dict["max(ID)"] as? UInt else {
            
            return 0
        }
        
        return id
    }
    
    /// 更新CT24
    func updateCurrentTransformer(_ currentTransformer: SHCurrentTransformer) -> Bool {
        
        let sql =
            "update CurrentTransformer set " +
            "Remark = '\(currentTransformer.remark)', " +
            "SubnetID = \(currentTransformer.subnetID), " +
            "DeviceID = \(currentTransformer.deviceID), " +
            "voltage = \(currentTransformer.voltage), " +
            "Channel1  = '\(currentTransformer.channel1)', "
        +
            "Channel2  = '\(currentTransformer.channel2)', "
        +
            "Channel3 = '\(currentTransformer.channel3)', "
        +
            "Channel4  = '\(currentTransformer.channel4)', "
        +
            "Channel5  = '\(currentTransformer.channel5)', "
        +
            "Channel6 = '\(currentTransformer.channel6)', "
        +
            "Channel7  = 'currentTransformer.channel7', "
        +
            "Channel8  = '\(currentTransformer.channel8)', "
        +
            "Channel9 = '\(currentTransformer.channel9)', "
        +
            "Channel10 = '\(currentTransformer.channel10)', "
        +
            "Channel11 = '\(currentTransformer.channel11)', "
        +
            "Channel12 = '\(currentTransformer.channel12)', "
        +
            "Channel13 = '\(currentTransformer.channel13)', "
        +
            "Channel14 = '\(currentTransformer.channel14)', "
        +
            "Channel15 = '\(currentTransformer.channel15)', "
        +
            "Channel16 = '\(currentTransformer.channel16)', "
        +
            "Channel17 = '\(currentTransformer.channel17)', "
        +
            "Channel18 = '\(currentTransformer.channel18)', "
        +
            "Channel19 = '\(currentTransformer.channel19)', "
        
        +   "Channel20 = '\(currentTransformer.channel20)', "
        
        +
            "Channel21 = '\(currentTransformer.channel21)', "
        +
            "Channel22 = '\(currentTransformer.channel22)', "
        +
            "Channel23 = '\(currentTransformer.channel23)', "
        +
            "Channel24 = '\(currentTransformer.channel24)' "
        +
           "where CurrentTransformerID = "
        +
           "\(currentTransformer.currentTransformerID);"
        
        
        return executeSql(sql)
    }
    
    /// 删除 CT24
    func deleteCurrentTransformer(_ currentTransformer: SHCurrentTransformer) -> Bool {
        
        let sql =
            "delete from CurrentTransformer where "       +
            "CurrentTransformerID = "                     +
            "\(currentTransformer.currentTransformerID) " +
            "and ID = \(currentTransformer.id);"
        
        return executeSql(sql)
    }
    
    /// 获得 最大的 CurrentTransformerID
    func getMaxCurrentTransformerID() -> UInt {
        
        let sql =
            "select max(CurrentTransformerID) from CurrentTransformer;"
        
        guard let dict = selectProprty(sql).last,
        let currentTransformerID =
                dict["max(CurrentTransformerID)"]
            as? UInt else {
                
            return 0
        }
        
        return currentTransformerID
    }
    
    /// 获得所有的CT24
    func getCurrentTransformers() -> [SHCurrentTransformer] {
        
        let sql =
            "select ID, CurrentTransformerID, SubnetID, " +
            "DeviceID, Remark, voltage, Channel1, " +
            "Channel2, Channel3, Channel4, Channel5, " +
            "Channel6, Channel7, Channel8, Channel9, " +
            "Channel10, Channel11, Channel12, Channel13, " +
            "Channel14, Channel15, Channel16, Channel17, " +
            "Channel18, Channel19, Channel20, Channel21, " +
            "Channel22, Channel23,Channel24 "              +
            "from  CurrentTransformer "                    +
            "order by CurrentTransformerID;"
        
        let array = selectProprty(sql)
        
        var currentTransformers = [SHCurrentTransformer]()
        
        for dict in array {
            
            currentTransformers.append(
                SHCurrentTransformer(dict: dict)
            )
        }
        
        return currentTransformers
    }
    
    /// 增加CT24的参数
    func addCurrentTransformerParameter() {
        
        // 增加CT24的电压设定值
        if isColumnName(
            "Voltage", consistinTable:
            "CurrentTransformer") == false {
            
            let sql =
                "ALTER TABLE CurrentTransformer " +
                "ADD Voltage INTEGER NOT NULL DEFAULT 0;"
            
            _ = executeSql(sql)
        }
        
        if isColumnName(
            "Channel1",
            consistinTable: "CurrentTransformer"
            ) == false {
            
            for i in 1 ... 24 {
                
                let sql =
                    "ALTER TABLE CurrentTransformer " +
                    "ADD Channel\(i) TEXT NOT NULL " +
                    "DEFAULT 'CH\(i)'"
                
                _ = executeSql(sql)
            }
        }
        
    }
}
