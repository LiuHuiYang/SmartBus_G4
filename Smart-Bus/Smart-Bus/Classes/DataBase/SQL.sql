
-- 创建所有的表格

-- 0.创建地区表格
CREATE TABLE IF NOT EXISTS Regions (
    regionID        INTEGER DEFAULT 1 PRIMARY KEY,
    regionName      TEXT,
    regionIconName  TEXT
);

-- 1.创建区域表格
CREATE TABLE IF NOT EXISTS Zones (
    ZoneID       INTEGER PRIMARY KEY,
    regionID     INTEGER DEFAULT 1,
    ZoneName     TEXT,
    zoneIconName TEXT
);


-- 2.创建一个区域图标表格
CREATE TABLE IF NOT EXISTS iconList (
    iconID    INTEGER PRIMARY KEY,
    iconName  TEXT,
    imageData DATA
);


-- 2.5 创建系统区域定义表格
CREATE TABLE IF NOT EXISTS systemDefnition (
    ID         INTEGER PRIMARY KEY AUTOINCREMENT,
    SystemID   INTEGER  DEFAULT 0,
    SystemName TEXT DEFAULT  'systemName' 
);

-- 3.创建系统区域表格(数字代码含有的设备功能开启，没有开启)
CREATE TABLE IF NOT EXISTS SystemInZone (
    ZoneID   INTEGER DEFAULT 0,
    SystemID INTEGER DEFAULT 0
);

--- 所有的系统设备

-- 4.创建区域中的所有Light
CREATE TABLE IF NOT EXISTS LightInZone (
    ID          INTEGER PRIMARY KEY AUTOINCREMENT,
    ZoneID      INTEGER DEFAULT 0,
    LightID     INTEGER DEFAULT 0,
    LightRemark TEXT DEFAULT '',
    SubnetID    INTEGER DEFAULT 1,
    DeviceID    INTEGER DEFAULT 0,
    ChannelNo   INTEGER DEFAULT 0,
    CanDim      INTEGER NOT NULL DEFAULT 0 ,
    LightTypeID INTEGER DEFAULT 0
);

-- 5.创建HVACInZone表格
CREATE TABLE IF NOT EXISTS HVACInZone (
    ID        INTEGER PRIMARY KEY AUTOINCREMENT,
    ZoneID    INTEGER,
    SubnetID  INTEGER NOT NULL  DEFAULT 1,
    DeviceID  INTEGER NOT NULL  DEFAULT 0,
    ACNumber  INTEGER NOT NULL  DEFAULT 0,
    ACTypeID  INTEGER NOT NULL  DEFAULT 1,
    ACRemark  TEXT,
    channelNo INTEGER NOT NULL DEFAULT 0,
    temperatureSensorSubNetID  INTEGER NOT NULL DEFAULT 1,
    temperatureSensorDeviceID  INTEGER NOT NULL DEFAULT 0,
    temperatureSensorChannelNo INTEGER NOT NULL DEFAULT 0
);

-- 6.创建HVACSetUp表格
CREATE TABLE IF NOT EXISTS HVACSetUp (
    ID INTEGER       PRIMARY KEY,
    isCelsius        BOOL DEFAULT 1,
    TempertureOfCold INTEGER DEFAULT 16,
    TempertureOfCool INTEGER DEFAULT 22,
    TempertureOfWarm INTEGER DEFAULT 26,
    TempertureOfHot  INTEGER DEFAULT 30
);

-- 6. 创建音乐ZaudioInZone
CREATE TABLE IF NOT EXISTS ZaudioInZone (
    ID            INTEGER PRIMARY KEY AUTOINCREMENT,
    ZoneID        INTEGER DEFAULT 0,
    SubnetID      INTEGER DEFAULT 1,
    DeviceID      INTEGER DEFAULT 0,
    audioName     TEXT NOT NULL DEFAULT 'audio',

    haveSdCard    INTEGER NOT NULL DEFAULT 1,
    haveFtp       INTEGER NOT NULL DEFAULT 0,
    haveRadio     INTEGER NOT NULL DEFAULT 0,
    haveAudioIn   INTEGER NOT NULL DEFAULT 0,
    havePhone     INTEGER NOT NULL DEFAULT 0,
    haveUdisk     INTEGER NOT NULL DEFAULT 0,
    haveBluetooth INTEGER NOT NULL DEFAULT 0,
    isMiniZAudio INTEGER NOT NULL DEFAULT 0
);


-- 7. 创建FanInZone
CREATE TABLE  IF NOT EXISTS FanInZone (
    ID        INTEGER PRIMARY KEY AUTOINCREMENT,
    ZoneID    INTEGER,
    FanID     INTEGER DEFAULT 1,
    FanName   TEXT NOT NULL DEFAULT 'Fan',
    SubnetID  INTEGER DEFAULT 1,
    DeviceID  INTEGER DEFAULT 0,
    ChannelNO INTEGER DEFAULT 0,
    FanTypeID INTEGER DEFAULT 0,
    Remark    TEXT NOT NULL DEFAULT 'Fan',
    Reserved1 INTEGER DEFAULT 0,
    Reserved2 INTEGER DEFAULT 0,
    Reserved3 INTEGER DEFAULT 0,
    Reserved4 INTEGER DEFAULT 0,
    Reserved5 INTEGER DEFAULT 0
);

-- 9.创建ShadeInZone

