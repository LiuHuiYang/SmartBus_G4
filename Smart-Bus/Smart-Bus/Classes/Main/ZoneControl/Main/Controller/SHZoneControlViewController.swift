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

/// regionCell重用标示
private let regionCellReuseIdentifier = "SHRegionViewCell"

class SHZoneControlViewController: SHViewController {
    
   
    /// 地区
    var region: SHRegion?
    
    /// 所有的分组
    private lazy var groups = [SHRegion]()
    
    /// 当前分组的所有区域
    private lazy var zones = [SHZone]()
    
    /// 所有在线设备
    private lazy var devices = [SHDevice]()
    
    /// 导航栏上中间视图
    private lazy var titleView: UIButton = {
        
        let button = UIButton()
        
        button.titleLabel?.font = navigationBarFont
        button.titleLabel?.textColor = UIView.textWhiteColor()
        button.addTarget(self,
                         action: #selector(sectionButtonClick),
                         for: .touchUpInside
        )
        
        return button
    }()
    
    /// 区域列表
    @IBOutlet weak var listView: UICollectionView!
    
    /// listView的底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!
    
    /// 搜索设备的高度约束
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    
    /// 按钮的高度约束
    @IBOutlet weak var sureButtonHeghtConstraint: NSLayoutConstraint!
    
    /// 确定按钮
    @IBOutlet weak var sureButton: UIButton!
    
    /// 搜索设备视图
    @IBOutlet weak var serchView: UIView!
    
    /// 搜索设备列表
    @IBOutlet weak var deviceListView: UITableView!
    
    /// 区域列表
    @IBOutlet weak var regionListView: UITableView!
    
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
        
        deviceListView.reloadData()
        
        SHSocketTools.sendData(
            operatorCode: 0x000E,
            subNetID: 0xFF,
            deviceID: 0xFF,
            additionalData: []
        )
         
        Thread.sleep(forTimeInterval: 1.0)
        
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
    
    
    /// 分组按钮点击
    @objc private func sectionButtonClick() {
        
        serchView.isHidden = true
        regionListView.isHidden = !regionListView.isHidden
    }
    
    /// 设置区域
    @objc private func addNewZones() {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            return
        }
        
        serchView.isHidden = true
        regionListView.isHidden = true
        
        let alertView =
            TYCustomAlertView(title: nil,
                              message: nil,
                              isCustom: true
        )
        
        let addSectionAction = TYAlertAction(title: "Add Section", style: .default) { (action) in
            
            let region = SHRegion()
            region.regionID =
                SHSQLiteManager.shared.getMaxRegionID()
                + 1
            region.regionName = "New Region"
            region.regionIconName = "regionIcon"
            
            _ = SHSQLiteManager.shared.insertRegion(region)
            
            let detailController =
                SHAreaSettingViewController()
            
            detailController.region = region
            
            self.navigationController?.pushViewController(
                detailController,
                animated: true
            )
        }
        
        alertView?.add(addSectionAction)
        
        let addZoneAction = TYAlertAction(title: "Add Zone", style: .default) { (action) in
            
            let zone = SHZone()
            zone.zoneID =
                SHSQLiteManager.shared.getMaxZoneID() + 1
            zone.zoneName = "New Zone"
            zone.zoneIconName = "Demokit"
            zone.regionID = self.region?.regionID ?? 1 // 默认是1
            
            _ = SHSQLiteManager.shared.insertZone(zone)
            
            let systemViewController = SHAreaSettingViewController()
            
            systemViewController.currentZone = zone
            
            self.navigationController?.pushViewController(
                systemViewController,
                animated: true
            )
        }
        
        alertView?.add(addZoneAction)
        
        let alertController =
            TYAlertController(alert: alertView,
                              preferredStyle: .alert,
                              transitionAnimation: .dropDown
        )
        
        alertController?.backgoundTapDismissEnable = true
        
        present(alertController!, animated: true, completion: nil)
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
                    
