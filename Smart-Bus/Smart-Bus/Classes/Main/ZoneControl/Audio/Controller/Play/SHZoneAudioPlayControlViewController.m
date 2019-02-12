//
//  SHZoneAudioPlayControlViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/17.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHZoneAudioPlayControlViewController.h"

#import "SHAudioSourceButton.h"
#import "SHAudioSelectButton.h"
#import "SHAuioPlayTypeButton.h"

/// 专辑重用标示符
static NSString *albumCellReusableIdentifier = @"SHAudioAlbumCell";

/// 歌曲重用标示符
static NSString *songCellReusableIdentifier = @"SHAudioAlbumSongCell";

@interface SHZoneAudioPlayControlViewController () <UIScrollViewDelegate,
UITableViewDelegate, UITableViewDataSource>

/// 音乐来源的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint
*sourceTypeHeightConstraint;

/// 音乐播放控制高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint
*playControlViewHeightConstraint;

/// 整个音乐控制界面最底部的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;

/// 成功执行
@property (assign, nonatomic) BOOL isUpdateFtpSuccess;

/// 取消发送请求数据
@property (assign, nonatomic) BOOL cancelSendData;

/// 拼接歌曲时的错误码值(最后一步拼接字符串时使用, 必须是有符号的数据)
@property (nonatomic, assign) NSInteger errorSongNameNumber;

/// 当前请求的第几个列表 专辑
@property (assign, nonatomic) NSUInteger currentCategoryNumber;

/// 当前第几个包
@property (assign, nonatomic) NSUInteger currentPackageNumber;

/// 总共包的数量
@property (assign, nonatomic) NSUInteger totalPackages;

/// 接收数据的状态
@property (assign, nonatomic) SHAudioReceivedStatusType receivedStatusType;

/// 重发次数 - 最多3次
@property (nonatomic, assign) Byte reSendCount;

/// 是否接收到需要的音乐广播数据
@property (assign, nonatomic) BOOL isReceivedAudioData;

/// 接收到的拼接字符串【注意: 如果接收失败一定要清空】
@property (nonatomic, copy) NSMutableString *recivedStringList;

// MARK: - ============ 音乐设备相关的属性 ==========

// MARK: - 播放控制的标记属性

/// 当前是显示在队列界面上
@property (nonatomic, assign) BOOL isQueue;

/// 当前播放队列的哪一行
@property (nonatomic, assign) NSInteger indexQueue;

/// 当前正在播放的队列音乐
@property (nonatomic, assign) BOOL isQueuePlay;

/// 播放次数
@property (nonatomic, assign) Byte queueCount;

/// 选择的队列音乐(只在内存中有效)
@property (nonatomic, strong) NSMutableArray *selectQueueSongs;

// MARK: - ============ UI界面上的属性 ============

// MARK: - 顶部

/// 音乐来源背景视图
@property (weak, nonatomic) IBOutlet UIView *audioSourceView;

/// 音乐来源显示滚动视图
@property (weak, nonatomic) UIScrollView *sourceTypeScrollView;

// MARK: - 中间部分

/// 中间大背景音乐显示视图
@property (weak, nonatomic) IBOutlet UIView *audioSongsShowView;

/// 中间整体的滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *listScrollView;

/// 中间左侧占位视图
@property (weak, nonatomic) IBOutlet UIView *leftListHolderView;

/// 区域按钮
@property (weak, nonatomic) UIButton *zoneRefreshButton;

/// 选择专辑按钮
@property (weak, nonatomic) SHAudioSelectButton *selectAlbumButton;

/// 增加到队列按钮
@property (weak, nonatomic) UIButton *addToQueButton;

/// 左列表视图
@property (weak, nonatomic) UIImageView *leftListImageView;

/// 中间左图歌曲列表视图
@property (weak, nonatomic) UITableView *currentAlbumSongsListTableView;

/// 显示正在播放的歌曲
@property (weak, nonatomic) SHAudioPlayStatusView *showPlayStatusView;

/// 中间左图专辑列表的背景视图
@property (weak, nonatomic) UIImageView *albumListBackgroundView;

/// 中间显示指向右边的按钮
@property (weak, nonatomic) UIButton *showScrollRightButton;

/// 专辑列表的展示视图
@property (weak, nonatomic) UITableView *albumListTableView;

/// 取消选中专辑
@property (weak, nonatomic) UIButton *cancelSelectAlbumButton;

/// 确定选择中的专辑
@property (weak, nonatomic) UIButton *sureSelectAlbumButton;


/// 中间右侧占位视图
@property (weak, nonatomic) IBOutlet UIView *rightHolderListView;

/// 右列表视图
@property (weak, nonatomic) UIImageView *rightListImageView;

/// 中间显示指向右边的按钮
@property (weak, nonatomic) UIButton *showScrollLeftButton;

/// 播放队列按钮
@property (weak, nonatomic) UIButton *playQueButton;

/// 编辑队列按钮
@property (weak, nonatomic) UIButton *editQueButton;

/// 播放队列的歌曲列表视图
@property (weak, nonatomic) UITableView *songQueueListTableView;

/// 收音机音乐按钮的父视图(方便布局子控件)
@property (weak, nonatomic) UIView *radioChannelButtonsView;

/// 外接音乐视图
@property (weak, nonatomic) SHAudioInView* audioinImageView;

/// 音乐声音控制界面
@property (weak, nonatomic) SHAudioVolumeView *volumeView;


// MARK: - 底部UI  -- 播放按钮

/// 播放按钮
@property (weak, nonatomic) IBOutlet SHAuioPlayTypeButton *playButton;

/// 暂停按钮
@property (weak, nonatomic) IBOutlet SHAuioPlayTypeButton *pauseButton;

/// 下一首
@property (weak, nonatomic) IBOutlet SHAuioPlayTypeButton *nextButton;

/// 声音
@property (weak, nonatomic) IBOutlet SHAuioPlayTypeButton *voiceButton;

/// 停止
@property (weak, nonatomic) IBOutlet SHAuioPlayTypeButton *stopButton;

/// 上一首
@property (weak, nonatomic) IBOutlet SHAuioPlayTypeButton *previousButton;

/// 播放模式
@property (weak, nonatomic) IBOutlet SHAuioPlayTypeButton *modelButton;

@end

@implementation SHZoneAudioPlayControlViewController


// MARK: - ============ 音乐处理数据的部分 ============