CREATE TABLE IF NOT EXISTS ShadeInZone (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ZoneID INTEGER DEFAULT 0,
    ShadeID INTEGER DEFAULT 0,
    ShadeName TEXT DEFAULT 'shade' ,

    SubnetID INTEGER DEFAULT 1,
    DeviceID INTEGER DEFAULT 0,

     HasStop INTEGER DEFAULT 0,

    -- 开窗帘通道
    openChannel INTEGER DEFAULT 0,
    -- 打开比例
    openingRatio INTEGER DEFAULT 100,

    -- 关闭窗帘通道
    closeChannel INTEGER DEFAULT 0,
    closingRatio INTEGER DEFAULT 100,

    -- 停止通道
    stopChannel INTEGER NOT NULL DEFAULT 0,
    stoppingRatio INTEGER NOT NULL DEFAULT 0,

    Reserved1 INTEGER DEFAULT 0,
    Reserved2 INTEGER DEFAULT 0,

    -- 打开窗帘的备注
    remarkForOpen text NOT NULL DEFAULT(''),

    -- 关闭窗帘的备注
    remarkForClose text NOT NULL DEFAULT(''),

    -- 停止窗帘的备注
    remarkForStop text NOT NULL DEFAULT(''),

    controlType INTEGER NOT NULL DEFAULT 0,

    switchIDforOpen INTEGER NOT NULL DEFAULT 0,
    switchIDStatusforOpen INTEGER NOT NULL DEFAULT 0,

    switchIDforClose INTEGER NOT NULL DEFAULT 0,
    switchIDStatusforClose INTEGER NOT NULL DEFAULT 0,

    switchIDforStop INTEGER NOT NULL DEFAULT 0,
    switchIDStatusforStop INTEGER NOT NULL DEFAULT 0
);

-- 11. 普通TV.创建TVInZone表格
CREATE TABLE IF NOT EXISTS TVInZone (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    remark text NOT NULL DEFAULT('TV'),
    ZoneID INTEGER DEFAULT 0,
    SubnetID INTEGER DEFAULT 1,
    DeviceID INTEGER DEFAULT 0,

    UniversalSwitchIDforOn INTEGER DEFAULT 1,
    UniversalSwitchStatusforOn ININTEGERT DEFAULT 255,
    UniversalSwitchIDforOff INTEGER DEFAULT 1,
    UniversalSwitchStatusforOff INTEGER DEFAULT 0,

    UniversalSwitchIDforCHAdd INTEGER DEFAULT 0,
    UniversalSwitchIDforCHMinus INTEGER DEFAULT 0,
    UniversalSwitchIDforVOLUp INTEGER DEFAULT 0,
    UniversalSwitchIDforVOLDown INTEGER DEFAULT 0,

    UniversalSwitchIDforMute INTEGER DEFAULT 0,
    UniversalSwitchIDforMenu INTEGER DEFAULT 0,
    UniversalSwitchIDforSource INTEGER DEFAULT 0,
    UniversalSwitchIDforOK INTEGER DEFAULT 0,

    UniversalSwitchIDfor0 INTEGER DEFAULT 0,
    UniversalSwitchIDfor1 INTEGER DEFAULT 0,
    UniversalSwitchIDfor2 INTEGER DEFAULT 0,
    UniversalSwitchIDfor3 INTEGER DEFAULT 0,
    UniversalSwitchIDfor4 INTEGER DEFAULT 0,
    UniversalSwitchIDfor5 INTEGER DEFAULT 0,
    UniversalSwitchIDfor6 INTEGER DEFAULT 0,
    UniversalSwitchIDfor7 INTEGER DEFAULT 0,
    UniversalSwitchIDfor8 INTEGER DEFAULT 0,
    UniversalSwitchIDfor9 INTEGER DEFAULT 0,

    -- IR
    IRMacroNumberForTVStart0 INTEGER DEFAULT 0,
    IRMacroNumberForTVStart1 INTEGER DEFAULT 0,
    IRMacroNumberForTVStart2 INTEGER DEFAULT 0,
    IRMacroNumberForTVStart3 INTEGER DEFAULT 0,
    IRMacroNumberForTVStart4 INTEGER DEFAULT 0,
    IRMacroNumberForTVStart5 INTEGER DEFAULT 0
);


-- 11.创建AppleTVInZone表格
CREATE TABLE IF NOT EXISTS AppleTVInZone (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    remark text NOT NULL DEFAULT('APPLE TV'),
    ZoneID INTEGER DEFAULT 0,
    SubnetID INTEGER DEFAULT 1,
    DeviceID INTEGER DEFAULT 0,

    UniversalSwitchIDforOn INTEGER DEFAULT 1,
    UniversalSwitchStatusforOn INTEGER DEFAULT 255,
    UniversalSwitchIDforOff INTEGER DEFAULT 1,
    UniversalSwitchStatusforOff INTEGER DEFAULT 0,

    UniversalSwitchIDforUp INTEGER DEFAULT 2,
    UniversalSwitchIDforDown INTEGER DEFAULT 3,
    UniversalSwitchIDforLeft INTEGER DEFAULT 4,
    UniversalSwitchIDforRight INTEGER DEFAULT 5,
    UniversalSwitchIDforOK INTEGER DEFAULT 6,
    UniversalSwitchIDforMenu INTEGER DEFAULT 7,
    UniversalSwitchIDforPlayPause INTEGER DEFAULT 8,

    IRMacroNumberForAppleTVStart0 INTEGER DEFAULT 0,
    IRMacroNumberForAppleTVStart1 INTEGER DEFAULT 0,
    IRMacroNumberForAppleTVStart2 INTEGER DEFAULT 0,
    IRMacroNumberForAppleTVStart3 INTEGER DEFAULT 0,
    IRMacroNumberForAppleTVStart4 INTEGER DEFAULT 0,
    IRMacroNumberForAppleTVStart5 INTEGER DEFAULT 0
);

