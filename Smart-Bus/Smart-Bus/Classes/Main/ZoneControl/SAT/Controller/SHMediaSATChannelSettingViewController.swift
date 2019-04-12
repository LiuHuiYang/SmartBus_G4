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
    
    private var categories = [SHMediaSATCategory]()
    
    /// 延时
    @IBOutlet weak var timeTextField: UITextField!
    
    /// 分类列表
    @IBOutlet weak var listView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "addDevice_navigationbar",
                hightlightedImageName: "addDevice_navigationbar",
                addTarget: self,
                action: #selector(addMoreSatCategory),
                isLeft: false
        )
        
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
            UINib(nibName: mediaSatCategoryEditCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
                mediaSatCategoryEditCellReuseIdentifier
        )
        
        
        listView.rowHeight = SHMediaSATCategoryEditViewCell.rowHeight
        
        if UIDevice.is_iPad() {
            
            timeTextField.font = UIView.suitFontForPad()
        }
        
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        categories =
            SHSQLiteManager.shared.getSatCategory(mediaSAT!)
        
        listView.reloadData()
    }
}


// MARK: - 添加新的分析
extension SHMediaSATChannelSettingViewController {
    
    /// 添加新的分类
    @objc private func addMoreSatCategory() {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            return;
        }
        
        let category = SHMediaSATCategory()
        category.subnetID = mediaSAT!.subnetID
        category.deviceID = mediaSAT!.deviceID
        category.zoneID = mediaSAT!.zoneID
        category.categoryID = SHSQLiteManager.shared.getMaxCategoryID(
                category.zoneID
            ) + 1
        
        category.categoryName = "new category"
        
        _ = SHSQLiteManager.shared.insertSatCategory(category)
        
        
        let detailViewController =
            SHDeviceArgsViewController()
        
        detailViewController.mediaSatCategory = category
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}


// MARK: - UITableViewDelegate
extension SHMediaSATChannelSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "\t\(SHLanguageText.delete)\t") { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let category = self.categories[indexPath.row]
            
            self.categories.remove(at: indexPath.row)
            
            _ = SHSQLiteManager.shared.deleteSatCategory(
                category
            )
            
            tableView.reloadData()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "\t\(SHLanguageText.edit)\t") { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            
            let detailViewController =
                SHDeviceArgsViewController()
            
            detailViewController.mediaSatCategory = self.categories[indexPath.row]
            
            self.navigationController?.pushViewController(
                detailViewController,
                animated: true
            )
            
        }
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController =
            SHMediaSatCategoryDetailViewController()
        
        detailViewController.satCategory =
            categories[indexPath.row]
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}

extension SHMediaSATChannelSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return categories.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier:
                mediaSatCategoryEditCellReuseIdentifier,
                for: indexPath
            ) as! SHMediaSATCategoryEditViewCell
        
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
