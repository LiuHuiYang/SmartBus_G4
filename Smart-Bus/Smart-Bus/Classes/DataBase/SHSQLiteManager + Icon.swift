//
//  SHSQLiteManager + Icon.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/24.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - icon 操作
extension SHSQLiteManager {
    
    /// 增加 icon
    func insertIcon(_ icon: SHIcon) -> Bool {
        
        if icon.iconName == nil ||
            icon.iconData == nil {
            return false
        }
        
        var result = false
        queue?.inTransaction({ (db, rollback) in
            
            result =
                ((try? db.executeUpdate(
                    "INSERT INTO iconList (iconID, iconName, iconData) VALUES (?, ?, ?);",
                    values:
                    [icon.iconID,
                     icon.iconName!,
                     icon.iconData!]
                    )) != nil)
        })
        
        return result
    }
    
    /// 获得最大的 iconID
    func getMaxIconID() -> UInt {
        
        let sql = "select max(iconID) from iconList;"
        
        guard let dict = selectProprty(sql).last,
        
        let iconID = dict["max(iconID)"] as? UInt else {
            
            return 0
        }
        
        return iconID
    }
    
    /// 删除 图片
    func deleteIcon(_ icon: SHIcon) -> Bool {
        
        let sql =
            "delete from iconList where " +
            "iconID = \(icon.iconID); "
        
        return executeSql(sql)
    }
    
    /// 依据名称获得图片
    func getIcon(_ iconName: String) -> SHIcon? {
        
        let sql =
            "select iconID, iconName, iconData from " +
            "iconList where iconName = '\(iconName)';"
        
        guard let dict = selectProprty(sql).last else {
            return nil
        }
        
        return SHIcon(dict: dict)
    }
    
    /// 查询所有的图片
    func getIcons() -> [SHIcon] {
        
        let sql =
            "select iconID, iconName, iconData " +
            "from iconList order by iconID;"
        
        let array = selectProprty(sql)
        
        var icons = [SHIcon]()
        
        for dict in array {
            
            icons.append(SHIcon(dict: dict))
        }
        
        return icons
    }
    
    /// 增加 图片 二进制数据 字段
    func addIconData() {
        
        if isColumnName(
            "iconData",
            consistinTable: "iconList") {
            
            return
        }
        
        _ = executeSql(
            "ALTER TABLE iconList ADD iconData DATA;"
        )
        
        // 查询非App原有默认图片
        
        let sql =
            "select iconID, iconName from iconList " +
            "where iconID > \(maxIconIDForDataBase);"
        
        let array = selectProprty(sql)
        
        if array.isEmpty {
            return
        }
        
        // 将图片进行转为二进制数据存储到数据库中
        
        for dict in array {
            
            let icon = SHIcon(dict: dict)
            
            if let data = UIImage.getZoneControlImage(forZones: icon.iconName)?.pngData() {
                
                // 更新二进制数据
                icon.iconData = data
                
                // 更新数据库记录
                _ = deleteIcon(icon)
                
                _ = insertIcon(icon)
            }
        }
        
        // 删除文件夹
        try? FileManager.default.removeItem(atPath: UIImage.zoneControlImageFloderPath())
    }
}
