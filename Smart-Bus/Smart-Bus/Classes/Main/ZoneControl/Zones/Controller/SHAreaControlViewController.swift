//
//  SHAreaControlViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/13.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHAreaControlViewController: SHTabBarController {
    
    /// 当前区域
    var currentZone: SHZone?
    
    /// 设备类型ID号
    private lazy var deviceTypeIDs = [UInt]()
    
    /// 设备类型图标名称
    private lazy var deviceTypeNames = [String]()
    
    /// 选项卡
    private lazy var tabBarScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = false
        
        return scrollView
    }()

    /// 上一次选中的按钮
    var preivousButton: SHZoneControlButton?
    
    /// 设置控器
    func setupViewController(_ zone: SHZone?) {
        
        currentZone = zone
        
        addChildViewControllers()
        setUpTabBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
}


// MARK: - 导航栏设置
extension SHAreaControlViewController {
    
    /// 设置区域
    @objc private func setArea() {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            
            return
        }
        
        guard let selectController = selectedViewController else {
            return
        }
        
        var deviceType = SHSystemDeviceType.undefined
        
        // 列表类
        if selectController.isKind(of: SHZoneDevicesViewController.self) {
         
            let devicesController =
                selectController as!
                SHZoneDevicesViewController
            
            switch devicesController.deviceType {
                
            case .hvac:
                deviceType = .hvac
                
            case .audio:
                deviceType = .audio
                
            case .floorHeating:
                deviceType = .floorHeating
                
            case .nineInOne:
                deviceType = .nineInOne
                
            case .tv:
                deviceType = .tv
                
            case .dvd:
                deviceType = .dvd
                
            case .sat:
                deviceType = .sat
                
            case .appletv:
                deviceType = .appletv
                
            case .projector:
                deviceType = .projector
                
            case .dmx:
                
                let dmxGroupSettingController =
                    SHZoneDmxGroupSettingViewController()
                
                dmxGroupSettingController.currentZone =
                    currentZone
                
                navigationController?.pushViewController(
                    dmxGroupSettingController,
                    animated: true
                )
                
                return; // dmx 的方式也不同
            
            default:
                break
            }
            
        } else if selectController.isKind(of: SHZoneMoodViewController.self) {
            
            let editMoodController =
                SHZoneControlEditMoodViewController()
            
            editMoodController.currentZone = self.currentZone
            
            navigationController?.pushViewController(
                editMoodController,
                animated: true
            )
            
            return; // Mood是不同的方式
            
        } else if selectController.isKind(of: SHZoneLightViewController.self) {
            
            deviceType = .light
        
        } else if selectController.isKind(of: SHZoneShadeViewController.self) {
            
            deviceType = .shade
        
        } else if selectController.isKind(of: SHZoneFanViewController.self) {
            
            deviceType = .fan
        
        } else if selectController.isKind(of: SHZoneDryContactViewController.self) {
            
            deviceType = .dryContact
        
        } else if selectController.isKind(of: SHZoneTemperatureSensorViewController.self) {
            
            deviceType = .temperatureSensor
       
        } else if selectController.isKind(of: SHSceneControlViewController.self) {
            
            deviceType = .sceneControl
        
        } else if selectController.isKind(of: SHSequenceControlViewController.self) {
            
            deviceType = .sequenceControl
        
        } else if selectController.isKind(of: SHOtherControlViewController.self) {
            
            deviceType = .otherControl
        }
        
        let detailConroller =
            SHSystemDetailViewController()
        
        detailConroller.systemType = deviceType
        
        detailConroller.currentZone = currentZone
        
        navigationController?.pushViewController(
            detailConroller,
            animated: true
        )
        
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        
        navigationItem.title = currentZone?.zoneName
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "setting",
                hightlightedImageName: "setting",
                addTarget: self,
                action: #selector(setArea),
                isLeft: false
        )
        
        let itemSize =
                UIDevice.is_iPad() ?
                (navigationBarHeight + statusBarHeight) :
                tabBarHeight
        
        let bounds =
            CGRect(x: 0,
                   y: 0,
                   width: itemSize,
                   height: itemSize
        )
        
        let leftItem =
            navigationItem.leftBarButtonItem?.customView
        
        let rightItem =
            navigationItem.rightBarButtonItem?.customView
        
        leftItem?.bounds = bounds
        rightItem?.bounds = bounds
    }
}


// MARK: - 子控制器 与 TabBar
extension SHAreaControlViewController {
    
