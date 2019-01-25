//
//  SHZoneDmxGroupSettingViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2017/10/29.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// 分组cell标示
private let dmxGroupCellReuseIdentifier = "SHZoneDeviceGroupSettingCell"

@objcMembers class SHZoneDmxGroupSettingViewController: SHViewController {

    /// 区域
    var currentZone: SHZone?
    
    /// 所有的分组
    private lazy var dmxGroups: [SHDmxGroup] =
        [SHDmxGroup]()
    
    /// 组列表
    @IBOutlet weak var dmxGroupListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Dmx Group"
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "addDevice_navigationbar",
                hightlightedImageName: "addDevice_navigationbar",
                addTarget: self,
                action: #selector(addNewDmxGroup),
                isLeft: false
        )
        
        dmxGroupListView.rowHeight = SHZoneDeviceGroupSettingCell.rowHeight
        
        dmxGroupListView.register(
            UINib(nibName: dmxGroupCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier: dmxGroupCellReuseIdentifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let zoneID = currentZone?.zoneID  else {
            return
        }
        
        dmxGroups =
            SHSQLiteManager.shared.getDmxGroup(zoneID)
        
        if dmxGroups.isEmpty {
             
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
            
            return
        }
        
        dmxGroupListView.reloadData()
    }
    
    /// 添加新的分组
    @objc private func addNewDmxGroup() {
        
        let dmxGroup = SHDmxGroup()
        dmxGroup.zoneID = currentZone?.zoneID ?? 1
        dmxGroup.groupID =
            SHSQLiteManager.shared.getMaxDmxGroupID(
                currentZone?.zoneID ?? 0) + 1
        
       _ = SHSQLiteManager.shared.insertDmxGroup(dmxGroup)
        
        let detailViewController = SHDeviceArgsViewController()
        
        detailViewController.dmxGroup = dmxGroup
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}



// MARK: - UITableViewDelegate
extension SHZoneDmxGroupSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let editChannelController = SHDmxChannelSettingViewController()
        
        editChannelController.dmxGroup = dmxGroups[indexPath.row]
        
        navigationController?.pushViewController(
            editChannelController,
            animated: true
        )
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "\t\(SHLanguageText.delete)\t") { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let dmxGroup = self.dmxGroups[indexPath.row]
            
            self.dmxGroups.remove(at: indexPath.row)
            
            _ = SHSQLiteManager.shared.deleteDmxGroup(
                dmxGroup
            )
            
            tableView.reloadData()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "\t\(SHLanguageText.edit)\t") { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let editChannelController =
                SHDmxChannelSettingViewController()
            
            editChannelController.dmxGroup =
                self.dmxGroups[indexPath.row]
            
            self.navigationController?.pushViewController(
                editChannelController,
                animated: true
            )
        }
        
        return [deleteAction, editAction]
    }
}

// MARK: - UITableViewDataSource
extension SHZoneDmxGroupSettingViewController:
UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dmxGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: dmxGroupCellReuseIdentifier,
            for: indexPath
        ) as! SHZoneDeviceGroupSettingCell
        
        cell.dmxGroup = dmxGroups[indexPath.row]
        
        return cell
    }
}
