//
//  SHZoneControlRecordMoodViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/8/11.
//  Copyright © 2017年 Mark Liu. All rights reserved
/*
 录制过程中会出现失败的情况
    1> 读取状态时间不够
    2> 数据丢包
 
 */

import UIKit

/// 窗帘重用标示
private let editRecordShadeCellReIdentifier =
    "SHEditRecordShadeCell"

class SHZoneControlRecordMoodViewController: SHViewController {
    
    /// 当前区域
    var currentZone: SHZone? {
        
        didSet {
            
            guard let zone = currentZone else {
                return
            }
            
            /// 所有系统ID
            systemIDs =
                SHSQLiteManager.shared.getSystemIDs(zone.zoneID)
        }
    }
    
    /// 当前的模式
    private var currentMood: SHMood = SHMood()
    
    /// 录制成功
    private var recordSuccess = false
    
    /// 当前区域的所有系统ID
    private var systemIDs = [UInt]()
    
    /// 当前出现的键盘的高度
    private var keyboradHeight: CGFloat = 0.0
    
    /// 显示图片
    private var moodIconsView: UIScrollView = {
        
        let listView = UIScrollView()
        listView.backgroundColor =
            UIColor(white: 0, alpha: 0.5)
        listView.showsVerticalScrollIndicator = false
        listView.showsHorizontalScrollIndicator = false
        listView.layer.cornerRadius =
            statusBarHeight * 0.5
        listView.clipsToBounds = true
        
        return listView
    }()
    
    /// 录制定时器
    private var timer: Timer?
    
    /// 重复次数
    private var count: Int = 0
    
    /// 当前区域中的所有灯光设备
    private var allLights = [SHLight]()
    
    /// 当前区域中的所有空调设备
    private var allHVACs = [SHHVAC]()
    
    /// 当前区域所有的窗帘
    private var allShades = [SHShade]()
    
    /// 所有的音乐设备
    private var allAudios = [SHAudio]()
    
    /// 所有的供暖设备
    private var allFloorHeatings = [SHFloorHeating]()
    
    /// mood图片名称
    private var moodImageNames = [
        "mood_romantic", "mood_bye",
        "mood_dining", "mood_meeting",
        "mood_night", "mood_party",
        "mood_study", "mood_tv"
    ]
    
    // MARK: - UI控件与约束
    
    /// 图片名称上的约束
    @IBOutlet weak var moodNameTextFieldHeightConstraint: NSLayoutConstraint!
    
    /// 竖直方向上的距离
    @IBOutlet weak var recordViewBottomHeightConstraint: NSLayoutConstraint!
    
    /// 区域标签
    @IBOutlet weak var zoneLabel: UILabel!
    
    /// 选择按钮的背景图片
    @IBOutlet weak var buttonsView: UIView!
    
    /// 灯光按钮
    @IBOutlet weak var lightButton: SHCommandButton!
    
    /// 空调按钮
    @IBOutlet weak var hvacButton: SHCommandButton!
    
    /// 音乐按钮
    @IBOutlet weak var audioButton: SHCommandButton!
    
    /// 灯光按钮
    @IBOutlet weak var shadeButton: SHCommandButton!
    
    /// 窗帘列表
    @IBOutlet weak var shadeListView: UITableView!
    
    /// 窗帘占位视图
    @IBOutlet weak var shadeHolderView: UIView!
    
    /// 关闭窗帘占位视图按钮
    @IBOutlet weak var closeShadeHolderViewButton: UIButton!
    
    /// 地热按钮
    @IBOutlet weak var floorHeatingButton: SHCommandButton!
    
    /// 录制控制的背景界面
    @IBOutlet weak var recordView: UIView!
    
    /// 录制按钮
    @IBOutlet weak var recordButton: SHCommandButton!
    
    /// 选择图片按钮
    @IBOutlet weak var selectImageButton: SHCommandButton!
    
    /// 场景名称
    @IBOutlet weak var moodNameTextField: UITextField!
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
}


