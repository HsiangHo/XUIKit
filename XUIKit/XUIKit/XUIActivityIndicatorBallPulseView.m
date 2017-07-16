//
//  XUIActivityIndicatorBallPulseView.m
//  XUIKit
//
//  Created by Jovi on 7/14/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIActivityIndicatorBallPulseView.h"
#import <Quartz/Quartz.h>

#define FACTOR_NUM      3

@implementation XUIActivityIndicatorBallPulseView{
    CALayer                         *_parentLayer;
    CGFloat                         _durationTime;
    NSColor                         *_color;
}


-(instancetype)initWithLayer:(CALayer *)layer withColor:(nonnull NSColor *)color withDurationTime:(CGFloat)durationTime{
    if (self = [super init]) {
        _parentLayer = layer;
        _color = color;
        _durationTime = durationTime;
        [self __initializeXUIActivityIndicatorBallPulseView];
    }
    return self;
}

#pragma mark - Private methods

-(void)__initializeXUIActivityIndicatorBallPulseView{
    [self __updateAnimations];
}

-(void)__updateAnimations{
    [_parentLayer setSublayers:nil];
    
    NSRect rctFrame = NSInsetRect([_parentLayer frame], 2.0, 2.0);
    CGFloat gap = MIN(NSWidth(rctFrame), NSHeight(rctFrame))/(FACTOR_NUM + 1);
    CGFloat randius = gap/2 * 0.9;
    NSPoint center = NSMakePoint(MIN(NSWidth(rctFrame), NSHeight(rctFrame))/2, MIN(NSWidth(rctFrame), NSHeight(rctFrame))/2);
    
    for (int i = 0; i < FACTOR_NUM; ++i) {
        NSPoint ptCenter = NSMakePoint(gap * (1 + i), center.y);
        CALayer *layer = [CALayer layer];
        [layer setBackgroundColor: _color.CGColor];
        [layer setOpacity:1.0f];
        [layer setCornerRadius:randius];
        [layer setFrame:NSMakeRect(gap * (1 + i) - randius, ptCenter.y, randius * 2, randius * 2)];
        
        CGFloat beginTime = _durationTime / ((FACTOR_NUM + 1) * 1.0) * (i + 1);
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.keyTimes = @[@(0.1),@(0.5),@(0.9)];
        opacityAnimation.values = @[@(1),@(0.3),@(1)];
        opacityAnimation.duration = _durationTime;
        
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.keyTimes = @[@(0.1),@(0.5),@(0.9)];
        scaleAnimation.values = @[@(1),@(0.3),@(1)];
        scaleAnimation.duration = _durationTime;
        
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        [animation setAnimations:@[opacityAnimation,scaleAnimation]];
        animation.repeatCount = INFINITY;
        animation.beginTime = beginTime;
        animation.duration = _durationTime;
        animation.removedOnCompletion = NO;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [layer addAnimation:animation forKey:@"animation"];
        
        [_parentLayer addSublayer:layer];
    }
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
