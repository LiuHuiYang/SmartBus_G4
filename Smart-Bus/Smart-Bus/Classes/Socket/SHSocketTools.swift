//
//  SHSocketTools.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017 SmartHome. All rights reserved.
//

import UIKit
import CocoaAsyncSocket


/// 广播接收数据代理
@objc protocol SHSocketToolsReceiveDataProtocol {
  
    @objc optional func receiveData(_ socketData: SHSocketData)
}


/// SHSocketTools
@objcMembers class SHSocketTools: NSObject {
    
    // MARK: - 单例
    
//    /// 单例对象
//    private static var shareInstance: SHSocketTools?
//
//    /// 创建单例对象
//    ///
//    /// - Returns: 单例
//    static func shared() -> SHSocketTools {
//
//        guard let instance = shareInstance else {
//
//            shareInstance = SHSocketTools()
//
//            return shareInstance!
//        }
//
//        return instance
//    }
//
//    /// 销毁单例对象
//    static func destroy() {
//
//        shareInstance = nil
//    }
//
//    private override init() {
//
//    }
//
//    deinit {
//
//        socket?.close()
//        socket = nil
//    }
    
    
    /// 代理
    weak var delegate: SHSocketToolsReceiveDataProtocol?
    
    /// 单例对象
    static let shared = SHSocketTools()
    
    /// 发送数据包缓存
    static let caches = NSCache<AnyObject, AnyObject>()
    
    /// 开始重发
    static var startToReSend = false
     
    
    /// 重发缓存数据
    var cacheData = [SHSocketData]()
    
    /// UDP 广播通知
    static let broadcastNotificationName = "socketBroadcastNotification"
    
    /// socket对象
    lazy var socket: GCDAsyncUdpSocket? = setupSocket()
    
    /// 接收线程的queue
    static let reciveQueue = DispatchQueue.init(label: "recive")
    
    /// 重发线程的queue
    let repeatQueue =
        DispatchQueue.init(label: "repeat")
    
    /// 创建socket
    func setupSocket() -> GCDAsyncUdpSocket? {
     
        let udpSocket =
            GCDAsyncUdpSocket(
                delegate: self,
                delegateQueue: DispatchQueue.global() //SHSocketTools.reciveQueue
        )
        
        do {
            
            try udpSocket.enableBroadcast(true)
//            try udpSocket.beginReceiving()
            
        } catch {
            
            SVProgressHUD.showError(withStatus:
                "socket init error"
            )
            print("收到错误信息: \(error)")
            udpSocket.close()
        }
        
        return udpSocket
    }
}