                    let zone = self.zones[index.item]
                    
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
                            
                            let zone = self.zones[index.item]
                            self.zones.remove(at: index.item)
                            
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
        
        let currentZone = zones[indexPath.item]
        
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
            SHAreaControlViewController()
        
        zoneController.setupViewController(currentZone)
        
        navigationController?.pushViewController(
            zoneController,
            animated: true
        )
    }
}

// MARK: - UICollectionViewDataSource
extension SHZoneControlViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return zones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: zoneControlCellReuseIdentifier,
                for: indexPath
                ) as! SHZoneControlViewCell
        
        cell.currentZone = zones[indexPath.item]
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension SHZoneControlViewController: UITableViewDelegate {
    
    /// 选择指定的区域
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == regionListView &&
            !groups.isEmpty {
            
            let area = groups[indexPath.row]
            
            region = area
            
            zones = SHSQLiteManager.shared.getZones(regionID: area.regionID)
            
            var title =
                (SHLanguageTools.share()?.getTextFromPlist(
                    "MAIN_PAGE",
                    withSubTitle: "MAIN_LABEL"
                ) as! [String]).first ?? ""
            
            let isSingleRegion = groups.count == 1
            
            title =
                isSingleRegion ?
                    title :
                    (area.regionName + " ▼ ")
            
            titleView.isUserInteractionEnabled = !isSingleRegion
            
            titleView.setTitle(title, for: .normal)
            
            listView.reloadData()
            
            tableView.isHidden = true
        }
    }
    
    // ======  编辑与删除地区 =====
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        guard tableView == regionListView else {
            
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard tableView == regionListView else {
            
            return nil
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "\t\(SHLanguageText.delete)\t") { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let region = self.groups[indexPath.row]
            self.groups.remove(at: indexPath.row)
            
            _ = SHSQLiteManager.shared.deleteRegion(region.regionID)
            
            self.regionListView.reloadData()
            
            if SHSQLiteManager.shared.getRegions().count == 1 {
                
                self.tableView(self.regionListView,
                               didSelectRowAt: IndexPath(row: 0, section: 0)
                )
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "\t\(SHLanguageText.edit)\t") { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let area = self.groups[indexPath.row]
            
            let detailController =
                SHAreaSettingViewController()
            
            detailController.region = area
            self.navigationController?.pushViewController(
                detailController,
                animated: true
            )
        }
        
        return [deleteAction, editAction]
    }
}

// MARK: - UITableViewDataSource
extension SHZoneControlViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == deviceListView {
            
            return devices.count
            
        } else if tableView == regionListView {
            
            return groups.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == deviceListView {
            
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: deviceCellReuseIdentifier,
                    for: indexPath
                    ) as! SHDeviceViewCell
            
            cell.device = devices[indexPath.row]
            
            return cell
        } else if tableView == regionListView {
            
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: regionCellReuseIdentifier,
                    for: indexPath
                ) as! SHRegionViewCell
            
            cell.region = groups[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - UI设置
extension SHZoneControlViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = titleView
        
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
        
        navigationItem.leftBarButtonItem = searchItem
        navigationItem.rightBarButtonItem = addItem
        
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
        
        regionListView.register(
            UINib(nibName: regionCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier: regionCellReuseIdentifier
        )
        
        regionListView.rowHeight =
            SHRegionViewCell.rowHeight
        
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
        
        groups = SHSQLiteManager.shared.getRegions()
        
        regionListView.reloadData()
        
        self.tableView(regionListView,
                       didSelectRowAt: IndexPath(row: 0,
                                                 section: 0)
        )
    }
    
    /// 布局
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPhone() {
            
            searchViewHeightConstraint.constant = 0
        }
        
        navigationItem.titleView?.bounds =
            CGRect(x: 0,
                   y: 0,
                   width: view.frame_width,
                   height: navigationBarHeight
        )
        
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