// MARK: - 收到广播数据
extension SHZoneControlRecordMoodViewController {
    
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        switch socketData.operatorCode {
            
        case 0x0034:
            
            // LED
            if socketData.additionalData.count == (0 + 4 + 1) &&
                socketData.deviceType == 0x0382 {
                
                // 获得每个通道的值
                let red   = socketData.additionalData[1]
                let green = socketData.additionalData[2]
                let blue  = socketData.additionalData[3]
                let white = socketData.additionalData[4]
                
                for light in allLights {
                    
                    if light.subnetID == socketData.subNetID &&
                        light.deviceID == socketData.deviceID {
                        
                        // 这是将LED当成一个整体来控制的情况
                        light.redColorValue = red
                        light.greenColorValue = green
                        light.blueColorValue = blue
                        light.whiteColorValue = white
                        
                        light.ledHaveColor =
                            (red != 0)  || (green != 0)  ||
                            (blue != 0) || (white != 0)
                        
                        // 这是将LED中的每个颜色通道【独立】看成一个灯 (另一种方式)
                        
                        switch light.channelNo {
                            
                        case SHZoneControllightLEDChannel.red.rawValue:
                            light.brightness = red
                            
                        case SHZoneControllightLEDChannel.green.rawValue:
                            light.brightness = green
                            
                        case SHZoneControllightLEDChannel.blue.rawValue:
                            light.brightness = blue
                            
                        case SHZoneControllightLEDChannel.white.rawValue:
                            light.brightness = white
                            
                        default:
                            break
                        }
                        
                        light.recordSuccess = true
                    }
                }
                
                // 普通灯泡
            } else {
                
                let totalChannels = socketData.additionalData[0]
                
                for light in allLights {
                    
                    if light.subnetID == socketData.subNetID &&
                        light.deviceID == socketData.deviceID &&
                        light.channelNo <= totalChannels {
                        
                        light.brightness = socketData.additionalData[Int(light.channelNo)]
                        
                        if light.canDim == .notDimmable {
                            
                            light.brightness =
                                (light.brightness == lightMaxBrightness) ? lightMaxBrightness : 0
                        }
                        
                        light.recordSuccess = true
                    }
                }
            }
            
            // 处理录制完成的数据
            for light in allLights {
                
                lightButton.recordSuccess = light.recordSuccess
                
                if light.recordSuccess == false {
                    break
                }
            }
            
        // 获得温度单位
        case 0xE121:
            
            for hvac in allHVACs {
                
                if hvac.subnetID == socketData.subNetID && hvac.deviceID == socketData.deviceID {
                    
                    hvac.isCelsius =
                        socketData.additionalData[0] == 0
                }
            }
            
            
        case 0xE0ED:
            
            for hvac in allHVACs {
                
                if hvac.subnetID == socketData.subNetID && hvac.deviceID == socketData.deviceID {
                    
                    hvac.isTurnOn =
                        socketData.additionalData[0] != 0
                    
                    hvac.fanSpeed =
                        SHAirConditioningFanSpeedType(
                            rawValue: socketData.additionalData[2] & 0x0F
                        ) ?? .auto
                    
                    hvac.acMode = SHAirConditioningModeType(rawValue: (socketData.additionalData[2] & 0xF0) >> 4) ?? .cool
                    
                    hvac.indoorTemperature =
                        Int(socketData.additionalData[4])
                    
                    hvac.coolTemperture =
                        Int(socketData.additionalData[1])
                    
                    hvac.heatTemperture =
                        Int(socketData.additionalData[5])
                    
                    hvac.autoTemperture =
                        Int(socketData.additionalData[7])
                    
                    hvac.recordSuccess = true
                }
            }
            
            // 处理录制完成的数据
            for hvac in allHVACs {
                
                hvacButton.recordSuccess = hvac.recordSuccess
                
                if hvac.recordSuccess == false {
                    
                    break
                }
            }
            
        // 地热的开关模式
        case 0xE3DB:
            
            for floorHeating in allFloorHeatings {
                
                if socketData.subNetID != floorHeating.subnetID ||
                    
                    socketData.deviceID != floorHeating.deviceID ||
                    
                    socketData.additionalData[2] != floorHeating.channelNo {
                    
                    return
                }
                
                let operatorKind =
                    socketData.additionalData[0]
                
                let operatorResult =
                    socketData.additionalData[1]
                
                if operatorKind == SHFloorHeatingControlType.onAndOff.rawValue {
                    
                    floorHeating.isTurnOn =
                        operatorResult != 0
                    
                } else if operatorKind == SHFloorHeatingControlType.modelSet.rawValue {
                    
                    floorHeating.floorHeatingModeType =
                        SHFloorHeatingModeType(
                            rawValue: operatorResult
                        ) ?? .manual
                }
                
                floorHeating.recordSuccess = true
            }
            
            // ===== 处理录制完成的数据
            for floorHeating in allFloorHeatings {
                
                floorHeatingButton.recordSuccess =
                    floorHeating.recordSuccess
                
                if floorHeating.recordSuccess == false {
                    
                    break
                }
            }
            
        // 模式状态
        case 0x03C8:
            
            for floorHeating in allFloorHeatings {
                
                if socketData.subNetID != floorHeating.subnetID ||
                    
                    socketData.deviceID != floorHeating.deviceID ||
                    
                    socketData.additionalData[0] != floorHeating.channelNo {
                    
                    return
                }
                
                // 获得每个模式下的温度
                floorHeating.manualTemperature =
                    Int(socketData.additionalData[1])
                
                floorHeating.dayTemperature =
                    Int(socketData.additionalData[3])
                
                floorHeating.nightTemperature =
                    Int(socketData.additionalData[5])
                
                floorHeating.awayTemperature =
                    Int(socketData.additionalData[7])
                
                floorHeating.recordSuccess = true
               
            }
            
            // ===== 处理录制完成的数据
            for floorHeating in allFloorHeatings {
                
                floorHeatingButton.recordSuccess =
                    floorHeating.recordSuccess
                
                if floorHeating.recordSuccess == false {
                    
                    break
                }
            }
            
        // 音乐部分
        case 0x192F:
            
            for audio in allAudios {
                
                if audio.subnetID != socketData.subNetID ||
                    audio.deviceID != socketData.deviceID {
                    
                    return
                }
                
                let count = socketData.additionalData.count
                
                // 1.获得音量大小部分
                if (socketData.additionalData[0]  == 0x23 && // #
                    socketData.additionalData[1]  == 0x5A && // Z
                    //                socketData.additionalData[2]   && // z // 当前区号
                    socketData.additionalData[3]  == 0x2C && // ,
                    socketData.additionalData[4]  == 0x4F && // O
                    socketData.additionalData[5]  == 0x4E && // N
                    socketData.additionalData[6]  == 0x2C && // ,
                    socketData.additionalData[7]  == 0x53 && // S
                    socketData.additionalData[8]  == 0x52 && // R
                    socketData.additionalData[9]  == 0x43 && // C
                    //                socketData.additionalData[0 + 10]  && // 当前源号
                    socketData.additionalData[11] == 0x2C && // ,
                    socketData.additionalData[12] == 0x56 && // V
                    socketData.additionalData[13] == 0x4F && // O
                    socketData.additionalData[14] == 0x4C    // L
                    ) {
                    
                    if (socketData.additionalData[17] == 0xD) {
                        
                        audio.recoredVolume = 79 -
                            ((SHAudioOperatorTools.asciiToDecimal(
                                data: socketData.additionalData[15]
                            )) * 10 +
                                SHAudioOperatorTools.asciiToDecimal(
                                    data: socketData.additionalData[16]
                                )
                        
                        )
                        
                    } else {
                        
                        audio.recoredVolume =
                            79 -
                            
                            SHAudioOperatorTools.asciiToDecimal(
                                data: socketData.additionalData[15]
                        )
                    }
                }
                    
                    // 3.获得歌曲名称
                else if (socketData.additionalData[0]  == 0x23 && // #
                    socketData.additionalData[1]  == 0x53 && // S
                    
                    // socketData.additionalData[2] 音乐来源
                    
                    socketData.additionalData[3]  == 0x44 && // D
                    socketData.additionalData[4]  == 0x49 && // I
                    socketData.additionalData[5]  == 0x53 && // S
                    socketData.additionalData[6]  == 0x50 && // P
                    socketData.additionalData[7]  == 0x4C && // L
                    socketData.additionalData[8]  == 0x49 && // I
                    socketData.additionalData[9]  == 0x4E && // N
                    socketData.additionalData[10] == 0x45 && // E
                    
                    socketData.additionalData[12] == 0x2C &&  // ,
                    socketData.additionalData[13] == 0x02     // STX , ASC码
                    ) {
                    
                    
                    // 获得音乐来源
                    audio.recordSource =
                        SHAudioOperatorTools.asciiToDecimal(
                            data: socketData.additionalData[2]
                    )
                    
                    guard let string = String(
                        bytes: socketData.additionalData[14 ..< count - 3],
                        encoding: String.Encoding.unicode) as NSString?
                        else {
                        
                        return
                    }
                    
                        // 列表号与列表总数
                    switch socketData.additionalData[11] {
                        
                        // 获得专辑分类 辑字符串:List:1/8
                    case 0x31:
                        
                        let start =
                            string.range(of: ":")

                        let end =
                            string.range(of: "/")
                        
                        if start.location == NSNotFound ||
                            end.location == NSNotFound {
                            
                            break
                        }
                        
                        let range =
                            NSRange(
                                location: start.location + start.length,
                                
                                length:
                                    end.location -
                                    start.location -
                                    start.length
                        )
                        
                        let alubmNumberString =
                            string.substring(with: range)
                  
                        audio.recordAlubmNumber =  UInt8(alubmNumberString) ?? 1
                        
                        
                    // 获得歌曲号 歌曲字符串:Track:1/5
                    case 0x33:
                        
                        let start = string.range(of: ":")
                        let end = string.range(of: "/")
                        
                        if start.location == NSNotFound ||
                            end.location == NSNotFound {
                            
                            break
                        }
                        
                        let range =
                            NSRange(
                                location: start.location + start.length,
                                
                                length:
                                end.location -
                                    start.location -
                                    start.length
                        )
                        
                        let songNumberString =
                            string.substring(with: range)
                        
                        audio.recordSongNumber =
                            UInt8(songNumberString) ?? 1
                        
                       
                    default:
                        break
                        
                    }
                }
                
                // 4.获得当前的播放状态
                else if (socketData.additionalData[0]  == 0x23 &&  // #
                    socketData.additionalData[1]  == 0x53 &&  // S
                    
                    // socketData.additionalData[0 + 2]         // 音乐来源
                    
                    socketData.additionalData[3]  == 0x44 &&  // D
                    socketData.additionalData[4]  == 0x49 &&  // I
                    socketData.additionalData[5]  == 0x53 &&  // S
                    socketData.additionalData[6]  == 0x50 &&  // P
                    socketData.additionalData[7]  == 0x49 &&  // I
                    socketData.additionalData[8]  == 0x4E &&  // N
                    socketData.additionalData[9]  == 0x46 &&  // F
                    socketData.additionalData[10] == 0x4F &&  // O
                    socketData.additionalData[11] == 0x2C &&  // ,
                    socketData.additionalData[12] == 0x44 &&  // D
                    socketData.additionalData[13] == 0x55 &&  // U
                    socketData.additionalData[14] == 0x52     // R
                    ) {
                    
                    audio.recordPlayStatus = (socketData.additionalData[count - 2] == 0x32) ? SHAudioPlayControlType.play.rawValue: SHAudioPlayControlType.stop.rawValue
                }
                
                
                // 这些都不可能是0 才是录制成功
                if audio.recordPlayStatus != 0 &&
                    audio.recordAlubmNumber != 0 &&
                    audio.recordSongNumber != 0 &&
                    audio.recordSource != 0 {
                
                    audio.recordSuccess = true
                }
            }
            
            // ===== 处理录制完成的数据
            for audio in allAudios {
                
                audioButton.recordSuccess = audio.recordSuccess
                
                if audio.recordSuccess == false {
                    
                    break
                }
            }
            
        default:
            break
        }
    }
}


