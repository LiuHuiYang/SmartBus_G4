//
//  SHSystemDetailViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/15.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import "SHSystemDetailViewController.h"

static NSString *deviceGroupSettingCellReuseIdentifier = @"SHZoneDeviceGroupSettingCell";

@interface SHSystemDetailViewController () <UITableViewDelegate, UITableViewDataSource>

/// 同一类型的所有设备
@property (nonatomic, strong) NSMutableArray *allSameTypeDevices;

/// 所有同类型设备列表
@property (weak, nonatomic) IBOutlet UITableView *allDevicesListView;


@end

@implementation SHSystemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Devices Setting";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"addDevice_navigationbar" hightlightedImageName:@"addDevice_navigationbar" addTarget:self action:@selector(addNewDevices) isLeft:NO];
    
    self.allDevicesListView.rowHeight = [SHZoneDeviceGroupSettingCell rowHeight];
    
    [self.allDevicesListView registerNib:[UINib nibWithNibName:deviceGroupSettingCellReuseIdentifier bundle:nil] forCellReuseIdentifier:deviceGroupSettingCellReuseIdentifier];
}

/// 添中新的设备
- (void)addNewDevices {

    SHDeviceArgsViewController *detailController =
        [[SHDeviceArgsViewController alloc] init];
    
    switch (self.systemType) {
            
        case SHSystemDeviceTypeLight: {
            
            SHLight *light = [[SHLight alloc] init];
            
            light.lightRemark = @"light";
            light.zoneID = self.zone.zoneID;
            light.lightID = [[SHSQLManager shareSQLManager] getMaxLightIDForZone:light.zoneID] + 1;
            
            [[SHSQLManager shareSQLManager] insertNewLight:light];
            
            detailController.light = light;
        }
            break;
            
        case SHSystemDeviceTypeHvac: {
            
            SHHVAC *hvac = [[SHHVAC alloc] init];
            
            hvac.acRemark = @"hvac";
            hvac.zoneID = self.zone.zoneID;
           
            hvac.id = [[SHSQLManager shareSQLManager] insertNewHVAC: hvac];
            
            detailController.hvac = hvac;
        }
            break;
            
        case SHSystemDeviceTypeAudio: {
            
            SHAudio *audio = [[SHAudio alloc] init];
             
            audio.zoneID = self.zone.zoneID;
            audio.havePhone = 0;
            audio.haveSdCard = 1;
            audio.haveFtp = 1;
            audio.haveRadio = 1;
            audio.haveAudioIn= 1;
            audio.audioName = [NSString stringWithFormat:@"%@ Audio", self.zone.zoneName];
            
            audio.id = [[SHSQLManager shareSQLManager] insertNewAudio:audio];
            
            detailController.audio = audio;
        }
            break;
            
        case SHSystemDeviceTypeShade: {
            
            SHShade *shade = [[SHShade alloc] init];
            shade.shadeName = @"shade";
            shade.zoneID = self.zone.zoneID;
            shade.shadeID = [[SHSQLManager shareSQLManager] getMaxShadeIDForZone:shade.zoneID] + 1;
            
            shade.remarkForStop = @"";
            shade.remarkForClose = @"";
            shade.remarkForOpen = @"";
            
            [[SHSQLManager shareSQLManager] insertNewShade:shade];
            
            detailController.shade = shade;
        }
            break;
            
        case SHSystemDeviceTypeMood: {
            
        }
            break;
            
        case SHSystemDeviceTypeTv: {
            
            SHMediaTV* tv = [[SHMediaTV alloc] init];
            tv.remark = @"TV";
            tv.zoneID = self.zone.zoneID;
            
            tv.id = [[SHSQLManager shareSQLManager] inserNewMediaTV:tv];
            
           detailController.mediaTV = tv;
        }
            break;
            
        case SHSystemDeviceTypeDvd: {
            
            SHMediaDVD* dvd = [[SHMediaDVD alloc] init];
            dvd.remark = @"DVD";
            dvd.zoneID = self.zone.zoneID;
            
            dvd.id = [[SHSQLManager shareSQLManager] inserNewMediaDVD:dvd];
            
            detailController.mediaDVD = dvd;
        }
            break;
            
        case SHSystemDeviceTypeSat: {  // 卫星电视
            
            SHMediaSAT *sat = [[SHMediaSAT alloc] init];
            
            sat.remark = @"SATELLITE TV";
            sat.switchNameforControl1 = @"C1";
            sat.switchNameforControl2 = @"C2";
            sat.switchNameforControl3 = @"C3";
            sat.switchNameforControl4 = @"C4";
            sat.switchNameforControl5 = @"C5";
            sat.switchNameforControl6 = @"C6";
            
            sat.zoneID = self.zone.zoneID;
            
            sat.id = [[SHSQLManager shareSQLManager] insertNewMediaSAT:sat];
            
            detailController.mediaSAT = sat;
        }
            break;
            
        case SHSystemDeviceTypeAppletv: {
            
            SHMediaAppleTV *appleTV = [[SHMediaAppleTV alloc] init];
            appleTV.remark = @"APPLE TV";
            appleTV.zoneID = self.zone.zoneID;
            
            appleTV.id = [[SHSQLManager shareSQLManager] insertNewMediaAppleTV:appleTV];
            
            detailController.mediaAppleTV = appleTV;
        }
            break;
            
        case SHSystemDeviceTypeProjector:{
            
            SHMediaProjector *projector = [[SHMediaProjector alloc] init];
            projector.remark = @"PROJECTOR";
            projector.zoneID = self.zone.zoneID;
            
            projector.id = [[SHSQLManager shareSQLManager] insertNewMediaProjector:projector];
            
            detailController.mediaProjector = projector;
        }
            break;
            
        case SHSystemDeviceTypeFan : {
            
            SHFan *fan = [[SHFan alloc] init];
            fan.fanName = @"fan";
            fan.zoneID = self.zone.zoneID;
            fan.fanID = [[SHSQLManager shareSQLManager] getMaxFanIDForZone:fan.zoneID] + 1;
            
            [[SHSQLManager shareSQLManager] insertNewFan:fan];
            
            detailController.fan = fan;
        }
            break;
            
        case SHSystemDeviceTypeFloorHeating: {
            
            SHFloorHeating *floorHeating = [[SHFloorHeating alloc] init];
            floorHeating.floorHeatingRemark = @"floorHeating";
            floorHeating.zoneID = self.zone.zoneID;
            floorHeating.floorHeatingID = [[SHSQLManager shareSQLManager] getMaxFloorHeatingIDForZone:floorHeating.zoneID] + 1;
            
            [[SHSQLManager shareSQLManager] insertNewFloorHeating:floorHeating];
            
            detailController.floorHeating = floorHeating;
        }
            break;
            
        case SHSystemDeviceTypeNineInOne: {
            
            SHNineInOne *nineInOne = [[SHNineInOne alloc] init];
            
            nineInOne.nineInOneName = @"9in1";
            nineInOne.zoneID = self.zone.zoneID;
            nineInOne.nineInOneID = [[SHSQLManager shareSQLManager] getMaxNineInOneIDForZone:nineInOne.zoneID] + 1;
            
            nineInOne.switchNameforControl1 = @"C1";
            nineInOne.switchNameforControl2 = @"C2";
            nineInOne.switchNameforControl3 = @"C3";
            nineInOne.switchNameforControl4 = @"C4";
            nineInOne.switchNameforControl5 = @"C5";
            nineInOne.switchNameforControl6 = @"C6";
            nineInOne.switchNameforControl7 = @"C7";
            nineInOne.switchNameforControl8 = @"C8";
            
            nineInOne.switchNameforSpare1 = @"Spare_1";
            nineInOne.switchNameforSpare2 = @"Spare_2";
            nineInOne.switchNameforSpare3 = @"Spare_3";
            nineInOne.switchNameforSpare4 = @"Spare_4";
            nineInOne.switchNameforSpare5 = @"Spare_5";
            nineInOne.switchNameforSpare6 = @"Spare_6";
            nineInOne.switchNameforSpare7 = @"Spare_7";
            nineInOne.switchNameforSpare8 = @"Spare_8";
            nineInOne.switchNameforSpare9 = @"Spare_9";
            nineInOne.switchNameforSpare10 = @"Spare_10";
            nineInOne.switchNameforSpare11 = @"Spare_11";
            nineInOne.switchNameforSpare12 = @"Spare_12";
             
            [[SHSQLManager shareSQLManager] insertNewNineInOne:nineInOne];
            
            detailController.nineInOne = nineInOne;
        }
            break;
            
        case SHSystemDeviceTypeDryContact: {
        
            SHDryContact *dryContact = [[SHDryContact alloc] init];
            dryContact.remark = @"dry contact";
            dryContact.zoneID = self.zone.zoneID;
            
            dryContact.contactID = [[SHSQLManager shareSQLManager] getMaxDryContactIDForZone:dryContact.zoneID] + 1;
            
            [[SHSQLManager shareSQLManager] insertNewDryContact:dryContact];
            
            detailController.dryContact = dryContact;
        }
            break;
            
        case SHSystemDeviceTypeTemperatureSensor: {
            
            SHTemperatureSensor *temperatureSensor = [[SHTemperatureSensor alloc] init];
            
            temperatureSensor.remark = @"temperature sensor";
            
            temperatureSensor.zoneID = self.zone.zoneID;
            
            temperatureSensor.temperatureID = [[SHSQLManager shareSQLManager] getMaxTemperatureTemperatureIDForZone:temperatureSensor.zoneID] + 1;
            
            [[SHSQLManager shareSQLManager] insertNewTemperatureSensor:temperatureSensor];
            
            detailController.temperatureSensor = temperatureSensor;
        }
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:detailController
                                         animated:YES
    ];
}

