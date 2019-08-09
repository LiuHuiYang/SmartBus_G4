//
//  SHReadSecurityLogViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/15.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// 安防日志重用标示
private let securityLogcellReuseIdentifier =
    "SHSecurityLogCell"

class SHReadSecurityLogViewController: SHViewController {
    
    /// 选择安防的区域
    var securityZone: SHSecurityZone?
    
    /// 安防日志集合
    var securityLogs = [SHSecurityLog]()
    
    /// 日期格式化字符串
    var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
    
    /// 选择的按钮
    var selectButton: UIButton?

    /// 清除按钮
    @IBOutlet weak var cleanButton: UIButton!
    
    /// 读取按钮
    @IBOutlet weak var readButton: UIButton!
    
    /// 开始日期按钮
    @IBOutlet weak var startDateButton: UIButton!
    
    /// 结束日期按钮
    @IBOutlet weak var endDateButton: UIButton!
    
    /// 控制按钮的高度
    @IBOutlet weak var controlButtonHeightConstraint: NSLayoutConstraint!
    
    /// 日期选择器的顶部约束
    @IBOutlet weak var datePickerTopConstraint: NSLayoutConstraint!
    
    /// 日期选择
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //// 日志历表
    @IBOutlet weak var logListView: UITableView!
 
}


// MARK: - 日志的处理
extension SHReadSecurityLogViewController {
    
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        guard let zone = securityZone else {
            return
        }
        
        if socketData.subNetID != zone.subnetID ||
            socketData.deviceID != zone.deviceID {
            
            return
        }
        
        switch socketData.operatorCode {
            
            // 获得历史记录的数量
        case 0x0139:
            
            readLogData(
                startIndexHigh: socketData.additionalData[0],
                startIndexLow: socketData.additionalData[1],
                indexHigh: socketData.additionalData[2],
                indexLow: socketData.additionalData[3]
            )
            
            // 获得查询的历史记录
        case 0x013B:
            if socketData.additionalData[0] != 0xF8 {
                return
            }
            
            let log = SHSecurityLog()
            
            log.logNumber =
                (UInt(socketData.additionalData[1]) << 8) +
                 UInt(socketData.additionalData[2])
            
            log.areaNumber = socketData.additionalData[3]
            
            log.securityTypeName =
                String(format: "%d-%02d-%02d/%02d:%02d:%02d",
                    socketData.additionalData[4],
                    socketData.additionalData[5],
                    socketData.additionalData[6],
                    socketData.additionalData[7],
                    socketData.additionalData[8],
                    socketData.additionalData[9]
            )
            
            log.subNetID = socketData.additionalData[10]
            log.deviceID = socketData.additionalData[11]
            log.securityType = socketData.additionalData[12]
            log.channelNumber = socketData.additionalData[13]
            
            let data =
                Data(bytes: &socketData.additionalData[14],
                     count: 20)
            
            log.remark = String(data: data, encoding: .utf8)
            
            // 只有是这个区域的才添加
            if log.areaNumber == zone.zoneID {
                
                securityLogs.append(log)
                
                DispatchQueue.main.sync {
                    self.logListView.reloadData()
                }
            }
            
        case 0x014B:
            
            if socketData.additionalData[0] == 0xF8 &&
                socketData.additionalData[1] == 0 {
                
                DispatchQueue.main.sync {
                    
                    securityLogs.removeAll()
                    
                    logListView.reloadData()
                    
                    SVProgressHUD.showSuccess(
                        withStatus: "Clear history success"
                    )
                }
                
            }
            
        default:
            break
        }
    }
    
    ///
    /// 读取最终的历史记录数据
    ///
    /// - Parameters:
    ///   - startIndexHigh: 历史记录开始位置高八位
    ///   - startIndexLow: 历史记录开始位置低八位
    ///   - indexHigh: 序号高八位
    ///   - indexLow: 序号低八位
    private func readLogData(
        startIndexHigh: UInt8,
        startIndexLow: UInt8,
        indexHigh: UInt8,
        indexLow: UInt8) {
        
        guard let zone = securityZone,
            
            let startDate =
            startDateButton.currentTitle?.components(
                separatedBy: "-"
            ),
            
            let endDate =
            endDateButton.currentTitle?.components(
                separatedBy: "-"
            ),
            
            !startDate.isEmpty,
            !endDate.isEmpty
            
            else {
                
                return
        }
        
        let startHour = UInt8(UInt(startDate[0]) ?? 0 % 100)
        let startMin = UInt8(startDate[1]) ?? 0
        let startSec = UInt8(startDate[2]) ?? 0
        
        let endHour = UInt8(UInt(endDate[0]) ?? 0 % 100)
        let endMin = UInt8(endDate[1]) ?? 0
        let endSec = UInt8(endDate[2]) ?? 0
        
        let logData =
            [startHour, startMin, startSec,
             endHour, endMin, endSec,
             startIndexHigh, startIndexLow,
             indexHigh, indexLow
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x013A,
            subNetID: zone.subnetID,
            deviceID: zone.deviceID,
            additionalData: logData
        )
        
    }
    
    /// 读取日志
    @IBAction func readLogButtonClick() {
        
        hideDatePicker()
        readLogTotals()
    }
    
    /// 读取历史记录总数
    private func readLogTotals() {
        
        guard let zone = securityZone,
            
        let startDate =
            startDateButton.currentTitle?.components(
                separatedBy: "-"
        ),
        
        let endDate =
            endDateButton.currentTitle?.components(
                separatedBy: "-"
        ),
        
        !startDate.isEmpty,
        !endDate.isEmpty
        
        else {
                
             return
        }
        
        let startHour = UInt8(UInt(startDate[0]) ?? 0 % 100)
        let startMin = UInt8(startDate[1]) ?? 0
        let startSec = UInt8(startDate[2]) ?? 0
        
        let endHour = UInt8(UInt(endDate[0]) ?? 0 % 100)
        let endMin = UInt8(endDate[1]) ?? 0
        let endSec = UInt8(endDate[2]) ?? 0
        
        SHSocketTools.sendData(
            operatorCode: 0x0138,
            subNetID: zone.subnetID,
            deviceID: zone.deviceID,
            additionalData:
                [startHour, startMin, startSec,
                 endHour, endMin, endSec]
        )
        
    }
    
    /// 清除日志
    @IBAction func cleanLogButtonClick() {
        
        guard let zone = securityZone else {
            return
        }
        
        hideDatePicker()
        
        SHSocketTools.sendData(
            operatorCode: 0x014A,
            subNetID: zone.subnetID,
            deviceID: zone.deviceID,
            additionalData: [0xF8, 1, 1, 1, 1, 1, 1])
    }
}