// MARK: - 其它点击事件
extension SHZoneControlRecordMoodViewController {
    
    /// 开始录制
    @IBAction func recordButtonClick() {
 
        // 隐藏窗帘
        shadeHolderView.isHidden = true

        // 处理名称
        if parseRecordName() == false {
            return
        }
        
        // 处理键盘
        if keyboradHeight != 0 {
            
            _ = self.textFieldShouldReturn(moodNameTextField)
        }
        
        moodIconsView.isHidden = true
        
        
        if !lightButton.isSelected &&
           !hvacButton.isSelected  &&
           !audioButton.isSelected &&
           !shadeButton.isSelected &&
           !floorHeatingButton.isSelected {
            
            let showTextTitle =
                SHLanguageTools.share()?.getTextFromPlist(
                    "MOOD_IN_ZONE",
                    withSubTitle: "PROMPT_MESSAGE_5"
                ) as! String
            
            let showTextMsg1 =
                SHLanguageTools.share()?.getTextFromPlist(
                    "MOOD_IN_ZONE",
                    withSubTitle: "PROMPT_MESSAGE_6"
                ) as! String
            
            let showTextMsg2 =
                SHLanguageTools.share()?.getTextFromPlist(
                    "MOOD_IN_ZONE",
                    withSubTitle: "PROMPT_MESSAGE_7"
                ) as! String
            
            
            let statusString = "\(showTextTitle)\n\r\(showTextMsg1)\n\r\(showTextMsg2)"
            
            SVProgressHUD.showError(
                withStatus: statusString
            )
            
            return
        }
        
        let showText =
            SHLanguageTools.share()?.getTextFromPlist(
                "MOOD_IN_ZONE",
                withSubTitle: "PROMPT_MESSAGE_8"
            ) as! String
        
        SVProgressHUD.show(withStatus: showText)
        
        // 开始录制
        readLightStatus()
        readHVACStatus()
        readAudioStatus()
        readShadeStatus()
        readFloorheatingStatus()
        
        // 开始计时
        let timer =
            Timer(timeInterval: 1.5,
                  target: self,
                  selector: #selector(finishedRecored),
                  userInfo: nil,
                  repeats: true
        )
        
        RunLoop.current.add(timer, forMode: .common)
        
        self.timer = timer
        
        count = 0
        
        timer.fire()
    }
    