/// 收到广播
- (void)analyzeReceivedSocketData:(SHSocketData *)socketData {
    
    
    if (socketData.subNetID != self.currentAudio.subnetID ||
        socketData.deviceID != self.currentAudio.deviceID) {
        return;
    }
    
    NSUInteger count = socketData.additionalData.count;
    Byte recivedData[count];
    
    for (int i = 0; i < count; i++) {
        
        recivedData[i] =
        ([socketData.additionalData[i] integerValue]) & 0xFF;
    }
    
    switch (self.receivedStatusType) {
            
            /********* 读取专辑与歌曲部分 **********/
            
        case SHAudioReceivedStatusTypeReadTotalPackages:{
            
            if (socketData.operatorCode == 0x02E1 &&
                recivedData[0] == self.currentAudio.sourceType) {
                
                self.receivedStatusType = SHAudioReceivedStatusTypeOut;
                self.totalPackages = recivedData[1];
                self.isReceivedAudioData = YES;
            }
        }
            break;  // OK
            
        case SHAudioReceivedStatusTypeReadAlbumList:{
            
            //11 源号  12大包号
            if (recivedData[2] == self.currentAudio.sourceType &&
                socketData.operatorCode == 0x02E3      &&
                recivedData[3] == self.currentPackageNumber) {
                
                //                printLog(@"2.专辑总数: %d", recivedData[0 + 4]);
                
                self.receivedStatusType = SHAudioReceivedStatusTypeOut;
                self.isReceivedAudioData = YES;
                
                // 相关的名称从5开始
                NSUInteger albumDataLength =
                recivedData[0] * 0xFF + recivedData[1] - 5;
                
                NSArray *albumNames =
                [SHAudioTools getNameFrom:[NSData dataWithBytes:&recivedData[5] length:albumDataLength]
                                  isAlbum:YES
                                    count:recivedData[4]
                 ];
                
                NSString *albumName = [albumNames componentsJoinedByString:@""];
                
                [self.recivedStringList appendFormat:@"%@",albumName];
                
                if (recivedData[3] == self.totalPackages) {
                    
                     printLog(@"最终的专辑名称: %@", self.recivedStringList);
                    
                    [SHAudioTools parseNameList:socketData.subNetID
                                       deviceID:socketData.deviceID
                                     sourceType:recivedData[2]
                                       nameList:self.recivedStringList
                                        isAlbum:YES
                             currentAlbumNumber:0
                     ];
                    
                    self.recivedStringList = nil;
                }
            }
        }
            break;  // OK
            
        case SHAudioReceivedStatusTypeReadSongPackages:{
            if (recivedData[0] == self.currentAudio.sourceType &&
                socketData.operatorCode == 0x02E5 &&
                self.currentCategoryNumber == recivedData[1]) {
                
                self.receivedStatusType = SHAudioReceivedStatusTypeOut;
                self.totalPackages = recivedData[2];
                self.isReceivedAudioData = YES;
                
                // printLog(@"当前专辑一共有歌曲的包数: %d", recivedData[0 + 2]);
            }
        }
            break;  // OK
            
        case SHAudioReceivedStatusTypeReadSongList: {
            
            // 确定是当前设备来源正在返回请求的歌曲名称
            if (recivedData[2] == self.currentAudio.sourceType &&
                socketData.operatorCode == 0x02E7                                      &&
                recivedData[3] == self.currentCategoryNumber
                ) {
                
                // 请求包号与返回一致
                if (recivedData[4] == self.currentPackageNumber) {
                    
                    self.receivedStatusType = SHAudioReceivedStatusTypeOut;
                    self.isReceivedAudioData = YES;
                    
                    NSUInteger songNameLength =
                    recivedData[0] * 0xFF + recivedData[1] - 6;
                    
                    if (songNameLength < 3 &&
                        recivedData[4] != self.totalPackages) {
                        
                        self.isReceivedAudioData = NO;
                        printLog(@"提前空包");
                        return;
                    }
                    
                    NSArray *songNames =
                    [SHAudioTools getNameFrom:
                     [NSData dataWithBytes:&recivedData[6]
                                    length:songNameLength]
                                      isAlbum:NO
                                        count:recivedData[5]
                     ];
                    
                    
                    NSString *songName = [songNames componentsJoinedByString:@""];
                    
                    [self.recivedStringList appendFormat:@"%@",songName];
                    
                    // printLog(@"当前音乐名称: %@", self.recivedStringList);
                    
                    /// 拼接完成
                    if (recivedData[4] == self.totalPackages) {
                        
                        //                        [SVProgressHUD showSuccessWithStatus:@"专辑所有音乐读取完成"];
                        [SHAudioTools parseNameList:socketData.subNetID
                                           deviceID:socketData.deviceID
                                         sourceType:recivedData[2]
                                           nameList:self.recivedStringList
                                            isAlbum:NO
                                 currentAlbumNumber:recivedData[3]
                         ];
                        
                        self.recivedStringList = nil;
                        self.errorSongNameNumber = 0;
                        
                        //下面部分为了防止出现包拼接错误，和包内容错误
                        //后面还有包，判断包拼接是否正确
                        
                    } else {
                        
                        self.errorSongNameNumber =
                        recivedData[5] +
                        recivedData[6] * 0xFF +
                        recivedData[7] + 3;
                    }
                    
                } else {
                    
                    printLog(@"====== 当前请求包号不一致 接收到信息========");
                    printLog(@"当前包号: %d\n请求包号: %zd\n总包号: %zd",
                             recivedData[4],
                             self.currentPackageNumber,
                             self.totalPackages
                             );
                    
                    // FIXME: - 音乐空包 以后如果出现其它情况，则可能需要修改固件
                    // 这个条件只适用于 80S专辑最后一个是空包的情况，其它情况都是不可用的
                    // 空包时 固件返回的广播不完整，数据也不匹配
                    // 只能临时这样判断
                    if ((count == 4) &&
                        (self.currentPackageNumber == self.totalPackages)) {
                        
                        self.receivedStatusType = SHAudioReceivedStatusTypeOut;
                        self.isReceivedAudioData = YES;
                        
                        [SHAudioTools parseNameList:socketData.subNetID
                                           deviceID:socketData.deviceID
                                         sourceType:recivedData[2]
                                           nameList:self.recivedStringList
                                            isAlbum:NO
                                 currentAlbumNumber:recivedData[3]
                         ];
                        
                        self.recivedStringList = nil;
                        self.errorSongNameNumber = 0;
                    }
                }
            }
            
        }
            break;
            
            /*************** 更新FTP部分 ****************/
        case SHAudioReceivedStatusTypeUpdateList: {
            
            // #SsDISPUPDATE, STATUS1<CR><LF>
            if (recivedData[0]  == 0x23 && // #
                recivedData[1]  == 0x53 && // S
                recivedData[2]  == 0x32 && // 来源 FTP
                recivedData[3]  == 0x44 && // D
                recivedData[4]  == 0x49 && // I
                recivedData[5]  == 0x53 && // S
                recivedData[6]  == 0x50 && // P
                recivedData[7]  == 0x55 && // U
                recivedData[8]  == 0x50 && // P
                recivedData[9]  == 0x44 && // D
                recivedData[10] == 0x41 && // A
                recivedData[11] == 0x54 && // T
                recivedData[12] == 0x45 && // E
                recivedData[13] == 0x2C && // ,
                recivedData[14] == 0x53 && // S
                recivedData[15] == 0x54 && // T
                recivedData[16] == 0x41 && // A
                recivedData[17] == 0x54 && // T
                recivedData[18] == 0x55 && // U
                recivedData[19] == 0x53    // S
                ) {
                
                // 获得状态
                SHAudioUpdateFtpServerDataStatus status =
                
                [SHAudioOperatorTools asciiToDecimalWithData:recivedData[20]];
                
                printLog(@"获得状态: %d", status);
                
                // 更新完成
                if (status == SHAudioUpdateFtpServerDataStatusFinished) {
                    
                    // 设置状态
                    self.receivedStatusType = SHAudioReceivedStatusTypeOut;
                    
                    // 成功更新
                    self.isUpdateFtpSuccess = YES;
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@\n%@", [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"UPDATE_FTP"], [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"PROMPT_MESSAGE_8"]]];
                    
                    // 其它代码
                    
                    // 正在更新
                } else if (status == SHAudioUpdateFtpServerDataStatusUpdating) {
                    
                    // 更新失败
                } else {
                    
                }
            }
            
        }
            break;
            
            /*************** 获得相关的状态 **************/
            
        case SHAudioReceivedStatusTypeOut: {
            
            if (socketData.operatorCode != 0X192F) {
                return;
            }
            
            /********* 声音 ***************/
            
            // 声音大小
            if (recivedData[0]  == 0x23 && // #
                recivedData[1]  == 0x5A && // Z
                // recivedData[0 + 2]   && // z // 当前区号
                recivedData[3]  == 0x2C && // ,
                recivedData[4]  == 0x4F && // O
                recivedData[5]  == 0x4E && // N
                recivedData[6]  == 0x2C && // ,
                recivedData[7]  == 0x53 && // S
                recivedData[8]  == 0x52 && // R
                recivedData[9]  == 0x43 && // C
                // recivedData[0 + 10]  && // 当前源号
                recivedData[11] == 0x2C && // ,
                recivedData[12] == 0x56 && // V
                recivedData[13] == 0x4F && // O
                recivedData[14] == 0x4C    // L
                
                ) {
                
                if (recivedData[17] == 0xD) { // ASCII
                    
                    self.volumeView.volume =
                    SHAUDIO_MAX_VOLUME -
                    (([SHAudioOperatorTools asciiToDecimalWithData:recivedData[15]]) * 10 +
                     [SHAudioOperatorTools asciiToDecimalWithData:recivedData[16]]);
                } else {
                    
                    self.volumeView.volume =
                    SHAUDIO_MAX_VOLUME -
                    [SHAudioOperatorTools asciiToDecimalWithData:recivedData[15]];
                }
                
                //                printLog(@"当前的声音大小: %d", self.volumeView.volume);
            }
            
            // 高低音 控制 #S1DISPTONE,BASS-(或+)1,TREB+(或-)5 回车
            else if (recivedData[0]  == 0x23 &&  // #
                     recivedData[1]  == 0x53 &&  // S
                     recivedData[2]  == 0x31 &&  // 1 音源，暂时先这么写
                     recivedData[3]  == 0x44 &&  // D
                     recivedData[4]  == 0x49 &&  // I
                     recivedData[5]  == 0x53 &&  // S
                     recivedData[6]  == 0x50 &&  // P
                     recivedData[7]  == 0x54 &&  // T
                     recivedData[8]  == 0x4F &&  // O
                     recivedData[9]  == 0x4E &&  // N
                     recivedData[10] == 0x45 &&  // E
                     recivedData[11] == 0x2C &&  // ,
                     recivedData[12] == 0x42 &&  // B
                     recivedData[13] == 0x41 &&  // A
                     recivedData[14] == 0x53 &&  // S
                     recivedData[15] == 0x53 &&  // S
                     
                     recivedData[18] == 0x2C &&  // ,
                     recivedData[19] == 0x54 &&  // T
                     recivedData[20] == 0x52 &&  // R
                     recivedData[21] == 0x45 &&  // E
                     recivedData[22] == 0x42 &&  // B
                     
                     recivedData[25] == 0x0D    // <CR>
                     ) {
                
                
                NSInteger bass =
                [SHAudioOperatorTools asciiToDecimalWithData:recivedData[17]];
                
                NSInteger treble =
                [SHAudioOperatorTools asciiToDecimalWithData:recivedData[24]];
                
                if (recivedData[16] == 0x2D) { // -
                    
                    bass =  0 - bass;
                }
                
                if (recivedData[23] == 0x2D) { // -
                    
                    treble = 0 - treble;
                }
                
                self.volumeView.bass = bass;
                self.volumeView.treble = treble;
                
                //                printLog(@"高音与低音： %@ - %@",
                //                         @(bass), @(treble));
            }
            
            /*********  播放时间与状态信息  ***********/
            
            else if (recivedData[0]  == 0x23 &&  // #
                     recivedData[1]  == 0x53 &&  // S
                     
                     // recivedData[2]         // 音乐来源
                     [SHAudioOperatorTools asciiToDecimalWithData:recivedData[2]] ==
                     self.currentAudio.sourceType     &&
                     
                     recivedData[3]  == 0x44 &&  // D
                     recivedData[4]  == 0x49 &&  // I
                     recivedData[5]  == 0x53 &&  // S
                     recivedData[6]  == 0x50 &&  // P
                     recivedData[7]  == 0x49 &&  // I
                     recivedData[8]  == 0x4E &&  // N
                     recivedData[9]  == 0x46 &&  // F
                     recivedData[10] == 0x4F &&  // O
                     recivedData[11] == 0x2C &&  // ,
                     recivedData[12] == 0x44 &&  // D
                     recivedData[13] == 0x55 &&  // U
                     recivedData[14] == 0x52     // R
                     
                     ) {
                
                NSString *playStatusString =
                [[NSString alloc] initWithBytes:&recivedData[15]
                                         length:count - 2
                                       encoding:NSASCIIStringEncoding
                 ];
                
                NSArray *playStatusArray = [playStatusString
                                            componentsSeparatedByString:@","];
                
                NSInteger totalSeconds = [playStatusArray[0] integerValue] / 10;
                
                // 1.总共时长
                NSString *totalTimeString = [SHAudioOperatorTools showTimeWithSeconds:totalSeconds];
                
                [SHPlayingSong.shared
                 setTotalTime:totalTimeString
                 ];
                
                // 2.已播放时间
                NSInteger playSeconds = [[[playStatusArray objectAtIndex:1] substringFromIndex:3] integerValue] / 10; // POS
                
                NSString *playTimeString =
                [SHAudioOperatorTools
                 showTimeWithSeconds:playSeconds
                 ];
                
                [SHPlayingSong.shared
                 setAleardyPlayTime:playTimeString
                 ];
                
                SHAudioBoardCastPlayStatus status =
                [SHAudioOperatorTools asciiToDecimalWithData:recivedData[count - 2]];
                
                // 3.播放状态
                SHPlayingSong.shared.playStatus = status;
                
                self.showPlayStatusView.playSong =
                SHPlayingSong.shared;
                
                if (self.isQueue &&
                    status == SHAudioBoardCastPlayStatusPlay) {
                    
                    
                    SHSong *queueSong = self.selectQueueSongs[self.indexQueue];
                    
                    if ((SHPlayingSong.shared.albumNumber != queueSong.albumNumber) ||
                        (SHPlayingSong.shared.songNumber != queueSong.songNumber)) {
                    
                        ++self.queueCount;
                        
                        if (self.queueCount == 2) { // 固件在短时间内会有两次相同的广播
                           
                            self.queueCount = 0;
                            ++self.indexQueue;
                            
                            self.indexQueue %= self.selectQueueSongs.count;
                            
                              printLog(@"做准备发送 == %@", @(self.indexQueue));
                            
                            SHSong *song =
                            self.selectQueueSongs[self.indexQueue];
                              
                            [self playQueueSong:song];
                        }
                        
                    }
                }
            }
            
            /********** 歌曲与专辑信息 ***************/
            
            // #SsDISPLINE1, <STX>L:??? / ???<ETX> <CR><LF>
            
            else if (recivedData[0]  == 0x23 && // #
                     recivedData[1]  == 0x53 && // S
                     
                     // recivedData[2] 音乐来源
                     [SHAudioOperatorTools asciiToDecimalWithData:
                      recivedData[2]
                      ]
                     
                     == self.currentAudio.sourceType   && // 来源
                     
                     recivedData[3]  == 0x44 && // D
                     recivedData[4]  == 0x49 && // I
                     recivedData[5]  == 0x53 && // S
                     recivedData[6]  == 0x50 && // P
                     recivedData[7]  == 0x4C && // L
                     recivedData[8]  == 0x49 && // I
                     recivedData[9]  == 0x4E && // N
                     recivedData[10] == 0x45 && // E
                     
                     recivedData[12] == 0x2C &&  // ,
                     recivedData[13] == 0x02     // STX , ASC码
                     ) {
                
                // 内容从可变参数的第14个索引开始
                // 倒数3个是固定的结束标示 ETX> <CR><LF>
                // 可变参数的第11个索引是1~4代表返回不同的内容
                
                NSString *string =
                [[NSString alloc]
                 initWithBytes:&recivedData[14]
                 length:(count - 14 - 3)
                 encoding:NSUnicodeStringEncoding
                 ];
                
                if (!string.length) {
                    break;
                }
                
                switch (recivedData[11]) {
                        
                    case 0x31: {  // 列表号与列表总数
                        
//                        printLog(@"1. 列表号与列表总数: %@", string);
                        
                        [SHPlayingSong.shared
                         setAlbumSerialNumber:string];
                        
                        // List:XX/XXX
                        NSRange range =
                            [string rangeOfString:@"/"];
                        
                        if (range.location == NSNotFound) {
                            return;
                        }
                        
                        NSString *albumNumber = [string substringToIndex:range.location];
                        
                       
                        // 确定 : 的位置
                        range =
                            [albumNumber rangeOfString:@":"];
                        
                        if (range.location == NSNotFound) {
                            return;
                        }
                       
                        // L:1
                       albumNumber =
                            [albumNumber substringFromIndex: range.location + 1];
                  
                        SHPlayingSong.shared.albumNumber = albumNumber.integerValue;
                    }
                        break;
                        
                    case 0x32: {  // 列表名
                        
                        //                          printLog(@"2.专辑名称: %@", string);
                        [SHPlayingSong.shared
                         setAlbumName:string];
                    }
                        break;
                        
                    case 0x33: {  // 歌曲号???/歌曲总数
                        
                        // printLog(@"3. 歌曲号???/歌曲总数: %@", string);
                        [SHPlayingSong.shared
                         setSongSerialNumber:string];
                        
                        // Track:2/3
                        
                        NSRange range =
                        [string rangeOfString:@"/"];
                        
                        if (range.location == NSNotFound) {
                            return;
                        }
                        
                        NSString *songNumber = [string substringToIndex:range.location];
                        
                        // 确定 : 的位置
                        range =
                            [songNumber rangeOfString:@":"];
                        
                        if (range.location == NSNotFound) {
                            return;
                        }
                        
                        // Track:4 / S:1 - FTP
                        songNumber =
                        [songNumber substringFromIndex: range.location + 1];
                        
                        SHPlayingSong.shared.songNumber =
                            songNumber.integerValue;
                    }
                        break;
                        
                    case 0x34: {  // 歌曲名
                        
                        //                    printLog(@"4. 歌曲名: %@", string);
                        [SHPlayingSong.shared
                         setSongName:string];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                [SHPlayingSong.shared setSourceType:self.currentAudio.sourceType
                 ];
                
                [self.showPlayStatusView
                 setPlaySong:SHPlayingSong.shared
                 ];
            }
            
            /********** 获得当前的模式 ***********/
            
            else if (recivedData[0]  == 0x23 && // #
                     recivedData[1]  == 0x53 && // S
                     
                     // recivedData[2]  // 音乐来源
                     [SHAudioOperatorTools asciiToDecimalWithData:recivedData[2]]
                     ==
                     self.currentAudio.sourceType     &&
                     
                     recivedData[3]  == 0x44 && // D
                     recivedData[4]  == 0x49 && // I
                     recivedData[5]  == 0x53 && // S
                     recivedData[6]  == 0x50 && // P
                     recivedData[7]  == 0x4D && // M
                     recivedData[8]  == 0x4F && // O
                     recivedData[9]  == 0x44 && // D
                     recivedData[10] == 0x45 && // E
                     recivedData[11] == 0x2C && // ,
                     recivedData[12] == 0x53 && // S
                     recivedData[13] == 0x54 && // T
                     recivedData[14] == 0x41 && // A
                     recivedData[15] == 0x54 && // T
                     recivedData[16] == 0x55 && // U
                     recivedData[17] == 0x53    // S
                     )  {
                
                self.currentAudio.playMode =
                
                [SHAudioOperatorTools asciiToDecimalWithData:
                 recivedData[18]
                 ];
                
                // printLog(@"当前取值: %d", self.currentAudio.playMode);
                
                // 显示状态
                [self showAudioPlayModel];
            }
        }
            break;
            
            //  获得状态
        case SHAudioReceivedStatusTypeReadDeviceStatus: {
            
        }
            break;
            
        default:
            break;
    }
}

// MARK: ====== - 重发机制 ======

/// 发送数据
- (void)sendControlAudioData:(SHAudioSendData *)sendData {
    
    if (self.cancelSendData) {
        return;     // 取消发送消息
    }
    
    [SHSocketTools sendDataWithOperatorCode:sendData.operatorCode
                                   subNetID:sendData.subNetID
                                   deviceID:sendData.deviceID
                             additionalData:sendData.additionalData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:false
                                      isDMX:false
     ];
    
    self.isReceivedAudioData = NO;
    
    [self performSelector:@selector(reSendControlAudioData:)
               withObject:sendData
               afterDelay:1.2];
}

/// 重新发送数据
-(void)reSendControlAudioData:(SHAudioSendData *)sendData{
    
    /// 取消发送消息
    if (self.cancelSendData) {
        return;
    }
    
    if (self.isReceivedAudioData) {
        
        self.reSendCount = 0;
        self.isReceivedAudioData = NO;
        [self sendStartNewData:sendData];
        
    } else {
        
        self.reSendCount++;
        
        // 超时
        if (self.reSendCount > 3) { // 重发最多3次
            
            TYCustomAlertView *alertView =
            [TYCustomAlertView alertViewWithTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"SYSTEM_PROMPT"] message:@"Sorry! Fail to read list, please check network and zone settings!" isCustom:YES];
            
            [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.ok style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
                
                self.view.userInteractionEnabled = YES; // 恢复交互
                self.recivedStringList = nil; // 清空接收字符串的内容
                
            }]];
            
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
            
            alertController.backgoundTapDismissEnable = YES;
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            [SVProgressHUD dismiss];
            
            self.receivedStatusType =
                SHAudioReceivedStatusTypeOut;
            
            self.reSendCount = 0;
            self.isReceivedAudioData = NO;
            
        } else {
            
            [self sendControlAudioData:sendData];
        }
    }
}

