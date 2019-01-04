//
//  SHLanguagesViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/10.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// 当前的语言名称
fileprivate let languageNamekey = "LAGUAGEZ_NAME"

/// cell重用标示
fileprivate let languageCellReuseIdentifier = "SHLanguageViewCell"

class SHLanguagesViewController: SHViewController {
    
    /// 选择列表
    @IBOutlet weak var listView: UITableView!
    
    /// 保存按钮
    @IBOutlet weak var saveButton: UIButton!
    
    /// 取消按钮
    @IBOutlet weak var cancelButton: UIButton!
    
    /// 按钮高度约束
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 语言集合
    fileprivate lazy var languages: [String] = SHLanguageTools.share()?.getAllLanguages() as! [String]
    
    /// 选择的语言
    fileprivate var selectLanguageName: String?
    
    /// 当前选择的语言对应的行号
    fileprivate var currentRow: Int = 0
    
 
    /// 保存点击
    @IBAction func saveButtonClick() {
        
        guard let _ = selectLanguageName else {
            return
        }
        
        UserDefaults.standard.set(
            selectLanguageName,
            forKey: languageNamekey
        )
        
        UserDefaults.standard.synchronize()
        
        SHLanguageTools.share()?.setLanguage()
        
        navigationController?.popViewController(animated: true)
    }
    
    /// 取消点击
    @IBAction func cancelButtonClick() {
        
        // ...
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navItemTitle = (SHLanguageTools.share()?.getTextFromPlist(
                "SETTINGS",
                withSubTitle: "LANGUAGE_SETTINGS")
            ) as! String
        
        navigationItem.title = navItemTitle
        
        saveButton.setTitle(SHLanguageText.save, for: .normal)
        cancelButton.setTitle(SHLanguageText.cancel, for: .normal)
        
        saveButton.setRoundedRectangleBorder()
        cancelButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            saveButton.titleLabel?.font = font
            cancelButton.titleLabel?.font = font
        }
        
        // 初始化列表
        listView.backgroundColor = UIColor.clear
        listView.rowHeight = SHLanguageViewCell.rowHeightForLanguageViewCell()
        
        listView.register(UINib(nibName:
            languageCellReuseIdentifier,
                                bundle: nil),
                          forCellReuseIdentifier: languageCellReuseIdentifier
        )
        
        // 语言操作
        let languageType =  UserDefaults.standard.object(forKey: languageNamekey) as? String
        
        let languageName = languageType ?? "English"
        
        // 遍历
        for elem in languages.enumerated() {
            
            if languageName.isEqual(elem.element) {
                currentRow = elem.offset
                break
            }
        }
        
        let indexPath = IndexPath(row: currentRow, section: 0)
        
        listView.selectRow(at: indexPath,
                           animated: false,
                           scrollPosition: .none
        )
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            buttonHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
    }
}


// MARK: - UITableViewDataSource
extension SHLanguagesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: languageCellReuseIdentifier, for: indexPath) as! SHLanguageViewCell
        
        
        cell.language = languages[indexPath.row]
        
        cell.accessoryView = UIImageView(image: UIImage(named: "check"))
        
        cell.accessoryView?.isHidden =
            (indexPath.row != self.currentRow)
        
        return cell
    }
}



// MARK: - UITableViewDelegate
extension SHLanguagesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectLanguageName = languages[indexPath.row]
        
        currentRow = indexPath.row
       
        listView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