-- 13.创建DVD表格
CREATE TABLE IF NOT EXISTS DVDInZone (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    remark text NOT NULL DEFAULT('TV'),
    ZoneID INTEGER DEFAULT 0,
    SubnetID INTEGER DEFAULT 1,
    DeviceID INTEGER DEFAULT 0,

    UniversalSwitchIDforOn INTEGER DEFAULT 1,
    UniversalSwitchStatusforOn INTEGER DEFAULT 255,
    UniversalSwitchIDforOff INTEGER DEFAULT 1,
    UniversalSwitchStatusforOff INTEGER DEFAULT 0,

    UniversalSwitchIDfoMenu INTEGER DEFAULT 7,
    UniversalSwitchIDfoUp INTEGER DEFAULT 2,
    UniversalSwitchIDforDown INTEGER DEFAULT 3,
    UniversalSwitchIDforFastForward INTEGER DEFAULT 5,
    UniversalSwitchIDforBackForward INTEGER DEFAULT 4,
    UniversalSwitchIDforOK INTEGER DEFAULT 6,
    UniversalSwitchIDforPREVChapter INTEGER DEFAULT 0,
    UniversalSwitchIDforNextChapter INTEGER DEFAULT 0,
    UniversalSwitchIDforPlayPause INTEGER DEFAULT 8,

    UniversalSwitchIDforPlayRecord INTEGER DEFAULT 11,
    UniversalSwitchIDforPlayStopRecord INTEGER DEFAULT 22,

    IRMacroNumberForDVDStart0 INTEGER DEFAULT 33,
    IRMacroNumberForDVDStart1 INTEGER DEFAULT 1,
    IRMacroNumberForDVDStart2 INTEGER DEFAULT 2,
    IRMacroNumberForDVDStart3 INTEGER DEFAULT 3,
    IRMacroNumberForDVDStart4 INTEGER DEFAULT 4,
    IRMacroNumberForDVDStart5 INTEGER DEFAULT 5
);


-- 14.创建ProjectorInZone表格
CREATE TABLE IF NOT EXISTS ProjectorInZone (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    remark text NOT NULL DEFAULT('PROJECTOR'),
    ZoneID INTEGER DEFAULT 0,
    SubnetID INTEGER DEFAULT 1,
    DeviceID INTEGER DEFAULT 0,

    UniversalSwitchIDforOn INTEGER DEFAULT 0,
    UniversalSwitchStatusforOn INTEGER DEFAULT 255,
    UniversalSwitchIDforOff INTEGER DEFAULT 0,
    UniversalSwitchStatusforOff INTEGER DEFAULT 255,

    UniversalSwitchIDfoUp INTEGER DEFAULT 0,
    UniversalSwitchIDforDown INTEGER DEFAULT 0,
    UniversalSwitchIDforLeft INTEGER DEFAULT 0,
    UniversalSwitchIDforRight INTEGER DEFAULT 0,
    UniversalSwitchIDforOK INTEGER DEFAULT 0,
    UniversalSwitchIDfoMenu INTEGER DEFAULT 0,
    UniversalSwitchIDforSource INTEGER DEFAULT 0,

    IRMacroNumberForProjectorSpare0 INTEGER DEFAULT 0,
    IRMacroNumberForProjectorSpare1 INTEGER DEFAULT 0,
    IRMacroNumberForProjectorSpare2 INTEGER DEFAULT 0,
    IRMacroNumberForProjectorSpare3 INTEGER DEFAULT 0,
    IRMacroNumberForProjectorSpare4 INTEGER DEFAULT 0,
    IRMacroNumberForProjectorSpare5 INTEGER DEFAULT 0
);

-- 15.创建SATInZone

