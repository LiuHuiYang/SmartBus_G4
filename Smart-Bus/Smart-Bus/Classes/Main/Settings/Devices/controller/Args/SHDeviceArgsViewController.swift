//
//  SHDeviceArgsViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2017/10/19.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// cell重标标示符
let deviceArgsCellReuseIdentifier = "SHDeviceArgsViewCell"

class SHDeviceArgsViewController: SHViewController {
    
    // MARK: - 不同类型设备
    
    /// 灯泡
    var light: SHLight?
    
    /// 空调
    var hvac: SHHVAC?
    
    /// 音乐
    var audio: SHAudio?
    
    /// 风扇
    var fan: SHFan?
    
    /// 窗帘
    var shade: SHShade?
    
    /// 地热
    var floorHeating: SHFloorHeating?
    
    /// 干节点
    var dryContact: SHDryContact?
    
    /// 温度传感器
    var temperatureSensor: SHTemperatureSensor?
    
    /// dmxGroup
    var dmxGroup: SHDmxGroup?
    
    /// dmx通道
    var dmxChannel: SHDmxChannel?
    
    /// 9in1
    var nineInOne: SHNineInOne?
    
    /// TV
    var mediaTV: SHMediaTV?
    
    /// DVD
    var mediaDVD: SHMediaDVD?
    
    /// sat.
    var mediaSAT: SHMediaSAT?
    
    /// appleTV
    var mediaAppleTV: SHMediaAppleTV?
    
    /// projector
    var mediaProjector: SHMediaProjector?
    
    /// mood指令(具体)
    var moodCommand: SHMoodCommand?
    
    /// macro指令(具体)
    var macroCommand: SHMacroCommand?
    
    /// 安防模块
    var securityZone: SHSecurityZone?
    
    /// CT24
    var currentTransformer: SHCurrentTransformer?
    
    // MARK: - 通部用部分属性
    
    /// 详情列表
    @IBOutlet weak var detailListView: UITableView!
    
    /// 属性名称
    fileprivate lazy var argsNames: [String] = [String]()
    
    /// 属性值
    fileprivate lazy var argsValues: [String] = [String]()
    
    /// 属性值输入框（中间过渡）
    fileprivate var valueTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Parameters Setting"

        detailListView.rowHeight = SHDeviceArgsViewCell.rowHeight
        
        detailListView.register(UINib(nibName: deviceArgsCellReuseIdentifier,
                                      bundle: nil),
                                forCellReuseIdentifier: deviceArgsCellReuseIdentifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshListView()
    }
}

