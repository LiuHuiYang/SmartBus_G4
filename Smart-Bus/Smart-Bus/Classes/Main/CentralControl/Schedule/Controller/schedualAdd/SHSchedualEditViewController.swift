//
//  SHSchedualEditViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/20.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// 控制区域重用标示符
private let schdualContolItemAndZoneCellReusableIdentifier = "SHSchdualContolItemAndZoneCell"

class SHSchedualEditViewController: SHViewController {

    /// 是否为增加的计算
    var isAddSedual = false
    
    /// 编辑的计划
    var schedual: SHSchedual?
    
    /// 所有的区域
    private lazy var allZones = [SHZone]()
    
    /// 不同的控制类型
    private lazy var controlItems: [String] = [
        "Macro buttons",
        "Moods",
        "Lights",
        "HVAC",
        "Music",
        "Shades",
        "Floor heating"
    ]
    
    // MARK: - 不同的计划部分
    
    /// 宏命令展示
    var macroView: SHSchduleMacroView =
        SHSchduleMacroView.loadFromNib()
    
    /// mood展示
    var moodView: SHSchduleMoodView =
        SHSchduleMoodView.loadFromNib()
    
    /// light展示
    var lightView: SHSchduleLightView =
        SHSchduleLightView.loadFromNib()
    
    /// HVAC展示
    var hvacView: SHSchduleHVACView =
        SHSchduleHVACView.loadFromNib()
    
    /// audio展示
    var audioView: SHSchduleAudioView =
        SHSchduleAudioView.loadFromNib()
    
    /// shade展示
    var shadeView: SHSchduleShadeView =
        SHSchduleShadeView.loadFromNib()
    
    /// 地热展示
    var floorheatingView: SHSchedualFloorHeatingView =
        SHSchedualFloorHeatingView.loadFromNib()
    
    // MARK: - 布局约束
    
    /// 向上移动的基础约束
    @IBOutlet weak var baseTopConstraint: NSLayoutConstraint!
    
    /// 设置view的顶部约束
    @IBOutlet weak var settingViewTopConstraint: NSLayoutConstraint!
    
    /// 子控件的高度约束
    @IBOutlet weak var basseViewHeightConstraint: NSLayoutConstraint!


    // MARK： - 计划名称 与 控制类型
    
    /// 计划名称textField
    @IBOutlet weak var scheduleNameTextField: UITextField!
    
    /// 控制类型的提示Label
    @IBOutlet weak var controlItemLabel: UILabel!
    
    /// 控制类型按钮
    @IBOutlet weak var controlItemButton: SHCommandButton!
    
    /// 控制类型列表
    @IBOutlet weak var controlItemListView: UITableView!
    
    // MARK: - 控制区域
    
    /// 区域控制Label
    @IBOutlet weak var controlZoneLabel: UILabel!
    
    /// 区域按钮
    @IBOutlet weak var controlZoneButton: SHCommandButton!
    
    /// 控制区域列表
    @IBOutlet weak var controlZoneListView: UITableView!

    // MARK: - 显示需要控制的内容
    
    /// 选择区域展示列表
    @IBOutlet weak var showControlScheduleView: UIView!
    
    /// 执行频率
    @IBOutlet weak var frequencyLabel: UILabel!
    
    /// 保存数据
    @IBOutlet weak var saveButton: SHCommandButton!
    
    /// 声音按钮
    @IBOutlet weak var soundButton: SHCommandButton!
    
    /// 执行频率按钮
    @IBOutlet weak var frequencyButton: SHCommandButton!
    
    /// 时间按钮
    @IBOutlet weak var timeButton: SHCommandButton!
    
    /// 选择星期按钮
    @IBOutlet weak var selectWeekButton: SHCommandButton!
    
    /// 日期选择器
    @IBOutlet weak var datePicker: UIDatePicker!
 
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - 点击事件
extension SHSchedualEditViewController {
    
    /// 选择执行的时间
    @IBAction func selectExecuteTime() {
        
        showTime()
    }
    
