//
//  SHZoneControlViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/2/2.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

/// cell重用标示符
private let zoneControlCellReuseIdentifier =
    "SHZoneControlViewCell"

/// deviceCell重用标标
private let deviceCellReuseIdentifier = "SHDeviceViewCell"

class SHZoneControlViewController: SHViewController {
    
    /// 地区
    var region: SHRegion?
    
    /// 所有的区域
    private lazy var allZones = [SHZone]()
    
    /// 所有在线设备
    private lazy var devices = [SHDevice]()

    /// 区域列表
    @IBOutlet weak var listView: UICollectionView!
    
    /// listView的底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!
    
    /// 按钮的高度约束
    @IBOutlet weak var sureButtonHeghtConstraint: NSLayoutConstraint!
    
    /// 确定按钮
    @IBOutlet weak var sureButton: UIButton!
    
    /// 搜索设备视图
    @IBOutlet weak var serchView: UIView!
    
    /// 设备列表
    @IBOutlet weak var deviceListView: UITableView!
    
    /// 点击确定
    @IBAction func sureButtonClick() {
    
        serchView.isHidden = true
    }
}


// MARK: - 设置在线状态与解析
extension SHZoneControlViewController {
    
    /// 解析数据
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        if socketData.operatorCode != 0x000F {
        
            return
        }
        
        let device = SHDevice()
        device.subNetID = socketData.subNetID
        device.deviceID = socketData.deviceID
        device.deviceType = UInt(socketData.deviceType)
        
        device.remark =
            String(bytes: socketData.additionalData,
                   encoding: String.Encoding.utf8
            ) ?? ""
        
        var index: Int = 0
        while index < devices.count {
            let dev = devices[index]
            
            if dev.subNetID == device.subNetID &&
                dev.deviceID == device.deviceID {
            
                break
            }
            
            index += 1
        }
        
        if index >= devices.count {
            
            devices.append(device)
            deviceListView.reloadData()
        }
    }
    
    /// 搜索设备
    @objc private func searchDevices() {
        
        serchView.isHidden = false
        
        devices.removeAll()
        
        SHSocketTools.sendData(
            operatorCode: 0x000E,
            subNetID: 0xFF,
            deviceID: 0xFF,
            additionalData: []
        )
        
        // 同时搜索DMX
        SHSocketTools.sendData(
            operatorCode: 0x000E,
            subNetID: 0xFF,
            deviceID: 0xFF,
            additionalData: [],
            isDMX: true
        )
    }
}

// MARK: - 设置增加与删除
extension SHZoneControlViewController {
    
    /// 设置区域
    @objc private func addNewZones() {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            return
        }
        
        let zone = SHZone()
        zone.zoneID =
            SHSQLiteManager.shared.getMaxZoneID() + 1
        zone.zoneName = "New Zone"
        zone.zoneIconName = "Demokit"
        zone.regionID = region?.regionID ?? 1 // 默认是1
        
        _ = SHSQLiteManager.shared.insertZone(zone)
        
        let systemViewController = SHAreaSettingViewController()
        
        systemViewController.currentZone = zone
        
        navigationController?.pushViewController(
            systemViewController,
            animated: true
        )
    }
    
    /// 设置区域
    @objc private func settingZones(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            return
        }
        
        if longPressGestureRecognizer.state != .began {
            return
        }
        
        guard let index =
            listView.indexPathForItem(
                at: longPressGestureRecognizer.location(
                    in: listView)
            ) else {
                
                return
        }
        
        
        let alertView = TYCustomAlertView(title: nil,
                                          message: nil,
                                          isCustom: true
        )
        
        let editAction =
            TYAlertAction(
                title: SHLanguageText.edit,
                style: .default) { (action) in
                    
                    let zone = self.allZones[index.item]
                    
                    let systemViewController = SHAreaSettingViewController()
                    
                    systemViewController.currentZone = zone;
                    
                    self.navigationController?.pushViewController(
                        systemViewController,
                        animated: true
                    )
                    
        }
        
        alertView?.add(editAction)
        
        let deleteAction =
            TYAlertAction(title: SHLanguageText.delete,
                          style: .destructive) { (action) in
                            
                            let zone = self.allZones[index.item]
                            self.allZones.remove(at: index.item)
                            
                            _ = SHSQLiteManager.shared.deleteZone(zone.zoneID)
                            
                            self.listView.reloadData()
        }
        
        alertView?.add(deleteAction)
        
        let cancelAction =
            TYAlertAction(title: SHLanguageText.cancel,
                          style: .cancel,
                          handler: nil
        )
        
        alertView?.add(cancelAction)
        
        let alertController =
            TYAlertController(alert: alertView,
                              preferredStyle: .alert,
                              transitionAnimation: .custom
        )
        
        alertController?.backgoundTapDismissEnable = true
        
        present(alertController!, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension SHZoneControlViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentZone = allZones[indexPath.item]
        
        let systemDevices =  SHSQLiteManager.shared.getSystemIDs(
                currentZone.zoneID
        )
    
        if systemDevices.isEmpty {
            
            let systemViewController =
                SHAreaSettingViewController()
            
            systemViewController.currentZone = currentZone
            
            navigationController?.pushViewController(
                systemViewController,
                animated: true
            )
            
            return
        }
        
        let zoneController =
            SHAreaControlViewController.init(zone: currentZone)
        
        navigationController?.pushViewController(
            zoneController!,
            animated: true
        )
    }
}

