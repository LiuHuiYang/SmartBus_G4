//
//  SHResetPasswordViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/9.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHResetPasswordViewController: SHViewController {
    
    /// 验证码输入框
    @IBOutlet weak var verificationTextField: UITextField!
    
    /// 描述文字
    @IBOutlet weak var verfificationDescLabel: UILabel!
    
    /// 验证按钮
    @IBOutlet weak var verificationButton: UIButton!
    
    /// 高度约束
    @IBOutlet weak var verificationTextFieldHeightConstraint: NSLayoutConstraint!
    
    /// 验证按钮点击
    @IBAction func verificationButtonClick() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.title = "Reset Password"
        
        verificationButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            verificationTextField.font = font
            verfificationDescLabel.font = font
            verificationButton.titleLabel?.font = font
        }
        
    }
 
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            verificationTextFieldHeightConstraint.constant =
                navigationBarHeight
        }
    }
}