/// 成功接收到旧信息，开始发送新信息
-(void)sendStartNewData:(SHAudioSendData *)sendData{
    
    switch (sendData.operatorCode) {
            
        case 0x02E0:{
            
            sendData.packageTotal = self.totalPackages;
            sendData.packageNumber = 1;
            sendData.operatorCode = sendData.operatorCode+2;
            
            sendData.additionalData =
            @[ @(sendData.sourceType),
               @(sendData.packageNumber)];
            
            self.currentPackageNumber = sendData.packageNumber;
            
            self.reSendCount = 0;
            self.receivedStatusType =
                SHAudioReceivedStatusTypeReadAlbumList;
            [self sendControlAudioData:sendData];
            
        }  // OK
            break;
            
        case 0x02E2:{
            
            if (sendData.packageNumber == sendData.packageTotal) {
                
                sendData.categoryNumber = 1;
                
                [self showAlbumList:sendData.subNetID deviceID:sendData.deviceID sourceType:sendData.sourceType albumNumber:sendData.categoryNumber readSong:NO];
                
                sendData.operatorCode = sendData.operatorCode + 2;
                
                sendData.additionalData = @[@(sendData.sourceType), @(sendData.categoryNumber)];
                
                self.currentCategoryNumber = sendData.categoryNumber;
                
                self.reSendCount = 0;
                self.receivedStatusType = SHAudioReceivedStatusTypeReadSongPackages;
                
                [self sendControlAudioData:sendData];
                
            } else {
                sendData.packageNumber = sendData.packageNumber + 1;
                
                sendData.additionalData = @[@(sendData.sourceType),  @(sendData.packageNumber)];
                
                self.currentPackageNumber = sendData.packageNumber;
                self.reSendCount = 0;
                self.receivedStatusType = SHAudioReceivedStatusTypeReadAlbumList;
                [self sendControlAudioData:sendData];  // OK
            }
            
        }
            break;
            
        case 0x02E4:{
            
            sendData.packageTotal = self.totalPackages;
            sendData.packageNumber = 1;
            sendData.operatorCode = sendData.operatorCode+2;
            
            sendData.additionalData =
            @[ @(sendData.sourceType),
               @(sendData.categoryNumber),
               @(sendData.packageNumber)
               ];
            
            self.currentPackageNumber = sendData.packageNumber;
            self.reSendCount = 0;
            self.receivedStatusType = SHAudioReceivedStatusTypeReadSongList;
            
            [self sendControlAudioData:sendData];
            
        }
            break;
            
        case 0x02E6:{
            
            if (sendData.packageNumber == sendData.packageTotal) {
                
                [self showSongList:sendData.subNetID deviceID:sendData.deviceID sourceType:sendData.sourceType songAlbumNumber:sendData.categoryNumber];
            } else {
                sendData.packageNumber = sendData.packageNumber + 1;
                
                sendData.additionalData =
                @[ @(sendData.sourceType),
                   @(sendData.categoryNumber),
                   @(sendData.packageNumber)
                   ];
                
                self.currentPackageNumber = sendData.packageNumber;
                
                self.reSendCount = 0;
                self.receivedStatusType = SHAudioReceivedStatusTypeReadSongList;
                
                [self sendControlAudioData: sendData];
            }
        }
            break;
    }
}

/**
 显示音乐专辑列表
 
 @param subNetID 子网ID
 @param deviceID 设备ID
 @param sourceType 音乐类型
 @param songAlbumNumber 歌曲的专辑号序号
 */
