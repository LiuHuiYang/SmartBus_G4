//
//  SHDeviceList.swift
//  Smart-Bus
//
//  Created by Mac on 2017/10/25.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

// @objec (类名) 是为了解决app升级后归档崩溃出错的问题
@objc (SHDeviceList)

@objcMembers class SHDeviceList: NSObject, NSCoding {
   
    /// rsip mac地址
    var macAddress: String?
    
    /// rsip 别名
    var alias: String?
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(macAddress, forKey: "macAddress")
        aCoder.encode(alias, forKey: "alias")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        macAddress = aDecoder.decodeObject(forKey: "macAddress") as? String
        alias = aDecoder.decodeObject(forKey: "alias") as? String
    }
}
