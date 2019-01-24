//
//  SHSQLiteManager + NineInOne.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/24.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 9in1 操作
extension SHSQLiteManager {
    
    /// 增加 nineInOne
    func insertNineInOne(_ nineInOne: SHNineInOne) -> Bool {
        
        let sql =
            "insert into NineInOneInZone (ZoneID,           " +
            "NineInOneID, NineInOneName,                    " +
            "SubnetID, DeviceID,                            " +
            "SwitchIDforControlSure,                        " +
            "SwitchIDforControlUp,                          " +
            "SwitchIDforControlDown,                        " +
            "SwitchIDforControlLeft,                        " +
            "SwitchIDforControlRight,                       " +
        
            "SwitchNameforControl1,                         " +
            "SwitchIDforControl1,                           " +
            "SwitchNameforControl2,                         " +
            "SwitchIDforControl2,                           " +
            "SwitchNameforControl3,                         " +
            "SwitchIDforControl3,                           " +
            "SwitchNameforControl4,                         " +
            "SwitchIDforControl4,                           " +
            "SwitchNameforControl5,                         " +
            "SwitchIDforControl5,                           " +
            "SwitchNameforControl6,                         " +
            "SwitchIDforControl6,                           " +
            "SwitchNameforControl7,                         " +
            "SwitchIDforControl7,                           " +
            "SwitchNameforControl8,                         " +
            "SwitchIDforControl8,                           " +
        
            "SwitchIDforNumber0,                            " +
            "SwitchIDforNumber1,                            " +
            "SwitchIDforNumber2,                            " +
            "SwitchIDforNumber3,                            " +
            "SwitchIDforNumber4,                            " +
            "SwitchIDforNumber5,                            " +
            "SwitchIDforNumber6,                            " +
            "SwitchIDforNumber7,                            " +
            "SwitchIDforNumber8,                            " +
            "SwitchIDforNumber9,                            " +
            "SwitchIDforNumberAsterisk,                     " +
            "SwitchIDforNumberPound,                        " +
                
            "SwitchNameforSpare1,                           " +
            "SwitchIDforSpare1,                             " +
            "SwitchNameforSpare2,                           " +
            "SwitchIDforSpare2,                             " +
            "SwitchNameforSpare3,                           " +
            "SwitchIDforSpare3,                             " +
            "SwitchNameforSpare4,                           " +
            "SwitchIDforSpare4,                             " +
            "SwitchNameforSpare5,                           " +
            "SwitchIDforSpare5,                             " +
            "SwitchNameforSpare6,                           " +
            "SwitchIDforSpare6,                             " +
            "SwitchNameforSpare7,                           " +
            "SwitchIDforSpare7,                             " +
            "SwitchNameforSpare8,                           " +
            "SwitchIDforSpare8,                             " +
            "SwitchNameforSpare9,                           " +
            "SwitchIDforSpare9,                             " +
            "SwitchNameforSpare10,                          " +
            "SwitchIDforSpare10,                            " +
            "SwitchNameforSpare11,                          " +
            "SwitchIDforSpare11,                            " +
            "SwitchNameforSpare12,                          " +
            "SwitchIDforSpare12 ) values(                   " +
            "\(nineInOne.zoneID), \(nineInOne.nineInOneID), " +
            "'\(nineInOne.nineInOneName ?? "9in1")',        " +
            "\(nineInOne.subnetID), \(nineInOne.deviceID),  " +
            "\( nineInOne.switchIDforControlSure),          " +
            "\(nineInOne.switchIDforControlUp),             " +
            "\(nineInOne.switchIDforControlDown),           " +
            "\(nineInOne.switchIDforControlLeft),           " +
            "\(nineInOne.switchIDforControlRight),          " +
            "'\(nineInOne.switchNameforControl1 ?? "C1")',  " +
            "\(nineInOne.switchIDforControl1),              " +
            "'\(nineInOne.switchNameforControl2 ?? "C2")',  " +
            "\(nineInOne.switchIDforControl2),              " +
            "'\(nineInOne.switchNameforControl3 ?? "C3")',  " +
            "\(nineInOne.switchIDforControl3),              " +
            "'\(nineInOne.switchNameforControl4 ?? "C4")',  " +
            "\(nineInOne.switchIDforControl4),              " +
            "'\(nineInOne.switchNameforControl5 ?? "C5")',  " +
            "\(nineInOne.switchIDforControl5),              " +
            "'\(nineInOne.switchNameforControl6 ?? "C6")',  " +
            "\(nineInOne.switchIDforControl6),              " +
            "'\(nineInOne.switchNameforControl7 ?? "C7")',  " +
            "\(nineInOne.switchIDforControl7),              " +
            "'\(nineInOne.switchNameforControl8 ?? "C8")',  " +
            "\(nineInOne.switchIDforControl8),              " +
            "\(nineInOne.switchIDforNumber0),               " +
            "\(nineInOne.switchIDforNumber1),               " +
            "\(nineInOne.switchIDforNumber2),               " +
            "\(nineInOne.switchIDforNumber3),               " +
            "\(nineInOne.switchIDforNumber4),               " +
            "\(nineInOne.switchIDforNumber5),               " +
            "\(nineInOne.switchIDforNumber6),               " +
            "\(nineInOne.switchIDforNumber7),               " +
            "\(nineInOne.switchIDforNumber8),               " +
            "\(nineInOne.switchIDforNumber9),               " +
            "\(nineInOne.switchIDforNumberAsterisk),        " +
            "\(nineInOne.switchIDforNumberPound),           " +
            "'\(nineInOne.switchNameforSpare1 ?? "Spare_1")', "
                                                              +
            "\(nineInOne.switchIDforSpare1),                " +
            "'\(nineInOne.switchNameforSpare2 ?? "Spare_2")', "
                                                              +
            "\(nineInOne.switchIDforSpare2),                " +
            "'\(nineInOne.switchNameforSpare3 ?? "Spare_3")', "
                                                              +
            "\(nineInOne.switchIDforSpare3),                " +
            "'\(nineInOne.switchNameforSpare4 ?? "Spare_4")', "
                                                              +
            "\(nineInOne.switchIDforSpare4),                " +
            "'\(nineInOne.switchNameforSpare5 ?? "Spare_5")', "
                                                              +
            "\(nineInOne.switchIDforSpare5),                " +
            "'\(nineInOne.switchNameforSpare6 ?? "Spare_6")', "
                                                              +
            "\(nineInOne.switchIDforSpare6),                " +
            "'\(nineInOne.switchNameforSpare7 ?? "Spare_7" )', "
                                                              +
            "\(nineInOne.switchIDforSpare7),                " +
            "'\(nineInOne.switchNameforSpare8 ?? "Spare_8")', "
                                                              +
            "\(nineInOne.switchIDforSpare8),                " +
            "'\(nineInOne.switchNameforSpare9 ?? "Spare_9")', "
                                                              +
            "\(nineInOne.switchIDforSpare9),                " +
            "'\(nineInOne.switchNameforSpare10 ?? "Spare_10")', "
                                                              +
            "\(nineInOne.switchIDforSpare10),               " +
            "'\(nineInOne.switchNameforSpare11 ?? "Spare_11")', "
                                                              +
            "\(nineInOne.switchIDforSpare11),               " +
            "'\(nineInOne.switchNameforSpare12 ?? "Spare_12")', "
                                                              +
            "\(nineInOne.switchIDforSpare12));"
        
        return executeSql(sql)
    }
    
