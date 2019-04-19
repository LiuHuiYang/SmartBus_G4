//
//  SHDataMigrationViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/20.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit
import FMDB

/// 旧数据库的名称
private let oldDataBase = "Database.sqlite3"

class SHDataMigrationViewController: SHViewController {
    
    /// 数据迁移按钮
    @IBOutlet weak var startDataMigrationButton: UIButton!
    
    /// 描述文字
    @IBOutlet weak var notesLabel: UILabel!
    
    /// 高度约束
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 文字的高度约束
    @IBOutlet weak var noteLabelHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Data Migration"
        startDataMigrationButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            notesLabel.font = font
            startDataMigrationButton.titleLabel?.font = font
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            buttonHeightConstraint.constant =
                (navigationBarHeight + statusBarHeight)
            
            noteLabelHeightConstraint.constant =
                (navigationBarHeight * 4)
        }
    }
    
    /// 开始数据迁移
    @IBAction func startDataMigrationButtonClick() {
        
        // 1.判断旧的数据库文件存在
        if isOldDataBaseFileExist() == false {
            
            SVProgressHUD.showError(
                withStatus: "Database files do not exist"
            )
            return
        }
        
        // 2.开始将每个数据表进行修改
        if migrationData() == false {
            
            SVProgressHUD.showError(
                withStatus: "Data migration failure"
            )
            
            return
        }
        
        // 修改数据库的名称
        if chaneOldDataBaseFileToDefaultDataBaseFile() == false {
            
            SVProgressHUD.showError(
                withStatus: "Update the database failure"
            )
            
            return
        }
        
        // 修改完成
        SVProgressHUD.showSuccess(
            withStatus: "Data migration completion"
        )
    }
}


// MARK: - 迁移数据
extension SHDataMigrationViewController {
    
    /// 修改旧的数据库名称为默认的数据库名称
    func chaneOldDataBaseFileToDefaultDataBaseFile() -> Bool {
        
        let sourceDataBasePath =
            FileTools.documentPath() + "/" + oldDataBase
        
        let destDataBasePath =
            FileTools.documentPath() + "/" + dataBaseName
        
        guard ((try? FileManager.default.removeItem(atPath: destDataBasePath)) != nil) else {
            return false
        }
        
        guard ((try? FileManager.default.moveItem(atPath: sourceDataBasePath, toPath: destDataBasePath)) != nil) else {
            
            return false
        }
        
        // 重启数据库
        SHSQLiteManager.shared.restart()
        
        return true
    }
    
    /// 判断旧数据库文件能否使用
    func isOldDataBaseFileExist() -> Bool {
        
        let sourceDataBasePath = FileTools.documentPath() + "/" + oldDataBase
        
        return FileManager.default.fileExists(atPath: sourceDataBasePath)
    }
    
    /// 迁移数据
    func migrationData() -> Bool {
        
        let sourceDataBasePath =
            FileTools.documentPath() + "/" + oldDataBase
        
        SHSQLiteManager.shared.queue =
            FMDatabaseQueue(path: sourceDataBasePath)
        
        if changeSystemDefnition() == false {
            return false
        }
        
        if changeZoneSystems() == false {
            return false
        }
        
        if changeZones() == false {
            return false
        }
        
        if changeZoneImages() == false {
            
            return false
        }
        
        if changeZoneLights() == false {
            return false
        }
        
        if changeHVACSetUpHVAC() == false {
            return false
        }
        
        if changeZoneHVAC() == false {
            return false
        }
        
        if changeZoneAudio() == false {
            return false
        }
        
        if changeZoneFan() == false {
            return false
        }
        
        if changeZoneShade() == false {
            return false
        }
        
        if changeZoneMood() == false {
            return false
        }
        
        if changeMoodCommand() == false {
            return false
        }
        
        if changeZoneTV() == false {
            
            return false
        }
        
        if changeZoneAppleTV() == false {
            return false
        }
        
        if changeZoneDVD() == false {
            return false
        }
        
        if changeZoneProjector() == false {
            return false
        }
        
        if changeZoneSATCategory() == false {
            return false
        }
        
        if changeZoneSATChannels() == false {
            return false
        }
        
        if changeZoneSAT() == false {
            return false
        }
        
        if changeMacroButtons() == false {
            return false
        }
        
        if changeMacroCommands() == false {
            return false
        }
        
        if changeCentralLights() == false {
            return false
        }
        
        if changeCentralLightCommands() == false {
            return false
        }
        
        if changeCentralSecurity() == false {
            return false
        }
        
        if changeCentralHVAC() == false {
            return false
        }
        
        if changeCentralHVACCommands() == false {
            return false
        }
        
        // 删除一些数据库
        
        _ = SHSQLiteManager.shared.deleteTable(
            "CommandTypeDefinition"
        )
        
        _ = SHSQLiteManager.shared.deleteTable("Camera")
        _ = SHSQLiteManager.shared.deleteTable("IpCamera")
        
        _ = SHSQLiteManager.shared.deleteTable("Schedules")
        _ = SHSQLiteManager.shared.deleteTable(
            "ScheduleCommands"
        )
        
        // 指向新的数据库
        let destDataBasePath = FileTools.documentPath() + "/" + dataBaseName
        
        SHSQLiteManager.shared.queue =
            FMDatabaseQueue(path: destDataBasePath)
        
        return true
    }
    
    
}


// MARK: - 多媒体设备
extension SHDataMigrationViewController {
    
    /// SAT通道迁移
    func changeZoneSATChannels() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS  SATChannels_tmp ("       +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,  "             +
                "CategoryID INTEGER NOT NULL DEFAULT 0, "             +
                "ChannelID INTEGER NOT NULL DEFAULT 0, "              +
                "ChannelNo INTEGER NOT NULL DEFAULT 0, "              +
                "ChannelName  TEXT NOT NULL DEFAULT 'channel Name',"   +
                "iconName TEXT NOT NULL DEFAULT 'iconName',"          +
                "SequenceNo  INTEGER NOT NULL DEFAULT 0, "            +
        "ZoneID INTEGER NOT NULL DEFAULT 0);"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL =
            "INSERT INTO SATChannels_tmp (  "                       +
                "CategoryID, ChannelID, ChannelNo, ChannelName, "       +
                "iconName, SequenceNo) SELECT CategoryID, ChannelID,"   +
                "ChannelNo, ChannelName, 'mediaSATChannelDefault',  "   +
        "SequenceNo FROM SATChannels;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("SATChannels")
        
        _ = SHSQLiteManager.shared.renameTable(
            "SATChannels_tmp",
            toName: "SATChannels"
        )
        
        return true
    }
    
    /// SAT分类迁移
    func changeZoneSATCategory() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS  SATCategory_tmp ( "        +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"                 +
                "CategoryID INTEGER  NOT NULL DEFAULT 0, "              +
                "CategoryName  TEXT  NOT NULL DEFAULT 'categoryName', " +
                "SequenceNo INTEGER NOT NULL DEFAULT 0, "               +
        "ZoneID INTEGER NOT NULL DEFAULT 0 );"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL =
        "INSERT INTO SATCategory_tmp (CategoryID, CategoryName, SequenceNo) SELECT CategoryID, CategoryName, SequenceNo FROM SATCategory;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("SATCategory")
        
        _ = SHSQLiteManager.shared.renameTable(
            "SATCategory_tmp",
            toName: "SATCategory"
        )
        
        return true
    }
    
