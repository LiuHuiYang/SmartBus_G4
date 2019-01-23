//
//  SHZoneDevicesViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/29.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

private let deviceCellReuseIdentifier = "SHZoneDevicesCell"

@objcMembers class SHZoneDevicesViewController: SHViewController {
    
    /// 当前区域
    var currentZone: SHZone?
    
    /// 当前设备类型
    var deviceType: SHSystemDeviceType = .undefined
    
    /// 所有的设备类型
    private var allDevices = [Any]()
    
    /// 列表
    @IBOutlet weak var listView: UICollectionView!
    
    /// 底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.register(
            UINib(nibName: deviceCellReuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: deviceCellReuseIdentifier
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPhoneX_More() {
            listViewBottomConstraint.constant = tabBarHeight_iPhoneX_more
        }
        
        let itemMarign: CGFloat = 1
        
        let totalCols = isPortrait ? 3 : 5
        
        let itemWidth = (listView.frame_width - (CGFloat(totalCols) * itemMarign)) / CGFloat(totalCols)
        
        let flowLayout = listView.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.itemSize =
            CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = itemMarign
        flowLayout.minimumInteritemSpacing = itemMarign
    }
}


// MARK: - UICollectionViewDelegate
extension SHZoneDevicesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if allDevices.isEmpty {
            return
        }
        
        switch deviceType {
            
        case .hvac:
            
            let hvacControlViewController = SHZoneHVACControlViewController()
            
            hvacControlViewController.currentHVAC = allDevices[indexPath.row] as? SHHVAC
            
            navigationController?.pushViewController(
                hvacControlViewController,
                animated: true
            )
            
        case .audio:
            
            let audioPlayControlViewController = SHZoneAudioPlayControlViewController()
            
            audioPlayControlViewController.currentAudio = allDevices[indexPath.row] as? SHAudio
            
            navigationController?.pushViewController(
                audioPlayControlViewController,
                animated: true
            )
            
        case .tv:
            
            let tvController = SHZoneTVViewController()
            
            tvController.zoneTV = allDevices[indexPath.row] as? SHMediaTV
            
            navigationController?.pushViewController(
                tvController,
                animated: true
            )
            
        case .dvd:
            
            let dvdControlViewController = SHZoneDVDControlViewController()
            
            dvdControlViewController.zoneDVD = allDevices[indexPath.row] as? SHMediaDVD
            
            navigationController?.pushViewController(
                dvdControlViewController,
                animated: true
            )
            
            
        case .sat:
            
            let satController = SHZoneSATViewController()
            
            satController.zoneSAT = allDevices[indexPath.row] as? SHMediaSAT
            
            navigationController?.pushViewController(
                satController,
                animated: true
            )
            
        case .appletv:
            
            let appleTVControlViewController =
                SHZoneAppleTVControlViewController()
            
            appleTVControlViewController.zoneAppleTV =
                allDevices[indexPath.row] as? SHMediaAppleTV
            
            navigationController?.pushViewController(
                appleTVControlViewController,
                animated: true
            )
            
        case .projector:
            
            let zoneProjectorController =
                SHZoneProjectorViewController()
            
            zoneProjectorController.zoneProjector =
                allDevices[indexPath.row] as? SHMediaProjector
            
            navigationController?.pushViewController(
                zoneProjectorController,
                animated: true
            )
            
        case .floorHeating:
            
            let floorHeatingViewController =
                SHZoneControlFloorHeatingControlViewController()
            
            floorHeatingViewController.currentFloorHeating =
                allDevices[indexPath.row] as? SHFloorHeating
            
            navigationController?.pushViewController(
                floorHeatingViewController,
                animated: true
            )
            
        case .nineInOne:
            
            let nineInOneViewController =
                SHZoneNineInOneControlViewController()
            
            nineInOneViewController.currentNineInOne =
                allDevices[indexPath.row] as? SHNineInOne
            
            navigationController?.pushViewController(
                nineInOneViewController,
                animated: true
            )
            
        case .dmx:
            
            
            let dmxGroup =
                allDevices[indexPath.row] as? SHDmxGroup
            
            let dmxGroupController = SHZoneDmxGroupViewController(dmxGroup: dmxGroup)
            
            navigationController?.pushViewController(
                dmxGroupController!,
                animated: true
            )
            
        default:
            break
        }
    }
}

// MARK: - 获取设备
extension SHZoneDevicesViewController {
    
    /// 获得设备
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let zoneID = currentZone?.zoneID else {
            return
        }
        
        switch deviceType {
            
        case .hvac:
            
            let hvacs =
                SHSQLiteManager.shared.getHVACs(zoneID)
            
            allDevices = hvacs as [Any]
            
        case .audio:
            
            let audios =
                SHSQLiteManager.shared.getAudios(zoneID)
            
            allDevices = audios as [Any]
            
        case .tv:
           
            let tvs = SHSQLiteManager.shared.getMediaTV(zoneID)
            allDevices = tvs as [Any]
            
        case .dvd:
            
            let dvds = SHSQLiteManager.shared.getDVDs(zoneID)
            allDevices = dvds as [Any]
            
        case .sat:
            if let sats =  SHSQLManager.share()?.getMediaSAT(for: zoneID) {
                
                allDevices = sats as! [Any]
            }
            
        case .appletv:
             
            let appleTVs = SHSQLiteManager.shared.getAppleTV(zoneID)
            
            allDevices = appleTVs as [Any]

        case .projector:
            if let projectors =  SHSQLManager.share()?.getMediaProjector(for: zoneID) {
                
                allDevices = projectors as! [Any]
            }
            
        case .floorHeating:
          
            let floorHeaters =
                SHSQLiteManager.shared.getFloorHeatings(
                    zoneID
            )
            
            allDevices = floorHeaters as [Any]
            
        case .nineInOne:
            if let nineInOnes =  SHSQLManager.share()?.getNineInOne(forZone: zoneID) {
                
                allDevices = nineInOnes as! [Any]
            }
            
        case .dmx:
            
            let dmxs =
                SHSQLiteManager.shared.getDmxGroup(zoneID)
            
             allDevices = dmxs as [Any]
            
        default:
            break
        }
    
        listView.reloadData()
    }
}


extension SHZoneDevicesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allDevices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: deviceCellReuseIdentifier,
                for: indexPath
                ) as! SHZoneDevicesCell
        
        switch deviceType {
            
        case .hvac:
            cell.zoneHVAC = allDevices[indexPath.row] as? SHHVAC
            
        case .audio:
            cell.zoneAudio = allDevices[indexPath.row] as? SHAudio
            
        case .tv:
            cell.zoneTV = allDevices[indexPath.row] as? SHMediaTV
            
        case .dvd:
            cell.zoneDVD = allDevices[indexPath.row] as? SHMediaDVD
            
        case .sat:
            cell.zoneSAT = allDevices[indexPath.row] as? SHMediaSAT
            
        case .appletv:
            cell.zoneAppleTV = allDevices[indexPath.row] as? SHMediaAppleTV
            
        case .projector:
            cell.zoneProjector = allDevices[indexPath.row] as? SHMediaProjector
            
        case .floorHeating:
            cell.floorHeating = allDevices[indexPath.row] as? SHFloorHeating
            
        case .nineInOne:
            cell.nineInOne = allDevices[indexPath.row] as? SHNineInOne
            
        case .dmx:
            cell.dmxGroup = allDevices[indexPath.row] as? SHDmxGroup
            
        default:
            break
        }
        
        return cell
    }
}
