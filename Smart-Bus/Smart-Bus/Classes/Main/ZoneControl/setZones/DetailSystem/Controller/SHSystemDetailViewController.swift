//
//  SHSystemDetailViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/15.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

@objcMembers class SHSystemDetailViewController: SHViewController {

    /// 区域模型
    var currentZone: SHZone?
    
    /// 系统ID
    var systemType: SHSystemDeviceType = .undefined

    /// 同一类型的所有设备
    private var allDevices = NSMutableArray()
    
    /// 所有同类型设备列表
    @IBOutlet weak var allDevicesListView: UITableView!
}


// MARK: - UITableViewDelegate
extension SHSystemDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        updateDevicesArgs(indexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // 删除操作
        let deleteAction = UITableViewRowAction(style: .destructive, title: SHLanguageText.delete) { (action, indexPath) in
            
            tableView.setEditing(false, animated: false)
            
            switch self.systemType {
                
            case .light:
                
                if let light = self.allDevices[indexPath.row]
                        as? SHLight {
                   
                    _ = SHSQLiteManager.shared.deleteLight(
                        light
                    )
                    
                    self.allDevices.remove(light)
                }
            
            case .hvac:
                
                if let hvac = self.allDevices[indexPath.row]
                        as? SHHVAC {
                    
                    self.allDevices.remove(hvac)
                    
                    _ = SHSQLiteManager.shared.deleteHVAC(
                        hvac
                    )
                }
                
            case .audio:
                
                if let audio = self.allDevices[indexPath.row]
                        as? SHAudio {
                 
                    self.allDevices.remove(audio)
                    
                    _ = SHSQLiteManager.shared.deleteAudio(
                        audio
                    )
                }
                
            case .shade:
                
                if let shade = self.allDevices[indexPath.row]
                        as? SHShade {
                    
                    self.allDevices.remove(shade)
                    
                    _ = SHSQLiteManager.shared.deleteShade(
                        shade
                    )
                }
                
            case .tv:
                
                if let tv = self.allDevices[indexPath.row]
                        as? SHMediaTV {
               
                    self.allDevices.remove(tv)
                    
                    _ = SHSQLiteManager.shared.deleteTV(tv)
                }
                
            case .dvd:
                
                if let dvd = self.allDevices[indexPath.row]
                        as? SHMediaDVD {
                    
                    SHSQLManager.share()?.deleteDVD(
                        inZone: dvd
                    )
                    
                    self.allDevices.remove(dvd)
                }
                
            case .sat:
                
                if let sat = self.allDevices[indexPath.row]
                        as? SHMediaSAT {
                    
                    SHSQLManager.share()?.deleteSAT(
                        inZone: sat
                    )
                    
                    self.allDevices.remove(sat)
                }
                
            case .appletv:
                
                if let appletv = self.allDevices[indexPath.row]
                        as? SHMediaAppleTV {
                    
                    SHSQLManager.share()?.deleteAppleTV(
                        inZone: appletv
                    )
                    
                    self.allDevices.remove(appletv)
                }
                
            case .projector:
                if let projector = self.allDevices[indexPath.row]
                        as? SHMediaProjector {
                    
                    SHSQLManager.share()?.deleteProjector(
                        inZone: projector
                    )
                    
                    self.allDevices.remove(projector)
                }
                
            case .fan:
                
                if let fan = self.allDevices[indexPath.row]
                        as? SHFan {
                    
                    _ = SHSQLiteManager.shared.deleteFan(fan)
                    
                    self.allDevices.remove(fan)
                }
                
            case .floorHeating:
                
                if let floorHeating = self.allDevices[indexPath.row]
                        as? SHFloorHeating {
                    
                    
                    self.allDevices.remove(floorHeating)
                    
                    _ = SHSQLiteManager.shared.deleteFloorHeating(floorHeating)
                }
                
            case .nineInOne:
                
                if let nineInOne = self.allDevices[indexPath.row]
                        as? SHNineInOne {
                    
                    SHSQLManager.share()?.deleteNineInOne(
                         inZone: nineInOne
                    )
                    
                    self.allDevices.remove(nineInOne)
                }
                
            case .dryContact:
                
                if let dryContact = self.allDevices[indexPath.row]
                        as? SHDryContact {
                    
                    self.allDevices.remove(dryContact)
                    
                    _ = SHSQLiteManager.shared.deleteDryContact(dryContact)
                }
                
            case .temperatureSensor:
                
                if let sensor = self.allDevices[indexPath.row]
                        as? SHTemperatureSensor {
                    
                    self.allDevices.remove(sensor)
                    
                    _ = SHSQLiteManager.shared.deleteTemperatureSensor(sensor)
                }
                
            case .sceneControl:
                
                if let scene = self.allDevices[indexPath.row]
                        as? SHScene {
                   
                    self.allDevices.remove(scene)
                    
                    _ = SHSQLiteManager.shared.deleteScene(
                        scene
                    )
                }
                
            case .sequenceControl:
                
                if let sequence  = self.allDevices[indexPath.row]
                        as? SHSequence {
                    
                    _ = SHSQLiteManager.shared.deleteSequence(sequence)
                     
                    self.allDevices.remove(sequence)
                }
                
            case .otherControl:
                break
                
                
            default:
                break
            }
            
            tableView.reloadData()
        }
        
        let editAction =
            UITableViewRowAction(
                style: .normal,
                title: SHLanguageText.edit)
            { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
                self.updateDevicesArgs(indexPath)
        }
        
        return [deleteAction, editAction]
    }
    
    /// 更新参数
    private func updateDevicesArgs(
        _ indexPath: IndexPath) {
    
        let detailController =
            SHDeviceArgsViewController()
        
        switch systemType {
        case .light:
            if let light =
                allDevices[indexPath.row]
                    as? SHLight {
                
                detailController.light = light
            }
            
        case .hvac:
            
            if let hvac =
                allDevices[indexPath.row]
                    as? SHHVAC {
                
                detailController.hvac = hvac
            }
            
        case .audio:
            
            if let audio =
                allDevices[indexPath.row]
                    as? SHAudio {
                
                detailController.audio = audio
            }
            
        case .shade:
            
            if let shade =
                allDevices[indexPath.row]
                    as? SHShade {
                
                detailController.shade = shade
            }
            
        case .tv:
            
            if let tv =
                allDevices[indexPath.row]
                    as? SHMediaTV {
                
                detailController.mediaTV = tv
            }
            
        case .dvd:
            
            if let dvd =
                allDevices[indexPath.row]
                    as? SHMediaDVD {
                
                detailController.mediaDVD = dvd
            }
            
        case .sat:
            
            if let sat =
                allDevices[indexPath.row]
                    as? SHMediaSAT {
                
                detailController.mediaSAT = sat
            }
            
        case .appletv:
            
            if let appletv =
                allDevices[indexPath.row]
                    as? SHMediaAppleTV {
                
                detailController.mediaAppleTV =
                    appletv
            }
        
        case .projector:
            
            if let projector =
                allDevices[indexPath.row]
                    as? SHMediaProjector {
                
                detailController.mediaProjector =
                    projector
            }
            
        case .fan:
            
            if let fan =
                allDevices[indexPath.row]
                    as? SHFan {
                
                detailController.fan = fan
            }
            
        case .floorHeating:
            
            if let floorHeating =
                allDevices[indexPath.row]
                    as? SHFloorHeating {
                
                detailController.floorHeating =
                    floorHeating
            }
            
        case .nineInOne:
            
            if let nineInOne =
                allDevices[indexPath.row]
                    as? SHNineInOne {
                
                detailController.nineInOne =
                    nineInOne
            }
            
        case .dryContact:
            
            if let dryContact =
                allDevices[indexPath.row]
                    as? SHDryContact {
                
                detailController.dryContact =
                    dryContact
            }
            
        case .temperatureSensor:
            
            if let sensor =
                allDevices[indexPath.row]
                    as? SHTemperatureSensor {
                
                detailController.temperatureSensor =
                    sensor
            }
            
        case .sceneControl:
            
            if let scene =
                allDevices[indexPath.row]
                    as? SHScene {
                
                detailController.scene =
                    scene
            }
            
        case .sequenceControl:
            
            if let sequence =
                allDevices[indexPath.row]
                    as? SHSequence {
                
                detailController.sequence =
                    sequence
            }
            
        default:
            break
        }
        
        navigationController?.pushViewController(
            detailController,
            animated: true
        )
    }

}