    /// 选择图片
    @IBAction func selectImageButtonClick() {
    
        _ = self.textFieldShouldReturn(moodNameTextField)
        
        moodIconsView.isHidden = !moodIconsView.isHidden
    }

    /// 关闭占位视图按钮
    @IBAction func closeShadeHolderViewButtonClick() {
        
        shadeHolderView.isHidden = true
    }
    
}

// MARK: - 点击录制数据
extension SHZoneControlRecordMoodViewController {
    
    /// 选择灯光
    @IBAction func lightButtonClick() {
        
        lightButton.isSelected = !lightButton.isSelected
        
        allLights =
            lightButton.isSelected ?
            SHSQLiteManager.shared.getLights(
                currentMood.zoneID) : []
    }
    
    /// 选择空调
    @IBAction func hvacButtonClick() {
        
        hvacButton.isSelected = !hvacButton.isSelected
        
        allHVACs =
            hvacButton.isSelected ?
                SHSQLiteManager.shared.getHVACs(
                    currentMood.zoneID) : []
    }
    
    /// 选择音乐
    @IBAction func audioButtonClick() {
        
        audioButton.isSelected = !audioButton.isSelected
        
        allAudios =
            audioButton.isSelected ?
                SHSQLiteManager.shared.getAudios(
                    currentMood.zoneID) : []
    }
    
    /// 选择窗帘
    @IBAction func shadeButtonClick() {
        
        shadeButton.isSelected = !shadeButton.isSelected
        shadeHolderView.isHidden = !shadeHolderView.isHidden
        
        if shadeButton.isSelected {
            
            allShades =
                shadeButton.isSelected ?
                    SHSQLiteManager.shared.getShades(
                        currentMood.zoneID) : []
            
            
            shadeListView.reloadData()
        }
    }
    
    /// 选择地热
    @IBAction func floorheatingButtonClick() {
        
        floorHeatingButton.isSelected =
            !floorHeatingButton.isSelected
        
        allFloorHeatings =
            audioButton.isSelected ?
                SHSQLiteManager.shared.getFloorHeatings(
                    currentMood.zoneID) : []
    }
}

