//
//  SHScheduleLightViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/2/19.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// light重用标示
private let schduleLightCellReuseIdentifier =
    "SHSchduleLightCell"

class SHScheduleLightViewController: SHViewController {

    /// 计划
    var schedule: SHSchedual?
    
    /// 包含light的所有区域
    private lazy var lightZones =
        SHSQLiteManager.shared.getZones(
            deviceType: SHSystemDeviceType.light.rawValue
    )
    
    /// 灯泡列表
    @IBOutlet weak var lightListView: UITableView!
    
}


// MARK: - UI初始化
extension SHScheduleLightViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航
        navigationItem.title = "Light"
        
//        navigationItem.rightBarButtonItem =
//            UIBarButtonItem(
//                imageName: "back",
//                hightlightedImageName: "back",
//                addTarget: self,
//                action: #selector(saveMoodsClick),
//                isLeft: false
//        )
        
        // 注册cell
        lightListView.register(
            UINib(
                nibName: schduleLightCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleLightCellReuseIdentifier
        )
        
        lightListView.rowHeight = SHSchduleLightCell.rowHeight
    }
}


// MARK: - UITableViewDelegate
extension SHScheduleLightViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return defaultHeight
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let customView = UIView()
    //
    //        customView.backgroundColor = UIColor.red
    //
    //        return customView
    //    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return lightZones[section].zoneName ?? "zone"
    }
}

// MARK: - UITableViewDataSource
extension SHScheduleLightViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lightZones.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 获得每个区域
        let lightZone = lightZones[section]
        
        // 获得每组的Light
        let sectionLights =
            SHSQLiteManager.shared.getLights(lightZone.zoneID)
        
        return sectionLights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleLightCellReuseIdentifier,
                for: indexPath
                ) as! SHSchduleLightCell
        
        // 获得每个区域
        let lightZone = lightZones[indexPath.section]
        
        // 获得每组的Light
        let sectionLights =
            SHSQLiteManager.shared.getLights(lightZone.zoneID)
        
        cell.light = sectionLights[indexPath.row]
        
        return cell
    }
}