CREATE TABLE IF NOT EXISTS SATInZone (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    remark text NOT NULL DEFAULT('SAT'),
    ZoneID INTEGER DEFAULT 0,
    SubnetID INTEGER DEFAULT 1,
    DeviceID INTEGER DEFAULT 0,

    UniversalSwitchIDforOn INTEGER DEFAULT 0,
    UniversalSwitchStatusforOn INTEGER DEFAULT 255,
    UniversalSwitchIDforOff INTEGER DEFAULT 0,
    UniversalSwitchStatusforOff INTEGER DEFAULT 0,

    UniversalSwitchIDforUp INTEGER DEFAULT 0,
    UniversalSwitchIDforDown INTEGER DEFAULT 0,
    UniversalSwitchIDforLeft INTEGER DEFAULT 0,
    UniversalSwitchIDforRight INTEGER DEFAULT 0,
    UniversalSwitchIDforOK INTEGER DEFAULT 0,
    UniversalSwitchIDfoMenu INTEGER DEFAULT 0,
    UniversalSwitchIDforFAV INTEGER DEFAULT 0,

    UniversalSwitchIDfor0 INTEGER DEFAULT 0,
    UniversalSwitchIDfor1 INTEGER DEFAULT 0,
    UniversalSwitchIDfor2 INTEGER DEFAULT 0,
    UniversalSwitchIDfor3 INTEGER DEFAULT 0,
    UniversalSwitchIDfor4 INTEGER DEFAULT 0,
    UniversalSwitchIDfor5 INTEGER DEFAULT 0,
    UniversalSwitchIDfor6 INTEGER DEFAULT 0,
    UniversalSwitchIDfor7 INTEGER DEFAULT 0,
    UniversalSwitchIDfor8 INTEGER DEFAULT 0,
    UniversalSwitchIDfor9 INTEGER DEFAULT 0,

    UniversalSwitchIDforPREVChapter INTEGER DEFAULT 0,
    UniversalSwitchIDforNextChapter INTEGER DEFAULT 0,

    UniversalSwitchIDforPlayRecord INTEGER DEFAULT 0,
    UniversalSwitchIDforPlayStopRecord INTEGER DEFAULT 0,

    SwitchNameforControl1 TEXT DEFAULT 'C1',
    SwitchIDforControl1 INTEGER DEFAULT 0,

    SwitchNameforControl2 TEXT DEFAULT 'C2',
    SwitchIDforControl2 INTEGER DEFAULT 0,

    SwitchNameforControl3 TEXT DEFAULT 'C3',
    SwitchIDforControl3 INTEGER DEFAULT 0,

    SwitchNameforControl4 TEXT DEFAULT 'C4',
    SwitchIDforControl4 INTEGER DEFAULT 0,

    SwitchNameforControl5 TEXT DEFAULT 'C5',
    SwitchIDforControl5 INTEGER DEFAULT 0,

    SwitchNameforControl6 TEXT DEFAULT 'C6',
    SwitchIDforControl6 INTEGER DEFAULT 0
);

-- 16.创建SATCategory
CREATE TABLE IF NOT EXISTS  SATCategory (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    CategoryID INTEGER  NOT NULL DEFAULT 0,
    CategoryName  TEXT  NOT NULL DEFAULT 'categoryName',
    SequenceNo INTEGER NOT NULL DEFAULT 0,
    ZoneID INTEGER NOT NULL DEFAULT 0
);

-- 17创建SATChannels
CREATE TABLE IF NOT EXISTS  SATChannels (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    CategoryID INTEGER NOT NULL DEFAULT 0,
    ChannelID INTEGER NOT NULL DEFAULT 0,
    ChannelNo INTEGER NOT NULL DEFAULT 0,
    ChannelName  TEXT NOT NULL DEFAULT 'channelName',
    iconName TEXT NOT NULL DEFAULT 'iconName',
    SequenceNo  INTEGER NOT NULL DEFAULT 0,
    ZoneID INTEGER NOT NULL DEFAULT 0
);

-- 2.创建一个通道图标表格 (备用，方便将来需要实现这个功能时，直接参照区域按钮进行设置)
CREATE TABLE IF NOT EXISTS  SATChannelIconList (
    iconID INTEGER PRIMARY KEY,
    iconName TEXT DEFAULT 'mediaSATChannelDefault'
);

-- 创建模式 MoodInZone

CREATE TABLE IF NOT EXISTS MoodInZone (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,

    ZoneID INTEGER DEFAULT 0 ,
    MoodID INTEGER DEFAULT 0 ,

    MoodName TEXT NOT NULL DEFAULT 'newMood' ,
    MoodIconName  TEXT NOT NULL DEFAULT 'mood_romantic' ,
    IsSystemMood INTEGER DEFAULT 0
);

-- 4.创建MoodCommands表格
CREATE TABLE IF NOT EXISTS MoodCommands (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,

    ZoneID INTEGER NOT NULL DEFAULT 0 ,
    MoodID INTEGER DEFAULT 0 ,

    -- 系统设备ID
    deviceType INTEGER NOT NULL DEFAULT 0 ,

    SubnetID INTEGER NOT NULL DEFAULT  1 ,
    DeviceID INTEGER NOT NULL DEFAULT 0 ,
    deviceName TEXT NOT NULL DEFAULT 'DeviceName',

    -- Dimmer的LightTypeID
    Parameter1 INTEGER NOT NULL DEFAULT 0,

    -- Dimmer的通道
    Parameter2 INTEGER NOT NULL DEFAULT 0,

    -- Dimmer的亮度
    Parameter3 INTEGER NOT NULL DEFAULT 0,

    Parameter4 INTEGER NOT NULL DEFAULT 0 ,
    Parameter5 INTEGER NOT NULL DEFAULT 0 ,
    Parameter6 INTEGER NOT NULL DEFAULT 0 ,
    DelayMillisecondAfterSend integer NOT NULL DEFAULT(100)
);

-- 创建地热列表
CREATE TABLE IF NOT EXISTS FloorHeatingInZone (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ZoneID INTEGER DEFAULT 0,
    FloorHeatingID INTEGER DEFAULT 0,
    FloorHeatingRemark TEXT DEFAULT 'floorHeating',
    SubnetID INTEGER DEFAULT 1,
    DeviceID INTEGER DEFAULT 0,
    ChannelNo INTEGER DEFAULT 0,

    -- 室外传感器的地址
    outsideSensorSubNetID INTEGER DEFAULT 1,
    outsideSensorDeviceID INTEGER DEFAULT 0,
    outsideSensorChannelNo INTEGER DEFAULT 0
);