    /// 区域SAT数据迁移
    func changeZoneSAT() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS SATInZone_tmp ("            +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT, "                +
                "remark text NOT NULL DEFAULT('SAT'),  "                +
                "ZoneID INTEGER DEFAULT 0,             "                +
                "SubnetID INTEGER DEFAULT 1,           "                +
                "DeviceID INTEGER DEFAULT 0,           "                +
                "UniversalSwitchIDforOn INTEGER DEFAULT 0,       "      +
                "UniversalSwitchStatusforOn INTEGER DEFAULT 255, "      +
                "UniversalSwitchIDforOff INTEGER DEFAULT 0,      "      +
                "UniversalSwitchStatusforOff INTEGER DEFAULT 0,  "      +
                "UniversalSwitchIDforUp INTEGER DEFAULT 0,       "      +
                "UniversalSwitchIDforDown INTEGER DEFAULT 0,     "      +
                "UniversalSwitchIDforLeft INTEGER DEFAULT 0,     "      +
                "UniversalSwitchIDforRight INTEGER DEFAULT 0,    "      +
                "UniversalSwitchIDforOK INTEGER DEFAULT 0,       "      +
                "UniversalSwitchIDfoMenu INTEGER DEFAULT 0,      "      +
                "UniversalSwitchIDforFAV INTEGER DEFAULT 0,      "      +
                "UniversalSwitchIDfor0 INTEGER DEFAULT 0,        "      +
                "UniversalSwitchIDfor1 INTEGER DEFAULT 0,        "      +
                "UniversalSwitchIDfor2 INTEGER DEFAULT 0,        "      +
                "UniversalSwitchIDfor3 INTEGER DEFAULT 0,        "      +
                "UniversalSwitchIDfor4 INTEGER DEFAULT 0,        "      +
                "UniversalSwitchIDfor5 INTEGER DEFAULT 0,        "      +
                "UniversalSwitchIDfor6 INTEGER DEFAULT 0,        "      +
                "UniversalSwitchIDfor7 INTEGER DEFAULT 0,        "      +
                "UniversalSwitchIDfor8 INTEGER DEFAULT 0,        "      +
                "UniversalSwitchIDfor9 INTEGER DEFAULT 0,        "      +
                "UniversalSwitchIDforPREVChapter INTEGER DEFAULT 0, "   +
                "UniversalSwitchIDforNextChapter INTEGER DEFAULT 0,  "  +
                "UniversalSwitchIDforPlayRecord INTEGER DEFAULT 0,   "  +
                "UniversalSwitchIDforPlayStopRecord INTEGER DEFAULT 0, " +
                "IRMacroNumberForSATSpare0 INTEGER DEFAULT 0,        "  +
                "IRMacroNumberForSATSpare1 INTEGER DEFAULT 0,        "  +
                "IRMacroNumberForSATSpare2 INTEGER DEFAULT 0,        "  +
                "IRMacroNumberForSATSpare3 INTEGER DEFAULT 0,        "  +
                "IRMacroNumberForSATSpare4 INTEGER DEFAULT 0,        "  +
        "IRMacroNumberForSATSpare5 INTEGER DEFAULT 0);"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL =
            "INSERT INTO SATInZone_tmp ("       +
                "ZoneID, SubnetID, DeviceID,"       +
                "UniversalSwitchIDforOn, "          +
                "UniversalSwitchStatusforOn, "      +
                "UniversalSwitchIDforOff, "         +
                "UniversalSwitchStatusforOff, "     +
                "UniversalSwitchIDforUp, "          +
                "UniversalSwitchIDforDown, "        +
                "UniversalSwitchIDforLeft, "        +
                "UniversalSwitchIDforRight, "       +
                "UniversalSwitchIDforOK, "          +
                "UniversalSwitchIDfoMenu, "         +
                "UniversalSwitchIDforFAV, "         +
                "UniversalSwitchIDfor0, "           +
                "UniversalSwitchIDfor1, "           +
                "UniversalSwitchIDfor2, "           +
                "UniversalSwitchIDfor3, "           +
                "UniversalSwitchIDfor4, "           +
                "UniversalSwitchIDfor5, "           +
                "UniversalSwitchIDfor6, "           +
                "UniversalSwitchIDfor7, "           +
                "UniversalSwitchIDfor8, "           +
                "UniversalSwitchIDfor9, "           +
                "UniversalSwitchIDforPlayRecord,"   +
                "UniversalSwitchIDforPlayStopRecord,"   +
                "IRMacroNumberForSATSpare0, "       +
                "IRMacroNumberForSATSpare1, "       +
                "IRMacroNumberForSATSpare2, "       +
                "IRMacroNumberForSATSpare3, "       +
                "IRMacroNumberForSATSpare4, "       +
                "IRMacroNumberForSATSpare5) " +
                "SELECT ZoneID, SubnetID, DeviceID,"    +
                "UniversalSwitchIDforOn, "          +
                "UniversalSwitchStatusforOn, "      +
                "UniversalSwitchIDforOff, "         +
                "UniversalSwitchStatusforOff, "     +
                "UniversalSwitchIDfoUp, "           +
                "UniversalSwitchIDforDown, "        +
                "UniversalSwitchIDforLeft, "        +
                "UniversalSwitchIDforRight, "       +
                "UniversalSwitchIDforOK, "          +
                "UniversalSwitchIDfoMenu, "         +
                "UniversalSwitchIDforFAV, "         +
                "UniversalSwitchIDfor0, "           +
                "UniversalSwitchIDfor1, "           +
                "UniversalSwitchIDfor2, "           +
                "UniversalSwitchIDfor3, "           +
                "UniversalSwitchIDfor4, "           +
                "UniversalSwitchIDfor5, "           +
                "UniversalSwitchIDfor6, "           +
                "UniversalSwitchIDfor7, "           +
                "UniversalSwitchIDfor8, "           +
                "UniversalSwitchIDfor9, "           +
                "UniversalSwithIDForRecord, "       +
                "UniversalSwithIDForStopRecord,"    +
                "IRMacroNumbForSATStart, "          +
                "IRMacroNumbForSATSpare1,"          +
                "IRMacroNumbForSATSpare2, "         +
                "IRMacroNumbForSATSpare3, "         +
                "IRMacroNumbForSATSpare4, "         +
        "IRMacroNumbForSATSpare5 FROM SATInZone;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("SATInZone")
        
        _ = SHSQLiteManager.shared.renameTable(
            "SATInZone_tmp",
            toName: "SATInZone"
        )
        
        return true
    }
    