// MARK: - 保存场景数据
extension SHZoneControlRecordMoodViewController {
    
    
    /// 完成录制
    @objc private func finishedRecored() {
        
        count += 1
        
        let recoredLight =
            lightButton.isSelected ?
                lightButton.recordSuccess : true
        
        let recoredHVAC =
            hvacButton.isSelected ?
                hvacButton.recordSuccess : true
        
        let recoredAudio =
            audioButton.isSelected ?
                audioButton.recordSuccess : true
        
        let recoredFloorHeating =
            floorHeatingButton.isSelected ?
                floorHeatingButton.recordSuccess : true
        
        // 窗帘是直接编辑的, 所以不读取状态
        shadeButton.recordSuccess = true
        let recoredShade =
            shadeButton.isSelected ?
                shadeButton.recordSuccess : true
        
        // 由于音乐数据比较多, 容易失败, 所以启动多次重发
        if recoredAudio == false {
            
            readAudioStatus()
        }
        
        let status =
            recoredLight && recoredHVAC &&
            recoredAudio && recoredShade &&
            recoredFloorHeating
        
        if status {
            
            timer?.invalidate()
            timer = nil
            count = 0
            
            // 保存数据
            _ = SHSQLiteManager.shared.insertMood(currentMood)
            
            saveLightMoods()
            saveHvacMoods()
            saveShadeMoods()
            saveAudioMoods()
            saveFloorHeatings()
            
            // 显示录制成功
            let statusSting =
                SHLanguageTools.share()?.getTextFromPlist(
                    "MOOD_IN_ZONE",
                    withSubTitle: "RECORD"
                ) as! String + SHLanguageText.done
            
            SVProgressHUD.showSuccess(withStatus: statusSting)
            
            navigationController?.popViewController(
                animated: true
            )
            
            return
        }
        
        // 音乐比较复杂，需要解析的内容比较多 * 3 多延时一下
        if count > (
            allLights.count + allHVACs.count +
            allShades.count + allFloorHeatings.count +
            allAudios.count * 3) {
            
//            print("失败结果: \(recoredHVAC) - \(recoredAudio) - \(recoredLight)")
            
            timer?.invalidate()
            timer = nil
            count = 0
            
            let errorTitle =
                SHLanguageTools.share()?.getTextFromPlist(
                    "MOOD_IN_ZONE",
                    withSubTitle: "PROMPT_MESSAGE_2"
            ) as! String
            
            let errorMsg1 =
                SHLanguageTools.share()?.getTextFromPlist(
                    "MOOD_IN_ZONE",
                    withSubTitle: "PROMPT_MESSAGE_3"
            ) as! String
            
            let errorMsg2 =
                SHLanguageTools.share()?.getTextFromPlist(
                    "MOOD_IN_ZONE",
                    withSubTitle: "PROMPT_MESSAGE_4"
            ) as! String
            
            let error =
                "\(errorTitle)\n\r\(errorMsg1)\n\r\(errorMsg2)"
            
            SVProgressHUD.showError(withStatus: error)
        }
        
    }
    
    /// 保存音乐数据
    private func saveAudioMoods() {
        
        for audio in allAudios {
            
            let moodCommand = SHMoodCommand()
            
            moodCommand.id =
                SHSQLiteManager.shared.getMaxIDForMoodCommand() + 1
            
            moodCommand.deviceName = audio.audioName
            
            moodCommand.zoneID = currentMood.zoneID
            moodCommand.moodID = currentMood.moodID
            
            moodCommand.deviceType = SHSystemDeviceType.audio.rawValue
            
            moodCommand.subnetID = audio.subnetID
            moodCommand.deviceID = audio.deviceID
            
            moodCommand.parameter1 = UInt(audio.recoredVolume)
            moodCommand.parameter2 = UInt(audio.recordSource)
            moodCommand.parameter3 = UInt(audio.recordAlubmNumber)
            moodCommand.parameter4 = UInt(audio.recordSongNumber)
            moodCommand.parameter5 = UInt(audio.recordPlayStatus)
            
            _ = SHSQLiteManager.shared.insertMoodCommand(
                moodCommand
            )
        }
    }
    
    /// 保存窗帘数据
    private func saveShadeMoods() {
        
        for shade in allShades {
            
            if shade.currentStatus == .close ||
                shade.currentStatus == .open {
                
                let moodCommand = SHMoodCommand()
                
                moodCommand.id =
                    SHSQLiteManager.shared.getMaxIDForMoodCommand() + 1
                
                moodCommand.deviceName = shade.shadeName
                moodCommand.zoneID = currentMood.zoneID
                moodCommand.moodID = currentMood.moodID
                moodCommand.deviceType = SHSystemDeviceType.shade.rawValue
                
                moodCommand.subnetID = shade.subnetID
                moodCommand.deviceID = shade.deviceID
                
                moodCommand.parameter1 = shade.currentStatus.rawValue
                moodCommand.parameter2 = UInt(shade.openChannel)
                moodCommand.parameter3 = UInt(shade.closeChannel)
                
                _ = SHSQLiteManager.shared.insertMoodCommand(
                    moodCommand
                )
            }
            
        }
    }
    
    /// 保存地热数据
    private func saveFloorHeatings() {
        
        for floorHeating in allFloorHeatings {
            
            let moodCommand = SHMoodCommand()
            
            moodCommand.id =
                SHSQLiteManager.shared.getMaxIDForMoodCommand() + 1
            
            moodCommand.zoneID = currentMood.zoneID
            moodCommand.moodID = currentMood.moodID
            moodCommand.deviceName = floorHeating.floorHeatingRemark
            
            moodCommand.deviceType = SHSystemDeviceType.floorHeating.rawValue
            
            moodCommand.subnetID = floorHeating.subnetID
            moodCommand.deviceID = floorHeating.deviceID
            
            moodCommand.parameter1 = UInt(floorHeating.channelNo)
            
            moodCommand.parameter2 = floorHeating.isTurnOn ? 1 : 0
            
            moodCommand.parameter3 = UInt(floorHeating.floorHeatingModeType.rawValue)
            
            moodCommand.parameter4 = UInt(floorHeating.manualTemperature)
            
            _ = SHSQLiteManager.shared.insertMoodCommand(
                moodCommand
            )
            
        }
    }
    