-- 创建九合一的列表
CREATE TABLE IF NOT EXISTS NineInOneInZone (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    NineInOneName TEXT  DEFAULT '9in1',
    ZoneID INTEGER DEFAULT 0 ,

    -- 表示这是当前区域中的第几个
    NineInOneID INTEGER DEFAULT 0 ,
    SubnetID INTEGER DEFAULT 1,
    DeviceID INTEGER DEFAULT 0,

    -- 11个控制面板的个按钮

    -- 中间转盘 
    SwitchIDforControlSure INTEGER DEFAULT 0,
    SwitchIDforControlUp INTEGER DEFAULT 0,
    SwitchIDforControlDown INTEGER DEFAULT 0,
    SwitchIDforControlLeft INTEGER DEFAULT 0,
    SwitchIDforControlRight INTEGER DEFAULT 0,

    -- 8个匹配的按钮
    SwitchNameforControl1 TEXT DEFAULT 'C1',
    SwitchIDforControl1 INTEGER DEFAULT 0,

    SwitchNameforControl2 TEXT DEFAULT 'C2',
    SwitchIDforControl2 INTEGER DEFAULT 0,

    SwitchNameforControl3 TEXT DEFAULT 'C3',
    SwitchIDforControl3 INTEGER DEFAULT 0,

    SwitchNameforControl4 TEXT DEFAULT 'C4',
    SwitchIDforControl4 INTEGER DEFAULT 0,

    SwitchNameforControl5 TEXT DEFAULT 'C5',
    SwitchIDforControl5 INTEGER DEFAULT 0,

    SwitchNameforControl6 TEXT DEFAULT 'C6',
    SwitchIDforControl6 INTEGER DEFAULT 0,

    SwitchNameforControl7 TEXT DEFAULT 'C7',
    SwitchIDforControl7 INTEGER DEFAULT 0,

    SwitchNameforControl8 TEXT DEFAULT 'C8',
    SwitchIDforControl8 INTEGER DEFAULT 0,

    -- 12个数字键盘
    SwitchIDforNumber0 INTEGER DEFAULT  0 ,
    SwitchIDforNumber1 INTEGER DEFAULT  0 ,
    SwitchIDforNumber2 INTEGER DEFAULT  0 ,
    SwitchIDforNumber3 INTEGER DEFAULT  0 ,
    SwitchIDforNumber4 INTEGER DEFAULT  0 ,
    SwitchIDforNumber5 INTEGER DEFAULT  0 ,
    SwitchIDforNumber6 INTEGER DEFAULT  0 ,
    SwitchIDforNumber7 INTEGER DEFAULT  0 ,
    SwitchIDforNumber8 INTEGER DEFAULT  0 ,
    SwitchIDforNumber9 INTEGER DEFAULT  0 ,

    -- * 号
    SwitchIDforNumberAsterisk INTEGER DEFAULT  0 ,
    -- # 号
    SwitchIDforNumberPound INTEGER DEFAULT  0 ,

    -- 12个保留参数的名称与指令
    SwitchNameforSpare1 TEXT DEFAULT  'Spare_1' ,
    SwitchIDforSpare1 INTEGER DEFAULT  0 ,

    SwitchNameforSpare2 TEXT DEFAULT  'Spare_2' ,
    SwitchIDforSpare2 INTEGER DEFAULT  0 ,

    SwitchNameforSpare3 TEXT DEFAULT  'Spare_3' ,
    SwitchIDforSpare3 INTEGER DEFAULT  0 ,

    SwitchNameforSpare4 TEXT DEFAULT  'Spare_4' ,
    SwitchIDforSpare4 INTEGER DEFAULT  0 ,

    SwitchNameforSpare5 TEXT DEFAULT  'Spare_5' ,
    SwitchIDforSpare5 INTEGER DEFAULT  0 ,

    SwitchNameforSpare6 TEXT DEFAULT  'Spare_6' ,
    SwitchIDforSpare6 INTEGER DEFAULT  0 ,

    SwitchNameforSpare7 TEXT DEFAULT  'Spare_7' ,
    SwitchIDforSpare7 INTEGER DEFAULT  0 ,

    SwitchNameforSpare8 TEXT DEFAULT  'Spare_8' ,
    SwitchIDforSpare8 INTEGER DEFAULT  0 ,

    SwitchNameforSpare9 TEXT DEFAULT  'Spare_9' ,
    SwitchIDforSpare9 INTEGER DEFAULT  0 ,

    SwitchNameforSpare10 TEXT DEFAULT  'Spare_10' ,
    SwitchIDforSpare10 INTEGER DEFAULT  0 ,

    SwitchNameforSpare11 TEXT DEFAULT  'Spare_11' ,
    SwitchIDforSpare11 INTEGER DEFAULT  0 ,

    SwitchNameforSpare12 TEXT DEFAULT  'Spare_12' ,
    SwitchIDforSpare12 INTEGER DEFAULT  0
);

/*
-- 4.创建区域中的所有DMX
CREATE TABLE IF NOT EXISTS DMXInZone (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,

    -- 哪一个组
    groupID INTEGER NOT NULL DEFAULT 0,
    ZoneID INTEGER NOT NULL DEFAULT 0,
    remark TEXT NOT NULL DEFAULT 'dmx',

    SubnetID INTEGER NOT NULL DEFAULT 0,
    DeviceID INTEGER NOT NULL DEFAULT 0,

    redColorChannel INTEGER NOT NULL DEFAULT 0,
    greenColorChannel INTEGER NOT NULL DEFAULT 0,
    blueColorChannel INTEGER NOT NULL DEFAULT 0,
    whiteColorChannel INTEGER NOT NULL DEFAULT 0
);

*/

