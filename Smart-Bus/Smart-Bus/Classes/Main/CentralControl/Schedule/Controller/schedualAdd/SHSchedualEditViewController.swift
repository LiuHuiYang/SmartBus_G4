//
//  SHSchedualEditViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/20.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHSchedualEditViewController: SHViewController {

    /// 是否为增加的计算
    var isAddSedual = false
    
    /// 编辑的计划
    var schedual: SHSchedule? {
        
        didSet {
            
            guard let plan = schedual else {
                return
            }
            
            plan.commands =
                SHSQLiteManager.shared.getSchedualCommands(
                    plan.scheduleID
            )
        }
    }
    
    
    /// 不同的控制类型
    private lazy var controlItemView: SHScheduleControlItemView = {
        
        let item = SHScheduleControlItemView()
        
        itemsView.addSubview(item)
        
        item.delegate = self
    
        return item
    }()
    
    
    // MARK: - 不同的计划部分
    
    /// 类型列表
    @IBOutlet weak var itemsView: UIView!
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
    
  
    // MARK: - 显示需要控制的内容

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


// MARK: - SHScheduleControlItemViewDelegate
extension SHSchedualEditViewController: SHScheduleControlItemViewDelegate {
   
    func schedueleControlItemChoice(_ controlType: SHSchdualControlItemType) {
         
        
        switch controlType {
        case .marco:
            
            let macroController = SHScheduleMacroViewController()
            
            macroController.schedule = schedual
            
            navigationController?.pushViewController(
                macroController,
                animated: true
            )
        
        case .mood:
            
            let moodController =
                SHScheduleMoodViewController()
            
            moodController.schedule = schedual
            
            navigationController?.pushViewController(
                moodController,
                animated: true
            )
            
        case .light:
            
            let lightController =
                SHScheduleLightViewController()
            
            lightController.schedule = schedual
            
            navigationController?.pushViewController(
                lightController,
                animated: true
            )
            
        case .hvac:
            
            let hvacController =
                SHScheduleHVACViewController()
            
            hvacController.schedule = schedual
            
            navigationController?.pushViewController(
                hvacController,
                animated: true
            )
            
        case .audio:
            
            let audioController =
                SHScheduleAudioViewController()
            
            audioController.schedule = schedual
            
            navigationController?.pushViewController(
                audioController,
                animated: true
            )
            
        case .shade:
            
            let shadeController =
                SHScheduleShadeViewController()
            
            shadeController.schedule = schedual
            
            navigationController?.pushViewController(
                shadeController,
                animated: true
            )
            
        case .floorHeating:
            
            let floorHeatingController =
                SHScheduleFloorheatingViewController()
            
            floorHeatingController.schedule = schedual
            
            navigationController?.pushViewController(
                floorHeatingController,
                animated: true
            )
            
        case .none:
            break
        }
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
            UIDevice.is_iPad() ? 1.8 : 1.15
        
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
            
            _ = SHSQLiteManager.shared.insertSchedule(plan)
        
        } else {
        
            _ = SHSQLiteManager.shared.updateSchedule(plan)
        }
        
        // 先清空以前的所有数据
        _ = SHSQLiteManager.shared.deleteSchedualeCommands(
            plan
        )
        
        let beforeCommands =
            SHSQLiteManager.shared.getSchedualCommands(
                plan.scheduleID
        )
        
        print("1. 保存前的数据 \(beforeCommands.count)")
        
        if let commands = plan.commands as? [SHSchedualCommand] {
            
           
             print("2. 将要保存的数据 \(commands.count)")
            
            for command in commands {
                
                _ = SHSQLiteManager.shared.insertSchedualeCommand(command)
            }
        }
        
        let savedCommands =   SHSQLiteManager.shared.getSchedualCommands(
            plan.scheduleID
        )
        
        print("3. 保存后的数据 \(savedCommands.count)")

        SHSchedualExecuteTools.shared.updateSchduals()
        
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
        
        let allScheduales =
            SHSQLiteManager.shared.getSchedules()
        
        for plan in allScheduales {
            
            if plan.scheduleName == name &&
                plan.scheduleID != schedual?.scheduleID {
                
                SVProgressHUD.showError(
                    withStatus: "The name has been saved!"
                )
                
                return false
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
        
        controlItemView.frame = itemsView.bounds
        
        if UIDevice.is_iPad() {
            
            basseViewHeightConstraint.constant =
                isPortrait ? (navigationBarHeight + statusBarHeight):
            navigationBarHeight
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let plan = schedual else {
            return
        }
        
        setExecutionFrequency(plan.frequencyID)
        
        soundButton.isSelected = plan.haveSound
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlItemView.schedule = schedual

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
        
        frequencyLabel.text = SHLanguageText.frequency
        
        saveButton.setTitle(SHLanguageText.save,
                            for: .normal
        )
        
        timeButton.titleLabel?.numberOfLines = 0
        timeButton.titleLabel?.textAlignment = .center
        
        datePicker.setValue(UIView.textWhiteColor(),
                            forKey: "textColor"
        )
        
        scheduleNameTextField.setRoundedRectangleBorder()
        
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
            frequencyLabel.font = font
        }
    }
 
}