- (void)showSongList:(Byte)subNetID deviceID:(Byte)deviceID sourceType:(Byte)sourceType songAlbumNumber:(Byte)songAlbumNumber {
    
    [SVProgressHUD showWithStatus:@"Loading Data ..."];
    NSString *songPath =
    [SHAudioOperatorTools getAudioPathWithSubNetID:subNetID deviceID:deviceID sourceType:sourceType fileType:SHAudioSourceFileTypeSongs serialNumber:songAlbumNumber];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:songPath]) {
        
        // 读取出歌曲
        self.currentAudio.currentSelectAlbum.totalAlbumSongs = [SHAudioTools  readPlist:songPath];
        
        [self.currentAlbumSongsListTableView reloadData];
        
        [SVProgressHUD dismiss];
        
        self.view.userInteractionEnabled = YES;
        
        /// FIXME: - 从这里开始读状态
        
        if (self.currentAudio.sourceType == SHAudioSourceTypeSDCARD || self.currentAudio.sourceType ==
            SHAudioSourceTypeFTP) {
            
            // 加载队列音乐
            self.selectQueueSongs =
            [SHAudioOperatorTools getQueueSongsWithSubNetID:subNetID
                                                   deviceID:deviceID
                                                 sourceType:sourceType
             ];
            
            [self.songQueueListTableView reloadData];
            
            [NSThread sleepForTimeInterval:0.5];
            
            self.receivedStatusType = SHAudioReceivedStatusTypeOut;
            
            // 读取状态
            [SHAudioOperatorTools readAudioStatusWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID];
            
            [NSThread sleepForTimeInterval:0.3];
            
            
            if (!self.currentAudio.isMiniZAudio) {
                
                // 读取模式
                [SHAudioOperatorTools readAudioModelWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID];
                
                [NSThread sleepForTimeInterval:0.3];
                
                // 读取均衡器的值
                [SHAudioOperatorTools readAudioTrebleAndBassWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID zoneFlag:self.currentAudio.zoneFlag
                 ];
            }
            
        }
        
    } else {
        
        SHAudioSendData *sendData = [[SHAudioSendData alloc] init];
        sendData.subNetID = subNetID;
        sendData.deviceID = deviceID;
        sendData.sourceType = sourceType;
        sendData.operatorCode = 0X02E4;
        sendData.packageNumber = 1;
        sendData.packageTotal = 1;
        
        sendData.categoryNumber = songAlbumNumber;
        
        sendData.additionalData =
        @[@(sourceType), @(songAlbumNumber)];
        
        self.receivedStatusType = SHAudioReceivedStatusTypeReadSongPackages;
        self.reSendCount = 0;
        
        self.currentCategoryNumber = songAlbumNumber;
        [self sendControlAudioData:sendData];
        
        // UI的处理上
        self.currentAudio.currentSelectAlbum.totalAlbumSongs
        = @[];
        
        [self.currentAlbumSongsListTableView reloadData];
    }
}

/**
 显示音乐的专辑
 
 @param subNetID 子网ID
 @param deviceID 设备ID
 @param sourceType 设备类型
 @param albumNumber 专辑序号，从1开始
 @param readSong 读取音乐
 */
- (void)showAlbumList:(Byte)subNetID deviceID:(Byte)deviceID sourceType:(Byte)sourceType albumNumber:(Byte)albumNumber readSong:(BOOL)readSong {
    
    [SVProgressHUD showWithStatus:@"Loading Data ..."];
    
    // 此时是不能交互的 禁止点击
    self.view.userInteractionEnabled = NO;
    
    // 1.获得路径
    NSString *albumPlistFilePath =
    [SHAudioOperatorTools getAudioPathWithSubNetID:subNetID
                                          deviceID:deviceID
                                        sourceType:sourceType
                                          fileType:SHAudioSourceFileTypeAlbum
                                      serialNumber:0
     ];
    
    // 2.判断文件是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:albumPlistFilePath]) {
        
        // 获得所有的专辑
        self.currentAudio.allAlbums =
        [SHAudioTools readPlist:albumPlistFilePath];
        
        if (self.currentAudio.allAlbums.count == 0) {
            
            printLog(@"测试专辑为空 albumPlistFilePath = %@",
                     albumPlistFilePath);
            return ;
        }
        
        // 刷新列表
        [self.albumListTableView reloadData];
        
        //  选择第一个
        self.currentAudio.currentSelectAlbum =
        self.currentAudio.allAlbums[albumNumber - 1];
        
        // 默认选择第一个cell 动画效果
        [self.albumListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(albumNumber - 1) inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        // 设置标题
        [self.selectAlbumButton
         setTitle:self.currentAudio.currentSelectAlbum.albumName
         forState:UIControlStateNormal
        ];
        
        if (readSong) {
            
            [self showSongList:subNetID
                      deviceID:deviceID
                    sourceType:sourceType
               songAlbumNumber:1
            ];
        }
        
    } else {
        
        // 1 ==== 请求数据
        SHAudioSendData *sendData =
            [[SHAudioSendData alloc] init];
        sendData.subNetID = subNetID;
        sendData.deviceID = deviceID;
        sendData.sourceType = sourceType;
        sendData.operatorCode = 0X02E0;
        sendData.packageNumber = 1;
        sendData.packageTotal = 1;
        sendData.categoryNumber = albumNumber;
        
        sendData.additionalData = @[@(sourceType)];
        
        self.receivedStatusType = SHAudioReceivedStatusTypeReadTotalPackages;
        self.reSendCount = 0;
        
        [self sendControlAudioData:sendData];
        
        // 2 ===== UI上的处理
        [self.selectAlbumButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"ALBUMS_LIST"] forState:UIControlStateNormal];
        
        // 清空列表
        self.currentAudio.allAlbums = @[];
        [self.albumListTableView reloadData];
        
        // 清空列表对应的歌曲
        self.currentAudio.currentSelectAlbum.totalAlbumSongs
            = @[];
        
        [self.currentAlbumSongsListTableView reloadData];
    }
}


// MARK: - ============ 关于UI控件点击事件 ============

/// 显示当前的模式
- (void)showAudioPlayModel {
    
    switch (self.currentAudio.playMode) {
            
            
        case SHAudioPlayModeTypeNotRepeated: { // 单曲播放
            
            // [SVProgressHUD showInfoWithStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"REPEAT_OFF"]];
            
            // 设置图片
            [self.modelButton setImage:[UIImage imageNamed:@"playModelNotReated_normal"] forState:UIControlStateNormal];
            
            [self.modelButton setImage:[UIImage imageNamed:@"playModelNotReated_highlighted"] forState:UIControlStateHighlighted];
        }
            break;
            
        case SHAudioPlayModeTypeRepeatOneSong: { // 单曲循环
            
            // [SVProgressHUD showInfoWithStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"REPEAT_ONE"]];
            
            // 设置图片
            [self.modelButton setImage:[UIImage imageNamed:@"playModelRepeatOne_normal"] forState:UIControlStateNormal];
            
            [self.modelButton setImage:[UIImage imageNamed:@"playModelRepeatOne_highlighted"] forState:UIControlStateHighlighted];
            
        }
            break;
            
        case SHAudioPlayModeTypeRepeatOneAlbum: { // 顺序播放
            
            // [SVProgressHUD showInfoWithStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"CONTINUED"]];
            
            // 设置图片
            [self.modelButton setImage:[UIImage imageNamed:@"playModelRepeatOneAlbum_normal"] forState:UIControlStateNormal];
            [self.modelButton setImage:[UIImage imageNamed:@"playModelRepeatOneAlbum_highlighted"] forState:UIControlStateHighlighted];
        }
            break;
            
        case SHAudioPlayModeTypeRepeatAllAlbum: { // 循环播放
            
            // [SVProgressHUD showInfoWithStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"REPEAT_ALL"]];
            
            // 设置图片
            [self.modelButton setImage:[UIImage imageNamed:@"playModelRepeatAllAlbum_normal"] forState:UIControlStateNormal];
            [self.modelButton setImage:[UIImage imageNamed:@"playModelRepeatAllAlbum_highlighted"] forState:UIControlStateHighlighted];
        }
            break;
            
        default:
            break;
    }
}

/// 模式播放
- (IBAction)modelButtonClick {
    
    if (self.currentAudio.isMiniZAudio) {
        return;
    }
    
    [SHAudioOperatorTools changeAudioplayModelWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID playMode:self.currentAudio.playMode
     ];
}

/// 上一首
- (IBAction)previousButtonClick {
    
    if (self.isQueue) {
        
        --self.indexQueue;
        
        if (self.indexQueue < 0) {
            
            self.indexQueue =
            self.selectQueueSongs.count - 1;
        }
        
        SHSong *song = self.selectQueueSongs[self.indexQueue];
        
        [self playQueueSong:song];
        
    } else {
        
        // 收音机
        if ((!self.currentAudio.isMiniZAudio &&
             self.currentAudio.sourceType == SHAudioSourceTypeRADIO) ||
            (self.currentAudio.isMiniZAudio &&
             self.currentAudio.sourceType == SHMiniZAudioSourceTypeRADIO)
            ) {
            
            [SHAudioOperatorTools changePreviousRadioChannelWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID];
            
            return;
        }
        
        // 音乐
        [SHAudioOperatorTools playAudioPreviousSongWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID sourceType:self.currentAudio.sourceType zoneFlag:self.currentAudio.zoneFlag
         ];
    }
}

/// 停止
- (IBAction)stopButtonClick {
    
    if (self.isQueue) {
        
        [self playQueButtonClick];
        
    } else {
        
        [SHAudioOperatorTools stopAudioWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID];
        
        [SHAudioOperatorTools stopAudioSongWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID sourceType:self.currentAudio.sourceType zoneFlag:self.currentAudio.zoneFlag];
    }
}

/// 播放
- (IBAction)playButtonClick {
    
    if (self.isQueue) {
        
        // 直接播放指定音乐
        SHSong *queueSong = self.selectQueueSongs[self.indexQueue];
        
        [self playQueueSong:queueSong];
        
    } else {
        
        // 指定播放
        if (self.currentAudio.currentSelectAlbum.currentSelectSong) {
            
            [SHAudioOperatorTools playAudioSelectSongWithSubNetID:self.currentAudio.subnetID
                                                         deviceID:self.currentAudio.deviceID
                                                       sourceType:self.currentAudio.sourceType
                                                      albumNumber:self.currentAudio.currentSelectAlbum.currentSelectSong.albumNumber
                                                       songNumber:self.currentAudio.currentSelectAlbum.currentSelectSong.songNumber
                                                         zoneFlag:self.currentAudio.zoneFlag];
            
        } else {  // 直接播放
            
            [SHAudioOperatorTools playAudioWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID];
            
            [SHAudioOperatorTools playAudioAnySongWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID sourceType:self.currentAudio.sourceType zoneFlag:self.currentAudio.zoneFlag
             ];
        }
    }
}

/// 暂停
- (IBAction)pauseButtonClick {
    
    // 现在的设备没有暂停这个功能，暂停就是停止
    [self stopButtonClick];
}

/// 下一首
- (IBAction)nextButtonClick {
    
    if (self.isQueue) {
        
        ++self.indexQueue;
        
        if (self.indexQueue == self.selectQueueSongs.count) {
            
            self.indexQueue = 0;
        }
        
        SHSong *song = self.selectQueueSongs[self.indexQueue];
        
        [self playQueueSong:song];
        
        
    } else {
        
        // 收音机
        if ((!self.currentAudio.isMiniZAudio &&
             self.currentAudio.sourceType == SHAudioSourceTypeRADIO) ||
            (self.currentAudio.isMiniZAudio &&
             self.currentAudio.sourceType == SHMiniZAudioSourceTypeRADIO)
            ) {
            
            [SHAudioOperatorTools changeNextRadioChannelWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID];
            
            return;
        }
        
        // 音乐
        [SHAudioOperatorTools playAudioNextSongWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID sourceType:self.currentAudio.sourceType zoneFlag:self.currentAudio.zoneFlag
         ];
    }
}