// MARK: - UITableViewDataSource
extension SHDeviceArgsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return argsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: deviceArgsCellReuseIdentifier,
            for: indexPath
            ) as! SHDeviceArgsViewCell
        
        cell.argsName = argsNames[indexPath.row]
        cell.argValueText = argsValues[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SHDeviceArgsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = argsNames[indexPath.row]
        
        let alertView = TYCustomAlertView(title: title,
                                          message: nil,
                                          isCustom: true
        )
        
        alertView?.addTextField(configurationHandler: { (textField) in
            
            textField?.becomeFirstResponder()
            textField?.clearButtonMode = .whileEditing
            textField?.textAlignment = .center
            textField?.text = self.argsValues[indexPath.row]
            
            let name = self.argsNames[indexPath.row].lowercased()
            
            let isString = name.contains("name") || name.contains("remark")
            
            textField?.keyboardType =
                isString ? .default : .numberPad
            
            self.valueTextField = textField
        })
        
        let cancelAction =
            TYAlertAction(title: SHLanguageText.cancel,
                                         style: .cancel,
                                         handler: nil
        )
        
        alertView?.add(cancelAction)
        
        
        let saveAction = TYAlertAction(title: SHLanguageText.save, style: .destructive) { (action) in
            
            guard let value = self.valueTextField?.text else {
                
                return
            }
            
            if value.isEmpty {
                
                SVProgressHUD.showInfo(withStatus: "The value should not be empty!")
                return
            }
            
            self.updateValue(value: value, index: indexPath.row)
        }
        
        alertView?.add(saveAction)
        
        
        let alertController =
            TYAlertController(alert: alertView,
                              preferredStyle: .alert,
                              transitionAnimation: .scaleFade
        )
        
        if UIDevice.is3_5inch() || UIDevice.is4_0inch() {
            
            alertController?.alertViewOriginY =
                navigationBarHeight + statusBarHeight
        }
        
        UIApplication.shared.keyWindow?.rootViewController?.present(
            alertController!,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - 更新所有设备的参数并且进行保存
extension SHDeviceArgsViewController {
    
    /// 更新参数
    func refreshListView() {
        
        if light != nil {
            
            refreshLight()
        }
        
        if hvac != nil {
            
            refreshHVAC()
        }
        
        if audio != nil {
            
            refreshAudio()
        }
        
        if fan != nil {
            refreshFan()
        }
        
        if shade != nil {
            
            refreshShade()
        }
        
        if floorHeating != nil {
            
            refreshFloorHeating()
        }
        
        if dryContact != nil {
            
            refreshDryContact()
        }
        
        if temperatureSensor != nil {
            
            refreshTemperatureSensor()
        }
        
        
        if dmxGroup != nil {
            
            refreshDmxGroup()
        }
        
        if dmxChannel != nil {
            
            refreshDmxChannel()
        }
        
        // 9in1
        if nineInOne != nil {
            
            refreshNineInOne()
        }
        
        // tv
        if mediaTV != nil {
            
            refreshMediaTV()
        }
        
        // dvd
        if mediaDVD != nil {
            
            refreshMediaDVD()
        }
        
        // sat.
        if mediaSAT != nil {
            
            refreshMediaSAT()
        }
        
        // sat.
        if mediaAppleTV != nil {
            
            refreshMediaAppleTV()
        }
        
        // projector
        if mediaProjector != nil {
            
            refreshMediaProjector()
        }
        
        // moodCommand
        if moodCommand != nil {
            
            refreshMooCommand()
        }
        
        // marcroCommand
        if macroCommand != nil {
            
            refreshMacroCommand()
        }
        
        // 安防
        if securityZone != nil {
            
            refreshSecurityZone()
        }
        
        // CT24
        if currentTransformer != nil {
            
            refreshCurrentTransformer()

        }
        
        detailListView.reloadData()
    }
    
    // ===========================================
    
    /// 保存值
    func updateValue(value: String, index: Int) {
        
        // 保存light
        if light != nil {
            
            updateLight(value: value, index: index)
        }
        
        // 保存fan
        if fan != nil {
            
            updateFan(value: value, index: index)
        }
        
        // 保存hvac
        if hvac != nil {
            
            updateHVAC(value: value, index: index)
        }
        
        if audio != nil{
         
            updateAudio(value: value, index: index)
        }
        
        // 保存shade
        if shade != nil {
            updateShade(value: value, index: index)
        }
        
        // 保存地热
        if floorHeating != nil {
            
            updateFloorHeating(value: value, index: index)
        }
        
        // 保存 4Z
        if dryContact != nil {
            
            updateDryContact(value: value, index: index)
        }
        
        // 保存 4T
        if temperatureSensor != nil {
            
            updateTemperatureSensor(value: value, index: index)
        }
        
        // 保存 dmxGroup
        if dmxGroup != nil {
            
            updateDmxGroup(value: value, index: index)
        }
        
        // 保存 dmxChannel
        if dmxChannel != nil {
            
            updateDmxChannel(value: value, index: index)
        }
 
        // 保存9in1
        if nineInOne != nil {
            
            updateNineInOne(value: value, index: index)
        }
        
        // 保存tv
        if mediaTV != nil {
            
            updateMediaTV(value: value, index: index)
        }
        
        // 保存dvd
        if mediaDVD != nil {
            
            updateMediaDVD(value: value, index: index)
        }
        
        // 保存sat
        if mediaSAT != nil {
            
            updateMediaSAT(value: value, index: index)
        }
        
        // 保存 Apple TV
        if mediaAppleTV != nil {
            
            updateMediaAppleTV(value: value, index: index)
        }
        
        // 保存 投影仪
        if mediaProjector != nil {
            
            updateMediaProjector(value: value, index: index)
        }
        
        // 保存 mood指令
        if moodCommand != nil {
            
            updateMoodCommand(value: value, index: index)
        }
        
        // 保存 宏指令
        if macroCommand != nil {
            
            updateMacroCommand(value: value, index: index)
        }
        
        // 保存 安防
        if securityZone != nil {
            
            updateSecurityZone(value: value, index: index)
        }
        
        // 保存 CT24
        if currentTransformer != nil {
            
            updateCurrentTransformer(value: value, index: index)
        }
        
        refreshListView()
    }
}


// MARK: - Audio
extension SHDeviceArgsViewController {
    
    /// 刷新音乐数据
    func refreshAudio() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "SDCard",
            "FTP",
            "Radio",
            "Audio In",
            "Phone",
            "Udisk",
            "Bluetooth",
            "isMiniZAudio"
        ]
        
        argsValues = [
            audio?.audioName ?? "audio",
            "\(audio?.subnetID ?? 1)",
            "\(audio?.deviceID ?? 0)",
            
            "\(audio?.haveSdCard ?? 0)",
            "\(audio?.haveFtp ?? 0)",
            "\(audio?.haveRadio ?? 0)",
            "\(audio?.haveAudioIn ?? 0)",
            "\(audio?.havePhone ?? 0)",
            "\(audio?.haveUdisk ?? 0)",
            "\(audio?.haveBluetooth ?? 0)",
            "\(audio?.isMiniZAudio ?? 0)",
        ]
    }
    
    
    func updateAudio(value: String, index: Int) {
        
        switch (index) {
            
        case 0:
            self.audio?.audioName = value
            
        case 1:
            self.audio?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.audio?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.audio?.haveSdCard = UInt8(value) ?? 0
            
        case 4:
            self.audio?.haveFtp = UInt8(value) ?? 0
            
        case 5:
            self.audio?.haveRadio = UInt8(value) ?? 0
            
        case 6:
            self.audio?.haveAudioIn = UInt8(value) ?? 0
            
        case 7:
            self.audio?.havePhone = UInt8(value) ?? 0
            
        case 8:
            self.audio?.haveUdisk = UInt8(value) ?? 0
            
        case 9:
            self.audio?.haveBluetooth = UInt8(value) ?? 0
            
        case 10:
            self.audio?.isMiniZAudio = UInt8(value) ?? 0
            
        default:
            break
        }
        
        SHSQLManager.share()?.updateAudio(inZone: audio)
    }
}

// MARK: - Projector
extension SHDeviceArgsViewController {
    
    func refreshMediaProjector() {
        
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
            "Source",
                          
            "IRReserved_0",
            "IRReserved_1",
            "IRReserved_2",
            "IRReserved_3",
            "IRReserved_4",
            "IRReserved_5"
        ]
        
