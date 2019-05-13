//
//  SHSocketTools + receive.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017 SmartHome. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

// MARK: - GCDAsyncUdpSocketDelegate
extension SHSocketTools: GCDAsyncUdpSocketDelegate {
    
    /// 接收到数据
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        
        // 本机的IP
        let localIP =
            UIDevice.getIPAddress(UIDevice.isIPV6()) ?? ""
        
        // 接收目标的ip
        let formIP =
            GCDAsyncUdpSocket.host(fromAddress: address) ?? ""
        
        if formIP.contains(localIP) {
            
            // print("信息中的内容包含有相同的地址:")
            return
        }
        
        // 解析成数组
        var recivedData = [UInt8](data)
        
        // 数据包的前16个固定字节数(源IP + 协议头 + 开始的操作码 --> 不影响解析，所以去除)
        
        // FIXME: 暂时不进行接收校验
        // 16的是0xAAAA后的位置 SN2
        guard check_crc(position: &(recivedData[16]),
                        length: recivedData.count - 16 - 2

            ) else {

                return
        }

        let subNetID = recivedData[17]
        let deviceID = recivedData[18]
        
        let deviceType: UInt16 =
            (UInt16(recivedData[19]) << 8) |
                (UInt16(recivedData[20]))
        
        let operatorCode: UInt16 =
            (UInt16(recivedData[21]) << 8) |
                (UInt16(recivedData[22]))
        
        
        if operatorCode == 0x000F {
            
            print("为什么收不到广播")
        }
        
        var additionalData = [UInt8]()
    
        // 27是去除可变参数剩余的所有的长度
        let additionalLength = recivedData.count - 27
        
        if additionalLength > 0 {
            let range = 25 ..< (25 + additionalLength)
            additionalData = [UInt8](recivedData[range])
        }
        
        let socketData =
            SHSocketData(operatorCode: operatorCode,
                         subNetID: subNetID,
                         deviceID: deviceID,
                         additionalData: additionalData,
                         deviceType: deviceType
        )
        
        SHSocketTools.removeSocketData(
            socketData: socketData,
            isReceived: true
        )

        let broadcastMessage = [
            SHSocketTools.broadcastNotificationName:
            socketData
        ]
        
        DispatchQueue.main.async {
        
            NotificationCenter.default.post(
                name:NSNotification.Name(rawValue: SHSocketTools.broadcastNotificationName),
                object: nil,
                userInfo: broadcastMessage
            )
        }
    }
    
    /// socket 关闭
    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        
        print("socket已经关闭了")
        sock.setDelegateQueue(DispatchQueue.global())
        sock.setDelegate(self)
        _ = try? sock.enableBroadcast(true)
        _ = try? sock.beginReceiving()
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {

        print("socket成功发送信息")
        _ = try? sock.beginReceiving()
    }
}
