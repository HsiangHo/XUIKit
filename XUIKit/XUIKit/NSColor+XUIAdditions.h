//
//  NSColor+XUIAdditions.h
//  XUIKit
//
//  Created by Jovi on 6/12/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (XUIAdditions)

- (NSColor *)lightenColorByValue:(float)value;
- (NSColor *)darkenColorByValue:(float)value;
- (BOOL)isLightColor;
+ (NSColor *)colorWithHex:(NSString *)strHex alpha:(CGFloat)alpha;          //eg: #FFFFFF

/*
 Before 10.8 CGColor was not supported
 */
@property (nonatomic, readonly) CGColorRef CGColor;

@end
