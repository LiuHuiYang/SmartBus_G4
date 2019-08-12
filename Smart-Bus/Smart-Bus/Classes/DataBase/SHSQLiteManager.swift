//
//  SHSQLiteManager.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/9.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit
import FMDB


/// 数据库名称
let dataBaseName = "SMART-BUS.sqlite";

/// 沙盒记录版本标示
let sandboxVersionKey = "sandboxVersionKey"
  
// 在数据库中可以iconList直接查询到
let maxIconIDForDataBase = 10

@objcMembers class SHSQLiteManager: NSObject {

    /// 单列对象
    static let shared = SHSQLiteManager()
    
    /// 全局操作队列
    var queue: FMDatabaseQueue?
    
    /// 初始化
    override init() {
        super.init()
       
        setupDataBase()
    }
    
    /// 初始化数据库
    private func setupDataBase() {
        
        let filePath =
            FileTools.documentPath() + "/" + dataBaseName
        
        if let resourcePath = Bundle.main.resourcePath {
            
            let sourcePath =
                resourcePath + "/" + dataBaseName
            
            if FileManager.default.fileExists(atPath: filePath) == false {
                
                try? FileManager.default.copyItem(
                    atPath: sourcePath,
                    toPath: filePath
                )
            }
        }
        
        queue = FMDatabaseQueue(path: filePath)
        
        // 创建表格
        createSqlTables()
        
        // 增加字段操作
        alertTablesOrColumnName()
    }
    
    /// 创建表格
    func createSqlTables() {
        
        guard let path =
            Bundle.main.path(forResource: "SQL.sql",
                             ofType: nil),
        
            let sql =
                try? String(contentsOfFile:path,
                            encoding: .utf8) else {
                
                return
        }

        queue?.inTransaction({ (db, rollback) in
            
            db.executeStatements(sql)
        })
    }
    
    
    /// 删除残留数据
    func deleteResidualData() {
    
        // 有效区域
        let zoneIDs = getZoneID(tableName: "Zones")
        
        // 已配置的区域
        let systemDeviceZoneIDs =
            getZoneID(tableName: "SystemInZone")
        
        // 需要被删除的区域
        var delelteZoneID = [UInt]()
        
        for zoneID in systemDeviceZoneIDs {
            
            if !zoneIDs.contains(zoneID) {
             
                delelteZoneID.append(zoneID)
            }
        }
        
        // 删除残留数据
        for zoneID in delelteZoneID {
            
            _ = deleteZone(zoneID)
        }
    }
    
    /// 增加字段操作
    func alertTablesOrColumnName() {
        
        /**** 1. 版本匹配记录 *****/
        if SHSQLiteManager.isLatestVersion() {
            
            return // 最新版本
        }
        
        /**** 2. 删除区域中的旧数据 *****/
        deleteResidualData()
         
        /**** 3. 设置字段和新设备 *****/
        
        // 增加多区域支持
        addRegions()
        
        // 增加图片的二进制数据
        addIconData()
        
        // 增加CT24的参数
        addCurrentTransformerParameter()
        
        // 增加HVAC的显示温度参数
        addHvacParameter()
        
        // 增加窗帘操作的一些参数
        addShadeParameter()
        
        // 增加音乐的一些字段
        addAudioParameter()
        
        // 增加多媒体设备的标注
        addMediaDeviceRemark()
        
        // 增加FloorHeating类型
        _ = addFloorHeating()
        
        // 增加DMX类型
        _ = addZoneDmx()
        
        // 增加9in1类型
        _ = addNineInOne()
        
        // 增加Scene控制
        _ = addSceneControl()
        
        // 增加 Sequence 控制
        _ = addSequenceControl()
        
        // 增加其它 控制
        _ = addOtherControl()
        
        // 增加温度传感器
        _ = addTemperatureSensor()
        
        // 增加区域干节点
        _ = addZoneDryContact()
        
        // 增加SAT的字段
        addSatControlItems()
   
        // 增加场景模式的延时功能
        _ = addMoodCommandDelaytime()
        
        // 增加电视的更多参数
        _ = addMediaTVParameter()
        
        // 增加卫星电视的参数
        _ = addMediaSATCategoryParameter()
        
        // 增加light的参数
        _ = addLightParameter()
    }
    
