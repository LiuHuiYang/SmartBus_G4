

#import "Regular.h"

@implementation Regular

/**
 对字符串进行正则表达式检测
 
 @param expression 需要检验的字符串
 @param regularString 正则表达式字符串
 @return 返回检测结果 NSTextCheckingResult
 */
+ (NSTextCheckingResult *)matchExpression:(NSString *)expression
                            regularString:(NSString *)regularString {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularString options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *result = [regex firstMatchInString:expression options:NSRegularExpressionAnchorsMatchLines | NSRegularExpressionCaseInsensitive range:NSMakeRange(0, expression.length)];
    
    return result;
}

@end