/// 显示音量调整器
- (IBAction)showVolumeView {
    
    self.volumeView.hidden = !self.volumeView.hidden;
    self.voiceButton.selected = !self.voiceButton.selected;
}


/// 选择专辑
- (void)selectAlbumNames:(UIButton *)button {
    
    // 匹分标题 -- 点击确认
    if ([button.currentTitle isEqualToString:SHLanguageText.ok]) {
        
        if (self.currentAudio.currentSelectAlbum.albumName.length) {
            
            self.view.userInteractionEnabled = NO;
            
            // 设置标题
            [self.selectAlbumButton setTitle:self.currentAudio.currentSelectAlbum.albumName
                                    forState:UIControlStateNormal
             ];
            
            // 显示当前专辑的音乐数据
            [self showSongList:self.currentAudio.subnetID
                      deviceID:self.currentAudio.deviceID
                    sourceType:self.currentAudio.sourceType
               songAlbumNumber:self.currentAudio.currentSelectAlbum.albumNumber
             ];
        }
    }
    
    // 隐藏
    self.albumListBackgroundView.hidden = YES;
}

/// 编辑队列
- (void)editQueButtonClick {
    
    if (!self.selectQueueSongs.count) {
        
        [SVProgressHUD showErrorWithStatus:SHLanguageText.noData];
        
        return;
    }
    
    // 设置状态
    self.songQueueListTableView.editing = !self.songQueueListTableView.isEditing;
    
    // 设置文字
    [self.editQueButton setTitle:(self.songQueueListTableView.isEditing ? SHLanguageText.done : SHLanguageText.edit) forState: UIControlStateNormal];
}

/// 队列播放音乐
- (void)playQueButtonClick {
    
    if (self.isQueue || !self.selectQueueSongs.count) {
        
        if (self.isQueue) {
            
            // 停止队列播放
            [self stopQueueSongs];
            
            // 停止播放音乐
            [SHAudioOperatorTools stopAudioSongWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID sourceType:self.currentAudio.sourceType zoneFlag:self.currentAudio.zoneFlag
             ];
            
            return;
            
        } else {
            
            [SVProgressHUD showInfoWithStatus:SHLanguageText.noData];
        }
        
    } else {
        
        self.isQueue = YES; // 设置播放状态
        
        [UIApplication sharedApplication].idleTimerDisabled = YES; // 不能锁屏
        
        // 设置标题
        NSString *queueButtonTitle = [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"STOP_QUE"];
        
        [self.playQueButton setTitle:queueButtonTitle
                            forState:UIControlStateNormal
         ];
        
        // 开始播放队列音乐
        
        // 如果已经选择了开始播放，如果没有选择，从头开始播放
        
        SHSong *queueSong = self.selectQueueSongs[self.indexQueue];
        
        [self playQueueSong:queueSong];
    }
}

/// 播放队列中音乐
- (void)playQueueSong:(SHSong *)song {
    
    if (UIApplication.sharedApplication.idleTimerDisabled == NO) {
        UIApplication.sharedApplication.idleTimerDisabled =
        YES;
    }
    
    // 播放指定音乐
    [SHAudioOperatorTools playAudioSelectSongWithSubNetID:song.subNetID deviceID:song.deviceID sourceType:song.sourceType albumNumber:song.albumNumber songNumber:song.songNumber zoneFlag:self.currentAudio.zoneFlag
     ];
    
    self.queueCount = 0;
    
    NSIndexPath *queueIndex =
    [NSIndexPath indexPathForRow:self.indexQueue
                       inSection:0
     ];
    
    [self.songQueueListTableView selectRowAtIndexPath:queueIndex animated:YES scrollPosition:UITableViewScrollPositionMiddle
     ];
    
    [self tableView:self.songQueueListTableView didSelectRowAtIndexPath:queueIndex];
    
    [self performSelector:@selector(readAudioStatus) withObject:nil afterDelay:3.0];
}


/// 停止队列音乐播放
- (void)stopQueueSongs {
    
    self.isQueue = NO;
    
    [self.songQueueListTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.indexQueue inSection:0] animated:YES];
    
    self.indexQueue = 0;
    
    [UIApplication sharedApplication].idleTimerDisabled =
    NO;
    
    [self.playQueButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"PLAY_QUE"] forState:UIControlStateNormal];
    
    [SVProgressHUD showSuccessWithStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"STOP_QUE"]];
}

/// 增加到队列
- (void)addToQueButtonClick {
    
    SHSong *selectSong =
    self.currentAudio.currentSelectAlbum.currentSelectSong ;
    
    if (selectSong == nil
        /*!self.currentAudio.currentSelectAlbum.totalAlbumSongs.count*/) {
        
        [SVProgressHUD showErrorWithStatus:SHLanguageText.noData];
        
        return;
    }
    
    
    [self.selectQueueSongs addObject:selectSong];
    
    [SVProgressHUD showSuccessWithStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"ADD_SUCCEED"]];
    
    [self.songQueueListTableView reloadData];
    
    if (self.selectQueueSongs.count) {
        
        [SHAudioOperatorTools saveQueueSongsWithSongs:self.selectQueueSongs subNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID sourceType:self.currentAudio.sourceType
         ];
    }
}


/// 选择专辑列表
- (void)selectAlbumButtonClick {
    
    self.albumListBackgroundView.hidden = !self.albumListBackgroundView.hidden;
}

/// 选择区域 刷新
- (void)zoneRefreshButtonClick {
    
    if (self.currentAudio.isMiniZAudio                             ||
        ((self.currentAudio.sourceType != SHAudioSourceTypeSDCARD) &&
         (self.currentAudio.sourceType != SHAudioSourceTypeFTP))
        ) {
        
        return;
    }
    
    self.showPlayStatusView.playSong = nil;
    
    // 删除数据
    [SHAudioOperatorTools deletePlistWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID sourceType:self.currentAudio.sourceType
     ];
    
    self.currentAudio.currentSelectAlbum = nil;;
    
    [self showAlbumList:self.currentAudio.subnetID
               deviceID:self.currentAudio.deviceID
             sourceType:self.currentAudio.sourceType
            albumNumber:1
               readSong:YES
     ];
}

/// 点击Zaudio来源选择按钮
- (void)selectAudioSourceButtonTouch:(SHAudioSourceButton *)button {
    
    SHAudioSourceType sourceType = button.sourceType;
    
    // 1.切换按钮
    for (NSUInteger i = 0; i < self.sourceTypeScrollView.subviews.count; i++) {
        
        SHAudioSourceButton *autioButton = self.sourceTypeScrollView.subviews[i];
        
        autioButton.selected = (sourceType == autioButton.sourceType);
    }
    
    // 2.显示不同的状态
    switch (sourceType) {
            
        case SHAudioSourceTypeSDCARD: {
            
            if (self.currentAudio.sourceType != SHAudioSourceTypeSDCARD) {
                
                self.currentAudio.sourceType = SHAudioSourceTypeSDCARD;
                
                [SHAudioOperatorTools changeAudioSourceWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID musicSoureNumber:SHAudioSoureNumberSdCard zoneFlag:self.currentAudio.zoneFlag
                 ];
                
                [NSThread sleepForTimeInterval:0.1];
                
                
                [self showAlbumList:self.currentAudio.subnetID
                           deviceID:self.currentAudio.deviceID
                         sourceType:self.currentAudio.sourceType
                        albumNumber:1
                           readSong:YES
                 ];
            }
        }
            break;
            
        case SHAudioSourceTypeFTP: {
            
            if (self.currentAudio.sourceType != SHAudioSourceTypeFTP) {
                
                self.currentAudio.sourceType = SHAudioSourceTypeFTP;
                
                
                [SHAudioOperatorTools changeAudioSourceWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID musicSoureNumber:SHAudioSoureNumberFtpServer zoneFlag:self.currentAudio.zoneFlag];
                
                [NSThread sleepForTimeInterval:0.1];
                
                [self showAlbumList:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID sourceType:self.currentAudio.sourceType albumNumber:1 readSong:YES];
            }
        }
            break;
            
        case SHAudioSourceTypeRADIO: {
            
            if (self.currentAudio.sourceType != SHAudioSourceTypeRADIO) {
                
                self.currentAudio.sourceType = SHAudioSourceTypeRADIO;
                
                [SHAudioOperatorTools changeAudioSourceWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID musicSoureNumber:SHAudioSoureNumberFMRadio zoneFlag:self.currentAudio.zoneFlag
                 ];
            }
        }
            break;
            
        case SHAudioSourceTypeAUDIOIN: {
            
            if (self.currentAudio.sourceType != SHAudioSourceTypeAUDIOIN) {
                
                self.currentAudio.sourceType = SHAudioSourceTypeAUDIOIN;
                
                [SHAudioOperatorTools changeAudioSourceWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID musicSoureNumber:SHAudioSoureNumberAudioIn zoneFlag:self.currentAudio.zoneFlag
                 ];
            }
        }
            break;
            
        default:
            break;
    }
    
    // 隐藏或显示相关的按钮 (播放与暂停/停止按钮都会显示出来)
    self.modelButton.hidden =
    (sourceType == SHAudioSourceTypeRADIO   ||
     sourceType == SHAudioSourceTypeAUDIOIN );
    
    self.previousButton.hidden =
    (sourceType == SHAudioSourceTypeRADIO   ||
     sourceType == SHAudioSourceTypeAUDIOIN );
    
    self.nextButton.hidden =
    (sourceType == SHAudioSourceTypeRADIO   ||
     sourceType == SHAudioSourceTypeAUDIOIN );
    
    self.listScrollView.hidden =
    !((sourceType == SHAudioSourceTypeSDCARD) ||
      (sourceType == SHAudioSourceTypeFTP) );
    
    self.radioChannelButtonsView.hidden =
    (sourceType != SHAudioSourceTypeRADIO);
    
    self.audioinImageView.hidden =
    (sourceType != SHAudioSourceTypeAUDIOIN);
}