    /// 是否为最新版本
    static func isLatestVersion() -> Bool {
        
        // 获得记录版本
        let sandboxVersion =
            UserDefaults.standard.object(
                forKey: sandboxVersionKey
                ) as? String
        
        // 当前应用版本
        let currentVersion =
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        // 设置最新版本
        UserDefaults.standard.set(
            currentVersion,
            forKey: sandboxVersionKey
        )
        
        UserDefaults.standard.synchronize()
        
        return currentVersion == sandboxVersion
    }
    
}


// MARK: - 常用操作
extension SHSQLiteManager {
    
    /// 数据库关闭
    func restart() {
        
        queue?.close()
        
        queue = nil
        
        // 清空版本记录
        UserDefaults.standard.set(
            "",
            forKey: sandboxVersionKey
        )
        
        UserDefaults.standard.synchronize()
        
        setupDataBase()
    }
    
    /// 执行SQL语句
    ///
    /// - Parameter sql: sql 语句
    /// - Returns: 是否成功执行
    func executeSql(_ sql: String) -> Bool {
        
        var result = true
        
        queue?.inTransaction({ db, rollback in
            
            if db.executeUpdate(sql, withArgumentsIn: []) == false {
                
                result = false
            }
        })
        
        return result
    }
    
    
    /// 查询封装语句
    ///
    /// - Parameter sql: 查询语句
    /// - Returns: 【字典】数组
    func selectProprty(_ sql: String) -> [[String: Any]] {
        
        /// 数组集合
        var array = [[String: Any]]()
        
        queue?.inTransaction({ db, rollback in
            
            // 获得所有的结果集
            if let resultSet = db.executeQuery(sql, withArgumentsIn: []) {
                
                // 遍历结果集
                while resultSet.next() {
                    
                    // 准备好字典
                    var dict = [String: Any]()
                    
                    // 获得列数
                    let count = resultSet.columnCount
                    
                    // 遍历所有的记录
                    for i in 0 ..< count {
                        
                        // 获得字段名称与值
                        if let name =
                            resultSet.columnName(for: i) {
                            
                            // 获得字段值
                            let value =
                                resultSet.object(forColumn: name)
                            
                            // 赋值字典
                            dict[name] = value
                        }
                        
                    }
                    
                    // 添加到数组
                    array.append(dict)
                }
            }
            
        })
        
        return array
    }

    
    /// 删除表格
    ///
    /// - Parameter name: 表格名称
    /// - Returns: true - 删除成功 false - 删除失败
    func deleteTable(_ name: String) -> Bool {
        
        let deleteSQL = "DROP TABLE IF EXISTS \(name);"
        
        return executeSql(deleteSQL)
    }
    
    
    /// 修改数据表的名称
    ///
    /// - Parameters:
    ///   - srcName: 原名称
    ///   - destName: 新名称
    /// - Returns: true - 修改成功, false - 修改失败
    func renameTable(_ srcName: String,
                     toName destName: String) -> Bool {
        
        let renameSQL =
            "ALTER TABLE \(srcName) RENAME TO \(destName);"
        
        return executeSql(renameSQL)
    }


    /// 判断表中是否存在字段
    ///
    /// - Parameters:
    ///   - columnName: 字段名称
    ///   - tableName: 表格名称
    /// - Returns: true - 存在 false - 不存在
    func isColumnName(_ columnName: String,
                      consistinTable tableName: String) -> Bool {
        
        let sql = "select * from \(tableName)"
        
        var result: FMResultSet?
        
        queue?.inTransaction({ (db, roolback) in
            
            result =
                db.executeQuery(sql,
                                withArgumentsIn: []
            )
        })
        
        guard let count = result?.columnCount else {
            
            return false
        }
        
        for i in 0 ..< count {
            
            let name = result?.columnName(for: i)
            
            // 判断是否存在
            // (由于SQL不区分大小，所以需要统一区分成大小。)
            if name?.uppercased() == columnName.uppercased() {
                
                return true
            }

        }
        
        return false
    }
    
}
