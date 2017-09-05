//
//  XUIActivityIndicatorCircleLineRotateView.m
//  XUIKit
//
//  Created by Jovi on 7/10/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIActivityIndicatorCircleLineRotateView.h"
#import <Quartz/Quartz.h>
#import "NSBezierPath+XUIAdditions.h"

@implementation XUIActivityIndicatorCircleLineRotateView{
    CALayer                         *_parentLayer;
    CAShapeLayer                    *_layer;
    CGFloat                         _durationTime;
    NSColor                         *_color;
}

-(instancetype)initWithLayer:(CALayer *)layer withColor:(nonnull NSColor *)color withDurationTime:(CGFloat)durationTime{
    if (self = [super init]) {
        _parentLayer = layer;
        _color = color;
        _durationTime = durationTime;
        [self __initializeXUIActivityIndicatorCircleLineRotateView];
    }
    return self;
}

#pragma mark - Private methods

-(void)__initializeXUIActivityIndicatorCircleLineRotateView{
    _layer = [CAShapeLayer layer];
    NSRect rctProgress = _parentLayer.bounds;
    [_parentLayer addSublayer:_layer];
    [_layer setFrame:rctProgress];
    NSPoint center = NSMakePoint(NSMidX(rctProgress), NSMidY(rctProgress));
    rctProgress = NSInsetRect(rctProgress, 1.5f, 1.5f);
    CGFloat radius = NSHeight(rctProgress) > NSWidth(rctProgress) ? NSWidth(rctProgress) / 2.0 : NSHeight(rctProgress) / 2.0;
    CGFloat startAngle = 90;
    CGFloat endAngle = -270;
    [_layer setFillColor:[NSColor clearColor].CGColor];
    [_layer setStrokeColor: _color.CGColor];
    [_layer setOpacity:1.0f];
    [_layer setLineWidth:3.0f];
    [_layer setLineCap:kCALineCapRound];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path appendBezierPathWithArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    CGPathRef pathRef = [path quartzPath];
    _layer.path = pathRef;
    CGPathRelease(pathRef);
    
    [self __updateAnimations];
}

-(void)__updateAnimations{
    [_layer addAnimation:[self __strokeAnimation] forKey:@"strokeLineAnimation"];
    [_layer addAnimation:[self __rotationAnimation] forKey:@"rotationAnimation"];
}

-(CAAnimation *)__strokeAnimation{
    CABasicAnimation *headAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    headAnimation.beginTime = _durationTime/3.0;
    headAnimation.fromValue = @(0);
    headAnimation.toValue = @(1);
    headAnimation.duration = _durationTime/1.5;
    headAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tailAnimation.fromValue = @(0);
    tailAnimation.toValue = @(1);
    tailAnimation.duration = _durationTime/1.5;
    tailAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = _durationTime;
    groupAnimation.repeatCount = INFINITY;
    groupAnimation.animations = [NSArray arrayWithObjects:headAnimation,tailAnimation,nil];
    groupAnimation.removedOnCompletion = NO;
    return groupAnimation;
}

-(CAAnimation *)__rotationAnimation{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(-2 * M_PI);
    rotationAnimation.duration = _durationTime;
    rotationAnimation.repeatCount = INFINITY;
    rotationAnimation.removedOnCompletion = NO;
    return rotationAnimation;

}

#pragma mark - Public methods

-(void)setColor:(NSColor *)color{
    _color = color;
    [_layer setStrokeColor:_color.CGColor];
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