-- 创建Dmx的分组
CREATE TABLE IF NOT EXISTS  dmxGroupInZone (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ZoneID INTEGER NOT NULL DEFAULT 0,
    groupID INTEGER NOT NULL DEFAULT 0,
    groupName TEXT NOT NULL DEFAULT 'dmx'
);

-- 创建Dmx的通道
CREATE TABLE IF NOT EXISTS  dmxChannelInZone (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ZoneID INTEGER NOT NULL DEFAULT 0,
    groupID INTEGER NOT NULL DEFAULT 0,
    groupName TEXT NOT NULL DEFAULT 'dmxGroup',
    remark TEXT NOT NULL DEFAULT 'channel',
    channelType INTEGER NOT NULL DEFAULT 0,
    SubnetID INTEGER NOT NULL DEFAULT 0,
    DeviceID INTEGER NOT NULL DEFAULT 0,
    channelNo INTEGER NOT NULL DEFAULT 0
);

-- scene控制
CREATE TABLE IF NOT EXISTS  SceneInZone (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ZoneID INTEGER NOT NULL DEFAULT 0,
    SceneID INTEGER NOT NULL DEFAULT 0,
    remark TEXT NOT NULL DEFAULT 'Scene',

    SubnetID INTEGER NOT NULL DEFAULT 0,
    DeviceID INTEGER NOT NULL DEFAULT 0,
    AreaNo INTEGER NOT NULL DEFAULT 0,
    SceneNo INTEGER NOT NULL DEFAULT 0
);

-- Sequence 控制
CREATE TABLE IF NOT EXISTS  SequenceInZone (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ZoneID INTEGER NOT NULL DEFAULT 0,
    SequenceID INTEGER NOT NULL DEFAULT 0,
    remark TEXT NOT NULL DEFAULT 'Sequence',

    SubnetID INTEGER NOT NULL DEFAULT 0,
    DeviceID INTEGER NOT NULL DEFAULT 0,
    AreaNo INTEGER NOT NULL DEFAULT 0,
    SequenceNo INTEGER NOT NULL DEFAULT 0
);

-- OtherControl控制
CREATE TABLE IF NOT EXISTS OtherControlInZone (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    OtherControlID INTEGER NOT NULL DEFAULT(0),
    ZoneID INTEGER NOT NULL DEFAULT(0),
    remark TEXT NOT NULL DEFAULT 'OtherControl',
    ControlType INTEGER NOT NULL DEFAULT 0,
    SubnetID INTEGER NOT NULL DEFAULT 0,
    DeviceID INTEGER NOT NULL DEFAULT 0,
    Parameter1 INTEGER NOT NULL DEFAULT(0),
    Parameter2 INTEGER NOT NULL DEFAULT(0)
);


-- --------------中心控制区域------------

-- 2>>_1_1. 创建宏命令 MacroButton

CREATE TABLE IF NOT EXISTS MacroButtons (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    MacroID INTEGER NOT NULL,
    MacroName TEXT NOT NULL DEFAULT 'MacroName' ,
    MacroIconName TEXT NOT NULL DEFAULT 'MacroIconName'
);

-- 2>>_1_2. 创建宏命令按钮的指令集 MacroButtonCommands

CREATE TABLE IF NOT EXISTS MacroButtonCommands (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    MacroID INTEGER NOT NULL DEFAULT 0 ,
    Remark TEXT NOT NULL DEFAULT 'text' ,
    SubnetID INTEGER NOT NULL DEFAULT 0 ,
    DeviceID INTEGER NOT NULL DEFAULT 0 ,
    CommandTypeID INTEGER NOT NULL DEFAULT 0 ,
    FirstParameter INTEGER NOT NULL DEFAULT 0 ,
    SecondParameter INTEGER NOT NULL DEFAULT 0 ,
    ThirdParameter INTEGER NOT NULL DEFAULT 0 ,
    DelayMillisecondAfterSend INTEGER NOT NULL DEFAULT 0
);

-- 2>>_2_1. 创建CentralLights
CREATE TABLE IF NOT EXISTS CentralLights (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    FloorID INTEGER NOT NULL,
    FloorName TEXT NOT NULL
);

-- 2>>_2_2. 创建CentralLightsCommands
CREATE TABLE IF NOT EXISTS CentralLightsCommands (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    FloorID INTEGER NOT NULL DEFAULT 0,
    CommandID INTEGER NOT NULL DEFAULT 0,
    Remark TEXT NOT NULL DEFAULT 'lightsCommand' ,
    SubnetID INTEGER NOT NULL DEFAULT 0,
    DeviceID INTEGER NOT NULL DEFAULT 0,
    CommandTypeID INTEGER NOT NULL DEFAULT 0,
    Parameter1  INTEGER NOT NULL DEFAULT 0,
    Parameter2 INTEGER NOT NULL DEFAULT 0,
    DelayMillisecondAfterSend INTEGER NOT NULL DEFAULT 0
);


-- 2>>_4_1 创建CentralSecurity

