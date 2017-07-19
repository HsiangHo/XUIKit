//
//  NSImage+XUIAdditions.m
//  XUIKit
//
//  Created by Jovi on 7/19/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "NSImage+XUIAdditions.h"

static NSImage *clearButtonImageNormal = nil;
static NSImage *clearButtonImageDown = nil;
static NSImage *showSecureTextImage = nil;
static NSImage *hideSecureTextImage = nil;

@implementation NSImage (XUIAdditions)

+(NSImage *)XUI_clearButtonImageDown{
    if (nil == clearButtonImageDown){
        clearButtonImageDown = [NSImage __drawClearImage:[NSColor colorWithCalibratedRed: 0 green: 0.42 blue: 0.898 alpha: 1]];
    }
    return clearButtonImageDown;
}

+(NSImage *)XUI_clearButtonImageNormal{
    if (nil == clearButtonImageNormal){
        clearButtonImageNormal = [NSImage __drawClearImage:[NSColor colorWithCalibratedRed: 0.8 green: 0.8 blue: 0.8 alpha: 1]];
    }
    return clearButtonImageNormal;
}

+(NSImage *)XUI_showSecureTextImage{
    if (nil == showSecureTextImage){
        showSecureTextImage =  [self __drawEyeImage:[NSColor blackColor] withOn:YES];
    }
    return showSecureTextImage;
}

+(NSImage *)XUI_hidenSecureTextImage{
    if (nil == hideSecureTextImage){
        hideSecureTextImage =  [self __drawEyeImage:[NSColor blackColor] withOn:NO];
    }
    return hideSecureTextImage;
}

#pragma mark - Private Methods

+(NSImage *)__drawEyeImage:(NSColor *)backgroundColor withOn:(BOOL)isOn{
    NSImage *image = [[NSImage alloc] initWithSize: NSMakeSize(24, 18)];
    NSRect frame = NSMakeRect(0, 0, image.size.width, image.size.height);
    [image lockFocus];

    NSColor* color = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 1];
    
    NSBezierPath* bezierPath = [NSBezierPath bezierPath];
    [bezierPath moveToPoint: NSMakePoint(NSMinX(frame) + 0.5, NSMaxY(frame) - 9.5)];
    [bezierPath curveToPoint: NSMakePoint(NSMinX(frame) + 23.5, NSMaxY(frame) - 9.5) controlPoint1: NSMakePoint(NSMinX(frame) + 12.5, NSMaxY(frame) + 8.5) controlPoint2: NSMakePoint(NSMinX(frame) + 23.5, NSMaxY(frame) - 9.5)];
    [backgroundColor setFill];
    [bezierPath fill];
    [backgroundColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    NSBezierPath* bezier2Path = [NSBezierPath bezierPath];
    [backgroundColor setStroke];
    bezier2Path.lineWidth = 1;
    [bezier2Path stroke];
    
    NSBezierPath* bezier3Path = [NSBezierPath bezierPath];
    [bezier3Path moveToPoint: NSMakePoint(NSMinX(frame) + 0.5, NSMaxY(frame) - 8.5)];
    [bezier3Path curveToPoint: NSMakePoint(NSMinX(frame) + 23.5, NSMaxY(frame) - 8.5) controlPoint1: NSMakePoint(NSMinX(frame) + 11.5, NSMaxY(frame) - 26.5) controlPoint2: NSMakePoint(NSMinX(frame) + 23.5, NSMaxY(frame) - 8.5)];
    [backgroundColor setFill];
    [bezier3Path fill];
    [backgroundColor setStroke];
    bezier3Path.lineWidth = 1;
    [bezier3Path stroke];
    
    NSBezierPath* ovalPath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(NSMinX(frame) + 7, NSMinY(frame) + frame.size.height - 14, 10, 10)];
    [color setFill];
    [ovalPath fill];
    
    NSBezierPath* oval2Path = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(NSMinX(frame) + 9, NSMinY(frame) + frame.size.height - 12, 6, 6)];
    [backgroundColor setFill];
    [oval2Path fill];
    
    if(!isOn){
        NSBezierPath* bezier5Path = [NSBezierPath bezierPath];
        [bezier5Path moveToPoint: NSMakePoint(2, 19)];
        [bezier5Path curveToPoint: NSMakePoint(NSMinX(frame) + 23, NSMaxY(frame) - 17) controlPoint1: NSMakePoint(23, 1) controlPoint2: NSMakePoint(NSMinX(frame) + 23, NSMaxY(frame) - 17)];
        [color setStroke];
        bezier5Path.lineWidth = 2;
        [bezier5Path stroke];
        
        NSBezierPath* bezier4Path = [NSBezierPath bezierPath];
        [bezier4Path moveToPoint: NSMakePoint(NSMinX(frame) + 1.5, NSMaxY(frame) - 0.5)];
        [bezier4Path curveToPoint: NSMakePoint(NSMinX(frame) + 21.5, NSMaxY(frame) - 17.5) controlPoint1: NSMakePoint(NSMinX(frame) + 21.5, NSMaxY(frame) - 17.5) controlPoint2: NSMakePoint(NSMinX(frame) + 21.5, NSMaxY(frame) - 17.5)];
        [backgroundColor setStroke];
        bezier4Path.lineWidth = 2;
        [bezier4Path stroke];
    }
    
    [image unlockFocus];
    return image;
}

+(NSImage *)__drawClearImage:(NSColor *)backgroundColor{
    NSImage *image = [[NSImage alloc] initWithSize: NSMakeSize(16, 16)];
    
    [image lockFocus];
    
    // Color Declarations
    NSColor* color = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 1];
    
    // Oval Drawing
    NSBezierPath* ovalPath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(0, 0, 16, 16)];
    [backgroundColor setFill];
    [ovalPath fill];
    
    // Bezier Drawing
    NSBezierPath* bezierPath = [NSBezierPath bezierPath];
    [bezierPath moveToPoint: NSMakePoint(11.5, 11.5)];
    [bezierPath lineToPoint: NSMakePoint(4.5, 4.5)];
    [color setStroke];
    bezierPath.lineWidth = 2;
    [bezierPath stroke];
    
    // Bezier 2 Drawing
    NSBezierPath* bezier2Path = [NSBezierPath bezierPath];
    [bezier2Path moveToPoint: NSMakePoint(4.5, 11.5)];
    [bezier2Path lineToPoint: NSMakePoint(11.5, 4.5)];
    [color setStroke];
    bezier2Path.lineWidth = 2;
    [bezier2Path stroke];
    
    [image unlockFocus];
    return image;
}

@end