// MARK: - 日期的处理
extension SHReadSecurityLogViewController {
    
    /// 开始日期点击
    @IBAction func startDateButtonClick() {
        
        if selectButton != self.startDateButton {
            
            selectButton?.isSelected = false
        }
        
        startDateButton.isSelected =
            !startDateButton.isSelected
        
        
        if startDateButton.isSelected {
            
            showDatePicker()
            selectButton = startDateButton
            
        } else {
            
            hideDatePicker()
        }
    }
    
    /// 结束日期点击
    @IBAction func endDateButtonClick() {
        
        if selectButton != self.endDateButton {
            
            selectButton?.isSelected = false
        }
        
        endDateButton.isSelected =
            !endDateButton.isSelected
        
        
        if endDateButton.isSelected {
            
            showDatePicker()
            selectButton = endDateButton
            
        } else {
            
            hideDatePicker()
        }
    }
    
    /// 选择日期
    @IBAction func selectDate() {
        
        let title =
            (selectButton == startDateButton) ?
            "Start Date" : "End Date"
        
        let showDate =
            dateFormatter.string(from: datePicker.date)
        
        selectButton?.setTitle("\(title)\n \(showDate) ",
                               for: .normal)
    }
    
    /// 显示日期选择器
    private func showDatePicker() {
        
        let scale: CGFloat =
            UIDevice.is_iPad() ? 1.8 : 1.2
        
        if datePicker.transform == .identity {
            
            datePicker.transform =
                CGAffineTransform(scaleX: scale, y: scale)
        }
        
        logListView.isHidden = true
        
        if datePickerTopConstraint.constant == 0 {
            
            datePickerTopConstraint.constant -=
                datePicker.frame_height
            
            UIView.animate(withDuration: 0.3) {
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    /// 隐藏日期选择器
    private func hideDatePicker() {
        
        selectButton?.isSelected = false
        selectButton = nil
        logListView.isHidden = false
        
        if datePickerTopConstraint.constant != 0 {
            
            datePickerTopConstraint.constant = 0
            datePicker.transform = .identity
            
            UIView.animate(withDuration: 0.3) {
                
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SHReadSecurityLogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return securityLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: securityLogcellReuseIdentifier,
                for: indexPath
            ) as! SHSecurityLogCell
        
        cell.securityLog = securityLogs[indexPath.row]
        
        return cell
    }
}

// MARK: - UI初始化
extension SHReadSecurityLogViewController {
    
    /// 测试数据
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        for i in 0 ..< 6 {
//            
//            let log = SHSecurityLog()
//            
//            log.logNumber = UInt(100 + i + 1)
//            log.areaNumber = UInt8(i + 1)
//            log.securityTime = "2017-11-15 15:46:08"
//            log.subNetID = securityZone?.subnetID ?? 0
//            log.deviceID = securityZone?.deviceID ?? 0
//            log.securityType = UInt8(i)
//            log.channelNumber =
//                UInt8(securityZone?.zoneID ?? 0)
//            log.remark = "hello"
//            
//            securityLogs.append(log)
//        }
//        
//        logListView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Security Log"
        
        // 日期控件
        datePicker.date = Date()
        datePicker.setValue(UIView.textWhiteColor(),
                            forKey: "textColor"
        )
        
        // 操作按钮
        startDateButton.titleLabel?.numberOfLines = 0
        endDateButton.titleLabel?.numberOfLines = 0
        
        startDateButton.titleLabel?.textAlignment = .center
        endDateButton.titleLabel?.textAlignment = .center
        dateFormatter.string(from: datePicker.date)
        
        let defaultDate =
            "Start Date \n " +
            "\(dateFormatter.string(from: datePicker.date))"
       
        startDateButton.setTitle(defaultDate, for: .normal)
        endDateButton.setTitle(defaultDate, for: .normal)
        
        view.bringSubviewToFront(datePicker)
        
        // 日志列表初始化
        logListView.backgroundColor = .clear
        
        logListView.register(
            UINib(nibName: securityLogcellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
                securityLogcellReuseIdentifier
        )
        
        logListView.rowHeight = SHSecurityLogCell.rowHeight
        
        logListView.isHidden = true
        
        // 图形与字体适配
        startDateButton.setRoundedRectangleBorder()
        endDateButton.setRoundedRectangleBorder()
        readButton.setRoundedRectangleBorder()
        cleanButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            startDateButton.titleLabel?.font = font
            endDateButton.titleLabel?.font = font
            readButton.titleLabel?.font = font
            cleanButton.titleLabel?.font = font
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            controlButtonHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
    }
}
