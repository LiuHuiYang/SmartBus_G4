//
//  SHLight.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/16.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

/// 区域控制的灯的能否调光的类型 // 数据库中的 canDim值
@objc enum SHZoneControlLightCanDimType: UInt8 {
    case notDimmable        //  不可以调光 - 继电器模块
    case dimmable           // 可以调光
    case led                // LED 类型
    case pushOnReleaseOff   // 按住开，松开关。
    case universalSwitch    // 通用开关类型。
}

/// 区域控制的灯类型
@objc enum SHZoneControlLightType: UInt8 {
    
    case incandescent = 1 // 白织炮，像灯泡哪样的
    case spotlight    = 2 // 聚光灯
    case fluorescent  = 3 // 灯管样式的灯泡，只能开和关的哪一种
    case chandelier   = 4 // 吊灯
    case deskLight    = 5 // 台灯
    case led          = 6 // LED
}

/// LED中每个颜色通道的编号
@objc enum SHZoneControllightLEDChannel: UInt8 {
    
    case red   = 49
    case green = 50
    case blue  = 51
    case white = 52
}

@objcMembers class SHLight: NSObject {

    // MARK: - Schedual部分　增加的属性
    
    /// 启动配置计划
    var schedualEnable = false
    
    /// 计划执行的LED颜色
    var schedualRedColor: UInt8 = 0
    
    /// 计划执行的LED颜色
    var schedualGreenColor: UInt8 = 0
    
    /// 计划执行的LED颜色
    var schedualBlueColor: UInt8 = 0
    
    /// 计划执行的LED颜色
    var schedualWhiteColor: UInt8 = 0
    
    /// 计划执行的亮度
    var schedualBrightness: UInt8 = 0
    
    // MARK : -----------------------------------
    
    /// 录制状态标示
    var recordSuccess = false
    
    /// 亮度值： - 这是为了保存方便【没有存储在数据库当中】
    var brightness: UInt8 = 0
    
    /// LED 有颜色
    var ledHaveColor = false
    
    /// LED的red
    var redColorValue: UInt8 = 0
    
    /// LED的green
    var greenColorValue: UInt8 = 0
    
    /// LED的blue
    var blueColorValue: UInt8 = 0
    
    /// LED的white
    var whiteColorValue: UInt8 = 0
    
    /// 是否需要解析EFFF(YES - 不需要 NO 需要)
    var isUnwantedEFFF = false
    
    // MARK： - 数据库中的值
    
    /// 主键
    var id: UInt = 0
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 灯泡ID
    var lightID: UInt = 0
    
    /// 灯泡备注
    var lightRemark = ""
    
    /// 灯泡子网ID
    var subnetID: UInt8 = 0
    
    /// 灯泡设备ID
    var deviceID: UInt8 = 0
    
    /// 灯泡通道
    var channelNo: UInt8 = 0
    
    /// 灯泡canDim
    var canDim: SHZoneControlLightCanDimType = .notDimmable
    
    /// 灯泡类型
    var lightTypeID: SHZoneControlLightType = .incandescent {
        
        didSet {
            
            if lightTypeID.rawValue == 0 {
                lightTypeID = .incandescent
            }
        }
    }
    
    /// 红外码 开
    var switchOn: UInt8 = 0
    
    /// 红外码 关
    var switchOff: UInt8 = 0
    
    /// 不同类型ID的图片名称
    class func lightImageName(lightTypeID: SHZoneControlLightType) -> String {
        
        switch lightTypeID {
        case .led:
            return "LED"
            
        case .deskLight:
            return "desklight"
            
        case .chandelier:
            return "chandelier"
            
        case .fluorescent:
            return "fluorescent"
            
        case .spotlight:
            return "spotlight"
            
        case .incandescent:
            return "incandescent"
         
        }
    }
    
    override init() {
        super.init()
    }
    
    init(dictionary: [String: Any]) {
        super.init()
        setValuesForKeys(dictionary)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "ID" {
            self.id = value as? UInt ?? 0
        }
    }
}
