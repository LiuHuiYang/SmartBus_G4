//
//  SHSchedualAudioViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/9.
//  Copyright © 2018年 SmartHome. All rights reserved.
/*
    5> 歌曲的保存与同步
 */

#import "SHScheduleAudioViewDetailController.h"
#import "SHAudioSelectButton.h"

/// 专辑重用标示符
static NSString *albumCellReusableIdentifier =
    @"SHAudioAlbumCell";

/// 歌曲重用标示符
static NSString *songCellReusableIdentifier =
    @"SHAudioAlbumSongCell";

@interface SHScheduleAudioViewDetailController () <UITableViewDelegate, UITableViewDataSource>

// MARK: - 约束

/// 顶部分组的视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topGroupViewHeightConstraint;

/// 宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subViewWidthConstraint;

/// 高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subViewHeightConstraint;

// MARK: - 界面上的属性

/// 声音按钮
@property (weak, nonatomic) IBOutlet UIButton *volumeButton;

/// 声音滑块
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

/// 声音的百分比
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

    
/// 专辑列表的背景视图
@property (weak, nonatomic) IBOutlet UIView * albumListBackgroundView;

/// 专辑列表
@property (weak, nonatomic) IBOutlet UITableView *albumListView;

/// 音乐列表
@property (weak, nonatomic) IBOutlet UITableView *songListView;

/// 选择专辑按钮
@property (weak, nonatomic) IBOutlet SHAudioSelectButton *selectAlbumButton;

/// 音乐来源 
@property (weak, nonatomic) IBOutlet UISegmentedControl *sourceTypeSegmentedControl;

/// 播放控制选项卡
@property (weak, nonatomic) IBOutlet UISegmentedControl *playStatusSegmentedControl;

@end

@implementation SHScheduleAudioViewDetailController
    

// MARK: - 音乐专辑的处理


/// 选择专辑按钮点击
- (IBAction)selectAlbumButtonClick {
    
    self.albumListBackgroundView.hidden = !self.albumListBackgroundView.hidden;
}


/// 刷新加载数据
- (IBAction)refreshButtonClick {
    
    if (self.schedualAudio.schedualSourceType != SHAudioSourceTypeSDCARD &&
        self.schedualAudio.schedualSourceType != SHAudioSourceTypeFTP) {
        
        return;
    }
    
    // 删除数据
    [SHAudioOperatorTools deletePlistWithSubNetID:self.schedualAudio.subnetID deviceID:self.schedualAudio.deviceID sourceType:self.schedualAudio.schedualSourceType];
    
    [self showAlbumList:self.schedualAudio.subnetID
               deviceID:self.schedualAudio.deviceID
             sourceType:self.schedualAudio.schedualSourceType
            albumNumber:1
               readSong:YES
     ];
}


// MARK: - 声音部分 && 播放状态 && 音乐来源

/// 设置播放状态点击
- (IBAction)playStautsSegmentedControlClick {
  
    self.schedualAudio.schedualPlayStatus = (!self.playStatusSegmentedControl.selectedSegmentIndex) ? SHAudioPlayControlTypePlay : SHAudioPlayControlTypeStop;
}

/// 选择音乐来源
- (IBAction)sourceSegmentedControlClick {
    
    self.schedualAudio.schedualSourceType = (!self.sourceTypeSegmentedControl.selectedSegmentIndex) ? SHAudioSourceTypeSDCARD : SHAudioSourceTypeFTP;
    
    [self showAlbumList:self.schedualAudio.subnetID
               deviceID:self.schedualAudio.deviceID
             sourceType:self.schedualAudio.schedualSourceType
            albumNumber:self.schedualAudio.schedualPlayAlbumNumber
               readSong:YES
    ];
}

/// 点击声音按钮
- (IBAction)volumeButtonClick {
    
    self.volumeButton.selected = !self.volumeButton.selected;
    
    self.volumeSlider.value = self.volumeButton.selected ? self.volumeSlider.maximumValue : self.volumeSlider.minimumValue;
    
    [self volumeSliderChange];
}
    
    /// 声音选择
