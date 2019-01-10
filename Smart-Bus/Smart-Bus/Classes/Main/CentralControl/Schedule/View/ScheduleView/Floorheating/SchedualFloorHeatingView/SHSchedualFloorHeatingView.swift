//
//  SHSchedualFloorHeatingView.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/10.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHSchedualFloorHeatingView: UIView, loadNibView {

    /// 计划模型
    var schedual: SHSchedual? 
  
    /// 列表
    @IBOutlet weak var listView: UITableView!
}