        argsValues = [
            
            mediaProjector?.remark ?? "projector",
            "\(mediaProjector?.subnetID ?? 1)",
            "\(mediaProjector?.deviceID ?? 0)",
            
            "\(mediaProjector?.universalSwitchIDforOn ?? 0)",
            "\(mediaProjector?.universalSwitchStatusforOn ?? 0)",
            "\(mediaProjector?.universalSwitchIDforOff ?? 0)",
            "\(mediaProjector?.universalSwitchStatusforOff ?? 0)",
            
            "\(mediaProjector?.universalSwitchIDfoUp ?? 0)",
            "\(mediaProjector?.universalSwitchIDforDown ?? 0)",
            "\(mediaProjector?.universalSwitchIDforLeft ?? 0)",
            "\(mediaProjector?.universalSwitchIDforRight ?? 0)",
            "\(mediaProjector?.universalSwitchIDforOK ?? 0)",
            "\(mediaProjector?.universalSwitchIDfoMenu ?? 0)",
            "\(mediaProjector?.universalSwitchIDforSource ?? 0)",
            
            "\(mediaProjector?.iRMacroNumberForProjectorSpare0 ?? 0)",
            "\(mediaProjector?.iRMacroNumberForProjectorSpare1 ?? 0)",
            "\(mediaProjector?.iRMacroNumberForProjectorSpare2 ?? 0)",
            "\(mediaProjector?.iRMacroNumberForProjectorSpare3 ?? 0)",
            "\(mediaProjector?.iRMacroNumberForProjectorSpare4 ?? 0)",
            "\(mediaProjector?.iRMacroNumberForProjectorSpare5 ?? 0)"
        ]
    }
    
    /// 保存投影仪
    func updateMediaProjector(value: String, index: Int) {
        
        switch (index) {
            
        case 0:
            self.mediaProjector?.remark = value
            
        case 1:
            self.mediaProjector?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.mediaProjector?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.mediaProjector?.universalSwitchIDforOn = UInt(value) ?? 0
            
        case 4:
            self.mediaProjector?.universalSwitchStatusforOn = UInt(value) ?? 0
            
        case 5:
            self.mediaProjector?.universalSwitchIDforOff = UInt(value) ?? 0
            
        case 6:
            self.mediaProjector?.universalSwitchStatusforOff = UInt(value) ?? 0
            
        case 7:
            self.mediaProjector?.universalSwitchIDfoUp = UInt(value) ?? 0
            
        case 8:
            self.mediaProjector?.universalSwitchIDforDown = UInt(value) ?? 0
            
        case 9:
            self.mediaProjector?.universalSwitchIDforLeft = UInt(value) ?? 0
            
        case 10:
            self.mediaProjector?.universalSwitchIDforRight = UInt(value) ?? 0
            
        case 11:
            self.mediaProjector?.universalSwitchIDforOK = UInt(value) ?? 0
            
        case 12:
            self.mediaProjector?.universalSwitchIDfoMenu = UInt(value) ?? 0
            
        case 13:
            self.mediaProjector?.universalSwitchIDforSource = UInt(value) ?? 0
            
        case 14:
            self.mediaProjector?.iRMacroNumberForProjectorSpare0 = UInt(value) ?? 0
            
        case 15:
            self.mediaProjector?.iRMacroNumberForProjectorSpare1 = UInt(value) ?? 0
            
        case 16:
            self.mediaProjector?.iRMacroNumberForProjectorSpare2 = UInt(value) ?? 0
            
        case 17:
            self.mediaProjector?.iRMacroNumberForProjectorSpare3 = UInt(value) ?? 0
            
        case 18:
            self.mediaProjector?.iRMacroNumberForProjectorSpare4 = UInt(value) ?? 0
            
        case 19:
            self.mediaProjector?.iRMacroNumberForProjectorSpare5 = UInt(value) ?? 0
            
        default:
            break
        }
        
        SHSQLManager.share()?.saveMediaProjector(inZone: mediaProjector)
    }
}

// MARK: - AppleTV
extension SHDeviceArgsViewController {
    
    func refreshMediaAppleTV() {
        
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
            "Pause",
                          
            "IRReserved_0",
            "IRReserved_1",
            "IRReserved_2",
            "IRReserved_3",
            "IRReserved_4",
            "IRReserved_5"
        ]
        
