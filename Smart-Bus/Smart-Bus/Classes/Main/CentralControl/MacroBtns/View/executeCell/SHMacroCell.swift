//
//  SHMacroCell.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/6.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMacroCell: UICollectionViewCell {

    /// 宏
    var macro: SHMacro? {
        
        didSet {
            
            let normalImage =
                UIImage(named: "\(macro?.macroIconName ?? "Macro")_normal")
            
            let highlightedImage =
                UIImage(named: "\(macro?.macroIconName ?? "Macro")_highlighted")
            
            
            commandButton.setImage(
                normalImage,
                for: .normal
            )
            
            commandButton.setImage(
                highlightedImage,
                for: .highlighted
            )
            
            commandButton.setImage(
                highlightedImage,
                for: .selected
            )
            
            commandButton.setTitle(
                macro?.macroName,
                for: .normal
            )
        }
    }
    
    /// 宏按钮
    @IBOutlet  weak var  commandButton: SHMacroButton!
    
    /// 进度占位条
    @IBOutlet weak var holdProgressView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commandButton.setRoundedRectangleBorder()
        
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func commandButtonChangeStatus() {
        
        commandButton.isSelected = false
        
        SHLoadProgressView.share()?.removeFromSuperview()
    }
    
    /// 宏点击
    @IBAction func commandButtonClick() {
        
        if macro == nil {
            
            return
        }
        
        let commands =
            SHSQLiteManager.shared.getMacroCommands(macro!)
         
        if commands.isEmpty {
        
            let title = macro!.macroName
            
            SVProgressHUD.showInfo(withStatus: "\(title ?? "") \(SHLanguageText.noData)")
            
            return
        }
        
        commandButton.isSelected = true
        
        SHLoadProgressView.show(in: holdProgressView)
        
        performSelector(
            inBackground: #selector(executeCommands(_:)),
            with: commands
        )
    }
    
    /// 执行命令
    ///
    /// - Parameter commands: 指令集合
    @objc func executeCommands(_ commands: [SHMacroCommand]) {
        
        for command in commands {
            
            SHSocketTools.executeMacroCommand(command)
        }
    }
     
}
