//
//  XUIActivityIndicatorBallRotateChaseView.m
//  XUIKit
//
//  Created by Jovi on 7/12/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIActivityIndicatorBallRotateChaseView.h"
#import <Quartz/Quartz.h>

#define FACTOR_COUNT        5

@implementation XUIActivityIndicatorBallRotateChaseView{
    CALayer                         *_parentLayer;
    CGFloat                         _durationTime;
    NSColor                         *_color;
}


-(instancetype)initWithLayer:(CALayer *)layer withColor:(nonnull NSColor *)color withDurationTime:(CGFloat)durationTime{
    if (self = [super init]) {
        _parentLayer = layer;
        _color = color;
        _durationTime = durationTime;
        [self __initializeXUIActivityIndicatorBallRotateChaseView];
    }
    return self;
}

#pragma mark - Private methods

-(void)__initializeXUIActivityIndicatorBallRotateChaseView{
    [self __updateAnimations];
}

-(void)__updateAnimations{
    [_parentLayer setSublayers:nil];
    
    NSRect rctFrame = NSInsetRect([_parentLayer frame], 2.0, 2.0);
    CGFloat circleSize = NSWidth(rctFrame) / FACTOR_COUNT;
    CGFloat cornerRadius = (MIN(NSWidth(rctFrame), NSHeight(rctFrame)) - circleSize) / 2;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    NSPoint center = NSMakePoint(MIN(NSWidth(rctFrame), NSHeight(rctFrame))/2, MIN(NSWidth(rctFrame), NSHeight(rctFrame))/2);
    CGPathAddArc(path, &transform, center.x, center.y, cornerRadius, 0, 2*pi, YES);
    
    for (int i = 0; i < FACTOR_COUNT; ++i) {
        CGFloat rate = i * 1.0 / FACTOR_COUNT;
        CALayer *circleLayer = [CALayer layer];
        [circleLayer setCornerRadius:circleSize / 2];
        [circleLayer setFrame:NSMakeRect(center.x, center.y, circleSize, circleSize)];
        [circleLayer setBackgroundColor:_color.CGColor];
        
        CAKeyframeAnimation * arcAnimation = [CAKeyframeAnimation animationWithKeyPath: @"position"];
        arcAnimation.duration = _durationTime;
        arcAnimation.autoreverses = NO;
        arcAnimation.repeatCount = INFINITY;
        [arcAnimation setCalculationMode:kCAAnimationPaced];
        [arcAnimation setPath: path];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = _durationTime;
        animation.autoreverses = NO;
        animation.repeatCount = INFINITY;
        animation.fromValue = [NSNumber numberWithFloat:1 - rate];
        animation.toValue = [NSNumber numberWithFloat:0.2 + rate];
        
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.duration = _durationTime;
        groupAnimation.repeatCount = INFINITY;
        groupAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :0.15 + rate :0.25 :1.0];
        groupAnimation.animations = [NSArray arrayWithObjects:arcAnimation,animation,nil];
        
        [circleLayer addAnimation:groupAnimation forKey:@"animation"];
        [_parentLayer addSublayer:circleLayer];
    }
    
    CFRelease(path);
}

#pragma mark - Public methods

-(void)setColor:(NSColor *)color{
    if (_color != color) {
        _color = color;
        NSArray *subLayers = [_parentLayer sublayers];
        for (CALayer *layer in subLayers) {
            [layer setBackgroundColor:_color.CGColor];
        }
    }
}

-(void)setDurationTime:(CGFloat)durationTime{
    _durationTime = durationTime;
    [self __updateAnimations];
}

@end