    /// 选择星期
    @IBAction func selectWeekButtonClick() {
        
        let weekView = 
            SHSchedualWeekView.schedualWeekView(
                schedual
        )

        let alertController =
            TYAlertController(
                alert: weekView,
                preferredStyle: .alert,
                transitionAnimation: .dropDown
        )
        
        alertController?.backgoundTapDismissEnable = true
        
        present(alertController!,
                animated: true,
                completion: nil
        )
    }

    
    /// 时间按钮
    @IBAction func timeButtonClick() {
     
        let scale: CGFloat =
            UIDevice.is_iPad() ?  1.8 : 1.3
        
        let moveMarign = pickerViewHeight * scale
        
        if baseTopConstraint.constant >= 0 {
            
            if datePicker.transform == .identity {
                
                datePicker.transform =
                    CGAffineTransform(scaleX: scale,
                                      y: scale
                )
            }
            
            baseTopConstraint.constant -= moveMarign
            settingViewTopConstraint.constant += moveMarign
            
        } else {
            
            baseTopConstraint.constant += moveMarign
            settingViewTopConstraint.constant -= moveMarign
            datePicker.transform = .identity
        }
        
        // 触发布局
        UIView .animate(withDuration: 0.3) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    /// 执行频率点击
    @IBAction func frequencyButtonClick() {
        
        let alertView =
            TYCustomAlertView(title: nil,
                              message: nil,
                              isCustom: true
        )
        
        weak var weakSelf = self
        
        let oneceAction =
            TYAlertAction(
            title: SHLanguageText.frequencyOnce,
            style: .default) { (action) in
            
             weakSelf?.setExecutionFrequency(.oneTime)
        }
        
        alertView?.add(oneceAction)
        
        let dayilyAction =
            TYAlertAction(
                title: SHLanguageText.frequencyDaily,
                style: .default) { (action) in
                    
                    weakSelf?.setExecutionFrequency(.dayily)
        }
        
        alertView?.add(dayilyAction)
        
        let weeklyAction =
            TYAlertAction(
                title: SHLanguageText.frequencyWeekly,
                style: .default) { (action) in
                    
                    weakSelf?.setExecutionFrequency(.weekly)
        }
        
        alertView?.add(weeklyAction)
        
        let cancelAction =
            TYAlertAction(title: SHLanguageText.cancel,
                          style: .cancel,
                          handler: nil
        )
        
        alertView?.add(cancelAction)
        
        let alertController =
            TYAlertController(
                alert: alertView,
                preferredStyle: .alert,
                transitionAnimation: .dropDown
        )
        
        present(alertController!,
                animated: true,
                completion: nil
        )
    }
    
    /// 设置执行频率
    func setExecutionFrequency(_ frequencyID: SHSchdualFrequency) {

        schedual?.frequencyID = frequencyID
        
        datePicker.datePickerMode =
            (frequencyID == .oneTime) ? UIDatePicker.Mode.dateAndTime : UIDatePicker.Mode.time
        
        showTime()
        
        switch frequencyID {
        
        case .oneTime:
            frequencyButton.setTitle(
                SHLanguageText.frequencyOnce,
                for: .normal
            )
            
        case .dayily:
            frequencyButton.setTitle(
                SHLanguageText.frequencyDaily,
                for: .normal
            )
            
        case .weekly:
            frequencyButton.setTitle(
                SHLanguageText.frequencyWeekly,
                for: .normal
            )
        }
        
        selectWeekButton.isHidden =
            frequencyID != .weekly
    }

    /// 声音按钮点击
    @IBAction func soundButtonClick() {
        
        soundButton.isSelected = !soundButton.isSelected
        schedual?.haveSound = soundButton.isSelected
        
        if soundButton.isSelected {
            
            SoundTools.share()?.playSound(
                withName: "schedulesound.wav"
            )
        
        } else {
        
            SoundTools.share()?.stopSound(
                withName: "schedulesound.wav"
            )
        }
    }
    
    
    /// 控制类型按钮点击

    @IBAction func controlItemButtonClick() {

        controlItemListView.isHidden =
            !controlItemListView.isHidden
    }

    /// 区域点击
    @IBAction func controlZoneButtonClick() {

        controlZoneListView.isHidden =
            !controlZoneListView.isHidden
    }
    
    /// 显示时间
    private func showTime() {
        
        guard let plan = schedual else {
            return
        }
     
        let dateFormatter = DateFormatter()
        
        switch plan.frequencyID {
        
        case .oneTime:
            
            dateFormatter.dateFormat = "MM-dd HH:mm"
            
            plan.executionDate =
                dateFormatter.string(
                    from: datePicker.date
            )
            
            timeButton.setTitle(plan.executionDate,
                                for: .normal
            )
            
        case .dayily:
            
            dateFormatter.dateFormat = "HH:mm"
            
            plan.executionDate =
                dateFormatter.string(
                    from: datePicker.date
            )
            
            timeButton.setTitle(plan.executionDate,
                                for: .normal
            )
            
        case .weekly:
            
            dateFormatter.dateFormat = "HH:mm"
           
            timeButton.setTitle(
                dateFormatter.string(
                    from: datePicker.date
                ),
                
                for: .normal
            )
            
            guard let comps = NSDate.getCurrentDateComponents(
                    from: datePicker.date
            ) else {
            
                return
            }
            
            plan.executionHours = UInt8(comps.hour ?? 0)
            plan.executionMins = UInt8(comps.minute ?? 0)
            
            plan.executionDate =
                String(format: "%02d:%02d",
                       plan.executionHours,
                       plan.executionMins
            )
            
            
        }
        
    }
    
    
    /// 保存数据
    @IBAction func saveButtonClick() {
        
        guard let plan = schedual else {
            return
        }
        
        if processingSchedualName() == false {
            
            scheduleNameTextField.becomeFirstResponder()
            return
        }
        
        if isAddSedual {
            
            SHSQLManager.share()?.insertNewScheduale(plan)
        
        } else {
        
            SHSQLManager.share()?.updateSchedule(plan)
        }
        
        print(" ===> 保存命令集合 === \(plan.commands.count) ")
        
        if let commands = plan.commands as? [SHSchedualCommand] {
            
            for command: SHSchedualCommand in commands {
                SHSQLManager.share()?.insertNewSchedualeCommand(command)
            }
        }
        
        SHSchedualExecuteTools.shared.updateSchduals()
        
        NotificationCenter.default.post(
            name: NSNotification.Name.SHSchedualSaveData,
            object: plan.controlledItemID
        )
        
        navigationController?.popViewController(
            animated: true
        )
    }
}


// MARK: - UITextFieldDelegate 与 名称处理
extension SHSchedualEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    /// 处理要保存的计划名称
    private func processingSchedualName() -> Bool {
        
        guard let name = scheduleNameTextField.text else {
            
            return false
        }
        
        if name.isEmpty {
            
            SVProgressHUD.showError(
                withStatus: "The name cannot be empty!"
            )
            
            return false
        }
        
        if let allScheduales = SHSQLManager.share()?.getAllSchdule() as? [SHSchedual] {
            
            for plan in allScheduales {
                
                if plan.scheduleName == name &&
                    plan.scheduleID != schedual?.scheduleID {
                    
                    SVProgressHUD.showError(
                        withStatus: "The name has been saved!"
                    )
                    
                    return false
                }
            }
        }
        
        schedual?.scheduleName = name
        
        return true
    }
    
}


// MARK: - UI设置
extension SHSchedualEditViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            basseViewHeightConstraint.constant =
                isPortrait ? (navigationBarHeight + statusBarHeight):
            navigationBarHeight
        }
        
        // 不同的控制项的显示
        macroView.frame = showControlScheduleView.bounds
        moodView.frame = showControlScheduleView.bounds
        lightView.frame = showControlScheduleView.bounds
        hvacView.frame = showControlScheduleView.bounds
        shadeView.frame = showControlScheduleView.bounds
        audioView.frame = showControlScheduleView.bounds
        floorheatingView.frame =
            showControlScheduleView.bounds

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let plan = schedual else {
            return
        }
        
       
        // 选中第一个
        self.tableView(
            controlItemListView,
            didSelectRowAt: IndexPath(row: 0,
                                      section: 0)
        )
        
        setExecutionFrequency(plan.frequencyID)
        
        soundButton.isSelected = plan.haveSound
        
        if (plan.controlledItemID != SHSchdualControlItemType.marco) &&
            !isAddSedual {
            
            let count = allZones.count
            
            for i in 0 ..< count {
                
                let zoneID = allZones[i].zoneID
                
                if zoneID == plan.zoneID {
                    
                    let index =
                        IndexPath(row: i, section: 0)
                    
                    controlZoneListView.selectRow(
                        at: index,
                        animated: true,
                        scrollPosition: .top
                    )
                    
                    self.tableView(
                        controlZoneListView,
                        didSelectRowAt: index
                    )
                    
                    break
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化表格
        setupTableView()

        // 文字适配
        navigationItem.title =
            isAddSedual ? SHLanguageText.newSchedual :
            SHLanguageText.editSchedual
        
        scheduleNameTextField.text =
            isAddSedual ? SHLanguageText.schedualName :
            schedual?.scheduleName
        
        soundButton.setTitle(
            SHLanguageText.schedualSound,
            for: .normal
        )
        
        controlZoneLabel.text =
            SHLanguageText.controlZone
        
        controlItemLabel.text =
            SHLanguageText.controlItem
        
        frequencyLabel.text = SHLanguageText.frequency
        
        saveButton.setTitle(SHLanguageText.save,
                            for: .normal
        )
        
        controlZoneButton.titleLabel?.numberOfLines = 0
        controlZoneButton.titleLabel?.textAlignment
            = .center
        
        timeButton.titleLabel?.numberOfLines = 0
        timeButton.titleLabel?.textAlignment = .center
        
        datePicker.setValue(UIView.textWhiteColor(),
                            forKey: "textColor"
        )
        
        scheduleNameTextField.setRoundedRectangleBorder()
        controlItemButton.setRoundedRectangleBorder()
        controlZoneButton.setRoundedRectangleBorder()
        timeButton.setRoundedRectangleBorder()
        frequencyButton.setRoundedRectangleBorder()
        selectWeekButton.setRoundedRectangleBorder()
        soundButton.setRoundedRectangleBorder()
        saveButton.setRoundedRectangleBorder()
        
        if isAddSedual {
            
            datePicker.date = Date()
        
        } else {
         
            guard let plan = schedual else {
                return
            }
            
            let dateFormatter = DateFormatter()
            
            switch plan.frequencyID {
                
            case .oneTime:
                
                dateFormatter.dateFormat = "MM-dd HH:mm"
                datePicker.date =
                    dateFormatter.date(
                        from: plan.executionDate
                    ) ?? Date()
                
            case .dayily:
                
                dateFormatter.dateFormat = "HH:mm"
                datePicker.date =
                    dateFormatter.date(
                        from: plan.executionDate
                    ) ?? Date()
                
            case .weekly:
                
                dateFormatter.dateFormat = "HH:mm"
                
                let time =
                    String(format: "%02d:%02d",
                           plan.executionHours,
                           plan.executionMins
                )
                
                datePicker.date = 
                    dateFormatter.date(from: time) ?? Date()
                
            }
            
        }
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            scheduleNameTextField.font = font
            controlItemLabel.font = font
            controlZoneLabel.font = font
            frequencyLabel.font = font
        }
    }

    
    /// 初始化表格
    private func setupTableView() {
        
        controlZoneListView.register(
            UINib(
                nibName: schdualContolItemAndZoneCellReusableIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schdualContolItemAndZoneCellReusableIdentifier
        )
        
        controlZoneListView.rowHeight = SHSchdualContolItemAndZoneCell.rowHeight
        
        controlZoneListView.isHidden = true
        
        
        controlItemListView.register(
            UINib(
                nibName: schdualContolItemAndZoneCellReusableIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schdualContolItemAndZoneCellReusableIdentifier
        )
        
        controlItemListView.rowHeight = SHSchdualContolItemAndZoneCell.rowHeight
        
        controlItemListView.isHidden = true
        
    }
}


// MARK: - UITableViewDelegate
extension SHSchedualEditViewController: UITableViewDelegate {
    
    /// 选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 选择控制项
        if tableView == controlItemListView {
          
            schedual?.controlledItemID =
                SHSchdualControlItemType(
                    rawValue: UInt(indexPath.row + 1)
                ) ?? .marco
            
            
            controlItemButton.setTitle(
                controlItems[indexPath.row],
                for: .normal
            )
            
            tableView.isHidden = true
            
            setControlZoneView()
        
        // 选择类型
        } else if tableView == controlZoneListView {
            
            let zone = allZones[indexPath.row]
            
            controlZoneButton.setTitle(zone.zoneName,
                                       for: .normal
            )
            
            schedual?.zoneID = zone.zoneID
            
            tableView.isHidden = true
            
            setDifferentControlItemZoneView()
        }
    }
}

// MARK: - UITableViewDataSource
extension SHSchedualEditViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if tableView == controlItemListView {

            return controlItems.count
    
        } else if tableView == controlZoneListView {

            return allZones.count
    
        }

        return 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: schdualContolItemAndZoneCellReusableIdentifier, for: indexPath) as! SHSchdualContolItemAndZoneCell
        
        
        if tableView == controlItemListView {
            
            cell.controlItemName =
                controlItems[indexPath.row]
        
        } else if tableView == controlZoneListView {
            
            cell.currentZone = allZones[indexPath.row]
        }
        
        return cell
    }
    
}