    /// 投影仪数据迁移
    func changeZoneProjector() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS ProjectorInZone_tmp ("   +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"              +
                "remark text NOT NULL DEFAULT('PROJECTOR'),"         +
                "ZoneID INTEGER DEFAULT 0,"                          +
                "SubnetID INTEGER DEFAULT 1,"                        +
                "DeviceID INTEGER DEFAULT 0,"                        +
                "UniversalSwitchIDforOn INTEGER DEFAULT 0,"          +
                "UniversalSwitchStatusforOn INTEGER DEFAULT 255,"    +
                "UniversalSwitchIDforOff INTEGER DEFAULT 0,"         +
                "UniversalSwitchStatusforOff INTEGER DEFAULT 255,"   +
                "UniversalSwitchIDfoUp INTEGER DEFAULT 0,"           +
                "UniversalSwitchIDforDown INTEGER DEFAULT 0,"        +
                "UniversalSwitchIDforLeft INTEGER DEFAULT 0, "       +
                "UniversalSwitchIDforRight INTEGER DEFAULT 0,"       +
                "UniversalSwitchIDforOK INTEGER DEFAULT 0, "         +
                "UniversalSwitchIDfoMenu INTEGER DEFAULT 0,  "       +
                "UniversalSwitchIDforSource INTEGER DEFAULT 0,"      +
                "IRMacroNumberForProjectorSpare0 INTEGER DEFAULT 0," +
                "IRMacroNumberForProjectorSpare1 INTEGER DEFAULT 0," +
                "IRMacroNumberForProjectorSpare2 INTEGER DEFAULT 0," +
                "IRMacroNumberForProjectorSpare3 INTEGER DEFAULT 0," +
                "IRMacroNumberForProjectorSpare4 INTEGER DEFAULT 0," +
        "IRMacroNumberForProjectorSpare5 INTEGER DEFAULT 0);"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL =
            "INSERT INTO ProjectorInZone_tmp("      +
                "ZoneID, SubnetID, DeviceID,"           +
                "UniversalSwitchIDforOn,"               +
                "UniversalSwitchStatusforOn,"           +
                "UniversalSwitchIDforOff,"              +
                "UniversalSwitchStatusforOff,"          +
                "UniversalSwitchIDfoUp, "               +
                "UniversalSwitchIDforDown,"             +
                "UniversalSwitchIDforLeft, "            +
                "UniversalSwitchIDforRight, "           +
                "UniversalSwitchIDforOK, "              +
                "UniversalSwitchIDfoMenu, "             +
                "UniversalSwitchIDforSource,"           +
                "IRMacroNumberForProjectorSpare0,"      +
                "IRMacroNumberForProjectorSpare1,"      +
                "IRMacroNumberForProjectorSpare2,"      +
                "IRMacroNumberForProjectorSpare3,"      +
                "IRMacroNumberForProjectorSpare4,"      +
                "IRMacroNumberForProjectorSpare5)   "   +
                "SELECT ZoneID, SubnetID, DeviceID, "   +
                "UniversalSwitchIDforOn, "              +
                "UniversalSwitchStatusforOn, "          +
                "UniversalSwitchIDforOff, "             +
                "UniversalSwitchStatusforOff, "         +
                "UniversalSwitchIDfoUp,"                +
                "UniversalSwitchIDforDown, "            +
                "UniversalSwitchIDforLeft, "            +
                "UniversalSwitchIDforRight, "           +
                "UniversalSwitchIDforOK, "              +
                "UniversalSwitchIDfoMenu, "             +
                "UniversalSwitchIDforSource,"           +
                "IRMacroNumbForProjectorStart,"         +
                "IRMacroNumbForProjectorSpare1,"        +
                "IRMacroNumbForProjectorSpare2,"        +
                "IRMacroNumbForProjectorSpare3,"        +
                "IRMacroNumbForProjectorSpare4,"        +
        "IRMacroNumbForProjectorSpare5 FROM ProjectorInZone;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable(
            "ProjectorInZone"
        )
        
        _ = SHSQLiteManager.shared.renameTable(
            "ProjectorInZone_tmp",
            toName: "ProjectorInZone"
        )
        