    /// 设置tabBar
    private func setUpTabBar() {
        
        tabBar.backgroundImage =
            UIImage.resize("tabBarbackground")
        
        view.addSubview(tabBarScrollView)
        
        let count = children.count
        
        for i in 0 ..< count {
            
            let zoneControlButton = SHZoneControlButton()
            
            zoneControlButton.tag = i
            
            // 设置图片
            //  [zoneControlButton setBackgroundImage:[UIImage resizeImage:@"tabBarSelectedbackground"] forState:UIControlStateSelected];
            
            let normalImage =
                UIImage(named: deviceTypeNames[i] + "TabBar")
            
            zoneControlButton.setImage(normalImage,
                                       for: .normal
            )
            
            let selectedImage =
                UIImage(named: deviceTypeNames[i] +
                    "TabBar_highlighted"
            )
            
            zoneControlButton.setImage(selectedImage,
                                       for: .selected
            )
            
            // 获得按钮名称 -- 取消文字显示
            //        [zoneControlButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MAIN_PAGE" withSubTitle:self.systemNames[i]] forState:UIControlStateNormal];
            
            tabBarScrollView.addSubview(zoneControlButton)
            
            zoneControlButton.addTarget(
                self,
                action: #selector(changeViewController(_:)),
                for: .touchUpInside
            )
            
            if i == 0 { // 默认第一个是选中状态
                
                changeViewController(zoneControlButton)
            }
        }
    }
        
