//
//  SHScheduleHVACViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/2/19.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// hvac重用标示
private let schduleHVACCellReuseIdentifier =
    "SHSchedualHVACCell"

class SHScheduleHVACViewController: SHViewController {

    /// 计划
    var schedule: SHSchedual?
    
    /// 包含HVAC的所有区域
    private lazy var hvacZones =
        SHSQLiteManager.shared.getZones(
            deviceType: SHSystemDeviceType.hvac.rawValue
    )
    
    /// 空调列表
    @IBOutlet weak var hvacListView: UITableView!

}


// MARK: - UI初始化
extension SHScheduleHVACViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航
        navigationItem.title = "HVAC"
        
        //        navigationItem.rightBarButtonItem =
        //            UIBarButtonItem(
        //                imageName: "back",
        //                hightlightedImageName: "back",
        //                addTarget: self,
        //                action: #selector(saveMoodsClick),
        //                isLeft: false
        //        )
        
        // 注册cell
        hvacListView.register(
            UINib(
                nibName: schduleHVACCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleHVACCellReuseIdentifier
        )
        
        hvacListView.rowHeight = SHSchedualHVACCell.rowHeight
    }
}



// MARK: - UITableViewDelegate
extension SHScheduleHVACViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 获得每个区域
        let hvacZone = hvacZones[indexPath.section]
        
        // 获得每组的hvac
        let sectionHVACs =
            SHSQLiteManager.shared.getHVACs(hvacZone.zoneID)
        
        // 获得具体的hvac
        let hvac = sectionHVACs[indexPath.row]
        
        let hvacController =
            SHSchedualHVACViewController()
        
        hvacController.schedualHVAC = hvac
        
        navigationController?.pushViewController(
            hvacController,
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
        
        return hvacZones[section].zoneName ?? "zone"
    }
}

// MARK: - UITableViewDataSource
extension SHScheduleHVACViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hvacZones.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 获得每个区域
        let hvacZone = hvacZones[section]
        
        // 获得每组的hvac
        let sectionHVACs =
            SHSQLiteManager.shared.getHVACs(hvacZone.zoneID)
        
        return sectionHVACs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleHVACCellReuseIdentifier,
                for: indexPath
                ) as! SHSchedualHVACCell
        
        // 获得每个区域
        let hvacZone = hvacZones[indexPath.section]
        
        // 获得每组的hvac
        let sectionHVACs =
            SHSQLiteManager.shared.getHVACs(hvacZone.zoneID)
        
        cell.schedualHVAC = sectionHVACs[indexPath.row]
        
        return cell
    }
}
