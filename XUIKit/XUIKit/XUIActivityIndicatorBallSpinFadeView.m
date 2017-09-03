//
//  XUIActivityIndicatorBallSpinFadeView.m
//  XUIKit
//
//  Created by Jovi on 7/14/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIActivityIndicatorBallSpinFadeView.h"
#import <Quartz/Quartz.h>

#define FACTOR_NUM      8

@implementation XUIActivityIndicatorBallSpinFadeView{
    CALayer                         *_parentLayer;
    CGFloat                         _durationTime;
    NSColor                         *_color;
}


-(instancetype)initWithLayer:(CALayer *)layer withColor:(nonnull NSColor *)color withDurationTime:(CGFloat)durationTime{
    if (self = [super init]) {
        _parentLayer = layer;
        _color = color;
        _durationTime = durationTime;
        [self __initializeXUIActivityIndicatorBallSpinFadeView];
    }
    return self;
}

#pragma mark - Private methods

-(void)__initializeXUIActivityIndicatorBallSpinFadeView{
    [self __updateAnimations];
}

-(void)__updateAnimations{
    [_parentLayer setSublayers:nil];
    
    NSRect rctFrame = NSInsetRect([_parentLayer frame], 2.0, 2.0);
    CGFloat gapFromCenter = MIN(NSWidth(rctFrame), NSHeight(rctFrame))/3;
    CGFloat randius = (MIN(NSWidth(rctFrame), NSHeight(rctFrame))/2 - gapFromCenter) * 0.6;
    NSPoint center = NSMakePoint(MIN(NSWidth(rctFrame), NSHeight(rctFrame))/2, MIN(NSWidth(rctFrame), NSHeight(rctFrame))/2);
    
    CGFloat angle = 0;
    CGFloat smallAngle = - 2 * M_PI / FACTOR_NUM;
    for (int i = 0; i < FACTOR_NUM; ++i) {
        angle = smallAngle * i;
        NSPoint ptCenter = NSMakePoint(center.x + (gapFromCenter * cos(angle)), center.y + (gapFromCenter * sin(angle)));
        CALayer *layer = [CALayer layer];
        [layer setBackgroundColor: _color.CGColor];
        [layer setOpacity:1.0f];
        [layer setCornerRadius:randius];
        [layer setFrame:NSMakeRect(ptCenter.x - randius, ptCenter.y - randius, randius * 2, randius * 2)];
        
        CGFloat beginTime = _durationTime / ((FACTOR_NUM + 1) * 1.0) * (i + 1);
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.keyTimes = @[@(0),@(0.5),@(1)];
        opacityAnimation.values = @[@(1),@(0.3),@(1)];
        opacityAnimation.duration = _durationTime;
        
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.keyTimes = @[@(0),@(0.5),@(1)];
        scaleAnimation.values = @[@(1),@(0.3),@(1)];
        scaleAnimation.duration = _durationTime;
        
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        [animation setAnimations:@[opacityAnimation,scaleAnimation]];
        animation.repeatCount = INFINITY;
        animation.beginTime = beginTime;
        animation.duration = _durationTime;
        animation.removedOnCompletion = NO;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
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

-(NSColor *)color{
    return _color;
}

-(void)setDurationTime:(CGFloat)durationTime{
    _durationTime = durationTime;
    [self __updateAnimations];
}

-(CGFloat)durationTime{
    return _durationTime;
}

@end
