#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIView+Border.h"
#import "XKAlertUtil.h"
#import "XKConsoleBoard.h"
#import "XKCrashRecord.h"
#import "XKDeviceDataLibrery.h"

FOUNDATION_EXPORT double XKConsoleBoardVersionNumber;
FOUNDATION_EXPORT const unsigned char XKConsoleBoardVersionString[];

