//
//  SHDeviceArgsViewController + TV.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - TV
extension SHDeviceArgsViewController {
    
    /// 刷新电视
    func refreshMediaTV() {
        
        argsNames = [
            "TV Name",
            "Subnet ID",
            "Device ID",
            
            "turnOn ID",
            "StatusforOn",
            "turnOff ID",
            "StatusforOff",
            
            "CH+",
            "CH-",
            "V+",
            "V-",
            
            "Mute",
            "Menu",
            "Source",
            "OK",
            
            "Number_0",
            "Number_1",
            "Number_2",
            "Number_3",
            "Number_4",
            "Number_5",
            "Number_6",
            "Number_7",
            "Number_8",
            "Number_9",
            
            "IRReserved_0",
            "IRReserved_1",
            "IRReserved_2",
            "IRReserved_3",
            "IRReserved_4",
            "IRReserved_5"
        ]
        
        argsValues = [
            
            mediaTV?.remark ?? "tv",
            "\(mediaTV?.subnetID ?? 1)",
            "\(mediaTV?.deviceID ?? 0)",
            
            "\(mediaTV?.universalSwitchIDforOn ?? 0)",
            "\(mediaTV?.universalSwitchStatusforOn ?? 0)",
            "\(mediaTV?.universalSwitchIDforOff ?? 0)",
            "\(mediaTV?.universalSwitchStatusforOff ?? 0)",
            
            "\(mediaTV?.universalSwitchIDforCHAdd ?? 0)",
            "\(mediaTV?.universalSwitchIDforCHMinus ?? 0)",
            "\(mediaTV?.universalSwitchIDforVOLUp ?? 0)",
            "\(mediaTV?.universalSwitchIDforVOLDown ?? 0)",
            
            "\(mediaTV?.universalSwitchIDforMute ?? 0)",
            "\(mediaTV?.universalSwitchIDforMenu ?? 0)",
            "\(mediaTV?.universalSwitchIDforSource ?? 0)",
            "\(mediaTV?.universalSwitchIDforOK ?? 0)",
            
            "\(mediaTV?.universalSwitchIDfor0 ?? 0)",
            "\(mediaTV?.universalSwitchIDfor1 ?? 0)",
            "\(mediaTV?.universalSwitchIDfor2 ?? 0)",
            "\(mediaTV?.universalSwitchIDfor3 ?? 0)",
            "\(mediaTV?.universalSwitchIDfor4 ?? 0)",
            "\(mediaTV?.universalSwitchIDfor5 ?? 0)",
            "\(mediaTV?.universalSwitchIDfor6 ?? 0)",
            "\(mediaTV?.universalSwitchIDfor7 ?? 0)",
            "\(mediaTV?.universalSwitchIDfor8 ?? 0)",
            "\(mediaTV?.universalSwitchIDfor9 ?? 0)",
            
            "\(mediaTV?.iRMacroNumberForTVStart0 ?? 0)",
            "\(mediaTV?.iRMacroNumberForTVStart1 ?? 0)",
            "\(mediaTV?.iRMacroNumberForTVStart2 ?? 0)",
            "\(mediaTV?.iRMacroNumberForTVStart3 ?? 0)",
            "\(mediaTV?.iRMacroNumberForTVStart4 ?? 0)",
            "\(mediaTV?.iRMacroNumberForTVStart5 ?? 0)"
        ]
    }
    
    func updateMediaTV(value: String, index: Int) {
        
        guard let tv = self.mediaTV else {
            return
        }
        
        switch (index) {
            
        case 0:
            tv.remark = value
            
        case 1:
            tv.subnetID =  UInt8(value) ?? 0
            
        case 2:
            tv.deviceID = UInt8(value) ?? 0
            
        case 3:
            tv.universalSwitchIDforOn = UInt(value) ?? 0
            
        case 4:
            tv.universalSwitchStatusforOn = UInt(value) ?? 0
            
        case 5:
            tv.universalSwitchIDforOff = UInt(value) ?? 0
            
        case 6:
            tv.universalSwitchStatusforOff = UInt(value) ?? 0
            
        case 7:
            tv.universalSwitchIDforCHAdd = UInt(value) ?? 0
            
        case 8:
            tv.universalSwitchIDforCHMinus = UInt(value) ?? 0
            
        case 9:
            tv.universalSwitchIDforVOLUp = UInt(value) ?? 0
            
        case 10:
            tv.universalSwitchIDforVOLDown = UInt(value) ?? 0
            
        case 11:
            tv.universalSwitchIDforMute = UInt(value) ?? 0
            
        case 12:
            tv.universalSwitchIDforMenu = UInt(value) ?? 0
            
        case 13:
            tv.universalSwitchIDforSource = UInt(value) ?? 0
            
        case 14:
            tv.universalSwitchIDforOK = UInt(value) ?? 0
            
        case 15:
            tv.universalSwitchIDfor0 = UInt(value) ?? 0
            
        case 16:
            tv.universalSwitchIDfor1 = UInt(value) ?? 0
            
        case 17:
            tv.universalSwitchIDfor2 = UInt(value) ?? 0
            
        case 18:
            tv.universalSwitchIDfor3 = UInt(value) ?? 0
            
        case 19:
            tv.universalSwitchIDfor4 = UInt(value) ?? 0
            
        case 20:
            tv.universalSwitchIDfor5 = UInt(value) ?? 0
            
        case 21:
            tv.universalSwitchIDfor6 = UInt(value) ?? 0
            
        case 22:
            tv.universalSwitchIDfor7 = UInt(value) ?? 0
            
        case 23:
            tv.universalSwitchIDfor8 = UInt(value) ?? 0
            
        case 24:
            tv.universalSwitchIDfor9 = UInt(value) ?? 0
            
        case 25:
            tv.iRMacroNumberForTVStart0 = UInt(value) ?? 0
            
        case 26:
            tv.iRMacroNumberForTVStart1 = UInt(value) ?? 0
            
        case 27:
            tv.iRMacroNumberForTVStart2 = UInt(value) ?? 0
            
        case 28:
            tv.iRMacroNumberForTVStart3 = UInt(value) ?? 0
            
        case 29:
            tv.iRMacroNumberForTVStart4 =  UInt(value) ?? 0
            
        case 30:
            tv.iRMacroNumberForTVStart5 = UInt(value) ?? 0
            
        default:
            break
        } 
        
        _ = SHSQLiteManager.shared.updateTV(tv)
    }
}
