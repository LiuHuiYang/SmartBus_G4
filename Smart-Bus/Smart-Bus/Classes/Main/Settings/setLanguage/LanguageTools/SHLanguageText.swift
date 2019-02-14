//
//  SHLanguageText.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/11/30.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHLanguageText: NSObject {

//    static let shared = SHLanguageText()
    
    /// 开
    class var on: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "PUBLIC",
                    withSubTitle: "ON")
                ) as! String
    }
    
    /// 关
    class var off: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "PUBLIC",
                    withSubTitle: "OFF")
                ) as! String
    }
    
    /// yes
    class var yes: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "PUBLIC",
                    withSubTitle: "YES")
                ) as! String
    }
    
    /// no
    class var no: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "PUBLIC",
                    withSubTitle: "NO")
                ) as! String
    }
    
    /// 完成
    class var done: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "PUBLIC",
                    withSubTitle: "DONE")
                ) as! String
    }
    
    /// 菜单
    class var menu: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "MEDIA_IN_ZONE",
                    withSubTitle: "MENU")
                ) as! String
    }
    
    /// ok
    class var ok: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "PUBLIC",
                    withSubTitle: "OK")
                ) as! String
    }
    
    /// cancel
    class var cancel: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "PUBLIC",
                    withSubTitle: "CANCEL")
                ) as! String
    }
    
    /// 没有数据
    class var noData: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "PUBLIC",
                    withSubTitle: "NO_DATA"
                )) as! String
    }
    
    /// 编辑
    class var edit: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "PUBLIC",
                    withSubTitle: "EDIT")
                ) as! String
    }
    
    /// 删除
    class var delete: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "RECORD",
                    withSubTitle: "DELETE")
                ) as! String
    }
    
    /// 保存
    class var save: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "PUBLIC",
                    withSubTitle: "SAVE")
                ) as! String
    }
    
    /// 已经保存
    class var saved: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "PUBLIC",
                    withSubTitle: "SAVED")
                ) as! String
    }
    
    // MARK: -  窗帘部分
    
    /// 窗帘开启
    class var shadeOpen: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SHADE_IN_ZONE",
                    withSubTitle: "SHADE_OPE")
                ) as! String
    }
    
    /// 窗帘关闭
    class var shadeClose: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SHADE_IN_ZONE",
                    withSubTitle: "SHADE_CLOSE")
                ) as! String
    }
    
    /// 窗帘停止
    class var shadeStop: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SHADE_IN_ZONE",
                    withSubTitle: "SHADE_STOP")
                ) as! String
    }
    
    /// 窗帘忽略
    class var shadeIgnore: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                "MOOD_IN_ZONE",
                withSubTitle: "SHADE_BYPASS")
            ) as! String
    }
    
    /// 窗帘指令执行完成
    class var shadeExecuted: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SHADE_IN_ZONE",
                    withSubTitle: "EXECUTED")
                ) as! String
    }
    
    // MARK: -  多媒体部分
    
    /// 资源
    class var source: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "MEDIA_IN_ZONE",
                    withSubTitle: "SOURCE")
                ) as! String
    }
    
    /// 控制
    class var control: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "MEDIA_IN_ZONE",
                    withSubTitle: "CONTROL")
                ) as! String
    }
    
    /// 数字键盘
    class var numberPad: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "MEDIA_IN_ZONE",
                    withSubTitle: "NUM_PAD")
                ) as! String
    }
    
    /// 数字键盘
    class var add: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "MEDIA_IN_ZONE",
                    withSubTitle: "ADD")
                ) as! String
    }
    
    /// 频道
    class var channel: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "MEDIA_IN_ZONE",
                    withSubTitle: "CHANNEL")
                ) as! String
    }
    
    /// 频道
    class var mute: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "MEDIA_IN_ZONE",
                    withSubTitle: "MUTE")
                ) as! String
    }
    
    
    // MARK: - 安防区域
    
    /// 安防标题
    class var securityTitle: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SECURITY",
                    withSubTitle: "TITLE_NAME")
                ) as! String
    }
    
    /// 离开
    class var securityAway: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SECURITY",
                    withSubTitle: "MODE_BUTTON_NAME")
                as![String])[0]
    }
    
    /// 夜晚
    class var securityNight: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SECURITY",
                    withSubTitle: "MODE_BUTTON_NAME")
                as![String])[1]
    }
    
    /// 晚上预约
    class var securityNightGeust: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SECURITY",
                    withSubTitle: "MODE_BUTTON_NAME")
                as![String])[2]
    }
    
    /// 白天
    class var securityDay: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SECURITY",
                    withSubTitle: "MODE_BUTTON_NAME")
                as![String])[3]
    }
    
    /// 假期
    class var securityVacation: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SECURITY",
                    withSubTitle: "MODE_BUTTON_NAME")
                as![String])[4]
    }
    
    /// 愉快
    class var securityDisarm: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SECURITY",
                    withSubTitle: "MODE_BUTTON_NAME")
                as![String])[5]
    }
    
    /// 报警
    class var securityPanic: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SECURITY",
                    withSubTitle: "MODE_BUTTON_NAME")
                as![String])[6]
    }
    
    /// 急救
    class var securityAmbulance: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SECURITY",
                    withSubTitle: "MODE_BUTTON_NAME")
                as![String])[7]
    }
    
    
    // MARK: - Schedual 部分
    
    /// 计划名称
    class var schedualName: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SCHEDULE",
                    withSubTitle: "SCHEDULE_NAME")
                ) as! String
    }
    
    /// 计划声音
    class var schedualSound: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SCHEDULE",
                    withSubTitle: "ALARM_CLOCK_BELL")
                ) as! String
    }
    
    /// 新增计划
    class var newSchedual: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SCHEDULE",
                    withSubTitle: "ADD_NEW_SCHEDULE")
                ) as! String
    }
    
    /// 编辑计划
    class var editSchedual: String {
        
        return (SHLanguageTools.share()?.getTextFromPlist(
                    "SCHEDULE",
                    withSubTitle: "EDIT_SCHEDULE")
                ) as! String
    }
    
    /// 控制区域
    class var controlZone: String {
        
        return SHLanguageTools.share()?.getTextFromPlist(
                    "Z_AUDIO",
                    withSubTitle: "ZONE_LIST"
            ) as! String
    }
    
    /// 控制类别
    class var controlItem: String {
        
        return SHLanguageTools.share()?.getTextFromPlist(
                    "SCHEDULE",
                    withSubTitle: "CONTROLLED_ITEM"
            ) as! String
    }
    
    /// 执行频率
    class var frequency: String {
        
        return SHLanguageTools.share()?.getTextFromPlist(
            "SCHEDULE",
            withSubTitle: "FREQUENCY"
            ) as! String
    }
    
    /// 执行一次
    class var frequencyOnce: String {
        
        return SHLanguageTools.share()?.getTextFromPlist(
                    "SCHEDULE",
                    withSubTitle: "ONE_TIME"
            ) as! String
    }
    
    /// 每天
    class var frequencyDaily: String {
        
        return SHLanguageTools.share()?.getTextFromPlist(
            "SCHEDULE",
            withSubTitle: "DAILY"
            ) as! String
    }
    
    /// 按星期
    class var frequencyWeekly: String {
        
        return SHLanguageTools.share()?.getTextFromPlist(
            "SCHEDULE",
            withSubTitle: "WEEKLY"
            ) as! String
    }
}
