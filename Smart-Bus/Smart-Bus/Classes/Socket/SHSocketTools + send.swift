//
//  SHSocketTools + send.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017 SmartHome. All rights reserved.
//

import Foundation
//import MachO

/// 远程设备类型标示
private let iOS_flag: UInt8 = 0x02

/// 记录的wifi(Server时有效)
private let localWifiKey = "SHUdpSocketSendDataLocalWifi"

/// 本地wifi广播地址
private let localBroadcastAddress = "255.255.255.255"

/// 本地端口
private let localServerPort: UInt16 = 6000

/// 远程端口
private let remoteServerPort: UInt16 = 8888

/// 计数
private var count = 0
 

// MARK: - 发送数据包
extension SHSocketTools {
    
    /// socket发送的通用数据包(外界调用)
    ///
    /// - Parameters:
    ///   - operatorCode: 操作码
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - additionalData: 额外参数数组
    ///   - remoteDevice: 远程设备RSIP
    ///   - needReSend: 是否需要重发(默认重发)
    ///   - isDMX: 是否为DMX设备(默认不是)
    static func sendData(
        operatorCode: UInt16,
        subNetID: UInt8,
        deviceID: UInt8,
        additionalData:[UInt8],
        remoteDevice: SHDeviceList =
        (SHDeviceList.selectedRemoteDevice() ?? SHDeviceList()),
        needReSend: Bool = true,
        isDMX: Bool = false) {
        
        DispatchQueue.global().async {
            
            let socketData =
                SHSocketData(operatorCode: operatorCode,
                             subNetID: subNetID,
                             deviceID: deviceID,
                             additionalData: additionalData,
                             deviceType: 0,
                             remoteDevice: remoteDevice,
                             isDMX: isDMX
            )
            
            sendDeviceControlData(socketData)
            
            if needReSend {
                
                SHSocketTools.appendCaCheData(socketData)
            }
            
//            if needReSend {
//
//                SHSocketTools.addSocketData(
//                    socketData: socketData
//                )
//
//                var count = 1
//
//                while count > 0 {
//
//                    sendDeviceControlData(socketData)
//
//                    Thread.sleep(forTimeInterval: 0.75)
//
//                    // 查询缓存
//                    if SHSocketTools.isSocketDataExist(socketData: socketData) == false {
//
//                        break
//                    }
//
//                    count -= 1
//                }
//
//                // 重发超过规定次数
//                if (count <= 0) {
//
//                    SHSocketTools.removeSocketData(
//                        socketData: socketData
//                    )
//                }
//            }
        }
     
        // 所有的指令都要延时 0.1秒执行
        // (0.1是依据产品固件计算出来的平均值)
        Thread.sleep(forTimeInterval: 0.15)
  
        // 如果没有启动重发线程 就启动，如果已经启动不需要重新启动。
        if SHSocketTools.startToReSend == false {
            SHSocketTools.startToReSend = true
            
            repeatSendDeviceData()
        }
 
    }
}


// MARK: - 重发数据
extension SHSocketTools {
    
    /// 添加缓存数据
    ///
    /// - Parameter socketData: 缓存数据
    private static func appendCaCheData(_ socketData: SHSocketData) {
        
        let cacheData = SHSocketTools.shared.cacheData
 
        for item in cacheData {
            
            if item.operatorCode == socketData.operatorCode &&
                item.subNetID == socketData.subNetID &&
                item.deviceID == socketData.deviceID &&
                item.additionalData == socketData.additionalData  {
                
                
                return
            }
        }
        
        SHSocketTools.shared.lock.lock()
        
        SHSocketTools.shared.cacheData.append(
            socketData
        )
        
        SHSocketTools.shared.lock.unlock()
    }
    
    /// 重发数据
    @objc private static func repeatSendDeviceData() {
        
        // 独立的重发线程执行
        SHSocketTools.shared.repeatQueue.async {
            
            Thread.sleep(forTimeInterval: 0.5)
            
//            print(" 重发 \(Thread.current) - \(SHSocketTools.shared.cacheData.count)")
        
            while let socketData = SHSocketTools.shared.cacheData.first {
                
                if socketData.reSendCount >= 1 {
 
                    SHSocketTools.shared.lock.lock()
                    SHSocketTools.shared.cacheData.remove(
                        at: 0
                    )
                    SHSocketTools.shared.lock.unlock()
                    
                    continue
                }
                
                socketData.reSendCount += 1
                sendDeviceControlData(socketData)
                
                Thread.sleep(forTimeInterval: 0.7)
            }
 
            SHSocketTools.startToReSend = false
            
//            print("重发 结束 \(SHSocketTools.shared.cacheData.count)")
            
        }
    }
}


