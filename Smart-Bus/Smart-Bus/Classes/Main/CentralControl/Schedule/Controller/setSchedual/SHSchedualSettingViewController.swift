//
//  SHSchedualSettingViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/6.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHSchedualSettingViewController: SHViewController {
    
    /// 开启功能开关
    @IBOutlet weak var openSwitch: UISwitch!
    
    /// 开关服务
    @IBOutlet weak var openCloseServiceLabel: UILabel!
    
    /// 操作列表
    @IBOutlet weak var operatorLabel: UILabel!
    
    /// 开关的点击
    @IBAction func openSwitchClick() {
        
        let isOn = openSwitch.isOn ?  SHApplicationBackgroundTask.open :
        SHApplicationBackgroundTask.close
        
        UserDefaults.standard.set(
            isOn.rawValue,
            forKey: UIAPPLICATION_BACKGROUND_TASK_KEY
        )
        
        UserDefaults.standard.synchronize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let title =
            (SHLanguageTools.share()?.getTextFromPlist(
                "SETTINGS",
                withSubTitle: "SETTINGS")
            ) as! String
        
        navigationItem.title = title
        
        operatorLabel.text = "  1.This setting is for schedule to run in the background. Using this function, you can't shut down the SMART-BUS application.\n\n  2. If you choose to open, the program exit the background or iPhone or iPad lock screen, schedule can perform normally. We also recommend that you choose to turn on if you need to use schedule function module.\n\n  3. If the choice is closed, only the current application is running at the front desk, schedule can be executed normally. If you do not need to use the schedule function module, it is suggested that you choose to close.\n\n  4. When setting changes, you need to restart the app."
        
        
        self.openSwitch.isOn =
            UserDefaults.standard.integer(
                forKey: UIAPPLICATION_BACKGROUND_TASK_KEY
            ) ==
            Int(SHApplicationBackgroundTask.open.rawValue)
     
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            openCloseServiceLabel.font = font
            operatorLabel.font = font
        }
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height: CGFloat = (
            operatorLabel.text?.boundingRect(
                with: CGSize(width: operatorLabel.frame_width,
                             height: CGFloat(MAXFLOAT)),
                options: .usesLineFragmentOrigin,
                attributes:
                    [NSAttributedString.Key.font: operatorLabel.font],
                context: nil
            ).size.height)!
        
        operatorLabel.frame_height = height
    }

}
