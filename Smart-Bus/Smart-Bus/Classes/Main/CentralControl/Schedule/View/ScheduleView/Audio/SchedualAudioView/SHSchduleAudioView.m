//
//  SHSchduleAudioView.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/22.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchduleAudioView.h"
#import "SHSchedualAudioCell.h"


@interface SHSchduleAudioView () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
    
/// 所有的音乐
@property (nonatomic, strong) NSMutableArray *allAudios;

/// 所有音乐列表
@property (weak, nonatomic) IBOutlet UITableView *allAudioListView;
 

@end

@implementation SHSchduleAudioView


/// 保存数据
- (void)saveAudio:(NSNotification *)notification {
    
    SHSchdualControlItemType controlItemType = [notification.object integerValue];
    
    if (controlItemType == SHSchdualControlItemTypeAudio) {
        
        // 删除数据
        [[SHSQLManager shareSQLManager] deleteSchedualeCommand:self.schedual];
        
        for (SHAudio *audio in self.allAudios) {
            
            if (audio.schedualEnable) {
                
                SHSchedualCommand *command = [[SHSchedualCommand alloc] init];
                
                command.scheduleID = self.schedual.scheduleID;
                command.typeID = SHSchdualControlItemTypeAudio;
                
                command.parameter1 = audio.subnetID; // 子网ID
                command.parameter2 = audio.deviceID; // 设备ID
                
                // 音量
                command.parameter3 = audio.schedualVolumeRatio;
                
                /// ((状态 & 0xFF) << 8 ) | (来源 & 0xFF)
                command.parameter4 = ((audio.schedualPlayStatus & 0xFF) << 8) | (audio.schedualSourceType & 0xFF); // 播放状态
                
                //  (歌曲号 & 0xFF) << 8 | (专辑号 & 0xFF)
                command.parameter5 = ((audio.schedualAlbum.currentSelectSong.songNumber & 0xFF) << 8) | (audio.schedualAlbum.albumNumber & 0xFF);
                
                // 存入数据库
                [[SHSQLManager shareSQLManager] insertNewSchedualeCommand:command];
            }
        }
    }
}


/// 设置 schedual
- (void)setSchedual:(SHSchedual *)schedual {
    
    _schedual = schedual;
    
    if ((!self.allAudios.count && !schedual.isDifferentZoneSchedual) || schedual.isDifferentZoneSchedual) {
         
        self.allAudios = [[SHSQLManager shareSQLManager] getAudioForZone:schedual.zoneID];
        
        // 将schedual中的状态来进行设置
        NSMutableArray *schedualCommandforAudios = [[SHSQLManager shareSQLManager] getSchedualCommands:schedual.scheduleID];
        
        for (SHAudio *audio in self.allAudios) {
            
            for (SHSchedualCommand *command in schedualCommandforAudios) {
                
                if (command.typeID != SHSchdualControlItemTypeAudio) {
                    continue;
                }
                
                // 找到具体的设备
                if (audio.subnetID == command.parameter1 && audio.deviceID == command.parameter2) {
                    
                    audio.schedualEnable = YES;
                    audio.schedualVolumeRatio = command.parameter3;
                    audio.schedualSourceType = command.parameter4 & 0xFF;
                    audio.schedualPlayStatus = (command.parameter4 >> 8) & 0xFF;
                    
                    audio.schedualPlayAlbumNumber = (command.parameter5 >> 10) & 0xFF;
                    
                    audio.schedualPlaySongNumber = command.parameter5 - audio.schedualPlayAlbumNumber;
                    audio.schedualPlayAlbumNumber = command.parameter5 & 0xFF;
                    audio.schedualPlaySongNumber = command.parameter5 >> 8;
                }
            }
        }
    }
    
    [self.allAudioListView reloadData];
}

// MARK: - 数据源
    
/// 一共有多少个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allAudios.count;
}
    
/// 显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHSchedualAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHSchedualAudioCell class]) forIndexPath:indexPath];
    
    cell.schedualAudio = self.allAudios[indexPath.row];
    
    return cell;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];

    self.allAudioListView.rowHeight = [SHSchedualAudioCell rowHeightForSchedualAudioCell];
    
    // 注册
    [self.allAudioListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHSchedualAudioCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHSchedualAudioCell class])];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAudio:) name:SHSchedualSaveDataNotification object:nil];
    
}


/// Audio
+ (instancetype)schduleAudioView {
    
    return [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
