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
        
        switch (index) {
            
        case 0:
            self.mediaTV?.remark = value
            
        case 1:
            self.mediaTV?.subnetID =  UInt8(value) ?? 0
            
        case 2:
            self.mediaTV?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.mediaTV?.universalSwitchIDforOn = UInt(value) ?? 0
            
        case 4:
            self.mediaTV?.universalSwitchStatusforOn = UInt(value) ?? 0
            
        case 5:
            self.mediaTV?.universalSwitchIDforOff = UInt(value) ?? 0
            
        case 6:
            self.mediaTV?.universalSwitchStatusforOff = UInt(value) ?? 0
            
        case 7:
            self.mediaTV?.universalSwitchIDforCHAdd = UInt(value) ?? 0
            
        case 8:
            self.mediaTV?.universalSwitchIDforCHMinus = UInt(value) ?? 0
            
        case 9:
            self.mediaTV?.universalSwitchIDforVOLUp = UInt(value) ?? 0
            
        case 10:
            self.mediaTV?.universalSwitchIDforVOLDown = UInt(value) ?? 0
            
        case 11:
            self.mediaTV?.universalSwitchIDforMute = UInt(value) ?? 0
            
        case 12:
            self.mediaTV?.universalSwitchIDforMenu = UInt(value) ?? 0
            
        case 13:
            self.mediaTV?.universalSwitchIDforSource = UInt(value) ?? 0
            
        case 14:
            self.mediaTV?.universalSwitchIDforOK = UInt(value) ?? 0
            
        case 15:
            self.mediaTV?.universalSwitchIDfor0 = UInt(value) ?? 0
            
        case 16:
            self.mediaTV?.universalSwitchIDfor1 = UInt(value) ?? 0
            
        case 17:
            self.mediaTV?.universalSwitchIDfor2 = UInt(value) ?? 0
            
        case 18:
            self.mediaTV?.universalSwitchIDfor3 = UInt(value) ?? 0
            
        case 19:
            self.mediaTV?.universalSwitchIDfor4 = UInt(value) ?? 0
            
        case 20:
            self.mediaTV?.universalSwitchIDfor5 = UInt(value) ?? 0
            
        case 21:
            self.mediaTV?.universalSwitchIDfor6 = UInt(value) ?? 0
            
        case 22:
            self.mediaTV?.universalSwitchIDfor7 = UInt(value) ?? 0
            
        case 23:
            self.mediaTV?.universalSwitchIDfor8 = UInt(value) ?? 0
            
        case 24:
            self.mediaTV?.universalSwitchIDfor9 = UInt(value) ?? 0
            
        case 25:
            self.mediaTV?.iRMacroNumberForTVStart0 = UInt(value) ?? 0
            
        case 26:
            self.mediaTV?.iRMacroNumberForTVStart1 = UInt(value) ?? 0
            
        case 27:
            self.mediaTV?.iRMacroNumberForTVStart2 = UInt(value) ?? 0
            
        case 28:
            self.mediaTV?.iRMacroNumberForTVStart3 = UInt(value) ?? 0
            
        case 29:
            self.mediaTV?.iRMacroNumberForTVStart4 =  UInt(value) ?? 0
            
        case 30:
            self.mediaTV?.iRMacroNumberForTVStart5 = UInt(value) ?? 0
            
        default:
            break
        }
        
        SHSQLManager.share()?.updateMediaTV(inZone: mediaTV)
    }
}
