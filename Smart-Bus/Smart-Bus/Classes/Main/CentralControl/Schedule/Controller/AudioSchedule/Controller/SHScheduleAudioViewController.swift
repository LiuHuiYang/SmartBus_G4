//
//  SHScheduleAudioViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/2/19.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// audio的重用标示
private let schduleAudioCellReuseIdentifier =
    "SHSchedualAudioCell"

class SHScheduleAudioViewController: SHViewController {

    /// 计划
    var schedule: SHSchedule?
    
    /// 包含audio的所有区域
    private lazy var audioZones =
        SHSQLiteManager.shared.getZones(
            deviceType: SHSystemDeviceType.audio.rawValue
    )
    
    /// 音乐列表
    @IBOutlet weak var audioListView: UITableView!
}


// MARK: - UI初始化
extension SHScheduleAudioViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Audio"
        
        //        navigationItem.rightBarButtonItem =
        //            UIBarButtonItem(
        //                imageName: "back",
        //                hightlightedImageName: "back",
        //                addTarget: self,
        //                action: #selector(saveMoodsClick),
        //                isLeft: false
        //        )
        
        // 注册 cell
        audioListView.register(
            UINib(
                nibName: schduleAudioCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleAudioCellReuseIdentifier
        )
        
        audioListView.rowHeight = SHSchedualAudioCell.rowHeight
    }
}


// MARK: - UITableViewDelegate
extension SHScheduleAudioViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // 获得每个区域
        let audioZone = audioZones[indexPath.section]
        
        // 获得每组的audio
        let sectionAudios =
            SHSQLiteManager.shared.getAudios(audioZone.zoneID)
        
        // 获得具体的hvac
        let audio = sectionAudios[indexPath.row]
        
        let audioController =
            SHScheduleAudioViewDetailController()
        
        audioController.schedualAudio = audio
        
        navigationController?.pushViewController(
            audioController,
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
        
        return audioZones[section].zoneName ?? "zone"
    }
}


// MARK: - UITableViewDataSource
extension SHScheduleAudioViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return audioZones.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 获得每个区域
        let audioZone = audioZones[section]
        
        // 获得每组的audio
        let sectionAudios =
            SHSQLiteManager.shared.getAudios(audioZone.zoneID)
        
        return sectionAudios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleAudioCellReuseIdentifier,
                for: indexPath
                ) as! SHSchedualAudioCell
        
        
        // 获得每个区域
        let audioZone = audioZones[indexPath.section]
        
        // 获得每组的audio
        let sectionAudios =
            SHSQLiteManager.shared.getAudios(audioZone.zoneID)
        
        cell.schedualAudio = sectionAudios[indexPath.row]
        
        return cell
    }
}
