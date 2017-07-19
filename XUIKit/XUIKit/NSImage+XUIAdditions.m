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
static NSImage *hidenSecureTextImage = nil;

@implementation NSImage (XUIAdditions)

+(NSImage *)XUI_clearButtonImageDown{
    if (nil == clearButtonImageDown){
        clearButtonImageDown = [NSImage __drawClearButton:[NSColor colorWithCalibratedRed: 0 green: 0.42 blue: 0.898 alpha: 1]];
    }
    return clearButtonImageDown;
}

+(NSImage *)XUI_clearButtonImageNormal{
    if (nil == clearButtonImageNormal){
        clearButtonImageNormal = [NSImage __drawClearButton:[NSColor colorWithCalibratedRed: 0.8 green: 0.8 blue: 0.8 alpha: 1]];
    }
    return clearButtonImageNormal;
}

+(NSImage *)XUI_showSecureTextImage{
    return nil;
}

+(NSImage *)XUI_hidenSecureTextImage{
    return nil;
}

#pragma mark - Private Methods

+(NSImage *)__drawClearButton:(NSColor *)backgroundColor{
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