- (IBAction)volumeSliderChange {
    
    // 获得值
    Byte volum = self.volumeSlider.value;
    
    self.volumeLabel.text = [NSString stringWithFormat:@"%d%%", volum];
    
    self.volumeButton.selected = volum != 0;
    
    self.schedualAudio.schedualVolumeRatio = volum;
    
    [self testSchedul];
}

    
// MARK: - 导航栏
    
/// 关闭界面
- (void)close {
    
    
    [self.navigationController popViewControllerAnimated:true];
}


/**
 测试验证
 */
- (void)testSchedul {
    
    printLog("配置的音乐选项: src: %d - P/S:%d - vol: %d\n album: %d - No: %zd",
             self.schedualAudio.schedualSourceType,
             self.schedualAudio.schedualPlayStatus,
             self.schedualAudio.schedualVolumeRatio,
             self.schedualAudio.schedualPlayAlbumNumber,
             self.schedualAudio.schedualPlaySongNumber);
}

/// 退出界面时 不要再请求音乐数据
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.schedualAudio.cancelSendData = YES;
    
    self.schedualAudio.schedualPlayAlbumNumber =
        self.schedualAudio.currentSelectAlbum.albumNumber;
    
    self.schedualAudio.schedualPlaySongNumber = self.schedualAudio.currentSelectAlbum.currentSelectSong.songNumber;
    
    
    [self testSchedul];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self testSchedul];
    
    self.schedualAudio.isUpdateSchedualCommand = false;
    
    [self setDefaultStatus];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if ([UIDevice is_iPad]) {
        
        self.topGroupViewHeightConstraint.constant = statusBarHeight + navigationBarHeight;
        self.subViewWidthConstraint.constant = navigationBarHeight;
        self.subViewHeightConstraint.constant = navigationBarHeight;
    }
}

    
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"Schedule Audio";
    
    // 替换图片
    [self.volumeSlider setThumbImage:[UIImage getClearColorImage:CGSizeMake(7, 15)] forState:UIControlStateNormal];
    
    [self.volumeSlider setThumbImage:[UIImage getClearColorImage:CGSizeMake(7, 15)] forState:UIControlStateHighlighted];
    
    self.volumeSlider.transform = CGAffineTransformMakeScale(1.0, [UIDevice is_iPad] ? 15.0 : 5.0);
    
    [self.selectAlbumButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"ALBUMS_LIST"] forState:UIControlStateNormal];
    
    self.albumListBackgroundView.hidden = YES;
    
    // 初始化列表
    
    self.albumListView.rowHeight = [SHAudioAlbumCell rowHeight];
    self.songListView.rowHeight = [SHAudioAlbumSongCell rowHeight];
    
    [self.albumListView registerNib:[UINib nibWithNibName:albumCellReusableIdentifier bundle:nil] forCellReuseIdentifier:albumCellReusableIdentifier];
    
    [self.songListView registerNib:[UINib nibWithNibName:songCellReusableIdentifier bundle:nil] forCellReuseIdentifier:songCellReusableIdentifier];
    
    if ([UIDevice is_iPad]) {
        
        self.selectAlbumButton.titleLabel.font = [UIView suitFontForPad];
        self.volumeLabel.font = [UIView suitFontForPad];
        
        [self.playStatusSegmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIView suitFontForPad]} forState:UIControlStateNormal];
        [self.sourceTypeSegmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIView suitFontForPad]} forState:UIControlStateNormal];
    }
}