        argsValues = [
            
            mediaAppleTV?.remark ?? "Apple TV",
            "\(mediaAppleTV?.subnetID ?? 1)",
            "\(mediaAppleTV?.deviceID ?? 0)",
            
            "\(mediaAppleTV?.universalSwitchIDforOn ?? 0)",
            "\(mediaAppleTV?.universalSwitchStatusforOn ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforOff ?? 0)",
            "\(mediaAppleTV?.universalSwitchStatusforOff ?? 0)",
            
            "\(mediaAppleTV?.universalSwitchIDforUp ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforDown ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforLeft ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforRight ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforOK ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforMenu ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforPlayPause ?? 0)",
            
            "\(mediaAppleTV?.iRMacroNumberForAppleTVStart0 ?? 0)",
            "\(mediaAppleTV?.iRMacroNumberForAppleTVStart1 ?? 0)",
            "\(mediaAppleTV?.iRMacroNumberForAppleTVStart2 ?? 0)",
            "\(mediaAppleTV?.iRMacroNumberForAppleTVStart3 ?? 0)",
            "\(mediaAppleTV?.iRMacroNumberForAppleTVStart4 ?? 0)",
            "\(mediaAppleTV?.iRMacroNumberForAppleTVStart5 ?? 0)",
        ]
    }
    
    /// 保存AppleTV
    func updateMediaAppleTV(value: String, index: Int) {
        
        switch (index) {
            
        case 0:
            self.mediaAppleTV?.remark = value
            
        case 1:
            self.mediaAppleTV?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.mediaAppleTV?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.mediaAppleTV?.universalSwitchIDforOn = UInt(value) ?? 0
            
        case 4:
            self.mediaAppleTV?.universalSwitchStatusforOn = UInt(value) ?? 0
            
        case 5:
            self.mediaAppleTV?.universalSwitchIDforOff = UInt(value) ?? 0
            
        case 6:
            self.mediaAppleTV?.universalSwitchStatusforOff = UInt(value) ?? 0
            
        case 7:
            self.mediaAppleTV?.universalSwitchIDforUp = UInt(value) ?? 0
            
        case 8:
            self.mediaAppleTV?.universalSwitchIDforDown = UInt(value) ?? 0
            
        case 9:
            self.mediaAppleTV?.universalSwitchIDforLeft = UInt(value) ?? 0
            
        case 10:
            self.mediaAppleTV?.universalSwitchIDforRight = UInt(value) ?? 0
            
        case 11:
            self.mediaAppleTV?.universalSwitchIDforOK = UInt(value) ?? 0
            
        case 12:
            self.mediaAppleTV?.universalSwitchIDforMenu = UInt(value) ?? 0
            
        case 13:
            self.mediaAppleTV?.universalSwitchIDforPlayPause = UInt(value) ?? 0
            
        case 14:
            self.mediaAppleTV?.iRMacroNumberForAppleTVStart0 = UInt(value) ?? 0
            
        case 15:
            self.mediaAppleTV?.iRMacroNumberForAppleTVStart1 = UInt(value) ?? 0
            
        case 16:
            self.mediaAppleTV?.iRMacroNumberForAppleTVStart2 = UInt(value) ?? 0
            
        case 17:
            self.mediaAppleTV?.iRMacroNumberForAppleTVStart3 = UInt(value) ?? 0
            
        case 18:
            self.mediaAppleTV?.iRMacroNumberForAppleTVStart4 = UInt(value) ?? 0
            
        case 19:
            self.mediaAppleTV?.iRMacroNumberForAppleTVStart5 = UInt(value) ?? 0
            
        default:
            break
        }
        
        SHSQLManager.share()?.updateMediaAppleTV(inZone: mediaAppleTV)
    }
}

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
        
        switch (index) {
            
        case 0:
            self.mediaSAT?.remark = value
        case 1:
            self.mediaSAT?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.mediaSAT?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.mediaSAT?.universalSwitchIDforOn = UInt(value) ?? 0
            
        case 4:
            self.mediaSAT?.universalSwitchStatusforOn = UInt(value) ?? 0
            
        case 5:
            self.mediaSAT?.universalSwitchIDforOff = UInt(value) ?? 0
            
        case 6:
            self.mediaSAT?.universalSwitchStatusforOff = UInt(value) ?? 0
            
        case 7:
            self.mediaSAT?.universalSwitchIDforUp = UInt(value) ?? 0
            
        case 8:
            self.mediaSAT?.universalSwitchIDforDown = UInt(value) ?? 0
            
        case 9:
            self.mediaSAT?.universalSwitchIDforLeft = UInt(value) ?? 0
            
        case 10:
            self.mediaSAT?.universalSwitchIDforRight = UInt(value) ?? 0
        case 11:
            self.mediaSAT?.universalSwitchIDforOK = UInt(value) ?? 0
            
        case 12:
            self.mediaSAT?.universalSwitchIDfoMenu = UInt(value) ?? 0
            
        case 13:
            self.mediaSAT?.universalSwitchIDforFAV = UInt(value) ?? 0
            
        case 14:
            self.mediaSAT?.universalSwitchIDfor0 = UInt(value) ?? 0
            
        case 15:
            self.mediaSAT?.universalSwitchIDfor1 = UInt(value) ?? 0
            
        case 16:
            self.mediaSAT?.universalSwitchIDfor2 = UInt(value) ?? 0
            
        case 17:
            self.mediaSAT?.universalSwitchIDfor3 = UInt(value) ?? 0
            
        case 18:
            self.mediaSAT?.universalSwitchIDfor4 = UInt(value) ?? 0
            
        case 19:
            self.mediaSAT?.universalSwitchIDfor5 = UInt(value) ?? 0
            
        case 20:
            self.mediaSAT?.universalSwitchIDfor6 = UInt(value) ?? 0
            
        case 21:
            self.mediaSAT?.universalSwitchIDfor7 = UInt(value) ?? 0
            
        case 22:
            self.mediaSAT?.universalSwitchIDfor8 = UInt(value) ?? 0
            
        case 23:
            self.mediaSAT?.universalSwitchIDfor9 = UInt(value) ?? 0
            
        case 24:
            self.mediaSAT?.universalSwitchIDforPREVChapter = UInt(value) ?? 0
            
        case 25:
            self.mediaSAT?.universalSwitchIDforNextChapter = UInt(value) ?? 0
            
        case 26:
            self.mediaSAT?.universalSwitchIDforPlayRecord = UInt(value) ?? 0
            
        case 27:
            self.mediaSAT?.universalSwitchIDforPlayStopRecord =  UInt(value) ?? 0
            
        case 28:
            self.mediaSAT?.iRMacroNumberForSATSpare0 = UInt(value) ?? 0
            
        case 29:
            self.mediaSAT?.iRMacroNumberForSATSpare1 = UInt(value) ?? 0
            
        case 30:
            self.mediaSAT?.iRMacroNumberForSATSpare2 = UInt(value) ?? 0
            
        case 31:
            self.mediaSAT?.iRMacroNumberForSATSpare3 = UInt(value) ?? 0
            
        case 32:
            self.mediaSAT?.iRMacroNumberForSATSpare4 = UInt(value) ?? 0
            
        case 33:
            self.mediaSAT?.iRMacroNumberForSATSpare5 = UInt(value) ?? 0
            
        case 34:
            self.mediaSAT?.switchNameforControl1 = value
            
        case 35:
            self.mediaSAT?.switchIDforControl1 = UInt(value) ?? 0
            
        case 36:
            self.mediaSAT?.switchNameforControl2 = value
            
        case 37:
            self.mediaSAT?.switchIDforControl2 = UInt(value) ?? 0
            
        case 38:
            self.mediaSAT?.switchNameforControl3 = value
            
        case 39:
            self.mediaSAT?.switchIDforControl3 = UInt(value) ?? 0
            
        case 40:
            self.mediaSAT?.switchNameforControl4 = value
            
        case 41:
            self.mediaSAT?.switchIDforControl4 = UInt(value) ?? 0
            
        case 42:
            self.mediaSAT?.switchNameforControl5 = value
            
        case 43:
            self.mediaSAT?.switchIDforControl5 = UInt(value) ?? 0
            
        case 44:
            self.mediaSAT?.switchNameforControl6 = value
            
        case 45:
            self.mediaSAT?.switchIDforControl6 = UInt(value) ?? 0
            
        default:
            break
        }
        
        SHSQLManager.share()?.updateMediaSAT(inZone: mediaSAT)
    }
}

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