    /// 保存HVAC的场景
    private func saveHvacMoods() {
        
        for hvac in allHVACs {
            
            let moodCommand = SHMoodCommand()
            
            moodCommand.id =
                SHSQLiteManager.shared.getMaxIDForMoodCommand() + 1
            
            moodCommand.zoneID = currentMood.zoneID
            moodCommand.moodID = currentMood.moodID
            
            moodCommand.deviceType =
                SHSystemDeviceType.hvac.rawValue
            
            moodCommand.subnetID = hvac.subnetID
            moodCommand.deviceID = hvac.deviceID
            
            moodCommand.parameter1 = hvac.isTurnOn ? 1 : 0
            moodCommand.parameter2 = UInt(hvac.fanSpeed.rawValue)
            moodCommand.parameter3 = UInt(hvac.acMode.rawValue)
            
            
            if hvac.acMode == .heat {
                
                moodCommand.parameter4 = UInt(hvac.heatTemperture)
                
            } else if hvac.acMode == .auto {
                
                moodCommand.parameter4 = UInt(hvac.autoTemperture)
                
            } else {
                
                moodCommand.parameter4 = UInt(hvac.coolTemperture)
            }
            
            
            _ = SHSQLiteManager.shared.insertMoodCommand(
                moodCommand
            )
        }
    }
    
    /// 保存灯光的场景数据
    private func saveLightMoods() {
        
        for light in allLights {
            
            let moodCommand = SHMoodCommand()
            
            moodCommand.id =
                SHSQLiteManager.shared.getMaxIDForMoodCommand() + 1
            
            moodCommand.zoneID = currentMood.zoneID
            moodCommand.moodID = currentMood.moodID
            moodCommand.deviceName = light.lightRemark
            moodCommand.deviceType =
                SHSystemDeviceType.light.rawValue
            
            moodCommand.subnetID = light.subnetID
            moodCommand.deviceID = light.deviceID
            
            moodCommand.parameter1 = UInt(light.lightTypeID.rawValue)
            
            if light.lightTypeID == .led ||
                light.canDim == .led {
                
                moodCommand.parameter2 =
                    UInt(light.redColorValue)
                
                moodCommand.parameter3 =
                    UInt(light.greenColorValue)
                
                moodCommand.parameter4 =
                    UInt(light.blueColorValue)
                
                moodCommand.parameter5 =
                    UInt(light.whiteColorValue)
                
            } else {
                
                moodCommand.parameter2 = UInt(light.channelNo)
                moodCommand.parameter3 = UInt(light.brightness)
                
            }
            
            _ = SHSQLiteManager.shared.insertMoodCommand(
                moodCommand
            )
        }
        
    }
}

// MARK: - 读取相关设备的状态
extension SHZoneControlRecordMoodViewController {
    
    /// 读取地热状态
    private func readFloorheatingStatus() {
        
        for floorHeating in allFloorHeatings {
            
            // 读取模式匹配温度与传感器的地址
            SHSocketTools.sendData(
                operatorCode: 0x03C7,
                subNetID: floorHeating.subnetID,
                deviceID: floorHeating.deviceID,
                additionalData: [floorHeating.channelNo]
            )
            
            // 读取开关状态
            SHSocketTools.sendData(
                operatorCode: 0xE3DA,
                subNetID: floorHeating.subnetID,
                deviceID: floorHeating.deviceID,
                additionalData:
                [
                    SHFloorHeatingControlType.onAndOff.rawValue,
                    floorHeating.channelNo
                ]
            )
            
            // 读取模式状态
            SHSocketTools.sendData(
                operatorCode: 0xE3DA,
                subNetID: floorHeating.subnetID,
                deviceID: floorHeating.deviceID,
                additionalData:
                [
                    SHFloorHeatingControlType.modelSet.rawValue,
                    floorHeating.channelNo
                ]
            )
            
        }
        
        // 如果选择了类型, 但没有任何对应的设备则默认为真
        if allFloorHeatings.isEmpty {
            
            floorHeatingButton.recordSuccess = true
        }
    }
    
    /// 读取窗帘的状态，本身存在问题，只是为了保证当前设备在线
    private func readShadeStatus() {
        
        var subNetID: UInt8 = 0, deviceID: UInt8 = 0
        
        for shade in allShades {
            
            shade.recordSuccess = false
            
            if shade.subnetID == subNetID &&
                shade.deviceID == deviceID {
                continue
            }
            
            subNetID = shade.subnetID
            deviceID = shade.deviceID
            
            SHSocketTools.sendData(
                operatorCode: 0x0033,
                subNetID: subNetID,
                deviceID: deviceID,
                additionalData: [],
                needReSend:false
            )
        }
        
        // 如果选择了类型, 但没有任何对应的设备则默认为真
        if allShades.isEmpty {
            
            shadeButton.recordSuccess = true
        }
    }
    
    /// 读取音乐的状态
    private func readAudioStatus() {
        
        for audio in allAudios {
            
            audio.recordSuccess = false
            
            SHAudioOperatorTools.readAudioStatus(
                subNetID: audio.subnetID,
                deviceID: audio.deviceID
            )
        }
        
        // 如果选择了类型, 但没有任何对应的设备则默认为真
        if allAudios.isEmpty {
            
            audioButton.recordSuccess = true
        }
    }
    
    /// 读取HVAC的状态
    private func readHVACStatus() {
        
        for hvac in allHVACs {
            
            hvac.recordSuccess = false
            
            SHSocketTools.sendData(
                operatorCode: 0xE120,
                subNetID: hvac.subnetID,
                deviceID: hvac.deviceID,
                additionalData: [],
                needReSend: false
            )
            
            SHSocketTools.sendData(
                operatorCode: 0xE0EC,
                subNetID: hvac.subnetID,
                deviceID: hvac.deviceID,
                additionalData: [hvac.channelNo]
            )
        }
        
        // 如果选择了类型, 但没有任何对应的设备则默认为真
        if allHVACs.isEmpty {
            
            hvacButton.recordSuccess = true
        }
    }
    