/// 点击MiniZaudio来源选择按钮
- (void)selectMiniZAudioSourceButtonTouch:(SHAudioSourceButton *)button {
    
    SHMiniZAudioSourceType sourceType = (SHMiniZAudioSourceType)button.sourceType;
    
    // 1.切换按钮
    for (NSUInteger i = 0; i < self.sourceTypeScrollView.subviews.count; i++) {
        
        SHAudioSourceButton *autioButton = self.sourceTypeScrollView.subviews[i];
        
        autioButton.selected = (sourceType == (SHMiniZAudioSourceType)autioButton.sourceType);
    }
    
    switch (sourceType) {
            
        case SHMiniZAudioSourceTypeSDCARD: {
            
            if (self.currentAudio.sourceType != SHMiniZAudioSourceTypeSDCARD) {
                
                self.currentAudio.sourceType = SHMiniZAudioSourceTypeSDCARD;
                
                [SHAudioOperatorTools changeAudioSourceWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID musicSoureNumber:SHMiniAudioSoureNumberSdCard zoneFlag:self.currentAudio.zoneFlag
                 ];
                
            }
        }
            break;
            
        case SHMiniZAudioSourceTypeUDISK: {
            
            if (self.currentAudio.sourceType != SHMiniZAudioSourceTypeUDISK) {
                
                self.currentAudio.sourceType = SHMiniZAudioSourceTypeUDISK;
                
                [SHAudioOperatorTools changeAudioSourceWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID musicSoureNumber:SHMiniAudioSoureNumberUdisk zoneFlag:self.currentAudio.zoneFlag
                 ];
                
            }
        }
            break;
            
        case SHMiniZAudioSourceTypeBLUETOOTH: {
            
            if (self.currentAudio.sourceType != SHMiniZAudioSourceTypeBLUETOOTH) {
                
                self.currentAudio.sourceType = SHMiniZAudioSourceTypeBLUETOOTH;
                
                
                [SHAudioOperatorTools changeAudioSourceWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID musicSoureNumber:SHMiniAudioSoureNumberBluetooth zoneFlag:self.currentAudio.zoneFlag
                 ];
            }
        }
            break;
            
        case SHMiniZAudioSourceTypeRADIO: {
            
            if (self.currentAudio.sourceType != SHMiniZAudioSourceTypeRADIO) {
                
                self.currentAudio.sourceType = SHMiniZAudioSourceTypeRADIO;
                
                [SHAudioOperatorTools changeAudioSourceWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID musicSoureNumber:SHMiniAudioSoureNumberFMRadio zoneFlag:self.currentAudio.zoneFlag
                 ];
                
            }
        }
            break;
            
        default:
            break;
    }
    
    // 隐藏或显示相关的按钮 (播放与暂停/停止按钮都会显示出来)
    self.modelButton.hidden = YES;
    self.previousButton.hidden = NO;
    self.nextButton.hidden = NO;
    self.listScrollView.hidden = YES;
    self.radioChannelButtonsView.hidden =
    (sourceType != SHMiniZAudioSourceTypeRADIO);
    
    // 中间的空白
    self.audioinImageView.hidden =
    (sourceType == SHMiniZAudioSourceTypeRADIO);
    
    // bluetooth下不显示状态
    self.showPlayStatusView.hidden =
    (sourceType == SHMiniZAudioSourceTypeBLUETOOTH);;
}


/// 点击滑动scrollView
- (void)showScrollButtonClick {
    
    CGFloat offsetX =
    (self.listScrollView.contentOffset.x == 0) ?
    self.view.frame_width : 0 ;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.listScrollView.contentOffset =
        CGPointMake(offsetX, self.listScrollView.contentOffset.y);
    }];
    
    [self scrollViewDidEndDecelerating:self.listScrollView];
}


/// 读取音乐播放信息的状态
- (void)readAudioStatus {
    
    
    self.receivedStatusType = SHAudioReceivedStatusTypeOut;
    
    [SHAudioOperatorTools readAudioStatusWithSubNetID:self.currentAudio.subnetID
                                             deviceID:self.currentAudio.deviceID
     ];
}


// MARK: ====== - UIScrollView代理  ======


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //    printLog(@"偏移量 - %g", self.listScrollView.contentOffset.x);
    self.showPlayStatusView.frame_x =
    self.listScrollView.contentOffset.x;
    
    //    [self layoutAlbumSongsListView];
}


// MARK: ====== - UITableView代理  ======

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 开始选择专辑
    if (tableView == self.albumListTableView) {
        
        self.currentAudio.currentSelectAlbum =
            self.currentAudio.allAlbums[indexPath.row];
        
    } else if (tableView == self.currentAlbumSongsListTableView) {
        
        // 获得选择的歌曲
        self.currentAudio.currentSelectAlbum.currentSelectSong = self.currentAudio.currentSelectAlbum.totalAlbumSongs[indexPath.row];
        
    } else if (tableView == self.songQueueListTableView) {
        
        // 选择播放队列
        self.indexQueue = indexPath.row;
        self.isQueue = YES;
    }
}

/// 设置样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return
        (tableView == self.songQueueListTableView) ?
        UITableViewCellEditingStyleDelete :
        UITableViewCellEditingStyleNone;
}

/// 样式操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath {
    
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    if (tableView == self.songQueueListTableView) {
        
        TYCustomAlertView *alertView =
            [TYCustomAlertView alertViewWithTitle:nil
                                          message:@"Are you sure to delete song ?"
                                         isCustom:YES
            ];
        
        [alertView addAction: [TYAlertAction actionWithTitle:SHLanguageText.cancel style:TYAlertActionStyleDefault handler:nil]];
        
        [alertView addAction: [TYAlertAction actionWithTitle:SHLanguageText.ok style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
            
            SHAudio *audio =
                self.selectQueueSongs[indexPath.row];
            
            [self.selectQueueSongs removeObject:audio];
            
            [SHAudioOperatorTools saveQueueSongsWithSongs:self.selectQueueSongs subNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID sourceType:self.currentAudio.sourceType
             ];
            
            [tableView reloadData];
        }]];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
        
        alertController.backgoundTapDismissEnable = YES;
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

// MARK: - ====== 数据源 ======

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.albumListTableView) {
        
        SHAudioAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:albumCellReusableIdentifier forIndexPath:indexPath];
        
        cell.album = self.currentAudio.allAlbums[indexPath.row];
        
        return cell;
        
    } else if (tableView == self.currentAlbumSongsListTableView) {
        
        SHAudioAlbumSongCell *cell = [tableView dequeueReusableCellWithIdentifier:songCellReusableIdentifier forIndexPath:indexPath];
        
        cell.song = self.currentAudio.currentSelectAlbum.totalAlbumSongs[indexPath.row];
        
        return cell;
        
    } else if (tableView == self.songQueueListTableView) {  // 播放队列
        
        SHAudioAlbumSongCell *cell = [tableView dequeueReusableCellWithIdentifier:songCellReusableIdentifier forIndexPath:indexPath];
        
        cell.song = self.selectQueueSongs[indexPath.row];
        
        return cell;
        
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.albumListTableView) {  // 专辑列表
        
        return self.currentAudio.allAlbums.count;
        
    } else if (tableView == self.currentAlbumSongsListTableView) {  // 专辑歌曲列表
        
        return self.currentAudio.currentSelectAlbum.totalAlbumSongs.count;
        
    } else if (tableView == self.songQueueListTableView) { // 队列列表
        
        return self.selectQueueSongs.count;
        
    }
    
    return 0;
}


// MARK: - =======  UI布局 =======

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if ([UIDevice is_iPhoneX_More]) {
        
        self.bottomHeightConstraint.constant = defaultHeight;
    }
    
    [self layoutSourceTypeButtons];
    [self layoutAlbumSongsListView];
}

/// 布局中间的子控件
- (void)layoutAlbumSongsListView {
    
    // 正在播放的指示器
    CGFloat showPlayStatusHeight =
    [UIDevice is_iPad] ?
    (statusBarHeight + navigationBarHeight) :
    tabBarHeight;
    
    // 3.标题按钮的位置
    CGFloat controlButtonHeight =
    [UIDevice is_iPad] ?
    (navigationBarHeight + statusBarHeight) :
    tabBarHeight;
    
    CGFloat controlButtonPadding =
    [UIDevice is_iPad] ?
statusBarHeight: statusBarHeight * 0.5;
    
    // 区域选择
    self.zoneRefreshButton.frame =
    CGRectMake(0,
               0,
               (self.leftListHolderView.frame_width - 2 * controlButtonPadding) * 0.25,
               controlButtonHeight
               );
    
    // 选择专辑
    self.selectAlbumButton.frame =
    CGRectMake(self.zoneRefreshButton.frame_width +
               controlButtonPadding,
               0,
               self.zoneRefreshButton.frame_width * 2,
               controlButtonHeight
               );
    
    // 增加队列
    self.addToQueButton.frame =
    CGRectMake(CGRectGetMaxX(self.selectAlbumButton.frame) +
               controlButtonPadding,
               0,
               self.zoneRefreshButton.frame_width,
               controlButtonHeight
               );
    
    // 播放队列
    self.playQueButton.frame =
    CGRectMake(0,
               0,
               (self.rightHolderListView.frame_width - controlButtonPadding) * 0.5,
               controlButtonHeight
               );
    
    // 编辑队列
    self.editQueButton.frame =
    CGRectMake(self.playQueButton.frame_width +
               controlButtonPadding,
               0,
               self.playQueButton.frame_width,
               controlButtonHeight
               );
    
    // 4.两张大图片的位置
    CGFloat scale = 0.85;
    
    // 4.1 左图
    self.leftListImageView.frame =
    CGRectMake(0,
               controlButtonHeight +  controlButtonPadding,
               self.leftListHolderView.frame_width,
               self.leftListHolderView.frame_height -
               self.zoneRefreshButton.frame_height - controlButtonPadding
               
               );
    
    // 歌曲列表
    self.currentAlbumSongsListTableView.frame =
    CGRectMake(controlButtonPadding,
               controlButtonPadding,
               self.leftListImageView.frame_width * scale - controlButtonPadding,
               self.leftListImageView.frame_height - 2 * controlButtonPadding -
               showPlayStatusHeight
               );
    
    // 左图指示器
    self.showScrollRightButton.frame =
    CGRectMake(self.leftListImageView.frame_width * scale,
               self.leftListImageView.frame_height * 0.1,
               self.leftListImageView.frame_width * 0.1,
               self.leftListImageView.frame_height * 0.3
               
               );
    
    // 4.2 右图
    self.rightListImageView.frame =
    self.leftListImageView.frame;
    
    // 右图指示器
    self.showScrollLeftButton.frame =
    self.showScrollRightButton.frame;
    
    // 队列列表
    self.songQueueListTableView.frame =
    self.currentAlbumSongsListTableView.frame;
    
    // 5.专辑部分
    // 5.1 专辑的背景图片
    self.albumListBackgroundView.frame =
    CGRectMake(self.selectAlbumButton.frame_x,
               0,
               self.selectAlbumButton.frame_width,
               self.leftListImageView.frame_height * scale
               );
    
    // 5.2 专辑列表
    self.albumListTableView.frame =
    CGRectMake(0,
               0,
               self.albumListBackgroundView.frame_width,
               self.albumListBackgroundView.frame_height
               - self.selectAlbumButton.frame_height * scale - controlButtonPadding * 2
               );
    
    // 5.3 取消按钮
    self.cancelSelectAlbumButton.frame =
    CGRectMake(0,
               self.albumListTableView.frame_height + controlButtonPadding,(self.albumListBackgroundView.frame_width - controlButtonPadding) * 0.5,
               self.selectAlbumButton.frame_height * scale
               );
    
    // 5.4 确认按钮
    self.sureSelectAlbumButton.frame =
    self.cancelSelectAlbumButton.frame;
    
    self.sureSelectAlbumButton.frame_x =
    CGRectGetMaxX(self.cancelSelectAlbumButton.frame) +
    controlButtonPadding;
    
    // 6. ===== 收音机 ====
    self.radioChannelButtonsView.frame =
    self.audioSongsShowView.bounds;
    
    // 7. ==== 外接音乐 ======
    self.audioinImageView.frame =
    self.audioSongsShowView.bounds;
    
    // 8. ==== 设置音量调节器 ===
    
    self.volumeView.frame_width =
    self.audioSongsShowView.frame_width * scale;
    
    self.volumeView.frame_height =
    3 * ([UIDevice is_iPad] ? (navigationBarHeight + defaultHeight): navigationBarHeight);
    
    self.volumeView.frame_x =
    self.audioSongsShowView.frame_width * (1 - scale) * 0.5;
    
    self.volumeView.frame_y =
    (self.audioSongsShowView.frame_height - self.volumeView.frame_height) * 0.5;
    
    
    // 音乐播放状态
    self.showPlayStatusView.frame =
    CGRectMake(self.listScrollView.contentOffset.x,
               self.listScrollView.frame_height - showPlayStatusHeight,
               self.listScrollView.frame_width,
               showPlayStatusHeight
               );
    
    // 播放控制
    if ([UIDevice is_iPad]) {
        
        self.playControlViewHeightConstraint.constant =
        tabBarHeight + tabBarHeight;
    }
}