/// 设置初始状态
- (void)setDefaultStatus {
    
    // 设置音量
    self.volumeSlider.value = self.schedualAudio.schedualVolumeRatio;
    
    [self volumeSliderChange];

    // 设置播放状态
    if (!self.schedualAudio.schedualPlayStatus) {
        
        self.playStatusSegmentedControl.selectedSegmentIndex = -1;
    
    } else {
        
        self.playStatusSegmentedControl.selectedSegmentIndex = (self.schedualAudio.schedualPlayStatus == SHAudioPlayControlTypeStop);
        
        [self playStautsSegmentedControlClick];
    }
    
    // 设置SD卡
    if (!self.schedualAudio.schedualSourceType) {
        
        self.sourceTypeSegmentedControl.selectedSegmentIndex = -1;
    
    } else {
    
        self.sourceTypeSegmentedControl.selectedSegmentIndex = (self.schedualAudio.schedualSourceType == SHAudioSourceTypeFTP);
        
        [self sourceSegmentedControlClick];
    }
}


// MARK: - 数据源与代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.albumListView) {
        
        self.albumListBackgroundView.hidden = YES;
        
        // 当前选择专辑
        SHAlbum *album =
            self.schedualAudio.allAlbums[indexPath.row];
        
        [self.selectAlbumButton setTitle:album.albumName
                                forState:UIControlStateNormal
        ];
        
        self.schedualAudio.currentSelectAlbum = album;
        
        // 加载当前选择专辑的歌曲
        [self showSongList:self.schedualAudio.subnetID deviceID:self.schedualAudio.deviceID sourceType:self.schedualAudio.schedualSourceType songAlbumNumber:album.albumNumber];
 
        
    } else if (tableView == self.songListView) {
        
        // 当前选择的歌曲
        SHSong *song =
        self.schedualAudio.currentSelectAlbum.totalAlbumSongs[indexPath.row];
       
       self.schedualAudio.currentSelectAlbum.currentSelectSong =
        song;
        
        printLog(@"音乐名称： %@, %zd",
                 song.songName,
                 song.songNumber);
    }
}

// MARK: - 数据源

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.albumListView) {
        
        SHAudioAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:albumCellReusableIdentifier forIndexPath:indexPath];
        
        cell.album = self.schedualAudio.allAlbums[indexPath.row];
        
        return cell;
        
    } else if (tableView == self.songListView) {
        
        SHAudioAlbumSongCell *cell = [tableView dequeueReusableCellWithIdentifier:songCellReusableIdentifier forIndexPath:indexPath];
        
        cell.song = self.schedualAudio.currentSelectAlbum.totalAlbumSongs[indexPath.row];
        
        return cell;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.albumListView) {  // 专辑列表
        
        return self.schedualAudio.allAlbums.count;
        
    } else if (tableView == self.songListView) {  // 专辑歌曲列表
        
        return self.schedualAudio.currentSelectAlbum.totalAlbumSongs.count;
    }
    
    return 0;
}

// MARK: - 显示音乐与专辑数据

/**
 显示音乐专辑列表
 
 @param subNetID 子网ID
 @param deviceID 设备ID
 @param sourceType 音乐类型
 @param songAlbumNumber 歌曲的专辑号序号
 */
