//
//  SHMediaSATChannelViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/28.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHMediaSATChannelViewController: SHViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title =
            SHLanguageTools.share()?.getTextFromPlist(
                "MEDIA_IN_ZONE",
                withSubTitle: "SAT_CH_SETTINGS"
        ) as! String
        
        navigationItem.title = title
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                imageName: "close",
                hightlightedImageName: "close",
                addTarget: self,
                action: #selector(close),
                isLeft: true
        )
    }
    
    @objc private func close() {
        
        dismiss(animated: true, completion: nil)
    }
}
