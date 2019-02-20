//
//  SHZoneLightButton.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/6/29.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

class SHZoneLightButton: UIButton {

    override func layoutSubviews() {

        super.layoutSubviews()

        let scale: CGFloat = 0.7

        imageView?.frame_width = frame_width * scale
        imageView?.frame_height = frame_height * scale

        imageView?.frame_x = frame_width * (1 - scale) * 0.5
        imageView?.frame_y = frame_height * (1 - scale) * 0.5
    }


}
