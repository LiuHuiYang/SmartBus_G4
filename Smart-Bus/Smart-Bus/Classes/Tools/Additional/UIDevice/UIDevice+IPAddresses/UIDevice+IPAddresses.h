//
//  UIDevice+IPAddresses.h


#import <UIKit/UIKit.h>

@interface UIDevice (IPAddresses)

/**
 判断当前网络环境是iPV4 还是iPV6
 
 @return YES - iPV6 NO - iPV4
 */
+ (BOOL)isIPV6;


/**
 获得iPV4或者iPv6的地址
 
 @param isIPV6 是否为iPV6 (YES - iPV6, NO - iPV4)
 @return ip地址字符串
 */
+ (NSString *)getIPAddress:(BOOL)isIPV6;

/**
 获得当前wifi的名称
 
 @return 当前手机连接的wifi名称
 */
+ (NSString *)getWifiName;

/**
 域名字符串转换成ip字符串
 
 @param hostName 域名
 @return ip地址字符串
 */
+ (NSString *)convertedIPAddress:(NSString *)hostName;


/**
 设备的地址数组

 @param ipAddress 设备的IP地址字符串
 @return 字符串对应的数组
 */
+ (NSArray *)deviceIPAddressArray:(NSString *)ipAddress;

/**
 将主机域名转换成字符串
 
 @param hostName 主机地址
 @return IP地址字符串
 */
+ (NSString*)getIPAddressByHostName:(NSString*)hostName;


/**
 ip地址是否可用
 
 @param ipAddress 指定的ip地址的字符串
 @return YES - 可用，NO - 不可用
 */
+ (BOOL)isValidatIP:(NSString *)ipAddress;

/**
 判断字符串是非法的IP地址或是域名
 
 @param address 地址字符串
 @return YES - 非法 / NO 合法
 */
+ (BOOL)isIllegalDomainNameOrIPAddress:(NSString*)address;

@end
