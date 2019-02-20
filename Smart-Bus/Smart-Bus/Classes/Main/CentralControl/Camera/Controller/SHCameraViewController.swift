//
//  SHCameraViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/9.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHCameraViewController: SHViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title =
            ((SHLanguageTools.share()?.getTextFromPlist(
                "CAMERA",
                withSubTitle: "TITLE_NAME")
                ) as! String)
    }


   

}