// MARK: - 发送数据
extension SHSocketTools {
    
    /// 发送数据包
    ///
    /// - Parameter data: 控制数据
    private static func sendDeviceControlData(
        _ data: SHSocketData) {
        
        let data = packingData(
            operatorCode: data.operatorCode,
            subNetID: data.subNetID,
            deviceID: data.deviceID,
            additionalData: data.additionalData,
            remoteDevice: data.remoteDevice,
            isDMX: data.isDMX
        )
        
        let sendData =
            NSMutableData(bytes: data.datas,
                          length: data.datas.count
                ) as Data
        
        if SHSocketTools.shared.socket?.localPort() != data.port {
            
            do {
                
                // 端口不同，先关闭socket 释放端口 再重新绑定
                SHSocketTools.shared.socket?.close()
                SHSocketTools.shared.socket = nil
                
                SHSocketTools.shared.socket =
                    SHSocketTools.shared.setupSocket()
                
                // 绑定端口
                try SHSocketTools.shared.socket?.bind(
                    toPort: data.port,
                    interface: nil
                )
                
                // 开启接收
                try SHSocketTools.shared.socket?.beginReceiving()
                
            } catch {
                
                print("绑定端口出错!!! \(error)")
                
                SHSocketTools.shared.socket?.close()
                SHSocketTools.shared.socket = nil
                
                SHSocketTools.shared.socket =
                    SHSocketTools.shared.setupSocket()
            }
        }
        
        
        SHSocketTools.shared.socket?.send(
            sendData, toHost: data.destAddress,
            port: data.port,
            withTimeout: -1,
            tag: 0
        )
        
//         print("发送控制包: \(data)")
    }
}

// MARK: - 打包发送数据
extension SHSocketTools {
    