        return true
    }
    
    /// DVD数据迁移
    func changeZoneDVD() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS DVDInZone_tmp ("          +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"               +
                "remark text NOT NULL DEFAULT('DVD'),"                +
                "ZoneID INTEGER DEFAULT 0,"                           +
                "SubnetID INTEGER DEFAULT 1,"                         +
                "DeviceID INTEGER DEFAULT 0,"                         +
                "UniversalSwitchIDforOn INTEGER DEFAULT 1,"           +
                "UniversalSwitchStatusforOn INTEGER DEFAULT 255, "    +
                "UniversalSwitchIDforOff INTEGER DEFAULT 1,"          +
                "UniversalSwitchStatusforOff INTEGER DEFAULT 0,"      +
                "UniversalSwitchIDfoMenu INTEGER DEFAULT 7,"          +
                "UniversalSwitchIDfoUp INTEGER DEFAULT 2,"            +
                "UniversalSwitchIDforDown INTEGER DEFAULT 3,"         +
                "UniversalSwitchIDforFastForward INTEGER DEFAULT 5,"  +
                "UniversalSwitchIDforBackForward INTEGER DEFAULT 4,"  +
                "UniversalSwitchIDforOK INTEGER DEFAULT 6, "          +
                "UniversalSwitchIDforPREVChapter INTEGER DEFAULT 0,"  +
                "UniversalSwitchIDforNextChapter INTEGER DEFAULT 0,"  +
                "UniversalSwitchIDforPlayPause INTEGER DEFAULT 8, "   +
                "UniversalSwitchIDforPlayRecord INTEGER DEFAULT 11,"  +
                "UniversalSwitchIDforPlayStopRecord INTEGER DEFAULT 22," +
                "IRMacroNumberForDVDStart0 INTEGER DEFAULT 33, "      +
                "IRMacroNumberForDVDStart1 INTEGER DEFAULT 1, "       +
                "IRMacroNumberForDVDStart2 INTEGER DEFAULT 2, "       +
                "IRMacroNumberForDVDStart3 INTEGER DEFAULT 3, "       +
                "IRMacroNumberForDVDStart4 INTEGER DEFAULT 4, "       +
        "IRMacroNumberForDVDStart5 INTEGER DEFAULT 5 );"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL =
            "INSERT INTO DVDInZone_tmp(         "   +
                "ZoneID, SubnetID, DeviceID,        "   +
                "UniversalSwitchIDforOn,            "   +
                "UniversalSwitchStatusforOn,        "   +
                "UniversalSwitchIDforOff,           "   +
                "UniversalSwitchStatusforOff,       "   +
                "UniversalSwitchIDfoMenu,           "   +
                "UniversalSwitchIDfoUp,             "   +
                "UniversalSwitchIDforDown,          "   +
                "UniversalSwitchIDforFastForward,   "   +
                "UniversalSwitchIDforBackForward,   "   +
                "UniversalSwitchIDforOK,            "   +
                "UniversalSwitchIDforPREVChapter,   "   +
                "UniversalSwitchIDforNextChapter,   "   +
                "UniversalSwitchIDforPlayPause,     "   +
                "UniversalSwitchIDforPlayRecord,    "   +
                "UniversalSwitchIDforPlayStopRecord,"   +
                "IRMacroNumberForDVDStart0,         "   +
                "IRMacroNumberForDVDStart1,         "   +
                "IRMacroNumberForDVDStart2,         "   +
                "IRMacroNumberForDVDStart3,         "   +
                "IRMacroNumberForDVDStart4,         "   +
                "IRMacroNumberForDVDStart5)         "   +
                "SELECT ZoneID, SubnetID, DeviceID, "   +
                "UniversalSwitchIDforOn,            "   +
                "UniversalSwitchStatusforOn,        "   +
                "UniversalSwitchIDforOff,           "   +
                "UniversalSwitchStatusforOff,       "   +
                "UniversalSwitchIDfoMenu,           "   +
                "UniversalSwitchIDfoUp,             "   +
                "UniversalSwitchIDforDown,          "   +
                "UniversalSwitchIDforFastForward,   "   +
                "UniversalSwitchIDforBackForward,   "   +
                "UniversalSwitchIDforOK,            "   +
                "UniversalSwitchIDforPREVChapter,   "   +
                "UniversalSwitchIDforNextChapter,   "   +
                "UniversalSwitchIDforPlayPause,     "   +
                "UniversalSwithIDForRecord,         "   +
                "UniversalSwithIDForStopRecord,     "   +
                "IRMacroNumbForDVDStart,            "   +
                "IRMacroNumbForDVDSpare1,           "   +
                "IRMacroNumbForDVDSpare2,           "   +
                "IRMacroNumbForDVDSpare3,           "   +
                "IRMacroNumbForDVDSpare4,           "   +
        "IRMacroNumbForDVDSpare5 FROM DVDInZone;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("DVDInZone")
        
        _ = SHSQLiteManager.shared.renameTable(
            "DVDInZone_tmp",
            toName: "DVDInZone"
        )
        
        return true
    }
    
    /// AppleTv
    func changeZoneAppleTV() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS AppleTVInZone_tmp ("      +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"               +
                "remark text NOT NULL DEFAULT('APPLE TV'),"           +
                "ZoneID INTEGER DEFAULT 0, "                          +
                "SubnetID INTEGER DEFAULT 1,"                         +
                "DeviceID INTEGER DEFAULT 0, "                        +
                "UniversalSwitchIDforOn INTEGER DEFAULT 1,"           +
                "UniversalSwitchStatusforOn INTEGER DEFAULT 255,"     +
                "UniversalSwitchIDforOff INTEGER DEFAULT 1, "         +
                "UniversalSwitchStatusforOff INTEGER DEFAULT 0,"      +
                "UniversalSwitchIDforUp INTEGER DEFAULT 2,"           +
                "UniversalSwitchIDforDown INTEGER DEFAULT 3,"         +
                "UniversalSwitchIDforLeft INTEGER DEFAULT 4, "        +
                "UniversalSwitchIDforRight INTEGER DEFAULT 5,"        +
                "UniversalSwitchIDforOK INTEGER DEFAULT 6,  "         +
                "UniversalSwitchIDforMenu INTEGER DEFAULT 7, "        +
                "UniversalSwitchIDforPlayPause INTEGER DEFAULT 8,"    +
                "IRMacroNumberForAppleTVStart0 INTEGER DEFAULT 0,"    +
                "IRMacroNumberForAppleTVStart1 INTEGER DEFAULT 0,"    +
                "IRMacroNumberForAppleTVStart2 INTEGER DEFAULT 0,"    +
                "IRMacroNumberForAppleTVStart3 INTEGER DEFAULT 0,"    +
                "IRMacroNumberForAppleTVStart4 INTEGER DEFAULT 0,"    +
        "IRMacroNumberForAppleTVStart5 INTEGER DEFAULT 0);"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL =
            "INSERT INTO AppleTVInZone_tmp(ZoneID, SubnetID,"   +
                "DeviceID, UniversalSwitchIDforOn, "                +
                "UniversalSwitchStatusforOn,    "                   +
                "UniversalSwitchIDforOff,       "                   +
                "UniversalSwitchStatusforOff,   "                   +
                "UniversalSwitchIDforUp,        "                   +
                "UniversalSwitchIDforDown,      "                   +
                "UniversalSwitchIDforLeft,      "                   +
                "UniversalSwitchIDforRight,     "                   +
                "UniversalSwitchIDforOK,        "                   +
                "UniversalSwitchIDforMenu,      "                   +
                "UniversalSwitchIDforPlayPause, "                   +
                "IRMacroNumberForAppleTVStart0, "                   +
                "IRMacroNumberForAppleTVStart1, "                   +
                "IRMacroNumberForAppleTVStart2, "                   +
                "IRMacroNumberForAppleTVStart3, "                   +
                "IRMacroNumberForAppleTVStart4, "                   +
                "IRMacroNumberForAppleTVStart5) "                   +
                "SELECT ZoneID, SubnetID, DeviceID, "               +
                "UniversalSwitchIDforOn, "                          +
                "UniversalSwitchStatusforOn, "                      +
                "UniversalSwitchIDforOff, "                         +
                "UniversalSwitchStatusforOff, "                     +
                "UniversalSwitchIDforUp, "                          +
                "UniversalSwitchIDforDown, "                        +
                "UniversalSwitchIDforLeft, "                        +
                "UniversalSwitchIDforRight, "                       +
                "UniversalSwitchIDforOK, "                          +
                "UniversalSwitchIDforMenu, "                        +
                "UniversalSwitchIDforPlayPause, "                   +
                "IRMacroNumbForAppleTVStart,  "                     +
                "IRMacroNumbForAppleTVSpare1, "                     +
                "IRMacroNumbForAppleTVSpare2, "                     +
                "IRMacroNumbForAppleTVSpare3, "                     +
                "IRMacroNumbForAppleTVSpare4, "                     +
        "IRMacroNumbForAppleTVSpare5 FROM AppleTVInZone;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable(
            "AppleTVInZone"
        )
        
        _ = SHSQLiteManager.shared.renameTable(
            "AppleTVInZone_tmp",
            toName: "AppleTVInZone"
        )
        
        return true
    }
    
    /// 电视
    func changeZoneTV() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS TVInZone_tmp ("           +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"               +
                "remark text NOT NULL DEFAULT('TV'),"                 +
                "ZoneID INTEGER DEFAULT 0,"                           +
                "SubnetID INTEGER DEFAULT 1,"                         +
                "DeviceID INTEGER DEFAULT 0,"                         +
                "UniversalSwitchIDforOn INTEGER DEFAULT 1,"           +
                "UniversalSwitchStatusforOn ININTEGERT DEFAULT 255, " +
                "UniversalSwitchIDforOff INTEGER DEFAULT 1,"          +
                "UniversalSwitchStatusforOff INTEGER DEFAULT 0,"      +
                "UniversalSwitchIDforCHAdd INTEGER DEFAULT 0,"        +
                "UniversalSwitchIDforCHMinus INTEGER DEFAULT 0,"      +
                "UniversalSwitchIDforVOLUp INTEGER DEFAULT 0,"        +
                "UniversalSwitchIDforVOLDown INTEGER DEFAULT 0,"      +
                "UniversalSwitchIDforMute INTEGER DEFAULT 0, "        +
                "UniversalSwitchIDforMenu INTEGER DEFAULT 0,"         +
                "UniversalSwitchIDforSource INTEGER DEFAULT 0,"       +
                "UniversalSwitchIDforOK INTEGER DEFAULT 0, "          +
                "UniversalSwitchIDfor0 INTEGER DEFAULT 0,"            +
                "UniversalSwitchIDfor1 INTEGER DEFAULT 0,"            +
                "UniversalSwitchIDfor2 INTEGER DEFAULT 0,"            +
                "UniversalSwitchIDfor3 INTEGER DEFAULT 0,"            +
                "UniversalSwitchIDfor4 INTEGER DEFAULT 0,"            +
                "UniversalSwitchIDfor5 INTEGER DEFAULT 0,"            +
                "UniversalSwitchIDfor6 INTEGER DEFAULT 0,"            +
                "UniversalSwitchIDfor7 INTEGER DEFAULT 0,"            +
                "UniversalSwitchIDfor8 INTEGER DEFAULT 0,"            +
                "UniversalSwitchIDfor9 INTEGER DEFAULT 0,"            +
                "IRMacroNumberForTVStart0 INTEGER DEFAULT 0,"         +
                "IRMacroNumberForTVStart1 INTEGER DEFAULT 0,"         +
                "IRMacroNumberForTVStart2 INTEGER DEFAULT 0,"         +
                "IRMacroNumberForTVStart3 INTEGER DEFAULT 0,"         +
                "IRMacroNumberForTVStart4 INTEGER DEFAULT 0,"         +
        "IRMacroNumberForTVStart5 INTEGER DEFAULT 0);"
        
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL =
            "INSERT INTO TVInZone_tmp (ZoneID, SubnetID, DeviceID," +
                "UniversalSwitchIDforOn,"                               +
                "UniversalSwitchStatusforOn,"                           +
                "UniversalSwitchIDforOff, "                             +
                "UniversalSwitchStatusforOff,"                          +
                "UniversalSwitchIDforCHAdd, "                           +
                "UniversalSwitchIDforCHMinus,"                          +
                "UniversalSwitchIDforVOLUp, "                           +
                "UniversalSwitchIDforVOLDown, "                         +
                "UniversalSwitchIDforMute,"                             +
                "UniversalSwitchIDforMenu,"                             +
                "UniversalSwitchIDforSource,"                           +
                "UniversalSwitchIDforOK, "                              +
                "UniversalSwitchIDfor0, "                               +
                "UniversalSwitchIDfor1, "                               +
                "UniversalSwitchIDfor2, "                               +
                "UniversalSwitchIDfor3, "                               +
                "UniversalSwitchIDfor4, "                               +
                "UniversalSwitchIDfor5, "                               +
                "UniversalSwitchIDfor6, "                               +
                "UniversalSwitchIDfor7, "                               +
                "UniversalSwitchIDfor8, "                               +
                "UniversalSwitchIDfor9, "                               +
                "IRMacroNumberForTVStart0, "                            +
                "IRMacroNumberForTVStart1, "                            +
                "IRMacroNumberForTVStart2, "                            +
                "IRMacroNumberForTVStart3, "                            +
                "IRMacroNumberForTVStart4, "                            +
                "IRMacroNumberForTVStart5)  SELECT ZoneID, SubnetID,"   +
                "DeviceID, UniversalSwitchIDforOn,"                     +
                "UniversalSwitchStatusforOn, "                          +
                "UniversalSwitchIDforOff, "                             +
                "UniversalSwitchStatusforOff,"                          +
                "\"UniversalSwitchIDforCH+\","                          +
                "\"UniversalSwitchIDforCH-\","                          +
                "\"UniversalSwitchIDforVOL+\","                         +
                "\"UniversalSwitchIDforVOL-\", "                        +
                "UniversalSwitchIDforMute, "                            +
                "UniversalSwitchIDforMenu,"                             +
                "UniversalSwitchIDforSource,"                           +
                "UniversalSwitchIDforOK,"                               +
                "UniversalSwitchIDfor0,"                                +
                "UniversalSwitchIDfor1,"                                +
                "UniversalSwitchIDfor2,"                                +
                "UniversalSwitchIDfor3,"                                +
                "UniversalSwitchIDfor4,"                                +
                "UniversalSwitchIDfor5,"                                +
                "UniversalSwitchIDfor6,"                                +
                "UniversalSwitchIDfor7,"                                +
                "UniversalSwitchIDfor8,"                                +
                "UniversalSwitchIDfor9,"                                +
                "IRMacroNumbForTVStart,"                                +
                "IRMacroNumbForTVSpare1,"                               +
                "IRMacroNumbForTVSpare2,"                               +
                "IRMacroNumbForTVSpare3,"                               +
                "IRMacroNumbForTVSpare4,"                               +
        "IRMacroNumbForTVSpare5 FROM TVInZone;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("TVInZone")
        
        _ = SHSQLiteManager.shared.renameTable(
            "TVInZone_tmp",
            toName: "TVInZone"
        )
        
        return true
    }
}