// MARK: - UITableViewDataSource
extension SHSystemDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier:  deviceGroupSettingCellReuseIdentifier,
                for: indexPath
        ) as! SHZoneDeviceGroupSettingCell
        
        var deviceName = "N/A"
        
        switch systemType {
        
        case .light:
            if let light = allDevices[indexPath.row]
                as? SHLight {
                
                let suffix =
                    (light.lightTypeID == .led) ? "" :
                    " - \(light.channelNo)"
                
                deviceName =
                    "\(light.lightID) - "     +
                    "\(light.lightRemark) : " +
                    "\(light.subnetID) - "    +
                    "\(light.deviceID)"       +
                    suffix
            }
            
        case .hvac:
            
            if let hvac = allDevices[indexPath.row]
                as? SHHVAC {
                
                deviceName =
                    "\(hvac.acRemark) : " +
                    "\(hvac.subnetID) - " +
                    "\(hvac.deviceID)"
            }
            
        case .audio:
            
            if let audio = allDevices[indexPath.row]
                as? SHAudio {
                
                deviceName =
                    "\(audio.audioName) : " +
                    "\(audio.subnetID) - "  +
                    "\(audio.deviceID)"
            }
            
        case .shade:
            
            if let shade = allDevices[indexPath.row]
                as? SHShade {
                
                deviceName =
                    "\(shade.shadeName) : " +
                    "\(shade.subnetID) - "  +
                    "\(shade.deviceID)"
            }
            
        case .tv:
            
            if let tv = allDevices[indexPath.row]
                as? SHMediaTV {
                
                deviceName =
                    "\(tv.remark ?? "TV") : " +
                    "\(tv.subnetID) - "       +
                    "\(tv.deviceID)"
            }
            
        case .dvd:
            if let dvd = allDevices[indexPath.row]
                as? SHMediaDVD {
                
                deviceName =
                    "\(dvd.remark ?? "DVD") : " +
                    "\(dvd.subnetID) - "        +
                    "\(dvd.deviceID)"
            }
            
            
        case .sat:
            if let sat = allDevices[indexPath.row]
                as? SHMediaSAT {
                
                deviceName =
                    "\(sat.remark ?? "SAT.") : " +
                    "\(sat.subnetID) - "         +
                    "\(sat.deviceID)"
            }
            
        case .appletv:
            if let appletv = allDevices[indexPath.row]
                as? SHMediaAppleTV {
                
                deviceName =
                    "\(appletv.remark ?? "Apple TV") : " +
                    "\(appletv.subnetID) - " +
                    "\(appletv.deviceID)"
            }
            
        case .projector:
            if let projector = allDevices[indexPath.row]
                as? SHMediaProjector {
                
                deviceName =
                    "\(projector.remark ?? "Projector") : "       +
                    "\(projector.subnetID) - " +
                    "\(projector.deviceID)"
            }
            
        case .fan:
            
            if let fan = allDevices[indexPath.row]
                as? SHFan {
                
                deviceName =
                    "\(fan.fanID) - "    +
                    "\(fan.fanName) : "  +
                    "\(fan.subnetID) - " +
                    "\(fan.deviceID) - " +
                    "\(fan.channelNO)"
            }
            
        case .floorHeating:
            
            if let floorHeating =
                allDevices[indexPath.row]
                    as? SHFloorHeating {
                
                deviceName =
                    "\(floorHeating.floorHeatingID) - " +
                    "\(floorHeating.floorHeatingRemark) : " +
                    "\(floorHeating.subnetID) - " +
                    "\(floorHeating.deviceID) - " +
                    "\(floorHeating.channelNo)"
            }
            
        case .nineInOne:
            
            if let nineInOne = allDevices[indexPath.row]
                as? SHNineInOne {
                
                deviceName =
                    "\(nineInOne.nineInOneID) - " +
                    "\(nineInOne.nineInOneName ?? "9in1") : "               +
                    "\(nineInOne.subnetID) - "    +
                    "\(nineInOne.deviceID)"
            }
            
        case .dryContact:
            
            if let node = allDevices[indexPath.row]
                as? SHDryContact {
            
                deviceName =
                    "\(node.contactID) - "            +
                    "\(node.remark ?? "dry node") : " +
                    "\(node.subnetID) - "             +
                    "\(node.deviceID) - "             +
                    "\(node.channelNo)"
            }
            
        case .temperatureSensor:
            
            if let sensor = allDevices[indexPath.row]
                as? SHTemperatureSensor {
                
                deviceName =
                    "\(sensor.temperatureID) - " +
                    "\(sensor.remark ?? "temperature") : "                        +
                    "\(sensor.subnetID) - "      +
                    "\(sensor.deviceID) - "      +
                    "\(sensor.channelNo)"
            }
            
        case .sceneControl:
            
            if let scene = allDevices[indexPath.row]
                as? SHScene {
                
                deviceName =
                    "\(scene.sceneID) - "  +
                    "\(scene.remark) : "   +
                    "\(scene.subnetID) - " +
                    "\(scene.deviceID) - " +
                    "\(scene.areaNo) - "   +
                    "\(scene.sceneNo)"
            }
            
        case .sequenceControl:
            
            if let sequence = allDevices[indexPath.row]
                as? SHSequence {
                
                deviceName =
                    "\(sequence.sequenceID) - "  +
                    "\(sequence.remark) : "   +
                    "\(sequence.subnetID) - " +
                    "\(sequence.deviceID) - " +
                    "\(sequence.areaNo) - "   +
                    "\(sequence.sequenceNo)"
            }
            
        default:
            break
        }
        
        
        cell.deviceName = deviceName
        
        return cell
    }
    
    
    
}

