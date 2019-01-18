//
//  SHSQLiteManager + Fan.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/18.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 风扇操作
extension SHSQLiteManager {
    
    /// 获得指定区域中的最大FanID
    func getMaxFanID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(FanID) from FanInZone " +
            "where ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
            let resID = dict["max(FanID)"] as? String,
            let fanID = UInt(resID) else {
            
            return 0
        }
        
        return fanID
    }
    
    /// 更新风扇数据
    func updateFan(_ fan: SHFan) -> Bool {
        
        let sql =
            "update FanInZone set " +
            "SubnetID = \(fan.subnetID), " +
            "DeviceID = \(fan.deviceID), " +
            "FanName = '\(fan.fanName)', " +
            "ChannelNO = \(fan.channelNO), " +
            "FanTypeID = \(fan.fanTypeID), " +
            "Remark = '\(fan.remark)', " +
            "Reserved1 = \(fan.reserved1), " +
            "Reserved2 = \(fan.reserved2), " +
            "Reserved3 = \(fan.reserved3), " +
            "Reserved4 = \(fan.reserved4), " +
            "Reserved5 = \(fan.reserved5)  " +
            "Where zoneID = \(fan.zoneID) " +
            "and FanID = \(fan.fanID);"
        
        return executeSql(sql)
    }
    
    /// 增加风扇
    func insertFan(_ fan: SHFan) -> Bool {
        
        let sql =
            "insert into FanInZone " +
            "(ZoneID, FanID, FanName, SubnetID, "  +
            "DeviceID, ChannelNO, FanTypeID, "     +
            "Remark, Reserved1, Reserved2, "       +
            "Reserved3, Reserved4, Reserved5) "    +
            "values(\(fan.zoneID), \(fan.fanID), " +
            " '\(fan.fanName)', \(fan.subnetID), " +
            "\(fan.deviceID), \(fan.channelNO),  " +
            "\(fan.fanTypeID), '\(fan.remark)', "  +
            "\(fan.reserved1), \(fan.reserved2), " +
            "\(fan.reserved3), \(fan.reserved4), " +
            "\(fan.reserved5));"
        
        return executeSql(sql)
    }
    
    /// 删除指定区域的所有风扇
    func deleteFans(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from FanInZone Where zoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 删除指定的风扇
    func deleteFan(_ fan: SHFan) -> Bool {
        
        let sql =
            "delete from FanInZone Where "    +
            "zoneID = \(fan.zoneID) and "     +
            "FanID = \(fan.fanID) and "       +
            "SubnetID = \(fan.subnetID) and " +
            "DeviceID = \(fan.deviceID) and " +
            "ChannelNO = \(fan.channelNO);"
        
        return executeSql(sql)
    }
     
    /// 获得指定区域中的所有风扇
    func getFans(_ zoneID: UInt) -> [SHFan] {
        
        let sql =
            "select id, ZoneID, FanID, FanName, SubnetID," +
            "DeviceID, ChannelNO, FanTypeID, Remark,"      +
            "Reserved1, Reserved2, Reserved3, Reserved4,"  +
            "Reserved5 from FanInZone "                    +
            "where ZoneID = \(zoneID) order by id;"
        
        let array = selectProprty(sql)
        
        var fans = [SHFan]()
        
        for dict in array {
            
            fans.append(SHFan(dict: dict))
        }
        
        return fans
    }
    
}
