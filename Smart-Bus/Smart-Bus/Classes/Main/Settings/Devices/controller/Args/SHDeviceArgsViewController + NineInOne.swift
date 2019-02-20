//
//  SHDeviceArgsViewController + NineInOne.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - 9in1
extension SHDeviceArgsViewController {
    
    func refreshNineInOne() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            
            "ControlSure commandID",
            "ControlUp commandID",
            "ControlDown commandID",
            "ControlLeft commandID",
            "ControlRight commandID",
            
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
            "Control_6 commandID",
            
            "Control_7 Name",
            "Control_7 commandID",
            
            "Control_8 Name",
            "Control_8 commandID",
            
            "NumberPad_0 commandID",
            "NumberPad_1 commandID",
            "NumberPad_2 commandID",
            "NumberPad_3 commandID",
            "NumberPad_4 commandID",
            "NumberPad_5 commandID",
            "NumberPad_6 commandID",
            "NumberPad_7 commandID",
            "NumberPad_8 commandID",
            "NumberPad_9 commandID",
            "NumberPad_* commandID",
            "NumberPad_# commandID",
            
            "Spare_1 Name",
            "Spare_1 commandID",
            "Spare_2 Name",
            "Spare_2 commandID",
            "Spare_3 Name",
            "Spare_3 commandID",
            "Spare_4 Name",
            "Spare_4 commandID",
            "Spare_5 Name",
            "Spare_5 commandID",
            "Spare_6 Name",
            "Spare_6 commandID",
            "Spare_7 Name",
            "Spare_7 commandID",
            "Spare_8 Name",
            "Spare_8 commandID",
            "Spare_9 Name",
            "Spare_9 commandID",
            "Spare_10 Name",
            "Spare_10 commandID",
            "Spare_11 Name",
            "Spare_11 commandID",
            "Spare_12 Name",
            "Spare_12 commandID"
        ]
        
        argsValues = [
            nineInOne?.nineInOneName ?? "9in1",
            "\(nineInOne?.subnetID ?? 1)",
            "\(nineInOne?.deviceID ?? 0)",
            
            "\(nineInOne?.switchIDforControlSure ?? 0)",
            "\(nineInOne?.switchIDforControlUp ?? 0)",
            "\(nineInOne?.switchIDforControlDown ?? 0)",
            "\(nineInOne?.switchIDforControlLeft ?? 0)",
            "\(nineInOne?.switchIDforControlRight ?? 0)",
            
            "\(nineInOne?.switchNameforControl1 ?? "C1")",
            "\(nineInOne?.switchIDforControl1 ?? 0)",
            "\(nineInOne?.switchNameforControl2 ?? "C2")",
            "\(nineInOne?.switchIDforControl2 ?? 0)",
            "\(nineInOne?.switchNameforControl3 ?? "C3")",
            "\(nineInOne?.switchIDforControl3 ?? 0)",
            "\(nineInOne?.switchNameforControl4 ?? "C4")",
            "\(nineInOne?.switchIDforControl4 ?? 0)",
            "\(nineInOne?.switchNameforControl5 ?? "C5")",
            "\(nineInOne?.switchIDforControl5 ?? 0)",
            "\(nineInOne?.switchNameforControl6 ?? "C6")",
            "\(nineInOne?.switchIDforControl6 ?? 0)",
            "\(nineInOne?.switchNameforControl7 ?? "C7")",
            "\(nineInOne?.switchIDforControl7 ?? 0)",
            "\(nineInOne?.switchNameforControl8 ?? "C8")",
            "\(nineInOne?.switchIDforControl8 ?? 0)",
            
            "\(nineInOne?.switchIDforNumber0 ?? 0)",
            "\(nineInOne?.switchIDforNumber1 ?? 0)",
            "\(nineInOne?.switchIDforNumber2 ?? 0)",
            "\(nineInOne?.switchIDforNumber3 ?? 0)",
            "\(nineInOne?.switchIDforNumber4 ?? 0)",
            "\(nineInOne?.switchIDforNumber5 ?? 0)",
            "\(nineInOne?.switchIDforNumber6 ?? 0)",
            "\(nineInOne?.switchIDforNumber7 ?? 0)",
            "\(nineInOne?.switchIDforNumber8 ?? 0)",
            "\(nineInOne?.switchIDforNumber9 ?? 0)",
            "\(nineInOne?.switchIDforNumberAsterisk ?? 0)",
            "\(nineInOne?.switchIDforNumberPound ?? 0)",
            
            "\(nineInOne?.switchNameforSpare1 ?? "Spare_1")",
            "\(nineInOne?.switchIDforSpare1 ?? 0)",
            "\(nineInOne?.switchNameforSpare2 ?? "Spare_2")",
            "\(nineInOne?.switchIDforSpare2 ?? 0)",
            "\(nineInOne?.switchNameforSpare3 ?? "Spare_3")",
            "\(nineInOne?.switchIDforSpare3 ?? 0)",
            "\(nineInOne?.switchNameforSpare4 ?? "Spare_4")",
            "\(nineInOne?.switchIDforSpare4 ?? 0)",
            "\(nineInOne?.switchNameforSpare5 ?? "Spare_5")",
            "\(nineInOne?.switchIDforSpare5 ?? 0)",
            "\(nineInOne?.switchNameforSpare6 ?? "Spare_6")",
            "\(nineInOne?.switchIDforSpare6 ?? 0)",
            "\(nineInOne?.switchNameforSpare7 ?? "Spare_7")",
            "\(nineInOne?.switchIDforSpare7 ?? 0)",
            "\(nineInOne?.switchNameforSpare8 ?? "Spare_8")",
            "\(nineInOne?.switchIDforSpare8 ?? 0)",
            "\(nineInOne?.switchNameforSpare9 ?? "Spare_9")",
            "\(nineInOne?.switchIDforSpare9 ?? 0)",
            "\(nineInOne?.switchNameforSpare10 ?? "Spare_10")",
            "\(nineInOne?.switchIDforSpare10 ?? 0)",
            "\(nineInOne?.switchNameforSpare11 ?? "Spare_11")",
            "\(nineInOne?.switchIDforSpare11 ?? 0)",
            "\(nineInOne?.switchNameforSpare12 ?? "Spare_12")",
            "\(nineInOne?.switchIDforSpare12 ?? 0)"
        ]
    }
    
    /// 更新9in1
    func updateNineInOne(value: String, index: Int) {
        
        guard let nine = self.nineInOne else {
            return
        }
        
        switch (index) {
            
        case 0:
            nine.nineInOneName = value
            
        case 1:
            nine.subnetID = UInt8(value) ?? 0
            
        case 2:
            nine.deviceID = UInt8(value) ?? 0
            
        case 3:
            nine.switchIDforControlSure = UInt(value) ?? 0
            
        case 4:
            nine.switchIDforControlUp = UInt(value) ?? 0
            
        case 5:
            nine.switchIDforControlDown = UInt(value) ?? 0
            
        case 6:
            nine.switchIDforControlLeft = UInt(value) ?? 0
            
        case 7:
            nine.switchIDforControlRight = UInt(value) ?? 0
            
        case 8:
            self.nineInOne?.switchNameforControl1 = value
            
        case 9:
            nine.switchIDforControl1 = UInt(value) ?? 0
            
        case 10:
            nine.switchNameforControl2 = value
            
        case 11:
            nine.switchIDforControl2 = UInt(value) ?? 0
            
        case 12:
            nine.switchNameforControl3 = value
            
        case 13:
            nine.switchIDforControl3 = UInt(value) ?? 0
            
        case 14:
            nine.switchNameforControl4 = value
            
        case 15:
            nine.switchIDforControl4 = UInt(value) ?? 0
            
        case 16:
            nine.switchNameforControl5 = value
            
        case 17:
            nine.switchIDforControl5 = UInt(value) ?? 0
            
        case 18:
            nine.switchNameforControl6 = value
            
        case 19:
            nine.switchIDforControl6 = UInt(value) ?? 0
            
        case 20:
            self.nineInOne?.switchNameforControl7 = value
            
        case 21:
            nine.switchIDforControl7 = UInt(value) ?? 0
            
        case 22:
            nine.switchNameforControl8 = value
            
        case 23:
            nine.switchIDforControl8 = UInt(value) ?? 0
            
        case 24:
            nine.switchIDforNumber0 = UInt(value) ?? 0
            
        case 25:
            nine.switchIDforNumber1 = UInt(value) ?? 0
            
        case 26:
            nine.switchIDforNumber2 = UInt(value) ?? 0
            
        case 27:
            nine.switchIDforNumber3 = UInt(value) ?? 0
            
        case 28:
            nine.switchIDforNumber4 = UInt(value) ?? 0
            
        case 29:
            nine.switchIDforNumber5 = UInt(value) ?? 0
            
        case 30:
            nine.switchIDforNumber6 = UInt(value) ?? 0
            
        case 31:
            nine.switchIDforNumber7 = UInt(value) ?? 0
            
        case 32:
            nine.switchIDforNumber8 = UInt(value) ?? 0
            
        case 33:
            nine.switchIDforNumber9 = UInt(value) ?? 0
            
        case 34:
            nine.switchIDforNumberAsterisk = UInt(value) ?? 0
            
        case 35:
            nine.switchIDforNumberPound = UInt(value) ?? 0
            
        case 36:
            nine.switchNameforSpare1 = value
            
        case 37:
            nine.switchIDforSpare1 = UInt(value) ?? 0
            
        case 38:
            nine.switchNameforSpare2 = value
            
        case 39:
            nine.switchIDforSpare2 = UInt(value) ?? 0
            
        case 40:
            nine.switchNameforSpare3 = value
            
        case 41:
            nine.switchIDforSpare3 = UInt(value) ?? 0
            
        case 42:
            nine.switchNameforSpare4 = value
            
        case 43:
            nine.switchIDforSpare4 = UInt(value) ?? 0
            
        case 44:
            nine.switchNameforSpare5 = value
            
        case 45:
            nine.switchIDforSpare5 = UInt(value) ?? 0
            
        case 46:
            nine.switchNameforSpare6 = value
            
        case 47:
            nine.switchIDforSpare6 = UInt(value) ?? 0
            
        case 48:
            nine.switchNameforSpare7 = value
            
        case 49:
            nine.switchIDforSpare7 = UInt(value) ?? 0
            
        case 50:
            nine.switchNameforSpare8 = value
            
        case 51:
            nine.switchIDforSpare8 = UInt(value) ?? 0
            
        case 52:
            nine.switchNameforSpare9 = value
            
        case 53:
            nine.switchIDforSpare9 = UInt(value) ?? 0
            
        case 54:
            nine.switchNameforSpare10 = value
            
        case 55:
            nine.switchIDforSpare10 = UInt(value) ?? 0
            
        case 56:
            nine.switchNameforSpare11 = value
            
        case 57:
            nine.switchIDforSpare11 = UInt(value) ?? 0
            
        case 58:
            nine.switchNameforSpare12 = value
            
        case 59:
            nine.switchIDforSpare12 = UInt(value) ?? 0
            
        default:
            break;
        }
        
        _ = SHSQLiteManager.shared.updateNineInOne(nine)
    }
}
