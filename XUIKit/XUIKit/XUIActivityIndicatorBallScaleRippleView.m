//
//  XUIActivityIndicatorBallScaleRippleView.m
//  XUIKit
//
//  Created by Jovi on 8/28/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIActivityIndicatorBallScaleRippleView.h"
#import <Quartz/Quartz.h>

@implementation XUIActivityIndicatorBallScaleRippleView{
    CALayer                         *_parentLayer;
    CGFloat                         _durationTime;
    NSColor                         *_color;
}

-(instancetype)initWithLayer:(CALayer *)layer withColor:(nonnull NSColor *)color withDurationTime:(CGFloat)durationTime{
    if (self = [super init]) {
        _parentLayer = layer;
        _color = color;
        _durationTime = durationTime;
        [self __initializeXUIActivityIndicatorBallScaleRippleView];
    }
    return self;
}

#pragma mark - Private methods

-(void)__initializeXUIActivityIndicatorBallScaleRippleView{
    [self __updateAnimations];
}

-(void)__updateAnimations{
    [_parentLayer setSublayers:nil];
    
    NSRect rctFrame = NSInsetRect([_parentLayer frame], 2.0, 2.0);
    
    CAMediaTimingFunction *timeFunction = [CAMediaTimingFunction functionWithControlPoints:0.2 : 0.68: 0.18: 1.08];
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.keyTimes = @[@(0), @(0.6), @(1)];
    scaleAnimation.timingFunction = timeFunction;
    scaleAnimation.values = @[@(0.6), @(0.8), @(1)];
    scaleAnimation.duration = _durationTime;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.keyTimes = @[@(0), @(0.3), @(0.6) ,@(0.9)];
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation.values = @[@(0.3), @(0.2), @(0.1) ,@(0)];
    opacityAnimation.duration = _durationTime;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    [animation setAnimations:@[scaleAnimation,opacityAnimation]];
    animation.repeatCount = INFINITY;
    animation.duration = _durationTime;
    animation.removedOnCompletion = NO;
    
    CALayer *layer = [CALayer layer];
    [layer setBorderColor: _color.CGColor];
    [layer setBorderWidth:2.0f];
    [layer setOpacity:0.0f];
    [layer setCornerRadius:MIN(NSWidth(rctFrame),NSHeight(rctFrame)) / 2];
    [layer setFrame:rctFrame];
    [layer addAnimation:animation forKey:@"animation"];
    [_parentLayer addSublayer:layer];
}

#pragma mark - Public methods

-(void)setColor:(NSColor *)color{
    if (_color != color) {
        _color = color;
        NSArray *subLayers = [_parentLayer sublayers];
        for (CALayer *layer in subLayers) {
            [layer setBorderColor:_color.CGColor];
        }
    }
}

-(void)setDurationTime:(CGFloat)durationTime{
    _durationTime = durationTime;
    [self __updateAnimations];
}

@end
