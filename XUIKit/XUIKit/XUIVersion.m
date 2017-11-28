//
//  XUIVersion.m
//  XUIKit
//
//  Created by Jovi on 11/28/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIVersion.h"

@implementation XUIVersion

+ (NSString *)macOSVersionString{
    SInt32 major, minor, bugfix;
    Gestalt(gestaltSystemVersionMajor, &major);
    Gestalt(gestaltSystemVersionMinor, &minor);
    Gestalt(gestaltSystemVersionBugFix, &bugfix);
    return [NSString stringWithFormat:@"%i.%i.%i",major,minor,bugfix];
}

+ (BOOL)versionEqualTo:(NSString *)version{
    return ([[self macOSVersionString] compare:version options:NSNumericSearch] == NSOrderedSame);
}

+ (BOOL)versionGreaterThan:(NSString *)version{
    return ([[self macOSVersionString] compare:version options:NSNumericSearch] == NSOrderedDescending);
}

+ (BOOL)versionGreaterThanOrEqualTo:(NSString *)version{
    return ([[self macOSVersionString] compare:version options:NSNumericSearch] != NSOrderedAscending);
}

+ (BOOL)versionLessThan:(NSString *)version{
    return ([[self macOSVersionString] compare:version options:NSNumericSearch] == NSOrderedAscending);
}

+ (BOOL)versionLessThanOrEqualTo:(NSString *)version{
    return ([[self macOSVersionString] compare:version options:NSNumericSearch] != NSOrderedDescending);
}

@end