// MARK: - Shade
extension SHDeviceArgsViewController {
    
    func refreshShade() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
               
            "HasStop",
            "Open Channel",
            "Opening Ratio",
            "Close Channel",
            "Closing Ratio",
            "Stop Channel",
            "Stopping Ratio",
                      
            "Reserved1",
            "Reserved2",
                        
            "Open Remark",
            "Close Remark",
            "Stop Remark",
            
            "controlType",
            "switchID for Open",
            "switchID Status for Open",
            "switchID for Close",
            "switchID Status for Close",
            "switchID for Stop",
            "switchID Status for Stop"
        ]
        
        argsValues = [
            shade?.shadeName ?? "curtain",
            "\(shade?.subnetID ?? 1)",
            "\(shade?.deviceID ?? 0)",
            "\(shade?.hasStop ?? 0)",
            
            "\(shade?.openChannel ?? 0)",
            "\(shade?.openingRatio ?? 0)",
            "\(shade?.closeChannel ?? 0)",
            "\(shade?.closingRatio ?? 0)",
            "\(shade?.stopChannel ?? 0)",
            "\(shade?.stoppingRatio ?? 0)",
            
            "\(shade?.reserved1 ?? 0)",
            "\(shade?.reserved2 ?? 0)",
            
            "\(shade?.remarkForOpen ?? "open")",
            "\(shade?.remarkForClose ?? "close")",
            "\(shade?.remarkForStop ?? "stop")",
            
            "\(shade?.controlType.rawValue ?? 0)",
            
            "\(shade?.switchIDforOpen ?? 0)",
            "\(shade?.switchIDStatusforOpen ?? 0)",
            "\(shade?.switchIDforClose ?? 0)",
            "\(shade?.switchIDStatusforClose ?? 0)",
            "\(shade?.switchIDforStop ?? 0)",
            "\(shade?.switchIDStatusforStop ?? 0)"
        ]
    }
    
    
    func updateShade(value: String, index: Int) {
        
        switch (index) {
        case 0:
            self.shade?.shadeName = value
            
        case 1:
            self.shade?.subnetID = UInt8(value) ?? 1
        
        case 2:
            self.shade?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.shade?.hasStop = UInt8(value) ?? 0
            
        case 4:
            self.shade?.openChannel = UInt8(value) ?? 0
            
        case 5:
            self.shade?.openingRatio = UInt8(value) ?? 0
            
        case 6:
            self.shade?.closeChannel = UInt8(value) ?? 0
            
        case 7:
            self.shade?.closingRatio = UInt8(value) ?? 0
            
        case 8:
            self.shade?.stopChannel = UInt8(value) ?? 0
            
        case 9:
            self.shade?.stoppingRatio = UInt8(value) ?? 0
            
        case 10:
            self.shade?.reserved1 = UInt(value) ?? 0
            
        case 11:
            self.shade?.reserved2 = UInt(value) ?? 0
            
        case 12:
            self.shade?.remarkForOpen = value
            
        case 13:
            self.shade?.remarkForClose = value
            
        case 14:
            self.shade?.remarkForStop = value
            
        case 15:
            self.shade?.controlType = SHShadeControlType(rawValue: UInt(value) ?? 0) ?? .defaultControl
            
        case 16:
            self.shade?.switchIDforOpen = UInt(value) ?? 0
            
        case 17:
            self.shade?.switchIDStatusforOpen = UInt(value) ?? 0
            
        case 18:
            self.shade?.switchIDforClose = UInt(value) ?? 0
            
        case 19:
            self.shade?.switchIDStatusforClose = UInt(value) ?? 0
            
        case 20:
            self.shade?.switchIDforStop = UInt(value) ?? 0
            
        case 21:
            self.shade?.switchIDStatusforStop = UInt(value) ?? 0
            
        default:
            break
        }
        
        SHSQLManager.share()?.updateShade(inZone: shade)
    }
}

// MARK: - Fan
extension SHDeviceArgsViewController {
    
    func refreshFan() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "ChannelNO",
            "FanTypeID",
            "Remark",
            "Reserved1",
            "Reserved2",
            "Reserved3",
            "Reserved4",
            "Reserved5"
        ]
        
        
        argsValues = [
            
            fan?.fanName ?? "fan",
            "\(fan?.subnetID ?? 1)",
            "\(fan?.deviceID ?? 0)",
            "\(fan?.channelNO ?? 0)",
            "\(fan?.fanTypeID.rawValue ?? 0)",
            "\(fan?.remark ?? "fan")",
            "\(fan?.reserved1 ?? 0)",
            "\(fan?.reserved2 ?? 0)",
            "\(fan?.reserved3 ?? 0)",
            "\(fan?.reserved4 ?? 0)",
            "\(fan?.reserved5 ?? 0)",
        ]
    }
    
    func updateFan(value: String, index: Int) {
        
        switch (index) {
        case 0:
            self.fan?.fanName = value
            
        case 1:
            self.fan?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.fan?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.fan?.channelNO = UInt8(value) ?? 0
            
        case 4:
            self.fan?.fanTypeID = (SHFanType(rawValue: UInt(value) ?? 0)) ?? .unknow
            
        case 5:
            self.fan?.remark = value
            
        case 6:
            self.fan?.reserved1 = UInt(value) ?? 0
            
        case 7:
            self.fan?.reserved2 = UInt(value) ?? 0
            
        case 8:
            self.fan?.reserved3 = UInt(value) ?? 0
            
        case 9:
            self.fan?.reserved4 = UInt(value) ?? 0
            
        case 10:
            self.fan?.reserved5 = UInt(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.saveFan(inZone: fan)
    }
}

// MARK: - HVAC
extension SHDeviceArgsViewController {
    
    // 刷新 HVAC
    func refreshHVAC() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "ACNumber",
            "ACTypeID",
            "Channel No.",
            "temperature Sensor subnet ID",
            "temperature Sensor Device ID",
            "temperature Sensor Channel No."
        ]
        
        argsValues = [
            hvac?.acRemark ?? "hvac",
            "\(hvac?.subnetID ?? 1)",
            "\(hvac?.deviceID ?? 0)",
            "\(hvac?.acNumber ?? 0)",
            "\(hvac?.acTypeID.rawValue ?? 0)",
            "\(hvac?.channelNo ?? 0)",
            "\(hvac?.temperatureSensorSubNetID ?? 0)",
            "\(hvac?.temperatureSensorDeviceID ?? 0)",
            "\(hvac?.temperatureSensorChannelNo ?? 0)"
        ]
    }
    
    /// 保存HVAC
    func updateHVAC(value: String, index: Int) {
        
        switch (index) {
        case 0:
            self.hvac?.acRemark = value
            
        case 1:
            self.hvac?.subnetID = UInt8(value) ?? 0
            
        case 2:
            self.hvac?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.hvac?.acNumber = UInt(value) ?? 0
            
        case 4:
            self.hvac?.acTypeID = SHAirConditioningType(rawValue: (UInt8(value) ?? 1)) ?? SHAirConditioningType.hvac

            
        case 5:
            self.hvac?.channelNo = UInt8(value) ?? 0
            
        case 6:
            self.hvac?.temperatureSensorSubNetID = UInt8(value) ?? 0
            
        case 7:
            self.hvac?.temperatureSensorDeviceID = UInt8(value) ?? 0
            
        case 8:
            self.hvac?.temperatureSensorChannelNo = UInt8(value) ?? 0
        default:
            break;
        }
        
        SHSQLManager.share()?.updateHVAC(inZone: hvac)
    }
}

