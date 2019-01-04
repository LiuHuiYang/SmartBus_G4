/*
    单例模式的宏文件
    使用：
        1.直接将当前文件拖入工程
        2.在需要使用类的声明部分，写上 SingletonInterface(类名)
        3.在需要使用类的实现部分，写上 SingletonImplementation(类名)
 */

/*******声明部分***********/

/**
 类的单例方法名 的 宏定义

 @param className 需要实现单例的类
 @return 类的单例方法 的 宏声明
 */
#define SingletonInterface(className)      + (instancetype)share##className;

/*******实现部分***********/
// 是否支持aRC
#if __has_feature(objc_arc)

#define SingletonImplementation(className) \
static id instance; \
- (id)copyWithZone:(NSZone *)zone { \
return instance;  \
} \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [super allocWithZone:zone]; \
}); \
return instance; \
} \
+ (instancetype)share##className { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[self alloc] init]; \
}); \
return instance; \
}  // 最后一行不要 \

#else

#define SingletonImplementation(className) \
static id instance; \
- (id)copyWithZone:(NSZone *)zone { \
    return instance;  \
} \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        instance = [super allocWithZone:zone]; \
    }); \
    return instance; \
} \
+ (instancetype)share##className { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        instance = [[self alloc] init]; \
    }); \
    return instance; \
}  \
- (oneway void)release { \
    } \
    - (instancetype)retain { \
    return instance; \
    } \
    - (instancetype)autorelease { \
    return instance; \
} \
- (NSUInteger)retainCount { \
    return ULONG_MAX; \
}

#endif
