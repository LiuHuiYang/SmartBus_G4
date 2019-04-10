//
//  SHMediaSATChannelSettingViewController.swift
//  Smart-Bus
//
//  Created by Apple on 2019/4/10.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// 分类重用标示符
private let  mediaSATCategoryCellReuseIdentifier = "SHMediaSATCategoryCell"

/// 卫星电视的IR延时时间
let delayIRTimekey = "SHMediaSATChannelDelayIRTime"

class SHMediaSATChannelSettingViewController: SHViewController {
    
    /// 卫星电视
    var mediaSAT: SHMediaSAT?
    
    private lazy var categories =
        SHSQLiteManager.shared.getSatCategory()
    
    /// 延时
    @IBOutlet weak var timeTextField: UITextField!
    
    /// 分类列表
    @IBOutlet weak var listView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        
        // 设置 textField
        
        // 取出沙盒中的值
        let time = UserDefaults.standard.integer(
            forKey: delayIRTimekey
        )
        
        if time == 0 {
            
            let delayTitle =
                SHLanguageTools.share()?.getTextFromPlist(
                    "MEDIA_IN_ZONE",
                    withSubTitle: "PROMPT_MESSAGE_3"
                ) as! String
            
            timeTextField.placeholder = delayTitle
            
        } else {
            
            let delayTitle =
                SHLanguageTools.share()?.getTextFromPlist(
                    "MEDIA_IN_ZONE",
                    withSubTitle: "DELAY_FOR_IR"
                ) as! String
            
            timeTextField.text = delayTitle + ": \(time) ms"
        }
        
        
        listView.register(
            UINib(nibName: "SHMediaSATCategoryEditViewCell",
                  bundle: nil),
            forCellReuseIdentifier:
            "SHMediaSATCategoryEditViewCell"
        )
        
//        listView.rowHeight = SHMediaSATCategoryEditViewCell.rowHeight
        
        if UIDevice.is_iPad() {
            
            timeTextField.font = UIView.suitFontForPad()
        }
    }
 

}


extension SHMediaSATChannelSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return categories.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SHMediaSATCategoryEditViewCell", for: indexPath) as! SHMediaSATCategoryEditViewCell
        
        cell.category = categories[indexPath.row];
        
        return cell
    }
    
}

// MARK: - UITextFieldDelegate
extension SHMediaSATChannelSettingViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let str = textField.text,
              let time = Int(str) else {
            
            SVProgressHUD.showError(withStatus: "invalid data")
            textField.text = nil
            
            return
        }
        
        if !(time >= 50 && time <= 5000) {
            
            let error =
                SHLanguageTools.share()?.getTextFromPlist(
                    "MEDIA_IN_ZONE",
                    withSubTitle: "PROMPT_MESSAGE_3"
                    ) as! String
            
            SVProgressHUD.showError(withStatus: error)
            
            return
        }
        
        UserDefaults.standard.set(time,
                                  forKey: delayIRTimekey
        )
        
        UserDefaults.standard.synchronize()
        
        let delayTitle =
            SHLanguageTools.share()?.getTextFromPlist(
                "MEDIA_IN_ZONE",
                withSubTitle: "DELAY_FOR_IR"
                ) as! String
        
        timeTextField.text = delayTitle + ": \(time) ms"
        
        SVProgressHUD.showSuccess(
            withStatus: SHLanguageText.done
        )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == timeTextField {
            
            textField.endEditing(true)
        }
        
        return true
    }
}