- (void)showSongList:(Byte)subNetID
            deviceID:(Byte)deviceID
          sourceType:(Byte)sourceType
     songAlbumNumber:(Byte)songAlbumNumber {
    
    [SVProgressHUD showWithStatus:@"Loading Data ..."];
    
    NSString *songPath =
        [SHAudioOperatorTools getAudioPathWithSubNetID:subNetID
                                              deviceID:deviceID
                                            sourceType:sourceType
                                              fileType:SHAudioSourceFileTypeSongs
                                          serialNumber:songAlbumNumber
        ];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:songPath]) {
        
        self.schedualAudio.currentSelectAlbum.totalAlbumSongs =
            [SHAudioTools  readPlist:songPath];
        
        [self.songListView reloadData];
        
        [SVProgressHUD dismiss];
        
        self.view.userInteractionEnabled = YES;
        
        
        // 如果不是同一个专辑不要显示已选歌曲
        if (self.schedualAudio.schedualPlayAlbumNumber != self.schedualAudio.currentSelectAlbum.albumNumber) {
            
            return;
        }
        
        if (!self.schedualAudio.schedualPlaySongNumber) {
            return;
        }
        
        NSIndexPath *indexPath =
        
        [NSIndexPath indexPathForRow:(self.schedualAudio.schedualPlaySongNumber - 1)
                           inSection:0
         ];
        
        [self.songListView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [self tableView:self.songListView didSelectRowAtIndexPath:indexPath];
        
        /*
         //  选择第一个
         self.schedualAudio.schedualAlbum.currentSelectSong =
         self.schedualAudio.schedualAlbum.totalAlbumSongs
         [self.schedualAudio.schedualPlaySongNumber - 1];
         */
        
    } else {
        
        // 1.请求数据
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
        
        self.schedualAudio.receivedStatusType = SHAudioReceivedStatusTypeReadSongPackages;
        self.schedualAudio.reSendCount = 0;
        
        self.schedualAudio.currentCategoryNumber = songAlbumNumber;
        
        [self sendControlAudioData:sendData];
        
        // UI的处理上
        self.schedualAudio.currentSelectAlbum.totalAlbumSongs = @[];
        [self.songListView reloadData];
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
- (void)showAlbumList:(Byte)subNetID
             deviceID:(Byte)deviceID
           sourceType:(Byte)sourceType
          albumNumber:(Byte)albumNumber
             readSong:(BOOL)readSong {
    
    [SVProgressHUD showWithStatus:@"Loading Data ..."];
    
    // 此时是不能交互的 禁止点击
    self.view.userInteractionEnabled = NO;
    
    // 1.获得路径
    NSString *albumPlistFilePath =
        [SHAudioOperatorTools getAudioPathWithSubNetID:subNetID deviceID:deviceID sourceType:sourceType fileType:SHAudioSourceFileTypeAlbum serialNumber:0
        ];
    
    // 2.判断文件是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:albumPlistFilePath]) {
        
        // 获得所有的专辑
        self.schedualAudio.allAlbums =
            [SHAudioTools readPlist:albumPlistFilePath];
        
        [self.albumListView reloadData];
        
        // 如果有配置，显示配置，如果没有配置，选择第一个
        albumNumber =
            albumNumber ? (albumNumber - 1) : albumNumber;

        NSIndexPath *indexPath =
            [NSIndexPath indexPathForRow:albumNumber
                               inSection:0
            ];

        [self.albumListView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];

        [self tableView:self.albumListView didSelectRowAtIndexPath:indexPath];
 
//        if (readSong) {
//
//            [self showSongList:subNetID
//                      deviceID:deviceID
//                    sourceType:sourceType
//               songAlbumNumber:1
//            ];
//        }
        
    } else {
        
        // 1 ==== 请求数据
        SHAudioSendData *sendData = [[SHAudioSendData alloc] init];
        sendData.subNetID = subNetID;
        sendData.deviceID = deviceID;
        sendData.sourceType = sourceType;
        sendData.operatorCode = 0x02E0;
        sendData.packageNumber = 1;
        sendData.packageTotal = 1;
        sendData.categoryNumber = albumNumber;
        
        sendData.additionalData = @[@(sourceType)];
        
        self.schedualAudio.receivedStatusType = SHAudioReceivedStatusTypeReadTotalPackages;
        self.schedualAudio.reSendCount = 0;
        
        [self sendControlAudioData:sendData];
        
        // 2 ===== UI上的处理
        [self.selectAlbumButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"ALBUMS_LIST"] forState:UIControlStateNormal];
        
        // 清空数据
        self.schedualAudio.allAlbums = @[];
        self.schedualAudio.schedualPlaySongNumber = 0;
        self.schedualAudio.schedualPlayAlbumNumber = 0;
        
        [self.albumListView reloadData];

        // 清空列表对应的歌曲
        self.schedualAudio.currentSelectAlbum.totalAlbumSongs = @[];
        [self.songListView reloadData];
    }
}
    
