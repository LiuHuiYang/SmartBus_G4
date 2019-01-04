 

#import <Foundation/Foundation.h>

@interface Regular : NSObject

/**
 对字符串进行正则表达式检测
 
 @param expression 需要检验的字符串
 @param regularString 正则表达式字符串
 @return 返回检测结果 NSTextCheckingResult
 */
+ (NSTextCheckingResult *)matchExpression:(NSString *)expression
                            regularString:(NSString *)regularString;

@end
