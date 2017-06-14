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
/*
 Init NSColor with hex string eg: #0x4F5DA2
 */
+ (NSColor *)colorWithHex:(NSString *)strHex alpha:(CGFloat)alpha;

/*
 Converts a Quartz color reference to its NSColor equivalent.
 */
+ (NSColor *)colorWithCGColor:(CGColorRef)color;

/*
 10.7 CGColor supported
 */
@property (nonatomic, readonly) CGColorRef CGColor;

@end
