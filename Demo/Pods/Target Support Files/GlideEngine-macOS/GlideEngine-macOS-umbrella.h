#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Glide.h"
#import "DDHidDevice.h"
#import "DDHidElement.h"
#import "DDHidEvent.h"
#import "DDHidJoystick.h"
#import "DDHidLib.h"
#import "DDHidQueue.h"
#import "DDHidUsage.h"
#import "DDHidUsageTables.h"
#import "NSDictionary+DDHidExtras.h"
#import "NSXReturnThrowError.h"
#import "Image+macOS.h"

FOUNDATION_EXPORT double GlideEngineVersionNumber;
FOUNDATION_EXPORT const unsigned char GlideEngineVersionString[];

