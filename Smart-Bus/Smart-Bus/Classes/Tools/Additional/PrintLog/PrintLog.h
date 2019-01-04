//
//  PrintLog.h
 

#ifndef PrintLog_h
#define PrintLog_h


#ifdef DEBUG
    # define printLog(fmt, ...) NSLog((@"\n[文件位置: %s]\n" "[类名与方法: %s]\n" "[行号: %d] \n\n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)

#else

    # define printLog(...)

#endif


#endif /* PrintLog_h */