// MARK: - 区域控制中的设备数据迁移
extension SHDataMigrationViewController {
    
    func changeZoneLights() -> Bool {
        
        _ = SHSQLiteManager.shared.deleteTable(
            "LightTypeDefinition"
        )
        
        let createNewTableSql =
            "CREATE TABLE LightInZone_tmp ("            +
                "ZoneID integer,     "                      +
                "LightID integer,    "                      +
                "LightRemark text,   "                      +
                "SubnetID integer,   "                      +
                "DeviceID int,       "                      +
                "ChannelNo integer,  "                      +
                "CanDim integer NOT NULL DEFAULT(0), "      +
                "LightTypeID integer, "                     +
        "id integer PRIMARY KEY AUTOINCREMENT NOT NULL);"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL = "INSERT INTO LightInZone_tmp (ZoneID, LightID, LightRemark, SubnetID, DeviceID, ChannelNo, CanDim, LightTypeID) SELECT ZoneID, LightID, LightRemark, SubnetID, DeviceID, ChannelNo, CanDim, LightTypeID FROM LightInZone;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("LightInZone")
        
        _ = SHSQLiteManager.shared.renameTable(
            "LightInZone_tmp",
            toName: "LightInZone"
        )
        
        return true
    }
    
    func changeZoneHVAC() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE HVACInZone_tmp ("         +
                "ZoneID integer,   "                    +
                "SubnetID integer, "                    +
                "DeviceID integer, "                    +
                "ACNumber integer DEFAULT(0), "         +
                "ACTypeID integer NOT NULL DEFAULT(1)," +
                "ACRemark text,"                        +
        "id integer PRIMARY KEY NOT NULL);"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL = "INSERT INTO HVACInZone_tmp (ZoneID, SubnetID, DeviceID, ACNumber, ACTypeID, ACRemark) SELECT ZoneID, SubnetID, DeviceID, ACNumber, ACTypeID, Remark FROM HVACInZone;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("HVACInZone")
        
        _ = SHSQLiteManager.shared.renameTable(
            "HVACInZone_tmp",
            toName: "HVACInZone"
        )
        
        return true
    }
    
    /// 数据库的配置信息
    func changeHVACSetUpHVAC() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE HVACSetUp_tmp ("              +
                "ID integer PRIMARY KEY,  "                 +
                "isCelsius bool DEFAULT(1), "               +
                "TempertureOfCold integer DEFAULT(16), "    +
                "TempertureOfCool integer DEFAULT(22),"     +
                "TempertureOfWarm integer DEFAULT(26), "    +
        "TempertureOfHot integer DEFAULT(30) );"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL = "INSERT INTO HVACSetUp_tmp (isCelsius, TempertureOfCold, TempertureOfCool, TempertureOfWarm, TempertureOfHot) SELECT IsCelsiur, TempertureOfCold, TempertureOfCool, TempertureOfWarm, TempertureOfHot FROM HVACSetUp;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("HVACSetUp")
        
        _ = SHSQLiteManager.shared.renameTable(
            "HVACSetUp_tmp",
            toName: "HVACSetUp"
        )
        
        return true
    }
    
    /// 区域Audio数据
    func changeZoneAudio() -> Bool {
        
        _ = SHSQLiteManager.shared.deleteTable("ZAudioId")
        
        let createNewTableSql =
            "CREATE TABLE ZaudioInZone_tmp ( "      +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"     +
                "ZoneID INTEGER DEFAULT 0,"                 +
                "SubnetID INTEGER DEFAULT 1,  "             +
                "DeviceID INTEGER DEFAULT 0, "              +
                "haveSdCard integer NOT NULL DEFAULT(1), "  +
                "haveFtp integer NOT NULL DEFAULT(1),  "    +
                "haveRadio integer NOT NULL DEFAULT(1), "   +
                "haveAudioIn integer NOT NULL DEFAULT(1), " +
        "havePhone integer NOT NULL DEFAULT(0));"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL =
            "INSERT INTO ZaudioInZone_tmp (ZoneID, SubnetID," +
                "DeviceID) SELECT ZoneID, SubnetID, DeviceID "    +
        "FROM ZaudioInZone;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable(
            "ZaudioInZone"
        )
        
        _ = SHSQLiteManager.shared.renameTable(
            "ZaudioInZone_tmp",
            toName: "ZaudioInZone"
        )
        