// MARK: - FloorHeating
extension SHDeviceArgsViewController {
    
    /// 刷新 地热
    func refreshFloorHeating() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "Channel No.",
            "Outside Sensor SubNetID",
            "Outside Sensor DeviceID",
            "Outside Sensor ChannelNo"
        ]
        
        argsValues = [
            floorHeating?.floorHeatingRemark ?? "floor heating",
            "\(floorHeating?.subnetID ?? 1)",
            "\(floorHeating?.deviceID ?? 0)",
            "\(floorHeating?.channelNo ?? 0)",
            "\(floorHeating?.outsideSensorSubNetID ?? 0)",
            "\(floorHeating?.outsideSensorDeviceID ?? 0)",
            "\(floorHeating?.outsideSensorChannelNo ?? 0)"
        ]
    }
    
    /// 更新 地热
    func updateFloorHeating(value: String, index: Int) {
        
        switch (index) {
        case 0:
            self.floorHeating?.floorHeatingRemark = value
            
        case 1:
            self.floorHeating?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.floorHeating?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.floorHeating?.channelNo = UInt8(value) ?? 0
            
        case 4:
            self.floorHeating?.outsideSensorSubNetID = UInt8(value) ?? 1
            
        case 5:
            self.floorHeating?.outsideSensorDeviceID = UInt8(value) ?? 0
            
        case 6:
            self.floorHeating?.outsideSensorChannelNo =
                UInt8(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.updateFloorHeating(inZone: floorHeating)
    }
}

// MARK: - DryContact
extension SHDeviceArgsViewController {
    
    /// 刷新 干节点
    func refreshDryContact() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "Channel No."
        ]
        
        argsValues = [
            
            dryContact?.remark ?? "dry node",
            "\(dryContact?.subnetID ?? 1)",
            "\(dryContact?.deviceID ?? 0)",
            "\(dryContact?.channelNo ?? 0)"
        ]
    }
    
    /// 更新 干节点
    func updateDryContact(value: String, index: Int) {
        
        switch (index) {
            
        case 0:
            self.dryContact?.remark = value
            
        case 1:
            self.dryContact?.subnetID = UInt8(value) ?? 0
            
        case 2:
            self.dryContact?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.dryContact?.channelNo = UInt8(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.update(dryContact)
    }
}

// MARK: - TemperatureSensor
extension SHDeviceArgsViewController {
    
    /// 刷新 温度传感器
    func refreshTemperatureSensor() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "Channel No."
        ]
        
        argsValues = [
            
            temperatureSensor?.remark ?? "tem Sensor",
            "\(temperatureSensor?.subnetID ?? 1)",
            "\(temperatureSensor?.deviceID ?? 0)",
            "\(temperatureSensor?.channelNo ?? 0)"
        ]
    }
    
    /// 保存 4T
    func updateTemperatureSensor(value: String, index: Int) {
        
        switch (index) {
            
        case 0:
            self.temperatureSensor?.remark = value
            
        case 1:
            self.temperatureSensor?.subnetID = UInt8(value) ?? 0
            
        case 2:
            self.temperatureSensor?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.temperatureSensor?.channelNo = UInt8(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.update(temperatureSensor)
    }
}

// MARK: - Light
extension SHDeviceArgsViewController {
    
    /// 刷新 light
    func refreshLight() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "Channel No.",
            "Can Dim",
            "LightType"
        ]
        
        argsValues = [
            
            light?.lightRemark ?? "light",
            "\(light?.subnetID ?? 0)",
            "\(light?.deviceID ?? 0)",
            "\(light?.channelNo ?? 0)",
            "\((light?.canDim ?? .notDimmable).rawValue)",
            "\((light?.lightTypeID ?? .incandescent).rawValue)"
        ]
    }
    
    /// 保存
    func updateLight(value: String, index: Int) {
        
        switch (index) {
        case 0:
            self.light?.lightRemark = value
            
        case 1:
            self.light?.subnetID = UInt8(value) ?? 0
            
        case 2:
            self.light?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.light?.channelNo = UInt8(value) ?? 0
            
        case 4:
            self.light?.canDim = SHZoneControlLightCanDimType(rawValue: (UInt8(value) ?? 0)) ?? .notDimmable
            
        case 5:
            self.light?.lightTypeID = SHZoneControlLightType(rawValue: (UInt8(value) ?? 1)) ?? .incandescent
            
        default:
            break;
        }
        
        SHSQLManager.share()?.updateLight(inZone: light)
    }
}

