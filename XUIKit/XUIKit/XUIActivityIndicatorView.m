//
//  XUIActivityIndicatorView.m
//  XUIKit
//
//  Created by Jovi on 7/5/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIActivityIndicatorView.h"
#import "XUIActivityIndicatorViewProtocol.h"
#import "XUIActivityIndicatorCircleLineRotateView.h"
#import "XUIActivityIndicatorBallRotateChaseView.h"
#import "XUIActivityIndicatorLineSpinFadeView.h"
#import "XUIActivityIndicatorBallSpinFadeView.h"
#import "XUIActivityIndicatorBallPulseView.h"
#import "XUIActivityIndicatorLineScaleView.h"
#import "XUIActivityIndicatorBallScaleRippleView.h"
#import "XUIActivityIndicatorBallScaleRippleMultipleView.h"

@implementation XUIActivityIndicatorView{
    XUIActivityIndicatorViewStyle           _activityIndicatorViewStyle;
    BOOL                                    _hidesWhenStopped;
    CGFloat                                 _durationTime;
    NSColor                                 *_color;
    BOOL                                    _animating;
    id<XUIActivityIndicatorViewProtocol>    _currentStyleObj;
}

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXUIActivityIndicatorView];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self __initializeXUIActivityIndicatorView];
    }
    return self;
}

-(instancetype)initWithActivityIndicatorStyle:(XUIActivityIndicatorViewStyle)style{
    if (self = [super init]) {
        [self __initializeXUIActivityIndicatorView];
        _activityIndicatorViewStyle = style;
    }
    return self;
}

#pragma mark - Private methods

-(void)__initializeXUIActivityIndicatorView{
    [self setWantsLayer:YES];
    _hidesWhenStopped = YES;
    _durationTime = 1.5f;
    _animating = NO;
    _color = [NSColor redColor];
    _activityIndicatorViewStyle = XUIActivityIndicatorViewStyleCircleLineRotate;
}

-(id<XUIActivityIndicatorViewProtocol>)__currentStyleObject{
    if(nil == _currentStyleObj){
        switch (_activityIndicatorViewStyle) {
            case XUIActivityIndicatorViewStyleCircleLineRotate:
                _currentStyleObj = [[XUIActivityIndicatorCircleLineRotateView alloc] initWithLayer:self.layer withColor:_color withDurationTime:_durationTime];
                break;
                
            case XUIActivityIndicatorViewStyleBallRotateChase:
                _currentStyleObj = [[XUIActivityIndicatorBallRotateChaseView alloc] initWithLayer:self.layer withColor:_color withDurationTime:_durationTime];
                break;
                
            case XUIActivityIndicatorViewStyleLineSpinFade:
                _currentStyleObj = [[XUIActivityIndicatorLineSpinFadeView alloc] initWithLayer:self.layer withColor:_color withDurationTime:_durationTime];
                break;
              
            case XUIActivityIndicatorViewStyleBallSpinFade:
                _currentStyleObj = [[XUIActivityIndicatorBallSpinFadeView alloc] initWithLayer:self.layer withColor:_color withDurationTime:_durationTime];
                break;
                
            case XUIActivityIndicatorViewStyleBallPulse:
                _currentStyleObj = [[XUIActivityIndicatorBallPulseView alloc] initWithLayer:self.layer withColor:_color withDurationTime:_durationTime];
                break;
               
            case XUIActivityIndicatorViewStyleLineScale:
                _currentStyleObj = [[XUIActivityIndicatorLineScaleView alloc] initWithLayer:self.layer withColor:_color withDurationTime:_durationTime];
                break;
                
            case XUIActivityIndicatorViewStyleBallScaleRipple:
                _currentStyleObj = [[XUIActivityIndicatorBallScaleRippleView alloc] initWithLayer:self.layer withColor:_color withDurationTime:_durationTime];
                break;
                
            case XUIActivityIndicatorViewStyleBallScaleRippleMultiple:
                _currentStyleObj = [[XUIActivityIndicatorBallScaleRippleMultipleView alloc] initWithLayer:self.layer withColor:_color withDurationTime:_durationTime];
                break;
                
            default:
                break;
        }
    }
    return _currentStyleObj;
}

-(void)__pauseLayer{
    CFTimeInterval pausedTime = [_layer convertTime:CACurrentMediaTime() fromLayer:nil];
    _layer.speed = 0.0;
    _layer.timeOffset = pausedTime;
}

-(void)__resumeLayer{
    CFTimeInterval pausedTime = [_layer timeOffset];
    _layer.speed = 1.0;
    _layer.timeOffset = 0.0;
    _layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [_layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    _layer.beginTime = timeSincePause;
}

#pragma mark - Public methods

- (void)startAnimating{
    if(nil != [self __currentStyleObject]){
        [self __resumeLayer];
        [self setHidden:NO];
        _animating = YES;
    }
}

- (void)stopAnimating{
    if(nil != [self __currentStyleObject]){
        _animating = NO;
        [self __pauseLayer];
        [self setHidden:_hidesWhenStopped];
    }
}

-(void)setColor:(NSColor *)color{
    _color = color == nil ? [NSColor clearColor] : color;
    [[self __currentStyleObject] setColor:_color];
}

-(void)setDurationTime:(CGFloat)durationTime{
    _durationTime = durationTime;
    [[self __currentStyleObject] setDurationTime:durationTime];
}

@end