        return true
    }
    
    /// 风扇数据
    func changeZoneFan() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE FanInZone_tmp ("               +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"      +
                "ZoneID INTEGER,                        "    +
                "FanID INTEGER DEFAULT 1,  "                 +
                "FanName TEXT NOT NULL DEFAULT 'Fan', "      +
                "SubnetID INTEGER DEFAULT 1, "               +
                "DeviceID INTEGER DEFAULT 0,  "              +
                "ChannelNO INTEGER DEFAULT 0, "              +
                "FanTypeID INTEGER DEFAULT 0, "              +
                "Remark TEXT NOT NULL DEFAULT 'Fan', "       +
                "Reserved1 INTEGER DEFAULT 0,       "        +
                "Reserved2 INTEGER DEFAULT 0,      "         +
                "Reserved3 INTEGER DEFAULT 0,     "          +
                "Reserved4 INTEGER DEFAULT 0,     "          +
        "Reserved5 INTEGER DEFAULT 0 );"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL =
            "INSERT INTO FanInZone_tmp (ZoneID, FanID,"     +
                "FanName, SubnetID, DeviceID, ChannelNO, "      +
                "FanTypeID, Reserved1, Reserved2, Reserved3,"   +
                "Reserved4, Reserved5 ) SELECT ZoneID,   "      +
                "FanID, FanName, SubnetID as integer, "         +
                "DeviceID as integer, ChannelNO as integer, "   +
                "FanTypeID as integer, Reserved1 as integer,"   +
                "Reserved2 as integer, Reserved3 as integer,"   +
        "Reserved4 as integer, Reserved5 as integer FROM FanInZone;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("FanInZone")
        
        _ = SHSQLiteManager.shared.renameTable(
            "FanInZone_tmp",
            toName: "FanInZone"
        )
        
        return true
    }
    
    /// 窗帘迁移
    func changeZoneShade() -> Bool {
        
        _ = SHSQLiteManager.shared.deleteTable(
            "ShadeIconDefinition"
        )
        
        _ = SHSQLiteManager.shared.deleteTable(
            "ShadesControlTypeDefinition"
        )
        
        let createShadeSQL =
            "CREATE TABLE IF NOT EXISTS ShadeInZone ("            +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT, "              +
                "ZoneID INTEGER DEFAULT 0,"                           +
                "ShadeID INTEGER DEFAULT 0,"                          +
                "ShadeName TEXT DEFAULT 'shade' ,"                    +
                "SubnetID INTEGER DEFAULT 1, "                        +
                "DeviceID INTEGER DEFAULT 0, "                        +
                "HasStop INTEGER DEFAULT 0, "                         +
                "openChannel INTEGER DEFAULT 0, "                     +
                "openingRatio INTEGER DEFAULT 100, "                  +
                "closeChannel INTEGER DEFAULT 0,   "                  +
                "closingRatio INTEGER DEFAULT 100,  "                 +
                "Reserved1 INTEGER DEFAULT 0,    "                    +
                "Reserved2 INTEGER DEFAULT 0,  "                      +
                "remarkForOpen text NOT NULL DEFAULT(''), "           +
                "remarkForClose text NOT NULL DEFAULT(''), "          +
                "remarkForStop text NOT NULL DEFAULT(''),  "          +
                "controlType INTEGER NOT NULL DEFAULT 0,  "           +
                "switchIDforOpen INTEGER NOT NULL DEFAULT 0, "        +
                "switchIDStatusforOpen INTEGER NOT NULL DEFAULT 0,"   +
                "switchIDforClose INTEGER NOT NULL DEFAULT 0,"        +
                "switchIDStatusforClose INTEGER NOT NULL DEFAULT 0,"  +
                "switchIDforStop INTEGER NOT NULL DEFAULT 0, "        +
        "switchIDStatusforStop INTEGER NOT NULL DEFAULT 0);"
        
        _ = SHSQLiteManager.shared.executeSql(createShadeSQL)
        
        let array = SHSQLiteManager.shared.selectProprty("select ZoneID, ShadeID, ShadeName, HasStop from ShadesInZone;") as? [[String: String]]
        
        if let shades = array {
            
            for dict in shades {
                
                let zoneID = UInt(dict["ZoneID"] ?? "") ?? 0
                let shadeID = UInt(dict["ShadeID"] ?? "") ?? 0
                
                let commandSql =
                    "select ZoneID, ShadeID, ShadeControlType,"     +
                        "CommandID, Remark, SubnetID, DeviceID,"        +
                        "CommandTypeID, FirstParameter,  "              +
                        "SecondParameter, ThirdParameter,"              +
                        "DelayMillisecondAfterSend    "                 +
                        "from ShadesCommands where ZoneID = \(zoneID) and"    +
                "shadeID = \(shadeID);"
                
                if let commands = SHSQLiteManager.shared.selectProprty(commandSql) as? [[String: String]] {
                    
                    let shade = SHShade()
                    shade.zoneID = zoneID
                    shade.shadeID = shadeID
                    shade.shadeName = dict["ShadeName"] ?? "curtain"
                    
                    shade.hasStop = UInt8(dict["HasStop"] ?? "") ?? 0
                    
                    shade.subnetID = UInt8(dict["SubnetID"] ?? "") ?? 0
                    shade.deviceID = UInt8(dict["DeviceID"] ?? "") ?? 0
                    
                    for commandDict in commands {
                        
                        // 获得操作类型
                        let commandType = UInt(commandDict["CommandTypeID"] ?? "") ?? 0
                        
                        // 控制方式
                        let shadeControlType =
                            UInt(commandDict["ShadeControlType"] ?? "") ?? 0
                        
                        if commandType == 4 ||
                            commandType == 6 ||
                            commandType == 7 {
                            
                            // 获得每一组的控制方式
                            shade.controlType = .defaultControl
                            
                            switch shadeControlType {
                                
                            case SHShadeCommandType.open.rawValue:
                                shade.remarkForOpen = commandDict["Remark"] ?? "open"
                                
                                shade.openChannel = UInt8(commandDict["FirstParameter"] ?? "") ?? 0
                                
                                shade.openingRatio = UInt8(commandDict["SecondParameter"] ?? "") ?? 0
                                
                            case SHShadeCommandType.close.rawValue:
                                shade.remarkForClose = commandDict["Remark"] ?? "close"
                                
                                shade.closeChannel = UInt8(commandDict["FirstParameter"] ?? "") ?? 0
                                
                                shade.closingRatio = UInt8(commandDict["SecondParameter"] ?? "") ?? 0
                                
                            case SHShadeCommandType.stop.rawValue:
                                shade.remarkForStop = commandDict["Remark"] ?? "stop"
                                
                            default:
                                break
                            }
                        } else {
                            
                            // 使用了开关控制 232 + RSIP == 红外
                            shade.controlType = .universalSwitch
                            
                            switch shadeControlType {
                                
                            case SHShadeCommandType.open.rawValue:
                                shade.remarkForOpen = commandDict["Remark"] ?? "open"
                                
                                shade.switchIDforOpen = UInt(commandDict["FirstParameter"] ?? "") ?? 0
                                
                                shade.switchIDStatusforOpen = UInt(commandDict["SecondParameter"] ?? "") ?? 0
                                
                            case SHShadeCommandType.close.rawValue:
                                
                                shade.remarkForClose = commandDict["Remark"] ?? "close"
                                
                                shade.switchIDforClose = UInt(commandDict["FirstParameter"] ?? "") ?? 0
                                
                                shade.switchIDStatusforClose = UInt(commandDict["SecondParameter"] ?? "") ?? 0
                                
                            case SHShadeCommandType.stop.rawValue:
                                shade.remarkForStop = commandDict["Remark"] ?? "stop"
                                
                                shade.switchIDforStop = UInt(commandDict["FirstParameter"] ?? "") ?? 0
                                
                                shade.switchIDStatusforStop = UInt(commandDict["SecondParameter"] ?? "") ?? 0
                                
                            default:
                                break
                            }
                        }
                    }
                    
                   
                    _ = SHSQLiteManager.shared.insertShade(
                        shade
                    )
                }
                
            }
            
        }
        
        
        _ = SHSQLiteManager.shared.deleteTable(
            "ShadesCommands"
        )
        
        _ = SHSQLiteManager.shared.deleteTable(
            "ShadesInZone"
        )
        
        return true
    }
    
    /// Mood数据迁移
    func changeZoneMood() -> Bool {
        
        _ = SHSQLiteManager.shared.deleteTable(
            "MoodIconDefinition"
        )
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS MoodInZone_tmp ("            +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"                  +
                "ZoneID INTEGER DEFAULT 0 ,"                             +
                "MoodID INTEGER DEFAULT 0 ,"                             +
                "MoodName TEXT NOT NULL DEFAULT 'newMood' ,"             +
                "MoodIconName  TEXT NOT NULL DEFAULT 'mood_romantic' , " +
        "IsSystemMood INTEGER DEFAULT 0);"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL = "INSERT INTO MoodInZone_tmp(ZoneID, MoodID, MoodName, IsSystemMood) SELECT ZoneID, MoodID, MoodName, IsSystemMood FROM  MoodInZone;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("MoodInZone")
        
        _ = SHSQLiteManager.shared.renameTable(
            "MoodInZone_tmp",
            toName: "MoodInZone"
        )
        
        return true
    }
    
    /// Mood的具体指令的数据迁移
    func changeMoodCommand() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS MoodCommands_tmp ("     +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"             +
                "ZoneID INTEGER NOT NULL DEFAULT 0 ,  "             +
                "MoodID INTEGER DEFAULT 0 , "                       +
                "deviceType INTEGER NOT NULL DEFAULT 0 ,"           +
                "SubnetID INTEGER NOT NULL DEFAULT  1 ,"            +
                "DeviceID INTEGER NOT NULL DEFAULT 0 ,"             +
                "deviceName TEXT NOT NULL DEFAULT 'DeviceName',"    +
                "Parameter1 INTEGER NOT NULL DEFAULT 0, "           +
                "Parameter2 INTEGER NOT NULL DEFAULT 0,"            +
                "Parameter3 INTEGER NOT NULL DEFAULT 0, "           +
                "Parameter4 INTEGER NOT NULL DEFAULT 0 ,"           +
                "Parameter5 INTEGER NOT NULL DEFAULT 0 , "          +
                "Parameter6 INTEGER NOT NULL DEFAULT 0 , "          +
        "DelayMillisecondAfterSend integer NOT NULL DEFAULT(100));"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let inserSQL =
            "INSERT INTO MoodCommands_tmp(ZoneID, MoodID,"       +
                "SubnetID, DeviceID, deviceName, Parameter6, "       +
                "Parameter1, Parameter2, Parameter3, "               +
                "DelayMillisecondAfterSend) SELECT ZoneID, MoodID, " +
                "SubnetID, DeviceID, Remark, CommandTypeID,"         +
                "FirstParameter, SecondParameter, ThirdParameter,"   +
        "DelayMillisecondAfterSend FROM MoodCommands;"
        
        _ = SHSQLiteManager.shared.executeSql(inserSQL)
        
        _ = SHSQLiteManager.shared.deleteTable(
            "MoodCommands"
        )
        
        _ = SHSQLiteManager.shared.renameTable(
            "MoodCommands_tmp",
            toName: "MoodCommands"
        )
        
        return true
    }
}