/// 设置顶部的音乐来源按钮
- (void)layoutSourceTypeButtons {
    
    if ([UIDevice is_iPad]) {
        
        self.sourceTypeHeightConstraint.constant =
        navigationBarHeight + defaultHeight;
    }
    
    self.sourceTypeScrollView.frame = self.audioSourceView.bounds;
    
    // 固定控件的个数显示4个
    Byte showSourceTypePerPage = 4;
    
    // 总多媒体设备个数
    NSUInteger totalAudioTypeCount = self.sourceTypeScrollView.subviews.count;
    
    // 计算按钮的大小
    const Byte padding = 5;
    
    if (totalAudioTypeCount <= showSourceTypePerPage) {
        
        showSourceTypePerPage = totalAudioTypeCount;
    }
    
    CGFloat buttonWidth =
    (self.audioSourceView.frame_width -
     (showSourceTypePerPage + 1) * padding) /
    (showSourceTypePerPage);
    
    CGFloat buttonHeight =
    self.audioSourceView.frame_height - padding;
    
    // 起始位置
    CGFloat startX =
    (self.audioSourceView.frame_width -
     showSourceTypePerPage * buttonWidth -
     (showSourceTypePerPage - 1) * padding) * 0.5;
    
    for (NSUInteger i = 0; i < totalAudioTypeCount; i++) {
        
        SHAudioSourceButton *button = self.sourceTypeScrollView.subviews[i];
        
        button.frame =
        CGRectMake(startX + (buttonWidth + padding) * i,
                   padding,
                   buttonWidth,
                   buttonHeight
                   );
    }
    
    self.sourceTypeScrollView.contentSize =
    CGSizeMake(
               padding + totalAudioTypeCount * (buttonWidth + padding),
               0
               );
}


// MARK: ====== - UI 界面 ======

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self layoutSourceTypeButtons];
    
    if (!self.currentAudio.isMiniZAudio) {
        [self selectAudioSourceButtonTouch:
         self.sourceTypeScrollView.subviews.firstObject];;
    }
}

/// 设置音乐设备的相关数据
- (void)updateFtpAudioDatas {
    
    if (self.currentAudio.sourceType != SHAudioSourceTypeSDCARD &&
        self.currentAudio.sourceType != SHAudioSourceTypeFTP) {
        
        return;
    }
    
    // 弹框选择更新FTP
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:([[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"UPDATE_FTP"]) message:([[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"PROMPT_MESSAGE_15"]) isCustom:YES];
    
    [alertView addAction: [TYAlertAction actionWithTitle:SHLanguageText.cancel style:TYAlertActionStyleCancel handler:nil]];
    
    [alertView addAction: [TYAlertAction actionWithTitle:SHLanguageText.ok style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        
        self.isUpdateFtpSuccess = NO;
        
        // 1.切换音乐来源
        [SHAudioOperatorTools changeAudioSourceWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID musicSoureNumber:SHAudioSoureNumberFtpServer zoneFlag:self.currentAudio.zoneFlag
         ];
        
        // 2.设置状态
        self.receivedStatusType = SHAudioReceivedStatusTypeUpdateList;
        
        // 3.发出更新指令
        [SHAudioOperatorTools updateAudioFtpServerDataWithSubNetID:self.currentAudio.subnetID deviceID:self.currentAudio.deviceID];
        
        // 4.执行回调 checkUpdateStatus // 2109
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown];
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self resignFirstResponder];
    
    self.cancelSendData = YES;
}

/// 设置界面
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.currentAudio.audioName;
    
    self.currentAudio.zoneFlag = 1;  //  默认使用1
    
    // 1.添加音乐来源视图
    [self setUpAudioSourceTypeView];
    
    self.listScrollView.delegate = self;
    
    // 3. 设置中间右边
    [self setupLeftListView];
    
    // 4. 左边的控件
    [self setupRightListView];
    
    // 5. 添加收音机
    [self setupRadioView];
    
    // 6.添加外接音乐
    [self setupAudioInView];
    
    // 7. 添加声音控件
    [self setupVolumeView];
    
    // 8. 添加状态显示栏
    [self setupPlayStatusView];
    
    //  添加导航右侧的设置
    //    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"setting" hightlightedImageName:@"setting" addTarget:self action:@selector(updateFtpAudioDatas) isLeft:NO];
    //
    //    if (self.currentAudio.isMiniZAudio ||
    //        !self.currentAudio.haveFtp ) {
    //        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    //    }
    
    // miniAudio没有播放模式
    self.modelButton.hidden = self.currentAudio.isMiniZAudio;
}


/// 设置中间左边的列表视图
- (void)setupLeftListView {
    
    // 3.添加标题按钮
    // 3.1 左图中的区域列表按钮
    UIButton *zoneRefreshButton = [SHAuioPlayTypeButton buttonWithImageName:@"refreshAudio_normal" highlightedImageName:@"refreshAudio_highlighted" backgroundImageName:@"audioButtonbackground"  highlightedBackgroundImageName:@"audioButtonbackground"  addTarget:self action:@selector(zoneRefreshButtonClick)];
    
    zoneRefreshButton.titleLabel.numberOfLines = 0;
    zoneRefreshButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.leftListHolderView addSubview:zoneRefreshButton];
    
    self.zoneRefreshButton = zoneRefreshButton;
    
    // 3.2 选择专辑按钮
    SHAudioSelectButton *selectAlbumButton = [SHAudioSelectButton buttonWithTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"ALBUMS_LIST"] font:([UIDevice is_iPad] ? [UIView suitFontForPad] : [UIFont systemFontOfSize:16]) normalTextColor:[UIView textWhiteColor] highlightedTextColor:[UIView highlightedTextColor] imageName:@"audioSelect" backgroundImageName:@"audioButtonbackground" addTarget:self action:@selector(selectAlbumButtonClick)];
    
    selectAlbumButton.titleLabel.numberOfLines = 0;
    selectAlbumButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.leftListHolderView addSubview:selectAlbumButton];
    self.selectAlbumButton = selectAlbumButton;
    
    // 3.4 增加队列
    UIButton *addToQueButton = [UIButton buttonWithTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"ADD_TO_QUE"] font:([UIDevice is_iPad] ? [UIView suitFontForPad] : [UIFont systemFontOfSize:16])  normalTextColor:[UIView textWhiteColor] highlightedTextColor:[UIView highlightedTextColor]imageName:nil backgroundImageName:@"audioButtonbackground" addTarget:self action:@selector(addToQueButtonClick)];
    [self.leftListHolderView addSubview:addToQueButton];
    self.addToQueButton = addToQueButton;
    
    addToQueButton.titleLabel.numberOfLines = 0;
    addToQueButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 4.1 添加左边的图片
    UIImageView *leftListImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songsBackground"]];
    [self.leftListHolderView addSubview:leftListImageView];
    leftListImageView.userInteractionEnabled = YES;
    self.leftListImageView = leftListImageView;
    
    // 4.2 添加指示器 ->  暂时取消队列播放功能
    UIButton *showScrollRightButton = [UIButton buttonWithTitle:nil font:nil normalTextColor:nil highlightedTextColor:nil imageName:nil backgroundImageName:@"scrollToRight" addTarget:self action:@selector(showScrollButtonClick)];
    [self.leftListImageView addSubview:showScrollRightButton];
    self.showScrollRightButton = showScrollRightButton;
    
    // 5.1 增加歌曲列表视图
    UITableView *songListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    songListTableView.backgroundColor = [UIColor clearColor];
    songListTableView.rowHeight =
    [SHAudioAlbumSongCell rowHeight];
    songListTableView.dataSource = self;
    songListTableView.delegate = self;
    songListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [songListTableView registerNib:[UINib nibWithNibName:songCellReusableIdentifier bundle:nil] forCellReuseIdentifier:songCellReusableIdentifier];
    [self.leftListImageView addSubview:songListTableView];
    self.currentAlbumSongsListTableView = songListTableView;
    
    
    // 选择专辑要放在最后，因为要在最上面
    // 3.3 专辑的选择列表
    // 3.3.1 背景
    UIImageView *albumListBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songsBackground"]];
    albumListBackgroundView.userInteractionEnabled = YES;
    [self.leftListImageView addSubview:albumListBackgroundView];
    self.albumListBackgroundView = albumListBackgroundView;
    self.albumListBackgroundView.hidden = YES;
    
    // 3.3.2 专辑列表视图
    UITableView *albumListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    albumListTableView.backgroundColor = [UIColor clearColor];
    albumListTableView.rowHeight =
    [SHAudioAlbumCell rowHeight];
    albumListTableView.dataSource = self;
    albumListTableView.delegate = self;
    
    albumListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.albumListBackgroundView addSubview:albumListTableView];
    self.albumListTableView = albumListTableView;
    
    
    [albumListTableView registerNib:[UINib nibWithNibName:albumCellReusableIdentifier bundle:nil] forCellReuseIdentifier:albumCellReusableIdentifier];
    
    // 3.3.3 两个按钮
    SHAudioSelectButton *cancelButton = [SHAudioSelectButton buttonWithTitle:SHLanguageText.cancel  font:([UIDevice is_iPad] ? [UIView suitFontForPad] : [UIFont systemFontOfSize:16]) normalTextColor:[UIView textWhiteColor] highlightedTextColor:[UIView highlightedTextColor]imageName:nil backgroundImageName:@"audioButtonbackground" addTarget:self action:@selector(selectAlbumNames:)];
    
    [self.albumListBackgroundView addSubview:cancelButton];
    self.cancelSelectAlbumButton = cancelButton;
    
    SHAudioSelectButton *sureButton = [SHAudioSelectButton buttonWithTitle:SHLanguageText.ok  font:([UIDevice is_iPad] ? [UIView suitFontForPad] : [UIFont systemFontOfSize:16]) normalTextColor:[UIView textWhiteColor] highlightedTextColor:[UIView highlightedTextColor]imageName:nil backgroundImageName:@"audioButtonbackground" addTarget:self action:@selector(selectAlbumNames:)];
    
    [self.albumListBackgroundView addSubview:sureButton];
    self.sureSelectAlbumButton = sureButton;
    
    // miniZAudio 暂时不支持读取列表
    if (self.currentAudio.isMiniZAudio) {
        
        self.leftListImageView.hidden = YES;
        self.zoneRefreshButton.hidden = YES;
        self.addToQueButton.hidden = YES;
        self.selectAlbumButton.hidden = YES;
    }
}