// MARK: - UICollectionViewDataSource
extension SHZoneControlViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allZones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: zoneControlCellReuseIdentifier,
                for: indexPath
            ) as! SHZoneControlViewCell
        
        cell.currentZone = allZones[indexPath.item]
        
        return cell
    }
}

// MARK: - UITableViewDataSource
extension SHZoneControlViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: deviceCellReuseIdentifier,
                for: indexPath
                ) as! SHDeviceViewCell
        
        cell.device = devices[indexPath.row]
       
        return cell
    }
}

// MARK: - UI设置
extension SHZoneControlViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addItem =
            UIBarButtonItem(
                imageName: "addDevice_navigationbar",
                hightlightedImageName: "addDevice_navigationbar",
                addTarget: self,
                action: #selector(addNewZones),
                isLeft: false
        )
        
        let searchItem =
            UIBarButtonItem(
                imageName: "searchDevice_navigationbar",
                hightlightedImageName: "searchDevice_navigationbar",
                addTarget: self,
                action: #selector(searchDevices),
                isLeft: false
        )
        
        navigationItem.rightBarButtonItems =
            [addItem, searchItem] as? [UIBarButtonItem]
        
        listView.register(
            UINib(nibName: zoneControlCellReuseIdentifier,
                  bundle: nil),
            forCellWithReuseIdentifier:
            zoneControlCellReuseIdentifier
        )
        
        deviceListView.register(
            UINib(nibName: deviceCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
            deviceCellReuseIdentifier
        )
        
        deviceListView.rowHeight = SHDeviceViewCell.rowHeight
        
        // 添加手势
        let longPress =
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(settingZones(longPressGestureRecognizer:))
        )
        
        longPress.minimumPressDuration = 1.0
        
        listView.addGestureRecognizer(longPress)
        
        sureButton.setTitle(SHLanguageText.ok, for: .normal)
        sureButton.tintColor = UIView.textWhiteColor()
        sureButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            sureButton.titleLabel?.font = UIView.suitFontForPad()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//       let title =
//            (SHLanguageTools.share()?.getTextFromPlist(
//                "MAIN_PAGE",
//                withSubTitle: "MAIN_LABEL"
//            ) as! [String]).first ?? ""
        
        navigationItem.title = "Zones"
        
        if let rightItems = self.navigationItem.rightBarButtonItems {
        
            let itemSize =
                UIDevice.is_iPad() ?
                    (navigationBarHeight + statusBarHeight) :
                    tabBarHeight
        
            for i in 0 ..< rightItems.count {
            
                let itemView = rightItems[i].customView
                itemView?.bounds =
                    CGRect(x: 0,
                           y: 0,
                           width: itemSize,
                           height: itemSize
                )
            }
        }
        
        guard let area = region else {
            
            return
        }
        
        allZones = SHSQLiteManager.shared.getZones(regionID: area.regionID)
        
        if allZones.isEmpty {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
            
            return
        }
        
        listView.reloadData()
    }
    
    /// 布局
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPhoneX_More() {
            
            listViewBottomConstraint.constant =
                tabBarHeight_iPhoneX_more
        }
        
        let itemMarignX: CGFloat = 1
        
        var totalCols = isPortrait ? 4 : 6
        
        if UIDevice.is_iPhone() {
        
            sureButtonHeghtConstraint.constant = tabBarHeight
            
            totalCols -= 1
        }
        
        let itemWidth: CGFloat = (listView.frame_width - (CGFloat(totalCols) * itemMarignX)) / CGFloat(totalCols)
        
        let countForVerticalDirection = Int(listView.frame_height / itemWidth)
        
        let itemMarignY = (listView.frame_height - (CGFloat(countForVerticalDirection) * itemWidth)) / CGFloat(countForVerticalDirection)
        
        let flowLayout = listView.collectionViewLayout as! UICollectionViewFlowLayout

        flowLayout.itemSize =
            CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = itemMarignY
        flowLayout.minimumInteritemSpacing = itemMarignX
    }
}
