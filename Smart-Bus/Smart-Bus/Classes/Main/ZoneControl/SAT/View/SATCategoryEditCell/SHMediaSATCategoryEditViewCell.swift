//
//  SHMediaSATCategoryEditViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/29.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMediaSATCategoryEditViewCell: UITableViewCell {
    
    /// 分类
    var category: SHMediaSATCategory? {
        
        didSet {
            
            nameTextField.text = category?.categoryName
        }
    }
    
    /// 是新增加的
    var isNew = false
    
    /// 编辑新增的分类
    var editNewCategory = false {
        
        didSet {
            
            nameTextField.becomeFirstResponder()
        }
    }

    /// 开始移动的回调
    var cellMove: (() -> Void)?

    
    /// 名称
    @IBOutlet weak var nameTextField: UITextField!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none

        if UIDevice.is_iPad() {

            nameTextField.font = UIView.suitFontForPad()
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


// MARK: - UITextFieldDelegate
extension SHMediaSATCategoryEditViewCell : UITextFieldDelegate {
    
    /// 结束编辑
    func textFieldDidEndEditing(_ textField: UITextField) {
 
        // 修改样式
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIView.textWhiteColor()

        guard let name = textField.text else {
            return
        }
        
        if name.isEmpty || name == category?.categoryName {
            return
        }
        
        category?.categoryName = name
        
        let result =
                isNew ?
                SHSQLManager.share().insertNewMediaSATCategory(category) :
        
                    (SHSQLManager.share()?.update(category))!
        
        if result {
              SVProgressHUD.showSuccess(
                withStatus: SHLanguageText.saved
            )
        }
    }
    
    /// 开始编辑
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIView.textWhiteColor()
        textField.textColor = UIColor(white: 0.3, alpha: 1.0)

        cellMove?()
    }
    
    /// 点击确认
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.textFieldDidEndEditing(textField)
        textField.resignFirstResponder()
        
        return true
    }
}