    /// 打包数据
    static func packingData(operatorCode: UInt16,
                            subNetID: UInt8,
                            deviceID: UInt8,
                            additionalData:[UInt8],
                            remoteDevice: SHDeviceList,
                            isDMX: Bool)  ->
        (   datas: [UInt8],
        destAddress: String,
        port: UInt16
        ) {
            
            // 发送的数据包: 目标ip + 固定协议头 + protocolBaseStructure
            
            let remoteMacAddress =
                remoteDevice.macAddress ?? ""
            
            let remoteServerDomainName =
                remoteDevice.serverName ?? defaultRemoteServerDoMainName
            
            let isRemote =
                SHSocketTools.isRemoteControl(remoteMacAddress)
            
            // 1. 计算整个包的大小
            
            // 1.1 IP地址
            guard let ipAddress =
                isRemote ?
                    UIDevice.getIPAddress(
                        byHostName: remoteServerDomainName
                    ) :
                    
                    UIDevice.getIPAddress(UIDevice.isIPV6()
                        
                ) else {
                    
                    return ([], "", 0)
            }
            
            let sourceIP =
                ipAddress.components(separatedBy: ".")
            
            // 1.2 固定协议头
            let generalHeader: [UInt8] = [
                0x53, 0x4D, 0x41, 0x52, 0x54,
                0x43, 0x4C, 0x4F, 0x55, 0x44
            ]
            
            let dmxHeader: [UInt8] = [
                0x48, 0x44, 0x4C, 0x4D, 0x49,
                0x52, 0x41, 0x43, 0x4C, 0x45
            ]
            
            let headerCount =
                isDMX ? dmxHeader.count : generalHeader.count
            
            // 1.3 控制数据包部分
            
            let macAddress =
                remoteMacAddress.components(separatedBy: ".")
            
            let remoteDataLength =
                (isRemote ? (1 + macAddress.count) : 0)
            
            let protocolBaseStructureLength =
                11 + additionalData.count +
                    remoteDataLength + 2
            
            // 总长度
            let length = protocolBaseStructureLength +
                headerCount + sourceIP.count
            
            // =========== 2. 逐个赋值 ===========
            
            var socketData = [UInt8](repeating: 0, count: length)
            
            // 2.1 sourceIP
            var index = 0
            for i in 0 ..< sourceIP.count {
                
                index = i
                socketData[index] = (UInt8(sourceIP[i]) ?? 0)
            }
            
            // 2.2 固定协议头
            for i in 0 ..< headerCount {
                
                index += 1
                socketData[index] =
                    isDMX ? dmxHeader[i] : generalHeader[i]
            }
            
            // 3. Protocol Base Structure 部分
            
            // 0.计算 Protocol Base Structure 的容量大小
            // 本地:(固定部分11 + additionalContentLength + 2个 CRC)
            // 远程:(固定部分11 + additionalContentLength +
            //     (1个标示位 + 8个mac地地址) +  2个 0x00, 0x00)
            
            // 开始代码: 0XAAAA固定
            index += 1
            socketData[index] = 0xAA
            
            index += 1
            socketData[index] = 0xAA
            
            // 数据包的长度 -- 计算(SN2 ~ 10) 不包含开始码 0xAAAA
            index += 1
            socketData[index] =
                UInt8(protocolBaseStructureLength - 2)
            
            // 当前设备(iPhone && iPad)的 子网ID && 设备ID && 设备类型
            index += 1
            socketData[index] = 0xBB
            
            index += 1
            socketData[index] = 0xBB
            
            index += 1
            socketData[index] = 0xCC
            
            index += 1
            socketData[index] = 0xCC
            
            // 操作码
            index += 1
            socketData[index] = UInt8(operatorCode >> 8)
            
            index += 1
            socketData[index] = UInt8(operatorCode & 0xFF)
            
            // 目标设备的子网ID与设备ID
            index += 1
            socketData[index] = subNetID
            
            index += 1
            socketData[index] = deviceID
            
            // 可变参数
            for i in 0 ..< additionalData.count {
                
                index += 1
                socketData[index] = additionalData[i]
            }
            
            // 不同的部分
            if isRemote {
                
                index += 1
                socketData[index] = iOS_flag
                
                for i in 0 ..< macAddress.count {
                    
                    var mac: UInt32 = 0
                    
                    Scanner(string: macAddress[i]
                        ).scanHexInt32(&mac)
                    
                    index += 1
                    socketData[index] = UInt8(mac)
                }
                
                index += 1
                socketData[index] = 0
                
                index += 1
                socketData[index] = 0
                
            } else {
                
                SHSocketTools.pack_crc(
                    position: &socketData[sourceIP.count + headerCount + 2],
                    length: (protocolBaseStructureLength - 2 - 2)
                )
            }
            
            
            let local_send_ip =
                UserDefaults.standard.object(
                    forKey: socketRealIP
                    ) as? String ?? ""
            
            let destAddress =
                isRemote ? ipAddress :
                    (local_send_ip.isEmpty ?
                        localBroadcastAddress : local_send_ip
            )
            
            let port =
                isRemote ? remoteServerPort : localServerPort
            
            return (socketData, destAddress, port)
    }
}


// MARK: - 本地与远程网络判定
extension SHSocketTools {
    
    /// 当前是否使用远程发送数据包的方式
    ///
    /// - Parameter macAddress: RSIP的MAC地址
    /// - Returns: true 使用远程 false 使用本地Wifi
    static func isRemoteControl(_ macAddress: String) -> Bool {
        
        let specifyIP =
            (UserDefaults.standard.object(
                forKey: socketRealIP
                ) as? String) ?? ""
        
        guard specifyIP.isEmpty else {
            
            return false
        }
        
        // 2.判断是否开启了远程
        if !(UserDefaults.standard.bool(forKey: remoteControlKey)) {
            
            return false
        }
        
        // 检测mac地址
        if macAddress.isEmpty {
            return false
        }
        
        // 有mac地址 && 开启了远程
        // 需要查看 wifi 的情况
        
        guard let saveLocalWifi =
            UserDefaults.standard.object(
                forKey: localWifiKey
                ) as? String ,
            
            let currentWifi = UIDevice.getWifiName() else {
                
                return true
        }
        
        return !(saveLocalWifi == currentWifi)
    }
    
    /// 设置本地发送指令使用的wifi
    ///
    /// - Parameter wifi: wifi名称
    /// - Returns: 成功设置
    static func saveLocalSendDataWifi(_ wifi: String) -> Bool {
        
        UserDefaults.standard.set(
            wifi,
            forKey: localWifiKey
        )
        
        return UserDefaults.standard.synchronize()
    }
    
    /// - Returns: wifi名称
    static func localControlWifi() -> String {
        
        return
            (UserDefaults.standard.object(
                forKey: localWifiKey
                ) as? String) ?? ""
    }
}