// MARK: - UI初始化
extension SHSystemDetailViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getDevices()
        
        if allDevices.count == 0 {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
        }
        
        allDevicesListView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航栏设置
        
        navigationItem.title = "Devices Setting"
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "addDevice_navigationbar",
                hightlightedImageName:
                    "addDevice_navigationbar",
                addTarget: self,
                action: #selector(addNewDevices),
                isLeft: false
        )
        
        // 表格设置
        allDevicesListView.rowHeight =
            SHZoneDeviceGroupSettingCell.rowHeight
        
        allDevicesListView.register(
            UINib(nibName:
                deviceGroupSettingCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
                deviceGroupSettingCellReuseIdentifier
        )
    }
}


// MARK: - 获取设备
extension SHSystemDetailViewController {
    
    /// 添加新设备
    @objc private func addNewDevices() {
        
        guard let zoneID = currentZone?.zoneID else {
            return
        }
        
        let detailController =
            SHDeviceArgsViewController()
        
        switch systemType {
            
        case .light:
            
            let light = SHLight()
            
            light.lightRemark = "light"
            light.zoneID = zoneID
            light.lightID =  SHSQLiteManager.shared.getMaxLightID(
                    zoneID) + 1
            
            _ = SHSQLiteManager.shared.insertLight(light)
            
            detailController.light = light
            
        case .hvac:
            
            let hvac = SHHVAC()
            
            hvac.acRemark = "hvac"
            hvac.zoneID = zoneID
            
            let id = SHSQLiteManager.shared.insertHVAC(hvac)
            
            hvac.id = (id == 0) ? 1 : id
            
            detailController.hvac = hvac
            
        case .audio:
            let audio = SHAudio()
            audio.zoneID = zoneID
            audio.havePhone = 0
            audio.haveSdCard = 1
            audio.haveFtp = 1
            audio.haveRadio = 1
            audio.haveAudioIn = 1
            audio.audioName =
                "\(currentZone!.zoneName ?? "") Audio"
            
            let result =
                SHSQLiteManager.shared.insertAudio(audio)
            
            audio.id = (result == 0) ? 1 : result
            
            detailController.audio = audio
            
        case .shade:
            let shade = SHShade()
            shade.shadeName = "shade"
            shade.zoneID = zoneID
            shade.shadeID =
                SHSQLiteManager.shared.getMaxShadeID(
                    zoneID) + 1
            
            shade.remarkForStop = "stop"
            shade.remarkForClose = "close"
            shade.remarkForOpen = "open"
            
            _ = SHSQLiteManager.shared.insertShade(shade)
            
            detailController.shade = shade
            
        case .tv:
            let tv = SHMediaTV()
            tv.remark = "tv"
            tv.zoneID = zoneID
            
            let result = SHSQLManager.share()?.inserNewMediaTV(
                    tv) ?? 1
            
            tv.id = UInt(result)
            
            detailController.mediaTV = tv
            
        case .dvd:
            let dvd = SHMediaDVD()
            dvd.remark = "dvd"
            dvd.zoneID = zoneID
            
            let result = SHSQLManager.share()?.inserNewMediaDVD(
                dvd) ?? 1
            
            dvd.id = UInt(result)
            
            detailController.mediaDVD = dvd
            
        case .sat:
            let sat = SHMediaSAT()
            sat.remark = "Satellite TV"
            sat.zoneID = zoneID
            sat.switchNameforControl1 = "C1"
            sat.switchNameforControl2 = "C2"
            sat.switchNameforControl3 = "C3"
            sat.switchNameforControl4 = "C4"
            sat.switchNameforControl5 = "C5"
            sat.switchNameforControl6 = "C6"
            
            let result = SHSQLManager.share()?.insertNewMediaSAT(
                sat) ?? 1
            
            sat.id = UInt(result)
            
            detailController.mediaSAT = sat
            
        case .appletv:
            let appleTV = SHMediaAppleTV()
            appleTV.remark = "Apple TV"
            appleTV.zoneID = zoneID
            
            let result = SHSQLManager.share()?.insertNewMediaAppleTV( appleTV) ?? 1
            
            appleTV.id = UInt(result)
            
            detailController.mediaAppleTV = appleTV
            
        case .projector:
            let projector = SHMediaProjector()
            projector.remark = "projector"
            projector.zoneID = zoneID
            
            let result = SHSQLManager.share()?.insertNewMediaProjector(projector) ?? 1
            
            projector.id = UInt(result)
            
            detailController.mediaProjector = projector
            
            
        case .fan:
            let fan = SHFan()
            fan.fanName = "fan"
            fan.zoneID = zoneID
            fan.fanID =
                SHSQLiteManager.shared.getMaxFanID(
                    zoneID) + 1
        
            _ = SHSQLiteManager.shared.insertFan(fan)
            
            detailController.fan = fan
            
        case .floorHeating:
            let floorHeating = SHFloorHeating()
            floorHeating.floorHeatingRemark =
                "floorHeating"
            floorHeating.zoneID = zoneID
            floorHeating.floorHeatingID =
                SHSQLiteManager.shared.getMaxFloorHeatingID(
                    zoneID) + 1
            
            _ = SHSQLiteManager.shared.insertFloorHeating(
                floorHeating
            )
            
            detailController.floorHeating = floorHeating
    
        case .nineInOne:
            let nineInOne = SHNineInOne()
            nineInOne.nineInOneName = "9in1";
            nineInOne.zoneID = zoneID
            nineInOne.nineInOneID =
                (SHSQLManager.share()?.getMaxNineInOneID(
                    forZone: zoneID) ?? 0) + 1
            
            nineInOne.switchNameforControl1 = "C1"
            nineInOne.switchNameforControl2 = "C2"
            nineInOne.switchNameforControl3 = "C3"
            nineInOne.switchNameforControl4 = "C4"
            nineInOne.switchNameforControl5 = "C5"
            nineInOne.switchNameforControl6 = "C6"
            nineInOne.switchNameforControl7 = "C7"
            nineInOne.switchNameforControl8 = "C8"
            
            nineInOne.switchNameforSpare1 = "Spare_1"
            nineInOne.switchNameforSpare2 = "Spare_2"
            nineInOne.switchNameforSpare3 = "Spare_3"
            nineInOne.switchNameforSpare4 = "Spare_4"
            nineInOne.switchNameforSpare5 = "Spare_5"
            nineInOne.switchNameforSpare6 = "Spare_6"
            nineInOne.switchNameforSpare7 = "Spare_7"
            nineInOne.switchNameforSpare8 = "Spare_8"
            nineInOne.switchNameforSpare9 = "Spare_9"
            nineInOne.switchNameforSpare10 = "Spare_10"
            nineInOne.switchNameforSpare11 = "Spare_11"
            nineInOne.switchNameforSpare12 = "Spare_12"
            
            SHSQLManager.share()?.insertNewNine(
                nineInOne
            )
            
            detailController.nineInOne = nineInOne
            
        case .dryContact:
            let dryContact = SHDryContact()
            
            dryContact.remark = "dry contact"
            dryContact.zoneID = zoneID
            
            dryContact.contactID =   SHSQLiteManager.shared.getMaxDryContactID(
                    zoneID) + 1
            
            _ = SHSQLiteManager.shared.insertDryContact(
                dryContact
            )
            
            detailController.dryContact = dryContact
            
        case .temperatureSensor:
            
            let sensor = SHTemperatureSensor()
            
            sensor.remark = "temperature sensor"
            sensor.zoneID = zoneID
            
            sensor.temperatureID = SHSQLiteManager.shared.getMaxTemperatureID(
                    zoneID) + 1
            
            _ = SHSQLiteManager.shared.insertTemperatureSensor(sensor)
            
            detailController.temperatureSensor = sensor
            
        case .sceneControl:
            
            let scene = SHScene()
            
            scene.remark = "scene"
            scene.zoneID = zoneID
            scene.sceneID =
                SHSQLiteManager.shared.getMaxSceneID(
                    zoneID) + 1
             
            _ = SHSQLiteManager.shared.insertScene(scene)
            
            detailController.scene = scene
            
        case .sequenceControl:
            
            let sequence = SHSequence()
            sequence.remark = "sequence"
            sequence.zoneID = zoneID
            sequence.sequenceID =
                SHSQLiteManager.shared.getMaxSequenceID(
                    zoneID) + 1
            
            _ = SHSQLiteManager.shared.insertSequence(
                sequence
            )
            
            detailController.sequence = sequence
            
        default:
            break
        }
    
        
        navigationController?.pushViewController(
            detailController,
            animated: true
        )
    }
    
