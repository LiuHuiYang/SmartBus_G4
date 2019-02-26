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
    
    /// 所有的audio
    private lazy var scheduleAudios = [[SHAudio]]()
    
    /// 音乐列表
    @IBOutlet weak var audioListView: UITableView!
}


// MARK: - 更新命令
extension SHScheduleAudioViewController {
    
    /// 保存配置数据
    @objc private func updateScheduleaAudioCommands() {
        
        guard let plan = schedule else {
            return
        }
        
        plan.deleteShceduleCommands(.audio)
        
        for sectionAudios in scheduleAudios {
            
            for audio in sectionAudios where audio.schedualEnable {
                
                let command = SHSchedualCommand()
                
                command.scheduleID = plan.scheduleID
                command.typeID = .audio
                
                command.parameter1 = UInt(audio.subnetID)
                command.parameter2 = UInt(audio.deviceID)
                
                // 音量
                command.parameter3 =
                    UInt(audio.schedualVolumeRatio)
                
                // ((状态 & 0xFF) << 8 ) | (来源 & 0xFF)
                command.parameter4 =   UInt(((audio.schedualPlayStatus & 0xFF) << 8) |
                    (audio.schedualSourceType.rawValue & 0xFF))
                
                // 专辑号
                command.parameter5 =
                    UInt(audio.schedualAlbum?.albumNumber ?? 1)
                
                // 歌曲号
                command.parameter6 = audio.schedualAlbum?.currentSelectSong?.songNumber ?? 1
                
                plan.commands.append(command)
            }
        }
        
        _ = navigationController?.popViewController(
            animated: true
        )
    }
}

// MARK: - UI初始化
extension SHScheduleAudioViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let plan = schedule else {
            return
        }
        
        // 命令处理
        
        for command in plan.commands where command.typeID == .audio {
            
            for sectionAudios in scheduleAudios {
                
                for audio in sectionAudios {
                    
                    if audio.subnetID == command.parameter1 &&
                       audio.deviceID == command.parameter2 {
                        
                        if !audio.isUpdateSchedualCommand {
                            
                            continue
                        }
                        
                        // 只要是存在的命令就一定是选中的
                        audio.schedualEnable = true
                        
                        audio.schedualVolumeRatio = UInt8(command.parameter3)
                        
                        audio.schedualSourceType = SHAudioSourceType(rawValue: (UInt8(command.parameter4 & 0xFF))) ?? .SDCARD
                        
                        audio.schedualPlayStatus = UInt8((command.parameter4 >> 8) & 0xFF)
                        
                        audio.schedualPlayAlbumNumber = UInt8(command.parameter5)
                        
                        audio.schedualPlaySongNumber = command.parameter6
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载 所有的数据
        for zone in audioZones {
            
            let audios =
                SHSQLiteManager.shared.getAudios(
                    zone.zoneID
            )
            
            scheduleAudios.append(audios)
        }
        
        navigationItem.title = "Audio"

        navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                imageName: "navigationbarback",
                hightlightedImageName: "navigationbarback",
                addTarget: self,
                action: #selector(updateScheduleaAudioCommands),
                isLeft: true
        )
        
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
        
        let audioController =
            SHScheduleAudioViewDetailController()
        
        audioController.schedualAudio =
            scheduleAudios[indexPath.section][indexPath.row]
        
        navigationController?.pushViewController(
            audioController,
            animated: true
        )
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let sectionAudios = scheduleAudios[section]
        
        return sectionAudios.isEmpty ? 0 :
            SHScheduleSectionHeader.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = SHScheduleSectionHeader.loadFromNib()
        
        headerView.sectionZone = audioZones[section]
        
        return headerView
    }
}


// MARK: - UITableViewDataSource
extension SHScheduleAudioViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return audioZones.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return scheduleAudios[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleAudioCellReuseIdentifier,
                for: indexPath
                ) as! SHSchedualAudioCell
     
        cell.schedualAudio =
            scheduleAudios[indexPath.section][indexPath.row]
        
        return cell
    }
}
