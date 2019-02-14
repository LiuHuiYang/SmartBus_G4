//
//  SHSmsControlViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/29.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHSmsControlViewController: SHViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = (SHLanguageTools.share()?.getTextFromPlist("MAIN_PAGE", withSubTitle: "SMS_CONTROL") as! String)
    }
}
