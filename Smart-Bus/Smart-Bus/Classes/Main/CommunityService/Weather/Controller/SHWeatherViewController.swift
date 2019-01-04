//
//  SHWeatherViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2017/10/29.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHWeatherViewController: SHViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       navigationItem.title = (SHLanguageTools.share()?.getTextFromPlist("MAIN_PAGE", withSubTitle: "WEATHER") as! String)
    }
 

}
