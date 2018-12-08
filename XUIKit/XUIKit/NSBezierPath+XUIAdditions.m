//
//  NSBezierPath+XUIAdditions.m
//  XUIKit
//
//  Created by Jovi on 7/5/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "NSBezierPath+XUIAdditions.h"
#define XUI_RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@implementation NSBezierPath (XUIAdditions)

- (CGPathRef)quartzPath{
    NSInteger i, numElements;
    // Need to begin a path here.
    CGPathRef           immutablePath = NULL;
    // Then draw the path elements.
    numElements = [self elementCount];
    if (numElements > 0){
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
//        BOOL                didClosePath = YES;
        for (i = 0; i < numElements; i++){
            switch ([self elementAtIndex:i associatedPoints:points]){
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
//                    didClosePath = NO;
                    break;
                    
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);
//                    didClosePath = NO;
                    break;
                    
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
//                    didClosePath = YES;
                    break;
            }
        }
        // Be sure the path is closed or Quartz may not do valid hit detection.
//        if (!didClosePath){
//            CGPathCloseSubpath(path);
//        }
        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }
    return immutablePath;
}

- (void)addLineToPoint:(NSPoint)point{
    [self lineToPoint:point];
}

- (void)addCurveToPoint:(NSPoint)point controlPoint1:(NSPoint)controlPoint1 controlPoint2:(NSPoint)controlPoint2{
    [self curveToPoint:point controlPoint1:controlPoint1 controlPoint2:controlPoint2];
}

- (void)addQuadCurveToPoint:(NSPoint)point controlPoint:(NSPoint)controlPoint{
    CGPoint QP0 = [self currentPoint];
    CGPoint CP3 = point;
    
    CGPoint CP1 = CGPointMake(
                              //  QP0   +   2   / 3    * (QP1   - QP0  )
                              QP0.x + ((2.0 / 3.0) * (controlPoint.x - QP0.x)),
                              QP0.y + ((2.0 / 3.0) * (controlPoint.y - QP0.y))
                              );
    
    CGPoint CP2 = CGPointMake(
                              //  QP2   +  2   / 3    * (QP1   - QP2)
                              point.x + (2.0 / 3.0) * (controlPoint.x - point.x),
                              point.y + (2.0 / 3.0) * (controlPoint.y - point.y)
                              );
    
    [self curveToPoint:CP3 controlPoint1:CP1 controlPoint2:CP2];
}

- (void)addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    [self appendBezierPathWithArcWithCenter:center radius:radius startAngle:XUI_RADIANS_TO_DEGREES(startAngle) endAngle:XUI_RADIANS_TO_DEGREES(endAngle) clockwise:clockwise];

}

@end
