//
//  SHAudioRecordViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/29.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

class SHAudioRecordViewController: SHViewController {

    /// 当前的音乐
    var currentAudio: SHAudio?
    
    /// 录制按钮
    @IBOutlet weak var recordButton: SHAudioRecordControlButton!
    
    /// 上传按钮
    @IBOutlet weak var uploadButton: SHAudioRecordControlButton!
    
    /// 删除
    @IBOutlet weak var deleteButton: SHAudioRecordControlButton!
    
    /// 预览按钮
    @IBOutlet weak var preViewButton: SHAudioRecordControlButton!
    
    /// 整体底部约束
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let record =
            (SHLanguageTools.share()?.getTextFromPlist(
                "RECORD",
                withSubTitle: "RECORD")
            ) as! String
        
        recordButton.setTitle(record, for: .normal)
        
        let preView =
            (SHLanguageTools.share()?.getTextFromPlist(
                "RECORD",
                withSubTitle: "PREVIEW")
            ) as! String
        
        preViewButton.setTitle(preView, for: .normal)
        
        deleteButton.setTitle(SHLanguageText.delete, for: .normal)
        
       let upToFtp =
            (SHLanguageTools.share()?.getTextFromPlist(
                "RECORD",
                withSubTitle: "UPLOAD_TO_FTP")
            ) as! String
        
        uploadButton.setTitle(upToFtp, for: .normal)
        
        let title =
            (SHLanguageTools.share()?.getTextFromPlist(
                "RECORD",
                withSubTitle: "TITLE_NAME")
            ) as! String
        
        navigationItem.title = title
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        if UIDevice.is_iPhoneX_More() {
            bottomHeightConstraint.constant = tabBarHeight_iPhoneX_more
        }
    }
    
    // MARK: - 点击事件
    
    /// 上传
    @IBAction func uploadButtonClick() {
        
    }
    
    /// 预览
    @IBAction func preViewButtonClick() {
        
    }
    
    /// 删除
    @IBAction func deleteButtonClick() {
        
    }
    
    /// 录制
    @IBAction func recordButtonClick() {
       
        
    }
    
}