/// 实时刷新
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self searchDevices];
    
    if (!self.allSameTypeDevices.count) {
        
        [SVProgressHUD showInfoWithStatus:SHLanguageText.noData];
    }
    
    [self.allDevicesListView reloadData];
}

/// 查询列表
- (void)searchDevices {
    
    switch (self.systemType) {
            
        case SHSystemDeviceTypeLight: {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getLightForZone:self.zone.zoneID];
            
        }
            break;
            
        case SHSystemDeviceTypeHvac: {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getHVACForZone:self.zone.zoneID];
        }
            break;
            
        case SHSystemDeviceTypeAudio: {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager ] getAudioForZone:self.zone.zoneID];
        }
            break;
            
        case SHSystemDeviceTypeShade: {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getShadeForZone:self.zone.zoneID];
        }
            break;
        
        case SHSystemDeviceTypeMood: {
            
        }
            break;
            
        case SHSystemDeviceTypeTv: {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getMediaTVFor:self.zone.zoneID];
        }
            break;
            
        case SHSystemDeviceTypeDvd: {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getMediaDVDFor:self.zone.zoneID];
        }
            break;
            
        case SHSystemDeviceTypeSat: {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getMediaSATFor:self.zone.zoneID];
        }
            break;
            
        case SHSystemDeviceTypeAppletv: {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getMediaAppleTVFor:self.zone.zoneID];
        }
            break;
            
        case SHSystemDeviceTypeProjector:{
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getMediaProjectorFor:self.zone.zoneID];
        }
            break;
            
        case SHSystemDeviceTypeFan : {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getFanForZone:self.zone.zoneID];
        }
            break;
            
        case SHSystemDeviceTypeFloorHeating: {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getFloorHeatingForZone:self.zone.zoneID];
        }
            break;
            
        case SHSystemDeviceTypeNineInOne: {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getNineInOneForZone:self.zone.zoneID];
        }
            break;
            
        case SHSystemDeviceTypeDryContact: {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getDryContactForZone:self.zone.zoneID];
        }
            break;
            
        case SHSystemDeviceTypeTemperatureSensor: {
            
            self.allSameTypeDevices = [[SHSQLManager shareSQLManager] getTemperatureSensorForZone:self.zone.zoneID];
        }
            break;
            
        default:
            break;
    }
}