    /// 录取灯泡的状态
    private func readLightStatus() {
        
        var subNetID: UInt8 = 0, deviceID: UInt8 = 0
        
        for light in allLights {
            
            light.recordSuccess = false
            
            if light.subnetID == subNetID &&
                light.deviceID == deviceID {
                continue
            }
            
            subNetID = light.subnetID
            deviceID = light.deviceID
            
            SHSocketTools.sendData(
                operatorCode: 0x0033,
                subNetID: subNetID,
                deviceID: deviceID,
                additionalData: []
            )
        }
        
        // 如果选择了类型, 但没有任何对应的设备则默认为真
        if allLights.isEmpty {
            
            lightButton.recordSuccess = true
        }
    }
}


// MARK: - 窗帘的代理
extension SHZoneControlRecordMoodViewController: SHEditRecordShadeStatusDelegate {
    
    func edit(_ shade: SHShade?, currentStatus status: String?) {
        
        if shade == nil {
            return
        }
        
        for curtain in allShades {
            
            if curtain.shadeID == shade!.shadeID &&
                curtain.subnetID == shade!.subnetID &&
                curtain.deviceID == shade!.deviceID {
                
                if status == SHLanguageText.shadeOpen {
                    
                    curtain.currentStatus = .open
                    
                } else if status == SHLanguageText.shadeClose {
                    
                    curtain.currentStatus = .close
                    
                } else {
                    
                    curtain.currentStatus = .unKnow
                }
            }
        }
    }
}


// MARK: - 代理
extension SHZoneControlRecordMoodViewController: UITextFieldDelegate {
    
    /// 键盘消息
    ///
    /// - Parameter notification: <#notification description#>
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if keyboradHeight != 0 {
            return
        }
        
        // 获得键盘的高度
       
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey]
        
        keyboradHeight =
            ((keyboardinfo as AnyObject).cgRectValue.size.height)
        
        if moodNameTextField.isFirstResponder == false {
            return
        }
        
        recordViewBottomHeightConstraint.constant +=
            keyboradHeight
        
        view.layoutIfNeeded()
    }
    
    /// 开始编辑
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        buttonsView.isHidden = true
        moodIconsView.isHidden = true
        shadeHolderView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == moodNameTextField {
            
            if keyboradHeight != 0 {
                
                recordViewBottomHeightConstraint.constant
                    -= keyboradHeight
                
                 view.layoutIfNeeded()
                
                keyboradHeight = 0
            }
            
            buttonsView.isHidden = false
            textField.endEditing(true)
        }
        
        return true
    }
}

// MARK: - 窗帘的数据源
extension SHZoneControlRecordMoodViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allShades.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: editRecordShadeCellReIdentifier,
                for: indexPath
                ) as! SHEditRecordShadeCell
        
        cell.delegate = self
        cell.shade = allShades[indexPath.row]
        
        return cell
    }
}

extension SHZoneControlRecordMoodViewController {
    
    /// 初始化名称
    private func parseRecordName() -> Bool {
    
        guard let name = moodNameTextField.text,
            !name.isEmpty,
            name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count != 0
            else {
            
            SVProgressHUD.showError(
                withStatus: "The name cannot be empty!"
            )
            
            return false
        }
        
        // 检查名字是否有相同的
        
        let moods =
            SHSQLiteManager.shared.getMoods(currentMood.zoneID)
        
        for mood in moods {
        
            if mood.moodName == name {
                
                SVProgressHUD.showError(
                    withStatus: "The name has been saved!"
                )
                
                return false
            }
        }
        
        currentMood.moodName = name
        
        return true
    }
}

