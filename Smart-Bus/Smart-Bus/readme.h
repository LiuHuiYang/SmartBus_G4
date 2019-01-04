/*
 
 find . -name "*.m" -or -name "*.h" -or -name "*.xib" -or -name "*.swift" |xargs grep -v "^$"|wc -l
 
 
 
 相关事项

 
 1.安防密码默认是 8888 可以修改密码
    但如果用户忘了密码，使用root密码也是可以打开的
 
 2.区域设置增加密码进行密码才能设置
    和安防一样也是默认8888 否则也使用root密码打开
 
 ===================== 语音功能测试部分 ===================
 
 1> 注册百度云账号
 2> 创建一个应用
 获得需要的几个参数 APP_ID API_KEY  SECRET_KEY
 在指定包名的时候, 就是你要集成的哪个App的bundleID
 
 3> 测试Demo是否可用
 1.先要要从官网下载Demo 按要求填入 上一步获得的三个参数
 2.进行运行测试
 
 4> 创建自己的应用项目
 
 5> 开始集成 (需要的相关资源都在官方中的Demo文件中找)
 
 SDK文件说明地址:
 
 https://ai.baidu.com/sdk#asr Demo
 https://ai.baidu.com/docs#/ASR-iOS-SDK/f880a5cc 集成说明
 
 
 1> 在项目中准备好三个参数(为了区分,统一加上BD前缀)
 BD_APP_ID
 BD_API_KEY
 BD_SECRET_KEY
 
 2> 添加Framework
 
 libc++.tbd
 libz.1.2.5.tbd
 AudioToolbox
 CFNetwork
 CoreLocation
 CoreTelephony
 SystemConfiguration
 GLKit
 libsqlite3.tdb (这个也要加上)
 
 UIKit
 libstdc++.6.9.0.tbd
 libiconv.2.4.0.tbd
 libetts_devices_simulator.a(稍后再加, 不加也不影响,新版本已支持模拟器)
 
 
 3> 添加静态库 和 头文件
 
 BDSClientHeaders
 BDSClientLib
 
 两个文件夹以 以"create groups"方式添加到工程目录下即可
 
 4> 添加所需资源
 5.1 将开发包中BDSClientResource/ASR/BDSClientEASRResources目录以"create groups"方式添加到工程目录下即可
 
 5.2 将开发包中BDSClientResource/ASR/BDSClientResources目录以“create folder references”方式添加到工程的资源Group中
 
 5> 添加头文件
 
 // 在线识别功能
 #import "BDSEventManager.h"
 #import "BDSASRDefines.h"
 #import "BDSASRParameters.h"
 
 
 6.开始功能测试
 
 注意: 这一部分在 代码中有注释
 
 1> 测试在线语音功能
 
 2> 测试语音合成
  
 */