/// 设置中间右边
- (void)setupRightListView {
    
    // 3.4 播放队列按钮
    UIButton *playQueButton = [UIButton buttonWithTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"PLAY_QUE"]  font:([UIDevice is_iPad] ? [UIView suitFontForPad] : [UIFont systemFontOfSize:16]) normalTextColor:[UIView textWhiteColor] highlightedTextColor:[UIView highlightedTextColor]imageName:nil backgroundImageName:@"audioButtonbackground" addTarget:self action:@selector(playQueButtonClick)];
    [self.rightHolderListView addSubview:playQueButton];
    self.playQueButton = playQueButton;
    
    // 3.5.编辑队列
    UIButton *editQueButton = [UIButton buttonWithTitle:SHLanguageText.edit font:([UIDevice is_iPad] ? [UIView suitFontForPad] : [UIFont systemFontOfSize:16]) normalTextColor:[UIView textWhiteColor] highlightedTextColor:[UIView highlightedTextColor]imageName:nil backgroundImageName:@"audioButtonbackground" addTarget:self action:@selector(editQueButtonClick)];
    [self.rightHolderListView addSubview:editQueButton];
    self.editQueButton = editQueButton;
    
    // 4.添加展示图片
    // 4.2 添加右边的图片
    UIImageView *rightListImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songsBackground"]];
    [self.rightHolderListView addSubview:rightListImageView];
    rightListImageView.userInteractionEnabled = YES;
    self.rightListImageView = rightListImageView;
    
    // 暂时取消队列播放功能
    UIButton *showScrollLeftButton = [UIButton buttonWithTitle:nil font:nil normalTextColor:nil highlightedTextColor:nil imageName:nil backgroundImageName:@"scrollToLeft" addTarget:self action:@selector(showScrollButtonClick)];
    [self.rightListImageView addSubview:showScrollLeftButton];
    self.showScrollLeftButton = showScrollLeftButton;
    
    // 5.2 songQueListTableView 增加队列列表
    UITableView *songQueueListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    songQueueListTableView.backgroundColor = [UIColor clearColor];
    songQueueListTableView.rowHeight =
    [SHAudioAlbumSongCell rowHeight];
    songQueueListTableView.dataSource = self;
    songQueueListTableView.delegate = self;
    songQueueListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [songQueueListTableView registerNib:[UINib nibWithNibName:songCellReusableIdentifier bundle:nil] forCellReuseIdentifier:songCellReusableIdentifier];
    [self.rightListImageView addSubview:songQueueListTableView];
    self.songQueueListTableView = songQueueListTableView;
}

/// 设置声音控件
- (void)setupVolumeView {
    
    SHAudioVolumeView *volumeView =
    [SHAudioVolumeView volumeView];
    
    [self.audioSongsShowView addSubview:volumeView];
    
    volumeView.audio = self.currentAudio;
    volumeView.hidden = true;
    self.volumeView = volumeView;
}

/// 添加音乐播放状态的视图
- (void)setupPlayStatusView {
    
    SHAudioPlayStatusView *showPlayView =
    
    [SHAudioPlayStatusView showAudioPlayStatusView];
    
    [self.listScrollView addSubview:showPlayView];
    
    self.showPlayStatusView = showPlayView;
}

/// 添加外接音乐
- (void)setupAudioInView {
    
    SHAudioInView *audioinImageView =
    [SHAudioInView audioInView];
    
    [self.audioSongsShowView addSubview:audioinImageView];
    
    audioinImageView.audio = self.currentAudio;
    
    self.audioinImageView = audioinImageView;
    self.audioinImageView.hidden = YES;
}

/// 添加收音机
- (void)setupRadioView {
    
    SHAudioRadioView *radioChannelButtonsView =
    [[SHAudioRadioView alloc] init];
    
    [self.audioSongsShowView
     addSubview:radioChannelButtonsView];
    
    radioChannelButtonsView.audio = self.currentAudio;
    self.radioChannelButtonsView = radioChannelButtonsView;
    self.radioChannelButtonsView.hidden = YES;
}

/// 添加音乐来源
- (void)setUpAudioSourceTypeView {
    
    UIScrollView *sourceTypeScrollView = [[UIScrollView alloc] init];
    sourceTypeScrollView.pagingEnabled = YES;
    sourceTypeScrollView.showsVerticalScrollIndicator = NO;
    sourceTypeScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.audioSourceView addSubview:sourceTypeScrollView];
    self.sourceTypeScrollView = sourceTypeScrollView;
    
    if (self.currentAudio.isMiniZAudio) {
        
        // 1.sdcard
        if (self.currentAudio.haveSdCard) {
            
            SHAudioSourceButton *cardButton = [SHAudioSourceButton audioButtonWithType:SHMiniZAudioSourceTypeSDCARD title:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"REMAINING" withSubTitle:@"A_SD_CARD"] normalImageName:@"saCard_normal" selectImageName:@"saCard_highlighted" addTarget:self action:@selector(selectMiniZAudioSourceButtonTouch:)];
            
            cardButton.tag = SHMiniZAudioSourceTypeSDCARD;
            
            [self.sourceTypeScrollView addSubview:cardButton];
        }
        
        // 2.udisk - mini
        if (self.currentAudio.haveUdisk) {
            
            NSString *title = [UIDevice isChinese] ? @"U盘" : @"UDISK";
            
            SHAudioSourceButton *udiskButton = [SHAudioSourceButton audioButtonWithType:SHMiniZAudioSourceTypeUDISK title:title normalImageName:@"audioin_normal" selectImageName:@"audioin_highlighted" addTarget:self action:@selector(selectMiniZAudioSourceButtonTouch:)];
            
            udiskButton.tag = SHMiniZAudioSourceTypeUDISK;
            [self.sourceTypeScrollView addSubview:udiskButton];
        }
        
        
        // 3.Bluetooth - mini
        if (self.currentAudio.haveBluetooth) {
            
            NSString *title = [UIDevice isChinese] ? @"蓝牙" : @"BLUETOOTH";
            
            SHAudioSourceButton *bluetoothButton = [SHAudioSourceButton audioButtonWithType:SHMiniZAudioSourceTypeBLUETOOTH title:title normalImageName:@"phone_normal" selectImageName:@"phone_highlighted" addTarget:self action:@selector(selectMiniZAudioSourceButtonTouch:)];
            
            bluetoothButton.tag = SHMiniZAudioSourceTypeBLUETOOTH;
            [self.sourceTypeScrollView addSubview:bluetoothButton];
        }
        
        // 4. radio
        if (self.currentAudio.haveRadio) {
            
            SHAudioSourceButton *radioButton = [SHAudioSourceButton audioButtonWithType:SHMiniZAudioSourceTypeRADIO title:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"REMAINING" withSubTitle:@"D_RADIO"] normalImageName:@"radio_normal" selectImageName:@"radio_highlighted" addTarget:self action:@selector(selectMiniZAudioSourceButtonTouch:)];
            
            radioButton.tag = SHMiniZAudioSourceTypeRADIO;
            [self.sourceTypeScrollView addSubview:radioButton];
        }
        
        return;
    }
    
    // 1.sdcard
    if (self.currentAudio.haveSdCard) {
        
        SHAudioSourceButton *cardButton = [SHAudioSourceButton audioButtonWithType:SHAudioSourceTypeSDCARD title:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"REMAINING" withSubTitle:@"A_SD_CARD"] normalImageName:@"saCard_normal" selectImageName:@"saCard_highlighted" addTarget:self action:@selector(selectAudioSourceButtonTouch:)];
        
        cardButton.tag = SHAudioSourceTypeSDCARD;
        
        [self.sourceTypeScrollView addSubview:cardButton];
    }
    
    
    // 2.ftp
    if (self.currentAudio.haveFtp) {
        
        SHAudioSourceButton *ftpButton = [SHAudioSourceButton audioButtonWithType:SHAudioSourceTypeFTP title:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"REMAINING" withSubTitle:@"B_NETWORK"] normalImageName:@"ftp_normal" selectImageName:@"ftp_highlighted" addTarget:self action:@selector(selectAudioSourceButtonTouch:)];
        
        ftpButton.tag = SHAudioSourceTypeFTP;
        
        [self.sourceTypeScrollView addSubview:ftpButton];
    }
    
    // 3. radio
    if (self.currentAudio.haveRadio) {
        
        SHAudioSourceButton *radioButton = [SHAudioSourceButton audioButtonWithType:SHAudioSourceTypeRADIO title:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"REMAINING" withSubTitle:@"D_RADIO"] normalImageName:@"radio_normal" selectImageName:@"radio_highlighted" addTarget:self action:@selector(selectAudioSourceButtonTouch:)];
        
        radioButton.tag = SHAudioSourceTypeRADIO;
        [self.sourceTypeScrollView addSubview:radioButton];
    }
    
    // 4. audioin
    if (self.currentAudio.haveAudioIn) {
        
        SHAudioSourceButton *audioButton = [SHAudioSourceButton audioButtonWithType:SHAudioSourceTypeAUDIOIN title:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"REMAINING" withSubTitle:@"E_AUDIO_IN"] normalImageName:@"audioin_normal" selectImageName:@"audioin_highlighted" addTarget:self action:@selector(selectAudioSourceButtonTouch:)];
        
        audioButton.tag = SHAudioSourceTypeAUDIOIN;
        
        [self.sourceTypeScrollView addSubview:audioButton];
    }
    
    
    // 5.Phone == 这个功能没有，为了避免产生其它问题，暂时直接不显示
    //    if (self.currentAudio.havePhone) {
    //
    //        SHAudioSourceButton *phoneButton = [SHAudioSourceButton audioButtonWithType:SHAudioSourceTypePONE title:@"PHONE" normalImageName:@"phone_normal" selectImageName:@"phone_highlighted" addTarget:self action:@selector(selectAudioSourceButtonTouch:)];
    //
    //        phoneButton.userInteractionEnabled = NO; // 这个功能暂时没有
    //        phoneButton.tag = SHAudioSourceTypePONE;
    //        [self.sourceTypeScrollView addSubview:phoneButton];
    //    }
}


/// 移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[SHAudioPlayStatusView showAudioPlayStatusView]
     setHiddenPlayInfo:YES
     ];
}

// MARK: - getter && setter

- (NSMutableString *)recivedStringList {
    
    if (!_recivedStringList) {
        
        _recivedStringList = [NSMutableString string];
    }
    
    return _recivedStringList;
}

- (NSMutableArray *)selectQueueSongs {
    
    if (!_selectQueueSongs) {
        
        _selectQueueSongs = [NSMutableArray array];
    }
    return _selectQueueSongs;
}

@end
