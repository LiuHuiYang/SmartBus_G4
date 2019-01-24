//
//  SHDeviceArgsViewController + SAT.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - SAT.
extension SHDeviceArgsViewController {
    
    /// 刷新SAT.
    func refreshMediaSAT() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            
            "turnOn ID",
            "StatusforOn",
            "turnOff ID",
            "StatusforOff",
            
            "turn Up",
            "turn Down",
            "turn Left",
            "turn Right",
            "OK",
            "Menu",
            "FAV",
            
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
            
            "PrevChapter",
            "NextChapter",
            
            "Record",
            "StopRecord",
            
            "IRReserved_0",
            "IRReserved_1",
            "IRReserved_2",
            "IRReserved_3",
            "IRReserved_4",
            "IRReserved_5",
            
            "Control_1 Name",
            "Control_1 commandID",
            "Control_2 Name",
            "Control_2 commandID",
            "Control_3 Name",
            "Control_3 commandID",
            "Control_4 Name",
            "Control_4 commandID",
            "Control_5 Name",
            "Control_5 commandID",
            "Control_6 Name",
            "Control_6 commandID"
        ]
        
        argsValues = [
            mediaSAT?.remark ?? "sat.",
            "\(mediaSAT?.subnetID ?? 1)",
            "\(mediaSAT?.deviceID ?? 0)",
            
            "\(mediaSAT?.universalSwitchIDforOn ?? 0)",
            "\(mediaSAT?.universalSwitchStatusforOn ?? 0)",
            "\(mediaSAT?.universalSwitchIDforOff ?? 0)",
            "\(mediaSAT?.universalSwitchStatusforOff ?? 0)",
            
            "\(mediaSAT?.universalSwitchIDforUp ?? 0)",
            "\(mediaSAT?.universalSwitchIDforDown ?? 0)",
            "\(mediaSAT?.universalSwitchIDforLeft ?? 0)",
            "\(mediaSAT?.universalSwitchIDforRight ?? 0)",
            "\(mediaSAT?.universalSwitchIDforOK ?? 0)",
            "\(mediaSAT?.universalSwitchIDfoMenu ?? 0)",
            "\(mediaSAT?.universalSwitchIDforFAV ?? 0)",
            
            "\(mediaSAT?.universalSwitchIDfor0 ?? 0)",
            "\(mediaSAT?.universalSwitchIDfor1 ?? 0)",
            "\(mediaSAT?.universalSwitchIDfor2 ?? 0)",
            "\(mediaSAT?.universalSwitchIDfor3 ?? 0)",
            "\(mediaSAT?.universalSwitchIDfor4 ?? 0)",
            "\(mediaSAT?.universalSwitchIDfor5 ?? 0)",
            "\(mediaSAT?.universalSwitchIDfor6 ?? 0)",
            "\(mediaSAT?.universalSwitchIDfor7 ?? 0)",
            "\(mediaSAT?.universalSwitchIDfor8 ?? 0)",
            "\(mediaSAT?.universalSwitchIDfor9 ?? 0)",
            
            "\(mediaSAT?.universalSwitchIDforPREVChapter ?? 0)",
            "\(mediaSAT?.universalSwitchIDforNextChapter ?? 0)",
            "\(mediaSAT?.universalSwitchIDforPlayRecord ?? 0)",
            "\(mediaSAT?.universalSwitchIDforPlayStopRecord ?? 0)",
            
            "\(mediaSAT?.iRMacroNumberForSATSpare0 ?? 0)",
            "\(mediaSAT?.iRMacroNumberForSATSpare1 ?? 0)",
            "\(mediaSAT?.iRMacroNumberForSATSpare2 ?? 0)",
            "\(mediaSAT?.iRMacroNumberForSATSpare3 ?? 0)",
            "\(mediaSAT?.iRMacroNumberForSATSpare4 ?? 0)",
            "\(mediaSAT?.iRMacroNumberForSATSpare5 ?? 0)",
            
            "\(mediaSAT?.switchNameforControl1 ?? "C1")",
            "\(mediaSAT?.switchIDforControl1 ?? 0)",
            "\(mediaSAT?.switchNameforControl2 ?? "C2")",
            "\(mediaSAT?.switchIDforControl2 ?? 0)",
            "\(mediaSAT?.switchNameforControl3 ?? "C3")",
            "\(mediaSAT?.switchIDforControl3 ?? 0)",
            "\(mediaSAT?.switchNameforControl4 ?? "C4")",
            "\(mediaSAT?.switchIDforControl4 ?? 0)",
            "\(mediaSAT?.switchNameforControl5 ?? "C5")",
            "\(mediaSAT?.switchIDforControl5 ?? 0)",
            "\(mediaSAT?.switchNameforControl6 ?? "C6")",
            "\(mediaSAT?.switchIDforControl6 ?? 0)"
        ]
    }
    
    /// 保存sat.
    func updateMediaSAT(value: String, index: Int) {
        
        guard let sat = self.mediaSAT else {
            return
        }
        
        switch (index) {
            
        case 0:
            sat.remark = value
            
        case 1:
            sat.subnetID = UInt8(value) ?? 1
            
        case 2:
            sat.deviceID = UInt8(value) ?? 0
            
        case 3:
            sat.universalSwitchIDforOn = UInt(value) ?? 0
            
        case 4:
            sat.universalSwitchStatusforOn = UInt(value) ?? 0
            
        case 5:
            sat.universalSwitchIDforOff = UInt(value) ?? 0
            
        case 6:
            sat.universalSwitchStatusforOff = UInt(value) ?? 0
            
        case 7:
            sat.universalSwitchIDforUp = UInt(value) ?? 0
            
        case 8:
            sat.universalSwitchIDforDown = UInt(value) ?? 0
            
        case 9:
            sat.universalSwitchIDforLeft = UInt(value) ?? 0
            
        case 10:
            sat.universalSwitchIDforRight = UInt(value) ?? 0
        
        case 11:
            sat.universalSwitchIDforOK = UInt(value) ?? 0
            
        case 12:
            sat.universalSwitchIDfoMenu = UInt(value) ?? 0
            
        case 13:
            sat.universalSwitchIDforFAV = UInt(value) ?? 0
            
        case 14:
            sat.universalSwitchIDfor0 = UInt(value) ?? 0
            
        case 15:
            sat.universalSwitchIDfor1 = UInt(value) ?? 0
            
        case 16:
            sat.universalSwitchIDfor2 = UInt(value) ?? 0
            
        case 17:
            sat.universalSwitchIDfor3 = UInt(value) ?? 0
            
        case 18:
            sat.universalSwitchIDfor4 = UInt(value) ?? 0
            
        case 19:
            sat.universalSwitchIDfor5 = UInt(value) ?? 0
            
        case 20:
            sat.universalSwitchIDfor6 = UInt(value) ?? 0
            
        case 21:
            sat.universalSwitchIDfor7 = UInt(value) ?? 0
            
        case 22:
            sat.universalSwitchIDfor8 = UInt(value) ?? 0
            
        case 23:
            sat.universalSwitchIDfor9 = UInt(value) ?? 0
            
        case 24:
            sat.universalSwitchIDforPREVChapter = UInt(value) ?? 0
            
        case 25:
            sat.universalSwitchIDforNextChapter = UInt(value) ?? 0
            
        case 26:
            sat.universalSwitchIDforPlayRecord = UInt(value) ?? 0
            
        case 27:
            sat.universalSwitchIDforPlayStopRecord =  UInt(value) ?? 0
            
        case 28:
            sat.iRMacroNumberForSATSpare0 = UInt(value) ?? 0
            
        case 29:
            sat.iRMacroNumberForSATSpare1 = UInt(value) ?? 0
            
        case 30:
            sat.iRMacroNumberForSATSpare2 = UInt(value) ?? 0
            
        case 31:
            sat.iRMacroNumberForSATSpare3 = UInt(value) ?? 0
            
        case 32:
            sat.iRMacroNumberForSATSpare4 = UInt(value) ?? 0
            
        case 33:
            sat.iRMacroNumberForSATSpare5 = UInt(value) ?? 0
            
        case 34:
            sat.switchNameforControl1 = value
            
        case 35:
            sat.switchIDforControl1 = UInt(value) ?? 0
            
        case 36:
            sat.switchNameforControl2 = value
            
        case 37:
            sat.switchIDforControl2 = UInt(value) ?? 0
            
        case 38:
            sat.switchNameforControl3 = value
            
        case 39:
            sat.switchIDforControl3 = UInt(value) ?? 0
            
        case 40:
            sat.switchNameforControl4 = value
            
        case 41:
            sat.switchIDforControl4 = UInt(value) ?? 0
            
        case 42:
            sat.switchNameforControl5 = value
            
        case 43:
            sat.switchIDforControl5 = UInt(value) ?? 0
            
        case 44:
            sat.switchNameforControl6 = value
            
        case 45:
            sat.switchIDforControl6 = UInt(value) ?? 0
            
        default:
            break
        }
        
        _ = SHSQLiteManager.shared.updateSat(sat)
    }
}

