//
//  SHDeviceArgsViewController + NineInOne.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
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
        
        switch (index) {
            
        case 0:
            self.nineInOne?.nineInOneName = value
            
        case 1:
            self.nineInOne?.subnetID = UInt8(value) ?? 0
            break;
            
        case 2:
            self.nineInOne?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.nineInOne?.switchIDforControlSure = UInt(value) ?? 0
            
        case 4:
            self.nineInOne?.switchIDforControlUp = UInt(value) ?? 0
            
        case 5:
            self.nineInOne?.switchIDforControlDown = UInt(value) ?? 0
            
        case 6:
            self.nineInOne?.switchIDforControlLeft = UInt(value) ?? 0
            
        case 7:
            self.nineInOne?.switchIDforControlRight = UInt(value) ?? 0
            
        case 8:
            self.nineInOne?.switchNameforControl1 = value
            
        case 9:
            self.nineInOne?.switchIDforControl1 = UInt(value) ?? 0
            
        case 10:
            self.nineInOne?.switchNameforControl2 = value
            
        case 11:
            self.nineInOne?.switchIDforControl2 = UInt(value) ?? 0
            
        case 12:
            self.nineInOne?.switchNameforControl3 = value
            
        case 13:
            self.nineInOne?.switchIDforControl3 = UInt(value) ?? 0
            
        case 14:
            self.nineInOne?.switchNameforControl4 = value
            
        case 15:
            self.nineInOne?.switchIDforControl4 = UInt(value) ?? 0
            
        case 16:
            self.nineInOne?.switchNameforControl5 = value
            
        case 17:
            self.nineInOne?.switchIDforControl5 = UInt(value) ?? 0
            
        case 18:
            self.nineInOne?.switchNameforControl6 = value
            
        case 19:
            self.nineInOne?.switchIDforControl6 = UInt(value) ?? 0
            
        case 20:
            self.nineInOne?.switchNameforControl7 = value
            
        case 21:
            self.nineInOne?.switchIDforControl7 = UInt(value) ?? 0
            
        case 22:
            self.nineInOne?.switchNameforControl8 = value
            
        case 23:
            self.nineInOne?.switchIDforControl8 = UInt(value) ?? 0
            
        case 24:
            self.nineInOne?.switchIDforNumber0 = UInt(value) ?? 0
            
        case 25:
            self.nineInOne?.switchIDforNumber1 = UInt(value) ?? 0
            
        case 26:
            self.nineInOne?.switchIDforNumber2 = UInt(value) ?? 0
            
        case 27:
            self.nineInOne?.switchIDforNumber3 = UInt(value) ?? 0
            
        case 28:
            self.nineInOne?.switchIDforNumber4 = UInt(value) ?? 0
            
        case 29:
            self.nineInOne?.switchIDforNumber5 = UInt(value) ?? 0
            
        case 30:
            self.nineInOne?.switchIDforNumber6 = UInt(value) ?? 0
            
        case 31:
            self.nineInOne?.switchIDforNumber7 = UInt(value) ?? 0
            
        case 32:
            self.nineInOne?.switchIDforNumber8 = UInt(value) ?? 0
            
        case 33:
            self.nineInOne?.switchIDforNumber9 = UInt(value) ?? 0
            
        case 34:
            self.nineInOne?.switchIDforNumberAsterisk = UInt(value) ?? 0
            
        case 35:
            self.nineInOne?.switchIDforNumberPound = UInt(value) ?? 0
            
        case 36:
            self.nineInOne?.switchNameforSpare1 = value
            
        case 37:
            self.nineInOne?.switchIDforSpare1 = UInt(value) ?? 0
            
        case 38:
            self.nineInOne?.switchNameforSpare2 = value
            
        case 39:
            self.nineInOne?.switchIDforSpare2 = UInt(value) ?? 0
            
        case 40:
            self.nineInOne?.switchNameforSpare3 = value
            
        case 41:
            self.nineInOne?.switchIDforSpare3 = UInt(value) ?? 0
            
        case 42:
            self.nineInOne?.switchNameforSpare4 = value
            
        case 43:
            self.nineInOne?.switchIDforSpare4 = UInt(value) ?? 0
            
        case 44:
            self.nineInOne?.switchNameforSpare5 = value
            
        case 45:
            self.nineInOne?.switchIDforSpare5 = UInt(value) ?? 0
            
        case 46:
            self.nineInOne?.switchNameforSpare6 = value
            
        case 47:
            self.nineInOne?.switchIDforSpare6 = UInt(value) ?? 0
            
        case 48:
            self.nineInOne?.switchNameforSpare7 = value
            
        case 49:
            self.nineInOne?.switchIDforSpare7 = UInt(value) ?? 0
            
        case 50:
            self.nineInOne?.switchNameforSpare8 = value
            
        case 51:
            self.nineInOne?.switchIDforSpare8 = UInt(value) ?? 0
            
        case 52:
            self.nineInOne?.switchNameforSpare9 = value
            
        case 53:
            self.nineInOne?.switchIDforSpare9 = UInt(value) ?? 0
            
        case 54:
            self.nineInOne?.switchNameforSpare10 = value
            
        case 55:
            self.nineInOne?.switchIDforSpare10 = UInt(value) ?? 0
            
        case 56:
            self.nineInOne?.switchNameforSpare11 = value
            
        case 57:
            self.nineInOne?.switchIDforSpare11 = UInt(value) ?? 0
            
        case 58:
            self.nineInOne?.switchNameforSpare12 = value
            
        case 59:
            self.nineInOne?.switchIDforSpare12 = UInt(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.updateNineInOne(inZone: nineInOne)
    }
}