// MARK: - DmxChannel
extension SHDeviceArgsViewController {
    
    /// 刷新dmxGroup
    func refreshDmxGroup() {
        
        argsNames = [
            "Group Name"
        ]
        
        argsValues = [
            dmxGroup?.groupName ?? "dmx group"
        ]
    }
    
    /// 刷新dmxChannel
    func refreshDmxChannel() {
    
        argsNames = [
            "channel Name",
            "channel Type",
            "Subnet ID",
            "Device ID",
            "Chanel NO."
        ]
        
        argsValues = [
            dmxChannel?.remark ?? "dmx channel",
            "\((dmxChannel?.channelType ?? .none).rawValue)",
            "\(dmxChannel?.subnetID ?? 0)",
            "\(dmxChannel?.deviceID ?? 0)",
            "\(dmxChannel?.channelNo ?? 0)"
        ]
    }
    
    /// 保存dmx Group
    func updateDmxGroup(value: String, index: Int) {
    
        switch index {
        
        case 0:
            self.dmxGroup?.groupName = value
        
        default:
            break
        }
        
        SHSQLManager.share()?.update(dmxGroup)
    }
    
    /// 保存dmx通道
    func updateDmxChannel(value: String, index: Int) {
    
        switch (index) {
            
        case 0:
            self.dmxChannel?.remark = value;
            
        case 1:
            self.dmxChannel?.channelType =
                SHDmxChannelType(rawValue: UInt(value) ?? 0) ?? .none
            
        case 2:
            self.dmxChannel?.subnetID = UInt8(value) ?? 1
            
        case 3:
            self.dmxChannel?.deviceID = UInt8(value) ?? 0
            
        case 4:
            self.dmxChannel?.channelNo = UInt8(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.update(dmxChannel)
    }
}

// MARK: - MoodCommand
extension SHDeviceArgsViewController {
    
    /// 更新
    func refreshMooCommand() {
        
        argsNames = [
            "Device Name",
            "Device Type",
            "Subnet ID",
            "Device ID",
            "Parameter1",
            "Parameter2",
            "Parameter3",
            "Parameter4",
            "Parameter5",
            "Parameter6",
            "DelayMillisecondAfterSend"
        ]
        
        argsValues = [
            moodCommand?.deviceName ?? "mood Command",
            "\(moodCommand?.deviceType ?? 0)",
            "\(moodCommand?.subnetID ?? 0)",
            "\(moodCommand?.deviceID ?? 0)",
            "\(moodCommand?.parameter1 ?? 0)",
            "\(moodCommand?.parameter2 ?? 0)",
            "\(moodCommand?.parameter3 ?? 0)",
            "\(moodCommand?.parameter4 ?? 0)",
            "\(moodCommand?.parameter5 ?? 0)",
            "\(moodCommand?.parameter6 ?? 0)",
            "\(moodCommand?.delayMillisecondAfterSend ?? 0)",
        ]
    }
    
    /// 保存
    func updateMoodCommand(value: String, index: Int) {
        
        switch (index) {
            
        case 0:
            self.moodCommand?.deviceName = value
            
        case 1:
            self.moodCommand?.deviceType = UInt(value) ?? 0
            
        case 2:
            self.moodCommand?.subnetID = UInt8(value) ?? 0
            
        case 3:
            self.moodCommand?.deviceID = UInt8(value) ?? 0
            
        case 4:
            self.moodCommand?.parameter1 = UInt(value) ?? 0
            
        case 5:
            self.moodCommand?.parameter2 = UInt(value) ?? 0
            
        case 6:
            self.moodCommand?.parameter3 = UInt(value) ?? 0
            
        case 7:
            self.moodCommand?.parameter4 = UInt(value) ?? 0
            
        case 8:
            self.moodCommand?.parameter5 = UInt(value) ?? 0
            
        case 9:
            self.moodCommand?.parameter6 = UInt(value) ?? 0
            
        case 10:
            self.moodCommand?.delayMillisecondAfterSend = UInt(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.update(moodCommand)
    }
}

// MARK: - macroCommand
extension SHDeviceArgsViewController {
    
    func refreshMacroCommand() {
        
        argsNames = [
            "Remark",
            "Subnet ID",
            "Device ID",
            "CommandTypeID",
            "First Parameter",
            "Second Parameter",
            "Third Parameter",
            "Delay Millisecond AfterSend"
        ]
        
        argsValues = [
            
            macroCommand?.remark ?? "macro Command",
            "\(macroCommand?.subnetID ?? 1)",
            "\(macroCommand?.deviceID ?? 0)",
            "\(macroCommand?.commandTypeID ?? 0)",
            "\(macroCommand?.firstParameter ?? 0)",
            "\(macroCommand?.secondParameter ?? 0)",
            "\(macroCommand?.thirdParameter ?? 0)",
            "\(macroCommand?.delayMillisecondAfterSend ?? 0)"
        ]
    }
    
    /// 更新
    func updateMacroCommand(value: String, index: Int) {
        
        // 更新每一个参数
        switch index {
            
        case 0:
            self.macroCommand?.remark = value
            
        case 1:
            self.macroCommand?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.macroCommand?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.macroCommand?.commandTypeID = UInt(value) ?? 0
            
        case 4:
            self.macroCommand?.firstParameter = UInt(value) ?? 0
            
        case 5:
            self.macroCommand?.secondParameter = UInt(value) ?? 0
            
        case 6:
            self.macroCommand?.thirdParameter = UInt(value) ?? 0
            
        case 7:
            self.macroCommand?.delayMillisecondAfterSend =
                UInt(value) ?? 0
            
        default:
            break
        }
        
        // 保存到数据库
        SHSQLManager.share()?.updateCentralMacroCommand(
            macroCommand
        )
    }
}

// MARK: - SecurityZone
extension SHDeviceArgsViewController {
    
    /// 更新安防
    func refreshSecurityZone() {
     
        // 属性名称
        argsNames = [
            "Security Zone Name",
            "Subnet ID",
            "Device ID",
            "Zone ID"
        ]
        
        // 属性值
        argsValues = [
            securityZone?.zoneNameOfSecurity ?? "Security",
            "\(securityZone?.subnetID ?? 1)",
            "\(securityZone?.deviceID ?? 0)",
            "\(securityZone?.zoneID ?? 0)"
        ]
    }
    
    /// 更新值
    func updateSecurityZone(value: String, index: Int) {
        
        // 更新每一个参数
        switch index {
            
        case 0:
            self.securityZone?.zoneNameOfSecurity = value
            
        case 1:
            self.securityZone?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.securityZone?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.securityZone?.zoneID = UInt(value) ?? 0
            
        default:
            break
        }
        
        // 保存到数据库
        SHSQLManager.share()?.update(securityZone)
    }
}

// MARK: - CT24
extension SHDeviceArgsViewController {
    
    /// 刷新CT24
    func refreshCurrentTransformer() {
        
        // 属性名称
        argsNames = [
            "Remark",
            "Subnet ID",
            "Device ID",
            "Voltage",
            "Channnel1 remark",
            "Channnel2 remark",
            "Channnel3 remark",
            "Channnel4 remark",
            "Channnel5 remark",
            "Channnel6 remark",
            "Channnel7 remark",
            "Channnel8 remark",
            "Channnel9 remark",
            "Channnel10 remark",
            "Channnel11 remark",
            "Channnel12 remark",
            "Channnel13 remark",
            "Channnel14 remark",
            "Channnel15 remark",
            "Channnel16 remark",
            "Channnel17 remark",
            "Channnel18 remark",
            "Channnel19 remark",
            "Channnel20 remark",
            "Channnel21 remark",
            "Channnel22 remark",
            "Channnel23 remark",
            "Channnel24 remark"
        ]
        
        // 属性值
        argsValues = [
            currentTransformer?.remark ?? "CT24",
            "\(currentTransformer?.subnetID ?? 1)",
            "\(currentTransformer?.deviceID ?? 0)",
            "\(currentTransformer?.voltage ?? 0)",
            
            "\(currentTransformer?.channel1 ?? "CH1")",
            "\(currentTransformer?.channel2 ?? "CH2")",
            "\(currentTransformer?.channel3 ?? "CH3")",
            "\(currentTransformer?.channel4 ?? "CH4")",
            "\(currentTransformer?.channel5 ?? "CH5")",
            "\(currentTransformer?.channel6 ?? "CH6")",
            "\(currentTransformer?.channel7 ?? "CH7")",
            "\(currentTransformer?.channel8 ?? "CH8")",
            "\(currentTransformer?.channel9 ?? "CH9")",
            "\(currentTransformer?.channel10 ?? "CH10")",
            "\(currentTransformer?.channel11 ?? "CH11")",
            "\(currentTransformer?.channel12 ?? "CH12")",
            "\(currentTransformer?.channel13 ?? "CH13")",
            "\(currentTransformer?.channel14 ?? "CH14")",
            "\(currentTransformer?.channel15 ?? "CH15")",
            "\(currentTransformer?.channel16 ?? "CH16")",
            "\(currentTransformer?.channel17 ?? "CH17")",
            "\(currentTransformer?.channel18 ?? "CH18")",
            "\(currentTransformer?.channel19 ?? "CH19")",
            "\(currentTransformer?.channel20 ?? "CH20")",
            "\(currentTransformer?.channel21 ?? "CH21")",
            "\(currentTransformer?.channel22 ?? "CH22")",
            "\(currentTransformer?.channel23 ?? "CH23")",
            "\(currentTransformer?.channel24 ?? "CH24")"
            
        ]
    }
    
    /// 更新并保存CT24
    func updateCurrentTransformer(value: String, index: Int) {
        
        // 更新每一个参数
        switch index {
            
        case 0:
            self.currentTransformer?.remark = value
            
        case 1:
            self.currentTransformer?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.currentTransformer?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.currentTransformer?.voltage = UInt(value) ?? 0
            
        case 4:
            self.currentTransformer?.channel1 = value
            
        case 5:
            self.currentTransformer?.channel2 = value
            
        case 6:
            self.currentTransformer?.channel3 = value
            
        case 7:
            self.currentTransformer?.channel4 = value
            
        case 8:
            self.currentTransformer?.channel5 = value
            
        case 9:
            self.currentTransformer?.channel6 = value
            
        case 10:
            self.currentTransformer?.channel7 = value
            
        case 11:
            self.currentTransformer?.channel8 = value
            
        case 12:
            self.currentTransformer?.channel9 = value
            
        case 13:
            self.currentTransformer?.channel10 = value
            
        case 14:
            self.currentTransformer?.channel11 = value
            
        case 15:
            self.currentTransformer?.channel12 = value
            
        case 16:
            self.currentTransformer?.channel13 = value
            
        case 17:
            self.currentTransformer?.channel14 = value
            
        case 18:
            self.currentTransformer?.channel15 = value
            
        case 19:
            self.currentTransformer?.channel16 = value
            
        case 20:
            self.currentTransformer?.channel17 = value
            
        case 21:
            self.currentTransformer?.channel18 = value
            
        case 22:
            self.currentTransformer?.channel19 = value
        
        case 23:
            self.currentTransformer?.channel20 = value
        
        case 24:
            self.currentTransformer?.channel21 = value
            
        case 25:
            self.currentTransformer?.channel22 = value
            
        case 26:
            self.currentTransformer?.channel23 = value
            
        case 27:
            self.currentTransformer?.channel24 = value
            
        default:
            break
        }
        
        // 保存到数据库
        SHSQLManager.share()?.update(currentTransformer)
    }
}
