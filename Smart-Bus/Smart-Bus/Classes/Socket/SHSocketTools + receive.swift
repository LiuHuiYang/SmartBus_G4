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
        
         
        //        guard let host = GCDAsyncUdpSocket.host(fromAddress: address),
        //            let localIP = UIDevice.getIPAddress(UIDevice.isIPV6()),
        //            host.contains(localIP) == false else {
        //
        //            print("包含了 不要接收 ")
        //            return
        //        }
        //
        //        // 当前地址local:
        //        print("host: \(host), local: \(localIP)")
        
        // 解析成数组
        var recivedData = [UInt8](data)
        
        // 数据包的前16个固定字节数(源IP + 协议头 + 开始的操作码 --> 不影响解析，所以去除)
        
        // 16的是0xAAAA后的位置 SN2
        guard SHSocketTools.check_crc(position: &(recivedData[16]),
                                      length: recivedData.count - 16 - 2

            ) else {

            return
        }
        
//        if recivedData[22] == 0x32{
//            print("收到的广播: \(recivedData) \(Thread.current) \n 亮度: \(recivedData[27])")
//        }
        
        
        let subNetID = recivedData[17]
        let deviceID = recivedData[18]
        
        let deviceType: UInt16 =
            (UInt16(recivedData[19]) << 8) |
                (UInt16(recivedData[20]))
        
        let operatorCode: UInt16 =
            (UInt16(recivedData[21]) << 8) |
                (UInt16(recivedData[22]))
        
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
        
//        print("1111 socket 关闭")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        
//        print("成功发送信息 是否关闭 \(sock.isClosed())")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        
//        if error != nil {
//            print("发送失败代理回调 \(error!)")
//        }
    }
}
