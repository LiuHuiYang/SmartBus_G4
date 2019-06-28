//
//  SHMoodShadeStatusButton.swift
//  Smart-Bus
//
//  Created by Apple on 2019/6/28.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHMoodShadeStatusButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super .awakeFromNib()
        
        setUI()
    }

    
    private func setUI() {
        
        imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 文字大小
        guard let titleSize =
            titleLabel?.text?.boundingRect(
                with: bounds.size,
                options: .usesLineFragmentOrigin,
                attributes: [
                    NSAttributedString.Key.font:
                        titleLabel?.font as Any
                ],
                context: nil
                ).size else {
                    
              return
        }
        
        // 文字
        titleLabel?.frame_y = 0
        titleLabel?.frame_height = titleSize.height
        
        titleLabel?.frame_width = titleSize.width
        titleLabel?.preferredMaxLayoutWidth = titleSize.width
        titleLabel?.frame_x =
            (frame_width - titleSize.width) * 0.5
        
        
        // 图片
        imageView?.frame_x =
            (titleLabel?.frame_x ?? 0) +
            (titleLabel?.frame_width ?? 0)
        
        imageView?.frame_width =
            CGFloat.minimum(
                frame_width - (imageView?.frame_x ?? 0),
                titleSize.height
        )
        
        imageView?.frame_height = imageView?.frame_width ?? 0
        
        imageView?.frame_y =
            (frame_height - (imageView?.frame_height ?? 0)) * 0.5
    }
}