CREATE TABLE IF NOT EXISTS CentralSecurity (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    SubnetID INTEGER NOT NULL DEFAULT 1,
    DeviceID INTEGER NOT NULL DEFAULT 0,
    ZoneID INTEGER NOT NULL DEFAULT 0,
    zoneNameOfSecurity TEXT NOT NULL DEFAULT 'zoneName'
);

--2 >>_5_1 创建CentralHVAC
CREATE TABLE IF NOT EXISTS CentralHVAC (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    FloorID INTEGER NOT NULL DEFAULT 0,
    FloorName TEXT NOT NULL DEFAULT 'hvac',
    isHaveHot BOOL NOT NULL  DEFAULT 1
);

-- 2 >>_5_2. 创建CentralHVACCommands
CREATE TABLE IF NOT EXISTS CentralHVACCommands (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    FloorID INTEGER NOT NULL DEFAULT 0,
    CommandID INTEGER NOT NULL DEFAULT 0,
    Remark TEXT DEFAULT 'hvaccommand',
    SubnetID INTEGER NOT NULL DEFAULT 0,
    DeviceID INTEGER NOT NULL DEFAULT 0,
    CommandTypeID INTEGER NOT NULL DEFAULT 0,
    Parameter1  INTEGER NOT NULL DEFAULT 0,
    Parameter2 INTEGER NOT NULL DEFAULT 0,
    DelayMillisecondAfterSend INTEGER NOT NULL DEFAULT 0
);

-- 8.创建HVACInZoneIRCommands表格
CREATE TABLE IF NOT EXISTS HVACInZoneIRCommands (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ZoneID INTEGER   NOT NULL DEFAULT 0 ,
    ACID  INTEGER   NOT NULL DEFAULT 0 ,
    SubnetID  INTEGER NOT NULL  DEFAULT 0  ,
    DeviceID  INTEGER NOT NULL  DEFAULT 0  ,
    UniversalSwitchIDforOn  INTEGER NOT NULL  DEFAULT 0 ,
    UnSwStatusforOn  INTEGER NOT NULL  DEFAULT 0 ,
    UnSwIDforOff  INTEGER NOT NULL  DEFAULT 0 ,
    UnSwStatusforOff  INTEGER NOT NULL  DEFAULT 0 ,
    UnSwIDforCool  INTEGER NOT NULL  DEFAULT 0 ,
    UnSwIDforHeat  INTEGER NOT NULL  DEFAULT 0 ,
    UnSwIDforFan  INTEGER NOT NULL  DEFAULT 0 ,
    UnSwIDforModeAuto  INTEGER NOT NULL  DEFAULT 0 ,
    UnSwIDforDry  INTEGER NOT NULL DEFAULT 0,
    UnSwIDforFanLow  INTEGER NOT NULL  DEFAULT 0 ,
    UnSwIDforFanMed  INTEGER NOT NULL  DEFAULT 0 ,
    UnSwIDforFanHigh  INTEGER NOT NULL  DEFAULT 0 ,
    UnSwIDforFanAuto  INTEGER DEFAULT 0 ,
    UnSwForTemp15  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp16  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp17  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp18  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp19  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp20  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp21  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp22  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp23  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp24  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp25  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp26  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp27  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp28  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp29  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp30  INTEGER NOT NULL DEFAULT 0,
    UnSwForTemp31  INTEGER NOT NULL DEFAULT 0
);

-- 19.创建Schedules
CREATE TABLE IF NOT EXISTS Schedules (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ScheduleID INTEGER NOT NULL  DEFAULT 0 ,
    ScheduleName TEXT NOT NULL DEFAULT 'schedualeName',
    EnabledSchedule INTEGER NOT NULL  DEFAULT 1,
    ControlledItemID INTEGER NOT NULL DEFAULT 0,
    ZoneID TEXT NOT NULL  DEFAULT 0 ,
    FrequencyID TEXT NOT NULL  DEFAULT 0 ,
    WithSunday INTEGER NOT NULL  DEFAULT 0 ,
    WithMonday INTEGER NOT NULL  DEFAULT 0 ,
    WithTuesday INTEGER NOT NULL  DEFAULT 0 ,
    WithWednesday INTEGER NOT NULL  DEFAULT 0 ,
    WithThursday INTEGER NOT NULL  DEFAULT 0 ,
    WithFriday INTEGER NOT NULL  DEFAULT 0 ,
    WithSaturday INTEGER NOT NULL  DEFAULT 0 ,
    ExecutionHours TEXT NOT NULL  DEFAULT 0 ,
    ExecutionMins TEXT NOT NULL  DEFAULT 0 ,

    -- 这个ExecutionDate参数 是给每天或者只执行一次使用的
    ExecutionDate TEXT DEFAULT 1 ,
    HaveSound INTEGER NOT NULL  DEFAULT 0
);

-- 20. 创建ScheduleCommands
CREATE TABLE IF NOT EXISTS ScheduleCommands (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ScheduleID INTEGER NOT NULL DEFAULT 0,
    typeID INTEGER NOT NULL DEFAULT 0,
    parameter1 INTEGER NOT NULL DEFAULT 0,
    parameter2 INTEGER NOT NULL DEFAULT 0,
    parameter3 INTEGER NOT NULL DEFAULT 0,
    parameter4 INTEGER NOT NULL DEFAULT 0,
    parameter5 INTEGER NOT NULL DEFAULT 0,
    parameter6 INTEGER NOT NULL DEFAULT 0
);

