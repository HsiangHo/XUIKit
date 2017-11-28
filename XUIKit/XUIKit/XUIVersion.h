//
//  XUIVersion.h
//  XUIKit
//
//  Created by Jovi on 11/28/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XUIVersion : NSObject

+ (NSString *)macOSVersionString;
+ (BOOL)versionEqualTo:(NSString *)version;
+ (BOOL)versionGreaterThan:(NSString *)version;
+ (BOOL)versionGreaterThanOrEqualTo:(NSString *)version;
+ (BOOL)versionLessThan:(NSString *)version;
+ (BOOL)versionLessThanOrEqualTo:(NSString *)version;

@end