// MARK: - tableView代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self updateDevicesArgs:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/// 左滑多操作
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // 删除操作
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:[NSString stringWithFormat:@"\t%@\t", SHLanguageText.delete] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        switch (self.systemType) {
                
            case SHSystemDeviceTypeLight: {
                
                SHLight *light = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteLightInZone:light]) {
                    
                    [self.allSameTypeDevices removeObject:light];
                }
            }
                break;
                
            case SHSystemDeviceTypeHvac: {
                
                SHHVAC *hvac = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteHVACInZone:hvac]) {
                    
                    [self.allSameTypeDevices removeObject:hvac];
                }
            }
                break;
                
            case SHSystemDeviceTypeAudio: {
                
                SHAudio *audio = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteAudioInZone:audio]) {
                    
                    [self.allSameTypeDevices removeObject:audio];
                }
            }
                break;
                
            case SHSystemDeviceTypeShade: {
                
                SHShade *shade = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteShadeInZone:shade]) {
                    
                    [self.allSameTypeDevices removeObject:shade];
                }
            }
                break;
                
            case SHSystemDeviceTypeTv: {
                
                SHMediaTV *mediaTV = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteTVInZone:mediaTV]) {
                    
                    [self.allSameTypeDevices removeObject:mediaTV];
                }
            }
                break;
                
            case SHSystemDeviceTypeDvd: {
                
                SHMediaDVD *mediaDVD = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteDVDInZone:mediaDVD]) {
                    
                    [self.allSameTypeDevices removeObject:mediaDVD];
                }
            }
                break;
                
            case SHSystemDeviceTypeSat: {
                
                SHMediaSAT *mediaSAT = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteSATInZone:mediaSAT]) {
                    
                    [self.allSameTypeDevices removeObject:mediaSAT];
                }
            }
                break;
                
            case SHSystemDeviceTypeAppletv: {
                
                SHMediaAppleTV *mediaAppleTV = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteAppleTVInZone:mediaAppleTV]) {
                    
                    [self.allSameTypeDevices removeObject:mediaAppleTV];
                }
            }
                break;
                
            case SHSystemDeviceTypeProjector: {
                
                SHMediaProjector *mediaProjector = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteProjectorInZone:mediaProjector]) {
                    
                    [self.allSameTypeDevices removeObject:mediaProjector];
                }
            }
                break;
                
            case SHSystemDeviceTypeFan: {
                
                SHFan *fan = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteFanInZone:fan]) {
                    [self.allSameTypeDevices removeObject:fan];
                }
            }
                break;
                
            case SHSystemDeviceTypeFloorHeating: {
                
                SHFloorHeating *foorHeating = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteFloorHeatingInZone:foorHeating]) {
                    
                    [self.allSameTypeDevices removeObject:foorHeating];
                }
            }
                break;
                
            case SHSystemDeviceTypeNineInOne: {
                
                SHNineInOne *nineInOne = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteNineInOneInZone:nineInOne]) {
                    
                    [self.allSameTypeDevices removeObject:nineInOne];
                }
            }
                break;
                
            case SHSystemDeviceTypeDryContact: {
                
                SHDryContact *dryContact = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteDryContactInZone:dryContact]) {
                    
                    [self.allSameTypeDevices removeObject:dryContact];
                }
            }
                break;
                
            case SHSystemDeviceTypeTemperatureSensor: {
                
                SHTemperatureSensor *temperatureSensor = self.allSameTypeDevices[indexPath.row];
                
                if ([[SHSQLManager shareSQLManager] deleteTemperatureSensorInZone:temperatureSensor]) {
                    
                    [self.allSameTypeDevices removeObject:temperatureSensor];
                }
            }
                break;
                
            default:
                break;
        }
        
        [tableView reloadData];
        
    }];
     
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:[NSString stringWithFormat:@"\t%@\t", SHLanguageText.edit] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        [self updateDevicesArgs:indexPath];
        
    }];
    
    return @[deleteAction, editAction];
}

