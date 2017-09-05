//
//  XUIProgressView.m
//  XUIKit
//
//  Created by Jovi on 7/4/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIProgressView.h"
#import "NSColor+XUIAdditions.h"
#import <Quartz/Quartz.h>
#import "NSBezierPath+XUIAdditions.h"
#import "XUIProgressView+Bar.h"
#import "XUIProgressView+Circle.h"

#define DefaultTrackColor           [NSColor colorWithHex:@"#b5b5b5" alpha:1.0]
#define DefaultProgressColor        [NSColor colorWithHex:@"#007ef3" alpha:1.0]

#define INSETS_TO_FRAME(EdgeInsets,Frame)\
NSMakeRect(EdgeInsets.left, EdgeInsets.bottom, NSWidth(Frame) - EdgeInsets.right - EdgeInsets.left, NSHeight(Frame) - EdgeInsets.top - EdgeInsets.bottom)

@implementation XUIProgressView{
    float                           _progress;
    NSColor                         *_progressTintColor;
    NSColor                         *_trackTintColor;
    NSImage                         *_progressImage;
    NSImage                         *_trackImage;
    CAShapeLayer                    *_progressTintLayer;
    CAShapeLayer                    *_trackTintLayer;
    NSEdgeInsets                    _progressEdgeInsets;
    NSEdgeInsets                    _trackEdgeInsets;
    CGFloat                         _progressLineWidth;
    CGFloat                         _trackLineWidth;
    CGFloat                         _progressCornerRadius;
    CGFloat                         _trackCornerRadius;
    XUIProgressViewStyle            _progressViewStyle;
    
    struct{
        unsigned int showTrackImage:1;
        unsigned int showProgressImage:1;
    }_progressViewFlags;
}

#pragma mark - Override Methods

- (instancetype)init{
    if(self = [super init]){
        _progressViewStyle = XUIProgressViewStyleBar;
        [self __initializeXUIProgressView];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        _progressViewStyle = XUIProgressViewStyleBar;
        [self __initializeXUIProgressView];
    }
    return self;
}

-(void)drawRect:(NSRect)dirtyRect{
    [super drawRect:dirtyRect];
    [self __updateLookup];
}

#pragma mark - Private Methods

-(void)__initializeXUIProgressView{
    [self setWantsLayer:YES];
    _progressEdgeInsets = NSEdgeInsetsMake(0, 0, 0, 0);
    _trackEdgeInsets = NSEdgeInsetsMake(0, 0, 0, 0);
    
    _progressCornerRadius = -1;
    _trackCornerRadius = -1;
    _trackLineWidth = 2.f;
    _progressLineWidth = 2.f;
    _trackTintColor = DefaultTrackColor;
    _progressTintColor = DefaultProgressColor;
    _progress = 0;
    _progressViewFlags.showTrackImage = NO;
    _progressViewFlags.showProgressImage = NO;
    _trackTintLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_trackTintLayer];
    
    _progressTintLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_progressTintLayer];
}

-(void)__updateLookup{
    if(XUIProgressViewStyleCircle == _progressViewStyle){
        [self __updateCircleLookup];
    }else{
        [self __updateNormalBarLookup];
    }
}

-(void)__setProgressViewStyle:(XUIProgressViewStyle)buttonType{
    _progressViewStyle = buttonType;
}

#pragma mark - Public Methods

+ (id)progressViewWithType:(XUIProgressViewStyle)progressViewType{
    XUIProgressView *progressView = [[XUIProgressView alloc] init];
    [progressView __setProgressViewStyle:progressViewType];
    return progressView;
}

+ (id)progressView{
    XUIProgressView *progressView = [[XUIProgressView alloc] init];
    [progressView __setProgressViewStyle:XUIProgressViewStyleBar];
    return progressView;
}

-(void)setTrackTintColor:(NSColor *)trackTintColor{
    _progressViewFlags.showTrackImage = NO;
    _trackTintColor = trackTintColor;
    [self setNeedsDisplay:YES];
}

-(void)setProgressTintColor:(NSColor *)progressTintColor{
    _progressViewFlags.showProgressImage = NO;
    _progressTintColor = progressTintColor;
    [self setNeedsDisplay:YES];
}

-(void)setTrackImage:(NSImage *)trackImage{
    _progressViewFlags.showTrackImage = YES;
    _trackImage = trackImage;
    [self setNeedsDisplay:YES];
}

-(void)setProgressImage:(NSImage *)progressImage{
    _progressViewFlags.showProgressImage = YES;
    _progressImage = progressImage;
    [self setNeedsDisplay:YES];
}

-(void)setProgress:(float)progress{
    _progress = (progress >= 1.0) ? 1.0 : progress;
    [self setNeedsDisplay:YES];
}

- (void)setProgress:(float)progress animated:(BOOL)animated{
    _progress = (progress >= 1.0) ? 1.0 : progress;
    if (animated) {
        [self setNeedsDisplay:YES];
    }else{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self __updateLookup];
        [CATransaction commit];
    }
}

-(void)setProgressEdgeInsets:(NSEdgeInsets)progressEdgeInsets{
    _progressEdgeInsets = progressEdgeInsets;
    [self setNeedsDisplay:YES];
}

-(NSEdgeInsets)progressEdgeInsets{
    return _progressEdgeInsets;
}

-(void)setTrackEdgeInsets:(NSEdgeInsets)trackEdgeInsets{
    _trackEdgeInsets = trackEdgeInsets;
    [self setNeedsDisplay:YES];
}

-(NSEdgeInsets)trackEdgeInsets{
    return _trackEdgeInsets;
}

