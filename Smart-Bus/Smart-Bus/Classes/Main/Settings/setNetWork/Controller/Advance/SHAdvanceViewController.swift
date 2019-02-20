//
//  SHAdvanceViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/9.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHAdvanceViewController: SHViewController {

    /// 重设密码
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    /// 修改密码
    @IBOutlet weak var modifyPasswordButton: UIButton!
    
    /// 修改RSIP名称
    @IBOutlet weak var modifyNameOfRSIPButton: UIButton!
    
    /// 按钮的高度约束
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    
    /// 重设密码
    @IBAction func resetPasswordButtonClick() {
        
        navigationController?.pushViewController(
            SHResetPasswordViewController(),
            animated: true
        )
    }
    
    /// 修改密码
    @IBAction func modifyPasswordButtonClick() {
        
        navigationController?.pushViewController(
            SHModifyPasswordViewController(),
            animated: true
        )
    }
    
    /// 修改RSIP名称
    @IBAction func modifyNameOfRSIPButtonClick() {
        
        navigationController?.pushViewController(
            SHModifyRSIPNameViewController(),
            animated: true
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Advanced Settings"
        
        resetPasswordButton.setRoundedRectangleBorder()
        modifyPasswordButton.setRoundedRectangleBorder()
        modifyNameOfRSIPButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            resetPasswordButton.titleLabel?.font = font
            modifyPasswordButton.titleLabel?.font = font
            modifyNameOfRSIPButton.titleLabel?.font = font
        }
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            buttonHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
    }

}
