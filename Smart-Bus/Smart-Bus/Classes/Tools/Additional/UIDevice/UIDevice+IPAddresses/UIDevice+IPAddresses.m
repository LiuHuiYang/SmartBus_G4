
//  UIDevice+IPAddresses.m

#import "UIDevice+IPAddresses.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#include <netdb.h>

// ip字典信息中出现的的key
NSString *iOS_CELLULAR = @"pdp_ip0";

NSString *iOS_WIFI = @"en0";

NSString *iOS_VPN = @"utun0";

NSString *IP_ADDR_IPV4 = @"ipv4";

NSString *IP_ADDR_IPV6 = @"ipv6";

@implementation UIDevice (IPAddresses)


/**
 判断当前网络环境是iPV4 还是iPV6

 @return YES - iPV6 NO - iPV4
 */
+ (BOOL)isIPV6 {
    
    // 获得所有的ip地址
    NSDictionary *addresses = [self getIPAddresses];
    
    // 初始化查询字典
    NSArray *searchKeyArrayForIPV6 = @[
        [iOS_VPN stringByAppendingPathComponent:IP_ADDR_IPV6],
        [iOS_VPN stringByAppendingPathComponent:IP_ADDR_IPV4],
        [iOS_WIFI stringByAppendingPathComponent:IP_ADDR_IPV6],
        [iOS_WIFI stringByAppendingPathComponent:IP_ADDR_IPV4],
        [iOS_CELLULAR stringByAppendingPathComponent:IP_ADDR_IPV6],
        [iOS_CELLULAR stringByAppendingPathComponent:IP_ADDR_IPV4]
    ];
    
  
    __block BOOL isIPV6 = NO;
    
    [searchKeyArrayForIPV6 enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         
         if ([key rangeOfString:@"ipv6"].length > 0  && ![[NSString stringWithFormat:@"%@",addresses[key]] hasPrefix:@"(null)"] ) {
             
             if ( ![addresses[key] hasPrefix:@"fe80"]) {
                 
                 isIPV6 = YES;
             }
         }
         
     } ];
    
    return isIPV6;
}


/**
 获得iPV4或者iPv6的地址
 
 @param isIPV6 是否为iPV6 (YES - iPV6, NO - iPV4)
 @return ip地址字符串
 */
+ (NSString *)getIPAddress:(BOOL)isIPV6 {
    
//    printLog(@"当前网络环境: %@", isIPV6 ? @"IPV6" : @"IPV4");
    
    // 初始化查询字典的key
    NSArray *searchKeyArray = isIPV6 ?
    @[
      [iOS_VPN stringByAppendingPathComponent:IP_ADDR_IPV6],
      [iOS_VPN stringByAppendingPathComponent:IP_ADDR_IPV4],
      [iOS_WIFI stringByAppendingPathComponent:IP_ADDR_IPV6],
      [iOS_WIFI stringByAppendingPathComponent:IP_ADDR_IPV4],
      [iOS_CELLULAR stringByAppendingPathComponent:IP_ADDR_IPV6],
      [iOS_CELLULAR stringByAppendingPathComponent:IP_ADDR_IPV4]
      
    ] :
    
    @[
    
      [iOS_VPN stringByAppendingPathComponent:IP_ADDR_IPV4],
      [iOS_VPN stringByAppendingPathComponent:IP_ADDR_IPV6],
      [iOS_WIFI stringByAppendingPathComponent:IP_ADDR_IPV4],
      [iOS_WIFI stringByAppendingPathComponent:IP_ADDR_IPV6],
      [iOS_CELLULAR stringByAppendingPathComponent:IP_ADDR_IPV4],
      [iOS_CELLULAR stringByAppendingPathComponent:IP_ADDR_IPV6]
      
    ];
    
    // 获得所有的ip地址
    NSDictionary *addresses = [self getIPAddresses];
    
    // 结果ip字符串
    __block NSString *address;
    
    // 遍历所有的结果
    [searchKeyArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         
         // 取出字典中的每一个结果
         address = addresses[key];
         
         // 筛选出可用的IP地址格式
         if([self isValidatIP:address]) {
             
             *stop = YES;
         }
         
     } ];
    
    // 返回最终的结果
    return address ? address : @"255.255.255.255";
}



/**
 ip地址是否可用
 
 @param ipAddress 指定的ip地址的字符串
 @return YES - 可用，NO - 不可用
 */
