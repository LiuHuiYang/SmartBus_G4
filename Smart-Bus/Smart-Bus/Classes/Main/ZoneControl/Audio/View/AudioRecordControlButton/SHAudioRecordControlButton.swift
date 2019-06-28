//
//  SHAudioRecordControlButton.swift
//  Smart-Bus
//
//  Created by Apple on 2019/6/28.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHAudioRecordControlButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUi()
    }

    private func setUi() {

        contentHorizontalAlignment = .center
        titleLabel?.textAlignment = .left

        imageView?.contentMode = .scaleAspectFit

        imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    }

}
