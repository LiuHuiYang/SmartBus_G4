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
    
    /// 场景控制
    var scene: SHScene?
    
    // MARK: - 通部用部分属性
    
    /// 详情列表
    @IBOutlet weak var detailListView: UITableView!
    
    /// 属性名称
    lazy var argsNames: [String] = [String]()
    
    /// 属性值
    lazy var argsValues: [String] = [String]()
    
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
        
        if scene != nil {
            
            refreshScene()
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
        
        // 保存Scene
        if scene != nil {
            
            updateScene(value: value, index: index)
        }
        
        refreshListView()
    }
}