-(void)setProgressCornerRadius:(CGFloat)progressCornerRadius{
    _progressCornerRadius = progressCornerRadius;
    [self setNeedsDisplay:YES];
}

-(CGFloat)progressCornerRadius{
    return _progressCornerRadius;
}

-(void)setTrackCornerRadius:(CGFloat)trackCornerRadius{
    _trackCornerRadius = trackCornerRadius;
    [self setNeedsDisplay:YES];
}

-(CGFloat)trackCornerRadius{
    return _trackCornerRadius;
}

-(void)setProgressLineWidth:(CGFloat)progressLineWidth{
    _progressLineWidth = progressLineWidth;
    [self setNeedsDisplay:YES];
}

-(CGFloat)progressLineWidth{
    return _progressLineWidth;
}

-(void)setTrackLineWidth:(CGFloat)trackLineWidth{
    _trackLineWidth = trackLineWidth;
    [self setNeedsDisplay:YES];
}

-(CGFloat)trackLineWidth{
    return _trackLineWidth;
}

@end

#pragma mark - Category

@implementation XUIProgressView (Bar)

-(void)__updateNormalBarLookup{
    NSColor *trackTintColor = _trackTintColor;
    NSColor *progressTintColor = _progressTintColor;
    if(_progressViewFlags.showTrackImage && nil != _trackImage){
        trackTintColor = [NSColor colorWithPatternImage:_trackImage];
    }
    if (_progressViewFlags.showProgressImage && nil != _progressImage) {
        progressTintColor = [NSColor colorWithPatternImage:_progressImage];
    }
    
    NSRect rctTrack = INSETS_TO_FRAME(_trackEdgeInsets, [self bounds]);
    rctTrack.size.height = _trackLineWidth;
    [_trackTintLayer setFrame:rctTrack];
    [_trackTintLayer setBackgroundColor:(nil == trackTintColor) ? DefaultTrackColor.CGColor :  trackTintColor.CGColor];
    [_trackTintLayer setCornerRadius:_trackCornerRadius < 0 ? 0: _trackCornerRadius];
    
    NSRect rctProgress = INSETS_TO_FRAME(_progressEdgeInsets, [self bounds]);
    rctProgress.size.height = _progressLineWidth;
    rctProgress.size.width *= (_progress > 1.0 ? 1.0 : _progress);
    [_progressTintLayer setFrame:rctProgress];
    [_progressTintLayer setBackgroundColor:(nil == _progressTintColor) ? DefaultProgressColor.CGColor : progressTintColor.CGColor];
    [_progressTintLayer setCornerRadius:_progressCornerRadius < 0 ? 0: _progressCornerRadius];
}

@end

@implementation XUIProgressView (Circle)

-(void)__updateCircleLookup{
    NSColor *trackTintColor = _trackTintColor;
    NSColor *progressTintColor = _progressTintColor;
    if(_progressViewFlags.showTrackImage && nil != _trackImage){
        trackTintColor = [NSColor colorWithPatternImage:_trackImage];
    }
    if (_progressViewFlags.showProgressImage && nil != _progressImage) {
        progressTintColor = [NSColor colorWithPatternImage:_progressImage];
    }
    NSRect rctFrame = [self bounds];
    if (NSWidth(rctFrame) > NSHeight(rctFrame)) {
        rctFrame.size.width = NSHeight(rctFrame);
    }else{
        rctFrame.size.height = NSWidth(rctFrame);
    }
    NSPoint center = NSMakePoint(NSMidX(rctFrame), NSMidY(rctFrame));
    
    NSRect rctTrack = rctFrame;
    CGFloat defaultRadius = (NSWidth(rctTrack) - _trackLineWidth)* 0.5f;
    CGFloat radius = _trackCornerRadius < 0 ? defaultRadius: (_trackCornerRadius > defaultRadius ? defaultRadius : _trackCornerRadius);
    [_trackTintLayer setFillColor:[NSColor clearColor].CGColor];
    [_trackTintLayer setStrokeColor: (nil == trackTintColor) ? DefaultTrackColor.CGColor :  trackTintColor.CGColor];
    [_trackTintLayer setOpacity:1.0f];
    [_trackTintLayer setLineWidth:_trackLineWidth];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path appendBezierPathWithArcWithCenter:center radius:radius startAngle:90 endAngle:-270 clockwise:YES];
    CGPathRef pathRef = [path quartzPath];
    _trackTintLayer.path = pathRef;
    CGPathRelease(pathRef);
    
    NSRect rctProgress = rctFrame;
    CGFloat defaultRadius2 = (NSWidth(rctProgress) - _progressLineWidth)* 0.5f;
    CGFloat radius2 = _progressCornerRadius < 0 ? defaultRadius2: (_progressCornerRadius > defaultRadius2 ? defaultRadius2 : _progressCornerRadius);
    [_progressTintLayer setFillColor:[NSColor clearColor].CGColor];
    [_progressTintLayer setStrokeColor: (nil == progressTintColor) ? DefaultProgressColor.CGColor :  progressTintColor.CGColor];
    [_progressTintLayer setOpacity:1.0f];
    [_progressTintLayer setLineWidth:_progressLineWidth];
    [_progressTintLayer setLineCap:kCALineCapRound];
    NSBezierPath *path2 = [NSBezierPath bezierPath];
    [path2 appendBezierPathWithArcWithCenter:center radius:radius2 startAngle:90 endAngle:-270 clockwise:YES];
    CGPathRef pathRef2 = [path2 quartzPath];
    _progressTintLayer.path = pathRef2;
    CGPathRelease(pathRef2);
    _progressTintLayer.strokeStart = 0;
    _progressTintLayer.strokeEnd = _progress;
}

@end