+ (BOOL)isValidatIP:(NSString *)ipAddress {
    
    // 地址无效
    if (ipAddress.length == 0) {
        return NO;
    }
    
    // 检验使用的正则表达式的字符串
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    
    // 转换成正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            
            // 匹配结果 -> 返回值
            [ipAddress substringWithRange:resultRange];
            
            return YES;
        }
    }
    
    return NO;
}

/**
 判断字符串是非法的IP地址或是域名
 
 @param address 地址字符串
 @return YES - 非法 / NO 合法
 */
+ (BOOL)isIllegalDomainNameOrIPAddress:(NSString*)address {
    
    // 1.判断是否有点
    NSRegularExpression *pointRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[.]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    // 获得符包含点的字节数
    NSUInteger pointMatchCount = [pointRegularExpression numberOfMatchesInString:address options:NSMatchingReportProgress range:NSMakeRange(0, address.length)];
    
    // 2.判断是数字的条件
    NSRegularExpression *numRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    // 获得符合数字的字节数
    NSUInteger numberMatchCount = [numRegularExpression numberOfMatchesInString:address options:NSMatchingReportProgress range:NSMakeRange(0, address.length)];
    
    // 3.判断是大小写英文字母
    NSRegularExpression *letterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    // 获得符合字母的字节数
    NSUInteger letterMatchCount = [letterRegularExpression numberOfMatchesInString:address options:NSMatchingReportProgress range:NSMakeRange(0, address.length)];
    
    // 判断它是否有效
    if (!pointMatchCount) {
        return YES;  // 没有点肯定是非法地址
    }
    
    
    // 非法数据
    struct hostent* phot ;
    
    @try {
        
        phot = gethostbyname([address UTF8String]);
        
    } @catch (NSException * e) {
        
        return YES;
    }
    
    if (!phot) {
        
        return YES;  // 非法数据
    }
    
    // 全是数字 + .
    if (pointMatchCount + numberMatchCount == address.length) {
        
        return [[address componentsSeparatedByString:@"."] count] != 4;
    }
    
    // 有其它非法字符
    if (pointMatchCount + numberMatchCount + letterMatchCount < address.length) {
        
        return YES;
    }
    
    return NO;
}

/**
 获取所有相关IP信息
 
 @return 信息字典
 */
+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPV4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPV6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


/**
 获得当前wifi的名称
 
 @return 当前手机连接的wifi名称
 */
+ (NSString *)getWifiName {
    
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    
    return wifiName;
}


/**
 域名字符串转换成ip字符串
 
 @param hostName 域名
 @return ip地址字符串
 */
+ (NSString *)convertedIPAddress:(NSString *)hostName {
    
    //NSString to char*
    const char *webSite = [hostName cStringUsingEncoding:NSASCIIStringEncoding];
    
    // Get host entry info for given host
    struct hostent *remoteHostEnt = gethostbyname(webSite);
    
    // Get address info from host entry
    struct in_addr *remoteInAddr = (struct in_addr *) remoteHostEnt->h_addr_list[0];
    
    // Convert numeric addr to ASCII string
    char *sRemoteInAddr = inet_ntoa(*remoteInAddr);
    
    //char* to NSString
    NSString *ip = [[NSString alloc] initWithCString:sRemoteInAddr
                                            encoding:NSASCIIStringEncoding];
    //    NSLog(@"IP地址: %@", ip);
    return ip;
}


/**
 设备的地址数组
 
 @param ipAddress 设备的IP地址字符串
 @return 字符串对应的数组
 */
+ (NSArray *)deviceIPAddressArray:(NSString *)ipAddress{
    
    return [ipAddress componentsSeparatedByString:@"."];
}

/**
 将主机域名转换成字符串
 
 @param hostName 主机地址
 @return IP地址字符串
 */
+ (NSString*)getIPAddressByHostName:(NSString*)hostName {
    
    const char* szname = [hostName UTF8String];
    struct hostent* phot ;

    @try {

        phot = gethostbyname(szname);

    } @catch (NSException * e) {

        return nil;
    }

    struct in_addr ip_addr;

    if (!phot) {

        return nil;  // 非法数据
    }

    memcpy(&ip_addr, phot -> h_addr_list[0], 4);
    ///h_addr_list[0]里4个字节,每个字节8位，此处为一个数组，一个域名对应多个ip地址或者本地时一个机器有多个网卡

    char ip[20] = { 0 };

    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));

    NSString* iPAddress = [NSString stringWithUTF8String:ip];
    
    return iPAddress;
}


@end