    /// 获取设备信息
    private func getDevices() {
        
        guard let zoneID = currentZone?.zoneID else {
            return
        }
        
        switch systemType {
        
        case .light:
            
            let lights = SHSQLiteManager.shared.getLights(
                zoneID)
            
           allDevices = NSMutableArray(array: lights)
            
        case .hvac:
         
            let hvacs =
                SHSQLiteManager.shared.getHVACs(zoneID)
            
            allDevices = NSMutableArray(array: hvacs)
            
        case .audio:
            
            let audios = SHSQLiteManager.shared.getAudios(zoneID)
            
            allDevices = NSMutableArray(array: audios)
            
        case .shade:
       
            let shades =
                SHSQLiteManager.shared.getShades(zoneID)
            
            allDevices =  NSMutableArray(array: shades)
            
        case .tv:
         
            let tvs = SHSQLiteManager.shared.getMediaTV(zoneID)
            
            allDevices =  NSMutableArray(array: tvs)
            
        case .dvd:
            guard let dvds =
                SHSQLManager.share()?.getMediaDVD(
                    for: zoneID
                ) else {
                return
            }
            
            allDevices = dvds
            
        case .sat:
            guard let sats =
                SHSQLManager.share()?.getMediaSAT(
                    for: zoneID) else {
                
                return
            }
            
            allDevices = sats
            
        case .appletv:
            guard let appleTVs =
                SHSQLManager.share()?.getMediaAppleTV(
                    for: zoneID) else {
                
                return
            }
            
            allDevices = appleTVs
            
        case .projector:
            guard let projectors = SHSQLManager.share()?.getMediaProjector(
                    for: zoneID) else {
                
                return
            }
            
            allDevices = projectors
            
            
        case .fan:
           
            let fans = SHSQLiteManager.shared.getFans(zoneID)
           
            allDevices = NSMutableArray(array: fans)
            
        case .floorHeating:
            
            let floorHeatings =
                SHSQLiteManager.shared.getFloorHeatings(
                    zoneID
                )
            
            allDevices = NSMutableArray(array: floorHeatings)
            
        case .nineInOne:
            guard let nineInOnes =
                SHSQLManager.share()?.getNineInOne(
                    forZone: zoneID) else {
                
                return
            }
            
            allDevices = nineInOnes
            
        case .dryContact:
           
            let nodes =
                SHSQLiteManager.shared.getDryContact(zoneID)
            
            allDevices = NSMutableArray(array: nodes)
            
        case .temperatureSensor:
            
            let sensors = SHSQLiteManager.shared.getTemperatureSensors(
                    zoneID: zoneID
            )
            
            allDevices = NSMutableArray(array: sensors)
            
        case .sceneControl:
            
            let scenes =
                SHSQLiteManager.shared.getScenes(zoneID)
            
            allDevices = NSMutableArray(array: scenes)
            
        case .sequenceControl:
           
            let sequences =
                SHSQLiteManager.shared.getSequences(zoneID)
            
            allDevices = NSMutableArray(array: sequences)
            
        default:
            break
        }
    }
}