// MARK: - 请求数据后的解析(只是显示歌曲， 不需要状态)

/// 收到广播
- (void)analyzeReceivedSocketData:(SHSocketData *)socketData {
    
    if (socketData.subNetID != self.schedualAudio.subnetID ||
        socketData.deviceID != self.schedualAudio.deviceID) {
        return;
    }
    
    NSUInteger count = socketData.additionalData.count;
    Byte recivedData[count];
    
    for (int i = 0; i < count; i++) {
        
        recivedData[i] =
        ([socketData.additionalData[i] integerValue]) & 0xFF;
    }
    
    // 依据不同的状态来进行处理
    switch (self.schedualAudio.receivedStatusType) {
        
        case SHAudioReceivedStatusTypeReadTotalPackages: {
            
            if (recivedData[0] == self.schedualAudio.schedualSourceType
                &&
                socketData.operatorCode == 0x02E1) {
                
                self.schedualAudio.receivedStatusType = SHAudioReceivedStatusTypeOut;
                self.schedualAudio.totalPackages = recivedData[1];
                self.schedualAudio.isReceivedAudioData = YES;
            }
        }
            break;  // OK
            
        case SHAudioReceivedStatusTypeReadAlbumList:{
            
            //11 源号  12大包号
            if (recivedData[2] ==
                self.schedualAudio.schedualSourceType  &&
                socketData.operatorCode == 0x02E3      &&
                recivedData[3] == self.schedualAudio.currentPackageNumber) {
               
                self.schedualAudio.receivedStatusType = SHAudioReceivedStatusTypeOut;
                self.schedualAudio.isReceivedAudioData = YES;
                
                NSUInteger albumDataLength =
                    recivedData[0] * 0XFF +recivedData[1] - 5;
                
                NSArray *albumNames =
                [SHAudioTools getNameFrom:[NSData dataWithBytes:&recivedData[5] length:albumDataLength]
                                  isAlbum:YES
                                    count:recivedData[4]
                 ];
                
                NSString *albumName = [albumNames componentsJoinedByString:@""];
                
                [self.schedualAudio.recivedStringList appendFormat:@"%@",albumName];
                
                if (recivedData[3] == self.schedualAudio.totalPackages) {
                    
                    [SHAudioTools parseNameList:socketData.subNetID
                                       deviceID:socketData.deviceID
                                     sourceType:recivedData[2]
                                       nameList:self.schedualAudio.recivedStringList isAlbum:YES
                             currentAlbumNumber:0];
                    
                    
                    self.schedualAudio.recivedStringList = [NSMutableString string];
                }
            }
        }
            break;  // OK
            
        case SHAudioReceivedStatusTypeReadSongPackages:{
            if (recivedData[0] ==
                self.schedualAudio.schedualSourceType &&
                socketData.operatorCode == 0x02E5 &&
                self.schedualAudio.currentCategoryNumber == recivedData[1]) {
                
                self.schedualAudio.receivedStatusType = SHAudioReceivedStatusTypeOut;
                self.schedualAudio.totalPackages = recivedData[2];
                self.schedualAudio.isReceivedAudioData = YES;
            }
        }
            break;  // OK
            
        case SHAudioReceivedStatusTypeReadSongList:{
            
            // 确定是当前设备来源正在返回请求的歌曲名称
            if (recivedData[2] ==
                self.schedualAudio.schedualSourceType &&
                socketData.operatorCode == 0x02E7                                      &&
                recivedData[3] == self.schedualAudio.currentCategoryNumber
                ) {
                
                // 请求包号与返回一致
                if (recivedData[4] == self.schedualAudio.currentPackageNumber) {
                    
                    self.schedualAudio.receivedStatusType = SHAudioReceivedStatusTypeOut;
                    self.schedualAudio.isReceivedAudioData = YES;
                    
                    NSUInteger songNameLength =
                    recivedData[0] * 0XFF + recivedData[1] - 6;
                    
                    if (songNameLength < 3 &&
                        recivedData[4] != self.schedualAudio.totalPackages) {
                        //还没完呢，包就空了，错误
                        
                        self.schedualAudio.isReceivedAudioData = NO;
                        printLog(@"提前空包");
                        return;
                    }
                    
                    if (recivedData[4] != 1 &&
                        songNameLength > 3) {
                        
                        if ((recivedData[6] * 0XFF +
                             recivedData[7]) -
                            self.schedualAudio.errorSongNameNumber > 5) {
                            printLog(@"拼接不对");
                            self.schedualAudio.isReceivedAudioData = NO;
                            return;
                        }
                    }
                    
                    NSArray *songNames =
                    [SHAudioTools getNameFrom:
                     [NSData dataWithBytes:&recivedData[6]
                                    length:songNameLength]
                                      isAlbum:NO
                                        count:recivedData[5]
                     ];
                    
                    NSString *songName = [songNames componentsJoinedByString:@""];
                    
                    [self.schedualAudio.recivedStringList appendFormat:@"%@",songName];
                    
                    // printLog(@"当前音乐名称: %@", self.recivedStringList);
                    
                    /// 拼接完成
                    if (recivedData[4] == self.schedualAudio.totalPackages) {
                        
                        
                        [SHAudioTools parseNameList:socketData.subNetID
                                           deviceID:socketData.deviceID
                                         sourceType:recivedData[2]
                                           nameList:self.schedualAudio.recivedStringList
                                            isAlbum:NO
                                 currentAlbumNumber:recivedData[3]
                         ];
                        
                        self.schedualAudio.recivedStringList = [NSMutableString string];
                        self.schedualAudio.errorSongNameNumber = 0;
                        
                        
                        //下面部分为了防止出现包拼接错误，和包内容错误
                        //后面还有包，判断包拼接是否正确
                        
                    } else {
                        
                        self.schedualAudio.errorSongNameNumber = recivedData[5] +
                        recivedData[6] * 0xFF + recivedData[7] + 3;
                    }
                    
                } else { // 当前请求包号不一致
                    
                    printLog(@"=== 当前请求包号不一致 接收到信息===");
                    printLog(@"当前包号: %d\n请求包号: %zd\n总包号: %zd",
                             recivedData[4],
                             self.schedualAudio.currentPackageNumber,
                             self.schedualAudio.totalPackages
                             );
                    
                    // FIXME: - 音乐空包 以后如果出现其它情况，则可能需要修改固件
                    // 这个条件只适用于 80S专辑最后一个是空包的情况，其它情况都是不可用的
                    // 空包时 固件返回的广播不完整，数据也不匹配
                    // 只能临时这样判断
                    if ((count == 4) &&
                        (self.schedualAudio.currentPackageNumber == self.schedualAudio.totalPackages)) {
                        
                        self.schedualAudio.receivedStatusType = SHAudioReceivedStatusTypeOut;
                        self.schedualAudio.isReceivedAudioData = YES;
                        
                        [SHAudioTools parseNameList:socketData.subNetID
                                           deviceID:socketData.deviceID
                                         sourceType:recivedData[2]
                                           nameList:self.schedualAudio.recivedStringList
                                            isAlbum:NO
                                 currentAlbumNumber:recivedData[3]
                         ];
                        
                        self.schedualAudio.recivedStringList = [NSMutableString string];
                        self.schedualAudio.errorSongNameNumber = 0;
                    }
                }
            }
        }
            break;
            
        default:
            break;
    }
}

