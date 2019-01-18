//
//  SHSQLiteManager + Region.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/18.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 多分组操作
extension SHSQLiteManager {
    
 
    
    /// 插入一个新增加的region
    func insertRegion(_ region: SHRegion) -> Bool {
        
        let sql =
            "insert into Regions(regionID, regionName, " +
            "regionIconName) values(\(region.regionID), " +
            "'\(region.regionName)',  " +
            "'\(region.regionIconName)' );"
        
        return executeSql(sql)
    }
    
    /// 查询所有的区域分组
    func getAllRegions() -> [SHRegion] {
        
        let sql =
            "select *" +
            "from Regions order by regionID;"
        
        let array = selectProprty(sql)
        
        var regions = [SHRegion]()
        
        for dict in array {
            
            let region = SHRegion(dictionary: dict)
            
            regions.append(region)
        }
        
        return regions
    }
    
    /// 增加地区表格字段
    func addRegions() {
        
        if isColumnName("regionID",
                        consistinTable: "Zones") == false {
            
            let sql =
                "ALTER TABLE Zones ADD regionID INTEGER DEFAULT 1;"
            
            _ = executeSql(sql)
        }
        
        // 默认插入一条数据
        if getAllRegions().count == 0 {
            
            let region = SHRegion()
            region.regionID = 1
            region.regionName = "region"
            region.regionIconName = "regionIcon"
            
            _ = insertRegion(region)
            
        }
    }
    
}