// MARK: - UI初始化
extension SHZoneControlRecordMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let zone = currentZone else {
            return
        }
        
        // 初始化mood
        currentMood.zoneID = zone.zoneID
        currentMood.moodIconName = moodImageNames.first
        currentMood.moodID =
            SHSQLiteManager.shared.getMaxMoodID(zone.zoneID) + 1
        
        // 适配文字与图片
        suitText()
        
        // 显示录制类型
        showRecordDeviceKinds()
        
        // 显示场景图片
        showMoodIconsView()
        
        // 窗帘的显示列表
        shadeHolderView.isHidden = true
        shadeHolderView.setRoundedRectangleBorder()
        
        //        shadeHolderView.layer.cornerRadius = 15
        //        shadeHolderView.clipsToBounds = true
        
        shadeListView.rowHeight = SHEditRecordShadeCell.rowHeight
        shadeListView.register(
            UINib(nibName: editRecordShadeCellReIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
            editRecordShadeCellReIdentifier
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name:UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    /// 添加显示选择场景图片的view
    private func showMoodIconsView() {
        
        view.addSubview(moodIconsView)
        moodIconsView.isHidden = true
        
        let count = moodImageNames.count
        
        for i in 0 ..< count {
            
            let iconButton = UIButton()
            
            let iconName = moodImageNames[i]
            
            iconButton.setImage(
                UIImage(named: "\(iconName)_normal"),
                for: .normal
            )
            
            iconButton.setImage(
                UIImage(named: "\(iconName)_highlighted"),
                for: .highlighted
            )
            
            iconButton.tag = i
            moodIconsView.addSubview(iconButton)
            
            iconButton.addTarget(
                self,
                action: #selector(choiceMoodImage(_:)),
                for: .touchUpInside
            )
        }
    }
    
    
    /// 选择场景图片
    ///
    /// - Parameter button: 按钮
    @objc func choiceMoodImage(_ button: UIButton) {
        
        let iconName = moodImageNames[button.tag] + "_normal"
        
        selectImageButton.setImage(
            UIImage(named: iconName),
            for: .normal
        )
        
        currentMood.moodIconName = iconName
        
        moodIconsView.isHidden = !moodIconsView.isHidden
    }
    
    /// 录制的类型
    private func showRecordDeviceKinds() {
        
        lightButton.isHidden =
            !systemIDs.contains(SHSystemDeviceType.light.rawValue)
        
        hvacButton.isHidden =
            !systemIDs.contains(SHSystemDeviceType.hvac.rawValue)
        
        audioButton.isHidden =
            !systemIDs.contains(SHSystemDeviceType.audio.rawValue)
        
        shadeButton.isHidden =
            !systemIDs.contains(SHSystemDeviceType.shade.rawValue)
        
        floorHeatingButton.isHidden =
            !systemIDs.contains(
                SHSystemDeviceType.floorHeating.rawValue
        )
        
    }
    
    /// 适配文字与图片
    private func suitText() {
        
        // 显示区域内容
        zoneLabel.text = currentZone?.zoneName
        
        navigationItem.title = (SHLanguageTools.share()?.getTextFromPlist(
            "MOOD_IN_ZONE",
            withSubTitle: "RECORD_MOOD"
            ) as! String)
        
        lightButton.setTitle(
            (SHLanguageTools.share()?.getTextFromPlist(
                "MAIN_PAGE",
                withSubTitle: "alight"
                ) as! String),
            for: .normal
        )
        
        hvacButton.setTitle(
            (SHLanguageTools.share()?.getTextFromPlist(
                "MAIN_PAGE",
                withSubTitle: "bhvac"
                ) as! String),
            for: .normal
        )
        
        audioButton.setTitle(
            (SHLanguageTools.share()?.getTextFromPlist(
                "MAIN_PAGE",
                withSubTitle: "czaudio"
                ) as! String),
            for: .normal
        )
        
        shadeButton.setTitle(
            (SHLanguageTools.share()?.getTextFromPlist(
                "MAIN_PAGE",
                withSubTitle: "dshades"
                ) as! String),
            for: .normal
        )
        
        closeShadeHolderViewButton.setTitle(
            SHLanguageText.done,
            for: .normal
        )
        
        closeShadeHolderViewButton.setRoundedRectangleBorder()
        
        
        selectImageButton.setTitle(
            (SHLanguageTools.share()?.getTextFromPlist(
                "MOOD_IN_ZONE",
                withSubTitle: "SELECT_ICON"
                ) as! String),
            for: .normal
        )
        
        recordButton.setTitle(
            (SHLanguageTools.share()?.getTextFromPlist(
                "MOOD_IN_ZONE",
                withSubTitle: "RECORD"
                ) as! String),
            for: .normal
        )
        
        let holderString =
            NSMutableAttributedString(
                string:
                (SHLanguageTools.share()?.getTextFromPlist(
                    "MOOD_IN_ZONE",
                    withSubTitle: "MOOD_NAME"
                    ) as! String)
        )
        
        
        holderString.setAttributes(
            [
                NSAttributedString.Key.font: (UIDevice.is_iPad() ? UIView.suitFontForPad() as Any : UIFont.boldSystemFont(ofSize: 16)),
                
                
                NSAttributedString.Key.foregroundColor:
                    UIView.textWhiteColor() as Any
            ],
            
            range: NSRange(location: 0,
                           length: holderString.length
            )
        )
        
        moodNameTextField.attributedPlaceholder = holderString
        
        
        recordButton.setRoundedRectangleBorder()
        selectImageButton.setRoundedRectangleBorder()
        moodNameTextField.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            zoneLabel.font = font
            moodNameTextField.font = font
        }
    }
    
    
    /// 布局子控件
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        moodIconsView.frame_centerX = buttonsView.frame_centerX
        moodIconsView.frame_y = buttonsView.frame_y
        
        moodIconsView.frame_width =
            CGFloat.minimum(
                view.frame_width,
                view.frame_height
            ) * 0.75
        
        moodIconsView.frame_height =
            moodIconsView.frame_width * 0.75
        
        
        // 总共有的列数
        let totalCols = 3
        let count = moodImageNames.count
        let totalRows =
             (count / totalCols) +
             ((count % totalCols != 0) ? 1 : 0)
       
        let marign = moodIconsView.frame_width * 0.1
        let buttonSize =
            (moodIconsView.frame_width -
                CGFloat(totalCols + 1) * marign
        ) / CGFloat(totalCols)
        
        for i in 0 ..< count {
            
            let iconButton = moodIconsView.subviews[i]
            
            // 计算行号与列号
            let row = i / totalCols
            let col = i % totalCols
            
            // 设置位置
            iconButton.frame =
                CGRect(
                    x: marign + (buttonSize + marign) * CGFloat(col),
                    y: CGFloat(row) * (buttonSize + marign) + marign,
                    width: buttonSize,
                    height: buttonSize
            )
        }
        
        // 设置滚动范围
        moodIconsView.contentSize =
            CGSize(width: 0,
                   height: CGFloat(totalRows) * (buttonSize + marign)
        )
        
        if UIDevice.is_iPad() {
            
            moodNameTextFieldHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
    }
}