    /// 选择不同的控制器
    @objc private func changeViewController(_ button: SHZoneControlButton) {
        
        if button == preivousButton {
            
            return
        }
        
        button.isSelected = !button.isSelected
        
        preivousButton?.isSelected =
            !(preivousButton?.isSelected ?? false)
        
        preivousButton = button
        
        if button.isSelected {
            
            selectedIndex = button.tag
        }
        
    }

    
    /// 添加子控制器
    private func addChildViewControllers() {
        
       deviceTypeIDs =
            SHSQLiteManager.shared.getSystemIDs(
                self.currentZone?.zoneID ?? 0
            )
        
        if deviceTypeIDs.isEmpty {
            
            SVProgressHUD.showInfo(withStatus:
                SHLanguageText.noData
            )
            
            return
        }
        
        let count = deviceTypeIDs.count
        
        for index in 0 ..< count {
            
            switch deviceTypeIDs[index] {
                
                // light
            case SHSystemDeviceType.light.rawValue:
                
                deviceTypeNames.append("alight")
                
                let lightController =
                    SHZoneLightViewController()
                
                lightController.currentZone = currentZone
                
                addChild(lightController)
                
                // hvac
            case SHSystemDeviceType.hvac.rawValue:
                
                deviceTypeNames.append("bhvac")
                
                let hvacController =
                    SHZoneDevicesViewController()
                
                hvacController.deviceType = .hvac
                
                hvacController.currentZone = currentZone
                
                addChild(hvacController)
                
            // audio
            case SHSystemDeviceType.audio.rawValue:
                
                deviceTypeNames.append("czaudio")
                
                let audioController =
                    SHZoneDevicesViewController()
                
                audioController.deviceType = .audio
                
                audioController.currentZone = currentZone
                
                addChild(audioController)
                
            // shade
            case SHSystemDeviceType.shade.rawValue:
                
                deviceTypeNames.append("dshades")
                
                let shadeController =
                    SHZoneShadeViewController()
                
                shadeController.currentZone = currentZone
                
                addChild(shadeController)
                
                // tv
            case SHSystemDeviceType.tv.rawValue:
                
                deviceTypeNames.append("etv")
                
                let tvController =
                    SHZoneDevicesViewController()
                
                tvController.deviceType = .tv
                
                tvController.currentZone = currentZone
                
                addChild(tvController)
                
            // sat
            case SHSystemDeviceType.sat.rawValue:
                
                deviceTypeNames.append("esat")
                
                let satController =
                    SHZoneDevicesViewController()
                
                satController.deviceType = .sat
                
                satController.currentZone = currentZone
                
                addChild(satController)
                
            // dvd
            case SHSystemDeviceType.dvd.rawValue:
                
                deviceTypeNames.append("edvd")
                
                let dvdController =
                    SHZoneDevicesViewController()
                
                dvdController.deviceType = .dvd
                
                dvdController.currentZone = currentZone
                
                addChild(dvdController)
                
            // appleTV
            case SHSystemDeviceType.appletv.rawValue:
                
                deviceTypeNames.append("eappletv")
                
                let appleTVController =
                    SHZoneDevicesViewController()
                
                appleTVController.deviceType = .appletv
                
                appleTVController.currentZone = currentZone
                
                addChild(appleTVController)
                
            // projector
            case SHSystemDeviceType.projector.rawValue:
                
                deviceTypeNames.append("eprojector")
                
                let projectorController =
                    SHZoneDevicesViewController()
                
                projectorController.deviceType = .projector
                
                projectorController.currentZone = currentZone
                
                addChild(projectorController)
                
            // mood
            case SHSystemDeviceType.mood.rawValue:
                
                deviceTypeNames.append("fmoods")
                
                let moodController =
                    SHZoneMoodViewController()
                
                moodController.currentZone = currentZone
                
                addChild(moodController)
                
            // fan
            case SHSystemDeviceType.fan.rawValue:
                
                deviceTypeNames.append("gfan")
                
                let fanController =
                    SHZoneFanViewController()
                
                fanController.currentZone = currentZone
                
                addChild(fanController)
                
            // floorHeating
            case SHSystemDeviceType.floorHeating.rawValue:
                
                deviceTypeNames.append("hFloorheating")
                
                let floorHeatingController =
                    SHZoneDevicesViewController()
                
                floorHeatingController.deviceType
                    = .floorHeating
                
                floorHeatingController.currentZone = currentZone
                
                addChild(floorHeatingController)
                
            // nineInOne
            case SHSystemDeviceType.nineInOne.rawValue:
                
                deviceTypeNames.append("jnieInOne")
                
                let nineInOneController =
                    SHZoneDevicesViewController()
                
                nineInOneController.deviceType
                    = .nineInOne
                
                nineInOneController.currentZone = currentZone
                
                addChild(nineInOneController)
                
                // 4Z/24Z
            case SHSystemDeviceType.dryContact.rawValue:
                
                deviceTypeNames.append("kdryInput")
                
                let nodeController =
                    SHZoneDryContactViewController()
                
                nodeController.currentZone = currentZone
                
                addChild(nodeController)
                
            // 4T
            case SHSystemDeviceType.temperatureSensor.rawValue:
                
                deviceTypeNames.append("ltemperature")
                
                let temperatureController =
                    SHZoneTemperatureSensorViewController()
                
                temperatureController.currentZone = currentZone
                
                addChild(temperatureController)
                
            // dmx
            case SHSystemDeviceType.dmx.rawValue:
                
                deviceTypeNames.append("mdmx")
                
                let dmxController =
                    SHZoneDevicesViewController()
                
                dmxController.deviceType = .dmx
                
                dmxController.currentZone = currentZone
                
                addChild(dmxController)
                
            // Scene
            case SHSystemDeviceType.sceneControl.rawValue:
                
                deviceTypeNames.append("nscene")
                
                let sceneController =
                    SHSceneControlViewController()
                
                sceneController.currentZone = currentZone
                
                addChild(sceneController)
                
            // Sequence
            case SHSystemDeviceType.sequenceControl.rawValue:
                
                deviceTypeNames.append("psequence")
                
                let sequenceController =
                    SHSequenceControlViewController()
                
                sequenceController.currentZone = currentZone
                
                addChild(sequenceController)
                
            // otherControl
            case SHSystemDeviceType.otherControl.rawValue:
                
                deviceTypeNames.append("qother")
                
                let otherController =
                    SHOtherControlViewController()
                
                otherController.currentZone = currentZone
                
                addChild(otherController)
                
            default:
                break
            }
        }
    }
}

// MARK: - 布局
extension SHAreaControlViewController {
    
    /// 布局子控件
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBarScrollView.frame = tabBar.frame
        
        let itemHeight = tabBarHeight
        let itemWidth = tabBar.frame_width * 0.25 // (1/4)
        
        let startX =
            (tabBar.frame_width -
                CGFloat(children.count > 4 ? 4 : children.count) * itemWidth
                ) * 0.5
        
        let count = tabBarScrollView.subviews.count
        
        for i in 0 ..< count {
            
            let button = tabBarScrollView.subviews[i]
            
            button.frame =
                CGRect(x: CGFloat(button.tag) * itemWidth
                    + startX,
                       y: 0,
                       width: itemWidth,
                       height: itemHeight
            )
        }
        
        tabBarScrollView.contentSize =
            CGSize(width: itemWidth * CGFloat(children.count),
                   height: itemHeight
        )
    }
}
