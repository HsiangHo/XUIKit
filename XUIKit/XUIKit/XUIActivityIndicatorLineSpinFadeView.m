//
//  XUIActivityIndicatorLineSpinFadeView.m
//  XUIKit
//
//  Created by Jovi on 7/14/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIActivityIndicatorLineSpinFadeView.h"
#import "NSBezierPath+XUIAdditions.h"
#import <Quartz/Quartz.h>

#define FACTOR_NUM      8

@implementation XUIActivityIndicatorLineSpinFadeView{
    CALayer                         *_parentLayer;
    CGFloat                         _durationTime;
    NSColor                         *_color;
}


-(instancetype)initWithLayer:(CALayer *)layer withColor:(nonnull NSColor *)color withDurationTime:(CGFloat)durationTime{
    if (self = [super init]) {
        _parentLayer = layer;
        _color = color;
        _durationTime = durationTime;
        [self __initializeXUIActivityIndicatorLineSpinFadeView];
    }
    return self;
}

#pragma mark - Private methods

-(void)__initializeXUIActivityIndicatorLineSpinFadeView{
    [self __updateAnimations];
}

-(void)__updateAnimations{
    [_parentLayer setSublayers:nil];
    
    NSRect rctFrame = NSInsetRect([_parentLayer frame], 2.0, 2.0);
    CGFloat gapFromCenter = MIN(NSWidth(rctFrame), NSHeight(rctFrame))/5;
    CGFloat lineWidth = gapFromCenter / 2.0;
    NSPoint center = NSMakePoint(MIN(NSWidth(rctFrame), NSHeight(rctFrame))/2, MIN(NSWidth(rctFrame), NSHeight(rctFrame))/2);
    CGFloat randius = MIN(NSWidth(rctFrame), NSHeight(rctFrame))/2 - gapFromCenter - lineWidth;
    
    CGFloat angle = 0;
    CGFloat smallAngle = - 2 * M_PI / FACTOR_NUM;
    for (int i = 0; i < FACTOR_NUM; ++i) {
        angle = smallAngle * i;
        NSPoint ptStart = NSMakePoint(center.x + (gapFromCenter * cos(angle)), center.y + (gapFromCenter * sin(angle)));
        NSPoint ptEnd = NSMakePoint(center.x + ((gapFromCenter + randius) * cos(angle)), center.y + ((gapFromCenter + randius) * sin(angle)));
        CAShapeLayer *layer = [CAShapeLayer layer];
        [layer setFillColor:[NSColor clearColor].CGColor];
        [layer setStrokeColor: _color.CGColor];
        [layer setOpacity:1.0f];
        [layer setLineWidth:lineWidth];
        [layer setLineCap:kCALineCapRound];
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:ptStart];
        [path lineToPoint:ptEnd];
        CGPathRef pathRef = [path quartzPath];
        [layer setPath:pathRef];
        CGPathRelease(pathRef);
        
        CGFloat beginTime = _durationTime / (FACTOR_NUM * 1.0) * (i + 1);
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.keyTimes = @[@(0),@(0.5),@(1)];
        animation.values = @[@(1),@(0.3),@(1)];
        animation.duration = _durationTime;
        animation.repeatCount = INFINITY;
        animation.removedOnCompletion = NO;
        animation.beginTime = beginTime;
        [layer addAnimation:animation forKey:@"animation"];
        
        [_parentLayer addSublayer:layer];
    }
}

#pragma mark - Public methods

-(void)setColor:(NSColor *)color{
    if (_color != color) {
        _color = color;
        NSArray *subLayers = [_parentLayer sublayers];
        for (CAShapeLayer *layer in subLayers) {
            [layer setStrokeColor:_color.CGColor];
        }
    }
}

-(void)setDurationTime:(CGFloat)durationTime{
    _durationTime = durationTime;
    [self __updateAnimations];
}

@end
