

#import "FileTools.h"

@implementation FileTools

/**
 获得当前应用的名称
 */
+ (NSString *)appName {
    
    return [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"] ? [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"] :[NSBundle mainBundle].infoDictionary[@"CFBundleName"];
}


#pragma mark - 应用的缓存

/**
 获得缓存大小的字符串
 
 @param totalSize 获取的大小
 @return 对应的字符串
 */
+ (NSString *)getFileSizeString:(NSInteger)totalSize {
    
    NSString *sizeString = @"";
    
    if (totalSize > 1024 * 1024) {  // 1024
        
        CGFloat size = totalSize / 1024.0 / 1024.0;
        sizeString = [NSString stringWithFormat:@"%.2fMB", size];
    
    } else if (totalSize > 1024) {
        
        CGFloat size = totalSize / 1024.0;
        sizeString = [NSString stringWithFormat:@"%.2fKB", size];
   
    } else {
        
        sizeString = [NSString stringWithFormat:@"%ldB", (long)totalSize];
    }
    
    return sizeString;
}



/**
 获得文件夹中内容的大小
 
 @param directoryPath 需要获取的文件夹(不能是文件)
 @param completion 获取的回调
 */
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger totalFileSize))completion {

    // 获得文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    /********* 判断参数必须是一个路径(合法) *********/
    
    // 是否是一个路径
    BOOL isDirectory;
    
    // 是否是一个文件夹
    BOOL isExist = [fileManager fileExistsAtPath:directoryPath isDirectory: &isDirectory];
    
    // 如果非法
    if (!isDirectory || !isExist) {
        
        // 抛出异常提示调用方
        NSException *exception = [NSException exceptionWithName:@"路径参数错误" reason:@"参数必须是一个已【存在】的【文件夹】夹路径" userInfo:nil];
        [exception raise];
    }
    
    // 考虑到文件很大，计算时间较长，所以开启异步子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 获取文件夹下中的所有子路径，【包括】子路径中的子路径
        NSArray *subPaths = [fileManager subpathsAtPath:directoryPath];
        
        // 文件大小
        NSInteger totalFileSize = 0;
        
        // 计算总大小
        for (NSString *subPath in subPaths) {
            
            // 获得文件的全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            // 如果是隐藏文件不要计算
            if ([filePath containsString:@".DS"]) {
                continue;
            }
            
            // 如果是一个文件夹或者不存在的文件不要计算
            
            // 是否为文件夹
            BOOL isDirectory;
            // 文件是否存在
            BOOL isExist = [fileManager fileExistsAtPath: filePath isDirectory: &isDirectory];
            
            if (!isExist || isDirectory) {
                continue;
            }
            
            // 获得文件属性
            NSDictionary *fileAttr = [fileManager attributesOfItemAtPath:filePath error:nil];
            
            // 获得文件的大小并计算总大小
            totalFileSize += [fileAttr fileSize];
        }
        
        // 完成回调
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                // 执行回调
                completion(totalFileSize);
            }
        });
    });

}


/**
 删除文件夹中所有的内容(不包含隐藏文件 .DS, 也不含有子目录)
 
 @param directoryPath 需要获取的文件夹(不能是文件)
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath {

    // 获得文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    /********* 判断参数必须是一个路径(合法) *********/
    
    // 是否是一个路径
    BOOL isDirectory;
    
    // 是否是一个文件夹
    BOOL isExist = [fileManager fileExistsAtPath:directoryPath isDirectory: &isDirectory];
    
    // 如果非法
    if (!isDirectory || !isExist) {
        
        // 抛出异常提示调用方法
        NSException *exception = [NSException exceptionWithName:@"路径参数错误" reason:@"参数必须是一个已【存在】的【文件夹】夹路径" userInfo:nil];
        [exception raise];
    }
    
    // 获取应用沙盒中的cache文件夹下的所有文件，【不包括】子路径中的子路径
    NSArray *subPaths = [fileManager contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subPaths) {
        
        // 拼接成全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        // 删除文件
        [fileManager removeItemAtPath:filePath error:nil];
    }
}


// MARK: - 沙盒的路径

/**
 应用的主目录
 
 @return 应用的主目录
 */
+ (NSString *)homePath{
    return NSHomeDirectory();
}

/**
 应用的路径
 
 @return 应用的路径
 */
+ (NSString *)appPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}


/**
 沙盒 document文档 的路径
 
 @return 沙盒 document文档 的路径
 */
+ (NSString *)documentPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}


/**
 沙盒Preference的路径
 
 @return 沙盒Preference的路径
 */
+ (NSString *)libPreferencePath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}


/**
 偏好设置
 */
+ (NSUserDefaults *)defaults {
    
    return [NSUserDefaults standardUserDefaults];
}

/**
 沙盒Cache的路径
 
 @return 沙盒Cache的路径
 */
+ (NSString *)libCachePath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}


/**
 临时文件夹
 
 @return 沙盒tmp的路径
 */
+ (NSString *)tmpPath {

    return NSTemporaryDirectory();
}

@end