// MARK: - 请求数据的重发机制
    
/// 发送数据
- (void)sendControlAudioData:(SHAudioSendData *)sendData {
    
    if (self.schedualAudio.cancelSendData) {
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
    
    self.schedualAudio.isReceivedAudioData = NO;
    
    [self performSelector:@selector(reSendControlAudioData:)
               withObject:sendData
               afterDelay:1.5];
}
    
/// 重新发送数据
-(void)reSendControlAudioData:(SHAudioSendData *)sendData {
    
    /// 取消发送消息
    if (self.schedualAudio.cancelSendData) {
        return;
    }
    
    if (self.schedualAudio.isReceivedAudioData) {
        
        self.schedualAudio.reSendCount = 0;
        self.schedualAudio.isReceivedAudioData = NO;
        [self sendStartNewData:sendData];
        
    } else {
        
        self.schedualAudio.reSendCount++;
        
        // 超时
        if (self.schedualAudio.reSendCount > 3) { // 重发最多3次
            
            TYCustomAlertView *alertView =
            [TYCustomAlertView alertViewWithTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"SYSTEM_PROMPT"] message:@"Sorry! Fail to read list, please check network and zone settings!" isCustom:YES];
            
            [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.ok style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
                
                self.view.userInteractionEnabled = YES; // 恢复交互
                self.schedualAudio.recivedStringList = [NSMutableString string]; // 清空接收字符串的内容
                
            }]];
            
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
            
            alertController.backgoundTapDismissEnable = YES;
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            [SVProgressHUD dismiss];
            
            self.schedualAudio.receivedStatusType =
            SHAudioReceivedStatusTypeOut;
            
            self.schedualAudio.reSendCount = 0;
            self.schedualAudio.isReceivedAudioData = NO;
            
        } else {
            
            [self sendControlAudioData:sendData];
        }
    }
}
    
