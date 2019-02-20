//
//  SHCurrentTransformerRealTimeDataViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/6.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// CT24 通道总数
private let currentTransformerCount: Int = 24

class SHCurrentTransformerRealTimeDataViewController: SHViewController {
    
    /// CT24
    var currentTransformer: SHCurrentTransformer?
    
    /// 总值
    private var totalValue: Int = 0
    
    /// 通道数组(横坐标)
    private lazy var channelArray: [String] = [
        "CH1",  "CH2",  "CH3",  "CH4",
        "CH5",  "CH6",  "CH7",  "CH8",
        "CH9",  "CH10", "CH11", "CH12",
        "CH13", "CH14", "CH15", "CH16",
        "CH17", "CH18", "CH19", "CH20",
        "CH21", "CH22", "CH23", "CH24"
    ]
    
    /// 功率
    private lazy var valueArray: [[CGFloat]] = {
        
        var array = [[CGFloat]]()
        
        for i in 0 ..< currentTransformerCount {
            
            var vaue: [CGFloat] = [0.0]
            array.append(vaue)
        }
        
        return array
    }()
    
    private lazy var column: JHColumnChart = {
        
        let chart = JHColumnChart(frame:
            CGRect(x: statusBarHeight * 0.5,
                   y: navigationBarHeight,
                   width: UIView.frame_screenWidth() - statusBarHeight,
                   height: UIView.frame_screenHeight() * 0.7
        ))
        
        chart.animationDuration = 0.5
        chart.drawFromOriginX = 5
        
        chart.originSize = CGPoint(x: 40, y: 40)
        
        chart.xDescTextFontSize = 16
        chart.yDescTextFontSize = 16
        
        chart.typeSpace = 20
        chart.columnWidth = 40
        
        chart.isShowYLine = false
        chart.isShowLineChart = true
        
        chart.drawTextColorForX_Y = UIColor.white
        chart.colorForXYLine = UIColor.darkGray
        chart.columnBGcolorsArr = [
            UIColor(white: 225.0/255.0, alpha: 1.0)
        ]
        
        chart.xShowInfoText = channelArray
        chart.valueArr = valueArray
        
        return chart
    }()
    
    /// 单位
    @IBOutlet weak var unitLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = currentTransformer?.remark
        
        view.addSubview(column)
        column.showAnimation()
        
        //    if ([UIDevice is_iPad]) {
        //        self.unitLabel.font = [UIView  suitFontForPad];
        //        self.unitLabel.textAlignment = NSTextAlignmentCenter;
        //    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readDevicestatus()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        column.frame =
            CGRect(x: statusBarHeight * 0.5,
                   y: navigationBarHeight,
                   width: UIView.frame_screenWidth() - statusBarHeight,
                   height: UIView.frame_screenHeight() * 0.7
        )
    }
}


// MARK: - 读取状态与解析
extension SHCurrentTransformerRealTimeDataViewController {
    
    /// 接收到广播
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        if socketData.operatorCode != 0x0151 ||
            socketData.subNetID != currentTransformer?.subnetID ||
            socketData.deviceID != currentTransformer?.deviceID {
            return
        }
        
        // ======= 解析数据
        totalValue = 0
        var isNeedReDraw = false
        
        for index in 0 ..< currentTransformerCount {
            
            // 每个通道号对应的两个字节的序号
            let highChannel = index * 2
            let lowChannel = index * 2 + 1
            
            // 实时电流的单位是 ma
            let currentValue =
                (
                    Int(socketData.additionalData[highChannel]) << 8) |
                    Int(socketData.additionalData[lowChannel]
            )
            
            // 功率W = 电压V X 电流A
            let powerVaue = CGFloat(currentValue) * (CGFloat(currentTransformer?.voltage ?? 1)) * 0.001
            
            // 总电流
            totalValue += currentValue
            
            // 先取出数组中的值
            let lastPowerValue = valueArray[index].last ?? 0.0
            
            if abs(powerVaue - lastPowerValue) > 0.01 {
                
                isNeedReDraw = true
                
                // 更新变化通道的值
                valueArray[index] = [powerVaue]
            }
            
            if isNeedReDraw {
                
                column.clear()
                column.valueArr = valueArray
                column.showAnimation()
            }
        }
    }
    
    
    /// 读取状态
    private func readDevicestatus() {
        
        SHSocketTools.sendData(
            operatorCode: 0x0150,
            subNetID: currentTransformer?.subnetID ?? 0,
            deviceID: currentTransformer?.deviceID ?? 0,
            additionalData: []
        )
    }
}