    /// 最大的 NineInOneID
    func getMaxNineInOneID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(NineInOneID) from NineInOneInZone " +
            "where ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
              let id = dict["max(NineInOneID)"] as? UInt else {
            return 0
        }
        
        return id
    }
    
    /// 更新 9in1
    func updateNineInOne(_ nineInOne: SHNineInOne) -> Bool {
        
        let sql =
            "update NineInOneInZone set NineInOneName =     " +
            "'\(nineInOne.nineInOneName ?? "9in1")',        " +
            "SubnetID = \(nineInOne.subnetID),              " +
            "DeviceID = \(nineInOne.deviceID),              " +
            "SwitchIDforControlSure =                       " +
            "\(nineInOne.switchIDforControlSure),           " +
            "SwitchIDforControlUp =                         " +
            "\(nineInOne.switchIDforControlUp),             " +
            "SwitchIDforControlDown =                       " +
            "\(nineInOne.switchIDforControlDown),           " +
            "SwitchIDforControlLeft =                       " +
            "\(nineInOne.switchIDforControlLeft),           " +
            "SwitchIDforControlRight =                      " +
            "\(nineInOne.switchIDforControlRight),          " +
            "SwitchNameforControl1 =                        " +
            "'\(nineInOne.switchNameforControl1 ?? "C1")',  " +
            "SwitchIDforControl1 =                          " +
            "\(nineInOne.switchIDforControl1),              " +
            "SwitchNameforControl2 =                        " +
            "'\(nineInOne.switchNameforControl2 ?? "C2")',  " +
            "SwitchIDforControl2 =                          " +
            "\(nineInOne.switchIDforControl2),              " +
            "SwitchNameforControl3 =                        " +
            "'\(nineInOne.switchNameforControl3 ?? "C3")',  " +
            "SwitchIDforControl3 =                          " +
            "\(nineInOne.switchIDforControl3),              " +
            "SwitchNameforControl4 =                        " +
            "'\(nineInOne.switchNameforControl4 ?? "C4")',  " +
            "SwitchIDforControl4 =                          " +
            "\(nineInOne.switchIDforControl4),              " +
            "SwitchNameforControl5 =                        " +
            "'\(nineInOne.switchNameforControl5 ?? "C5")',  " +
            "SwitchIDforControl5 =                          " +
            "\(nineInOne.switchIDforControl5),              " +
            "SwitchNameforControl6 =                        " +
            "'\(nineInOne.switchNameforControl6 ?? "C6")',  " +
            "SwitchIDforControl6 =                          " +
            "\(nineInOne.switchIDforControl6),              " +
            "SwitchNameforControl7 =                        " +
            "'\(nineInOne.switchNameforControl7 ?? "C7")',  " +
            "SwitchIDforControl7 =                          " +
            "\(nineInOne.switchIDforControl7),              " +
            "SwitchNameforControl8 =                        " +
            "'\(nineInOne.switchNameforControl8 ?? "C8")',  " +
            "SwitchIDforControl8 =                          " +
            "\(nineInOne.switchIDforControl8),              " +
            "SwitchIDforNumber0 =                           " +
            "\(nineInOne.switchIDforNumber0),               " +
            "SwitchIDforNumber1 =                           " +
            "\(nineInOne.switchIDforNumber1),               " +
            "SwitchIDforNumber2 =                           " +
            "\(nineInOne.switchIDforNumber2),               " +
            "SwitchIDforNumber3 =                           " +
            "\(nineInOne.switchIDforNumber3),               " +
            "SwitchIDforNumber4 =                           " +
            "\(nineInOne.switchIDforNumber4),               " +
            "SwitchIDforNumber5 =                           " +
            "\(nineInOne.switchIDforNumber5),               " +
            "SwitchIDforNumber6 =                           " +
            "\(nineInOne.switchIDforNumber6),               " +
            "SwitchIDforNumber7 =                           " +
            "\(nineInOne.switchIDforNumber7),               " +
            "SwitchIDforNumber8 =                           " +
            "\(nineInOne.switchIDforNumber8),               " +
            "SwitchIDforNumber9 =                           " +
            "\(nineInOne.switchIDforNumber9),               " +
            "SwitchIDforNumberAsterisk =                    " +
            "\(nineInOne.switchIDforNumberAsterisk),        " +
            "SwitchIDforNumberPound =                       " +
            "\(nineInOne.switchIDforNumberPound),           " +
            "SwitchNameforSpare1 =                          " +
            "'\(nineInOne.switchNameforSpare1 ?? "Spare_1")',"
                                                              +
            "SwitchIDforSpare1 =                            " +
            "\(nineInOne.switchIDforSpare1),                " +
            "SwitchNameforSpare2 =                          " +
            "'\(nineInOne.switchNameforSpare2 ?? "Spare_2")', "
                                                              +
            "SwitchIDforSpare2 =                            " +
            "\(nineInOne.switchIDforSpare2),                " +
            "SwitchNameforSpare3 =                          " +
            "'\(nineInOne.switchNameforSpare3 ?? "Spare_3")', "
                                                              +
            "SwitchIDforSpare3 =                            " +
            "\(nineInOne.switchIDforSpare3),                " +
            "SwitchNameforSpare4 =                          " +
            "'\(nineInOne.switchNameforSpare4 ?? "Spare_4")', "
                                                              +
            "SwitchIDforSpare4 =                            " +
            "\(nineInOne.switchIDforSpare4),                " +
            "SwitchNameforSpare5 =                          " +
            "'\(nineInOne.switchNameforSpare5 ?? "Spare_5")', "
                                                              +
            "SwitchIDforSpare5 =                            " +
            "\(nineInOne.switchIDforSpare5),                " +
            "SwitchNameforSpare6 =                          " +
            "'\(nineInOne.switchNameforSpare6 ?? "Spare_6")', "
                                                              +
            "SwitchIDforSpare6 =                            " +
            "\(nineInOne.switchIDforSpare6),                " +
            "SwitchNameforSpare7 =                          " +
            "'\(nineInOne.switchNameforSpare7 ?? "Spare_7")', "
                                                              +
            "SwitchIDforSpare7 =                            " +
            "\(nineInOne.switchIDforSpare7),                " +
            "SwitchNameforSpare8 =                          " +
            "'\(nineInOne.switchNameforSpare8 ?? "Spare_8")', "
                                                              +
            "SwitchIDforSpare8 =                            " +
            "\(nineInOne.switchIDforSpare8),                " +
            "SwitchNameforSpare9 =                          " +
            "'\(nineInOne.switchNameforSpare9 ?? "Spare_9")', "
                                                              +
            "SwitchIDforSpare9 =                            " +
            "\(nineInOne.switchIDforSpare9),                " +
            "SwitchNameforSpare10 =                         " +
            "'\(nineInOne.switchNameforSpare10 ?? "Spare_10")', "
                                                              +
            "SwitchIDforSpare10 =                           " +
            "\(nineInOne.switchIDforSpare10),               " +
            "SwitchNameforSpare11 =                         " +
            "'\(nineInOne.switchNameforSpare11 ?? "Spare_11")', " +
            "SwitchIDforSpare11 =                           " +
            "\(nineInOne.switchIDforSpare11),               " +
            "SwitchNameforSpare12 =                         " +
            "'\(nineInOne.switchNameforSpare12 ?? "Spare_12")', " +
            "SwitchIDforSpare12 =                           " +
            "\(nineInOne.switchIDforSpare12)                " +
            "where ZoneID = \(nineInOne.zoneID) and         " +
            "NineInOneID = \(nineInOne.nineInOneID);"
        
        
        return executeSql(sql)
    }
    
    /// 删除 指定的 9in1
    func deleteNineInOne(_ nineInOne: SHNineInOne) -> Bool {
        
        let sql =
            "delete from NineInOneInZone    Where " +
            "zoneID = \(nineInOne.zoneID)     and " +
            "SubnetID = \(nineInOne.subnetID) and " +
            "DeviceID = \(nineInOne.deviceID) and " +
            "NineInOneID = \(nineInOne.nineInOneID);"
        
        return executeSql(sql)
    }
    
    /// 删除区域中的 9in1
    func deleteNineInOnes(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from NineInOneInZone Where " +
            "zoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 查询区域中的 9in1
    func getNineInOnes(_ zoneID: UInt) -> [SHNineInOne] {
        
        let sql =
            "select ID, ZoneID, NineInOneID,         " +
            "NineInOneName, SubnetID, DeviceID,      " +
            "SwitchIDforControlSure,                 " +
            "SwitchIDforControlUp,                   " +
            "SwitchIDforControlDown,                 " +
            "SwitchIDforControlLeft,                 " +
            "SwitchIDforControlRight,                " +
            "SwitchNameforControl1,                  " +
            "SwitchIDforControl1,                    " +
            "SwitchNameforControl2,                  " +
            "SwitchIDforControl2,                    " +
            "SwitchNameforControl3,                  " +
            "SwitchIDforControl3,                    " +
            "SwitchNameforControl4,                  " +
            "SwitchIDforControl4,                    " +
            "SwitchNameforControl5,                  " +
            "SwitchIDforControl5,                    " +
            "SwitchNameforControl6,                  " +
            "SwitchIDforControl6,                    " +
            "SwitchNameforControl7,                  " +
            "SwitchIDforControl7,                    " +
            "SwitchNameforControl8,                  " +
            "SwitchIDforControl8,                    " +
            "SwitchIDforNumber0,                     " +
            "SwitchIDforNumber1,                     " +
            "SwitchIDforNumber2,                     " +
            "SwitchIDforNumber3,                     " +
            "SwitchIDforNumber4,                     " +
            "SwitchIDforNumber5,                     " +
            "SwitchIDforNumber6,                     " +
            "SwitchIDforNumber7,                     " +
            "SwitchIDforNumber8,                     " +
            "SwitchIDforNumber9,                     " +
            "SwitchIDforNumberAsterisk,              " +
            "SwitchIDforNumberPound,                 " +
            "SwitchNameforSpare1,                    " +
            "SwitchIDforSpare1,                      " +
            "SwitchNameforSpare2,                    " +
            "SwitchIDforSpare2,                      " +
            "SwitchNameforSpare3,                    " +
            "SwitchIDforSpare3,                      " +
            "SwitchNameforSpare4,                    " +
            "SwitchIDforSpare4,                      " +
            "SwitchNameforSpare5,                    " +
            "SwitchIDforSpare5,                      " +
            "SwitchNameforSpare6,                    " +
            "SwitchIDforSpare6,                      " +
            "SwitchNameforSpare7,                    " +
            "SwitchIDforSpare7,                      " +
            "SwitchNameforSpare8,                    " +
            "SwitchIDforSpare8,                      " +
            "SwitchNameforSpare9,                    " +
            "SwitchIDforSpare9,                      " +
            "SwitchNameforSpare10,                   " +
            "SwitchIDforSpare10,                     " +
            "SwitchNameforSpare11,                   " +
            "SwitchIDforSpare11,                     " +
            "SwitchNameforSpare12,                   " +
            "SwitchIDforSpare12 from NineInOneInZone " +
            "where ZoneID = \(zoneID) order by NineInOneID;"
        
        let array = selectProprty(sql)
        var nineInOnes = [SHNineInOne]()
        
        for dict in array {
            
            nineInOnes.append(SHNineInOne(dict: dict))
        }
        
        return nineInOnes
    }
    
    /// 增加 9in1 类型
    func addNineInOne() -> Bool {
        
        let sql =
            "select Distinct SystemID from " +
                "systemDefnition where SystemID = " +
        "\(SHSystemDeviceType.nineInOne.rawValue);"
        
        if selectProprty(sql).isEmpty == false {
            
            return true
        }
        
        let addSQL =
            "insert into systemDefnition (SystemID, " +
                "SystemName) values(" +
                "\(SHSystemDeviceType.nineInOne.rawValue)," +
        "'9in1');"
        
        return executeSql(addSQL)
    }
}