// MARK: - 不同的控制模块
extension SHSchedualEditViewController {
    
    /// 设置区域界面
    func setControlZoneView() {
        
        guard let plan = schedual else {
            return
        }
        
        // 显示与隐藏其他的视图
        macroView.isHidden =
            plan.controlledItemID !=  .marco
        
        moodView.isHidden =
            plan.controlledItemID != .mood
        
        lightView.isHidden =
            plan.controlledItemID != .light
        
        hvacView.isHidden =
            plan.controlledItemID != .HVAC
        
        audioView.isHidden =
            plan.controlledItemID != .audio
        
        shadeView.isHidden =
            plan.controlledItemID != .shade
        
        floorheatingView.isHidden =
            plan.controlledItemID != .floorHeating
        
        // 处理区域按钮
        
        controlZoneButton.isUserInteractionEnabled =
            plan.controlledItemID != .marco
        
        // 如果是宏命令
        if plan.controlledItemID == .marco {
            
            if macroView.window == nil {
                
                showControlScheduleView.addSubview(
                    macroView
                )
            }
            
            controlZoneButton.setTitle("N/A", for: .normal)
            
            macroView.schedual = plan
            
            return
        }
        
        /// 区域数组
        var zones: [SHZone]?

        switch plan.controlledItemID {
        
        case .mood:
            
            if moodView.window == nil {
                
                showControlScheduleView.addSubview(
                    moodView
                )
            }
            
            zones = SHSQLManager.share()?.getZonesFor(
                SHSystemDeviceType.mood.rawValue
            ) as? [SHZone]
            
            
        case .light:
            
            if lightView.window == nil {
                
                showControlScheduleView.addSubview(
                    lightView
                )
            }
            
            zones = SHSQLManager.share()?.getZonesFor(
                SHSystemDeviceType.light.rawValue
            ) as? [SHZone]
            
        case .HVAC:
            
            if hvacView.window == nil {
                
                showControlScheduleView.addSubview(
                    hvacView
                )
            }
            
            zones = SHSQLManager.share()?.getZonesFor(
                SHSystemDeviceType.hvac.rawValue
            ) as? [SHZone]
            
        case .audio:
            
            if audioView.window == nil {
                
                showControlScheduleView.addSubview(
                    audioView
                )
            }
            
            zones = SHSQLManager.share()?.getZonesFor(
                SHSystemDeviceType.audio.rawValue
            ) as? [SHZone]
            
        case .shade:
            
            if shadeView.window == nil {
                
                showControlScheduleView.addSubview(
                    shadeView
                )
            }
            
            zones = SHSQLManager.share()?.getZonesFor(
                SHSystemDeviceType.shade.rawValue
            ) as? [SHZone]
            
        case .floorHeating:
            
            if floorheatingView.window == nil {
                
                showControlScheduleView.addSubview(
                    floorheatingView
                )
            }
            
            zones = SHSQLManager.share()?.getZonesFor(
                SHSystemDeviceType.floorHeating.rawValue
            ) as? [SHZone]
            
        default:
            break
        }
        
        if zones?.isEmpty ?? true {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
        
             controlZoneButton.isUserInteractionEnabled =
                false
            
            controlZoneButton.setTitle("N/A", for: .normal)
            
            return
        }
        
        allZones = zones!
        
        controlZoneButton.isUserInteractionEnabled =
            (allZones.count != 0)
        
        // 刷新区域列表
        controlZoneListView.reloadData()
        
        // 如果新增的，选择第一个，否则选择其它的
        if isAddSedual {
            
            let index = IndexPath(row: 0, section: 0)
            
            controlZoneListView.selectRow(
                at: index,
                animated: true,
                scrollPosition: .top
            )
            
            self.tableView(
                controlZoneListView,
                didSelectRowAt: index
            )
            
        } else {
            
            let count = allZones.count
            
            for i in 0 ..< count {
                
                let zone = allZones[i]
                
                if zone.zoneID == plan.zoneID {
                    
                    let index =
                        IndexPath(row: i, section: 0)
                    
                    controlZoneListView.selectRow(
                        at: index,
                        animated: true,
                        scrollPosition: .top
                    )
                    
                    self.tableView(
                        controlZoneListView,
                        didSelectRowAt: index
                    )
                    
                    break
                }
            }
            
        }
        
    }
    
    /// 设置不同的区域
    func setDifferentControlItemZoneView() {
        
        guard let plan = schedual else {
            return
        }
        
        switch plan.controlledItemID {
        
        case .mood:
            moodView.schedual = plan
            
        case .light:
            lightView.schedual = plan
            
        case .shade:
            shadeView.schedual = plan
            
        case .HVAC:
            hvacView.schedual = plan
            
        case .audio:
            audioView.schedual = plan
            
        case .floorHeating:
            floorheatingView.schedual = plan
            
        default:
            break
        }
    }
}
