//
//  SHScheduleShadeViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/2/19.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// light重用标示
private let schduleShadeCellReuseIdentifier =
    "SHSchduleShadeCell"

class SHScheduleShadeViewController: SHViewController {

    /// 计划
    var schedule: SHSchedule?
    
    /// 包含shade的所有区域
    private lazy var shadeZones =
        SHSQLiteManager.shared.getZones(
            deviceType: SHSystemDeviceType.shade.rawValue
    )
    
    /// 窗帘列表
    @IBOutlet weak var shadeListView: UITableView!
    
}


// MARK: - UI初始化
extension SHScheduleShadeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航
        navigationItem.title = "Shade"
        
        //        navigationItem.rightBarButtonItem =
        //            UIBarButtonItem(
        //                imageName: "back",
        //                hightlightedImageName: "back",
        //                addTarget: self,
        //                action: #selector(saveMoodsClick),
        //                isLeft: false
        //        )
        
        // 注册cell
        shadeListView.register(
            UINib(
                nibName: schduleShadeCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleShadeCellReuseIdentifier
        )
        
        shadeListView.rowHeight = SHSchduleShadeCell.rowHeight
    }
}


// MARK: - SHEditRecordShadeStatusDelegate
extension SHScheduleShadeViewController: SHEditRecordShadeStatusDelegate {
    
    /// 窗帘的代理
    func edit(shade: SHShade, status: String) {
        
        /// 遍历所有的区域
        for zone in shadeZones {
            
            let sectionShades =
                SHSQLiteManager.shared.getShades(zone.zoneID)
            
            for curtain in sectionShades {
                
                if (curtain.shadeID == shade.shadeID) &&
                    (curtain.subnetID == shade.subnetID) &&
                    (curtain.deviceID == shade.deviceID)  {
                    
                    if status == SHLanguageText.shadeOpen {
                        
                        shade.currentStatus = .open
                        
                    } else if status == SHLanguageText.shadeClose {
                        
                        shade.currentStatus = .close
                        
                    } else {
                        
                        shade.currentStatus = .unKnow
                    }
                }
            }
        }
    }
}


// MARK: - UITableViewDelegate
extension SHScheduleShadeViewController: UITableViewDelegate {
    
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
        
        return shadeZones[section].zoneName ?? "zone"
    }
}

// MARK: - UITableViewDataSource
extension SHScheduleShadeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return shadeZones.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 获得每个区域
        let shadeZone = shadeZones[section]
        
        // 获得每组的shade
        let sectionShades =
            SHSQLiteManager.shared.getShades(shadeZone.zoneID)
        
        return sectionShades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleShadeCellReuseIdentifier,
                for: indexPath
                ) as! SHSchduleShadeCell
        
        // 获得每个区域
        let shadeZone = shadeZones[indexPath.section]
        
        // 获得每组的shade
        let sectionShades =
            SHSQLiteManager.shared.getShades(shadeZone.zoneID)
        
        cell.shade = sectionShades[indexPath.row]
        
        cell.delegate = self
        
        return cell
    }
}
