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
private let dataBaseName = "SMART-BUS.sqlite";

/// 沙盒记录版本标示
private let sandboxVersionKey = "sandboxVersionKey"

@objcMembers class SHSQLiteManager: NSObject {

    /// 单列对象
    static let shared = SHSQLiteManager()
    
    /// 全局操作队列
    var queue: FMDatabaseQueue?
    
    
    /// 初始化
    override init() {
        super.init()
      
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
    
    
    /// 增加字段操作
    func alertTablesOrColumnName() {
        
        /**** 1. 版本匹配记录 *****/
        
        // 获得记录版本
        let sandboxVersion =
            UserDefaults.standard.object(
                forKey: sandboxVersionKey
            ) as? String
        
        // 当前应用版本
        let currentVersion =
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        if currentVersion == sandboxVersion {
            
//            return // 最新版本
        }
        
        // 设置最新版本
        UserDefaults.standard.set(
            currentVersion,
            forKey: sandboxVersionKey
        )
        
        UserDefaults.standard.synchronize()
        
        /**** 2. 删除区域中的旧数据 *****/
        
        
        /**** 3. 设置字段和新设备 *****/
        
        // 增加多区域支持
        addRegions()
        
        // 增加Scene控制
        _ = addSceneControl()
        
        // 增加 Sequence 控制
        _ = addSequenceControl()
        
        // 增加其它 控制
        _ = addOtherControl()
    }
}


// MARK: - 常用操作
extension SHSQLiteManager {
    
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
