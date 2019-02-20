//
//  SHScheduleFloorheatingViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/2/19.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// 重用标示
private let schduleFloorHeatingCellReuseIdentifier =
    "SHSchedualFloorHeatingCell"

class SHScheduleFloorheatingViewController: SHViewController {

    /// 计划
    var schedule: SHSchedual?
    
    /// 包含floorHeating的所有区域
    private lazy var floorHeatingZones =
        SHSQLiteManager.shared.getZones(
            deviceType:
                SHSystemDeviceType.floorHeating.rawValue
    )
    
    /// 地热列表
    @IBOutlet weak var floorheatingListView: UITableView!
    
}



// MARK: - UI初始化
extension SHScheduleFloorheatingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航
        navigationItem.title = "Floor heating"
        
        //        navigationItem.rightBarButtonItem =
        //            UIBarButtonItem(
        //                imageName: "back",
        //                hightlightedImageName: "back",
        //                addTarget: self,
        //                action: #selector(saveMoodsClick),
        //                isLeft: false
        //        )
        
        // 注册 cell
        floorheatingListView.register(
            UINib(
                nibName: schduleFloorHeatingCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleFloorHeatingCellReuseIdentifier
        )
        
        floorheatingListView.rowHeight =
            SHSchedualFloorHeatingCell.rowHeight
    }
}


// MARK: - UITableViewDelegate
extension SHScheduleFloorheatingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 获得每个区域
        let floorHeatingZone = floorHeatingZones[indexPath.section]
        
        // 获得每组的floorHeating
        let sectionFloorHeatings =
            SHSQLiteManager.shared.getFloorHeatings(
                floorHeatingZone.zoneID
        )
        
        
        // 获得具体的hvac
        let hvac = sectionFloorHeatings[indexPath.row]
        
        let floorHeating =
            SHSchedualFloorHeatingController()
        
        floorHeating.schedualFloorHeating = hvac
        
        navigationController?.pushViewController(
            floorHeating,
            animated: true
        )
    }
    
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
        
        return floorHeatingZones[section].zoneName ?? "zone"
    }
}


// MARK: - UITableViewDataSource
extension SHScheduleFloorheatingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return floorHeatingZones.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 获得每个区域
        let floorHeatingZone = floorHeatingZones[section]
        
        // 获得每组的floorHeating
        let sectionFloorHeatings =
            SHSQLiteManager.shared.getFloorHeatings(
                floorHeatingZone.zoneID
        )
        
        return sectionFloorHeatings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleFloorHeatingCellReuseIdentifier,
                for: indexPath
                ) as! SHSchedualFloorHeatingCell
        
        
        // 获得每个区域
        let floorHeatingZone =
            floorHeatingZones[indexPath.section]
        
        // 获得每组的floorHeating
        let sectionFloorHeatings =
            SHSQLiteManager.shared.getFloorHeatings(
                floorHeatingZone.zoneID
        )
        
        cell.schedualFloorHeating =
            sectionFloorHeatings[indexPath.row]
       
        return cell
    }
}
