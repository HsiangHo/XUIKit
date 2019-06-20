//
//  NSBezierPath+XUIAdditions.h
//  XUIKit
//
//  Created by Jovi on 7/5/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (XUIAdditions)

// The caller should release with CGPathRelease.
- (CGPathRef)quartzPath;
- (void)addLineToPoint:(NSPoint)point;
- (void)addCurveToPoint:(NSPoint)point controlPoint1:(NSPoint)controlPoint1 controlPoint2:(NSPoint)controlPoint2;
- (void)addQuadCurveToPoint:(NSPoint)point controlPoint:(NSPoint)controlPoint;
- (void)addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

@end
