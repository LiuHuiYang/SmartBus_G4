/**
    沙盒操作相关方法
 */

#import <UIKit/UIKit.h>
 

@interface FileTools : NSObject

/**
 获得当前应用的名称
 */
+ (NSString *)appName;


/**
 获得文件夹中内容的大小

 @param directoryPath 需要获取的文件夹(不能是文件)
 @param completion 获取的回调
 */
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger totalFileSize))completion;


/**
 删除文件夹中所有的内容(不包含隐藏文件 .DS)

 @param directoryPath 需要获取的文件夹(不能是文件)
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;


/**
 获得缓存大小的字符串
 
 @param totalSize 获取的大小
 @return 对应的字符串
 */
+ (NSString *)getFileSizeString:(NSInteger)totalSize;


/**
 应用的主目录
 
 @return 应用的主目录
 */
+ (NSString *)homePath;

/**
 应用的路径
 
 @return 应用的路径
 */
+ (NSString *)appPath;

/**
 沙盒 document文档 的路径
 
 @return 沙盒 document文档 的路径
 */
+ (NSString *)documentPath;

/**
 偏好设置 -- 开发中使用这种方式
 */
+ (NSUserDefaults *)defaults;

/**
 沙盒Preference的路径 
 
 @return 沙盒Preference的路径
 */
+ (NSString *)libPreferencePath;


/**
 沙盒Cache的路径
 
 @return 沙盒Cache的路径
 */
+ (NSString *)libCachePath;


/**
 临时文件夹
 
 @return 沙盒tmp路径
 */
+ (NSString *)tmpPath;

@end
