//
// Created by strelok on 28.11.13.
//


#import <Foundation/Foundation.h>

#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF EXHelpersLogLevel

#import "DDLog.h"

#ifdef DEBUG
    static int const EXHelpersLogLevel = LOG_LEVEL_VERBOSE;
#else
    static int const EXHelpersLogLevel = LOG_LEVEL_WARN;
#endif