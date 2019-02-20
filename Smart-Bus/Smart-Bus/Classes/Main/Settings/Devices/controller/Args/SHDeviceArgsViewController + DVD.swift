//
//  SHDeviceArgsViewController + DVD.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
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
        
        guard let dvd = self.mediaDVD else {
            return
        }
        
        switch (index) {
            
        case 0:
            dvd.remark = value
            
        case 1:
            dvd.subnetID = UInt8(value) ?? 1
            
        case 2:
            dvd.deviceID = UInt8(value) ?? 0
            
        case 3:
            dvd.universalSwitchIDforOn = UInt(value) ?? 0
            
        case 4:
            dvd.universalSwitchStatusforOn = UInt(value) ?? 0
            
        case 5:
            dvd.universalSwitchIDforOff = UInt(value) ?? 0
            
        case 6:
            dvd.universalSwitchStatusforOff = UInt(value) ?? 0
            
        case 7:
            dvd.universalSwitchIDfoMenu = UInt(value) ?? 0
            
        case 8:
            dvd.universalSwitchIDfoUp = UInt(value) ?? 0
            
        case 9:
            dvd.universalSwitchIDforDown = UInt(value) ?? 0
            
        case 10:
            dvd.universalSwitchIDforFastForward = UInt(value) ?? 0
            
        case 11:
            dvd.universalSwitchIDforBackForward = UInt(value) ?? 0
            
        case 12:
            dvd.universalSwitchIDforOK = UInt(value) ?? 0
            
        case 13:
            dvd.universalSwitchIDforPREVChapter = UInt(value) ?? 0
            
        case 14:
            dvd.universalSwitchIDforNextChapter = UInt(value) ?? 0
            
        case 15:
            dvd.universalSwitchIDforPlayPause = UInt(value) ?? 0
            
        case 16:
            dvd.universalSwitchIDforPlayRecord = UInt(value) ?? 0
            
        case 17:
            dvd.universalSwitchIDforPlayStopRecord = UInt(value) ?? 0
            
        case 18:
            dvd.iRMacroNumberForDVDStart0 = UInt(value) ?? 0
            
        case 19:
            dvd.iRMacroNumberForDVDStart1 = UInt(value) ?? 0
            
        case 20:
            dvd.iRMacroNumberForDVDStart2 = UInt(value) ?? 0
            
        case 21:
            dvd.iRMacroNumberForDVDStart3 = UInt(value) ?? 0
            
        case 22:
            dvd.iRMacroNumberForDVDStart4 = UInt(value) ?? 0
            
        case 23:
            dvd.iRMacroNumberForDVDStart5 = UInt(value) ?? 0
            
        default:
            break
        }
         
        _ = SHSQLiteManager.shared.updateDVD(dvd)
    }
}