// MARK: - 区域控制中的通用数据迁移
extension SHDataMigrationViewController {
    
    /// 系统定义
    func changeSystemDefnition() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS systemDefnition_tmp (" +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT, "           +
                "SystemID INTEGER  DEFAULT 0, "                    +
        "SystemName TEXT DEFAULT  'systemName');"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL = "INSERT INTO systemDefnition_tmp(SystemID, SystemName) SELECT DISTINCT SystemID, SystemName FROM SystemDefinition;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable(
            "SystemDefinition"
        )
        
        _ = SHSQLiteManager.shared.renameTable(
            "systemDefnition_tmp",
            toName: "systemDefnition"
        )
        
        return true
    }
    
    /// 系统数据迁移
    func changeZoneSystems() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS SystemInZone_tmp (" +
                "ZoneID INTEGER,"                               +
        "SystemID INTEGER );"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL =
        "INSERT INTO SystemInZone_tmp(ZoneID, SystemID) SELECT DISTINCT ZoneID, SystemID FROM SystemInZone;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable(
            "SystemInZone"
        )
        
        _ = SHSQLiteManager.shared.renameTable(
            "SystemInZone_tmp",
            toName: "SystemInZone"
        )
        
        return true
    }
    
    /// 区域数据
    func changeZones() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS Zones_tmp (" +
                "ZoneID integer PRIMARY KEY, "           +
                "ZoneName text,  "                       +
        "zoneIconName text);"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL = "INSERT INTO Zones_tmp (ZoneID, ZoneName, zoneIconName) SELECT ZoneID, ZoneName, 'Demokit' FROM Zones;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("Zones")
        
        _ = SHSQLiteManager.shared.renameTable(
            "Zones_tmp",
            toName: "Zones"
        )
        
        _ = SHSQLiteManager.shared.deleteTable(
            "ZoneIconDefine"
        )
        
        return true
    }
    
    /// 区域图片
    func changeZoneImages() -> Bool {
        
        _ = SHSQLiteManager.shared.deleteTable("Logo")
        
        let createImages =
            "CREATE TABLE IF NOT EXISTS iconList (" +
                "iconID INTEGER PRIMARY KEY, "          +
        "iconName TEXT );"
        
        _ = SHSQLiteManager.shared.executeSql(createImages)
        
        let images = [
            "Assistants", "Ceooffice", "Corridor", "Demokit",
            "GMoffice", "Masterroom", "Meetingroom", "Restroom",
            "Sales", "Trainingroom"
        ]
        
        for i in 0 ..< images.count {
            
            let insertSQL = "INSERT INTO iconList(iconID, iconName) VALUES(\(i + 1), \(images[i]));"
            
            _ = SHSQLiteManager.shared.executeSql(insertSQL)
        }
        
        return true
    }
}

// MARK: - 中心控制的数据迁移
extension SHDataMigrationViewController {
    
    func changeCentralHVACCommands() -> Bool {
        
        let createCommands =
            "CREATE TABLE IF NOT EXISTS CentralHVACCommands_tmp (" +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"                +
                "FloorID INTEGER NOT NULL DEFAULT 0,"                  +
                "CommandID INTEGER NOT NULL DEFAULT 0,"                +
                "Remark TEXT DEFAULT 'hvaccommand', "                  +
                "SubnetID INTEGER NOT NULL DEFAULT 0,"                 +
                "DeviceID INTEGER NOT NULL DEFAULT 0,"                 +
                "CommandTypeID INTEGER NOT NULL DEFAULT 0, "           +
                "Parameter1  INTEGER NOT NULL DEFAULT 0,"              +
                "Parameter2 INTEGER NOT NULL DEFAULT 0,"               +
        "DelayMillisecondAfterSend INTEGER NOT NULL DEFAULT 0);"
        
        _ = SHSQLiteManager.shared.executeSql(createCommands)
        
        let insertSQL = "INSERT INTO CentralHVACCommands_tmp(FloorID, CommandID, Remark, SubnetID, DeviceID, CommandTypeID, DelayMillisecondAfterSend) SELECT FloorID, CommandID, Remark, SubnetID, DeviceID, CommandTypeID, DelayMillisecondAfterSend FROM CentralHVACCommands;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable(
            "CentralHVACCommands"
        )
        
