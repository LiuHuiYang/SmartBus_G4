//
//  SHCurrentTransformerChannel.swift
//  Smart-Bus
//
//  Created by Mac on 2018/11/16.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHCurrentTransformerChannel: NSObject {

    /// 名称
    var name: String?
    
    /// 电流大小 mA
    var current: UInt = 0
    
    /// 功率大小 kW
    var power: CGFloat = 0.0
}