/// 成功接收到旧信息，开始发送新信息
- (void)sendStartNewData:(SHAudioSendData *)sendData {
    
    switch (sendData.operatorCode) {
        
        case 0x02E0:{
            
            sendData.packageTotal = self.schedualAudio.totalPackages;
            sendData.packageNumber = 1;
            sendData.operatorCode = sendData.operatorCode+2;
            
            sendData.additionalData =
            @[ @(sendData.sourceType),
               @(sendData.packageNumber)];
            
            self.schedualAudio.currentPackageNumber = sendData.packageNumber;
            
            self.schedualAudio.reSendCount = 0;
            self.schedualAudio.receivedStatusType =
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
                
                self.schedualAudio.currentCategoryNumber = sendData.categoryNumber;
                
                self.schedualAudio.reSendCount = 0;
                self.schedualAudio.receivedStatusType = SHAudioReceivedStatusTypeReadSongPackages;
                
                [self sendControlAudioData:sendData];
                
            } else {
                sendData.packageNumber = sendData.packageNumber + 1;
                
                sendData.additionalData = @[@(sendData.sourceType),  @(sendData.packageNumber)];
                
                self.schedualAudio.currentPackageNumber = sendData.packageNumber;
                self.schedualAudio.reSendCount = 0;
                self.schedualAudio.receivedStatusType = SHAudioReceivedStatusTypeReadAlbumList;
                [self sendControlAudioData:sendData];  // OK
            }
            
        }
        break;
        
        case 0x02E4:{
            
            sendData.packageTotal =
            self.schedualAudio.totalPackages;
            sendData.packageNumber = 1;
            sendData.operatorCode = sendData.operatorCode+2;
            
            sendData.additionalData =
            @[ @(sendData.sourceType),
               @(sendData.categoryNumber),
               @(sendData.packageNumber)
               ];
            
            self.schedualAudio.currentPackageNumber = sendData.packageNumber;
            self.schedualAudio.reSendCount = 0;
            self.schedualAudio.receivedStatusType = SHAudioReceivedStatusTypeReadSongList;
            
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
                
                self.schedualAudio.currentPackageNumber = sendData.packageNumber;
                
                self.schedualAudio.reSendCount = 0;
                self.schedualAudio.receivedStatusType = SHAudioReceivedStatusTypeReadSongList;
                
                [self sendControlAudioData: sendData];
            }
        }
        break;
    }
}

@end