/// 更新参数
- (void)updateDevicesArgs:(NSIndexPath *)indexPath {
    
    SHDeviceArgsViewController *detailController = [[SHDeviceArgsViewController alloc] init];
    
    switch (self.systemType) {
            
        case SHSystemDeviceTypeLight: {
            
            SHLight *light = self.allSameTypeDevices[indexPath.row];
            detailController.light = light;
        }
            break;
            
        case SHSystemDeviceTypeHvac: {
            SHHVAC *hvac = self.allSameTypeDevices[indexPath.row];
            detailController.hvac = hvac;
        }
            break;
            
        case SHSystemDeviceTypeAudio: {
            SHAudio *audio = self.allSameTypeDevices[indexPath.row];
           
            detailController.audio = audio;
        }
            break;
            
        case SHSystemDeviceTypeShade: {
            
            SHShade *shade = self.allSameTypeDevices[indexPath.row];
            
            detailController.shade = shade;
        }
            break;
            
        case SHSystemDeviceTypeTv: {
            
            SHMediaTV *mediaTV = self.allSameTypeDevices[indexPath.row];
            
            detailController.mediaTV = mediaTV;
        }
            break;
            
        case SHSystemDeviceTypeDvd: {
            
            SHMediaDVD *mediaDVD = self.allSameTypeDevices[indexPath.row];
            
            detailController.mediaDVD = mediaDVD;
        }
            break;
            
        case SHSystemDeviceTypeSat: {
            
            SHMediaSAT *mediaSAT = self.allSameTypeDevices[indexPath.row];
            
            detailController.mediaSAT = mediaSAT;
        }
            break;
            
        case SHSystemDeviceTypeAppletv: {
            
            SHMediaAppleTV *mediaAppleTV = self.allSameTypeDevices[indexPath.row];
             
            
            detailController.mediaAppleTV = mediaAppleTV;
        }
            break;
            
        case SHSystemDeviceTypeProjector: {
            
            SHMediaProjector *mediaProjector = self.allSameTypeDevices[indexPath.row];
             
            
            detailController.mediaProjector = mediaProjector;
        }
            break;
            
        case SHSystemDeviceTypeFan: {
            
            SHFan *fan = self.allSameTypeDevices[indexPath.row];
            
            detailController.fan = fan;
        }
            break;
            
        case SHSystemDeviceTypeFloorHeating: {
            
            SHFloorHeating *floorHeating = self.allSameTypeDevices[indexPath.row];
            detailController.floorHeating = floorHeating;
        }
            break;
            
        case SHSystemDeviceTypeNineInOne: {
            
            SHNineInOne *nineInOne = self.allSameTypeDevices[indexPath.row];
            
            detailController.nineInOne = nineInOne;
        }
            break;
            
        case SHSystemDeviceTypeDryContact: {
            
            SHDryContact *dryContact = self.allSameTypeDevices[indexPath.row];
            detailController.dryContact = dryContact;
        }
            break;
            
        case SHSystemDeviceTypeTemperatureSensor: {
            
            SHTemperatureSensor *temperatureSensor = self.allSameTypeDevices[indexPath.row];
            
            detailController.temperatureSensor = temperatureSensor;
        }
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:detailController
                                         animated:YES
    ];
}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allSameTypeDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHZoneDeviceGroupSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:deviceGroupSettingCellReuseIdentifier forIndexPath:indexPath];
    
    NSString *deviceName = @"";
    
    switch (self.systemType) {
            
        case SHSystemDeviceTypeLight:  {
            
            SHLight *light = self.allSameTypeDevices[indexPath.row];
            
            deviceName =
                [NSString stringWithFormat:@"%tu - %@ : %d - %d %@",
                    light.lightID, light.lightRemark,
                    light.subnetID, light.deviceID,
                 (light.lightTypeID == SHZoneControlLightTypeLed ? @"" : [NSString stringWithFormat:@"- %d", light.channelNo])];
        }
            break;
            
        case SHSystemDeviceTypeHvac:  {
            
            SHHVAC *ac = self.allSameTypeDevices[indexPath.row];
            
            deviceName = [NSString stringWithFormat:@"%@ : %d - %d",
                          ac.acRemark, ac.subnetID, ac.deviceID];
        }
            break;
            
        case SHSystemDeviceTypeAudio: {
            
            SHAudio *audio = self.allSameTypeDevices[indexPath.row];
            
            deviceName = [NSString stringWithFormat:@"%@ : %d - %d",
                          audio.audioName, audio.subnetID, audio.deviceID];
        }
            break;
            
        case SHSystemDeviceTypeShade: {
            
            SHShade *shade = self.allSameTypeDevices[indexPath.row];
            
            deviceName =
                [NSString stringWithFormat:@"%tu - %@ : %d - %d",
                    shade.shadeID, shade.shadeName,
                    shade.subnetID, shade.deviceID];
        }
            break;
            
        case SHSystemDeviceTypeTv: {
            
            SHMediaTV *mediaTV = self.allSameTypeDevices[indexPath.row];
            
            deviceName = [NSString stringWithFormat:@"%@ : %d - %d",
                          mediaTV.remark, mediaTV.subnetID, mediaTV.deviceID];
        }
            break;
            
        case SHSystemDeviceTypeDvd: {
            
            SHMediaDVD *mediaDVD = self.allSameTypeDevices[indexPath.row];
            
            deviceName = [NSString stringWithFormat:@"%@ : %d - %d", mediaDVD.remark, mediaDVD.subnetID, mediaDVD.deviceID];
        }
            break;
            
        case SHSystemDeviceTypeSat: {
            
            SHMediaSAT *mediaSAT = self.allSameTypeDevices[indexPath.row];
            deviceName = [NSString stringWithFormat:@"%@ : %d - %d", mediaSAT.remark,  mediaSAT.subnetID,  mediaSAT.deviceID];
        }
            break;
            
        case SHSystemDeviceTypeAppletv: {
            
            SHMediaAppleTV *mediaAppleTV = self.allSameTypeDevices[indexPath.row];
            deviceName = [NSString stringWithFormat:@"%@ : %d - %d", mediaAppleTV.remark, mediaAppleTV.subnetID, mediaAppleTV.deviceID];
        }
            break;
            
        case SHSystemDeviceTypeProjector: {
            
            SHMediaProjector *mediaProjector = self.allSameTypeDevices[indexPath.row];
            deviceName = [NSString stringWithFormat:@"%@ : %d - %d",
                          mediaProjector.remark, mediaProjector.subnetID, mediaProjector.deviceID];
        }
            break;
            
        case SHSystemDeviceTypeFan: {
            
            SHFan *fan = self.allSameTypeDevices[indexPath.row];
            deviceName = [NSString stringWithFormat:
                            @"%@ - %@ : %d - %d - %d",
                            @(fan.fanID), fan.fanName, fan.subnetID,
                            fan.deviceID, fan.channelNO
                        ];
        }
            break;
            
        case SHSystemDeviceTypeFloorHeating:  {
            
            SHFloorHeating *floorHeating = self.allSameTypeDevices[indexPath.row];
            
            deviceName = [NSString stringWithFormat:@"%@ - %@ : %d - %d - %d",
                          @(floorHeating.floorHeatingID),
                          floorHeating.floorHeatingRemark,
                          floorHeating.subnetID,
                          floorHeating.deviceID,
                          floorHeating.channelNo
                        ];
        }
            break;
            
        case SHSystemDeviceTypeNineInOne: {
            
            SHNineInOne *nineInOne = self.allSameTypeDevices[indexPath.row];
            
            deviceName = [NSString stringWithFormat:@"%@ - %@ : %d - %d",
                            @(nineInOne.nineInOneID), nineInOne.nineInOneName,
                            nineInOne.subnetID, nineInOne.deviceID
                         ];
        }
            break;
            
        case SHSystemDeviceTypeDryContact: { 
            
            SHDryContact *dryContact = self.allSameTypeDevices[indexPath.row];
            
            deviceName = [NSString stringWithFormat:@"%@ - %@ : %d - %d - %d",
                          @(dryContact.contactID), dryContact.remark,
                          dryContact.subnetID, dryContact.deviceID,
                          dryContact.channelNo
                         ];
        }
            break;
            
        case SHSystemDeviceTypeTemperatureSensor: {
        
            SHTemperatureSensor *temperatureSensor = self.allSameTypeDevices[indexPath.row];
            
            deviceName = [NSString stringWithFormat:@"%tu - %@ : %d - %d - %d", temperatureSensor.temperatureID, temperatureSensor.remark, temperatureSensor.subnetID, temperatureSensor.deviceID, temperatureSensor.channelNo];
        }
            break;
            
        default:
            break;
    }
    
    cell.deviceName = deviceName;
    
    return cell;
}

// MARK: - getter && setter

/// 所有的设备
- (NSMutableArray *)allSameTypeDevices {
    
    if (!_allSameTypeDevices) {
        _allSameTypeDevices = [NSMutableArray array];
    }
    return _allSameTypeDevices;
}

@end
