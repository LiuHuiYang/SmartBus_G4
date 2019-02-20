//
//  SHSQLiteManager + Scene.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - Scene 控制
extension SHSQLiteManager {
    
    /// 增加 Scene
    func insertScene(_ scene: SHScene) -> Bool {
        
        let sql =
            "insert into SceneInZone (ZoneID, "     +
            "SceneID, remark, SubnetID, DeviceID, " +
            "AreaNo, SceneNo) values( "             +
            "\(scene.zoneID), \(scene.sceneID), ' " +
            "\(scene.remark)', \(scene.subnetID), " +
            "\(scene.deviceID), \(scene.areaNo),  " +
            "\(scene.sceneNo));"
        
        return executeSql(sql)
    }
    
    /// 更新 Scene
    func updateScene(_ scene: SHScene) -> Bool {
        
        let sql =
            "update SceneInZone set "               +
            "remark = '\(scene.remark)', "          +
            "SubnetID = \(scene.subnetID), "        +
            "DeviceID = \(scene.deviceID), "        +
            "AreaNo = \(scene.areaNo), "            +
            "SceneNo = \(scene.sceneNo) "           +
            "where ZoneID = \(scene.zoneID) and "   +
            "SceneID = \(scene.sceneID);"
        
        return executeSql(sql)
    }
    
    /// 获得最大的 SceneID
    func getMaxSceneID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(SceneID) from SceneInZone " +
            "where ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
        let sceneID = dict["max(SceneID)"] as? UInt else {
            
            return 0
        }
        
        return sceneID
    }
    
    /// 删除区域中的 scene
    func deleteScenes(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from SceneInZone where " +
            "ZoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 删除 Scene
    func deleteScene(_ scene: SHScene) -> Bool {
        
        let sql =
            "delete from SceneInZone where " +
            "ZoneID = \(scene.zoneID) and "  +
            "SceneID = \(scene.sceneID);"
        
        return executeSql(sql)
    }
    
    /// 查询当前区域中的所有Scene
    func getScenes(_ zoneID: UInt) -> [SHScene] {
        
        let sql =
            "select id, ZoneID, SceneID, remark, " +
            "SubnetID, DeviceID, AreaNo, SceneNo " +
            "from SceneInZone where "              +
            "ZoneID = \(zoneID) order by SceneID;"
        
        let array = selectProprty(sql)
        var scenes = [SHScene]()
        
        for dict in array {
            
            scenes.append(SHScene(dictionary: dict))
        }
        
        return scenes
    }
    
    /// 增加 Scene 控制
    func addSceneControl() -> Bool {
        
        let sql =
            "select Distinct SystemID from " +
            "systemDefnition where SystemID = " +
            "\(SHSystemDeviceType.sceneControl.rawValue);"
        
        if selectProprty(sql).isEmpty == false {
            
            return true
        }
        
        let addSQL =
            "insert into systemDefnition (SystemID, " +
            "SystemName) values(" +
            "\(SHSystemDeviceType.sceneControl.rawValue)," +
            "'Scene Control');"
        
        return executeSql(addSQL)
    }
}
