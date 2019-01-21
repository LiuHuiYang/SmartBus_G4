//
//  SHSQLiteManager + Sequence.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


extension SHSQLiteManager {
    
    /// 增加 Sequence
    func insertSequence(_ sequence: SHSequence) -> Bool {
        
        let sql =
            "insert into SequenceInZone (ZoneID, "         +
            "SequenceID, remark, SubnetID, DeviceID, "     +
            "AreaNo, SequenceNo) values( "                 +
            "\(sequence.zoneID), \(sequence.sequenceID), " +
            "'\(sequence.remark)', \(sequence.subnetID), " +
            "\(sequence.deviceID), \(sequence.areaNo), " +
            "\(sequence.sequenceNo));"
      
        return executeSql(sql)
    }
    
    /// 更新 Sequence
    func updateSequence(_ sequence: SHSequence) -> Bool {
        
        let sql =
            "update SequenceInZone set "             +
            "remark = '\(sequence.remark)', "        +
            "SubnetID = \(sequence.subnetID), "      +
            "DeviceID = \(sequence.deviceID), "      +
            "AreaNo = \(sequence.areaNo), "          +
            "SequenceNo = \(sequence.sequenceNo) "   +
            "where ZoneID = \(sequence.zoneID) and " +
            "SequenceID = \(sequence.sequenceID);"
        
        return executeSql(sql)
    }
    
    /// 最大的 sequenceID
    func getMaxSequenceID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(SequenceID) from SequenceInZone " +
            "where ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
            let sequenceID = dict["max(SequenceID)"] as? UInt else {
            return 0
        }
        
        return sequenceID
    }
    
    /// 删除当前的 Sequence
    func deleteSequence(_ sequence: SHSequence) -> Bool {
        
        let sql =
            "delete from SequenceInZone where " +
            "ZoneID = \(sequence.zoneID) and " +
            "SequenceID = \(sequence.sequenceID);"
        
        return executeSql(sql)
    }
    
    /// 查询当前区域中的所有Sequence
    func getSequences(_ zoneID: UInt) -> [SHSequence] {
        
        let sql =
            "select id, ZoneID, SequenceID, remark, " +
            "SubnetID, DeviceID, AreaNo, SequenceNo " +
            "from SequenceInZone where "              +
            "ZoneID = \(zoneID) order by SequenceID;"
        
        let array = selectProprty(sql)
        
        var sequences = [SHSequence]()
        
        for dict in array {
            
            sequences.append(SHSequence(dictionary: dict))
        }
        
        return sequences
    }
    
    /// 增加 Sequence 控制
    func addSequenceControl() -> Bool {
        
        let sql =
            "select Distinct SystemID from " +
                "systemDefnition where SystemID = " +
        "\(SHSystemDeviceType.sequenceControl.rawValue);"
        
        if selectProprty(sql).isEmpty == false {
            
            return true
        }
        
        let addSQL =
            "insert into systemDefnition (SystemID, " +
                "SystemName) values(" +
                "\(SHSystemDeviceType.sequenceControl.rawValue)," +
        "'Sequence Control');"
        
        return executeSql(addSQL)
    }
}
