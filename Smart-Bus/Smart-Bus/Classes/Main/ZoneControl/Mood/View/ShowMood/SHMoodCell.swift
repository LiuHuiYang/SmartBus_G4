//
//  SHMoodCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMoodCell: UICollectionViewCell {
    
    /// 场景
    var mood: SHMood? {
        
        didSet {
            
            commandButton.setTitle(mood?.moodName, for: .normal)
            
            commandButton.setImage(
                UIImage(named: (mood?.moodIconName ?? "mood_romantic") + "_normal"),
                for: .normal
            )

            commandButton.setImage(
                UIImage(named: (mood?.moodIconName ?? "mood_romantic") + "_highlighted"),
                for: .selected
            )
        }
    }
    
    /// 命令按钮
    @IBOutlet weak var commandButton: SHCommandButton!
    
    /// 进度占位条
    @IBOutlet weak var holdProgressView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        commandButton.setRoundedRectangleBorder()
        
        commandButton.setTitleColor(
            UIView.textWhiteColor(),
            for: .normal
        )
        
        commandButton.setTitleColor(
            UIView.highlightedTextColor(),
            for: .selected
        )
        
        commandButton.titleLabel?.numberOfLines = 0
        commandButton.titleLabel?.textAlignment = .center
        
        if UIDevice.is_iPad() {
            
            commandButton.titleLabel?.font = UIView.suitFontForPad()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(commandButtonChangeStatus),
            name: NSNotification.Name(
                rawValue: commandExecutionComplete
            ),
            object: nil
        )
    }
    
    @objc private func commandButtonChangeStatus() {
        
        commandButton.isSelected = false
        
        SHLoadProgressView.shared.removeFromSuperview()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /// mood点击
    @IBAction func commandButtonClick() {
        
        if mood == nil {
            
            let title = mood?.moodName
            
            SVProgressHUD.showInfo(withStatus: "\(title ?? "") \(SHLanguageText.noData)")
            
            return
        }
        
        let moodCommands =
            SHSQLiteManager.shared.getMoodCommands(mood!)
        
        commandButton.isSelected = true
        
        SHLoadProgressView.showIn(holdProgressView)
        
        SVProgressHUD.showSuccess(
            withStatus: "Executing \(mood?.moodName ?? "mood")"
        )
         
        performSelector(
            inBackground: #selector(executeCommands(_:)),
            with: moodCommands
        )
    }
 
    /// 执行命令
    ///
    /// - Parameter commands: 指令集合
    @objc private func executeCommands(_ commands: [SHMoodCommand]) {
        
        for command in commands {
            
            SHSocketTools.executeMoodCommand(command)
        }
    }
}
