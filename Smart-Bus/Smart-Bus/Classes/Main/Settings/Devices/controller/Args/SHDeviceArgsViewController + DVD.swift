//
//  SHDeviceArgsViewController + DVD.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - DVD
extension SHDeviceArgsViewController {
    
    /// 刷新DVD
    func refreshMediaDVD() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            
            "turnOn ID",
            "StatusforOn",
            "turnOff ID",
            "StatusforOff",
            
            "Menu",
            "turn Up",
            "turn Down",
            "FastForward",
            "BackForward",
            "OK",
            "PrevChapter",
            "NextChapter",
            "Pause",
            
            "Record",
            "StopRecord",
            
            "IRReserved_0",
            "IRReserved_1",
            "IRReserved_2",
            "IRReserved_3",
            "IRReserved_4",
            "IRReserved_5"
        ]
        
        argsValues = [
            
            mediaDVD?.remark ?? "DVD",
            "\(mediaDVD?.subnetID ?? 1)",
            "\(mediaDVD?.deviceID ?? 0)",
            
            "\(mediaDVD?.universalSwitchIDforOn ?? 0)",
            "\(mediaDVD?.universalSwitchStatusforOn ?? 0)",
            "\(mediaDVD?.universalSwitchIDforOff ?? 0)",
            "\(mediaDVD?.universalSwitchStatusforOff ?? 0)",
            
            "\(mediaDVD?.universalSwitchIDfoMenu ?? 0)",
            "\(mediaDVD?.universalSwitchIDfoUp ?? 0)",
            "\(mediaDVD?.universalSwitchIDforDown ?? 0)",
            "\(mediaDVD?.universalSwitchIDforFastForward ?? 0)",
            "\(mediaDVD?.universalSwitchIDforBackForward ?? 0)",
            "\(mediaDVD?.universalSwitchIDforOK ?? 0)",
            "\(mediaDVD?.universalSwitchIDforPREVChapter ?? 0)",
            "\(mediaDVD?.universalSwitchIDforNextChapter ?? 0)",
            "\(mediaDVD?.universalSwitchIDforPlayPause ?? 0)",
            "\(mediaDVD?.universalSwitchIDforPlayRecord ?? 0)",
            "\(mediaDVD?.universalSwitchIDforPlayStopRecord ?? 0)",
            "\(mediaDVD?.universalSwitchStatusforOff ?? 0)",
            
            "\(mediaDVD?.iRMacroNumberForDVDStart0 ?? 0)",
            "\(mediaDVD?.iRMacroNumberForDVDStart1 ?? 0)",
            "\(mediaDVD?.iRMacroNumberForDVDStart2 ?? 0)",
            "\(mediaDVD?.iRMacroNumberForDVDStart3 ?? 0)",
            "\(mediaDVD?.iRMacroNumberForDVDStart4 ?? 0)",
            "\(mediaDVD?.iRMacroNumberForDVDStart5 ?? 0)"
        ]
    }
    
    /// 更新DVD
    func updateMediaDVD(value: String, index: Int) {
        
        switch (index) {
            
        case 0:
            self.mediaDVD?.remark = value
            
        case 1:
            self.mediaDVD?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.mediaDVD?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.mediaDVD?.universalSwitchIDforOn = UInt(value) ?? 0
            
        case 4:
            self.mediaDVD?.universalSwitchStatusforOn = UInt(value) ?? 0
            
        case 5:
            self.mediaDVD?.universalSwitchIDforOff = UInt(value) ?? 0
            
        case 6:
            self.mediaDVD?.universalSwitchStatusforOff = UInt(value) ?? 0
            
        case 7:
            self.mediaDVD?.universalSwitchIDfoMenu = UInt(value) ?? 0
            
        case 8:
            self.mediaDVD?.universalSwitchIDfoUp = UInt(value) ?? 0
            
        case 9:
            self.mediaDVD?.universalSwitchIDforDown = UInt(value) ?? 0
            
        case 10:
            self.mediaDVD?.universalSwitchIDforFastForward = UInt(value) ?? 0
            
        case 11:
            self.mediaDVD?.universalSwitchIDforBackForward = UInt(value) ?? 0
            
        case 12:
            self.mediaDVD?.universalSwitchIDforOK = UInt(value) ?? 0
            
        case 13:
            self.mediaDVD?.universalSwitchIDforPREVChapter = UInt(value) ?? 0
            
        case 14:
            self.mediaDVD?.universalSwitchIDforNextChapter = UInt(value) ?? 0
            
        case 15:
            self.mediaDVD?.universalSwitchIDforPlayPause = UInt(value) ?? 0
            
        case 16:
            self.mediaDVD?.universalSwitchIDforPlayRecord = UInt(value) ?? 0
            
        case 17:
            self.mediaDVD?.universalSwitchIDforPlayStopRecord = UInt(value) ?? 0
            
        case 18:
            self.mediaDVD?.iRMacroNumberForDVDStart0 = UInt(value) ?? 0
            
        case 19:
            self.mediaDVD?.iRMacroNumberForDVDStart1 = UInt(value) ?? 0
            
        case 20:
            self.mediaDVD?.iRMacroNumberForDVDStart2 = UInt(value) ?? 0
            
        case 21:
            self.mediaDVD?.iRMacroNumberForDVDStart3 = UInt(value) ?? 0
            
        case 22:
            self.mediaDVD?.iRMacroNumberForDVDStart4 = UInt(value) ?? 0
            
        case 23:
            self.mediaDVD?.iRMacroNumberForDVDStart5 = UInt(value) ?? 0
            
        default:
            break
        }
        
        SHSQLManager.share()?.updateMediaDVD(inZone: mediaDVD)
    }
}