        _ = SHSQLiteManager.shared.renameTable(
            "CentralHVACCommands_tmp",
            toName: "CentralHVACCommands"
        )
        
        return true
    }
    
    /// 中心区域HVAC
    func changeCentralHVAC() -> Bool {
        
        let createHVAC =
            "CREATE TABLE IF NOT EXISTS CentralHVAC_tmp ("  +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"         +
                "FloorID INTEGER NOT NULL DEFAULT 0,"           +
                "FloorName TEXT NOT NULL DEFAULT 'hvac',"       +
        "isHaveHot BOOL NOT NULL  DEFAULT 1);"
        
        _ = SHSQLiteManager.shared.executeSql(createHVAC)
        
        let insertSQL = "INSERT INTO CentralHVAC_tmp(FloorID, FloorName, isHaveHot) SELECT FloorID, FloorName, BlnHaveHot FROM CentralHVAC;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("CentralHVAC")
        
        _ = SHSQLiteManager.shared.renameTable(
            "CentralHVAC_tmp",
            toName: "CentralHVAC"
        )
        
        return true
    }
    
    /// 安防区域的数据迁移
    func changeCentralSecurity() -> Bool { // as integer
        
        let createSecurity =
            "CREATE TABLE IF NOT EXISTS CentralSecurity_tmp ("  +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"                 +
                "SubnetID INTEGER NOT NULL DEFAULT 1,"              +
                "DeviceID INTEGER NOT NULL DEFAULT 0,"              +
                "ZoneID INTEGER NOT NULL DEFAULT 0,"                +
        "zoneNameOfSecurity TEXT NOT NULL DEFAULT 'zoneName');"
        
        _ = SHSQLiteManager.shared.executeSql(createSecurity)
        
        let insertSQL = "INSERT INTO CentralSecurity_tmp(SubnetID, DeviceID, ZoneID, zoneNameOfSecurity) SELECT SubnetID as integer, DeviceID as integer, ZoneID as integer, ZoneNameOfSecurity FROM Security;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("Security")
        
        _ = SHSQLiteManager.shared.renameTable(
            "CentralSecurity_tmp",
            toName: "CentralSecurity"
        )
        
        return true
    }
    
    /// 中心区域中的light命令
    func changeCentralLightCommands() -> Bool {
        
        let createCommands =
            "CREATE TABLE IF NOT EXISTS CentralLightsCommands_tmp (" +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"                  +
                "FloorID INTEGER NOT NULL DEFAULT 0, "                   +
                "CommandID INTEGER NOT NULL DEFAULT 0, "                 +
                "Remark TEXT NOT NULL DEFAULT 'lightsCommand' ,"         +
                "SubnetID INTEGER NOT NULL DEFAULT 0, "                  +
                "DeviceID INTEGER NOT NULL DEFAULT 0, "                  +
                "CommandTypeID INTEGER NOT NULL DEFAULT 0, "             +
                "Parameter1  INTEGER NOT NULL DEFAULT 0, "               +
                "Parameter2 INTEGER NOT NULL DEFAULT 0,"                 +
        "DelayMillisecondAfterSend INTEGER NOT NULL DEFAULT 0);"
        
        _ = SHSQLiteManager.shared.executeSql(createCommands)
        
        let insertSQL = "INSERT INTO CentralLightsCommands_tmp(FloorID, CommandID, Remark, SubnetID, DeviceID, CommandTypeID, Parameter1, Parameter2, DelayMillisecondAfterSend) SELECT FloorID, CommandID, Remark, SubnetID, DeviceID, CommandTypeID, FirstParameter, ThirdParameter, DelayMillisecondAfterSend FROM CentralLightsCommands;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable(
            "CentralLightsCommands"
        )
        
        _ = SHSQLiteManager.shared.renameTable(
            "CentralLightsCommands_tmp",
            toName: "CentralLightsCommands"
        )
        
        return true
    }
    
    /// 中心区域的light
    func changeCentralLights() -> Bool {
        
        let createLights =
            "CREATE TABLE IF NOT EXISTS CentralLights_tmp (" +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"          +
                "FloorID INTEGER NOT NULL, "                     +
        "FloorName TEXT NOT NULL );"
        
        _ = SHSQLiteManager.shared.executeSql(createLights)
        
        let insertSQL = "INSERT INTO CentralLights_tmp(FloorID, FloorName) SELECT FloorID, FloorName FROM CentralLights;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable(
            "CentralLights"
        )
        
        _ = SHSQLiteManager.shared.renameTable(
            "CentralLights_tmp",
            toName: "CentralLights"
        )
        
        return true
    }
    
    /// 宏按钮
    func changeMacroButtons() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS MacroButtons_tmp (" +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT,"         +
                "MacroID INTEGER NOT NULL, "                    +
                "MacroName TEXT NOT NULL DEFAULT 'MacroName' ," +
        "MacroIconName TEXT NOT NULL DEFAULT 'MacroIconName');"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL = "INSERT INTO MacroButtons_tmp(MacroID, MacroName, MacroIconName) SELECT MacroID, MacroName, 'Romatic' FROM MacroButton;"
        
        _ = SHSQLiteManager.shared.executeSql(insertSQL)
        
        _ = SHSQLiteManager.shared.deleteTable("MacroButton")
        
        _ = SHSQLiteManager.shared.renameTable(
            "MacroButtons_tmp",
            toName: "MacroButtons"
        )
        
        return true
    }
    
    /// 宏命令
    func changeMacroCommands() -> Bool {
        
        let createNewTableSql =
            "CREATE TABLE IF NOT EXISTS MacroButtonCommands_tmp ("  +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT, "                +
                "MacroID INTEGER NOT NULL DEFAULT 0 , "                 +
                "Remark TEXT NOT NULL DEFAULT 'text' , "                +
                "SubnetID INTEGER NOT NULL DEFAULT 0 , "                +
                "DeviceID INTEGER NOT NULL DEFAULT 0 , "                +
                "CommandTypeID INTEGER NOT NULL DEFAULT 0 , "           +
                "FirstParameter INTEGER NOT NULL DEFAULT 0 ,"           +
                "SecondParameter INTEGER NOT NULL DEFAULT 0 ,"          +
                "ThirdParameter INTEGER NOT NULL DEFAULT 0 ,  "         +
        "DelayMillisecondAfterSend INTEGER NOT NULL DEFAULT 0);"
        
        _ = SHSQLiteManager.shared.executeSql(
            createNewTableSql
        )
        
        let insertSQL = "INSERT INTO MacroButtonCommands_tmp(MacroID, Remark, SubnetID, DeviceID, CommandTypeID, FirstParameter, SecondParameter, ThirdParameter, DelayMillisecondAfterSend) SELECT MacroID, Remark, SubnetID, DeviceID, CommandTypeID, FirstParameter, SecondParameter, ThirdParameter, DelayMillisecondAfterSend FROM MacroCommands;"
        
        _ = SHSQLiteManager.shared.executeSql(
            insertSQL
        )
        
        _ = SHSQLiteManager.shared.deleteTable(
            "MacroCommands"
        )
        
        _ = SHSQLiteManager.shared.renameTable(
            "MacroButtonCommands_tmp",
            toName: "MacroButtonCommands"
        )
        
        return true
    }
}
