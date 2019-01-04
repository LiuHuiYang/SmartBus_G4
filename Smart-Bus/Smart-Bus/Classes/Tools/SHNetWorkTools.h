//
//  SHNetWorkTools.h
//   
//
//  Created by Mark Liu on 2017/7/11.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>

///  网络请求枚举类型
typedef NS_ENUM(NSUInteger, HTTPMethod) {
    GET,
    POST
};

@interface SHNetWorkTools : AFHTTPSessionManager

///  创建网络管理工具
+ (instancetype)shareInstacneTools;

- (void)request:(HTTPMethod)httpMethod urlstring:(NSString *)URLstring parameters:(id)parameters finished:(void (^)(id res, NSError* error))finished;

@end
