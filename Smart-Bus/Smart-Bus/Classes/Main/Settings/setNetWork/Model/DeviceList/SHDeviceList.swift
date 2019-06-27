//
//  SHDeviceList.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/25.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// 选择的设备网卡地址
private let selectMacAddress: String = "SHSelectDeviceMacAddress.data"

// @objec (类名) 是为了解决app升级后归档崩溃出错的问题
@objc (SHDeviceList)

@objcMembers class SHDeviceList: NSObject, NSCoding {
    
    /// 服务器名称
    var serverName: String?
   
    /// rsip mac地址
    var macAddress: String?
    
    /// rsip 别名
    var alias: String?
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(serverName, forKey: "serverName")
        aCoder.encode(macAddress, forKey: "macAddress")
        aCoder.encode(alias, forKey: "alias")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        serverName = aDecoder.decodeObject(forKey: "serverName") as? String
        
        macAddress = aDecoder.decodeObject(forKey: "macAddress") as? String
        
        alias = aDecoder.decodeObject(forKey: "alias") as? String
    }
}


// MARK: - 归档与解档的直接操作
extension SHDeviceList {
    
    
    /// 保存所有的RSIP信息
    ///
    /// - Parameter devices: RSIP数组
    static func saveAllRemoteDevices(_ devices: [SHDeviceList]) -> Bool {
        
        let filePath =
            FileTools.documentPath() + "/" +
            allDeviceMacAddressListPath
        
        return
            NSKeyedArchiver.archiveRootObject(
                devices,
                toFile: filePath
            )
    }
    
    /// 获得所有的RSIP
    ///
    /// - Returns: RSIP数组
    static func allRemoteDevices() -> [SHDeviceList] {
        
        let rsipArrayPath =
            FileTools.documentPath() + "/" +
            allDeviceMacAddressListPath
        
        guard let rsips = NSKeyedUnarchiver.unarchiveObject(withFile: rsipArrayPath) as? [SHDeviceList] else {
            
            return [SHDeviceList]()
        }
        
        return rsips
    }
    
    /// 保存选择的RSIP信息
    ///
    /// - Parameter device: rsip信息
    static func saveSelectedRemoteDevice(_ device: SHDeviceList) -> Bool {
        
        // 更新选择中的RSIP
        let filePath =
            FileTools.documentPath() + "/" + selectMacAddress
        
        return
        
            NSKeyedArchiver.archiveRootObject(
                device,
                toFile: filePath
            )
    }
    
    /// 获得选择的RSIP的信息
    ///
    /// - Returns: rsip信息
    static func selectedRemoteDevice() -> SHDeviceList? {
        
        let path =
            FileTools.documentPath() + "/" + selectMacAddress
        
        let rsip =
            NSKeyedUnarchiver.unarchiveObject(withFile: path) as? SHDeviceList
        
        return rsip
    }
}