-- 24_1. 创建Camera
CREATE TABLE IF NOT EXISTS Camera (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    CameraID INTEGER NOT NULL DEFAULT 0,
    Name TEXT NOT NULL DEFAULT 'name',
    URL TEXT NOT NULL DEFAULT 'URL',
    SequenceNo INTEGER NOT NULL DEFAULT 0
);


-- 24_2. 创建IpCamera
CREATE TABLE IF NOT EXISTS IpCamera (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    CameraID INTEGER NOT NULL DEFAULT 0,
    Brand TEXT NOT NULL DEFAULT 'Foscam',
    Type INTEGER NOT NULL DEFAULT 0,
    Ip TEXT NOT NULL DEFAULT 'ip',
    Port INTEGER NOT NULL DEFAULT 0,
    Mask TEXT NOT NULL DEFAULT 'mask',
    Gateway TEXT NOT NULL DEFAULT 'gateway',
    Dns TEXT NOT NULL DEFAULT 'dns',
    IsP2P INTEGER NOT NULL DEFAULT 0,
    MediaPort INTEGER NOT NULL DEFAULT 0,
    SysVersions INTEGER NOT NULL DEFAULT 0,
    AppVersions INTEGER NOT NULL DEFAULT 0,
    DhcpEnabled INTEGER NOT NULL DEFAULT 0,
    CameraName TEXT NOT NULL DEFAULT 'cameraName',
    UIDForP2P INTEGER NOT NULL DEFAULT 0,
    IsMainStream INTEGER DEFAULT 1
);

-- 增加CT24

CREATE TABLE IF NOT EXISTS CurrentTransformer (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,

    -- 这是第几个设备
    CurrentTransformerID INTEGER NOT NULL DEFAULT 0,

    SubnetID  INTEGER NOT NULL  DEFAULT 0,
    DeviceID  INTEGER NOT NULL  DEFAULT 0,
    Remark TEXT NOT NULL DEFAULT 'CT24',
    Voltage   INTEGER NOT NULL  DEFAULT 0,

    Channel1 TEXT NOT NULL DEFAULT 'CH1',
    Channel2 TEXT NOT NULL DEFAULT 'CH2',
    Channel3 TEXT NOT NULL DEFAULT 'CH3',
    Channel4 TEXT NOT NULL DEFAULT 'CH4',
    Channel5 TEXT NOT NULL DEFAULT 'CH5',
    Channel6 TEXT NOT NULL DEFAULT 'CH6',
    Channel7 TEXT NOT NULL DEFAULT 'CH7',
    Channel8 TEXT NOT NULL DEFAULT 'CH8',
    Channel9 TEXT NOT NULL DEFAULT 'CH9',
    Channel10 TEXT NOT NULL DEFAULT 'CH10',
    Channel11 TEXT NOT NULL DEFAULT 'CH11',
    Channel12 TEXT NOT NULL DEFAULT 'CH12',
    Channel13 TEXT NOT NULL DEFAULT 'CH13',
    Channel14 TEXT NOT NULL DEFAULT 'CH14',
    Channel15 TEXT NOT NULL DEFAULT 'CH15',
    Channel16 TEXT NOT NULL DEFAULT 'CH16',
    Channel17 TEXT NOT NULL DEFAULT 'CH17',
    Channel18 TEXT NOT NULL DEFAULT 'CH18',
    Channel19 TEXT NOT NULL DEFAULT 'CH19',
    Channel20 TEXT NOT NULL DEFAULT 'CH20',
    Channel21 TEXT NOT NULL DEFAULT 'CH21',
    Channel22 TEXT NOT NULL DEFAULT 'CH22',
    Channel23 TEXT NOT NULL DEFAULT 'CH23',
    Channel24 TEXT NOT NULL DEFAULT 'CH24'
);

-- 增加干节点输入模块的状态

CREATE TABLE IF NOT EXISTS DryContactInZone (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,

    -- 第是第几个干节点
    contactID INTEGER NOT NULL DEFAULT 0,
    ZoneID INTEGER DEFAULT 0 ,

    -- 每个通道的标注
    remark TEXT NOT NULL DEFAULT '4z',

    SubnetID  INTEGER NOT NULL  DEFAULT 0,
    DeviceID  INTEGER NOT NULL  DEFAULT 0,
    ChannelNo INTEGER NOT NULL  DEFAULT 0
);


-- 增加温度传感器

CREATE TABLE IF NOT EXISTS TemperatureSensorInZone (

    ID INTEGER PRIMARY KEY AUTOINCREMENT,

    ZoneID INTEGER DEFAULT 0 ,

    -- 温度传感器标注
    remark TEXT NOT NULL DEFAULT 'ambient temperature',

    -- 这是第几个温度检测
    temperatureID INTEGER NOT NULL DEFAULT 0,

    SubnetID  INTEGER NOT NULL  DEFAULT 0,
    DeviceID  INTEGER NOT NULL  DEFAULT 0,

    -- 通道
    ChannelNo INTEGER NOT NULL  DEFAULT 0
);

/*
-- 增加语音控制表格(测试版)
CREATE TABLE IF NOT EXISTS speechControlDevices (
    ID integer PRIMARY KEY AUTOINCREMENT,
    deviceType integer NOT NULL DEFAULT 0,
    speechName text NOT NULL DEFAULT ''
);
*/
