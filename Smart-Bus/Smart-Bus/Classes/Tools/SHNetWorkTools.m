 

#import "SHNetWorkTools.h"


@protocol SHNetWorkToolsDelegate <NSObject>

@optional
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end

/// 遵守协议
@interface SHNetWorkTools() <SHNetWorkToolsDelegate>

@end

@implementation SHNetWorkTools

+ (instancetype)shareInstacneTools {
    
    static SHNetWorkTools *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SHNetWorkTools alloc] initWithBaseURL:nil];
        
        // 设置响响应类型
        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        // 设置响响应类型
        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    });
    
    return instance;
}


///  封装AFN
- (void)request:(HTTPMethod)httpMethod urlstring:(NSString *)URLstring parameters:(id)parameters finished:(void (^)(id res, NSError* error))finished {
    
    /// 断言
    NSAssert(finished != nil, @"否则不执行");
    NSString *methodStrng = httpMethod == GET ? @"GET": @"POST";
    
    [[self dataTaskWithHTTPMethod:methodStrng URLString:URLstring parameters:parameters uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, id res) {
        finished(res, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finished(nil, error);
    }] resume];
}

@end
